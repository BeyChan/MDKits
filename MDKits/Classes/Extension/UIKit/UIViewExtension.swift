//
//  UIViewExtension.swift
//  MDKit
//
//  Created by  MarvinChan on 2019/10/14.
//

import UIKit

public extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }

    @IBInspectable var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }

    @IBInspectable var borderColor: UIColor {
        get { return UIColor(cgColor: layer.borderColor ?? UIColor.clear.cgColor) }
        set { layer.borderColor = newValue.cgColor }
    }
    @IBInspectable var masksToBounds: Bool {
        get { return layer.masksToBounds}
        set { layer.masksToBounds = newValue }
    }
    
    /// 背景图片
    @IBInspectable var cgImage: UIImage {
        get{
            guard let temp: Any = self.layer.contents else {
                return UIImage()
            }
            return UIImage.init(cgImage: temp as! CGImage)
        }
        set { self.layer.contents = newValue.cgImage }
    }
    
       
       /// 切圆角
       ///
       /// - Parameters:
       ///   - radii: 半径
       ///   - borderWidth: 边缘宽度
       ///   - borderColor: 边缘颜色
       func cutCornerRadius(_ radii: CGFloat,borderWidth: CGFloat = 0,borderColor: UIColor = .clear) {
           self.layer.cornerRadius = radii
           self.layer.masksToBounds = true
           self.layer.borderWidth = borderWidth
           self.layer.borderColor = borderColor.cgColor
       }
       /// 部分圆角
       ///
       /// - Parameters:
       ///   - corners: 需要实现为圆角的角，可传入多个
       ///   - radii: 圆角半径
       func cutCorner(byRoundingCorners corners: UIRectCorner, radii: CGFloat) {
           let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
           let maskLayer = CAShapeLayer()
           maskLayer.frame = self.bounds
           maskLayer.path = maskPath.cgPath
           self.layer.mask = maskLayer
    
       }
}

// MARK: - UIView 属性扩展
extension MDKit where Base: UIView{
    
