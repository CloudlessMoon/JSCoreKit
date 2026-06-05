//
//  JSCoreHelper.m
//  JSCoreKit
//
//  Created by jiasong on 2021/1/22.
//

#import "JSCoreHelper.h"
#import <os/lock.h>

@implementation JSCoreHelper

+ (BOOL)isDebug {
#ifdef DEBUG
    return YES;
#else
    return NO;
#endif
}

+ (BOOL)executeOnceWithIdentifier:(NSString *)identifier usingBlock:(void (NS_NOESCAPE ^)(void))block {
    if (!block || identifier.length == 0) {
        return NO;
    }
    static os_unfair_lock lock = OS_UNFAIR_LOCK_INIT;
    static NSMutableSet<NSString *> *executedIdentifiers;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        executedIdentifiers = [NSMutableSet set];
    });
    os_unfair_lock_lock(&lock);
    BOOL result = ![executedIdentifiers containsObject:identifier];
    if (result) {
        [executedIdentifiers addObject:identifier];
    }
    os_unfair_lock_unlock(&lock);
    
    if (result) {
        block();
    }
    return result;
}

@end
