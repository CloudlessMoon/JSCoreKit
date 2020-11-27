//
//  NSObject+JSCore.m
//  JSCoreKit
//
//  Created by jiasong on 2020/11/27.
//

#import "NSObject+JSCore.h"

@implementation NSObject (JSCore)

- (void)js_performSelector:(SEL)selector withPrimitiveReturnValue:(void *)returnValue {
    [self js_performSelector:selector withPrimitiveReturnValue:returnValue arguments:nil];
}

- (void)js_performSelector:(SEL)selector withPrimitiveReturnValue:(void *)returnValue arguments:(void *)firstArgument, ... {
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:selector]];
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
