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
        return Base(__JSCGFloatCeilPixelValue(CGFloat(self.base)))
    }
    
    func roundPixelValue() -> Base {
        return Base(__JSCGFloatRoundPixelValue(CGFloat(self.base)))
    }
    
    func floorPixelValue() -> Base {
        return Base(__JSCGFloatFloorPixelValue(CGFloat(self.base)))
    }
    
    func toFixed(_ precision: UInt, rule: JSDecimalRoundingRule) -> Base {
        return Base(__JSCGFloatToFixed(CGFloat(self.base), precision, rule))
    }
    
    func equal(to other: Base) -> Bool { // ==
        return abs(self.base - other) <= Base(0.001)
    }
    
    func greater(than other: Base) -> Bool { // >
        return self.base - other > Base(0.001)
    }
    
    func greaterOrEqual(to other: Base) -> Bool { // >=
        return self.base - other >= -Base(0.001)
    }
    
    func less(than other: Base) -> Bool {  // <
        return other - self.base > Base(0.001)
    }
    
    func lessOrEqual(to other: Base) -> Bool { // <=
        return self.base - other <= Base(0.001)
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
    
    func equal(to other: Base) -> Bool { // ==
        return self.base.top.jsc.equal(to: other.top)
        && self.base.left.jsc.equal(to: other.left)
        && self.base.bottom.jsc.equal(to: other.bottom)
        && self.base.right.jsc.equal(to: other.right)
    }
    
    func greater(than other: Base) -> Bool { // >
        return self.base.top.jsc.greater(than: other.top)
        && self.base.left.jsc.greater(than: other.left)
        && self.base.bottom.jsc.greater(than: other.bottom)
        && self.base.right.jsc.greater(than: other.right)
    }
    
    func greaterOrEqual(to other: Base) -> Bool { // >=
        return self.base.top.jsc.greaterOrEqual(to: other.top)
        && self.base.left.jsc.greaterOrEqual(to: other.left)
        && self.base.bottom.jsc.greaterOrEqual(to: other.bottom)
        && self.base.right.jsc.greaterOrEqual(to: other.right)
    }
    
    func less(than other: Base) -> Bool { // <
        return self.base.top.jsc.less(than: other.top)
        && self.base.left.jsc.less(than: other.left)
        && self.base.bottom.jsc.less(than: other.bottom)
        && self.base.right.jsc.less(than: other.right)
    }
    
    func lessOrEqual(to other: Base) -> Bool { // <=
        return self.base.top.jsc.lessOrEqual(to: other.top)
        && self.base.left.jsc.lessOrEqual(to: other.left)
        && self.base.bottom.jsc.lessOrEqual(to: other.bottom)
        && self.base.right.jsc.lessOrEqual(to: other.right)
    }
    
}

// MARK: CGPoint
public extension CoreKitWrapper where Base == CGPoint {
    
    func ceilPixelValue() -> Base {
        return CGPoint(x: self.base.x.jsc.ceilPixelValue(), y: self.base.y.jsc.ceilPixelValue())
    }
    
    func roundPixelValue() -> Base {
        return CGPoint(x: self.base.x.jsc.roundPixelValue(), y: self.base.y.jsc.roundPixelValue())
    }
    
    func floorPixelValue() -> Base {
        return CGPoint(x: self.base.x.jsc.floorPixelValue(), y: self.base.y.jsc.floorPixelValue())
    }
    
    func toFixed(_ precision: UInt, rule: JSDecimalRoundingRule) -> Base {
        return __JSCGPointToFixed(self.base, precision, rule)
    }
    
    func equal(to other: Base) -> Bool { // ==
        return self.base.x.jsc.equal(to: other.x) && self.base.y.jsc.equal(to: other.y)
    }
    
    func greater(than other: Base) -> Bool { // >
        return self.base.x.jsc.greater(than: other.x) && self.base.y.jsc.greater(than: other.y)
    }
    
    func greaterOrEqual(to other: Base) -> Bool { // >=
        return self.base.x.jsc.greaterOrEqual(to: other.x) && self.base.y.jsc.greaterOrEqual(to: other.y)
    }
    
