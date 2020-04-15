//
//  MDColor.swift
//  MDFooBox
//
//  Created by  MarvinChan on 2019/10/15.
//  Copyright © 2019  MarvinChan. All rights reserved.
//

import UIKit

struct MDColor {
    
    static var normalWhite: UIColor = .white
    
    static var textPrimary: UIColor {
        return dynamicColorIfAvailable(defaultColor: UIColor(hexString: "#333333"), darkModeColor: UIColor(hexString: "#1B1B24"))
    }
    
    static var bgPrimary: UIColor {
        return dynamicColorIfAvailable(defaultColor: MDColor.milk, darkModeColor: UIColor(hexString: "#1B1B24"))
    }
    
    static var awardPrimary: UIColor {
        return UIColor(hexString: "#100036")
    }
    
    static var textWhite: UIColor = UIColor(hexString: "#FFFFFF")
    
    static var primaryColor: UIColor {
        return UIColor(hexString: "#FA700B")
    }
    
    static var primaryBackgroundColor = UIColor.white
    
    static var normalGray = UIColor(hexString: "#BABABA")
    
    static var normalBlack = UIColor(hexString: "#000000")
    
    static var lightBlack = UIColor(hexString: "#666666")
    
    static var lightGray = UIColor(hexString: "#999999")
    
    static var lineColor = UIColor(hexString: "#EEEEEE")
    
    static var awardTitleColor = UIColor(hexString: "#792B0D")
    
    static var wechatColor = UIColor(hexString: "#01BC0D")
    
    static var bgGrayColor = UIColor(hexString: "#F5F5F5")
    
    static var priceColor = UIColor(hexString: "#FC4747")
}

extension MDColor {

    public static var milk: UIColor {
        return UIColor(r: 255, g: 255, b: 255)
    }

}



// MARK: - Private helper for creating dynamic color
extension MDColor {
    private static func dynamicColorIfAvailable(defaultColor: UIColor, darkModeColor: UIColor) -> UIColor {
        switch MDUIManager.userInterfaceStyleSupport {
        case .forceDark:
            return darkModeColor
        case .forceLight:
            return defaultColor
        case .dynamic:
            if #available(iOS 13.0, *) {
                #if swift(>=5.1)
                return UIColor { traitCollection -> UIColor in
                    switch traitCollection.userInterfaceStyle {
                    case .dark:
                        return darkModeColor
                    default:
                        return defaultColor
                    }
                }
                #endif
            }
            return defaultColor
        }
    }
}
