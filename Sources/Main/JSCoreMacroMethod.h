//
//  JSCoreMacroMethod.h
//  JSCoreKit
//
//  Created by jiasong on 2020/12/28.
//

#ifndef JSCoreMacroMethod_h
#define JSCoreMacroMethod_h

#import "JSCoreMacroVariable.h"
#import <objc/runtime.h>

#pragma mark - Double

FOUNDATION_STATIC_INLINE double
JSDoubleToFixed(double value, NSUInteger precision) {
    NSString *formatString = [NSString stringWithFormat:@"%%.%@lf", @(precision)];
    NSString *toString = [NSString stringWithFormat:formatString, value];
    return [toString doubleValue];
}

#pragma mark - Float

FOUNDATION_STATIC_INLINE float
JSFloatToFixed(float value, NSUInteger precision) {
    NSString *formatString = [NSString stringWithFormat:@"%%.%@f", @(precision)];
    NSString *toString = [NSString stringWithFormat:formatString, value];
    return [toString floatValue];
}

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

#pragma mark - 线程相关

DISPATCH_INLINE void
JSAsyncExecuteOnQueue(dispatch_queue_t queue, dispatch_block_t block) {
    dispatch_async(queue, block);
}

DISPATCH_INLINE void   /// 全局并行队列
JSAsyncExecuteOnGlobalQueue(dispatch_block_t block){
    JSAsyncExecuteOnQueue(dispatch_get_global_queue(0, 0), block);
}

DISPATCH_INLINE void
JSAsyncExecuteOnMainQueue(dispatch_block_t block) {
    if (dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL) == dispatch_queue_get_label(dispatch_get_main_queue())) {
        block();
    } else {
        JSAsyncExecuteOnQueue(dispatch_get_main_queue(), block);
    }
}

DISPATCH_INLINE void
JSAfterOnMainQueue(CGFloat delayInSeconds, dispatch_block_t block) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}

DISPATCH_INLINE dispatch_queue_t
JSCreateSerialQueue(NSString *label) {
    return dispatch_queue_create(label.UTF8String, DISPATCH_QUEUE_SERIAL);
}

DISPATCH_INLINE dispatch_queue_t
JSCreateConcurrentQueue(NSString *label) {
    return dispatch_queue_create(label.UTF8String, DISPATCH_QUEUE_CONCURRENT);
}

#endif /* JSCoreMacroMethod_h */
