//
//  MDFont.swift
//  MDFooBox
//
//  Created by  MarvinChan on 2019/10/15.
//  Copyright © 2019  MarvinChan. All rights reserved.
//

import UIKit

struct MDFont {
    static func ultraLightFont(ofSize: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: ofSize, weight: .ultraLight)
    }
    static func thinFont(ofSize: CGFloat) -> UIFont {
          return UIFont.systemFont(ofSize: ofSize, weight: .thin)
      }
    static func lightFont(ofSize: CGFloat) -> UIFont {
          return UIFont.systemFont(ofSize: ofSize, weight: .light)
      }
    static func regularFont(ofSize: CGFloat) -> UIFont {
          return UIFont.systemFont(ofSize: ofSize, weight: .regular)
      }
    static func mediumFont(ofSize: CGFloat) -> UIFont {
          return UIFont.systemFont(ofSize: ofSize, weight: .medium)
      }
    static func semiboldFont(ofSize: CGFloat) -> UIFont {
          return UIFont.systemFont(ofSize: ofSize, weight: .semibold)
      }
    static func boldFont(ofSize: CGFloat) -> UIFont {
          return UIFont.systemFont(ofSize: ofSize, weight: .bold)
      }
    static func heavyFont(ofSize: CGFloat) -> UIFont {
          return UIFont.systemFont(ofSize: ofSize, weight: .heavy)
      }
}

public extension UIFont {
    /// 常用按钮字体
    static let normalButtonFont = UIFont.systemFont(ofSize: 18)
    /// 常用文本字体
    static let normalTextFont = UIFont.systemFont(ofSize: 15)
    
    // 平方字体
    // ["PingFangSC-Medium", "PingFangSC-Semibold", "PingFangSC-Light", "PingFangSC-Ultralight", "PingFangSC-Regular", "PingFangSC-Thin"]
    /// PingFang-Medium
    static func pf_m(fontSize : CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Medium", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .medium)
    }
    /// PingFangSC-Semibold
    static func pf_s(fontSize : CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Semibold", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .semibold)
    }
    /// PingFangSC-Light
    static func pf_l(fontSize : CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Light", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .light)
    }
    /// PingFangSC-Ultralight
    static func pf_u(fontSize : CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Ultralight", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .ultraLight)
    }
    /// PingFangSC-Regular
    static func pf_r(fontSize : CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Regular", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .regular)
    }
    /// PingFangSC-Thin
    static func pf_t(fontSize : CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Thin", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .thin)
    }
    static func fontHelvetic(fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Helvetica Neue", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
}
