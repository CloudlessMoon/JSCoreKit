//
//  JSCoreKitCompatible.swift
//  JSCoreKit
//
//  Created by jiasong on 2021/1/14.
//

import Foundation

public struct CoreKitWrapper<Base> {
    
    public let base: Base
    
    public init(_ base: Base) {
        self.base = base
    }
    
}

public protocol CoreKitCompatible {}

extension CoreKitCompatible {
    
    public static var jsc: CoreKitWrapper<Self>.Type {
        get { CoreKitWrapper<Self>.self }
        set { }
    }
    
    public var jsc: CoreKitWrapper<Self> {
        get { CoreKitWrapper(self) }
        set { }
    }
    
}

public protocol CoreKitCompatibleObject: AnyObject {}

extension CoreKitCompatibleObject {
    
    public static var jsc: CoreKitWrapper<Self>.Type {
        get { CoreKitWrapper<Self>.self }
        set { }
    }
    
    public var jsc: CoreKitWrapper<Self> {
        get { CoreKitWrapper(self) }
        set { }
    }
    
}

extension Double: CoreKitCompatible {}
extension CGFloat: CoreKitCompatible {}
extension CGSize: CoreKitCompatible {}
extension CGPoint: CoreKitCompatible {}
extension CGRect: CoreKitCompatible {}
extension UIEdgeInsets: CoreKitCompatible {}

extension NSObject: CoreKitCompatibleObject {}
