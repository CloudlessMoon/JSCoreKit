//
//  JSCoreHelper+Device.m
//  JSCoreKit
//
//  Created by jiasong on 2023/1/11.
//

#import "JSCoreHelper+Device.h"
#import <UIKit/UIKit.h>

@implementation JSCoreHelper (Device)

+ (BOOL)isMac {
    return self.isMacCatalystApp || self.isiOSAppOnMac;
}

+ (BOOL)isMacCatalystApp {
    static BOOL isMacCatalystApp = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (@available(iOS 13.0, *)) {
            isMacCatalystApp = NSProcessInfo.processInfo.isMacCatalystApp;
        }
    });
    return isMacCatalystApp;
}

+ (BOOL)isiOSAppOnMac {
    static BOOL isiOSAppOnMac = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (@available(iOS 14.0, *)) {
            isiOSAppOnMac = NSProcessInfo.processInfo.isiOSAppOnMac;
        }
    });
    return isiOSAppOnMac;
}

+ (BOOL)isiOSAppOnVision {
    static BOOL isiOSAppOnVision = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (@available(iOS 26.1, *)) {
            isiOSAppOnVision = NSProcessInfo.processInfo.isiOSAppOnVision;
        } else {
            isiOSAppOnVision = NSClassFromString(@"UIWindowSceneGeometryPreferencesVision") != nil;
        }
    });
    return isiOSAppOnVision;
}

+ (BOOL)isIPad {
    static BOOL isIPad = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isIPad = UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad;
    });
    return isIPad;
}

+ (BOOL)isIPod {
    static BOOL isIPod = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isIPod = [UIDevice.currentDevice.model rangeOfString:@"iPod touch"].location != NSNotFound;
    });
    return isIPod;
}

+ (BOOL)isIPhone {
    static BOOL isIPhone = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isIPhone = [UIDevice.currentDevice.model rangeOfString:@"iPhone"].location != NSNotFound;
    });
    return isIPhone;
}

+ (BOOL)isSimulator {
    static BOOL isSimulator = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
#if TARGET_OS_SIMULATOR
        isSimulator = YES;
#else
        isSimulator = NO;
#endif
    });
    return isSimulator;
}

@end
