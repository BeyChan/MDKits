//
//  UIControlExtension.swift
//  CMYKit
//
//  Created by  MarvinChan on 2019/3/27.
//  Copyright © 2019  MarvinChan. All rights reserved.
//

import UIKit


// MARK: - runtime keys
extension UIControl {
    fileprivate static var once: Bool = false
    
    fileprivate class func swizzing() {
        if once == false {
            once = true
            let select1 = #selector(UIControl.sendAction(_:to:for:))
            let select2 = #selector(UIControl.cmy_sendAction(action:to:forEvent:))
            let classType = UIControl.self
            let select1Method = class_getInstanceMethod(classType, select1)
            let select2Method = class_getInstanceMethod(classType, select2)
            let didAddMethod  = class_addMethod(classType,
                                                select1,
                                                method_getImplementation(select2Method!),
                                                method_getTypeEncoding(select2Method!))
            if didAddMethod {
                class_replaceMethod(classType,
                                    select2,
                                    method_getImplementation(select1Method!),
                                    method_getTypeEncoding(select1Method!))
            }else {
                method_exchangeImplementations(select1Method!, select2Method!)
            }
        }
    }
    
    fileprivate struct ActionKey {
        static var action = UnsafeRawPointer(bitPattern: "uicontrol_action_block".hashValue)
        static var time = UnsafeRawPointer(bitPattern: "uicontrol_event_time".hashValue)
        static var interval = UnsafeRawPointer(bitPattern: "uicontrol_event_interval".hashValue)
    }
}

// MARK: - time
extension UIControl {
    
    /// 系统响应事件
    fileprivate var systemActions: [String] {
        return ["_handleShutterButtonReleased:",
                "cameraShutterPressed:",
                "_tappedBottomBarCancelButton:",
                "_tappedBottomBarDoneButton:",
                "recordStart:",
                "btnTouchUp:withEvent:"]
    }
    
    // 重复点击的间隔
    public var eventInterval: TimeInterval {
        get {
            if let eventInterval = objc_getAssociatedObject(self,
                                                            UIControl.ActionKey.interval!) as? TimeInterval {
                return eventInterval
            }
            return 1.5
        }
        set {
            UIControl.swizzing()
            objc_setAssociatedObject(self,
                                     UIControl.ActionKey.interval!,
                                     newValue as TimeInterval,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 上次事件响应时间
    fileprivate var lastEventTime: TimeInterval {
        get {
            if let eventTime = objc_getAssociatedObject(self, UIControl.ActionKey.time!) as? TimeInterval {
                return eventTime
            }
            return 1.0
        }
        set {
            UIControl.swizzing()
            objc_setAssociatedObject(self,
                                     UIControl.ActionKey.time!,
                                     newValue as TimeInterval,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @objc fileprivate func cmy_sendAction(action: Selector, to target: AnyObject?, forEvent event: UIEvent?) {
        if systemActions.contains(action.description) || eventInterval <= 0 {
            self.cmy_sendAction(action: action, to: target, forEvent: event)
            return
        }
        
        let nowTime = Date().timeIntervalSince1970
        if nowTime - lastEventTime < eventInterval { return }
        if eventInterval > 0 { lastEventTime = nowTime }
        self.cmy_sendAction(action: action, to: target, forEvent: event)
    }
    
}
