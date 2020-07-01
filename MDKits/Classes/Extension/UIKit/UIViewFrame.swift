//
//  UIViewFrame.swift
//  CMYKit
//
//  Created by  MarvinChan on 2019/3/27.
//  Copyright © 2019  MarvinChan. All rights reserved.
//  source https://github.com/casatwy/SwiftHandyFrame

import UIKit

extension UIView {
    //MARK: Size
    var md_height: CGFloat {
        get {
            return frame.size.height
        }
        set {
            frame.size.height = newValue
        }
    }

    var md_width: CGFloat {
        get {
            return frame.size.width
        }
        set {
           frame.size.width = newValue
        }
    }
    
    var md_size: CGSize {
        get {
            return frame.size
        }
        set {
            frame.size = newValue
        }
    }
    
    //MARK: Position
    var md_x: CGFloat {
        get {
            return frame.origin.x
        }
        set {
            frame.origin.x = newValue
        }
    }

    var md_y: CGFloat {
        get {
            return frame.origin.y
        }
        set {
            frame.origin.y = newValue
        }
    }
    
    var md_centerX: CGFloat {
        get {
            return center.x
        }
        set {
            center.x = newValue
        }
    }
    
    var md_centerY: CGFloat {
        get {
            return center.y
        }
        set {
            center.y = newValue
        }
    }
        
    //MARK: Shape
    var md_left: CGFloat {
        return frame.origin.x
    }
    
    func md_setLeft(_ left:CGFloat, shouldResize:Bool) {
        if shouldResize {
            frame.size.width = frame.origin.x - left + frame.size.width
        }
        frame.origin.x = left
    }
    
    var md_right: CGFloat {
        return frame.origin.x + frame.size.width
    }

    func md_setRight(_ right:CGFloat, shouldResize:Bool) {
        if shouldResize {
            frame.size.width = right - frame.origin.x
        } else {
            frame.origin.x = right - frame.size.width
        }
    }
    
    var md_bottom: CGFloat {
        return frame.origin.y + frame.size.height
    }
    
    func md_setBottom(_ bottom:CGFloat, shouldResize:Bool) {
        if shouldResize {
            frame.size.height = bottom - frame.origin.y
        } else {
            frame.origin.y = bottom - frame.size.height
        }
    }
    
    var md_top: CGFloat {
        return frame.origin.y
    }
    
    func md_setTop(_ top:CGFloat, shouldResize:Bool) {
        if shouldResize {
            frame.size.height = frame.size.height - top + frame.origin.y
        }
        frame.origin.y = top
    }
    
    //MARK: Center Position with Other View
    func md_setCenterXEqualToView(_ view:UIView) {
        let superView = view.superview ?? view
        let topSuperView = md_topSuperView()
        
        let viewCenterPoint = superView.convert(view.center, to:topSuperView)
        let centerPoint = topSuperView.convert(viewCenterPoint, to:superview)
        self.md_centerX = centerPoint.x
    }
    
    func md_setCenterYEqualToView(_ view:UIView) {
        let superView = view.superview ?? view
        let topSuperView = md_topSuperView()
        
        let viewCenterPoint = superView.convert(view.center, to:topSuperView)
        let centerPoint = topSuperView.convert(viewCenterPoint, to:superview)
        self.md_centerY = centerPoint.y
    }
    
    public func md_setCenterEqualToView(_ view:UIView) {
        let superView = view.superview ?? view
        let topSuperView = md_topSuperView()
        
        let viewCenterPoint = superView.convert(view.center, to:topSuperView)
        let centerPoint = topSuperView.convert(viewCenterPoint, to:superview)
        center = centerPoint
    }
    
    //MARK: top/bottom/left/right gap in Other View
    
    /*
     ---------------------------------------------
     | superview          top                    |
     |                    gap                    |
     |          ----------------------           |
     |          |                    |           |
     |          |                    |           |
     |          |                    |           |
     |   left   |        VIEW        |   right   |
     |   gap    |                    |    gap    |
     |          |                    |           |
     |          |                    |           |
     |          ----------------------           |
     |                  bottom                   |
     |                    gap                    |
     ---------------------------------------------
     */
    
    
    public func md_setInnerTopGap(_ topGap:CGFloat, shouldResize:Bool) {
        if shouldResize {
            frame.size.height = frame.origin.y - topGap + frame.size.height
        }
        frame.origin.y = topGap
    }
    
    public func md_setInnerBottomGap(_ bottomGap:CGFloat, shouldResize:Bool) {
        if shouldResize {
            frame.size.height = superview!.frame.size.height - bottomGap - frame.origin.y - md_safeAreaBottomGap()
        } else {
            frame.origin.y = superview!.frame.size.height - frame.size.height - bottomGap - md_safeAreaBottomGap()
        }
    }
    
    public func md_setInnerLeftGap(_ leftGap:CGFloat, shouldResize:Bool) {
        if shouldResize {
            frame.size.width = frame.origin.x - leftGap + frame.size.width
        }
        frame.origin.x = leftGap
    }
    
    public func md_setInnerRightGap(_ rightGap:CGFloat, shouldResize:Bool) {
        if shouldResize {
            frame.size.width = superview!.frame.size.width - rightGap - frame.origin.x
        } else {
            frame.origin.x = superview!.frame.size.width - frame.size.width - rightGap
        }
    }
    
