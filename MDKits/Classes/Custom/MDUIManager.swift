//
//  MDUIManager.swift
//  MDFooBox
//
//  Created by  MarvinChan on 2019/10/15.
//  Copyright © 2019  MarvinChan. All rights reserved.
//

import Foundation

@objc public class MDUIManager: NSObject {
    public enum UserInterfaceStyleSupport {
        @available(iOS 13.0, *)
        case dynamic
        case forceLight
        case forceDark
    }

    static var bundle: Bundle {
        return Bundle(for: MDUIManager.self)
    }

    public static var isDynamicTypeEnabled: Bool = true
    public static var userInterfaceStyleSupport: UserInterfaceStyleSupport = .forceLight
}

@objc public extension Bundle {
    static var uiManager: Bundle {
        return MDUIManager.bundle
    }
}
