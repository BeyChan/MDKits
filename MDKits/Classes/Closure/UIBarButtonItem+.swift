//
//  UIBarButtonItem+.swift
//  MDFooBox
//
//  Created by  MarvinChan on 2019/12/27.
//  Copyright © 2019  MarvinChan. All rights reserved.
//

import Foundation

public extension Container where Host: UIBarButtonItem {
    
    ///示例 `barButton.on.tap{ }`
    /// 添加动作
    /// - Parameter action: 闭包动作
    func tap(_ action: @escaping Action) {
        let target = _BarButtonItemTarget(host: host, action: action)
        targets[_BarButtonItemTarget.uniqueId] = target
    }
}

private class _BarButtonItemTarget: NSObject {
    var action: Action?

    init(host: UIBarButtonItem, action: @escaping Action) {
        super.init()

        self.action = action
        host.target = self
        host.action = #selector(handleTap)
    }

    // MARK: - Action

    @objc func handleTap() {
        action?()
    }
}
