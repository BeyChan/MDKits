//
//  MDError.swift
//  MDKit
//
//  Created by  MarvinChan on 2019/10/14.
//

import Foundation

public struct MDError: Error {
    public let code:Int
    public let massage:String
    public init(code:Int, massage:String) {
        self.code = code
        self.massage = massage.isEmpty ? (MDError.massageFor(code) ?? "") : massage
    }
}

public extension MDError {
    static func massageFor(_ code:Int) -> String? {
        switch code {
        case -88888:
            return "服务器错误"
        case 404, 502:
            return "服务器错误"
        case -1:
            return "未知错误"
        case -999:
            return "网络请求取消"
        case -1000:
            return "URL错误"
        case -1001:
            return "请求超时"
        case -1003:
            return "无法找到服务器"
        case -1004:
            return "无法连接服务器"
        case -1005:
            return "网络连接丢失"
        case -1008:
            return "资源不可用"
        case -1011:
            return "服务器响应错误"
        case -1015, -1016:
            return "解码失败"
        case -1017:
            return "无法解析"
        case -1100:
            return "资源不存在"
        case -1101:
            return "资源目录错误"
        case -1102:
            return "没有权限读取资源"
        default:
            return "服务器响应错误"
        }
    }
}

public enum MDOtherError: Error {
       case networkNotReachable
       case writeJSONCacheFailed
       case readJSONCacheFailed
       case writeDownloadResumeDataFailed
       case invalidKeyPath
       case emptyKeyPath
       case invalidJSON
       case invalidURL(url: MDURLConvertible)
}

extension MDOtherError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .networkNotReachable:
            return "无网络"
        case .writeJSONCacheFailed:
            return "写入JSON数据失败"
        case .readJSONCacheFailed:
            return "读取JSON缓存失败"
        case .writeDownloadResumeDataFailed:
            return "写入下载的ResumeData失败"
        case .invalidKeyPath:
            return "无效的keyPath"
        case .emptyKeyPath:
            return "空的keyPath"
        case .invalidJSON:
            return "无效的json"
        case .invalidURL(let url):
            return "无效的URL: \(url)"
        }
    }
}

