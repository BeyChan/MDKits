//
//  MDLayoutUtils.swift
//  MDFooBox
//
//  Created by  MarvinChan on 2019/11/15.
//  Copyright © 2019  MarvinChan. All rights reserved.
//

import UIKit

public typealias MDMultipleConstraints = [MDAttribute: NSLayoutConstraint]
public typealias MDAttribute = NSLayoutConstraint.Attribute
public typealias MDRelation = NSLayoutConstraint.Relation
public typealias MDPriority = UILayoutPriority

/**
 将布局优先级扩展到其他可读类型
 */
public extension MDPriority {
    static let must = MDPriority(rawValue: 999)
    static let zero = MDPriority(rawValue: 0)
}

/**
 一对属性
 */
public struct MDAttributePair {
    public let first: MDAttribute
    public let second: MDAttribute
}

/**
 尺寸约束
 */
public struct MDSizeConstraints {
    public let width: NSLayoutConstraint
    public let height: NSLayoutConstraint
}

/**
 中心约束
 */
public struct MDCenterConstraints {
    public let x: NSLayoutConstraint
    public let y: NSLayoutConstraint
}

/**
 轴约束（可能是.top和.bottom，.left和.right，.leading和.trailing）
 */
public struct MDAxisConstraints {
    public let first: NSLayoutConstraint
    public let second: NSLayoutConstraint
}

/**
 中心和大小约束
 */
public struct MDFillConstraints {
    public let center: MDCenterConstraints
    public let size: MDSizeConstraints
}

/**
 代表一对优先事项
 */
public struct MDPriorityPair {
    
    public let horizontal: MDPriority
    public let vertical: MDPriority
    public static var required: MDPriorityPair {
        return MDPriorityPair(.required, .required)
    }
    
    public static var must: MDPriorityPair {
        return MDPriorityPair(.must, .must)
    }
    
    public init(_ horizontal: MDPriority, _ vertical: MDPriority) {
        self.horizontal = horizontal
        self.vertical = vertical
    }
}

/**
 轴描述
 */
public enum MDAxis {
    case horizontally
    case vertically
    
    public var attributes: MDAttributePair {
        
        let first: MDAttribute
        let second: MDAttribute
        
        switch self {
        case .horizontally:
            first = .left
            second = .right
        case .vertically:
            first = .top
            second = .bottom
        }
        return MDAttributePair(first: first, second: second)
    }
}

