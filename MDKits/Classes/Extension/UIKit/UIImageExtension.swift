//
//  UIImageExtension.swift
//  MDKit
//
//  Created by  MarvinChan on 2019/10/14.
//

import UIKit
import CoreMedia

extension UIImage{
    /// from CMSampleBuffer
    ///
    /// must import CoreMedia
    /// from: https://stackoverflow.com/questions/15726761/make-an-uiimage-from-a-cmsamplebuffer
    ///
    /// - Parameter sampleBuffer: CMSampleBuffer
    public convenience init?(sampleBuffer: CMSampleBuffer) {
        // Get a CMSampleBuffer's Core Video image buffer for the media data
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
        // Lock the base address of the pixel buffer
        CVPixelBufferLockBaseAddress(imageBuffer, .readOnly)
        // Get the number of bytes per row for the pixel buffer
        let baseAddress = CVPixelBufferGetBaseAddress(imageBuffer)
        // Get the number of bytes per row for the pixel buffer
        let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer)
        // Get the pixel buffer width and height
        let width = CVPixelBufferGetWidth(imageBuffer)
        let height = CVPixelBufferGetHeight(imageBuffer)
        // Create a device-dependent RGB color space
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        // Create a bitmap graphics context with the sample buffer data
        var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Little.rawValue
        bitmapInfo |= CGImageAlphaInfo.premultipliedFirst.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        
        //let bitmapInfo: UInt32 = CGBitmapInfo.alphaInfoMask.rawValue
        // Create a Quartz image from the pixel data in the bitmap graphics context
        guard let context = CGContext(data: baseAddress,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: 8,
                                      bytesPerRow: bytesPerRow,
                                      space: colorSpace,
                                      bitmapInfo: bitmapInfo),
            let quartzImage = context.makeImage() else { return nil }
        // Unlock the pixel buffer
        CVPixelBufferUnlockBaseAddress(imageBuffer, .readOnly)
        // Create an image object from the Quartz image
        self.init(cgImage: quartzImage)
    }
    
}


// MARK: - 初始化
extension UIImage{
    
    /// 获取指定颜色的图片
    /// - Parameter color: UIColor
    public static func imageWithColor(_ color:UIColor) -> UIImage {
         let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
         UIGraphicsBeginImageContext(rect.size)
         let context = UIGraphicsGetCurrentContext()
         context!.setFillColor(color.cgColor)
         context!.fill(rect)
         let image = UIGraphicsGetImageFromCurrentImageContext()
         UIGraphicsEndImageContext()
         return image!
     }
    /// 获取指定颜色的图片
    ///
    /// - Parameters:
    ///   - color: UIColor
    ///   - size: 图片大小
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        if size.width <= 0 || size.height <= 0 { return nil }
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let cgImg = image?.cgImage else { return nil }
        self.init(cgImage: cgImg)
    }
    
}


// MARK: - UIImage
extension MDKit where Base: UIImage{
    
    /// 图片尺寸: Bytes
    public var sizeAsBytes: Int
    {
        return base.jpegData(compressionQuality: 1)?.count ?? 0
    }
    
    /// 图片尺寸: KB
    public var sizeAsKB: Int {
        let sizeAsBytes = self.sizeAsBytes
        return sizeAsBytes != 0 ? sizeAsBytes / 1024: 0 }
    
    /// 图片尺寸: MB
    public var sizeAsMB: Int {
        let sizeAsKB = self.sizeAsKB
        return sizeAsBytes != 0 ? sizeAsKB / 1024: 0 }
    
}

// MARK: - UIImage
extension MDKit where Base: UIImage{
    /// 返回一张没有被渲染图片
    public var original: UIImage { return base.withRenderingMode(.alwaysOriginal) }
    /// 返回一张可被渲染图片
    public var template: UIImage { return base.withRenderingMode(.alwaysTemplate) }
}

extension MDKit where Base: UIImage{
    
    /// 修改单色系图片颜色
    ///
    /// - Parameter color: 颜色
    /// - Returns: 新图
    public func setTint(color: UIColor) -> UIImage {
        return self.setTint(color: color, blendMode: .destinationIn)
    }
    
    
    /// 设置有梯度的图片颜色
    /// - Parameter color: 颜色
    public func setGradientTint(color: UIColor) -> UIImage {
        return self.setTint(color: color, blendMode: .overlay)
    }
    
    
    /// 修改图片颜色
    /// - Parameter color: 颜色
    /// - Parameter blendMode: 模式
    public func setTint(color: UIColor, blendMode: CGBlendMode) -> UIImage
    {
        let bounds = CGRect(x: 0, y: 0, width: base.size.width, height: base.size.height)
        UIGraphicsBeginImageContextWithOptions(base.size, false, base.scale)
        color.setFill()
        UIRectFill(bounds)
        base.draw(in: bounds, blendMode: blendMode, alpha: 1.0)
        if blendMode != .destinationIn {
            base.draw(in: bounds, blendMode: .destinationIn, alpha: 1)
        }
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return tintedImage ?? base
    }
    
}

