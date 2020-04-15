//
//  Anchors+SafeArea.swift
//  MDFooBox
//
//  Created by  MarvinChan on 2019/10/21.
//  Copyright © 2019  MarvinChan. All rights reserved.
//

import UIKit
public extension MDKit where Base: UIView {
    var safeTop: NSLayoutYAxisAnchor { return base.safeTopAnchor }

    var safeBottom: NSLayoutYAxisAnchor { return base.safeBottomAnchor}

    var safeLeading: NSLayoutXAxisAnchor { return base.safeLeadingAnchor }

    var safeTrailing: NSLayoutXAxisAnchor { return base.safeTrailingAnchor }

    var safeCenterX: NSLayoutXAxisAnchor { return base.centerXAnchor }

    var safeCenterY: NSLayoutYAxisAnchor { return base.centerYAnchor }

    var safeWidth: NSLayoutDimension { return base.safeWidthAnchor }

    var safeHeight: NSLayoutDimension { return base.safeHeightAnchor }
}

public extension UIView {

    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, tvOS 11.0, *) {
            return safeAreaLayoutGuide.topAnchor
        }
        return topAnchor
    }

    var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, tvOS 11.0, *) {
            return safeAreaLayoutGuide.bottomAnchor
        }
        return bottomAnchor
    }

    var safeLeadingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, tvOS 11.0, *) {
            return safeAreaLayoutGuide.leadingAnchor
        }
        return leadingAnchor
    }

    var safeTrailingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, tvOS 11.0, *) {
            return safeAreaLayoutGuide.trailingAnchor
        }
        return trailingAnchor
    }

    var safeCenterXAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, tvOS 11.0, *) {
            return safeAreaLayoutGuide.centerXAnchor
        }
        return centerXAnchor
    }

    var safeCenterYAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, tvOS 11.0, *) {
            return safeAreaLayoutGuide.centerYAnchor
        }
        return centerYAnchor
    }

    var safeWidthAnchor: NSLayoutDimension {
        if #available(iOS 11.0, tvOS 11.0, *) {
            return safeAreaLayoutGuide.widthAnchor
        }
        return widthAnchor
    }

    var safeHeightAnchor: NSLayoutDimension {
        if #available(iOS 11.0, tvOS 11.0, *) {
            return safeAreaLayoutGuide.heightAnchor
        }
        return heightAnchor
    }
}
