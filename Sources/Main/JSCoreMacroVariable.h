//
//  JSCoreMacroVariable.h
//  JSCoreKit
//
//  Created by jiasong on 2020/8/24.
//

#ifndef JSCoreMacroVariable_h
#define JSCoreMacroVariable_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JSCoreWeakProxy.h"
#import <objc/runtime.h>

#pragma mark - Clang

#define JSArgumentToString(macro) #macro
#define JSClangWarningConcat(warning_name) JSArgumentToString(clang diagnostic ignored warning_name)
#define JSBeginIgnoreClangWarning(warningName) _Pragma("clang diagnostic push") _Pragma(JSClangWarningConcat(#warningName))
#define JSEndIgnoreClangWarning _Pragma("clang diagnostic pop")
#define JSBeginIgnorePerformSelectorLeaksWarning JSBeginIgnoreClangWarning(-Warc-performSelector-leaks)
#define JSEndIgnorePerformSelectorLeaksWarning JSEndIgnoreClangWarning
#define JSBeginIgnoreDeprecatedWarning JSBeginIgnoreClangWarning(-Wdeprecated-declarations)
#define JSEndIgnoreDeprecatedWarning JSEndIgnoreClangWarning

#pragma mark - Synthesize

#define _JSSynthesizeId(_getterName, _setterName, _policy) \
_Pragma("clang diagnostic push") _Pragma(JSClangWarningConcat("-Wmismatched-parameter-types")) _Pragma(JSClangWarningConcat("-Wmismatched-return-types"))\
static char kAssociatedObjectKey_##_getterName;\
- (void)_setterName:(id)_getterName {\
objc_setAssociatedObject(self, &kAssociatedObjectKey_##_getterName, _getterName, OBJC_ASSOCIATION_##_policy##_NONATOMIC);\
}\
\
- (id)_getterName {\
return objc_getAssociatedObject(self, &kAssociatedObjectKey_##_getterName);\
}\
_Pragma("clang diagnostic pop")

#define _JSSynthesizeWeakId(_getterName, _setterName) \
_Pragma("clang diagnostic push") _Pragma(JSClangWarningConcat("-Wmismatched-parameter-types")) _Pragma(JSClangWarningConcat("-Wmismatched-return-types"))\
static char kAssociatedObjectKey_##_getterName;\
- (void)_setterName:(id)_getterName {\
objc_setAssociatedObject(self, &kAssociatedObjectKey_##_getterName, [[JSCoreWeakProxy alloc] initWithTarget:_getterName], OBJC_ASSOCIATION_RETAIN_NONATOMIC);\
}\
\
- (id)_getterName {\
return ((JSCoreWeakProxy *)objc_getAssociatedObject(self, &kAssociatedObjectKey_##_getterName)).target;\
}\
_Pragma("clang diagnostic pop")

#define _JSSynthesizeNonObject(_getterName, _setterName, _type, valueInitializer, valueGetter) \
_Pragma("clang diagnostic push") _Pragma(JSClangWarningConcat("-Wmismatched-parameter-types")) _Pragma(JSClangWarningConcat("-Wmismatched-return-types"))\
static char kAssociatedObjectKey_##_getterName;\
- (void)_setterName:(_type)_getterName {\
objc_setAssociatedObject(self, &kAssociatedObjectKey_##_getterName, [NSNumber valueInitializer:_getterName], OBJC_ASSOCIATION_RETAIN_NONATOMIC);\
}\
\
- (_type)_getterName {\
return [((NSNumber *)objc_getAssociatedObject(self, &kAssociatedObjectKey_##_getterName)) valueGetter];\
}\
_Pragma("clang diagnostic pop")

/// @property (nonatomic, strong) id xxx
#define JSSynthesizeIdStrongProperty(_getterName, _setterName) _JSSynthesizeId(_getterName, _setterName, RETAIN)

/// @property (nonatomic, weak) id xxx
#define JSSynthesizeIdWeakProperty(_getterName, _setterName) _JSSynthesizeWeakId(_getterName, _setterName)

/// @property (nonatomic, copy) id xxx
#define JSSynthesizeIdCopyProperty(_getterName, _setterName) _JSSynthesizeId(_getterName, _setterName, COPY)

#pragma mark - NonObject Marcos

/// @property (nonatomic, assign) Int xxx
#define JSSynthesizeIntProperty(_getterName, _setterName) _JSSynthesizeNonObject(_getterName, _setterName, int, numberWithInt, intValue)

/// @property (nonatomic, assign) unsigned int xxx
#define JSSynthesizeUnsignedIntProperty(_getterName, _setterName) _JSSynthesizeNonObject(_getterName, _setterName, unsigned int, numberWithUnsignedInt, unsignedIntValue)

/// @property (nonatomic, assign) float xxx
#define JSSynthesizeFloatProperty(_getterName, _setterName) _JSSynthesizeNonObject(_getterName, _setterName, float, numberWithFloat, floatValue)

/// @property (nonatomic, assign) double xxx
#define JSSynthesizeDoubleProperty(_getterName, _setterName) _JSSynthesizeNonObject(_getterName, _setterName, double, numberWithDouble, doubleValue)

/// @property (nonatomic, assign) BOOL xxx
#define JSSynthesizeBOOLProperty(_getterName, _setterName) _JSSynthesizeNonObject(_getterName, _setterName, BOOL, numberWithBool, boolValue)

/// @property (nonatomic, assign) NSInteger xxx
#define JSSynthesizeNSIntegerProperty(_getterName, _setterName) _JSSynthesizeNonObject(_getterName, _setterName, NSInteger, numberWithInteger, integerValue)

/// @property (nonatomic, assign) NSUInteger xxx
#define JSSynthesizeNSUIntegerProperty(_getterName, _setterName) _JSSynthesizeNonObject(_getterName, _setterName, NSUInteger, numberWithUnsignedInteger, unsignedIntegerValue)

/// @property (nonatomic, assign) CGFloat xxx
#define JSSynthesizeCGFloatProperty(_getterName, _setterName) _JSSynthesizeNonObject(_getterName, _setterName, CGFloat, numberWithDouble, doubleValue)

/// @property (nonatomic, assign) CGPoint xxx
#define JSSynthesizeCGPointProperty(_getterName, _setterName) _JSSynthesizeNonObject(_getterName, _setterName, CGPoint, valueWithCGPoint, CGPointValue)

/// @property (nonatomic, assign) CGSize xxx
#define JSSynthesizeCGSizeProperty(_getterName, _setterName) _JSSynthesizeNonObject(_getterName, _setterName, CGSize, valueWithCGSize, CGSizeValue)

/// @property (nonatomic, assign) CGRect xxx
#define JSSynthesizeCGRectProperty(_getterName, _setterName) _JSSynthesizeNonObject(_getterName, _setterName, CGRect, valueWithCGRect, CGRectValue)

/// @property (nonatomic, assign) UIEdgeInsets xxx
#define JSSynthesizeUIEdgeInsetsProperty(_getterName, _setterName) _JSSynthesizeNonObject(_getterName, _setterName, UIEdgeInsets, valueWithUIEdgeInsets, UIEdgeInsetsValue)

#endif /* JSCoreMacroVariable_h */
