//
//  JSCoreHelper+Device.m
//  JSCoreKit
//
//  Created by jiasong on 2023/1/11.
//

#import "JSCoreHelper+Device.h"

@implementation JSCoreHelper (Device)

+ (BOOL)isMac {
    return self.isMacCatalystApp || self.isiOSAppOnMac;
}

+ (BOOL)isMacCatalystApp {
    static BOOL isMacCatalystApp;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (@available(iOS 13.0, *)) {
            isMacCatalystApp = NSProcessInfo.processInfo.isMacCatalystApp;
        }
    });
    return isMacCatalystApp;
}

+ (BOOL)isiOSAppOnMac {
    static BOOL isiOSAppOnMac;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (@available(iOS 14.0, *)) {
            isiOSAppOnMac = NSProcessInfo.processInfo.isiOSAppOnMac;
        }
    });
    return isiOSAppOnMac;
}

+ (BOOL)isIPad {
    static BOOL isIPad;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isIPad = UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad;
    });
    return isIPad;
}

+ (BOOL)isIPod {
    static BOOL isIPod;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isIPod = [UIDevice.currentDevice.model rangeOfString:@"iPod touch"].location != NSNotFound;
    });
    return isIPod;
}

+ (BOOL)isIPhone {
    static BOOL isIPhone;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isIPhone = [UIDevice.currentDevice.model rangeOfString:@"iPhone"].location != NSNotFound;
    });
    return isIPhone;
}

+ (BOOL)isSimulator {
    static BOOL isSimulator;
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
