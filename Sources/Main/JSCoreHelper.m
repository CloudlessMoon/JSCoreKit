//
//  JSCoreHelper.m
//  JSCoreKit
//
//  Created by jiasong on 2021/1/22.
//

#import "JSCoreHelper.h"
#import <os/lock.h>

@implementation JSCoreHelper

+ (BOOL)executeOnceWithIdentifier:(NSString *)identifier usingBlock:(void (NS_NOESCAPE ^)(void))block {
    if (!block || identifier.length <= 0) return NO;
    static dispatch_once_t onceToken;
    static NSMutableSet<NSString *> *executedIdentifiers;
    static os_unfair_lock lock;
    dispatch_once(&onceToken, ^{
        executedIdentifiers = [NSMutableSet set];
        lock = OS_UNFAIR_LOCK_INIT;
    });
    os_unfair_lock_lock(&lock);
    BOOL result = NO;
    if (![executedIdentifiers containsObject:identifier]) {
        [executedIdentifiers addObject:identifier];
        block();
        result = YES;
    }
    os_unfair_lock_unlock(&lock);
    return result;
}

@end
