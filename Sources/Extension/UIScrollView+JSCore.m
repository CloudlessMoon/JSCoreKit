//
//  UIScrollView+JSCore.m
//  JSCoreKit
//
//  Created by jiasong on 2021/4/30.
//

#import "UIScrollView+JSCore.h"
#import "NSNotificationCenter+JSSubscription.h"
#import "JSCoreMacroMethod.h"
#import "UIView+JSCoreLayout.h"

@interface UIScrollView (__JSCore)

@property (nullable, nonatomic, strong) NSNotificationCenter *js_scrollViewNotificationCenter;

@property (nullable, nonatomic, strong) NSMutableArray *js_endScrollingCompletions;

@end

@implementation UIScrollView (JSCore)

JSSynthesizeIdStrongProperty(js_scrollViewNotificationCenter, setJs_scrollViewNotificationCenter)
JSSynthesizeIdStrongProperty(js_endScrollingCompletions, setJs_endScrollingCompletions)

- (BOOL)js_canScroll {
    // 没有高度就不用算了，肯定不可滚动，这里只是做个保护
    if (JSCGSizeIsEmpty(self.bounds.size)) {
        return NO;
    }
    BOOL canVerticalScroll = self.contentSize.height + JSUIEdgeInsetsGetVerticalValue(self.adjustedContentInset) > CGRectGetHeight(self.bounds);
    BOOL canHorizontalScoll = self.contentSize.width + JSUIEdgeInsetsGetHorizontalValue(self.adjustedContentInset) > CGRectGetWidth(self.bounds);
    return canVerticalScroll || canHorizontalScoll;
}

- (CGPoint)js_minimumContentOffset {
    return CGPointMake(-self.adjustedContentInset.left, -self.adjustedContentInset.top);
}

- (CGPoint)js_maximumContentOffset {
    CGPoint minimum = self.js_minimumContentOffset;
    CGPoint maximum = CGPointMake(self.contentSize.width - CGRectGetWidth(self.bounds) + self.adjustedContentInset.right,
                                  self.contentSize.height - CGRectGetHeight(self.bounds) + self.adjustedContentInset.bottom);
    return CGPointMake(MAX(minimum.x, maximum.x), MAX(minimum.y, maximum.y));
}

- (void)js_setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated completion:(nullable void(^)(void))completion {
    if (animated && completion) {
        if (!self.js_endScrollingCompletions) {
            self.js_endScrollingCompletions = [NSMutableArray array];
        }
        [self.js_endScrollingCompletions addObject:completion];
    }
    
    [self setContentOffset:contentOffset animated:animated];
    
    if (!animated && completion) {
        completion();
    }
    
    if (animated && completion) {
        Class class = self.class;
        [JSCoreHelper executeOnceWithIdentifier:[NSString stringWithFormat:@"%@ setContentOffset_completion", NSStringFromClass(class)]
                                     usingBlock:^{
            NSString *animationEnded = [NSString stringWithFormat:@"_%@%@%@%@", @"delegate", @"ScrollView", @"Animation", @"Ended"];
            JSRuntimeExtendImplementationOfVoidMethodWithoutArguments(class, NSSelectorFromString(animationEnded), ^(__kindof UIScrollView *selfObject) {
                if (![selfObject isMemberOfClass:class]) {
                    return;
                }
                if (!selfObject.js_endScrollingCompletions) {
                    return;
                }
                [selfObject.js_endScrollingCompletions enumerateObjectsUsingBlock:^(void(^completion)(void), NSUInteger idx, BOOL *stop) {
                    completion();
                }];
                [selfObject.js_endScrollingCompletions removeAllObjects];
            });
        }];
    }
}

- (void)js_scrollToOffset:(CGPoint)offset animated:(BOOL)animated completion:(nullable void(^)(void))completion {
    if (!self.js_canScroll) {
        return;
    }
    
    CGPoint minimumOffset = self.js_minimumContentOffset;
    CGPoint maximumOffset = self.js_maximumContentOffset;
    CGFloat x = MIN(MAX(offset.x, minimumOffset.x), maximumOffset.x);
    CGFloat y = MIN(MAX(offset.y, minimumOffset.y), maximumOffset.y);
    [self js_setContentOffset:CGPointMake(x, y) animated:animated completion:completion];
}

- (JSNotificationCancellable *)js_addDidScrollSubscriber:(void(^)(__kindof UIScrollView *scrollView))subscriber {
    static const NSNotificationName kJSCoreScrollViewDidScrollKey = @"JSCoreScrollViewDidScrollKey";
    
    if (!self.js_scrollViewNotificationCenter) {
        self.js_scrollViewNotificationCenter = [[NSNotificationCenter alloc] init];
    }
    __weak __typeof(self) weakSelf = self;
    JSNotificationCancellable *cancellable = [self.js_scrollViewNotificationCenter js_addSubscriberForName:kJSCoreScrollViewDidScrollKey
                                                                                                    object:self
                                                                                                     queue:nil
                                                                                                usingBlock:^(NSNotification *notification) {
        if (subscriber && weakSelf && notification.object == weakSelf) {
            subscriber(weakSelf);
        }
    }];
    
    Class scrollViewClass = self.class;
    [JSCoreHelper executeOnceWithIdentifier:[NSString stringWithFormat:@"%@_%@", NSStringFromClass(scrollViewClass), NSStringFromSelector(_cmd)]
                                 usingBlock:^{
        static NSString *didScroll;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSString *didScroll1 = [[NSString alloc] initWithData:[[NSData alloc] initWithBase64EncodedString:@"X25vdGlmeQ==" options:NSDataBase64DecodingIgnoreUnknownCharacters] encoding:NSUTF8StringEncoding];
            NSString *didScroll2 = [[NSString alloc] initWithData:[[NSData alloc] initWithBase64EncodedString:@"RGlk" options:NSDataBase64DecodingIgnoreUnknownCharacters] encoding:NSUTF8StringEncoding];
            NSString *didScroll3 = [[NSString alloc] initWithData:[[NSData alloc] initWithBase64EncodedString:@"U2Nyb2xs" options:NSDataBase64DecodingIgnoreUnknownCharacters] encoding:NSUTF8StringEncoding];
            didScroll = [NSString stringWithFormat:@"%@%@%@", didScroll1, didScroll2, didScroll3];
        });
        JSRuntimeExtendImplementationOfVoidMethodWithoutArguments(scrollViewClass, NSSelectorFromString(didScroll), ^(UIScrollView *selfObject) {
            if (![selfObject isMemberOfClass:scrollViewClass]) {
                return;
            }
            if (!selfObject.js_scrollViewNotificationCenter) {
                return;
            }
            [selfObject.js_scrollViewNotificationCenter postNotificationName:kJSCoreScrollViewDidScrollKey object:selfObject];
        });
    }];
    
    return cancellable;
}

@end
