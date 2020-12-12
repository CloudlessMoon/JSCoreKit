//
//  UIView+JSCoreLayout.m
//  JSCoreKit
//
//  Created by jiasong on 2020/8/24.
//  Copyright © 2020 jiasong. All rights reserved.
//

#import "UIView+JSCoreLayout.h"
#import "JSCoreCommonDefines.h"

@implementation UIView (JSCoreLayout)

- (CGFloat)js_top {
    return CGRectGetMinY(self.frame);
}

- (void)setJs_top:(CGFloat)top {
    CGRect rect = self.frame;
    rect.origin.y = JSCGFlat(top);
    self.frame = rect;
}

- (CGFloat)js_left {
    return CGRectGetMinX(self.frame);
}

- (void)setJs_left:(CGFloat)left {
    CGRect rect = self.frame;
    rect.origin.x = JSCGFlat(left);
    self.frame = rect;
}

- (CGFloat)js_bottom {
    return CGRectGetMaxY(self.frame);
}

- (void)setJs_bottom:(CGFloat)bottom {
    CGRect rect = self.frame;
    rect.origin.y = JSCGFlat(bottom - CGRectGetHeight(self.frame));
    self.frame = rect;
}

- (CGFloat)js_right {
    return CGRectGetMaxX(self.frame);
}

- (void)setJs_right:(CGFloat)right {
    CGRect rect = self.frame;
    rect.origin.x = JSCGFlat(right - CGRectGetWidth(self.frame));
    self.frame = rect;
}

- (CGFloat)js_width {
    return CGRectGetWidth(self.frame);
}

- (void)setJs_width:(CGFloat)width {
    CGRect rect = self.frame;
    rect.size.width = JSCGFlat(width);
    self.frame = rect;
}

- (CGFloat)js_height {
    return CGRectGetHeight(self.frame);
}

- (void)setJs_height:(CGFloat)height {
    CGRect rect = self.frame;
    rect.size.height = JSCGFlat(height);
    self.frame = rect;
}

- (CGPoint)js_origin {
    return self.frame.origin;
}

- (void)setJs_origin:(CGPoint)js_origin {
    CGRect rect = self.frame;
    rect.origin.x = JSCGFlat(js_origin.x);
    rect.origin.y = JSCGFlat(js_origin.y);
    self.frame = rect;
}

- (CGSize)js_size {
    return self.frame.size;
}

- (void)setJs_size:(CGSize)js_size {
    CGRect rect = self.frame;
    rect.size.width = JSCGFlat(js_size.width);
    rect.size.height = JSCGFlat(js_size.height);
    self.frame = rect;
}

- (CGRect)js_frameApplyTransform {
    return self.frame;
}

- (void)setJs_frameApplyTransform:(CGRect)js_frameApplyTransform {
    self.frame = JSCGRectApplyAffineTransformWithAnchorPoint(js_frameApplyTransform, self.transform, self.layer.anchorPoint);
}

@end
