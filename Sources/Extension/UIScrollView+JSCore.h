//
//  UIScrollView+JSCore.h
//  JSCoreKit
//
//  Created by jiasong on 2021/4/30.
//

#import <UIKit/UIKit.h>

@class JSNotificationCancellable;

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (JSCore)

@property (nonatomic, readonly) BOOL js_canScroll;

/// 最小偏移量
@property (nonatomic, readonly) CGPoint js_minimumContentOffset;
/// 最大偏移量
@property (nonatomic, readonly) CGPoint js_maximumContentOffset;

- (void)js_setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated completion:(nullable void(^)(void))completion;

/// 超出区域则只会滚动到最大区域
- (void)js_scrollToOffset:(CGPoint)offset animated:(BOOL)animated completion:(nullable void(^)(void))completion;

/// - (void)scrollViewDidScroll
- (JSNotificationCancellable *)js_addDidScrollSubscriber:(void(^)(__kindof UIScrollView *scrollView))subscriber;

@end

NS_ASSUME_NONNULL_END
