//
//  JSCommonDefines.h
//  JSCoreKit
//
//  Created by jiasong on 2020/8/24.
//  Copyright © 2020 jiasong. All rights reserved.
//

#ifndef JSCommonDefines_h
#define JSCommonDefines_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <os/lock.h>
#import <objc/runtime.h>
#import "JSCoreWeakProxy.h"
#import "NSNumber+JSCore.h"

#pragma mark - Clang

#define JSArgumentToString(macro) #macro
#define JSClangWarningConcat(warning_name) JSArgumentToString(clang diagnostic ignored warning_name)
#define JSBeginIgnoreClangWarning(warningName) _Pragma("clang diagnostic push") _Pragma(JSClangWarningConcat(#warningName))
#define JSEndIgnoreClangWarning _Pragma("clang diagnostic pop")
#define JSBeginIgnorePerformSelectorLeaksWarning JSBeginIgnoreClangWarning(-Warc-performSelector-leaks)
#define JSEndIgnorePerformSelectorLeaksWarning JSEndIgnoreClangWarning
#define JSBeginIgnoreDeprecatedWarning JSBeginIgnoreClangWarning(-Wdeprecated-declarations)
#define JSEndIgnoreDeprecatedWarning JSEndIgnoreClangWarning

#pragma mark - Synthesize

