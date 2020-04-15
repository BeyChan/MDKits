
//
//  UIView+.swift
//  MDFooBox
//
//  Created by  MarvinChan on 2019/12/27.
//  Copyright © 2019  MarvinChan. All rights reserved.
//

import UIKit

public extension Container where Host: UIView {
    
    /// 示例
    ///  ```view.on.tap { }```
    ///
    /// UIView添加点击事件
    /// - Parameter action: 动作
    func tap(_ action: @escaping Action) {
        host.isUserInteractionEnabled = true
        let tapGestr = UITapGestureRecognizer()
        tapGestr.on.tap {
            action()
        }
        host.addGestureRecognizer(tapGestr)
    }
}
