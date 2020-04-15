//
//  UIView+Anchors.swift
//  MDFooBox
//
//  Created by  MarvinChan on 2019/10/21.
//  Copyright © 2019  MarvinChan. All rights reserved.
//

import Foundation

extension NSLayoutDimension {
    @discardableResult
    @objc func equalTo(c: CGFloat,
                       priority: UILayoutPriority = UILayoutPriority.required,
                       isActive: Bool = true) -> NSLayoutConstraint {
        let constraint = self.constraint(equalToConstant: c)
        constraint.priority = priority
        constraint.isActive = isActive
        return constraint
    }
    @discardableResult
    @objc func equalTo(anchor: NSLayoutDimension,
                       constant c: CGFloat,
                       mutiplier m: CGFloat = 1.0,
                       priority: UILayoutPriority = UILayoutPriority.required,
                       isActive: Bool = true) -> NSLayoutConstraint {
        let constraint = self.constraint(equalTo: anchor, multiplier: m, constant: c)
        constraint.priority = priority
        constraint.isActive = isActive
        return constraint
    }
    @discardableResult
    @objc func greaterThanOrEqualTo(c: CGFloat,
                                    priority: UILayoutPriority = UILayoutPriority.required,
                                    isActive: Bool = true) -> NSLayoutConstraint {
        let constraint = self.constraint(greaterThanOrEqualToConstant: c)
        constraint.priority = priority
        constraint.isActive = isActive
        return constraint
    }
    @discardableResult
    @objc func greaterThanOrEqualTo(anchor: NSLayoutDimension,
                                    constant c: CGFloat = 0,
                                    mutiplier m: CGFloat = 1.0,
                                    priority: UILayoutPriority = UILayoutPriority.required,
                                    isActive: Bool = true) -> NSLayoutConstraint {
        let constraint = self.constraint(greaterThanOrEqualTo: anchor, multiplier: m, constant: c)
        constraint.priority = priority
        constraint.isActive = isActive
        return constraint
    }
    @discardableResult
    @objc func lessThanOrEqualTo(c: CGFloat,
                                 priority: UILayoutPriority = UILayoutPriority.required,
                                 isActive: Bool = true) -> NSLayoutConstraint {
        let constraint = self.constraint(lessThanOrEqualToConstant: c)
        constraint.priority = priority
        constraint.isActive = isActive
        return constraint
    }
    @discardableResult
    @objc func lessThanOrEqualTo(anchor: NSLayoutDimension,
                                 constant c: CGFloat = 0,
                                 mutiplier m: CGFloat = 1.0,
                                 priority: UILayoutPriority = UILayoutPriority.required,
                                 isActive: Bool = true) -> NSLayoutConstraint {
        let constraint = self.constraint(lessThanOrEqualTo: anchor, multiplier: m, constant: c)
        constraint.priority = priority
        constraint.isActive = isActive
        return constraint
    }
}

extension NSLayoutAnchor {
    
    @discardableResult
    @objc func equalTo(anchor: NSLayoutAnchor,
                       constant: CGFloat = 0) -> NSLayoutConstraint {
        return self.equalTo(anchor: anchor, constant: constant, priority: .required, isActive: true)
    }
    
    @discardableResult
    @objc func greaterThanOrEqualTo(anchor: NSLayoutAnchor,
                                    constant: CGFloat = 0) -> NSLayoutConstraint {
        return self.greaterThanOrEqualTo(anchor: anchor, constant: constant, priority: .required, isActive: true)
    }
    
    @discardableResult
    @objc func lessThanOrEqualTo(anchor: NSLayoutAnchor,
                                 constant: CGFloat = 0) -> NSLayoutConstraint {
        return self.lessThanOrEqualTo(anchor: anchor, constant: constant, priority: .required, isActive: true)
    }
    
    @discardableResult
    @objc func equalTo(anchor: NSLayoutAnchor,
                       constant: CGFloat = 0,
                       priority: UILayoutPriority = UILayoutPriority.required,
                       isActive: Bool = true) -> NSLayoutConstraint {
        let constraint = self.constraint(equalTo: anchor, constant: constant)
        constraint.priority = priority
        constraint.isActive = isActive
        return constraint
    }
    
    @discardableResult
    @objc func greaterThanOrEqualTo(anchor: NSLayoutAnchor,constant: CGFloat = 0,
                                    priority: UILayoutPriority = UILayoutPriority.required,
                                    isActive: Bool = true) -> NSLayoutConstraint {
        let constraint = self.constraint(greaterThanOrEqualTo: anchor, constant: constant)
        constraint.priority = priority
        constraint.isActive = isActive
        return constraint
    }
    
    @discardableResult
    @objc func lessThanOrEqualTo(anchor: NSLayoutAnchor,
                                 constant: CGFloat = 0,
                                 priority: UILayoutPriority = UILayoutPriority.required,
                                 isActive: Bool = true) -> NSLayoutConstraint {
        let constraint = self.constraint(lessThanOrEqualTo: anchor, constant: constant)
        constraint.priority = priority
        constraint.isActive = isActive
        return constraint
    }
    
    
}
