//
//  UIView+JSCoreLayout.h
//  JSCoreKit
//
//  Created by jiasong on 2020/8/24.
//  Copyright © 2020 jiasong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN const CGSize JSCoreViewFixedSizeNone;

@interface UIView (JSCoreLayout)

/// 等价于 CGRectGetMinY(frame)
@property (nonatomic, assign) CGFloat js_top;

/// 等价于 CGRectGetMinX(frame)
@property (nonatomic, assign) CGFloat js_left;

/// 等价于 CGRectGetMaxY(frame)
@property (nonatomic, assign) CGFloat js_bottom;

/// 等价于 CGRectGetMaxX(frame)
@property (nonatomic, assign) CGFloat js_right;

/// 等价于 CGRectGetWidth(frame)
@property (nonatomic, assign) CGFloat js_width;

/// 等价于 CGRectGetHeight(frame)
@property (nonatomic, assign) CGFloat js_height;

/// 等价于 self.frame.origin
@property (nonatomic, assign) CGPoint js_origin;

/// 等价于 self.frame.size
@property (nonatomic, assign) CGSize js_size;

/// 固定 size
@property (nonatomic, assign) CGSize js_fixedSize;

/// 将要设置的 frame 用 CGRectApplyAffineTransformWithAnchorPoint 处理后再设置
@property (nonatomic, assign) CGRect js_frameApplyTransform;

/// sizeThatFits
@property (nullable, nonatomic, copy) CGSize (^js_sizeThatFitsBlock)(__kindof UIView *view, CGSize size, CGSize originalValue);

@end

NS_ASSUME_NONNULL_END
