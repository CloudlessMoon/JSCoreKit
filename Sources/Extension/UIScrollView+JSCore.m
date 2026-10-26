//
//  UIScrollView+JSCore.m
//  JSCoreKit
//
//  Created by jiasong on 2021/4/30.
//

#import "UIScrollView+JSCore.h"
#import "JSCoreMacroMethod.h"
#import "UIView+JSCoreLayout.h"

@interface UIScrollView (__JSCore)

@property (nullable, nonatomic, strong) NSMutableDictionary<NSString *, NSMutableDictionary<NSString *, JSScrollViewDelegateSubscriber> *> *js_scrollDelegateSubscribers;

@property (nullable, nonatomic, strong) NSMutableArray *js_endScrollingCompletions;

@end

@interface JSScrollViewDelegateCancellable ()

@property (nullable, nonatomic, copy) NSString *identifier;
@property (nullable, nonatomic, weak) UIScrollView *view;
@property (nullable, nonatomic, copy) NSString *name;

- (instancetype)initWithIdentifier:(nullable NSString *)identifier view:(nullable UIScrollView *)view name:(nullable NSString *)name;

@end

@implementation UIScrollView (JSCore)

JSSynthesizeIdStrongProperty(js_scrollDelegateSubscribers, setJs_scrollDelegateSubscribers)
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
                [selfObject.js_endScrollingCompletions.copy enumerateObjectsUsingBlock:^(void(^completion)(void), NSUInteger idx, BOOL *stop) {
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

- (JSScrollViewDelegateCancellable *)js_addDidScrollSubscriber:(JSScrollViewDelegateSubscriber)subscriber {
    static SEL selector;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        selector = NSSelectorFromString([NSString stringWithFormat:@"_%@%@", @"notify", @"DidScroll"]);
    });
    return [self js_addScrollDelegateForName:@"JSCoreScrollViewDidScrollKey"
                                    selector:selector
                                  subscriber:subscriber];
}

- (JSScrollViewDelegateCancellable *)js_addAdjustedContentInsetSubscriber:(JSScrollViewDelegateSubscriber)subscriber {
    static SEL selector;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        selector = @selector(adjustedContentInsetDidChange);
    });
    return [self js_addScrollDelegateForName:@"JSCoreScrollViewAdjustedContentInsetKey"
                                    selector:selector
                                  subscriber:subscriber];
}

#pragma mark - Private

- (JSScrollViewDelegateCancellable *)js_addScrollDelegateForName:(NSString * const)name
                                                        selector:(const SEL)selector
                                                      subscriber:(JSScrollViewDelegateSubscriber)subscriber {
    if (!subscriber) {
        NSAssert(NO, @"");
        return [[JSScrollViewDelegateCancellable alloc] initWithIdentifier:nil view:nil name:nil];
    }

    static NSUInteger subscriberIdentifier = 0;
    subscriberIdentifier = subscriberIdentifier + 1;

    NSString *identifier = @(subscriberIdentifier).stringValue;
    [self __js_setScrollDelegateSubscriber:subscriber forIdentifier:identifier name:name];

    Class scrollViewClass = self.class;
    [JSCoreHelper executeOnceWithIdentifier:[NSString stringWithFormat:@"%@_%@", NSStringFromClass(scrollViewClass), name]
                                 usingBlock:^{
        JSRuntimeExtendImplementationOfVoidMethodWithoutArguments(scrollViewClass, selector, ^(UIScrollView *selfObject) {
            if (![selfObject isMemberOfClass:scrollViewClass]) {
                return;
            }
            [selfObject __js_callScrollDelegateSubscribersForName:name];
        });
    }];

    return [[JSScrollViewDelegateCancellable alloc] initWithIdentifier:identifier view:self name:name];
}

- (void)__js_setScrollDelegateSubscriber:(nullable JSScrollViewDelegateSubscriber)subscriber forIdentifier:(NSString *)identifier name:(NSString *)name {
    if (!self.js_scrollDelegateSubscribers) {
        self.js_scrollDelegateSubscribers = [NSMutableDictionary dictionary];
    }
    NSMutableDictionary *subscribers = self.js_scrollDelegateSubscribers[name];
    if (!subscribers) {
        subscribers = [NSMutableDictionary dictionary];
        self.js_scrollDelegateSubscribers[name] = subscribers;
    }
    [subscribers setValue:subscriber forKey:identifier];
}

- (void)__js_removeScrollDelegateSubscriberForIdentifier:(NSString *)identifier name:(NSString *)name {
    if (!self.js_scrollDelegateSubscribers || !identifier) {
        return;
    }
    NSMutableDictionary *subscribers = self.js_scrollDelegateSubscribers[name];
    if (!subscribers) {
        return;
    }
    [subscribers removeObjectForKey:identifier];
    if (subscribers.count == 0) {
        [self.js_scrollDelegateSubscribers removeObjectForKey:name];
    }
}

- (void)__js_callScrollDelegateSubscribersForName:(NSString *)name {
    NSMutableDictionary *subscribers = self.js_scrollDelegateSubscribers[name];
    if (subscribers.count == 0) {
        return;
    }
    [subscribers enumerateKeysAndObjectsUsingBlock:^(NSString *key, JSScrollViewDelegateSubscriber subscriber, BOOL *stop) {
        if (subscriber) {
            subscriber(self);
        }
    }];
}

@end

@implementation JSScrollViewDelegateCancellable

- (instancetype)initWithIdentifier:(nullable NSString *)identifier view:(nullable UIScrollView *)view name:(nullable NSString *)name {
    if (self = [super init]) {
        self.identifier = identifier;
        self.view = view;
        self.name = name;
    }
    return self;
}

- (void)dealloc {
    [self cancel];
}

- (void)cancel {
    if (self.view && self.identifier && self.name) {
        [self.view __js_removeScrollDelegateSubscriberForIdentifier:self.identifier name:self.name];
        self.identifier = nil;
    }
}

@end
