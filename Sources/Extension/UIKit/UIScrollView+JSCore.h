//
//  UIScrollView+JSCore.h
//  JSCoreKit
//
//  Created by jiasong on 2021/4/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (JSCore)

@property (nonatomic, readonly) BOOL js_canScroll;
/// 最小偏移量
@property (nonatomic, readonly) CGPoint js_minimumContentOffset;
/// 最大偏移量
@property (nonatomic, readonly) CGPoint js_maximumContentOffset;

/// 超出区域则只会滚动到最大区域
- (void)js_scrollToOffset:(CGPoint)offset animated:(BOOL)animated NS_SWIFT_NAME(js_scrollTo(_:animated:));

@end

NS_ASSUME_NONNULL_END