    func less(than other: Base) -> Bool { // <
        return self.base.x.jsc.less(than: other.x) && self.base.y.jsc.less(than: other.y)
    }
    
    func lessOrEqual(to other: Base) -> Bool { // <=
        return self.base.x.jsc.lessOrEqual(to: other.x) && self.base.y.jsc.lessOrEqual(to: other.y)
    }
    
}

// MARK: CGSize
public extension CoreKitWrapper where Base == CGSize {
    
    var isValidated: Bool {
        return JSCGSizeIsValidated(self.base)
    }
    
    func ceilPixelValue() -> Base {
        return CGSize(width: self.base.width.jsc.ceilPixelValue(), height: self.base.height.jsc.ceilPixelValue())
    }
    
    func roundPixelValue() -> Base {
        return CGSize(width: self.base.width.jsc.roundPixelValue(), height: self.base.height.jsc.roundPixelValue())
    }
    
    func floorPixelValue() -> Base {
        return CGSize(width: self.base.width.jsc.floorPixelValue(), height: self.base.height.jsc.floorPixelValue())
    }
    
    func toFixed(_ precision: UInt, rule: JSDecimalRoundingRule) -> Base {
        return __JSCGSizeToFixed(self.base, precision, rule)
    }
    
    func equal(to other: Base) -> Bool { // ==
        return self.base.width.jsc.equal(to: other.width) && self.base.height.jsc.equal(to: other.height)
    }
    
    func greater(than other: Base) -> Bool { // >
        return self.base.width.jsc.greater(than: other.width) && self.base.height.jsc.greater(than: other.height)
    }
    
    func greaterOrEqual(to other: Base) -> Bool { // >=
        return self.base.width.jsc.greaterOrEqual(to: other.width) && self.base.height.jsc.greaterOrEqual(to: other.height)
    }
    
    func less(than other: Base) -> Bool { // <
        return self.base.width.jsc.less(than: other.width) && self.base.height.jsc.less(than: other.height)
    }
    
    func lessOrEqual(to other: Base) -> Bool { // <=
        return self.base.width.jsc.lessOrEqual(to: other.width) && self.base.height.jsc.lessOrEqual(to: other.height)
    }
    
}

// MARK: CGRect
public extension CoreKitWrapper where Base == CGRect {
    
    func pixelValue() -> Base {
        return CGRect(
            origin: self.base.origin.jsc.roundPixelValue(),
            size: self.base.size.jsc.ceilPixelValue()
        )
    }
    
    func ceilPixelValue() -> Base {
        return CGRect(
            origin: self.base.origin.jsc.ceilPixelValue(),
            size: self.base.size.jsc.ceilPixelValue()
        )
    }
    
    func roundPixelValue() -> Base {
        return CGRect(
            origin: self.base.origin.jsc.roundPixelValue(),
            size: self.base.size.jsc.roundPixelValue()
        )
    }
    
    func floorPixelValue() -> Base {
        return CGRect(
            origin: self.base.origin.jsc.floorPixelValue(),
            size: self.base.size.jsc.floorPixelValue()
        )
    }
    
    func toFixed(_ precision: UInt, rule: JSDecimalRoundingRule) -> Base {
        return __JSCGRectToFixed(self.base, precision, rule)
    }
    
    func equal(to other: Base) -> Bool { // ==
        return self.base.origin.jsc.equal(to: other.origin) && self.base.size.jsc.equal(to: other.size)
    }
    
    func greater(than other: Base) -> Bool { // >
        return self.base.origin.jsc.greater(than: other.origin) && self.base.size.jsc.greater(than: other.size)
    }
    
    func greaterOrEqual(to other: Base) -> Bool { // >=
        return self.base.origin.jsc.greaterOrEqual(to: other.origin) && self.base.size.jsc.greaterOrEqual(to: other.size)
    }
    
    func less(than other: Base) -> Bool { // <
        return self.base.origin.jsc.less(than: other.origin) && self.base.size.jsc.less(than: other.size)
    }
    
    func lessOrEqual(to other: Base) -> Bool { // <=
        return self.base.origin.jsc.lessOrEqual(to: other.origin) && self.base.size.jsc.lessOrEqual(to: other.size)
    }
    
}
