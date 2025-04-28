//
//  JSCoreMacroMethod.swift
//  JSCoreKit
//
//  Created by jiasong on 2021/1/23.
//

import UIKit

// MARK: BinaryFloatingPoint
public extension CoreKitWrapper where Base: BinaryFloatingPoint {
    
    func ceilPixelValue() -> Base {
        return Base(JSCeilPixelValue(CGFloat(self.base)))
    }
    
    func estimated() -> Base {
        return Base(JSCGFloatEstimated(CGFloat(self.base)))
    }

}

// MARK: UIEdgeInsets
public extension CoreKitWrapper where Base == UIEdgeInsets {
    
    var vertical: Double {
        return JSUIEdgeInsetsGetVerticalValue(self.base)
    }
    
    var horizontal: Double {
        return JSUIEdgeInsetsGetHorizontalValue(self.base)
    }
    
}


// MARK: CGPoint
public extension CoreKitWrapper where Base == CGPoint {
    
    func estimated() -> Base {
        return JSCGPointEstimated(self.base)
    }
    
}

// MARK: CGRect
public extension CoreKitWrapper where Base == CGRect {
    
  
    
}

// MARK: CGSize
public extension CoreKitWrapper where Base == CGSize {
    
    var isValidated: Bool {
        return JSCGSizeIsValidated(self.base)
    }
    
    func estimated() -> Base {
        return JSCGSizeEstimated(self.base)
    }
    
}
