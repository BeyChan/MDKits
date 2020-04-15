//
//  MDLabel.swift
//  MDKit
//
//  Created by  MarvinChan on 2019/10/15.
//

import UIKit

open class MDLabel: UILabel {
    ///字间距
    var WordSpace: CGFloat = 0.0
    ///行间距
    var LineSpace: CGFloat = 0.0
    
    /// 是否让文本居左上
    var topText: Bool = false {
        didSet{
            if topText == true {
                self.setNeedsDisplay()
            }
        }
    }
    
    /// 重写text
    override open var text: String?{
        didSet{
            self.setNeedsDisplay()
            /// 改变 行间距 和 字间距
            let labelText = self.text ?? ""
            let attStr = NSMutableAttributedString.init(string: labelText)
            let paragraphStyle:NSMutableParagraphStyle = NSMutableParagraphStyle.init()
            paragraphStyle.lineSpacing = LineSpace
            attStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, labelText.count))
            attStr.addAttribute(NSAttributedString.Key.kern, value: WordSpace, range: NSMakeRange(0, labelText.count))
            self.attributedText = attStr
        }
    }
    
    override open func drawText(in rect: CGRect) {
        if self.text?.isEmpty == true{
            return
        }
        
        /// 绘制文本
        let size = CGSize(width:CGFloat(self.frame.width), height:CGFloat.greatestFiniteMagnitude)
        let MYRect = self.text!.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font!], context:nil)
        let Height = MYRect.size.height
        let tempRect = CGRect.init(x: 0, y: 0, width: self.frame.width, height: Height)
        
        if topText == true {
            super.drawText(in: tempRect)
        }else{
            super.drawText(in: rect)
        }
    }
    
}
