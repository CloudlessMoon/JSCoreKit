//
//  JSCoreHelper.m
//  JSCoreKit
//
//  Created by jiasong on 2020/11/27.
//

#import "JSCoreHelper.h"
#import "NSObject+JSCore.h"
#import "JSCoreMacroVariable.h"
#import "UIApplication+JSCore.h"

@implementation JSCoreHelper

+ (BOOL)executeBlock:(void (NS_NOESCAPE ^)(void))block oncePerIdentifier:(NSString *)identifier {
    if (!block || identifier.length <= 0) return NO;
    static dispatch_once_t onceToken;
    static NSMutableSet<NSString *> *_executedIdentifiers;
    static JSLockDeclare(_lock);
    dispatch_once(&onceToken, ^{
        _executedIdentifiers = [NSMutableSet set];
        JSLockInit(_lock);
    });
    JSLockAdd(_lock);
    BOOL result = NO;
    if (![_executedIdentifiers containsObject:identifier]) {
        [_executedIdentifiers addObject:identifier];
        block();
        result = YES;
    }
    JSLockRemove(_lock);
    return result;
}

@end

@implementation JSCoreHelper (UIGraphic)

static CGFloat pixelOne = -1.0f;
+ (CGFloat)pixelOne {
    if (pixelOne < 0) {
        pixelOne = 1 / [[UIScreen mainScreen] scale];
    }
    return pixelOne;
}

@end

@implementation JSCoreHelper (Device)

static NSInteger isIPad = -1;
+ (BOOL)isIPad {
    if (isIPad < 0) {
        // [[[UIDevice currentDevice] model] isEqualToString:@"iPad"] 无法判断模拟器 iPad，所以改为以下方式
        isIPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 1 : 0;
    }
    return isIPad > 0;
}

static NSInteger isIPod = -1;
+ (BOOL)isIPod {
    if (isIPod < 0) {
        NSString *string = [[UIDevice currentDevice] model];
        isIPod = [string rangeOfString:@"iPod touch"].location != NSNotFound ? 1 : 0;
    }
    return isIPod > 0;
}

static NSInteger isIPhone = -1;
+ (BOOL)isIPhone {
    if (isIPhone < 0) {
        NSString *string = [[UIDevice currentDevice] model];
        isIPhone = [string rangeOfString:@"iPhone"].location != NSNotFound ? 1 : 0;
    }
    return isIPhone > 0;
}

static NSInteger isSimulator = -1;
+ (BOOL)isSimulator {
    if (isSimulator < 0) {
#if TARGET_OS_SIMULATOR
        isSimulator = 1;
#else
        isSimulator = 0;
#endif
    }
    return isSimulator > 0;
}

