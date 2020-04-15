//
//  UILabelExtension.swift
//  CMYKit
//
//  Created by  MarvinChan on 2019/3/27.
//  Copyright © 2019  MarvinChan. All rights reserved.
//

import UIKit

// MARK: - UILabel 属性扩展
struct RunTimeLabelKey {
//是否拥有复制功能
static let isCopyable = UnsafeRawPointer.init(bitPattern: "isCopyable".hashValue)
}
//MARK: -- 初始化 --
extension UILabel{
    
    /// 初始化
       ///
       /// - Parameters:
       ///   - color: 颜色
       ///   - fondSize: 大小
       ///   - TextAlignment: 位置
       convenience init(textColor:UIColor? = UIColor.black,fondSize:CGFloat?,TextAlignment:NSTextAlignment?) {
           self.init()
           self.textColor = textColor
           self.font = UIFont.systemFont(ofSize: fondSize ?? 17)
           
           let Alignment = TextAlignment ?? NSTextAlignment.left
           switch Alignment {
           case .left:
               self.textAlignment = NSTextAlignment.left
               break
           case .center:
               self.textAlignment = NSTextAlignment.center
               break
           case .right:
               self.textAlignment = NSTextAlignment.right
               break
           default:
               break
           }
       }
    /// 初始化
     ///
     /// - Parameters:
     ///   - color: 颜色
     ///   - fondSize: 大小
     ///   - TextAlignment: 位置
    convenience init(textColor:UIColor? = UIColor.black,font:UIFont?,TextAlignment:NSTextAlignment = .left) {
         self.init()
         self.textColor = textColor
         self.font = font ?? UIFont.systemFont(ofSize: 14)
         
         switch TextAlignment {
         case .left:
             self.textAlignment = NSTextAlignment.left
             break
         case .center:
             self.textAlignment = NSTextAlignment.center
             break
         case .right:
             self.textAlignment = NSTextAlignment.right
             break
         default:
             break
         }
     }
    /// 初始化
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - color: 颜色
    ///   - fondSize: 大小
    ///   - TextAlignment: 位置
    convenience init(title:String,color:UIColor? = UIColor.black,fondSize:CGFloat?,TextAlignment:NSTextAlignment?) {
        self.init()
        self.text = title
        self.textColor = color
        self.font = UIFont.systemFont(ofSize: fondSize ?? 17)
        
        let Alignment = TextAlignment ?? NSTextAlignment.left
        switch Alignment {
        case .left:
            self.textAlignment = NSTextAlignment.left
            break
        case .center:
            self.textAlignment = NSTextAlignment.center
            break
        case .right:
            self.textAlignment = NSTextAlignment.right
            break
        default:
            break
        }
    }
    
}

//MARK: -- 事件扩展 --
extension UILabel {
    
    var isCopyable: Bool? {
        set {
            objc_setAssociatedObject(self, RunTimeLabelKey.isCopyable!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            //添加长按手势
            self.isUserInteractionEnabled = true
            let LongPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressCopyEvent))
            self.addGestureRecognizer(LongPress)
            
        }
        get {
            return  objc_getAssociatedObject(self, RunTimeLabelKey.isCopyable!) as? Bool
        }
    }
    
    
    
    @objc func longPressCopyEvent(){
        // 让其成为响应者
        becomeFirstResponder()
        
        // 拿出菜单控制器单例
        let menu = UIMenuController.shared
        // 创建一个复制的item
        let copy = UIMenuItem(title: "复制", action: #selector(copyText))
        // 将复制的item交给菜单控制器（菜单控制器其实可以接受多个操作）
        menu.menuItems = [copy]
        // 设置菜单控制器的点击区域为这个控件的bounds
        menu.setTargetRect(bounds, in: self)
        // 显示菜单控制器，默认是不可见状态
        menu.setMenuVisible(true, animated: true)
        
    }
    
    @objc func copyText() {
        //  因为有时候 label 中设置的是attributedText
        //  而 UIPasteboard 的string只能接受 NSString 类型
        //  所以要做相应的判断
        
        if ((self.text) != nil) {
            UIPasteboard.general.string = self.text
        }else{
            UIPasteboard.general.string = self.attributedText?.string
        }
    }
    override open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        
        if action == #selector(copyText) {
            return true
        } else {
            return false
        }
    }
    
    /// 拥有成为响应者的能力
    open override var canBecomeFirstResponder: Bool{
        return true
    }
    
}

extension UILabel {
    
    /// 调整文字绘制区域
    public var textInset: UIEdgeInsets {
        get{
            if let eventInterval = objc_getAssociatedObject(self, UILabel.SwzzlingKeys.textInset!) as? UIEdgeInsets {
                return eventInterval
            }
            return UIEdgeInsets.zero
        }
        set {
            UILabel.swizzig()
            objc_setAssociatedObject(self,
                                     UILabel.SwzzlingKeys.textInset!,
                                     newValue as UIEdgeInsets,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            drawText(in: bounds)
        }
    }
    
    @objc fileprivate func cmy_drawText(in rect: CGRect) {
        let rect = CGRect(x: bounds.origin.x + textInset.left,
                          y: bounds.origin.y + textInset.top,
                          width: bounds.size.width - textInset.left - textInset.right,
                          height: bounds.size.height - textInset.top - textInset.bottom)
        cmy_drawText(in: rect)
    }
    
}

// MARK: - UILabel 函数扩展
extension MDKit where Base: UILabel {
    
    /// 改变字体大小 增加或者减少
    public func change(font offSet: CGFloat) {
        base.font = UIFont(name: base.font.fontName, size: base.font.pointSize + offSet)
    }
    
}

// MARK: - runtime and swizzling
fileprivate extension UILabel {
    static var once: Bool = false
    class func swizzig() {
        if once == false {
            once = true
            
            let select1 = #selector(UILabel.drawText(in:))
            let select2 = #selector(UILabel.cmy_drawText(in:))
            let classType = UILabel.self
            let select1Method = class_getInstanceMethod(classType, select1)
            let select2Method = class_getInstanceMethod(classType, select2)
            let didAddMethod  = class_addMethod(classType,
                                                select1,
                                                method_getImplementation(select2Method!),
                                                method_getTypeEncoding(select2Method!))
            if didAddMethod {
                class_replaceMethod(classType,
                                    select2,
                                    method_getImplementation(select1Method!),
                                    method_getTypeEncoding(select1Method!))
            }else {
                method_exchangeImplementations(select1Method!, select2Method!)
            }
        }
    }
    
    struct SwzzlingKeys {
        static var textInset = UnsafeRawPointer(bitPattern: "label_textInset".hashValue)
    }
}
