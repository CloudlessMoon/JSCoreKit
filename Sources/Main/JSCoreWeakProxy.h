//
//  JSCoreWeakProxy.h
//  JSCoreKit
//
//  Created by jiasong on 2020/8/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSCoreWeakProxy : NSProxy

@property (nullable, nonatomic, weak) id target;

- (instancetype)initWithTarget:(nullable id)target;
+ (instancetype)proxyWithTarget:(nullable id)target;

- (id)forwardingTargetForSelector:(SEL)aSelector;

@end

NS_ASSUME_NONNULL_END
