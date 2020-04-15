
//
//  MDAutoLayout++.swift
//  MDFooBox
//
//  Created by  MarvinChan on 2019/10/29.
//  Copyright © 2019  MarvinChan. All rights reserved.
//

import UIKit
/*
 示例
 view.md.makeConstraints { (make) in
 make.topAnchor.equalTo(anchor: otherView.bottomAnchor, constant: 23)
 make.centerXAnchor.equalTo(anchor: superView.centerXAnchor)
 make.widthAnchor.equalTo(c: 190)
 }
 
 或
 view.md.makeConstraints { (make) in
 make.md.centerY.equalTo(anchor: superView.md.centerY)
 make.md.right == contentView.md.right - 10
 make.md.width == 93
 make.md.height == 12
 }
 **/

public extension MDKit where Base:UIView {
    
    func makeConstraints(using closure: (UIView)->Void)
    {
        base.translatesAutoresizingMaskIntoConstraints = false
        closure(base)
    }
    
    var height:   NSLayoutDimension { return base.heightAnchor }
    var width:    NSLayoutDimension { return base.widthAnchor }
    
    var leading:  NSLayoutXAxisAnchor { return base.leadingAnchor }
    var trailing: NSLayoutXAxisAnchor { return base.trailingAnchor }
    
    var left:  NSLayoutXAxisAnchor { return base.leftAnchor }
    var right: NSLayoutXAxisAnchor { return base.rightAnchor }
    var centerX:  NSLayoutXAxisAnchor { return base.centerXAnchor }
    
    var top:      NSLayoutYAxisAnchor { return base.topAnchor }
    var bottom:   NSLayoutYAxisAnchor { return base.bottomAnchor }
    var centerY:  NSLayoutYAxisAnchor { return base.centerYAnchor }
    
    var marginsGuide: UILayoutGuide { return base.layoutMarginsGuide }
    
    var firstBaseLine: NSLayoutYAxisAnchor { return base.firstBaselineAnchor }
    var lastBaseline: NSLayoutYAxisAnchor { return base.lastBaselineAnchor }
    
}

public extension MDKit where Base: UILayoutGuide {
    var height:   NSLayoutDimension { return base.heightAnchor }
    var width:    NSLayoutDimension { return base.widthAnchor }
    
    var leading:  NSLayoutXAxisAnchor { return base.leadingAnchor }
    var trailing: NSLayoutXAxisAnchor { return base.trailingAnchor }
    
    var left:  NSLayoutXAxisAnchor { return base.leftAnchor }
    var right: NSLayoutXAxisAnchor { return base.rightAnchor }
    
    var centerX:  NSLayoutXAxisAnchor { return base.centerXAnchor }
    
    var top:      NSLayoutYAxisAnchor { return base.topAnchor }
    var bottom:   NSLayoutYAxisAnchor { return base.bottomAnchor }
    var centerY:  NSLayoutYAxisAnchor { return base.centerYAnchor }
}

public extension MDKit where Base: UIViewController {
    var bottomGuide: NSLayoutYAxisAnchor { return base.bottomLayoutGuide.topAnchor }
    var topGuide: NSLayoutYAxisAnchor { return base.topLayoutGuide.bottomAnchor }
}

// MARK: anchor = constant
@discardableResult
public func == (left: NSLayoutDimension, right: CGFloat)  -> NSLayoutConstraint {
    let c = left.constraint(equalToConstant: right);c.isActive = true;return c
}
@discardableResult
public func == (left:NSLayoutXAxisAnchor, right:NSLayoutXAxisAnchor) -> NSLayoutConstraint
{
    let c = left.constraint( equalTo:right, constant:0.0);c.isActive = true;return c
}
@discardableResult
public func == (left:NSLayoutYAxisAnchor, right:NSLayoutYAxisAnchor) -> NSLayoutConstraint
{
    let c = left.constraint( equalTo:right, constant:0.0);c.isActive = true;return c
}
@discardableResult
public func == (left:NSLayoutDimension, right:NSLayoutDimension) -> NSLayoutConstraint
{
    let c = left.constraint( equalTo:right, constant:0.0);c.isActive = true;return c
}

// MARK: anchor = anchor + constant
@discardableResult
public func == (left: NSLayoutDimension, right: (anchor: NSLayoutDimension, constant: CGFloat)) -> NSLayoutConstraint {
    let c = left.constraint(equalTo: right.anchor, constant: right.constant);c.isActive = true; return c
}
@discardableResult
public func == (left: NSLayoutXAxisAnchor, right: (anchor: NSLayoutXAxisAnchor, constant: CGFloat)) -> NSLayoutConstraint {
    let c = left.constraint(equalTo: right.anchor, constant: right.constant); c.isActive = true; return c
}