    /** 返回视图所在的视图控制器
     
     示例:
     
     ```
     let vc = UIView().md.viewController
     ```
     
     */
    public var viewController: UIViewController? {
        weak var parentResponder: UIResponder? = base
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    /** 视图中层级关系描述
     
     示例:
     
     ```
     <UIView; frame = (15 74; 345 201); autoresize = RM+BM; layer = <CALayer>>
     | <UIView; frame = (8 8; 185 185); autoresize = RM+BM; layer = <CALayer>>
     |    | <UIView; frame = (8 8; 169 76.5); autoresize = RM+BM; layer = <CALayer>>
     |    |    | <UIButton; frame = (8 8; 153 30); opaque = NO; autoresize = RM+BM; layer = <CALayer>>
     |    | <UIView; frame = (8 100.5; 169 76.5); autoresize = RM+BM; layer = <CALayer>>
     | <UIView; frame = (201 8; 136 185); autoresize = RM+BM; layer = <CALayer>>
     |    | <UILabel; frame = (8 8; 120 21); text = 'Label'; opaque = NO; autoresize = RM+BM; userInteractionEnabled = NO; layer = <_UILabelLayer>
     ```
     
     */
    public var description: String {
        let recursiveDescription = base
            .perform(Selector(("recursiveDescription")))?
            .takeUnretainedValue() as! String
        return recursiveDescription.replacingOccurrences(of: ":?\\s*0x[\\da-f]+(\\s*)",
                                                         with: "$1",
                                                         options: .regularExpression)
    }
    
    /** 获取视图显示内容
     
     示例:
     
     ```
     UIImageView(image: UIView().md.snapshot)
     ```
     */
    public var snapshot: UIImage? {
        UIGraphicsBeginImageContextWithOptions(base.bounds.size, base.isOpaque, 0)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        base.layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    /// 设置LayerShadow,offset,radius
    public func setShadow(color: UIColor, offset: CGSize,radius: CGFloat) {
        base.layer.shadowColor = color.cgColor
        base.layer.shadowOffset = offset
        base.layer.shadowRadius = radius
        base.layer.shadowOpacity = 1
        base.layer.shouldRasterize = true
        base.layer.rasterizationScale = UIScreen.main.scale
    }
    
    /**
     * 毛玻璃效果
     * view.md.blurEffect(UIColor(white: 0, alpha: 0.3), style: .light) { (blurV) in
     * let tap = UITapGestureRecognizer(target: self, action: #selector(self.back))
     * blurV.addGestureRecognizer(tap)}
     */
    @discardableResult
    func blurEffect(_ color:UIColor = UIColor.clear,  style:UIBlurEffect.Style = .light, block:((UIVisualEffectView) -> Void)? = nil) -> MDKit {
        base.layoutIfNeeded()
        base.backgroundColor = UIColor.clear
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.backgroundColor = color
        blurEffectView.frame = base.bounds
        base.addSubview(blurEffectView)
        base.sendSubviewToBack(blurEffectView)
        block?(blurEffectView)
        return self
    }
    
    /// 渐变色
    /// 背景线性渐变 默认横向渐变 point -> 0 - 1
    /// let gradients:[(UIColor,Float)] = [(UIColor.red,0),(UIColor.yellow,1)]
    /// view.md.gradient(layer: gradients)
    /// 文字渐变 view.gradient(layerAxial: ..., then:{ layer in layer.mask = label.layer })
    @discardableResult
    func gradient(layerAxial gradients:[(color:UIColor,location:CGFloat)], point:(start:CGPoint, end:CGPoint) = (start:CGPoint(x: 0, y: 0), end:CGPoint(x: 1, y: 0)), at: UInt32 = 0, updateIndex:Int? = nil, then:((CAGradientLayer)->Void)? = nil) -> MDKit {
        
        func gradient(_ layer:CAGradientLayer) {
            base.layoutIfNeeded()
            layer.colors = gradients.map{$0.color.cgColor}
            layer.locations = gradients.map{NSNumber(value:$0.location.float)}
            layer.startPoint = point.start
            layer.endPoint = point.end
            layer.frame = base.bounds
        }
        
        let layers:[CAGradientLayer] = base.layer.sublayers?.filter{$0.isKind(of: CAGradientLayer.self)}.map{$0} as? [CAGradientLayer] ?? []
        if layers.count <= at {
            let layer = CAGradientLayer()
            gradient(layer)
            base.layer.insertSublayer(layer, at: at)
            then?(layer)
        }else{
            let layer = layers[updateIndex ?? 0]
            gradient(layers[updateIndex ?? 0])
            then?(layer)
        }
        return self
    }
    /// 放射性渐变
    open class MD_GradientLayer:CALayer {
        open var point: CGPoint = CGPoint.zero
        open var colorSpace = CGColorSpaceCreateDeviceRGB()
        open var locations:[CGFloat] = [0.0, 1.0]
        open var colors:[CGFloat] = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0]
        open lazy var radius: CGFloat = {
            return Swift.max(self.bounds.size.width, self.bounds.size.height)
        }()
        override open func draw(in ctx: CGContext) {
            guard let gradient = CGGradient(colorSpace: colorSpace, colorComponents: colors, locations: locations, count: locations.count) else {
                return
            }
            ctx.drawRadialGradient(gradient, startCenter: point, startRadius: 0, endCenter: point, endRadius: radius, options: .drawsAfterEndLocation)
        }
    }
    /// 背景放射性渐变
    /// 渐变色
    /// 背景线性渐变 默认横向渐变 point -> 0 - 1
    /// let gradients:[(UIColor,Float)] = [(UIColor.red,0),(UIColor.yellow,1)]
    /// view.md.gradient(layer: gradients)
    /// 文字渐变 view.gradient(layerRadial: ..., then:{ layer in layer.mask = label.layer })
    @discardableResult
    func gradient(layerRadial gradients:[(color:UIColor,location:CGFloat)], point:CGPoint = CGPoint(x: 0, y: 0), radius:CGFloat? = nil, at: UInt32 = 0, updateIndex:Int? = nil, then:((MD_GradientLayer)->Void)? = nil) -> MDKit {
        func gradient(_ layer:MD_GradientLayer) {
            base.layoutIfNeeded()
            layer.locations = gradients.map{$0.location}
            layer.colors =  Array(gradients.map({ (c) -> [CGFloat] in
                let cc = c.color.md_rgba
                return [cc.0,cc.1,cc.2,cc.3]
            }).joined())
            layer.frame = base.bounds
            layer.point = point
            layer.radius = radius ?? Swift.max(base.bounds.size.width, base.bounds.size.height)
            layer.setNeedsDisplay()
        }
        
        let layers:[MD_GradientLayer] = base.layer.sublayers?.filter{$0.isKind(of: MD_GradientLayer.self)}.map{$0} as? [MD_GradientLayer] ?? []
        if layers.count <= at {
            let layer = MD_GradientLayer()
            gradient(layer)
            base.layer.insertSublayer(layer, at: at)
            then?(layer)
        }else{
            let layer = layers[updateIndex ?? 0]
            gradient(layer)
            then?(layer)
        }
        return self
    }
    
    
}


// MARK: - UIView 函数扩展
extension MDKit where Base: UIView{
    
    
    /** 添加子控件
     
     示例:
     
     ```
     let aView = UIView()
     let bView = UIView()
     UIView().cmy.addSubviews(aView,bView)
     ```
     
     - Parameter subviews: 子控件数组
     */
    
    public func addSubviews(_ subviews: UIView...) {
        subviews.forEach { base.addSubview($0) }
    }
    
    
    /// 移除全部子控件
    public func removeSubviews() {
        base.subviews.forEach{ $0.removeFromSuperview() }
    }
    
    
    /** 添加子控件
     
     示例:
     
     ```
     let tap = UITapGestureRecognizer(target: self, action: #selector(tapEvent(_:)))
     let pan = UIPanGestureRecognizer(target: self, action: #selector(tapEvent(_:)))
     UIView().addGestureRecognizers(tap,pan)
     ```
     
     - Parameter subviews: 手势对象数组
     */
    func addGestureRecognizers(_ gestureRecognizers: UIGestureRecognizer...) {
        gestureRecognizers.forEach { base.addGestureRecognizer($0) }
    }
    
    /// 移除全部手势
    public func removeGestureRecognizers() {
        base.gestureRecognizers?.forEach{ base.removeGestureRecognizer($0) }
    }
    
}
