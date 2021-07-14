//
//  JSCoreHelper+LayoutGuide.m
//  JSCoreKit
//
//  Created by jiasong on 2021/7/8.
//

#import "JSCoreHelper+LayoutGuide.h"
#import "JSCoreHelper+Device.h"
#import "UIApplication+JSCore.h"
#import "JSCoreMacroVariable.h"

@implementation JSCoreHelper (LayoutGuide)

static CGFloat pixelOne = -1.0f;
+ (CGFloat)pixelOne {
    if (pixelOne < 0) {
        pixelOne = 1 / [[UIScreen mainScreen] scale];
    }
    return pixelOne;
}

+ (UIStatusBarStyle)statusBarStyleDarkContent {
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleDarkContent;
    } else {
        return UIStatusBarStyleDefault;
    }
}

+ (UIEdgeInsets)safeAreaInsetsForDeviceWithNotch {
    NSAssert(NSThread.isMainThread, @"请在主线程调用！");
    UIEdgeInsets insets = UIEdgeInsetsZero;
    if (@available(iOS 11, *)) {
        UIWindow *window = UIApplication.sharedApplication.js_keyWindow;
        if (window) {
            insets = window.safeAreaInsets;
        }
    }
    return insets;
}

+ (CGFloat)statusBarHeight {
    NSAssert(NSThread.isMainThread, @"请在主线程调用！");
    JSBeginIgnoreDeprecatedWarning
    /// 如果是全面屏且状态栏隐藏的情况下, 需要使用safeAreaInsets, 以保证外部布局时, UI不会被遮挡
    BOOL isStatusBarHidden = UIApplication.sharedApplication.isStatusBarHidden;
    if ((self.isNotchedScreen && isStatusBarHidden) || self.isMac) {
        UIEdgeInsets insets = self.safeAreaInsetsForDeviceWithNotch;
        return insets.top;
    } else {
        return CGRectGetMaxY(UIApplication.sharedApplication.statusBarFrame);
    }
    JSEndIgnoreDeprecatedWarning
}

+ (CGFloat)navigationBarHeight {
    return (self.isIPad ? (self.systemVersion >= 12.0 ? 50 : 44) : (self.isLandscape ? (self.isRegularScreen ? 44 : 32) : 44));
}

+ (CGFloat)navigationContentTop {
    return self.statusBarHeight + self.navigationBarHeight;
}

+ (CGFloat)toolBarHeight {
    return (self.isIPad ? ([self isNotchedScreen] ? 70 : (self.systemVersion >= 12.0 ? 50 : 44)) : (self.isLandscape ? (self.isRegularScreen ? 44 : 32) : 44) + self.safeAreaInsetsForDeviceWithNotch.bottom);
}

+ (CGFloat)tabBarHeight {
    return (self.isIPad ? ([self isNotchedScreen] ? 65 : (self.systemVersion >= 12.0 ? 50 : 49)) : (self.isLandscape ? (self.isRegularScreen ? 49 : 32) : 49) + self.safeAreaInsetsForDeviceWithNotch.bottom);
}

+ (CGSize)applicationSize {
    JSBeginIgnoreDeprecatedWarning
    CGRect applicationFrame = [UIScreen mainScreen].applicationFrame;
    JSEndIgnoreDeprecatedWarning
    /// applicationFrame 在 iPad 下返回的 size 要比 window 实际的 size 小，这个差值体现在 origin 上，所以用 origin + size 修正得到正确的大小。
    return CGSizeMake(applicationFrame.size.width + applicationFrame.origin.x,
                      applicationFrame.size.height + applicationFrame.origin.y);
}

+ (BOOL)isLandscape {
    JSBeginIgnoreDeprecatedWarning
    return UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication.statusBarOrientation);
    JSEndIgnoreDeprecatedWarning
}

+ (BOOL)isLandscapeDevice {
    return UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation]);
}

+ (CGSize)screenSize {
    return UIScreen.mainScreen.bounds.size;
}

+ (CGSize)deviceSize {
    return CGSizeMake(MIN(self.screenSize.width, self.screenSize.height),
                      MAX(self.screenSize.width, self.screenSize.height));
}

@end
