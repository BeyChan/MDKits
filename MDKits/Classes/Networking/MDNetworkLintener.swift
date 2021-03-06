//
//  MDNetworkLintener.swift
//  MDKit
//
//  Created by  MarvinChan on 2019/10/12.
//

import Foundation
import Alamofire

/// 网络类型枚举
///
/// - unknown: 未知
/// - notReachable: 没有网络
/// - wifi: wifi信号
/// - mobile: 手机信号
public enum MDNetworkType {
    case unknown
    case notReachable
    case wifi
    case mobile
}

// MARK: -网络类型枚举描述
extension MDNetworkType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .unknown: return "未知"
        case .notReachable: return "没有网络"
        case .wifi: return "wifi网络"
        case .mobile: return "手机网络"
        }
    }
}

// MARK: - 获取网络状态
extension MDNetworkType {
    
    /// 获取网络状态
    ///
    /// - Parameter reachabilityStatus: Alamofire.NetworkReachabilityManager中的网络状态
    /// - Returns: 自己定义的网络状态
    fileprivate static func getType(by reachabilityStatus: NetworkReachabilityManager.NetworkReachabilityStatus) -> MDNetworkType {
        let status: MDNetworkType
        switch reachabilityStatus {
        case .unknown:
            status = .unknown
        case .notReachable:
            status = .notReachable
        case .reachable(NetworkReachabilityManager.ConnectionType.ethernetOrWiFi):
            status = .wifi
        case .reachable(NetworkReachabilityManager.ConnectionType.wwan):
            status = .mobile
        }
        return status
    }
}

/// 网络监听器
public class MDNetworkListener {
    
    //MARK:- 属性设置
    
    /// 监听管理器
    private let manager = NetworkReachabilityManager()!
    
    /// 是否在监听
    private var isListening = false
    
    /// 单例
    public static let shared = MDNetworkListener()
    private init() {}
    
    //MARK:- 监听状态
    
    /// 是否有网络
    public var isReachable: Bool {
        return manager.isReachable
    }
    
    /// 是否是手机信号
    public var isMobile: Bool {
        return manager.isReachableOnWWAN
    }
    
    /// 是否是wifi信号
    public var isWifi: Bool {
        return manager.isReachableOnEthernetOrWiFi
    }
    
    //MARK:- 开始监听
    
    /// 开始监听
    public func startListen() {
        if isListening { return }
        isListening = manager.startListening()
    }
    
    //MARK:- 结束监听
    
    /// 结束监听
    public func stopListen() {
        if !isListening { return }
        manager.stopListening()
        isListening = false
    }
    
    //MARK:- 获取监听的网络状态
    
    /// 获取监听的网络状态
    public var  status: MDNetworkType {
        let reachabilityStatus = manager.networkReachabilityStatus
        return MDNetworkType.getType(by: reachabilityStatus)
    }
    
    //MARK:- 刷新网络状态
    
    /// 刷新网络状态
    ///
    /// - Returns: 网络状态
    @discardableResult
    public func refreshStatus() -> MDNetworkType {
        let reachabilityStatus = manager.networkReachabilityStatus
        let newStatus = MDNetworkType.getType(by: reachabilityStatus)
        return newStatus
    }
    
    //MARK:- 闭包形式的状态回调
    
    /// 获取网络状态,一旦改变就会进行回调,可以说是全局的监听
    ///
    /// - Parameter callback: 回调
    public func listenStatus(_ callback: @escaping (MDNetworkType) -> ()) {
        manager.listener = { status in
            let status = MDNetworkType.getType(by: status)
            callback(status)
        }
        startListen()
    }
}