static NSInteger isNotchedScreen = -1;
+ (BOOL)isNotchedScreen {
    if (@available(iOS 11, *)) {
        if (isNotchedScreen < 0) {
            if (@available(iOS 12.0, *)) {
                /*
                 检测方式解释/测试要点：
                 1. iOS 11 与 iOS 12 可能行为不同，所以要分别测试。
                 2. 与触发 [JSCoreHelper isNotchedScreen] 方法时的进程有关，例如 https://github.com/Tencent/QMUI_iOS/issues/482#issuecomment-456051738 里提到的 [NSObject performSelectorOnMainThread:withObject:waitUntilDone:NO] 就会导致较多的异常。
                 3. iOS 12 下，在非第2点里提到的情况下，iPhone、iPad 均可通过 UIScreen -_peripheryInsets 方法的返回值区分，但如果满足了第2点，则 iPad 无法使用这个方法，这种情况下要依赖第4点。
                 4. iOS 12 下，不管是否满足第2点，不管是什么设备类型，均可以通过一个满屏的 UIWindow 的 rootViewController.view.frame.origin.y 的值来区分，如果是非全面屏，这个值必定为20，如果是全面屏，则可能是24或44等不同的值。但由于创建 UIWindow、UIViewController 等均属于较大消耗，所以只在前面的步骤无法区分的情况下才会使用第4点。
                 5. 对于第4点，经测试与当前设备的方向、是否有勾选 project 里的 General - Hide status bar、当前是否处于来电模式的状态栏这些都没关系。
                 */
                SEL peripheryInsetsSelector = NSSelectorFromString([NSString stringWithFormat:@"_%@%@", @"periphery", @"Insets"]);
                UIEdgeInsets peripheryInsets = UIEdgeInsetsZero;
                [[UIScreen mainScreen] js_performSelector:peripheryInsetsSelector withPrimitiveReturnValue:&peripheryInsets];
                if (peripheryInsets.bottom <= 0) {
                    UIWindow *window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
                    peripheryInsets = window.safeAreaInsets;
                    if (peripheryInsets.bottom <= 0) {
                        UIViewController *viewController = [UIViewController new];
                        window.rootViewController = viewController;
                        if (CGRectGetMinY(viewController.view.frame) > 20) {
                            peripheryInsets.bottom = 1;
                        }
                    }
                }
                isNotchedScreen = peripheryInsets.bottom > 0 ? 1 : 0;
            } else {
                isNotchedScreen = [self is58InchScreen] ? 1 : 0;
            }
        }
    } else {
        isNotchedScreen = 0;
    }
    
    return isNotchedScreen > 0;
}

