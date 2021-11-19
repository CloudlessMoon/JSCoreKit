//
//  UIView+JSCoreLayout.m
//  JSCoreKit
//
//  Created by jiasong on 2020/8/24.
//  Copyright © 2020 jiasong. All rights reserved.
//

#import "UIView+JSCoreLayout.h"
#import "JSCoreMacroMethod.h"
#import "JSCoreHelper.h"

const CGSize JSCoreViewFixedSizeNone = {-1, -1};

@implementation UIView (JSCoreLayout)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        JSRuntimeOverrideImplementation(UIView.class, @selector(setFrame:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UIView *selfObject, CGRect frame) {
                
                if (!CGSizeEqualToSize(selfObject.js_fixedSize, JSCoreViewFixedSizeNone)) {
                    frame.size = selfObject.js_fixedSize;
                }

                // call super
                void (*originSelectorIMP)(id, SEL, CGRect);
                originSelectorIMP = (void (*)(id, SEL, CGRect))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, frame);
            };
        });
        
        JSRuntimeOverrideImplementation(UIView.class, @selector(setBounds:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UIView *selfObject, CGRect bounds) {
                
                if (!CGSizeEqualToSize(selfObject.js_fixedSize, JSCoreViewFixedSizeNone)) {
                    bounds.size = selfObject.js_fixedSize;
                }

                // call super
                void (*originSelectorIMP)(id, SEL, CGRect);
                originSelectorIMP = (void (*)(id, SEL, CGRect))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, bounds);
            };
        });
    });
}

- (CGFloat)js_top {
    return CGRectGetMinY(self.frame);
}

- (void)setJs_top:(CGFloat)top {
    CGRect rect = self.frame;
    rect.origin.y = top;
    self.frame = rect;
}

- (CGFloat)js_left {
    return CGRectGetMinX(self.frame);
}

- (void)setJs_left:(CGFloat)left {
    CGRect rect = self.frame;
    rect.origin.x = left;
    self.frame = rect;
}

- (CGFloat)js_bottom {
    return CGRectGetMaxY(self.frame);
}

- (void)setJs_bottom:(CGFloat)bottom {
    CGRect rect = self.frame;
    rect.origin.y = bottom - CGRectGetHeight(self.frame);
    self.frame = rect;
}

- (CGFloat)js_right {
    return CGRectGetMaxX(self.frame);
}

- (void)setJs_right:(CGFloat)right {
    CGRect rect = self.frame;
    rect.origin.x = right - CGRectGetWidth(self.frame);
    self.frame = rect;
}

- (CGFloat)js_width {
    return CGRectGetWidth(self.frame);
}

- (void)setJs_width:(CGFloat)width {
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}

- (CGFloat)js_height {
    return CGRectGetHeight(self.frame);
}

- (void)setJs_height:(CGFloat)height {
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}

- (CGPoint)js_origin {
    return self.frame.origin;
}

- (void)setJs_origin:(CGPoint)js_origin {
    CGRect rect = self.frame;
    rect.origin.x = js_origin.x;
    rect.origin.y = js_origin.y;
    self.frame = rect;
}

- (CGSize)js_size {
    return self.frame.size;
}

- (void)setJs_size:(CGSize)js_size {
    CGRect rect = self.frame;
    rect.size.width = js_size.width;
    rect.size.height = js_size.height;
    self.frame = rect;
}

- (CGSize)js_fixedSize {
    NSNumber *result = objc_getAssociatedObject(self, _cmd);
    if (!result) {
        return JSCoreViewFixedSizeNone;
    }
    return result.CGSizeValue;
}

- (void)setJs_fixedSize:(CGSize)js_fixedSize {
    objc_setAssociatedObject(self, @selector(js_fixedSize), @(js_fixedSize), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (!CGSizeEqualToSize(js_fixedSize, JSCoreViewFixedSizeNone)) {
        self.js_sizeThatFitsBlock = ^CGSize(__kindof UIView * _Nonnull view, CGSize size, CGSize superResult) {
            if (!CGSizeEqualToSize(view.js_fixedSize, JSCoreViewFixedSizeNone)) {
                return view.js_fixedSize;
            }
            return superResult;
        };
        self.js_size = js_fixedSize;
    }
}

- (CGRect)js_frameApplyTransform {
    return self.frame;
}

- (void)setJs_frameApplyTransform:(CGRect)js_frameApplyTransform {
    self.frame = JSCGRectApplyAffineTransformWithAnchorPoint(js_frameApplyTransform, self.transform, self.layer.anchorPoint);
}

- (CGSize (^)(__kindof UIView * _Nonnull, CGSize, CGSize))js_sizeThatFitsBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setJs_sizeThatFitsBlock:(CGSize (^)(__kindof UIView * _Nonnull, CGSize, CGSize))js_sizeThatFitsBlock {
    objc_setAssociatedObject(self, @selector(js_sizeThatFitsBlock), js_sizeThatFitsBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    if (!js_sizeThatFitsBlock) return;
    
    // Extend 每个实例对象的类是为了保证比子类的 sizeThatFits 逻辑要更晚调用
    Class viewClass = self.class;
    [JSCoreHelper executeOnceWithIdentifier:[NSString stringWithFormat:@"UIView %@-%@", NSStringFromClass(viewClass), NSStringFromSelector(_cmd)] usingBlock:^{
        JSRuntimeOverrideImplementation(viewClass, @selector(sizeThatFits:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^CGSize(UIView *selfObject, CGSize firstArgv) {
                
                // call super
                CGSize (*originSelectorIMP)(id, SEL, CGSize);
                originSelectorIMP = (CGSize (*)(id, SEL, CGSize))originalIMPProvider();
                CGSize originReturnValue = originSelectorIMP(selfObject, originCMD, firstArgv);
                
                if (selfObject.js_sizeThatFitsBlock && [selfObject isMemberOfClass:viewClass]) {
                    originReturnValue = selfObject.js_sizeThatFitsBlock(selfObject, firstArgv, originReturnValue);
                }
                return originReturnValue;
            };
        });
    }];
}

@end
