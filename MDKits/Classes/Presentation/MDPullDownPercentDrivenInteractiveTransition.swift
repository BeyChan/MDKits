//
//  MDPullDownPercentDrivenInteractiveTransition.swift
//  MDMotion
//
//  Created by  MarvinChan on 2019/7/11.
//  Copyright © 2019  MarvinChan. All rights reserved.
//

import UIKit

/// 滑动关闭
 public class MDPullDownPercentDrivenInteractiveTransition: MDPercentDrivenInteractiveTransition {
    
    private var originY: CGFloat = 0
    
    weak var controller: UIViewController?
    /// 滑动列表
    weak var scrollView: UIScrollView?
    
    lazy var panGestr: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGes(_:)))
    
    
    init(_ controller: UIViewController,scrollView: UIScrollView? = nil) {
        super.init()
        self.controller = controller
        self.scrollView = scrollView
        prepareGestureRecognizer(controller.view)
        
    }
    
    private func prepareGestureRecognizer(_ inView: UIView) {
        panGestr.delegate = self
        panGestr.cancelsTouchesInView = false
        inView.addGestureRecognizer(panGestr)
        scrollView?.panGestureRecognizer.require(toFail: panGestr)
    }
    
}

extension MDPullDownPercentDrivenInteractiveTransition: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGr = gestureRecognizer as? UIPanGestureRecognizer {
            let scrollVOffsetY = scrollView?.contentOffset.y ?? 0
            let offsetY = (panGr.view as? UIScrollView)?.contentOffset.y ?? 0
            let vy = panGr.velocity(in: panGr.view).y
            if scrollVOffsetY <= 0 && offsetY <= 0 && vy > 0{
                return true
            }
        }
        return false
    }
    
    @objc func panGes(_ gesture: UIPanGestureRecognizer) {
        guard let controller = controller else { return }
        let translationY = gesture.translation(in: gesture.view).y
        switch gesture.state {
        case .began:
            self.interacting = true
            originY = 0
        case .changed:
            originY += translationY
            controller.view.transform = CGAffineTransform.identity.translatedBy(x: 0, y: originY)
            gesture.setTranslation(.zero, in: gesture.view)
        case .ended,.cancelled:
            var fraction = abs(originY / (controller.view.bounds.height))
            fraction = fmin(fmax(fraction, 0.0), 1.0)
            self.shouldComplete = fraction > 0.4
            
            if (self.shouldComplete == false || gesture.state == .cancelled) {
                UIView.animate(withDuration: 0.3) {
                    controller.view.transform = .identity
                }
                self.cancel()
            } else {
                controller.dismiss(animated: true, completion: nil)
                self.finish()
            }
            self.interacting = false
            
        default:
            break
        }
    }
}

