//
//  MDLayout.swift
//  MDFooBox
//
//  Created by  MarvinChan on 2019/10/15.
//  Copyright © 2019  MarvinChan. All rights reserved.
//

import UIKit

/*
 let view = UIView()
 superView.addSubView(view)
 view.fillInSuperView()
 或view.fillInSuperview(margin: 0)
 或view.fill(inView: superview, withInset: .zero)
 **/
public extension UIView {
    
    /// 填充父View
    @discardableResult
    func fillInSuperview(insets: UIEdgeInsets = .zero, isActive: Bool = true) -> [NSLayoutConstraint] {
        guard let superview = self.superview else {
            return [NSLayoutConstraint]()
        }
        
        return fill(inView: superview, withInset: insets, isActive: isActive)
    }
    
    /// 填充父View
    @discardableResult
    func fillInSuperview(margin: CGFloat, isActive: Bool = true) -> [NSLayoutConstraint] {
        let insets = UIEdgeInsets(top: margin, left: margin, bottom: -margin, right: -margin)
        return fillInSuperview(insets: insets, isActive: isActive)
    }
    
    /// 填充父View
    @discardableResult
    func fill(inView view: UIView, withInset insets: UIEdgeInsets = .zero, isActive: Bool = true) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [NSLayoutConstraint]()
        constraints.append(topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top))
        constraints.append(leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left))
        constraints.append(bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: insets.bottom))
        constraints.append(trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: insets.right))
        
        if isActive {
            NSLayoutConstraint.activate(constraints)
        }
        
        return constraints
    }
    

    
    /// 设置属性值
    /// - Parameter edge: 为width和height
    /// - Parameter value: 值
    /// - Parameter relation: 关系
    /// - Parameter multiplier: 比例
    /// - Parameter priority: 优先级
    @discardableResult
    func set(_ edge: MDAttribute, of value: CGFloat, relation: MDRelation = .equal,
             multiplier: CGFloat = 1.0, priority: MDPriority = .required) -> NSLayoutConstraint {
        if translatesAutoresizingMaskIntoConstraints {
            translatesAutoresizingMaskIntoConstraints = false
        }
        let constraint = NSLayoutConstraint(item: self, attribute: edge, relatedBy: relation, toItem: nil, attribute: .notAnAttribute, multiplier: multiplier, constant: value)
        constraint.priority = priority
        addConstraint(constraint)
        return constraint
    }
    
    /// 设置多个属性值等于某一个值
     /// - Parameter edge: 为width和height
     /// - Parameter value: 值
     /// - Parameter relation: 关系
     /// - Parameter multiplier: 比例
     /// - Parameter priority: 优先级
    @discardableResult
    func set(_ edges: MDAttribute..., of value: CGFloat, relation: MDRelation = .equal,
             multiplier: CGFloat = 1.0, priority: MDPriority = .required) -> MDMultipleConstraints {
        return set(edges, to: value, relation: relation, multiplier: multiplier, priority: priority)
    }
    
    
    /// 设置多个属性值等于某一个值
     /// - Parameter edge: 为width和height
     /// - Parameter value: 值
     /// - Parameter relation: 关系
     /// - Parameter multiplier: 比例
     /// - Parameter priority: 优先级
    @discardableResult
    private func set(_ edges: [MDAttribute], to value: CGFloat, relation: MDRelation = .equal,
             multiplier: CGFloat = 1.0, priority: MDPriority = .required) -> MDMultipleConstraints {
        var constraints: MDMultipleConstraints = [:]
        let uniqueEdges = Set(edges)
        for edge in uniqueEdges {
            let constraint = set(edge, of: value, priority: priority)
            constraints[edge] = constraint
        }
        return constraints
    }
    
    
    /// 设置单个布局方法
    /// - Parameter edge: 本身属性
    /// - Parameter view: 做对比的View
    /// - Parameter otherEdge: 做对比的View属性值
    /// - Parameter relation: 关系
    /// - Parameter multiplier: 倍数
    /// - Parameter offset: 偏移量
    /// - Parameter priority: 优先级
    @discardableResult
    func pin(_ edge: MDAttribute, off view: UIView? = nil, to otherEdge: MDAttribute? = nil,
                relation: MDRelation = .equal, multiplier: CGFloat = 1.0, offset: CGFloat = 0,
                priority: MDPriority = .required) -> NSLayoutConstraint? {
        guard isValidForLayout else {
            print("\(String(describing: self)) 出现错误在方法: \(#function)")
            return nil
        }
        
        guard let view = view ?? superview else {
            return nil
        }
        let otherEdge = otherEdge ?? edge
        let constraint = NSLayoutConstraint(item: self, attribute: edge, relatedBy: relation, toItem: view, attribute: otherEdge, multiplier: multiplier, constant: offset)
        constraint.priority = priority
        superview!.addConstraint(constraint)
        return constraint
    }

    /// 设置多个布局方法
    /// - Parameter edges: 本身属性数组
    /// - Parameter view: 做对比的View
    /// - Parameter relation: 关系
    /// - Parameter multiplier: 倍数
    /// - Parameter offset: 偏移量
    /// - Parameter priority: 优先级
    @discardableResult
    func pin(edges: MDAttribute..., to view: UIView? = nil, relation: MDRelation = .equal,
                multiplier: CGFloat = 1.0, offset: CGFloat = 0,
                priority: MDPriority = .required) -> MDMultipleConstraints {
        var constraints: MDMultipleConstraints = [:]
        guard isValidForLayout else {
            print("\(String(describing: self)) 出现错误在方法: \(#function)")
            return constraints
        }
        guard let view = view ?? superview else {
            return constraints
        }
        let uniqueEdges = Set(edges)
        for edge in uniqueEdges {
            let constraint = NSLayoutConstraint(item: self, attribute: edge, relatedBy: relation, toItem: view, attribute: edge, multiplier: multiplier, constant: offset)
            constraint.priority = priority
            superview!.addConstraint(constraint)
            constraints[edge] = constraint
        }
        return constraints
    }

    /// 设置单个布局方法 依赖于负View
    /// - Parameter edge: 本身属性
    /// - Parameter relation: 关系
    /// - Parameter multiplier: 倍数
    /// - Parameter offset: 偏移量
    /// - Parameter priority: 优先级
    @discardableResult
    func pinToSuperView(_ edge: MDAttribute, relation: MDRelation = .equal,
                           multiplier: CGFloat = 1, offset: CGFloat = 0,
                           priority: MDPriority = .required) -> NSLayoutConstraint? {
        guard isValidForLayout else {
            print("\(String(describing: self)) 出现错误在方法: \(#function)")
            return nil
        }
        let constraint = NSLayoutConstraint(item: self, attribute: edge, relatedBy: relation, toItem: superview, attribute: edge, multiplier: multiplier, constant: offset)
        constraint.priority = priority
        superview!.addConstraint(constraint)
        return constraint
    }
    
    /// 设置多个布局方法 依赖于负View
    /// - Parameter edge: 本身属性值数组
    /// - Parameter relation: 关系
    /// - Parameter multiplier: 倍数
    /// - Parameter offset: 偏移量
    /// - Parameter priority: 优先级
    @discardableResult
    func pinToSuperView(edges: MDAttribute..., relation: MDRelation = .equal,
                           multiplier: CGFloat = 1, offset: CGFloat = 0,
                           priority: MDPriority = .required) -> MDMultipleConstraints {
        var constraints: MDMultipleConstraints = [:]
        guard !edges.isEmpty && isValidForLayout else {
            return constraints
        }
        let uniqueEdges = Set(edges)
        for edge in uniqueEdges {
            let constraint = NSLayoutConstraint(item: self, attribute: edge, relatedBy: relation, toItem: superview, attribute: edge, multiplier: multiplier, constant: offset)
            constraint.priority = priority
            superview!.addConstraint(constraint)
            constraints[edge] = constraint
        }
        return constraints
    }
    
    
    /// 设置轴布局
    /// - Parameter axis: 横轴或者竖轴
    /// - Parameter offset: 偏移量
    /// - Parameter priority: 优先级
    @discardableResult
    func pinToSuperView(axis: MDAxis, offset: CGFloat = 0,
                           priority: MDPriority = .required) -> MDAxisConstraints? {
        let attributes = axis.attributes
        guard let first = pinToSuperView(attributes.first, offset: offset, priority: priority) else {
            return nil
        }
        guard let second = pinToSuperView(attributes.second, offset: -offset, priority: priority) else {
            return nil
        }
        return MDAxisConstraints(first: first, second: second)
    }
    
    
    /// 设置与父View的大小布局方法
    /// - Parameter multiplier: 倍数
    /// - Parameter offset: 偏移量
    /// - Parameter priority: 优先级
    @discardableResult
    func sizeToSuperview(withRatio multiplier: CGFloat = 1, offset: CGFloat = 0,
                         priority: MDPriority = .required) -> MDSizeConstraints? {
        let size = pinToSuperView(edges: .width, .height, multiplier: multiplier, offset: offset, priority: priority)
        guard !size.isEmpty else {
            return nil
        }
        return MDSizeConstraints(width: size[.width]!, height: size[.height]!)
    }
    
    /// 设置中心与父View的布局方法
    /// - Parameter offset: 偏移量
    /// - Parameter priority: 优先级
    @discardableResult
    func centerInSuperview(offset: CGFloat = 0, priority: MDPriority = .required) -> MDCenterConstraints? {
        let center = pinToSuperView(edges: .centerX, .centerY, offset: offset)
        guard !center.isEmpty else {
            return nil
        }
        return MDCenterConstraints(x: center[.centerX]!, y: center[.centerY]!)
    }
    
    /// 设置中心等于View,同时设置大小
    /// - Parameter multiplier: 倍数
    /// - Parameter offset: 偏移量
    /// - Parameter priority: 优先级
    @discardableResult
    func fillInSuperview(withSizeRatio multiplier: CGFloat = 1, offset: CGFloat = 0,
                       priority: MDPriority = .required) -> MDFillConstraints? {
        guard let center = centerInSuperview(priority: priority) else {
            return nil
        }
        guard let size = sizeToSuperview(withRatio: multiplier, offset: offset, priority: priority) else {
            return nil
        }
        return MDFillConstraints(center: center, size: size)
    }
    
    
    /// 检查布局是否有效
    private var isValidForLayout: Bool {
        guard superview != nil else {
            print("\(String(describing: self)):\(#function) - 父View不存在")
            return false
        }
        if translatesAutoresizingMaskIntoConstraints {
            translatesAutoresizingMaskIntoConstraints = false
        }
        return true
    }
}