    //MARK: top/bottom/left/right gap from Other View
    /*
     
     |                   |
     |                   |
     ---------------------
     top gap
     ---           ---------------------           ---
     |          |                   |           |
     |          |                   |           |
     |          |                   |           |
     | left gap |        VIEW       | right gap |
     |          |                   |           |
     |          |                   |           |
     |          |                   |           |
     ---          ---------------------           ---
     bottom gap
     ---------------------
     |                   |
     |                   |
     */
    public func md_setTopGap(_ topGap:CGFloat, fromView:UIView) {
        let fromViewSuperView = fromView.superview ?? fromView
        let topSuperView = md_topSuperView()
        let viewOriginPoint = fromViewSuperView.convert(fromView.frame.origin, to: topSuperView)
        let newOriginPoint = topSuperView.convert(viewOriginPoint, to:superview)
        frame.origin.y = newOriginPoint.y + topGap + fromView.frame.size.height
    }
    
    public func md_setBottomGap(_ bottomGap:CGFloat, fromView:UIView) {
        let fromViewSuperView = fromView.superview ?? fromView
        let fromViewOriginPoint = fromViewSuperView.convert(fromView.frame.origin, to:superview)
        frame.origin.y = fromViewOriginPoint.y - bottomGap - frame.size.height
    }
    
    public func md_setLeftGap(_ leftGap:CGFloat, fromView:UIView) {
        let fromViewSuperView = fromView.superview ?? fromView
        let topSuperView = md_topSuperView()
        let fromViewOriginPoint = fromViewSuperView.convert(fromView.frame.origin, to:topSuperView)
        let newOriginPoint = topSuperView.convert(fromViewOriginPoint, to: superview)
        frame.origin.x = newOriginPoint.x + leftGap + fromView.frame.size.width
    }
    
    public func md_setRightGap(_ rightGap:CGFloat, fromView:UIView) {
        let fromViewSuperView = fromView.superview ?? fromView
        let topSuperView = md_topSuperView()
        let fromViewOriginPoint = fromViewSuperView.convert(fromView.frame.origin, to:topSuperView)
        let newOriginPoint = topSuperView.convert(fromViewOriginPoint, to: superview)
        frame.origin.x = newOriginPoint.x - rightGap - fromView.frame.size.width
    }
    
    //MARK: top/bottom/left/right equal to Other View
    public func md_topEqualToView(_ view:UIView) {
        let viewSuperView = view.superview ?? view
        let topSuperView = md_topSuperView()
        let viewOriginPoint = viewSuperView.convert(view.frame.origin, to:topSuperView)
        let newOriginPoint = topSuperView.convert(viewOriginPoint, to: superview)
        frame.origin.y = newOriginPoint.y
    }
    
    public func md_bottomEqualToView(_ view:UIView) {
        let viewSuperView = view.superview ?? view
        let topSuperView = md_topSuperView()
        let viewOriginPoint = viewSuperView.convert(view.frame.origin, to:topSuperView)
        let newOriginPoint = topSuperView.convert(viewOriginPoint, to: superview)
        frame.origin.y = newOriginPoint.y + view.frame.size.height - frame.size.height
    }
    
    public func md_leftEqualToView(_ view:UIView) {
        let viewSuperView = view.superview ?? view
        let topSuperView = md_topSuperView()
        let viewOriginPoint = viewSuperView.convert(view.frame.origin, to:topSuperView)
        let newOriginPoint = topSuperView.convert(viewOriginPoint, to: superview)
        frame.origin.x = newOriginPoint.x
    }
    
    public func md_rightEqualToView(_ view:UIView) {
        let viewSuperView = view.superview ?? view
        let topSuperView = md_topSuperView()
        let viewOriginPoint = viewSuperView.convert(view.frame.origin, to:topSuperView)
        let newOriginPoint = topSuperView.convert(viewOriginPoint, to: superview)
        frame.origin.x = newOriginPoint.x + view.frame.size.width - frame.size.width
    }
    
    //MARK: Fill
    public func md_fillWidth() {
        frame.size.width = superview!.frame.size.width
        frame.origin.x = 0
    }
    
    public func md_fillHeight() {
        frame.size.height = superview!.frame.size.height
        frame.origin.y = 0
    }
    
    public func md_fill() {
        frame = CGRect(x: 0, y: 0, width: superview!.frame.size.width, height: superview!.frame.size.height)
    }
    
    //MARK: helper method
    private func md_topSuperView() -> UIView {
        var topSuperView = superview
        if topSuperView == nil {
            topSuperView = self
        } else {
            while topSuperView!.superview != nil {
                topSuperView = topSuperView!.superview
            }
        }
        
        return topSuperView!
    }
    
    private func md_safeAreaBottomGap() -> CGFloat {
        if #available(iOS 11.0, *) {
            if superview!.safeAreaLayoutGuide.layoutFrame.size.height > 0 {
                return superview!.frame.size.height - superview!.safeAreaLayoutGuide.layoutFrame.origin.y - superview!.safeAreaLayoutGuide.layoutFrame.size.height;
            } else {
                return 0
            }
        } else {
            return 0
        }
    }
}
