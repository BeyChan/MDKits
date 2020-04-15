//
//  UIImageViewExtension.swift
//  CMYKit
//
//  Created by  MarvinChan on 2019/3/27.
//  Copyright © 2019  MarvinChan. All rights reserved.
//

import UIKit

// MARK: - UILabel 函数扩展
extension MDKit where Base: UIImageView {
    
    /// 从网络上下载图片
    ///
    /// - Parameters:
    ///   - url: url
    ///   - contentMode: 内容模式
    ///   - placeholder: 占位图片
    ///   - completionHandler: 完成回调
    public func download(from url: URL,
                         contentMode: UIView.ContentMode = .scaleAspectFit,
                         placeholder: UIImage? = nil,
                         completionHandler: ((UIImage?) -> Void)? = nil) {
        
        base.image = placeholder
        base.contentMode = contentMode
        URLSession.shared.dataTask(with: url) { (data, response, _) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data,
                let image = UIImage(data: data)
                else {
                    completionHandler?(nil)
                    return
            }
            DispatchQueue.main.async {
                self.base.image = image
                completionHandler?(image)
            }
            }.resume()
    }
    
    
    /// 毛玻璃效果
    ///
    /// - Parameter style: 毛玻璃样式
    public func blur(withStyle style: UIBlurEffect.Style = .light) {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = base.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        base.addSubview(blurEffectView)
        base.clipsToBounds = true
    }
    
    
    /// 毛玻璃效果
    ///
    /// - Parameter style: 毛玻璃样式[[
    public func blurred(withStyle style: UIBlurEffect.Style = .light) -> UIImageView {
        blur(withStyle: style)
        return base
    }
    
}

