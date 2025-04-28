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
    static dispatch_once_t onceToken;
    static NSMutableSet<NSString *> *executedIdentifiers;
    static os_unfair_lock lock;
    dispatch_once(&onceToken, ^{
        executedIdentifiers = [NSMutableSet set];
        lock = OS_UNFAIR_LOCK_INIT;
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

+ (NSComparisonResult)compareVersion:(NSString *)currentVersion toVersion:(NSString *)targetVersion {
    currentVersion = currentVersion ? : @"";
    targetVersion = targetVersion ? : @"";
    
    NSArray<NSString *> *currentVersions = [currentVersion componentsSeparatedByString:@"."];
    NSArray<NSString *> *targetVersions = [targetVersion componentsSeparatedByString:@"."];
    /// 针对两位版本号进行特殊处理
    /// 比如：外部设置double类型等于8.88，转换为字符串时有可能变为@"8.880000000001"
    /// 假设与@"8.99"相比较就会出现错误，本来是Ascending，会变为Descending
    if (currentVersions.count == 2 && targetVersions.count == 2) {
        double current = currentVersion.doubleValue;
        double target = targetVersion.doubleValue;
        if (current > target) {
            return NSOrderedDescending;
        } else if (current < target) {
            return NSOrderedAscending;
        } else {
            return NSOrderedSame;
        }
    } else {
        return [currentVersion compare:targetVersion options:NSNumericSearch];
    }
}

@end
