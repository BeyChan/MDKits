
//
//  UIGestureRecognizer+.swift
//  MDFooBox
//
//  Created by  MarvinChan on 2019/12/27.
//  Copyright © 2019  MarvinChan. All rights reserved.
//

import Foundation

public extension Container where Host: UIGestureRecognizer {
    
    ///示例 `gesture.on.tap{ }`
    /// 添加事件
    /// - Parameter action: 闭包动作
    func tap(_ action: @escaping Action) {
        let target = _GestureTarget(host: host, action: action)
        targets[_GestureTarget.uniqueId] = target
    }
}

private class _GestureTarget: NSObject {
    var action: Action?

    init(host: UIGestureRecognizer, action: @escaping Action) {
        super.init()

        self.action = action
        host.addTarget(self, action: #selector(didOccur(_:)))
    }

    // MARK: - Action
    @objc func didOccur(_ gestureRecognizer: UIGestureRecognizer) {
        action?()
    }
}
