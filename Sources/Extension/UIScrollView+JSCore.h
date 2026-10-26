//
//  UIScrollView+JSCore.h
//  JSCoreKit
//
//  Created by jiasong on 2021/4/30.
//

#import <UIKit/UIKit.h>

@class JSScrollViewDelegateCancellable;

NS_ASSUME_NONNULL_BEGIN

typedef void(^JSScrollViewDelegateSubscriber)(__kindof UIScrollView *scrollView) NS_SWIFT_UNAVAILABLE("");

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
- (JSScrollViewDelegateCancellable *)js_addDidScrollSubscriber:(JSScrollViewDelegateSubscriber)subscriber;

/// - (void)adjustedContentInsetDidChange
- (JSScrollViewDelegateCancellable *)js_addAdjustedContentInsetSubscriber:(JSScrollViewDelegateSubscriber)subscriber;

@end

@interface JSScrollViewDelegateCancellable : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (void)cancel;

@end

NS_ASSUME_NONNULL_END
