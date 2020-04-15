//
//  MDHUD.swift
//  MDFooBox
//
//  Created by  MarvinChan on 2019/10/23.
//  Copyright © 2019  MarvinChan. All rights reserved.
//

import UIKit
import MBProgressHUD

private let kDelayTime = 1.5
struct MDHUD {
    private init() {}
    static var shared = MDHUD()
    
    static func showLoading(message: String? = nil,superView view : UIView? = MD.window)  {
        MDHUD.shared.createHUD(mode: .indeterminate, inView: view, message: message)
    }
    
    
    static func showMessage(_ message : String, delay : TimeInterval = kDelayTime,superView: UIView? = MD.window)  {
        MDHUD.shared.createHUD(mode: .text, inView: superView, message: message, delay: delay)
    }
    
    /// 显示错误
    static func showError(_ err: Error,superView: UIView? = MD.window) {
        if let error = err as? MDError,error.code != -999 {
            MDHUD.showMessage(error.massage, superView: superView)
        }else {
            let otherErr = err as? MDOtherError
            MDHUD.showMessage(otherErr?.description ?? err.localizedDescription, superView: superView)
        }
    }
    
    
    fileprivate func createHUD(mode: MBProgressHUDMode = .text, inView view: UIView?, message : String? = nil, delay : TimeInterval? = nil)  {
        guard let view = view  else { return  }
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: view, animated: true)
            let hud =  MBProgressHUD.showAdded(to: view, animated: true)
            hud.mode = mode
            hud.isUserInteractionEnabled = false
            hud.bezelView.style = .solidColor
            hud.backgroundView.style = .solidColor
            if let message = message {
                hud.label.text = message
                hud.label.numberOfLines = 0
                hud.label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            }
            hud.show(animated: true)
            if let delay = delay {
                hud.hide(animated: false, afterDelay: max(delay, kRemainTime))
            }
        }
    }
    
    
    
    static func hide(superView :UIView? = MD.window) {
        guard let view = superView  else { return }
        let notLast = MBProgressHUD.hide(for: view, animated: true)
        if notLast {
            hide(superView: view)
        }
    }
    
    
    
    static func hideWindowHUD() {
        guard let window = MD.window else { return }
        hide(superView: window)
    }
    
}
