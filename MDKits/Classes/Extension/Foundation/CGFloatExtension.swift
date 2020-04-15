//
//  CGFloat.swift
//  CMYKit
//
//  Created by  MarvinChan on 2019/3/27.
//  Copyright © 2019  MarvinChan. All rights reserved.
//

import UIKit

extension Float{
    public var cgFloat: CGFloat { return CGFloat(self) }
}

extension Double {
    public var cgFloat: CGFloat { return CGFloat(self) }
}

extension Int {
    public var cgFloat: CGFloat { return CGFloat(self) }
}

extension CGFloat{
    /// 绝对值
    public var abs: CGFloat { return Swift.abs(self) }
    /// 向上取整
    public var ceil: CGFloat { return Foundation.ceil(self) }
    /// 向下取整
    public var floor: CGFloat { return Foundation.floor(self) }
    
    public var string: String { return description }
    
    public var int: Int { return Int(self) }
    public var float: Float { return Float(self) }
}
