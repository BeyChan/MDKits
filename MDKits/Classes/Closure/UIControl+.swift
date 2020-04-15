
//
//  UIControl+Closure.swift
//  MDFooBox
//
//  Created by  MarvinChan on 2019/12/27.
//  Copyright © 2019  MarvinChan. All rights reserved.
//

import Foundation

public extension Container where Host: UIControl {
    /// 示例
    /// `button.on.add(for: .touchUpInside) { }`
    /// 添加响应事件
    /// - Parameters:
    ///   - event: 事件类型
    ///   - action: 闭包动作
    func add(for event: UIControl.Event, action: @escaping Action) {
        let target = _UIControlTarget(host: host, event: event, action: action)
        targets[_UIControlTarget.uniqueId] = target
    }
}

private class _UIControlTarget: NSObject {
    var host: UIControl?
    var action: Action?
    var event: UIControl.Event?

    init(host: UIControl, event: UIControl.Event, action: @escaping Action) {
        super.init()
        self.action = action
        self.event = event
        self.host = host
        host.addTarget(self, action: #selector(handleTap(_:)), for: event)
    }

    // MARK: - Action
    @objc func handleTap(_ sender: UIControl) {
        action?()
    }
    
}
