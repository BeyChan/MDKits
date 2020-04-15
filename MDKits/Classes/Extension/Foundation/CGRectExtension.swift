//
//  CGRectExtension.swift
//  CMYKit
//
//  Created by  MarvinChan on 2019/3/27.
//  Copyright © 2019  MarvinChan. All rights reserved.
//

import UIKit

extension CGRect {
    
    /// X
    public var x: CGFloat {
        set { self.origin.x = newValue }
        get { return self.origin.x }
    }
    
    /// Y
    public var y: CGFloat {
        set { self.origin.y = newValue }
        get { return self.origin.y }
    }
}
