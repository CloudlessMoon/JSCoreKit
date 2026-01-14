//
//  NSNotificationCenter+JSSubscription.h.m
//  JSCoreKit
//
//  Created by jiasong on 2024/6/28.
//

#import "NSNotificationCenter+JSSubscription.h"
#import <objc/runtime.h>
#import <os/lock.h>

@interface JSNotificationCancellable () {
    os_unfair_lock _lock;
}

@property (nullable, nonatomic, weak) NSNotificationCenter *notificationCenter;
@property (nullable, nonatomic, weak) id<NSObject> observer;

- (instancetype)initWithNotificationCenter:(NSNotificationCenter *)notificationCenter observer:(id<NSObject>)observer;

@end

@implementation NSNotificationCenter (JSSubscription)

- (JSNotificationCancellable *)js_addSubscriberForName:(NSNotificationName)name
                                                object:(nullable id)obj
                                                 queue:(nullable dispatch_queue_t)queue
                                            usingBlock:(void (^)(NSNotification *notification))block {
    NSOperationQueue *operationQueue = nil;
    if (queue != nil) {
        if (queue == dispatch_get_main_queue()) {
            operationQueue = NSOperationQueue.mainQueue;
        } else {
            operationQueue = [[NSOperationQueue alloc] init];
            operationQueue.underlyingQueue = queue;
        }
    }
    id<NSObject> observer = [self addObserverForName:name object:obj queue:operationQueue usingBlock:^(NSNotification *notification) {
        if (block) {
            block(notification);
        }
    }];
    return [[JSNotificationCancellable alloc] initWithNotificationCenter:self observer:observer];
}

@end

@implementation JSNotificationCancellable

- (instancetype)initWithNotificationCenter:(NSNotificationCenter *)notificationCenter observer:(id<NSObject>)observer {
    if (self = [super init]) {
        self.notificationCenter = notificationCenter;
        self.observer = observer;
        
        _lock = OS_UNFAIR_LOCK_INIT;
    }
    return self;
}

- (void)dealloc {
    [self cancel];
}

- (void)cancel {
    [self addLock];
    if (self.notificationCenter && self.observer) {
        [self.notificationCenter removeObserver:self.observer];
        self.observer = nil;
    }
    [self unLock];
}

- (void)addLock {
    os_unfair_lock_lock(&_lock);
}

- (void)unLock {
    os_unfair_lock_unlock(&_lock);
}

@end
