//
//  MDPresentationManager.swift
//  MDMotion
//
//  Created by  MarvinChan on 2019/7/11.
//  Copyright © 2019  MarvinChan. All rights reserved.
//

import UIKit

enum MDPresentationDirection {
    case left
    case top
    case right
    case bottom
    case center
}

class MDPresentationConfig {
    /// 方向
    var direction: MDPresentationDirection = .left
    /// 显示内容的大小
    var contentSize: CGSize = .zero
    /// 点击关闭
    var clickCloseEnabled: Bool = true
}
final class MDPresentationManager: NSObject {
    // MARK: - Properties
    var config: MDPresentationConfig = MDPresentationConfig()
    var interactionTransition: MDPercentDrivenInteractiveTransition?
}

// MARK: - UIViewControllerTransitioningDelegate
extension MDPresentationManager: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        let presentationController = MDPresentationController(presentedViewController: presented, presenting: presenting, config: config)
        presentationController.delegate = self
        return presentationController
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MDPresentationAnimator(direction: config.direction, isPresentation: true)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MDPresentationAnimator(direction: config.direction, isPresentation: false)
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return (interactionTransition?.interacting ?? false) ? interactionTransition : nil
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return (interactionTransition?.interacting ?? false) ? interactionTransition : nil
    }
}

extension MDPresentationManager: UIAdaptivePresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        if traitCollection.verticalSizeClass == .compact {
            return .overFullScreen
        } else {
            return .none
        }
    }
}
