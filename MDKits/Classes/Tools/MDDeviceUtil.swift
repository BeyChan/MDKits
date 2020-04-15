//
//  MDDisplay.swift
//  MDKit
//
//  Created by  MarvinChan on 2019/10/14.
//

import UIKit

struct MDDeviceUtil {
       
    public static let `default`: MDDeviceUtil = MDDeviceUtil()
    
    private init() {}
    
    /// 设计宽度
    var designWidth: CGFloat = 375
    /// 设计高度
    var designHeight: CGFloat = 667
    
    /// 宽度比例
    private var scaleWidth : CGFloat {
        get {
            
            return MD.screenW/designWidth
        }
    }
    
    /// 高度比例
    private var scaleHeight : CGFloat {
        get {
            return MD.screenH/designHeight
        }
    }
    
    
    /// 高度与屏幕一致适配宽度
    /// - Parameter width: CGFloat
    public static func setWidth(_ width: CGFloat) -> CGFloat{
        return width*MDDeviceUtil.default.scaleHeight
    }
    
    
    /// 宽度与屏幕一致适配高度
    /// - Parameter height: CGFloat
    public static func setHeight(_ height: CGFloat) -> CGFloat{
        return height*MDDeviceUtil.default.scaleWidth
    }
}

