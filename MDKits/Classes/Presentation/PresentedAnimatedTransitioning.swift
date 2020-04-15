//
//  PresentedAnimatedTransitioning.swift
//  Foo
//
//  Created by huangmin on 13/11/2017.
//  Copyright © 2017 YedaoDev. All rights reserved.
//

import UIKit

class PresentedAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toVC = transitionContext.viewController(forKey: .to)
        let fromVC = transitionContext.viewController(forKey: .from)
        guard toVC != nil && fromVC != nil else {
            return
        }
        let containerView = transitionContext.containerView
        let duration = self.transitionDuration(using: transitionContext)
        if toVC!.isBeingPresented {
            containerView.addSubview(toVC!.view)
            let view = toVC?.view
            view?.alpha = 0
            view?.frame = CGRect(x: 0, y: 0, width: containerView.frame.size.width, height: containerView.frame.size.height)
            UIView.animate(withDuration: duration, animations: {
                view?.alpha = 1
            }, completion: { (finished) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        } else if fromVC!.isBeingDismissed {
            UIView.animate(withDuration: duration, animations: {
                fromVC?.view.alpha = 0
            }, completion: { (finished) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
    }
}