static NSInteger is58InchScreen = -1;
+ (BOOL)is58InchScreen {
    if (is58InchScreen < 0) {
        // Both iPhone XS and iPhone X share the same actual screen sizes, so no need to compare identifiers
        // iPhone XS 和 iPhone X 的物理尺寸是一致的，因此无需比较机器 Identifier
        CGFloat deviceWidth = MIN([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
        CGFloat deviceHeight = MAX([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
        is58InchScreen = (deviceWidth == self.screenSizeFor58Inch.width && deviceHeight == self.screenSizeFor58Inch.height) ? 1 : 0;
    }
    return is58InchScreen > 0;
}

+ (CGSize)screenSizeFor65Inch {
    return CGSizeMake(414, 896);
}

+ (CGSize)screenSizeFor61Inch {
    return CGSizeMake(414, 896);
}

+ (CGSize)screenSizeFor58Inch {
    return CGSizeMake(375, 812);
}

+ (CGSize)screenSizeFor55Inch {
    return CGSizeMake(414, 736);
}

+ (CGSize)screenSizeFor47Inch {
    return CGSizeMake(375, 667);
}

+ (CGSize)screenSizeFor40Inch {
    return CGSizeMake(320, 568);
}

+ (CGSize)screenSizeFor35Inch {
    return CGSizeMake(320, 480);
}

+ (UIEdgeInsets)safeAreaInsetsForDeviceWithNotch {
    NSAssert(NSThread.isMainThread, @"请在主线程调用！");
    if (!self.isNotchedScreen) {
        return UIEdgeInsetsZero;
    }
    UIEdgeInsets insets = UIEdgeInsetsZero;
    UIWindow *window = UIApplication.sharedApplication.js_keyWindow;
    if (window) {
        if (@available(iOS 11.0, *)) {
            insets = window.safeAreaInsets;
        }
    }
    return insets;
}

+ (CGFloat)statusBarHeight {
    NSAssert(NSThread.isMainThread, @"请在主线程调用！");
    JSBeginIgnoreDeprecatedWarning
    return CGRectGetMaxY(UIApplication.sharedApplication.statusBarFrame);
    JSEndIgnoreDeprecatedWarning
}

+ (CGFloat)statusBarHeightConstant {
    JSBeginIgnoreDeprecatedWarning
    BOOL isStatusBarHidden = UIApplication.sharedApplication.isStatusBarHidden;
    JSEndIgnoreDeprecatedWarning
    if (isStatusBarHidden) {
        UIEdgeInsets insets = self.safeAreaInsetsForDeviceWithNotch;
        return insets.top ? : 20;
    } else {
        return self.statusBarHeight;
    }
}

+ (CGSize)applicationSize {
    /// applicationFrame 在 iPad 下返回的 size 要比 window 实际的 size 小，这个差值体现在 origin 上，所以用 origin + size 修正得到正确的大小。
    JSBeginIgnoreDeprecatedWarning
    CGRect applicationFrame = [UIScreen mainScreen].applicationFrame;
    JSEndIgnoreDeprecatedWarning
    return CGSizeMake(applicationFrame.size.width + applicationFrame.origin.x, applicationFrame.size.height + applicationFrame.origin.y);
}

@end

#pragma mark - 动画

@implementation JSCoreHelper (Animation)

+ (CGFloat)interpolateValue:(CGFloat)value
                 inputRange:(NSArray<NSNumber *>*)inputRange
                outputRange:(NSArray<NSNumber *>*)outputRange
            extrapolateLeft:(JSCoreAnimationExtrapolateType)extrapolateLeft
           extrapolateRight:(JSCoreAnimationExtrapolateType)extrapolateRight {
    NSUInteger rangeIndex = [self _findIndexOfNearestValue:value range:inputRange];
    CGFloat inputMin = inputRange[rangeIndex].doubleValue;
    CGFloat inputMax = inputRange[rangeIndex + 1].doubleValue;
    CGFloat outputMin = outputRange[rangeIndex].doubleValue;
    CGFloat outputMax = outputRange[rangeIndex + 1].doubleValue;
    return [self _interpolateValue:value
                          inputMin:inputMin
                          inputMax:inputMax
                         outputMin:outputMin
                         outputMax:outputMax
                   extrapolateLeft:extrapolateLeft
                  extrapolateRight:extrapolateRight];
}

+ (CGFloat)_interpolateValue:(CGFloat)value
                    inputMin:(CGFloat)inputMin
                    inputMax:(CGFloat)inputMax
                   outputMin:(CGFloat)outputMin
                   outputMax:(CGFloat)outputMax
             extrapolateLeft:(JSCoreAnimationExtrapolateType)extrapolateLeft
            extrapolateRight:(JSCoreAnimationExtrapolateType)extrapolateRight {
    if (value < inputMin) {
        if (extrapolateLeft == JSCoreAnimationExtrapolateTypeIdentity) {
            return value;
        } else if (extrapolateLeft == JSCoreAnimationExtrapolateTypeClamp) {
            value = inputMin;
        } else if (extrapolateLeft == JSCoreAnimationExtrapolateTypeExtend) {
            // 不做处理
        }
    }
    if (value > inputMax) {
        if (extrapolateRight ==JSCoreAnimationExtrapolateTypeIdentity) {
            return value;
        } else if (extrapolateRight == JSCoreAnimationExtrapolateTypeClamp) {
            value = inputMax;
        } else if (extrapolateRight == JSCoreAnimationExtrapolateTypeExtend) {
            // 不做处理
        }
    }
    return outputMin + (value - inputMin) * (outputMax - outputMin) / (inputMax - inputMin);
}

+ (NSUInteger)_findIndexOfNearestValue:(CGFloat)value
                                 range:(NSArray *)range {
    NSUInteger index;
    NSUInteger rangeCount = range.count;
    for (index = 1; index < rangeCount - 1; index++) {
        NSNumber *inputValue = range[index];
        if (inputValue.doubleValue >= value) {
            break;
        }
    }
    return index - 1;
}

+ (CGPoint)scaleOffsetPointInSize:(CGSize)size
                           scaleX:(CGFloat)scaleX
                           scaleY:(CGFloat)scaleY {
    CGPoint transformXY;
    transformXY.x = (size.width * (1 - scaleX)) / 2;
    transformXY.y = (size.height * (1 - scaleY)) / 2;
    return transformXY;
}


+ (CGFloat)radiansToDegrees:(CGFloat)radians {
    return radians * 180.0 / M_PI;
}

+ (CGFloat)degreesToRadians:(CGFloat)degrees {
    return degrees / 180.0 * M_PI;
}

@end
