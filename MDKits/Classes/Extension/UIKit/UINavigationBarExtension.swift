//
//  UINavigationBarExtension.swift
//  MDFooBox
//
//  Created by  MarvinChan on 2019/10/15.
//  Copyright © 2019  MarvinChan. All rights reserved.
//

import UIKit

extension MDKit where Base: UINavigationBar {
    
    /// MDKit: Set Navigation Bar title, title color and font.
    ///
    /// - Parameters:
    ///   - font: title font
    ///   - color: title text color (default is .black).
    public func setTitleFont(_ font: UIFont, color: UIColor = .black) {
        var attrs = [NSAttributedString.Key: Any]()
        attrs[.font] = font
        attrs[.foregroundColor] = color
        base.titleTextAttributes = attrs
    }
    
    /// MDKit: Make navigation bar transparent.
    ///
    /// - Parameter tint: tint color (default is .white).
    public func makeTransparent(withTintColor tintColor: UIColor = .white) {
        base.isTranslucent = true
        base.backgroundColor = .clear
        base.barTintColor = .clear
        base.setBackgroundImage(UIImage(), for: .default)
        base.tintColor = tintColor
        base.titleTextAttributes = [.foregroundColor: tintColor]
        base.shadowImage = UIImage()
    }
    
    /// MDKit: Set navigationBar background and text colors
    ///
    /// - Parameters:
    ///   - background: backgound color
    ///   - text: text color
    public func setColors(background: UIColor, color: UIColor,isTranslucent: Bool = false) {
        base.isTranslucent = isTranslucent
//        base.backgroundColor = background
        base.barTintColor = background
        let image = UIImage.imageWithColor(background)
        base.setBackgroundImage(image, for: .`default`)
        base.tintColor = color
        base.titleTextAttributes = [.foregroundColor: color]
        base.shadowImage = UIImage()
    }
    
}
