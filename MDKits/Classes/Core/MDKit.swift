//
//  MDKit.swift
//  MDKit
//
//  Created by  MarvinChan on 2019/10/12.
//

import UIKit

public struct MDKit<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol ExtensionCompatible {
    associatedtype CompatibleType
    var md: CompatibleType { get }
}

extension ExtensionCompatible {
    public var md: MDKit<Self> {
        get { return MDKit(self) }
    }
}


extension NSObject: ExtensionCompatible { }
