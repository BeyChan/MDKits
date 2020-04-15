//
//  ClosureAware.swift
//  MDFooBox
//
//  Created by  MarvinChan on 2019/12/27.
//  Copyright © 2019  MarvinChan. All rights reserved.
//

import UIKit

public typealias Action = () -> Void
public class Container<Host: AnyObject>: NSObject {
    public unowned let host: Host
    
    public init(host: Host) {
        self.host = host
    }
    
    public var targets = [String: NSObject]()
}


private struct AssociatedKey {
    static var key = "Closure"
}

public protocol MDClosureAware: class {
    associatedtype MDClosureAware: AnyObject

    var on: Container<MDClosureAware> { get }
}

extension MDClosureAware {
    public var on: Container<Self> {
        get {
            if let value = objc_getAssociatedObject(self, &AssociatedKey.key) as? Container<Self> {
                return value
            }

            let value = Container(host: self)
            objc_setAssociatedObject(self, &AssociatedKey.key, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return value
        }
    }
}

extension NSObject: MDClosureAware {
    static var uniqueId: String {
        return String(describing: self)
    }
}