@discardableResult
public func == (left: NSLayoutYAxisAnchor, right: (anchor: NSLayoutYAxisAnchor, constant: CGFloat)) -> NSLayoutConstraint {
    let c = left.constraint(equalTo: right.anchor, constant: right.constant); c.isActive = true; return c
}


// MARK: dimension = dimension * multiplier
public struct LayoutDimensionMultiplication {
    let dimension: NSLayoutDimension
    let multiplier: CGFloat
}
public func * (dimension: NSLayoutDimension, multiplier: CGFloat) -> LayoutDimensionMultiplication {
    return LayoutDimensionMultiplication(dimension: dimension, multiplier: multiplier)
}
@discardableResult
public func == (left: NSLayoutDimension, right: LayoutDimensionMultiplication) -> NSLayoutConstraint {
    let c = left.constraint(equalTo: right.dimension, multiplier: right.multiplier); c.isActive = true; return c
}


// MARK: `+`  anchor + constant
public func + (anchor: NSLayoutDimension, constant: CGFloat) -> (NSLayoutDimension , CGFloat) { return (anchor, constant) }
public func + (anchor: NSLayoutXAxisAnchor, constant: CGFloat) -> (NSLayoutXAxisAnchor , CGFloat) { return (anchor, constant) }
public func + (anchor: NSLayoutYAxisAnchor, constant: CGFloat) -> (NSLayoutYAxisAnchor , CGFloat) { return (anchor, constant) }


// MARK: `-`  anchor - constant
public func - (anchor: NSLayoutDimension, constant: CGFloat) -> (NSLayoutDimension, CGFloat) { return (anchor, -constant) }
public func - (anchor: NSLayoutXAxisAnchor, constant: CGFloat) -> (NSLayoutXAxisAnchor, CGFloat) { return (anchor, -constant) }
public func - (anchor: NSLayoutYAxisAnchor, constant: CGFloat) -> (NSLayoutYAxisAnchor, CGFloat) { return (anchor, -constant) }



// MARK: `>=` Operators
infix operator >=: ComparisonPrecedence

/* anchor >= constant */
@discardableResult
public func >= (dimension: NSLayoutDimension, constant: CGFloat) -> NSLayoutConstraint {
    let c = dimension.constraint(greaterThanOrEqualToConstant: constant); c.isActive = true; return c
}

/* anchor >= anchor +/- constant */
@discardableResult
public func >= (left: NSLayoutDimension, right: (anchor: NSLayoutDimension, constant: CGFloat)) -> NSLayoutConstraint {
    let c = left.constraint(greaterThanOrEqualTo: right.anchor, constant: right.constant); c.isActive = true; return c
}
@discardableResult
public func >= (left: NSLayoutXAxisAnchor, right: (anchor: NSLayoutXAxisAnchor, constant: CGFloat)) -> NSLayoutConstraint {
    let c = left.constraint(greaterThanOrEqualTo: right.anchor, constant: right.constant); c.isActive = true; return c
}
@discardableResult
public func >= (left: NSLayoutYAxisAnchor, right: (anchor: NSLayoutYAxisAnchor, constant: CGFloat)) -> NSLayoutConstraint {
    let c = left.constraint(greaterThanOrEqualTo: right.anchor, constant: right.constant); c.isActive = true; return c
}


// MARK: - `<=` Operators
infix operator <=: ComparisonPrecedence

/* anchor <= constant */
@discardableResult
public func <= (dimension: NSLayoutDimension, constant: CGFloat) -> NSLayoutConstraint {
    let c = dimension.constraint(lessThanOrEqualToConstant: constant); c.isActive = true; return c
}

/* anchor <= anchor +/- constant */
@discardableResult
public func <= (left: NSLayoutDimension, right: (anchor: NSLayoutDimension, constant: CGFloat)) -> NSLayoutConstraint {
    let c = left.constraint(lessThanOrEqualTo: right.anchor, constant: right.constant); c.isActive = true; return c
}
@discardableResult
public func <= (left: NSLayoutXAxisAnchor, right: (anchor: NSLayoutXAxisAnchor, constant: CGFloat)) -> NSLayoutConstraint {
    let c = left.constraint(lessThanOrEqualTo: right.anchor, constant: right.constant); c.isActive = true; return c
}
@discardableResult
public func <= (left: NSLayoutYAxisAnchor, right: (anchor: NSLayoutYAxisAnchor, constant: CGFloat)) -> NSLayoutConstraint {
    let c = left.constraint(lessThanOrEqualTo: right.anchor, constant: right.constant); c.isActive = true; return c
}