// MARK: - UIImage 图片处理
extension MDKit where Base: UIImage{
    
    /// 裁剪对应区域
    ///
    /// - Parameter bound: 裁剪区域
    /// - Returns: 新图
    public func crop(bound: CGRect) -> UIImage {
        let scaledBounds = CGRect(x: bound.origin.x * base.scale,
                                  y: bound.origin.y * base.scale,
                                  width: bound.size.width * base.scale,
                                  height: bound.size.height * base.scale)
        guard let cgImage = base.cgImage?.cropping(to: scaledBounds) else { return base }
        return UIImage(cgImage: cgImage, scale: base.scale, orientation: .up)
    }
    
    /// 返回圆形图片
    public func rounded() -> UIImage {
        return base.md.rounded(radius: base.size.height * 0.5,
                               corners: .allCorners,
                               borderWidth: 0,
                               borderColor: nil,
                               borderLineJoin: .miter)
    }
    
    /// 图像处理: 裁圆
    /// - Parameters:
    /// - radius: 圆角大小
    /// - corners: 圆角区域
    /// - borderWidth: 描边大小
    /// - borderColor: 描边颜色
    /// - borderLineJoin: 描边类型
    /// - Returns: 新图
    public func rounded(radius: CGFloat,
                        corners: UIRectCorner = .allCorners,
                        borderWidth: CGFloat = 0,
                        borderColor: UIColor? = nil,
                        borderLineJoin: CGLineJoin = .miter) -> UIImage {
        var corners = corners
        if corners != UIRectCorner.allCorners {
            var rawValue: UInt = 0
            if (corners.rawValue & UIRectCorner.topLeft.rawValue) != 0
            { rawValue = rawValue | UIRectCorner.bottomLeft.rawValue }
            if (corners.rawValue & UIRectCorner.topRight.rawValue) != 0
            { rawValue = rawValue | UIRectCorner.bottomRight.rawValue }
            if (corners.rawValue & UIRectCorner.bottomLeft.rawValue) != 0
            { rawValue = rawValue | UIRectCorner.topLeft.rawValue }
            if (corners.rawValue & UIRectCorner.bottomRight.rawValue) != 0
            { rawValue = rawValue | UIRectCorner.topRight.rawValue }
            corners = UIRectCorner(rawValue: rawValue)
        }
        UIGraphicsBeginImageContextWithOptions(base.size, false, base.scale)
        defer { UIGraphicsEndImageContext() }
        
        guard let context = UIGraphicsGetCurrentContext() else { return base }
        let rect = CGRect(x: 0, y: 0, width: base.size.width, height: base.size.height)
        context.scaleBy(x: 1, y: -1)
        context.translateBy(x: 0, y: -rect.height)
        let minSize = min(base.size.width, base.size.height)
        
        if borderWidth < minSize * 0.5{
            let path = UIBezierPath(roundedRect: rect.insetBy(dx: borderWidth, dy: borderWidth),
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: borderWidth))
            
            path.close()
            context.saveGState()
            path.addClip()
            guard let cgImage = base.cgImage else { return base }
            context.draw(cgImage, in: rect)
            context.restoreGState()
        }
        
        if (borderColor != nil && borderWidth < minSize / 2 && borderWidth > 0) {
            let strokeInset = (floor(borderWidth * base.scale) + 0.5) / base.scale
            let strokeRect = rect.insetBy(dx: strokeInset, dy: strokeInset)
            let strokeRadius = radius > base.scale / 2 ? CGFloat(radius - base.scale / 2): 0
            let path = UIBezierPath(roundedRect: strokeRect, byRoundingCorners: corners, cornerRadii: CGSize(width: strokeRadius, height: borderWidth))
            path.close()
            path.lineWidth = borderWidth
            path.lineJoinStyle = borderLineJoin
            borderColor?.setStroke()
            path.stroke()
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image ?? base
    }
    
    
    /// 缩放至指定高度
    ///
    /// - Parameters:
    ///   - toWidth: 高度
    ///   - opaque: 透明开关，如果图形完全不用透明，设置为YES以优化位图的存储
    /// - Returns: 新的图片
    public func scaled(toHeight: CGFloat, opaque: Bool = false) -> UIImage? {
        let scale = toHeight / base.size.height
        let newWidth = base.size.width * scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: toHeight), opaque, 0)
        base.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: toHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
    /// 缩放至指定宽度
    ///
    /// - Parameters:
    ///   - toWidth: 宽度
    ///   - opaque: 透明开关，如果图形完全不用透明，设置为YES以优化位图的存储
    /// - Returns: 新的图片
    public func scaled(toWidth: CGFloat, opaque: Bool = false) -> UIImage? {
        let scale = toWidth / base.size.width
        let newHeight = base.size.height * scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: toWidth, height: newHeight), opaque, 0)
        base.draw(in: CGRect(x: 0, y: 0, width: toWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
}
