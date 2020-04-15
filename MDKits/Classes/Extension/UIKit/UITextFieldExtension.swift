//
//  UITextFieldExtension.swift
//  CMYKit
//
//  Created by  MarvinChan on 2019/3/27.
//  Copyright © 2019  MarvinChan. All rights reserved.
//

import UIKit

struct RunTimeTextFieldKey {
    ///最大数量
    static let maxCount = UnsafeRawPointer.init(bitPattern: "maxCount".hashValue)
}
extension UITextField {
    //最大数量
    var maxCount: Int? {
        set {
            objc_setAssociatedObject(self, RunTimeTextFieldKey.maxCount!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            //添加监听
            self.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
        get {
            return  objc_getAssociatedObject(self, RunTimeTextFieldKey.maxCount!) as? Int
        }
    }
    
    ///文本变化时的监听
    @objc func textFieldDidChange(){
        //最大数量限制
        let count = self.maxCount ?? 0
        if count > 0 {
            setMAXCountNumber()
        }
    }
    
    //最大数量限制
    private func setMAXCountNumber() {
        let TFText = self.text ?? ""
        let count = TFText.count
        if count > self.maxCount!  {
            self.text = stringByReplacing(textString: TFText, index: self.maxCount!, length: count-self.maxCount!, replacText: "")
        }
    }
    
    //字符串的替换
    private func stringByReplacing(textString:String,index:Int,length:Int,replacText:String) -> String {
        var TEXT = textString
        let startIndex = textString.index(textString.startIndex, offsetBy: index)
        TEXT.replaceSubrange(startIndex..<TEXT.index(startIndex, offsetBy: length), with: replacText)
        
        return TEXT
    }
}

extension MDKit where Base: UITextField {

    /// 占位文字颜色
    public var placeholderColor: UIColor? {
        get{
            guard let attr = base.attributedPlaceholder?.attributes(at: 0, effectiveRange: nil),
                let color = attr[NSAttributedString.Key.foregroundColor] as? UIColor else{ return base.textColor }
            return color
        }
        set {
            guard let placeholder = base.placeholder, let color = newValue else { return }
            if var attr = base.attributedPlaceholder?.attributes(at: 0, effectiveRange: nil) {
                attr[NSAttributedString.Key.foregroundColor] = newValue
                base.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attr)
                return
            }
            
            let attr = [NSAttributedString.Key.foregroundColor: color]
            base.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attr)
        }
    }
    
    /// 占位文字字体
    public var placeholderFont: UIFont? {
        get{
            guard let attr = base.attributedPlaceholder?.attributes(at: 0, effectiveRange: nil),
                let ft = attr[.font] as? UIFont else{ return base.font }
            return ft
        }
        set {
            guard let placeholder = base.placeholder, let font = newValue else { return }
            if var attr = base.attributedPlaceholder?.attributes(at: 0, effectiveRange: nil) {
                attr[NSAttributedString.Key.font] = newValue
                base.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attr)
                return
            }
            let attr = [NSAttributedString.Key.font: font]
            base.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attr)
        }
    }
    
    
    /// 左边间距
    var leftPadding: CGFloat {
        get {
            return base.leftView?.frame.size.width ?? 0
        }
        set {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: base.frame.size.height))
            base.leftView = view
            base.leftViewMode = .always
        }
    }
    
    /// 右边间距
    var rightPadding: CGFloat {
        get {
            return base.rightView?.frame.size.width ?? 0
        }
        set {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: base.frame.size.height))
            base.rightView = view
            base.rightViewMode = .always
        }
    }
    
    
    
    /// 设置左边icon
    public func addPaddingLeftIcon(_ image: UIImage, padding: CGFloat) {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
        base.leftView = imageView
        base.leftView?.frame.size = CGSize(width: image.size.width + padding, height: image.size.height)
        base.leftViewMode = .always
    }
    
}

