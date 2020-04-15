//
//  StringExtension.swift
//  CMYKit
//
//  Created by  MarvinChan on 2019/3/27.
//  Copyright © 2019  MarvinChan. All rights reserved.
//

import UIKit
// MARK: - 文本区域
extension String{
    
    /// 解析HTML样式
    ///
    /// https://github.com/Luur/SwiftTips#57-render-html-within-a-uilabel
    ///
    /// - Parameters:
    ///   - fontName: 字体名称
    ///   - fontSize: 字体大小
    ///   - colorHex: 字体颜色
    /// - Returns: 富文本
    public func htmlAttributedString(with fontName: String, fontSize: Int, colorHex: String) -> NSAttributedString? {
        do {
            let cssPrefix = "<style>* { font-family: \(fontName); color: #\(colorHex); font-size: \(fontSize); }</style>"
            let html = cssPrefix + self
            guard let data = html.data(using: String.Encoding.utf8) else {  return nil }
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    
    /// 通过hex生成Color
    public func hexColor() -> UIColor {
        return UIColor(hexString: self)
    }
    
    /// 获取字符串的Bounds
    ///
    /// - Parameters:
    ///   - font: 字体大小
    ///   - size: 字符串长宽限制
    /// - Returns: 字符串的Bounds
    public func bounds(font: UIFont,size: CGSize) -> CGRect {
        if self.isEmpty { return CGRect.zero }
        let attributes = [NSAttributedString.Key.font: font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect = self.boundingRect(with: size, options: option, attributes: attributes, context: nil)
        return rect
    }
    
    
    /// 获取字符串的Bounds
    ///
    /// - parameter font:    字体大小
    /// - parameter size:    字符串长宽限制
    /// - parameter margins: 头尾间距
    /// - parameter space:   内部间距
    ///
    /// - returns: 字符串的Bounds
    public func size(with font: UIFont,
                     size: CGSize,
                     margins: CGFloat = 0,
                     space: CGFloat = 0) -> CGSize {
        if self.isEmpty { return CGSize.zero }
        var bound = self.bounds(font: font, size: size)
        let rows = self.rows(font: font, width: size.width)
        bound.size.height += margins * 2
        bound.size.height += space * (rows - 1)
        return bound.size
    }
    
    /// 文本行数
    ///
    /// - Parameters:
    ///   - font: 字体
    ///   - width: 最大宽度
    /// - Returns: 行数
    public func rows(font: UIFont,width: CGFloat) -> CGFloat {
        if self.isEmpty { return 0 }
        // 获取单行时候的内容的size
        let singleSize = (self as NSString).size(withAttributes: [NSAttributedString.Key.font:font])
        // 获取多行时候,文字的size
        let textSize = self.bounds(font: font, size: CGSize(width: width, height: CGFloat(MAXFLOAT))).size
        // 返回计算的行数
        return ceil(textSize.height / singleSize.height);
    }
    
}

//MARK:-- 字符串的拆分 --
extension String{
    
    ///  字符串的截取
    public func subStringFrom(index: Int,length:Int) -> String {
        if self.count > index {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let endIndex = self.index(self.startIndex, offsetBy: index+length)
            
            let subString = self[startIndex..<endIndex]
            return String(subString)
        } else {
            return self
        }
    }
    ///  字符串的截取
    func substring(from: Int, to: Int) -> String
    {
        let fromIndex = index(startIndex, offsetBy: from)
        let toIndex = index(startIndex, offsetBy: to)
        
        guard fromIndex >= startIndex, fromIndex < toIndex, toIndex <= endIndex else { return "" }
        
        return String(self[fromIndex ..< toIndex])
    }
    ///  字符串的截取
    public func substring(from: Int?, to: Int?) -> String
    {
        return substring(from: from ?? 0, to: to ?? count)
    }
    ///  字符串的截取
    func substring(from: Int) -> String
    {
        return substring(from: from, to: nil)
    }
    ///  字符串的截取
    func substring(to: Int) -> String
    {
        return substring(from: nil, to: to)
    }
    
    ///替换指定范围内的字符串
    mutating func stringByReplacingCharactersInRange(index:Int,length:Int,replacText:String) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: index)
        self.replaceSubrange(startIndex..<self.index(startIndex, offsetBy: length), with: replacText)
        return self
    }
    /// 替换指定字符串
    mutating func stringByReplacingstringByReplacingString(text:String,replacText:String) -> String {
        return self.replacingOccurrences(of: text, with: replacText)
    }
    
    ///删除最后一个字符
    mutating func deleteEndCharacters() -> String {
        self.remove(at: self.index(before: self.endIndex))
        return self
    }
    /// 删除指定字符串
    mutating func deleteString(string:String) -> String {
        return self.replacingOccurrences(of: string, with: "")
    }
    
    
    /// 将字符串通过特定的字符串拆分为字符串数组
    ///
    /// - Parameter string: 拆分数组使用的字符串
    /// - Returns: 字符串数组
    func split(string:String) -> [String] {
        return NSString(string: self).components(separatedBy: string)
    }
    
}

//MARK: -- 类型判断 --
extension String{
    /// URL编码
    public var urlEncoded: String {
        let characterSet = CharacterSet(charactersIn: ":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`")
        return self.addingPercentEncoding(withAllowedCharacters: characterSet)!
        
    }
    /// URL解码
    public var urlDecode: String? {
        return self.removingPercentEncoding
    }
    