#define _JSSynthesizeId(_getterName, _setterName, _policy) \
_Pragma("clang diagnostic push") _Pragma(JSClangWarningConcat("-Wmismatched-parameter-types")) _Pragma(JSClangWarningConcat("-Wmismatched-return-types"))\
static char kAssociatedObjectKey_##_getterName;\
- (void)_setterName:(id)_getterName {\
objc_setAssociatedObject(self, &kAssociatedObjectKey_##_getterName, _getterName, OBJC_ASSOCIATION_##_policy##_NONATOMIC);\
}\
\
- (id)_getterName {\
return objc_getAssociatedObject(self, &kAssociatedObjectKey_##_getterName);\
}\
_Pragma("clang diagnostic pop")

#define _JSSynthesizeWeakId(_getterName, _setterName) \
_Pragma("clang diagnostic push") _Pragma(JSClangWarningConcat("-Wmismatched-parameter-types")) _Pragma(JSClangWarningConcat("-Wmismatched-return-types"))\
static char kAssociatedObjectKey_##_getterName;\
- (void)_setterName:(id)_getterName {\
objc_setAssociatedObject(self, &kAssociatedObjectKey_##_getterName, [[JSCoreWeakProxy alloc] initWithTarget:_getterName], OBJC_ASSOCIATION_RETAIN_NONATOMIC);\
}\
\
- (id)_getterName {\
return ((JSCoreWeakProxy *)objc_getAssociatedObject(self, &kAssociatedObjectKey_##_getterName)).target;\
}\
_Pragma("clang diagnostic pop")

#define _JSSynthesizeNonObject(_getterName, _setterName, _type, valueInitializer, valueGetter) \
_Pragma("clang diagnostic push") _Pragma(JSClangWarningConcat("-Wmismatched-parameter-types")) _Pragma(JSClangWarningConcat("-Wmismatched-return-types"))\
static char kAssociatedObjectKey_##_getterName;\
- (void)_setterName:(_type)_getterName {\
objc_setAssociatedObject(self, &kAssociatedObjectKey_##_getterName, [NSNumber valueInitializer:_getterName], OBJC_ASSOCIATION_RETAIN_NONATOMIC);\
}\
\
- (_type)_getterName {\
return [((NSNumber *)objc_getAssociatedObject(self, &kAssociatedObjectKey_##_getterName)) valueGetter];\
}\
_Pragma("clang diagnostic pop")

/// @property (nonatomic, strong) id xxx
#define JSSynthesizeIdStrongProperty(_getterName, _setterName) _JSSynthesizeId(_getterName, _setterName, RETAIN)

/// @property (nonatomic, weak) id xxx
#define JSSynthesizeIdWeakProperty(_getterName, _setterName) _JSSynthesizeWeakId(_getterName, _setterName)

/// @property (nonatomic, copy) id xxx
#define JSSynthesizeIdCopyProperty(_getterName, _setterName) _JSSynthesizeId(_getterName, _setterName, COPY)

#pragma mark - NonObject Marcos

/// @property (nonatomic, assign) Int xxx
#define JSSynthesizeIntProperty(_getterName, _setterName) _JSSynthesizeNonObject(_getterName, _setterName, int, numberWithInt, intValue)

/// @property (nonatomic, assign) unsigned int xxx
#define JSSynthesizeUnsignedIntProperty(_getterName, _setterName) _JSSynthesizeNonObject(_getterName, _setterName, unsigned int, numberWithUnsignedInt, unsignedIntValue)

/// @property (nonatomic, assign) float xxx
#define JSSynthesizeFloatProperty(_getterName, _setterName) _JSSynthesizeNonObject(_getterName, _setterName, float, numberWithFloat, floatValue)

/// @property (nonatomic, assign) double xxx
#define JSSynthesizeDoubleProperty(_getterName, _setterName) _JSSynthesizeNonObject(_getterName, _setterName, double, numberWithDouble, doubleValue)

/// @property (nonatomic, assign) BOOL xxx
#define JSSynthesizeBOOLProperty(_getterName, _setterName) _JSSynthesizeNonObject(_getterName, _setterName, BOOL, numberWithBool, boolValue)

/// @property (nonatomic, assign) NSInteger xxx
#define JSSynthesizeNSIntegerProperty(_getterName, _setterName) _JSSynthesizeNonObject(_getterName, _setterName, NSInteger, numberWithInteger, integerValue)

/// @property (nonatomic, assign) NSUInteger xxx
#define JSSynthesizeNSUIntegerProperty(_getterName, _setterName) _JSSynthesizeNonObject(_getterName, _setterName, NSUInteger, numberWithUnsignedInteger, unsignedIntegerValue)

/// @property (nonatomic, assign) CGFloat xxx
#define JSSynthesizeCGFloatProperty(_getterName, _setterName) _JSSynthesizeNonObject(_getterName, _setterName, CGFloat, numberWithDouble, js_CGFloatValue)

/// @property (nonatomic, assign) CGPoint xxx
#define JSSynthesizeCGPointProperty(_getterName, _setterName) _JSSynthesizeNonObject(_getterName, _setterName, CGPoint, valueWithCGPoint, CGPointValue)

/// @property (nonatomic, assign) CGSize xxx
#define JSSynthesizeCGSizeProperty(_getterName, _setterName) _JSSynthesizeNonObject(_getterName, _setterName, CGSize, valueWithCGSize, CGSizeValue)

/// @property (nonatomic, assign) CGRect xxx
#define JSSynthesizeCGRectProperty(_getterName, _setterName) _JSSynthesizeNonObject(_getterName, _setterName, CGRect, valueWithCGRect, CGRectValue)

/// @property (nonatomic, assign) UIEdgeInsets xxx
#define JSSynthesizeUIEdgeInsetsProperty(_getterName, _setterName) _JSSynthesizeNonObject(_getterName, _setterName, UIEdgeInsets, valueWithUIEdgeInsets, UIEdgeInsetsValue)

#pragma mark - Lock

#ifndef JSLockDeclare
#define JSLockDeclare(lock) os_unfair_lock lock;
#endif

#ifndef JSLockInit
#define JSLockInit(lock) lock = OS_UNFAIR_LOCK_INIT;
#endif

#ifndef JSLockAdd
#define JSLockAdd(lock) os_unfair_lock_lock(&lock);
#endif

#ifndef JSLockRemove
#define JSLockRemove(lock) os_unfair_lock_unlock(&lock);
#endif

#pragma mark - CGFloat

CG_INLINE CGFloat
JSCGRemoveFloatMin(CGFloat floatValue) {
    return floatValue == CGFLOAT_MIN ? 0 : floatValue;
}

CG_INLINE CGFloat
JSCGFlatSpecificScale(CGFloat floatValue, CGFloat scale) {
    floatValue = JSCGRemoveFloatMin(floatValue);
    scale = scale ? : UIScreen.mainScreen.scale;
    CGFloat JSFlattedValue = ceil(floatValue * scale) / scale;
    return JSFlattedValue;
}

CG_INLINE CGFloat
JSCGFlat(CGFloat floatValue) {
    return JSCGFlatSpecificScale(floatValue, 0);
}

/// 检测某个数值如果为 NaN 则将其转换为 0，避免布局中出现 crash
CG_INLINE CGFloat
JSCGFloatSafeValue(CGFloat value) {
    return isnan(value) ? 0 : value;
}

CG_INLINE CGFloat
JSCGFloatToFixed(CGFloat value, NSUInteger precision) {
    NSString *formatString = [NSString stringWithFormat:@"%%.%@f", @(precision)];
    NSString *toString = [NSString stringWithFormat:formatString, value];
#if CGFLOAT_IS_DOUBLE
    CGFloat result = [toString doubleValue];
#else
    CGFloat result = [toString floatValue];
#endif
    return result;
}

#pragma mark - CGPoint

/// 两个point相加
CG_INLINE CGPoint
JSCGPointUnion(CGPoint point1, CGPoint point2) {
    return CGPointMake(JSCGFlat(point1.x + point2.x), JSCGFlat(point1.y + point2.y));
}

/// 获取rect的center，包括rect本身的x/y偏移
CG_INLINE CGPoint
JSCGPointGetCenterWithRect(CGRect rect) {
    return CGPointMake(JSCGFlat(CGRectGetMidX(rect)), JSCGFlat(CGRectGetMidY(rect)));
}

CG_INLINE CGPoint
JSCGPointGetCenterWithSize(CGSize size) {
    return CGPointMake(JSCGFlat(size.width / 2.0), JSCGFlat(size.height / 2.0));
}

CG_INLINE CGPoint
JSCGPointToFixed(CGPoint point, NSUInteger precision) {
    CGPoint result = CGPointMake(JSCGFloatToFixed(point.x, precision), JSCGFloatToFixed(point.y, precision));
    return result;
}

CG_INLINE CGPoint
JSCGPointRemoveFloatMin(CGPoint point) {
    CGPoint result = CGPointMake(JSCGRemoveFloatMin(point.x), JSCGRemoveFloatMin(point.y));
    return result;
}

#pragma mark - CGRect

CG_INLINE BOOL
JSCGRectIsNaN(CGRect rect) {
    return isnan(rect.origin.x) || isnan(rect.origin.y) || isnan(rect.size.width) || isnan(rect.size.height);
}

CG_INLINE BOOL
JSCGRectIsInf(CGRect rect) {
    return isinf(rect.origin.x) || isinf(rect.origin.y) || isinf(rect.size.width) || isinf(rect.size.height);
}

CG_INLINE BOOL
JSCGRectIsValidated(CGRect rect) {
    return !CGRectIsNull(rect) && !CGRectIsInfinite(rect) && !JSCGRectIsNaN(rect) && !JSCGRectIsInf(rect);
}

CG_INLINE CGRect
JSCGRectSafeValue(CGRect rect) {
    return CGRectMake(JSCGFloatSafeValue(CGRectGetMinX(rect)), JSCGFloatSafeValue(CGRectGetMinY(rect)), JSCGFloatSafeValue(CGRectGetWidth(rect)), JSCGFloatSafeValue(CGRectGetHeight(rect)));
}

CG_INLINE CGRect
JSCGRectFlatMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height) {
    return CGRectMake(JSCGFlat(x), JSCGFlat(y), JSCGFlat(width), JSCGFlat(height));
}

CG_INLINE CGRect
JSCGRectFlatted(CGRect rect) {
    return CGRectMake(JSCGFlat(rect.origin.x), JSCGFlat(rect.origin.y), JSCGFlat(rect.size.width), JSCGFlat(rect.size.height));
}

CG_INLINE CGRect
JSCGRectMakeWithSize(CGSize size) {
    return CGRectMake(0, 0, size.width, size.height);
}

#pragma mark - Transform

CG_INLINE CGPoint
JSCGPointApplyAffineTransformWithCoordinatePoint(CGPoint coordinatePoint, CGPoint targetPoint, CGAffineTransform t) {
    CGPoint p;
    p.x = (targetPoint.x - coordinatePoint.x) * t.a + (targetPoint.y - coordinatePoint.y) * t.c + coordinatePoint.x;
    p.y = (targetPoint.x - coordinatePoint.x) * t.b + (targetPoint.y - coordinatePoint.y) * t.d + coordinatePoint.y;
    p.x += t.tx;
    p.y += t.ty;
    return p;
}

CG_INLINE CGRect
JSCGRectApplyAffineTransformWithAnchorPoint(CGRect rect, CGAffineTransform t, CGPoint anchorPoint) {
    CGFloat width = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);
    CGPoint oPoint = CGPointMake(rect.origin.x + width * anchorPoint.x, rect.origin.y + height * anchorPoint.y);
    CGPoint top_left = JSCGPointApplyAffineTransformWithCoordinatePoint(oPoint, CGPointMake(rect.origin.x, rect.origin.y), t);
    CGPoint bottom_left = JSCGPointApplyAffineTransformWithCoordinatePoint(oPoint, CGPointMake(rect.origin.x, rect.origin.y + height), t);
    CGPoint top_right = JSCGPointApplyAffineTransformWithCoordinatePoint(oPoint, CGPointMake(rect.origin.x + width, rect.origin.y), t);
    CGPoint bottom_right = JSCGPointApplyAffineTransformWithCoordinatePoint(oPoint, CGPointMake(rect.origin.x + width, rect.origin.y + height), t);
    CGFloat minX = MIN(MIN(MIN(top_left.x, bottom_left.x), top_right.x), bottom_right.x);
    CGFloat maxX = MAX(MAX(MAX(top_left.x, bottom_left.x), top_right.x), bottom_right.x);
    CGFloat minY = MIN(MIN(MIN(top_left.y, bottom_left.y), top_right.y), bottom_right.y);
    CGFloat maxY = MAX(MAX(MAX(top_left.y, bottom_left.y), top_right.y), bottom_right.y);
    CGFloat newWidth = maxX - minX;
    CGFloat newHeight = maxY - minY;
    CGRect result = CGRectMake(minX, minY, newWidth, newHeight);
    return result;
}

CG_INLINE CGRect
JSCGRectApplyScale(CGRect rect, CGFloat scale) {
    return JSCGRectFlatted(CGRectMake(CGRectGetMinX(rect) * scale, CGRectGetMinY(rect) * scale, CGRectGetWidth(rect) * scale, CGRectGetHeight(rect) * scale));
}

#pragma mark - Runtime

CG_INLINE BOOL
JSRuntimeHasOverrideSuperclassMethod(Class targetClass, SEL targetSelector) {
    Method method = class_getInstanceMethod(targetClass, targetSelector);
    if (!method) return NO;
    
    Method methodOfSuperclass = class_getInstanceMethod(class_getSuperclass(targetClass), targetSelector);
    if (!methodOfSuperclass) return YES;
    
    return method != methodOfSuperclass;
}

CG_INLINE BOOL
JSRuntimeOverrideImplementation(Class targetClass, SEL targetSelector, id (^implementationBlock)(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void))) {
    Method originMethod = class_getInstanceMethod(targetClass, targetSelector);
    IMP imp = method_getImplementation(originMethod);
    BOOL hasOverride = JSRuntimeHasOverrideSuperclassMethod(targetClass, targetSelector);
    
    // 以 block 的方式达到实时获取初始方法的 IMP 的目的，从而避免先 swizzle 了 subclass 的方法，再 swizzle superclass 的方法，会发现前者调用时不会触发后者 swizzle 后的版本的 bug。
    IMP (^originalIMPProvider)(void) = ^IMP(void) {
        IMP result = NULL;
        if (hasOverride) {
            result = imp;
        } else {
            // 如果 superclass 里依然没有实现，则会返回一个 objc_msgForward 从而触发消息转发的流程
            // https://github.com/Tencent/JS_iOS/issues/776
            Class superclass = class_getSuperclass(targetClass);
            result = class_getMethodImplementation(superclass, targetSelector);
        }
        
        // 这只是一个保底，这里要返回一个空 block 保证非 nil，才能避免用小括号语法调用 block 时 crash
        // 空 block 虽然没有参数列表，但在业务那边被转换成 IMP 后就算传多个参数进来也不会 crash
        if (!result) {
            result = imp_implementationWithBlock(^(id selfObject){
                
            });
        }
        
        return result;
    };
    
    if (hasOverride) {
        method_setImplementation(originMethod, imp_implementationWithBlock(implementationBlock(targetClass, targetSelector, originalIMPProvider)));
    } else {
        NSMethodSignature *signature = [targetClass instanceMethodSignatureForSelector:targetSelector];
        JSBeginIgnorePerformSelectorLeaksWarning
        NSString *typeString = [signature performSelector:NSSelectorFromString([NSString stringWithFormat:@"_%@String", @"type"])];
        JSEndIgnorePerformSelectorLeaksWarning
        const char *typeEncoding = method_getTypeEncoding(originMethod) ?: typeString.UTF8String;
        class_addMethod(targetClass, targetSelector, imp_implementationWithBlock(implementationBlock(targetClass, targetSelector, originalIMPProvider)), typeEncoding);
    }
    
    return YES;
}

#endif /* JSCommonDefines_h */
