//
//  NSNotificationCenter+JSSubscription.h
//  JSCoreKit
//
//  Created by jiasong on 2024/6/28.
//

#import <Foundation/Foundation.h>

@class JSNotificationCancellable;

NS_ASSUME_NONNULL_BEGIN

@interface NSNotificationCenter (JSSubscription)

- (JSNotificationCancellable *)js_addSubscriberForName:(NSNotificationName)name
                                                object:(nullable id)obj
                                                 queue:(nullable dispatch_queue_t)queue
                                            usingBlock:(void (^)(NSNotification *notification))block;

@end

@interface JSNotificationCancellable : NSObject

- (instancetype)init NS_UNAVAILABLE;

- (void)cancel;

@end

NS_ASSUME_NONNULL_END
