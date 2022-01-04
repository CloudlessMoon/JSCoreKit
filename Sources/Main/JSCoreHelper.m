//
//  JSCoreHelper.m
//  JSCoreKit
//
//  Created by jiasong on 2021/1/22.
//

#import "JSCoreHelper.h"

@implementation JSCoreHelper

+ (BOOL)executeOnceWithIdentifier:(NSString *)identifier usingBlock:(void (NS_NOESCAPE ^)(void))block {
    if (!block || identifier.length == 0) {
        return NO;
    }
    static dispatch_once_t onceToken;
    static NSMutableSet<NSString *> *executedIdentifiers;
    static dispatch_queue_t queue;
    dispatch_once(&onceToken, ^{
        executedIdentifiers = [NSMutableSet set];
        queue = dispatch_queue_create("com.jscorehelper.once.queue", DISPATCH_QUEUE_SERIAL);
    });
    __block BOOL result = NO;
    dispatch_sync(queue, ^{
        if (![executedIdentifiers containsObject:identifier]) {
            [executedIdentifiers addObject:identifier];
            block();
            result = YES;
        }
    });
    return result;
}

@end
