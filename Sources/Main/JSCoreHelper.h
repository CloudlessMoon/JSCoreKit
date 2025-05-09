//
//  JSCoreHelper.h
//  JSCoreKit
//
//  Created by jiasong on 2021/1/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSCoreHelper : NSObject

@property (class, nonatomic, readonly) BOOL isDebug;

/**
 用一个 identifier 标记某一段 block，使其对应该 identifier 只会被运行一次
 @param identifier 唯一的标记，建议在 identifier 里添加当前这段业务的特有名称，例如用于 swizzle 的可以加“swizzled”前缀，以避免与其他业务共用同一个 identifier 引发 bug
 @param block 要执行的一段逻辑
 */
+ (BOOL)executeOnceWithIdentifier:(NSString *)identifier usingBlock:(void (NS_NOESCAPE ^)(void))block;

/** 判断当前版本号和目标版本号
 @param currentVersion 当前版本号
 @param targetVersion 目标版本号
 @return currentVersion大于targetVersion时返回NSOrderedDescending, 相等时返回NSOrderedSame, 小于时返回NSOrderedAscending
 */
+ (NSComparisonResult)compareVersion:(NSString *)currentVersion toVersion:(NSString *)targetVersion;

@end

NS_ASSUME_NONNULL_END
