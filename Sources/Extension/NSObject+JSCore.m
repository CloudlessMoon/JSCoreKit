//
//  NSObject+JSCore.m
//  JSCoreKit
//
//  Created by jiasong on 2020/11/27.
//

#import "NSObject+JSCore.h"
#import <objc/message.h>
#import <objc/runtime.h>

@implementation NSObject (JSCore)

- (BOOL)js_hasOverrideMethod:(SEL)selector ofSuperclass:(Class)superclass {
    return [NSObject js_hasOverrideMethod:selector forClass:self.class ofSuperclass:superclass];
}

+ (BOOL)js_hasOverrideMethod:(SEL)selector forClass:(Class)aClass ofSuperclass:(Class)superclass {
    if (![aClass isSubclassOfClass:superclass]) {
        return NO;
    }
    
    if (![superclass instancesRespondToSelector:selector]) {
        return NO;
    }
    
    Method superclassMethod = class_getInstanceMethod(superclass, selector);
    Method instanceMethod = class_getInstanceMethod(aClass, selector);
    if (!instanceMethod || instanceMethod == superclassMethod) {
        return NO;
    }
    return YES;
}

- (void)js_performSelector:(SEL)selector withPrimitiveReturnValue:(void *)returnValue {
    [self js_performSelector:selector withPrimitiveReturnValue:returnValue arguments:nil];
}

- (void)js_performSelector:(SEL)selector withPrimitiveReturnValue:(void *)returnValue arguments:(void *)firstArgument, ... {
    NSMethodSignature *methodSignature = [self methodSignatureForSelector:selector];
    NSAssert(methodSignature, @"- [%@ js_performSelector:@selector(%@)] 失败，方法不存在。", NSStringFromClass(self.class), NSStringFromSelector(selector));
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    [invocation setTarget:self];
    [invocation setSelector:selector];
    
    if (firstArgument) {
        va_list valist;
        va_start(valist, firstArgument);
        [invocation setArgument:firstArgument atIndex:2];// 0->self, 1->_cmd
        
        void *currentArgument;
        NSInteger index = 3;
        while ((currentArgument = va_arg(valist, void *))) {
            [invocation setArgument:currentArgument atIndex:index];
            index++;
        }
        va_end(valist);
    }
    
    [invocation invoke];
    
    if (returnValue) {
        [invocation getReturnValue:returnValue];
    }
}

@end
