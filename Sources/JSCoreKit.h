//
//  JSCoreKit.h
//  JSCoreKit
//
//  Created by jiasong on 2020/12/12.
//  Copyright © 2020 jiasong. All rights reserved.
//

#ifndef JSCoreKit_h
#define JSCoreKit_h

#if __has_include(<JSCoreKit/JSCoreKit.h>)

#import <JSCoreKit/JSCoreMacroVariable.h>
#import <JSCoreKit/JSCoreMacroMethod.h>
#import <JSCoreKit/JSCoreWeakProxy.h>
#import <JSCoreKit/NSObject+JSCore.h>
#import <JSCoreKit/UIView+JSCoreLayout.h>
#import <JSCoreKit/UIScrollView+JSCore.h>
#import <JSCoreKit/CALayer+JSCore.h>
#import <JSCoreKit/JSCoreHelper.h>
#import <JSCoreKit/JSCoreHelper+Animation.h>
#import <JSCoreKit/JSCoreHelper+Device.h>

#else

#import "JSCoreMacroVariable.h"
#import "JSCoreMacroMethod.h"
#import "JSCoreWeakProxy.h"
#import "NSObject+JSCore.h"
#import "UIView+JSCoreLayout.h"
#import "UIScrollView+JSCore.h"
#import "CALayer+JSCore.h"
#import "JSCoreHelper.h"
#import "JSCoreHelper+Animation.h"
#import "JSCoreHelper+Device.h"

#endif /* __has_include */

#endif /* JSCoreKit_h */
