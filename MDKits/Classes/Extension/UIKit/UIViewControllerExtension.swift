//
//  UIViewControllerExtension.swift
//  MDKit
//
//  Created by  MarvinChan on 2019/10/14.
//

import UIKit

// MARK: - UIViewController
extension MDKit where Base: UIViewController {
    
    /// tabbarHeight高度
    public var tabbarHeight: CGFloat {
        return base.tabBarController?.tabBar.bounds.height ?? 0
    }
    
    /// 能否回退
    public var canback: Bool {
        return (base.navigationController?.viewControllers.count ?? 0) > 1
    }
    
    /// 当前是控制器是否是被modal出来
    public var isByPresented: Bool {
        guard base.presentingViewController == nil else { return false }
        return true
    }
    
    /// 前进至指定控制器
    ///
    /// - Parameters:
    ///   - vc: 指定控制器
    ///   - isRemove: 前进后是否移除当前控制器
    ///   - animated: 是否显示动画
    public func push(vc: UIViewController?, isRemove: Bool = false, animated: Bool = true) {
        guard let vc = vc else { return }
        switch base {
        case let nav as UINavigationController:
            nav.pushViewController(vc, animated: animated)
        default:
            base.navigationController?.pushViewController(vc, animated: animated)
            if isRemove {
                guard let vcs = base.navigationController?.viewControllers else{ return }
                guard let flags = vcs.firstIndex(of: base.self) else { return }
                base.navigationController?.viewControllers.remove(at: flags)
            }
        }
    }
    
    /// modal 指定控制器
    ///
    /// - Parameters:
    ///   - vc: 指定控制器
    ///   - animated: 是否显示动画
    ///   - completion: 完成后事件
    func present(vc: UIViewController?, animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let vc = vc else { return }
        base.present(vc, animated: animated, completion: completion)
    }
    
    /// 简单弹窗
    /// - Parameter title: 标题
    func presentAlert(title:String){
        let title = title
        let alertView = UIAlertController.init(title: "提示", message: title, preferredStyle: .alert)
        let okAction = UIAlertAction.init(title:"确定", style: .default) { okAction in }
        alertView.addAction(okAction)
        self.present(vc: alertView)
    }
    
    /// 后退一层控制器
    ///
    /// - Parameter animated: 是否显示动画
    /// - Returns: vc
    @discardableResult
    public func pop(animated: Bool) -> UIViewController? {
        switch base {
        case let nav as UINavigationController:
            return nav.popViewController(animated: animated)
        default:
            return base.navigationController?.popViewController(animated: animated)
        }
    }
    
    /// 后退至指定控制器
    ///
    /// - Parameters:
    ///   - vc: 指定控制器
    ///   - animated: 是否显示动画
    /// - Returns: vcs
    @discardableResult
    public func pop(vc: UIViewController, animated: Bool) -> [UIViewController]? {
        switch base {
        case let nav as UINavigationController:
            return nav.popToViewController(vc, animated: animated)
        default:
            return base.navigationController?.popToViewController(vc, animated: animated)
        }
    }
    
    /// 后退至根控制器
    ///
    /// - Parameter animated: 是否显示动画
    /// - Returns: vcs
    @discardableResult
    public func pop(toRootVC animated: Bool) -> [UIViewController]? {
        if let vc = base as? UINavigationController {
            return vc.popToRootViewController(animated: animated)
        }else{
            return base.navigationController?.popToRootViewController(animated: animated)
        }
    }
    
}
