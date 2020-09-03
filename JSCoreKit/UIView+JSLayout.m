//
//  UIView+JSLayout.m
//  JSCoreKit
//
//  Created by jiasong on 2020/8/24.
//  Copyright © 2020 jiasong. All rights reserved.
//

#import "UIView+JSLayout.h"
#import "JSCommonDefines.h"

@implementation UIView (JSLayout)

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

@end
