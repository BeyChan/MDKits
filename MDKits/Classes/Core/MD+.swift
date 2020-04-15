//
//  MD+.swift
//  MDKit
//
//  Created by  MarvinChan on 2019/10/14.
//

import UIKit

public struct MD {
    public static var window:UIWindow? {
        return UIApplication.shared.delegate?.window ?? UIApplication.shared.keyWindow ?? nil
    }
    
    public static var screenSize:CGSize {
        return UIScreen.main.bounds.size
    }
    
    public static var screenW:CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    public static var screenH:CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    public static var sysNavigationH:CGFloat {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.statusBarFrame.size.height + (MD.visibleVC?.navigationController?.navigationBar.frame.size.height ?? 44)
        } else {
            return 20.0 + (MD.visibleVC?.navigationController?.navigationBar.frame.size.height ?? 44)
        }
    }
    
    public static var sysTabBarH:CGFloat {
        return MD.visibleVC?.tabBarController?.tabBar.frame.size.height ?? 59
    }
    
    public static var sectionMinH:CGFloat {
        return 0.001
    }
    
    public static var sysVersion:String {
        return UIDevice.current.systemVersion
    }
    
    public static var isSimulator:Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
    
    public static var notice:NotificationCenter {
        return NotificationCenter.default
    }
    
    public static var userde:UserDefaults {
        return UserDefaults.standard
    }
    
    public static var timestampNow:TimeInterval {
        return Date().timeIntervalSince1970
    }
    
    public static var appVersion:String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
    public static var appId:String {
        return Bundle.main.bundleIdentifier ?? ""
    }
    
    public static func atoz(_ capitalized:Bool = false) -> [String] {
        let az = (97...122).compactMap{String(UnicodeScalar($0))}
        return capitalized ? az.compactMap{$0.capitalized} : az
    }
    
    /// app 安装日期
    public static var appCreatDate:Date? {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            return nil
        }
        guard let dates = try? FileManager.default.attributesOfItem(atPath: url.path) else {
            return nil
        }
        return dates[FileAttributeKey.creationDate] as? Date ?? nil
    }
    /// app 更新日期
    public static var appUpdateDate:Date? {
        guard let info = Bundle.main.path(forResource: "Info", ofType: "plist") else {
            return nil
        }
        let url = URL(fileURLWithPath: info, isDirectory: true)
        let path = url.deletingLastPathComponent().relativePath
        guard let dates = try? FileManager.default.attributesOfItem(atPath: path) else {
            return nil
        }
        return dates[FileAttributeKey.modificationDate] as? Date ?? nil
    }
    
    
    public static var visibleVC:UIViewController? {
        func visibleVC(_ vc: UIViewController? = nil) -> UIViewController? {
            if let nv = vc as? UINavigationController
            {
                return visibleVC(nv.visibleViewController)
            } else if let tb = vc as? UITabBarController,
                let select = tb.selectedViewController
            {
                return visibleVC(select)
            } else if let presented = vc?.presentedViewController {
                return visibleVC(presented)
            }
            return vc
        }
        let vc = MD.window?.rootViewController
        return visibleVC(vc)
    }
    
    public static var topVC:UIViewController? {
        func topVC(_ vc: UIViewController? = nil) -> UIViewController? {
            let vc = vc ?? MD.window?.rootViewController
            if let nv = vc as? UINavigationController,
                !nv.viewControllers.isEmpty
            {
                return topVC(nv.topViewController)
            }
            if let tb = vc as? UITabBarController,
                let select = tb.selectedViewController
            {
                return topVC(select)
            }
            if let _ = vc?.presentedViewController, let nvc = MD.visibleVC?.navigationController {
                
                return topVC(nvc)
            }
            return vc
        }
        let vc = MD.window?.rootViewController
        return topVC(vc)
    }
    
    
    public static func iOSAdjustmentBehavior() {
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
            UICollectionView.appearance().contentInsetAdjustmentBehavior = .never
            /// 高度自适应会失效，需要高度自适应的tableView 需重新设置
            UITableView.appearance().contentInsetAdjustmentBehavior = .never
            UITableView.appearance().estimatedRowHeight = 0
            UITableView.appearance().estimatedSectionHeaderHeight = 0
            UITableView.appearance().estimatedSectionFooterHeight = 0
        } else {
            
        }
    }
    
    public static func present(_ vc:UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        MD.visibleVC?.present(vc, animated: animated, completion: completion)
    }
    
    public static func dismiss(_ animated: Bool = true, completion: (() -> Void)? = nil) {
        MD.visibleVC?.dismiss(animated: animated, completion: nil)
    }
    
    public static func push(_ vc:UIViewController, animated: Bool = true) {
        if let nvc = MD.visibleVC?.navigationController {
            vc.hidesBottomBarWhenPushed = true
            nvc.pushViewController(vc, animated: animated)
        }else{
            MD.visibleVC?.present(vc, animated: animated, completion: nil)
        }
    }
    
    public static func pop(_ animated: Bool = true) {
        if let nvc = MD.visibleVC?.navigationController, let _ = nvc.popViewController(animated: animated) {
        }else{
            MD.visibleVC?.dismiss(animated: animated, completion: nil)
        }
    }
}
