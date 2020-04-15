//
//  PresentedAnimatedTransition.swift
//  Foo
//
//  Created by huangmin on 26/12/2017.
//  Copyright © 2017 YedaoDev. All rights reserved.
//

import Foundation
class PresentedAnimatedTransitioningDelegate : NSObject, UIViewControllerTransitioningDelegate {
    /**
     * UIViewControllerTransitioningDelegate
     */
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentedAnimatedTransitioning()
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentedAnimatedTransitioning()
    }
}
