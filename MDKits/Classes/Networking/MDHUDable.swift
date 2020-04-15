//
//  MDHUDable.swift
//  MDKit
//
//  Created by  MarvinChan on 2019/10/14.
//

import UIKit
import MBProgressHUD
let kRemainTime:TimeInterval = 1.5
protocol MDHUDable {}

extension UIViewController: MDHUDable {}
extension UIView: MDHUDable {}
extension MDNetworking: MDHUDable {}

extension MDHUDable {
    /// 显示等待
    func showLoading(message: String? = nil, superView: UIView? = nil)  {
        return MDHUD.showLoading(message: message,superView: superView)
    }
    
    /// 显示消息文本
    func showMessage(_ message: String, delay: TimeInterval = kRemainTime, superView: UIView? = nil)  {
        return MDHUD.showMessage(message, delay: delay, superView: superView)
    }
    
    /// 显示错误
    func showError(_ err: MDError,superView: UIView? = nil)  {
        return MDHUD.showError(err, superView: superView)
    }
    
    /// 清楚Hud
    func clearHud(superView: UIView? = nil) {
        MDHUD.hide(superView: superView)
    }
    
    @discardableResult
    func showActivityIndicatorView(_ toView : UIView?) -> MBProgressHUD? {
        guard let toView = toView else { return nil }
        return MBProgressHUD.showAdded(to: toView, animated: true)
    }
    func hideActivityIndicatorView(_ fromView: UIView?) {
        guard let fromView = fromView else { return }
        MBProgressHUD.hide(for: fromView, animated: true)
    }
}