    /// base64编码
    var base64: String {
        let plainData = (self as NSString).data(using: String.Encoding.utf8.rawValue)
        let base64String = plainData!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        return base64String
    }
    /// Base64解码
    public var base64Decode: String? {
        
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    ///是否是邮箱
    public var isEmail: Bool {
        return range(of: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .regularExpression, range: nil, locale: nil) != nil }
    /// 是否是URL
    public var isValidUrl: Bool {
        return URL(string: self) != nil }
    /// 是否是手机号
    public var isMobile: Bool {
        /// https://www.jianshu.com/p/5fbb85967bfd
        /// 非严格匹配
        if let _ = self.range(of: "^(13[0-9]|14[5-9]|15[0-3,5-9]|16[2,5,6,7]|17[0-8]|18[0-9]|19[0-3,5-9])\\d{8}$", options: .regularExpression) {
            return true
        }
        
        return false
    }
    /// 是否是字母数字的组合
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
}

//MARK: -- 将字符串替换成值类型 --
extension String{
    
    ///变成Int 类型
    public func toInt() -> Int? {
        if let num = NumberFormatter().number(from: self) {
            return num.intValue
        } else {
            return nil
        }
    }
    /// 变成Double 类型
    public func toDouble() -> Double? {
        if let num = NumberFormatter().number(from: self) {
            return num.doubleValue
        } else {
            return nil
        }
    }
    /// 变成Float 类型
    public func toFloat() -> Float? {
        if let num = NumberFormatter().number(from: self) {
            return num.floatValue
        } else {
            return nil
        }
    }
    /// 变成D
    public func toDecimal() -> NSDecimalNumber {
        let num = NSDecimalNumber(string: self)
        if num == NSDecimalNumber.notANumber {
            return 0
        }
        return num
    }
}

//MARK:-- 获取文本的宽高 --
extension String{
    /// 获取文本高度
    ///
    /// - Parameters:
    ///   - font: font
    ///   - fixedWidth: fixedWidth
    func obtainTextHeight(font : UIFont = UIFont.systemFont(ofSize: 18), fixedWidth : CGFloat) -> CGFloat {
        
        guard self.count > 0 && fixedWidth > 0 else {
            return 0
        }
        
        let size = CGSize(width:fixedWidth, height:CGFloat.greatestFiniteMagnitude)
        let text = self as NSString
        let rect = text.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context:nil)
        
        return rect.size.height
    }
    
    
    /// 获取文本宽度
    ///
    /// - Parameter font: font
    func obtainTextWidth(font : UIFont = UIFont.systemFont(ofSize: 17)) -> CGFloat {
        
        guard self.count > 0 else {
            return 0
        }
        
        let size = CGSize(width:CGFloat.greatestFiniteMagnitude, height:0)
        let text = self as NSString
        let rect = text.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context:nil)
        
        return rect.size.width
    }
    
}


extension String {
    public func getFirstMatchedString(by regularExpression : String, rangeName : String? = nil) -> String? {
        let regularExpression = try! NSRegularExpression.init(pattern: regularExpression,
                                                              options: .caseInsensitive)
        let result = regularExpression.matches(in: self,
                                               options: .reportProgress,
                                               range: NSRange(location: 0, length: count))
        if (result.first?.numberOfRanges ?? 0) > 1 {
            if #available(iOS 11.0, *) {
                if let rangeName = rangeName {
                    if let range = result.first?.range(withName: rangeName) {
                        return NSString(string: self).substring(with: range)
                    }
                }
            }
            if let range = result.first?.range(at: 1) {
                return NSString(string: self).substring(with: range)
            }
        }
        return nil
    }

    public func matches(by regularExpression : String) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", regularExpression).evaluate(with: self)
    }
    public func canOpenAsURL() -> Bool {
        guard let url = URL(string: self), UIApplication.shared.canOpenURL(url) else {
            return false
        }
        return true
    }
}
