//
//  NSObject+JSCore.h
//  JSCoreKit
//
//  Created by jiasong on 2020/11/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (JSCore)

/**
 *  调用一个无参数、返回值类型为非对象的 selector。如果返回值类型为对象，请直接使用系统的 performSelector: 方法。
 *  @param selector 要被调用的方法名
 *  @param returnValue selector 的返回值的指针地址，请先定义一个变量再将其指针地址传进来，例如 &result
 *
 *  @code
 *  CGFloat alpha;
 *  [view qmui_performSelector:@selector(alpha) withPrimitiveReturnValue:&alpha];
 *  @endcode
 */
- (void)js_performSelector:(SEL)selector withPrimitiveReturnValue:(nullable void *)returnValue;

@end

NS_ASSUME_NONNULL_END
