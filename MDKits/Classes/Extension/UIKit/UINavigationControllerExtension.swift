//
//  UINavigationControllerExtension.swift
//  MDFooBox
//
//  Created by cloud.huang on 2019/10/30.
//  Copyright © 2019  MarvinChan. All rights reserved.
//

import Foundation
extension MDKit where Base: UINavigationController {
    public func replace(by controller : UIViewController, push : Bool = true, ignoreVCs : [UIViewController.Type] = []) {
        var vcs : [UIViewController] = []
        if ignoreVCs.isEmpty {
            vcs = base.viewControllers
        } else {
            for vc in base.viewControllers {
                for ignoreVC in ignoreVCs {
                    if !vc.isKind(of: ignoreVC) {
                        vcs.append(vc)
                    }
                }
            }
        }
        if push {
            vcs = vcs.dropLast()
            vcs.append(controller)
            base.setViewControllers(vcs, animated: true)
        } else {
            vcs.insert(controller, at: vcs.count - 1)
            base.setViewControllers(vcs, animated: false)
            base.popViewController(animated: true)
        }
    }
}
