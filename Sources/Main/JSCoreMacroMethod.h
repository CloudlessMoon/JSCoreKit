//
//  JSCoreMacroMethod.h
//  JSCoreKit
//
//  Created by jiasong on 2020/12/28.
//

#ifndef JSCoreMacroMethod_h
#define JSCoreMacroMethod_h

#import "JSCoreHelper+LayoutGuide.h"
#import "JSCoreMacroVariable.h"
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - CGFloat

CG_INLINE CGFloat
JSCeilPixelValue(CGFloat value) {
    CGFloat scale = JSCoreHelper.displayScale;
    return ceil(value * scale) / scale;
}

CG_INLINE CGFloat
JSRoundPixelValue(CGFloat value) {
    CGFloat scale = JSCoreHelper.displayScale;
    return round(value * scale) / scale;
}

CG_INLINE CGFloat
JSFloorPixelValue(CGFloat value) {
    CGFloat scale = JSCoreHelper.displayScale;
    return floor(value * scale) / scale;
}

/// 检测某个数值如果为 NaN 则将其转换为 0，避免布局中出现 crash
CG_INLINE CGFloat
JSCGFloatSafeValue(CGFloat value) {
    return isnan(value) || isinf(value) ? 0 : value;
}

#pragma mark - UIEdgeInsets

/// 获取UIEdgeInsets在水平方向上的值
CG_INLINE CGFloat
JSUIEdgeInsetsGetHorizontalValue(UIEdgeInsets insets) {
    return insets.left + insets.right;
}

/// 获取UIEdgeInsets在垂直方向上的值
CG_INLINE CGFloat
JSUIEdgeInsetsGetVerticalValue(UIEdgeInsets insets) {
    return insets.top + insets.bottom;
}

/// 将两个UIEdgeInsets合并为一个
CG_INLINE UIEdgeInsets
JSUIEdgeInsetsConcat(UIEdgeInsets insets1, UIEdgeInsets insets2) {
    insets1.top += insets2.top;
    insets1.left += insets2.left;
    insets1.bottom += insets2.bottom;
    insets1.right += insets2.right;
    return insets1;
}

#pragma mark - CGSize

/// 判断一个 CGSize 是否存在 NaN
CG_INLINE BOOL
JSCGSizeIsNaN(CGSize size) {
    return isnan(size.width) || isnan(size.height);
}

/// 判断一个 CGSize 是否存在 infinite
CG_INLINE BOOL
JSCGSizeIsInf(CGSize size) {
    return isinf(size.width) || isinf(size.height);
}

/// 判断一个 CGSize 是否为空（宽或高为0）
CG_INLINE BOOL
JSCGSizeIsEmpty(CGSize size) {
    return size.width <= 0 || size.height <= 0;
}

/// 判断一个 CGSize 是否合法（例如不带无穷大的值、不带非法数字）
CG_INLINE BOOL
JSCGSizeIsValidated(CGSize size) {
    return !JSCGSizeIsEmpty(size) && !JSCGSizeIsInf(size) && !JSCGSizeIsNaN(size);
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
JSCGRectSetX(CGRect rect, CGFloat x) {
    rect.origin.x = x;
    return rect;
}

CG_INLINE CGRect
JSCGRectSetY(CGRect rect, CGFloat y) {
    rect.origin.y = y;
    return rect;
}

CG_INLINE CGRect
JSCGRectSetXY(CGRect rect, CGFloat x, CGFloat y) {
    rect.origin.x = x;
    rect.origin.y = y;
    return rect;
}

CG_INLINE CGRect
JSCGRectSetWidth(CGRect rect, CGFloat width) {
    if (width < 0) {
        return rect;
    }
    rect.size.width = width;
    return rect;
}

CG_INLINE CGRect
JSCGRectSetHeight(CGRect rect, CGFloat height) {
    if (height < 0) {
        return rect;
    }
    rect.size.height = height;
    return rect;
}

CG_INLINE CGRect
JSCGRectSetSize(CGRect rect, CGSize size) {
    rect.size = size;
    return rect;
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
            // https://github.com/Tencent/QMUI_iOS/issues/776
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

#pragma mark - 线程

DISPATCH_INLINE BOOL
JSIsMainQueueForQueue(dispatch_queue_t _Nullable queue) {
    return dispatch_queue_get_label(queue ? : DISPATCH_CURRENT_QUEUE_LABEL) == dispatch_queue_get_label(dispatch_get_main_queue());
}

#pragma mark - 线程 - Sync

DISPATCH_INLINE void
JSSyncExecuteOnQueue(dispatch_queue_t queue, dispatch_block_t block) {
    dispatch_sync(queue, block);
}

DISPATCH_INLINE void
JSSyncExecuteOnMainQueue(dispatch_block_t block) {
    if (JSIsMainQueueForQueue(DISPATCH_CURRENT_QUEUE_LABEL)) {
        block();
    } else {
        JSSyncExecuteOnQueue(dispatch_get_main_queue(), block);
    }
}

#pragma mark - 线程 - Async

DISPATCH_INLINE void
JSAsyncExecuteOnQueue(dispatch_queue_t queue, dispatch_block_t block) {
    dispatch_async(queue, block);
}

DISPATCH_INLINE void
JSAsyncExecuteOnGlobalQueue(dispatch_block_t block){
    JSAsyncExecuteOnQueue(dispatch_get_global_queue(0, 0), block);
}

DISPATCH_INLINE void
JSAsyncExecuteOnMainQueue(dispatch_block_t block) {
    if (JSIsMainQueueForQueue(DISPATCH_CURRENT_QUEUE_LABEL)) {
        block();
    } else {
        JSAsyncExecuteOnQueue(dispatch_get_main_queue(), block);
    }
}

#pragma mark - 线程 - After

DISPATCH_INLINE void
JSAfterOnMainQueue(CGFloat delayInSeconds, dispatch_block_t block) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}

#pragma mark - 线程 - Create

DISPATCH_INLINE dispatch_queue_t
JSCreateSerialQueue(NSString *label) {
    return dispatch_queue_create(label.UTF8String, DISPATCH_QUEUE_SERIAL);
}

DISPATCH_INLINE dispatch_queue_t
JSCreateConcurrentQueue(NSString *label) {
    return dispatch_queue_create(label.UTF8String, DISPATCH_QUEUE_CONCURRENT);
}

NS_ASSUME_NONNULL_END

#endif /* JSCoreMacroMethod_h */
