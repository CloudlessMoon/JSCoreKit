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
#import <sys/utsname.h>

@interface JSCoreHelperEmptyViewController : UIViewController
@end
@implementation JSCoreHelperEmptyViewController
- (BOOL)shouldAutorotate {
    return NO;
}
@end

@implementation JSCoreHelper

+ (BOOL)executeOnceWithIdentifier:(NSString *)identifier usingBlock:(void (NS_NOESCAPE ^)(void))block {
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

@implementation JSCoreHelper (Device)

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

+ (NSString *)deviceModel {
    if (self.isSimulator) {
        // Simulator doesn't return the identifier for the actual physical model, but returns it as an environment variable
        // 模拟器不返回物理机器信息，但会通过环境变量的方式返回
        return [NSString stringWithFormat:@"%s", getenv("SIMULATOR_MODEL_IDENTIFIER")];
    }
    
    // See https://www.theiphonewiki.com/wiki/Models for identifiers
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

+ (NSString *)deviceName {
    static dispatch_once_t onceToken;
    static NSString *name;
    dispatch_once(&onceToken, ^{
        NSString *model = [self deviceModel];
        if (!model) {
            name = @"Unknown Device";
            return;
        }
        
        NSDictionary *dict = @{
            // See https://www.theiphonewiki.com/wiki/Models
            @"iPhone1,1" : @"iPhone 1G",
            @"iPhone1,2" : @"iPhone 3G",
            @"iPhone2,1" : @"iPhone 3GS",
            @"iPhone3,1" : @"iPhone 4 (GSM)",
            @"iPhone3,2" : @"iPhone 4",
            @"iPhone3,3" : @"iPhone 4 (CDMA)",
            @"iPhone4,1" : @"iPhone 4S",
            @"iPhone5,1" : @"iPhone 5",
            @"iPhone5,2" : @"iPhone 5",
            @"iPhone5,3" : @"iPhone 5c",
            @"iPhone5,4" : @"iPhone 5c",
            @"iPhone6,1" : @"iPhone 5s",
            @"iPhone6,2" : @"iPhone 5s",
            @"iPhone7,1" : @"iPhone 6 Plus",
            @"iPhone7,2" : @"iPhone 6",
            @"iPhone8,1" : @"iPhone 6s",
            @"iPhone8,2" : @"iPhone 6s Plus",
            @"iPhone8,4" : @"iPhone SE",
            @"iPhone9,1" : @"iPhone 7",
            @"iPhone9,2" : @"iPhone 7 Plus",
            @"iPhone9,3" : @"iPhone 7",
            @"iPhone9,4" : @"iPhone 7 Plus",
            @"iPhone10,1" : @"iPhone 8",
            @"iPhone10,2" : @"iPhone 8 Plus",
            @"iPhone10,3" : @"iPhone X",
            @"iPhone10,4" : @"iPhone 8",
            @"iPhone10,5" : @"iPhone 8 Plus",
            @"iPhone10,6" : @"iPhone X",
            @"iPhone11,2" : @"iPhone XS",
            @"iPhone11,4" : @"iPhone XS Max",
            @"iPhone11,6" : @"iPhone XS Max CN",
            @"iPhone11,8" : @"iPhone XR",
            @"iPhone12,1" : @"iPhone 11",
            @"iPhone12,3" : @"iPhone 11 Pro",
            @"iPhone12,5" : @"iPhone 11 Pro Max",
            @"iPhone12,8" : @"iPhone SE (2nd generation)",
            @"iPhone13,1" : @"iPhone 12 mini",
            @"iPhone13,2" : @"iPhone 12",
            @"iPhone13,3" : @"iPhone 12 Pro",
            @"iPhone13,4" : @"iPhone 12 Pro Max",
            
            @"iPad1,1" : @"iPad 1",
            @"iPad2,1" : @"iPad 2 (WiFi)",
            @"iPad2,2" : @"iPad 2 (GSM)",
            @"iPad2,3" : @"iPad 2 (CDMA)",
            @"iPad2,4" : @"iPad 2",
            @"iPad2,5" : @"iPad mini 1",
            @"iPad2,6" : @"iPad mini 1",
            @"iPad2,7" : @"iPad mini 1",
            @"iPad3,1" : @"iPad 3 (WiFi)",
            @"iPad3,2" : @"iPad 3 (4G)",
            @"iPad3,3" : @"iPad 3 (4G)",
            @"iPad3,4" : @"iPad 4",
            @"iPad3,5" : @"iPad 4",
            @"iPad3,6" : @"iPad 4",
            @"iPad4,1" : @"iPad Air",
            @"iPad4,2" : @"iPad Air",
            @"iPad4,3" : @"iPad Air",
            @"iPad4,4" : @"iPad mini 2",
            @"iPad4,5" : @"iPad mini 2",
            @"iPad4,6" : @"iPad mini 2",
            @"iPad4,7" : @"iPad mini 3",
            @"iPad4,8" : @"iPad mini 3",
            @"iPad4,9" : @"iPad mini 3",
            @"iPad5,1" : @"iPad mini 4",
            @"iPad5,2" : @"iPad mini 4",
            @"iPad5,3" : @"iPad Air 2",
            @"iPad5,4" : @"iPad Air 2",
            @"iPad6,3" : @"iPad Pro (9.7 inch)",
            @"iPad6,4" : @"iPad Pro (9.7 inch)",
            @"iPad6,7" : @"iPad Pro (12.9 inch)",
            @"iPad6,8" : @"iPad Pro (12.9 inch)",
            @"iPad6,11": @"iPad 5 (WiFi)",
            @"iPad6,12": @"iPad 5 (Cellular)",
            @"iPad7,1" : @"iPad Pro (12.9 inch, 2nd generation)",
            @"iPad7,2" : @"iPad Pro (12.9 inch, 2nd generation)",
            @"iPad7,3" : @"iPad Pro (10.5 inch)",
            @"iPad7,4" : @"iPad Pro (10.5 inch)",
            @"iPad7,5" : @"iPad 6 (WiFi)",
            @"iPad7,6" : @"iPad 6 (Cellular)",
            @"iPad7,11": @"iPad 7 (WiFi)",
            @"iPad7,12": @"iPad 7 (Cellular)",
            @"iPad8,1" : @"iPad Pro (11 inch)",
            @"iPad8,2" : @"iPad Pro (11 inch)",
            @"iPad8,3" : @"iPad Pro (11 inch)",
            @"iPad8,4" : @"iPad Pro (11 inch)",
            @"iPad8,5" : @"iPad Pro (12.9 inch, 3rd generation)",
            @"iPad8,6" : @"iPad Pro (12.9 inch, 3rd generation)",
            @"iPad8,7" : @"iPad Pro (12.9 inch, 3rd generation)",
            @"iPad8,8" : @"iPad Pro (12.9 inch, 3rd generation)",
            @"iPad8,9" : @"iPad Pro (11 inch, 2nd generation)",
            @"iPad8,10" : @"iPad Pro (11 inch, 2nd generation)",
            @"iPad8,11" : @"iPad Pro (12.9 inch, 4th generation)",
            @"iPad8,12" : @"iPad Pro (12.9 inch, 4th generation)",
            @"iPad11,1" : @"iPad mini (5th generation)",
            @"iPad11,2" : @"iPad mini (5th generation)",
            @"iPad11,3" : @"iPad Air (3rd generation)",
            @"iPad11,4" : @"iPad Air (3rd generation)",
            @"iPad11,6" : @"iPad (WiFi)",
            @"iPad11,7" : @"iPad (Cellular)",
            @"iPad13,1" : @"iPad Air (4th generation)",
            @"iPad13,2" : @"iPad Air (4th generation)",
            
            @"iPod1,1" : @"iPod touch 1",
            @"iPod2,1" : @"iPod touch 2",
            @"iPod3,1" : @"iPod touch 3",
            @"iPod4,1" : @"iPod touch 4",
            @"iPod5,1" : @"iPod touch 5",
            @"iPod7,1" : @"iPod touch 6",
            @"iPod9,1" : @"iPod touch 7",
            
            @"i386" : @"Simulator x86",
            @"x86_64" : @"Simulator x64",
            
            @"Watch1,1" : @"Apple Watch 38mm",
            @"Watch1,2" : @"Apple Watch 42mm",
            @"Watch2,3" : @"Apple Watch Series 2 38mm",
            @"Watch2,4" : @"Apple Watch Series 2 42mm",
            @"Watch2,6" : @"Apple Watch Series 1 38mm",
            @"Watch2,7" : @"Apple Watch Series 1 42mm",
            @"Watch3,1" : @"Apple Watch Series 3 38mm",
            @"Watch3,2" : @"Apple Watch Series 3 42mm",
            @"Watch3,3" : @"Apple Watch Series 3 38mm (LTE)",
            @"Watch3,4" : @"Apple Watch Series 3 42mm (LTE)",
            @"Watch4,1" : @"Apple Watch Series 4 40mm",
            @"Watch4,2" : @"Apple Watch Series 4 44mm",
            @"Watch4,3" : @"Apple Watch Series 4 40mm (LTE)",
            @"Watch4,4" : @"Apple Watch Series 4 44mm (LTE)",
            @"Watch5,1" : @"Apple Watch Series 5 40mm",
            @"Watch5,2" : @"Apple Watch Series 5 44mm",
            @"Watch5,3" : @"Apple Watch Series 5 40mm (LTE)",
            @"Watch5,4" : @"Apple Watch Series 5 44mm (LTE)",
            @"Watch5,9" : @"Apple Watch SE 40mm",
            @"Watch5,10" : @"Apple Watch SE 44mm",
            @"Watch5,11" : @"Apple Watch SE 40mm",
            @"Watch5,12" : @"Apple Watch SE 44mm",
            @"Watch6,1"  : @"Apple Watch Series 6 40mm",
            @"Watch6,2"  : @"Apple Watch Series 6 44mm",
            @"Watch6,3"  : @"Apple Watch Series 6 40mm",
            @"Watch6,4"  : @"Apple Watch Series 6 44mm",
            
            @"AudioAccessory1,1" : @"HomePod",
            @"AudioAccessory1,2" : @"HomePod",
            @"AudioAccessory5,1" : @"HomePod mini",
            
            @"AirPods1,1" : @"AirPods (1st generation)",
            @"AirPods2,1" : @"AirPods (2nd generation)",
            @"iProd8,1"   : @"AirPods Pro",
            
            @"AppleTV2,1" : @"Apple TV 2",
            @"AppleTV3,1" : @"Apple TV 3",
            @"AppleTV3,2" : @"Apple TV 3",
            @"AppleTV5,3" : @"Apple TV 4",
            @"AppleTV6,2" : @"Apple TV 4K",
        };
        name = dict[model];
        if (!name) name = model;
        if (self.isSimulator) name = [name stringByAppendingString:@" Simulator"];
    });
    return name;
}

static NSInteger isMac = -1;
+ (BOOL)isMac {
    if (isMac < 0) {
        if (@available(iOS 14.0, *)) {
            isMac = ([NSProcessInfo processInfo].isiOSAppOnMac || [NSProcessInfo processInfo].isMacCatalystApp) ? 1 : 0;
        } else if (@available(iOS 13.0, *)) {
            isMac = [NSProcessInfo processInfo].isMacCatalystApp ? 1 : 0;
        }
    }
    return isMac > 0;
}

static NSInteger isIPad = -1;
+ (BOOL)isIPad {
    if (isIPad < 0) {
        JSBeginIgnoreDeprecatedWarning
        isIPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 1 : 0;
        JSEndIgnoreDeprecatedWarning
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

static NSInteger isAppExtension = -1;
+ (BOOL)isAppExtension {
    if (isAppExtension < 0) {
        isAppExtension = [NSBundle.mainBundle.bundlePath hasSuffix:@".appex"] ? 1 : 0;
    }
    return isAppExtension > 0;
}

+ (double)systemVersion {
    return UIDevice.currentDevice.systemVersion.doubleValue;
}

static NSInteger isNotchedScreen = -1;
+ (BOOL)isNotchedScreen {
    NSAssert(NSThread.isMainThread, @"请在主线程调用！");
    if (@available(iOS 11, *)) {
        if (isNotchedScreen < 0) {
            if (@available(iOS 12.0, *)) {
                /*
                 检测方式解释/测试要点：
                 1. iOS 11 与 iOS 12 可能行为不同，所以要分别测试。
                 2. 与触发 [QMUIHelper isNotchedScreen] 方法时的进程有关，例如 https://github.com/Tencent/QMUI_iOS/issues/482#issuecomment-456051738 里提到的 [NSObject performSelectorOnMainThread:withObject:waitUntilDone:NO] 就会导致较多的异常。
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
                        /// https://github.com/Tencent/QMUI_iOS/issues/1263
                        JSCoreHelperEmptyViewController *viewController = [JSCoreHelperEmptyViewController new];
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

+ (BOOL)isRegularScreen {
    return [self isIPad] || (!self.isZoomedMode && ([self is67InchScreen] || [self is65InchScreen] || [self is61InchScreen] || [self is55InchScreen]));
}

static NSInteger is67InchScreen = -1;
+ (BOOL)is67InchScreen {
    if (is67InchScreen < 0) {
        is67InchScreen = (self.deviceSize.width == self.screenSizeFor67Inch.width && self.deviceSize.height == self.screenSizeFor67Inch.height) ? 1 : 0;
    }
    return is67InchScreen > 0;
}

static NSInteger is65InchScreen = -1;
+ (BOOL)is65InchScreen {
    if (is65InchScreen < 0) {
        // Since iPhone XS Max、iPhone 11 Pro Max and iPhone XR share the same resolution, we have to distinguish them using the model identifiers
        // 由于 iPhone XS Max、iPhone 11 Pro Max 这两款机型和 iPhone XR 的屏幕宽高是一致的，我们通过机器 Identifier 加以区别
        is65InchScreen = (self.deviceSize.width == self.screenSizeFor65Inch.width && self.deviceSize.height == self.screenSizeFor65Inch.height && ([self.deviceModel isEqualToString:@"iPhone11,4"] || [self.deviceModel isEqualToString:@"iPhone11,6"] || [self.deviceModel isEqualToString:@"iPhone12,5"])) ? 1 : 0;
    }
    return is65InchScreen > 0;
}

static NSInteger is61InchScreenAndiPhone12 = -1;
+ (BOOL)is61InchScreenAndiPhone12 {
    if (is61InchScreenAndiPhone12 < 0) {
        is61InchScreenAndiPhone12 = (self.deviceSize.width == self.screenSizeFor61InchAndiPhone12.width && self.deviceSize.height == self.screenSizeFor61InchAndiPhone12.height && ([self.deviceModel isEqualToString:@"iPhone13,2"] || [self.deviceModel isEqualToString:@"iPhone13,3"])) ? 1 : 0;
    }
    return is61InchScreenAndiPhone12 > 0;
}

static NSInteger is61InchScreen = -1;
+ (BOOL)is61InchScreen {
    if (is61InchScreen < 0) {
        is61InchScreen = (self.deviceSize.width == self.screenSizeFor61Inch.width && self.deviceSize.height == self.screenSizeFor61Inch.height && ([self.deviceModel isEqualToString:@"iPhone11,8"] || [self.deviceModel isEqualToString:@"iPhone12,1"])) ? 1 : 0;
    }
    return is61InchScreen > 0;
}

static NSInteger is58InchScreen = -1;
+ (BOOL)is58InchScreen {
    if (is58InchScreen < 0) {
        // Both iPhone XS and iPhone X share the same actual screen sizes, so no need to compare identifiers
        // iPhone XS 和 iPhone X 的物理尺寸是一致的，因此无需比较机器 Identifier
        is58InchScreen = (self.deviceSize.width == self.screenSizeFor58Inch.width && self.deviceSize.height == self.screenSizeFor58Inch.height) ? 1 : 0;
    }
    return is58InchScreen > 0;
}

static NSInteger is55InchScreen = -1;
+ (BOOL)is55InchScreen {
    if (is55InchScreen < 0) {
        is55InchScreen = (self.deviceSize.width == self.screenSizeFor55Inch.width && self.deviceSize.height == self.screenSizeFor55Inch.height) ? 1 : 0;
    }
    return is55InchScreen > 0;
}

static NSInteger is54InchScreen = -1;
+ (BOOL)is54InchScreen {
    if (is54InchScreen < 0) {
        is54InchScreen = (self.deviceSize.width == self.screenSizeFor54Inch.width && self.deviceSize.height == self.screenSizeFor54Inch.height) ? 1 : 0;
    }
    return is54InchScreen > 0;
}

static NSInteger is47InchScreen = -1;
+ (BOOL)is47InchScreen {
    if (is47InchScreen < 0) {
        is47InchScreen = (self.deviceSize.width == self.screenSizeFor47Inch.width && self.deviceSize.height == self.screenSizeFor47Inch.height) ? 1 : 0;
    }
    return is47InchScreen > 0;
}

static NSInteger is40InchScreen = -1;
+ (BOOL)is40InchScreen {
    if (is40InchScreen < 0) {
        is40InchScreen = (self.deviceSize.width == self.screenSizeFor40Inch.width && self.deviceSize.height == self.screenSizeFor40Inch.height) ? 1 : 0;
    }
    return is40InchScreen > 0;
}

static NSInteger is35InchScreen = -1;
+ (BOOL)is35InchScreen {
    if (is35InchScreen < 0) {
        is35InchScreen = (self.deviceSize.width == self.screenSizeFor35Inch.width && self.deviceSize.height == self.screenSizeFor35Inch.height) ? 1 : 0;
    }
    return is35InchScreen > 0;
}

+ (CGSize)screenSizeFor67Inch {
    return CGSizeMake(428, 926);
}

+ (CGSize)screenSizeFor65Inch {
    return CGSizeMake(414, 896);
}

+ (CGSize)screenSizeFor61InchAndiPhone12 {
    return CGSizeMake(390, 844);
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

+ (CGSize)screenSizeFor54Inch {
    return CGSizeMake(375, 812);
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
    UIEdgeInsets insets = UIEdgeInsetsZero;
    if (@available(iOS 11, *)) {
        UIWindow *window = UIApplication.sharedApplication.js_keyWindow;
        if (window) {
            insets = window.safeAreaInsets;
        }
    }
    return insets;
}

+ (BOOL)isLandscape {
    JSBeginIgnoreDeprecatedWarning
    return UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication.statusBarOrientation);
    JSEndIgnoreDeprecatedWarning
}

+ (BOOL)isLandscapeDevice {
    return UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation]);
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

+ (BOOL)isSplitScreenForiPad {
    return (self.isIPad && self.applicationSize.width != self.screenSize.width);
}

+ (BOOL)isZoomedMode {
    if (![self isIPhone]) {
        return NO;
    }
    
    CGFloat nativeScale = UIScreen.mainScreen.nativeScale;
    CGFloat scale = UIScreen.mainScreen.scale;
    
    // 对于所有的 Plus 系列 iPhone，屏幕物理像素低于软件层面的渲染像素，不管标准模式还是放大模式，nativeScale 均小于 scale，所以需要特殊处理才能准确区分放大模式
    // https://www.paintcodeapp.com/news/ultimate-guide-to-iphone-resolutions
    BOOL shouldBeDownsampledDevice = CGSizeEqualToSize(UIScreen.mainScreen.nativeBounds.size, CGSizeMake(1080, 1920));
    if (shouldBeDownsampledDevice) {
        scale /= 1.15;
    }
    
    return nativeScale > scale;
}

+ (CGSize)screenSize {
    return UIScreen.mainScreen.bounds.size;
}

+ (CGSize)deviceSize {
    return CGSizeMake(MIN(self.screenSize.width, self.screenSize.height),
                      MAX(self.screenSize.width, self.screenSize.height));
}

+ (CGSize)applicationSize {
    JSBeginIgnoreDeprecatedWarning
    CGRect applicationFrame = [UIScreen mainScreen].applicationFrame;
    JSEndIgnoreDeprecatedWarning
    /// applicationFrame 在 iPad 下返回的 size 要比 window 实际的 size 小，这个差值体现在 origin 上，所以用 origin + size 修正得到正确的大小。
    return CGSizeMake(applicationFrame.size.width + applicationFrame.origin.x,
                      applicationFrame.size.height + applicationFrame.origin.y);
}

static CGFloat pixelOne = -1.0f;
+ (CGFloat)pixelOne {
    if (pixelOne < 0) {
        pixelOne = 1 / [[UIScreen mainScreen] scale];
    }
    return pixelOne;
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
