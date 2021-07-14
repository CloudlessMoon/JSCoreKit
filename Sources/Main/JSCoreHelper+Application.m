//
//  JSCoreHelper+Application.m
//  JSCoreKit
//
//  Created by jiasong on 2021/7/8.
//

#import "JSCoreHelper+Application.h"
#import "JSCoreHelper+Device.h"
#import "JSCoreHelper+LayoutGuide.h"

@implementation JSCoreHelper (Application)

+ (NSString *)appVersion {
    static NSString *appVersion = @"";
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appVersion = [NSBundle.mainBundle.infoDictionary objectForKey:@"CFBundleShortVersionString"];
    });
    return appVersion;
}

+ (NSString *)appBuildVersion {
    static NSString *appBuildVersion = @"";
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appBuildVersion = [NSBundle.mainBundle.infoDictionary objectForKey:@"CFBundleVersion"];
    });
    return appBuildVersion;
}

static NSInteger isAppExtension = -1;
+ (BOOL)isAppExtension {
    if (isAppExtension < 0) {
        isAppExtension = [NSBundle.mainBundle.bundlePath hasSuffix:@".appex"] ? 1 : 0;
    }
    return isAppExtension > 0;
}

+ (BOOL)isSplitScreen {
    return (self.isIPad && self.applicationSize.width != self.screenSize.width);
}

@end
