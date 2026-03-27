//
//  WeakProxy.swift
//  JSCoreKit
//
//  Created by jiasong on 2025/4/24.
//

import Foundation

public final class WeakProxy<T: AnyObject> {
    
    public var value: T? {
        return self.ref.target as? T
    }
    
    private let ref: __RMWeakProxy
    
    public init(_ value: T?) {
        self.ref = __RMWeakProxy(target: value)
    }
    
}
