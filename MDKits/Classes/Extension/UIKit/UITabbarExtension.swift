//
//  UITabbarExtension.swift
//  CMYKit
//
//  Created by  MarvinChan on 2019/3/27.
//  Copyright © 2019  MarvinChan. All rights reserved.
//

import UIKit

// MARK: - Methods
extension MDKit where Base: UITabBar {
    
    /// CMYKit: Set tabBar colors.
    ///
    /// - Parameters:
    ///   - background: background color.
    ///   - selectedBackground: background color for selected tab.
    ///   - item: icon tint color for items.
    ///   - selectedItem: icon tint color for item.
    public func setColors(
        background: UIColor? = nil,
        selectedBackground: UIColor? = nil,
        item: UIColor? = nil,
        selectedItem: UIColor? = nil) {
        
        // background
        base.barTintColor = background ?? base.barTintColor
        
        // selectedItem
        base.tintColor = selectedItem ?? base.tintColor
        // shadowImage = UIImage()
        base.backgroundImage = UIImage()
        base.isTranslucent = false
        
        // selectedBackgoundColor
        guard let barItems = base.items else {
            return
        }
        
        if let selectedbg = selectedBackground {
            let rect = CGSize(width: base.frame.width/CGFloat(barItems.count), height: base.frame.height)
            base.selectionIndicatorImage = { (color: UIColor, size: CGSize) -> UIImage in
                UIGraphicsBeginImageContextWithOptions(size, false, 1)
                color.setFill()
                UIRectFill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
                guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
                UIGraphicsEndImageContext()
                guard let aCgImage = image.cgImage else { return UIImage() }
                return UIImage(cgImage: aCgImage)
            }(selectedbg, rect)
        }
        
        if let itemColor = item {
            for barItem in barItems as [UITabBarItem] {
                // item
                guard let image = barItem.image else { continue }
                
                barItem.image = { (image: UIImage, color: UIColor) -> UIImage in
                    UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
                    color.setFill()
                    guard let context = UIGraphicsGetCurrentContext() else {
                        return image
                    }
                    
                    context.translateBy(x: 0, y: image.size.height)
                    context.scaleBy(x: 1.0, y: -1.0)
                    context.setBlendMode(CGBlendMode.normal)
                    
                    let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
                    guard let mask = image.cgImage else { return image }
                    context.clip(to: rect, mask: mask)
                    context.fill(rect)
                    
                    let newImage = UIGraphicsGetImageFromCurrentImageContext()!
                    UIGraphicsEndImageContext()
                    return newImage
                    }(image, itemColor).withRenderingMode(.alwaysOriginal)
                
                barItem.setTitleTextAttributes([.foregroundColor: itemColor], for: .normal)
                if let selected = selectedItem {
                    barItem.setTitleTextAttributes([.foregroundColor: selected], for: .selected)
                }
            }
        }
    }
    
}
