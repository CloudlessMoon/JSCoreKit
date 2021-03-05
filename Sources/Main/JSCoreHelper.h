//
//  JSCoreHelper.h
//  JSCoreKit
//
//  Created by jiasong on 2020/11/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JSCoreAnimationExtrapolateType) {
    JSCoreAnimationExtrapolateTypeIdentity = 0,
    JSCoreAnimationExtrapolateTypeClamp,
    JSCoreAnimationExtrapolateTypeExtend,
};

@interface JSCoreHelper : NSObject

/**
 用一个 identifier 标记某一段 block，使其对应该 identifier 只会被运行一次
 @param identifier 唯一的标记，建议在 identifier 里添加当前这段业务的特有名称，例如用于 swizzle 的可以加“swizzled”前缀，以避免与其他业务共用同一个 identifier 引发 bug
 @param block 要执行的一段逻辑
 */
+ (BOOL)executeOnceWithIdentifier:(NSString *)identifier usingBlock:(void (NS_NOESCAPE ^)(void))block;

@end

@interface JSCoreHelper (Device)

/// 如 iPhone12,5、iPad6,8
/// @NEW_DEVICE_CHECKER
@property (class, nonatomic, readonly) NSString *deviceModel;

/// 如 iPhone 11 Pro Max、iPad Pro (12.9 inch)，如果是模拟器，会在后面带上“ Simulator”字样。
/// @NEW_DEVICE_CHECKER
@property (class, nonatomic, readonly) NSString *deviceName;

@property (class, nonatomic, readonly) BOOL isMac;
@property (class, nonatomic, readonly) BOOL isIPad;
@property (class, nonatomic, readonly) BOOL isIPod;
@property (class, nonatomic, readonly) BOOL isIPhone;
@property (class, nonatomic, readonly) BOOL isSimulator;

/// 是否来自小组件
@property (class, nonatomic, readonly) BOOL isAppExtension;

/// 操作系统版本号，只获取第二级的版本号，例如 10.3.1 只会得到 10.3
@property (class, nonatomic, readonly) double versionForiOS;

/// 带物理凹槽的刘海屏或者使用 Home Indicator 类型的设备
@property (class, nonatomic, readonly) BOOL isNotchedScreen;

/// iPhone 12 Pro Max
@property (class, nonatomic, readonly) BOOL is67InchScreen;

/// iPhone XS Max / 11 Pro Max
@property (class, nonatomic, readonly) BOOL is65InchScreen;

/// iPhone 12 / 12 Pro
@property (class, nonatomic, readonly) BOOL is61InchScreenAndiPhone12;

/// iPhone XR / 11
@property (class, nonatomic, readonly) BOOL is61InchScreen;

/// iPhone X / XS / 11Pro
@property (class, nonatomic, readonly) BOOL is58InchScreen;

/// iPhone 8 Plus
@property (class, nonatomic, readonly) BOOL is55InchScreen;

/// iPhone 12 mini
@property (class, nonatomic, readonly) BOOL is54InchScreen;

/// iPhone 8
@property (class, nonatomic, readonly) BOOL is47InchScreen;

/// iPhone 5
@property (class, nonatomic, readonly) BOOL is40InchScreen;

/// iPhone 4
@property (class, nonatomic, readonly) BOOL is35InchScreen;

@property (class, nonatomic, readonly) CGSize screenSizeFor67Inch;
@property (class, nonatomic, readonly) CGSize screenSizeFor65Inch;
@property (class, nonatomic, readonly) CGSize screenSizeFor61InchAndiPhone12;
@property (class, nonatomic, readonly) CGSize screenSizeFor61Inch;
@property (class, nonatomic, readonly) CGSize screenSizeFor58Inch;
@property (class, nonatomic, readonly) CGSize screenSizeFor55Inch;
@property (class, nonatomic, readonly) CGSize screenSizeFor54Inch;
@property (class, nonatomic, readonly) CGSize screenSizeFor47Inch;
@property (class, nonatomic, readonly) CGSize screenSizeFor40Inch;
@property (class, nonatomic, readonly) CGSize screenSizeFor35Inch;

/// 用于获取 isNotchedScreen 设备的 insets，注意对于 iPad Pro 11-inch 这种无刘海凹槽但却有使用 Home Indicator 的设备，它的 top 返回0，bottom 返回 safeAreaInsets.bottom 的值
@property (class, nonatomic, readonly) UIEdgeInsets safeAreaInsetsForDeviceWithNotch;

/// 系统设置里是否开启了“放大显示-试图-放大”，支持放大模式的 iPhone 设备可在官方文档中查询 https://support.apple.com/zh-cn/guide/iphone/iphd6804774e/ios
/// @NEW_DEVICE_CHECKER
@property (class, nonatomic, readonly) BOOL isZoomedMode;

/// 是否横竖屏
/// 用户界面横屏了才会返回YES
@property (class, nonatomic, readonly) BOOL isLandscape;

/// 无论支不支持横屏，只要设备横屏了，就会返回YES
@property (class, nonatomic, readonly) BOOL isLandscapeDevice;

/// 状态栏动态高度
@property (class, nonatomic, readonly) CGFloat statusBarHeight;

/// 导航栏高度
/// @NEW_DEVICE_CHECKER
@property (class, nonatomic, readonly) CGFloat navigationBarHeight;

/// 状态栏动态高度 + 导航栏高度
/// @NEW_DEVICE_CHECKER
@property (class, nonatomic, readonly) CGFloat navigationContentTop;

/// toolBar相关frame
/// @NEW_DEVICE_CHECKER
@property (class, nonatomic, readonly) CGFloat toolBarHeight;

/// tabBar相关frame
/// @NEW_DEVICE_CHECKER
@property (class, nonatomic, readonly) CGFloat tabBarHeight;

/// 屏幕尺寸，会根据横竖屏的变化而变化
@property (class, nonatomic, readonly) CGSize screenSize;

/// 设备尺寸，跟横竖屏无关
@property (class, nonatomic, readonly) CGSize deviceSize;

/// 在 iPad 分屏模式下可获得实际运行区域的窗口大小，如需适配 iPad 分屏，建议用这个方法来代替 [UIScreen mainScreen].bounds.size
@property (class, nonatomic, readonly) CGSize applicationSize;

/// 判断当前是否是处于分屏模式的 iPad
@property (class, nonatomic, readonly) BOOL isSplitScreenForiPad;

/// 获取一像素的大小
@property (class, nonatomic, readonly) CGFloat pixelOne;

@end

#pragma mark - 动画

@interface JSCoreHelper (Animation)

/// 插值器，线性插值 inputRange:[0, 100]  outputRange:[0.5, 1]，用于手势
+ (CGFloat)interpolateValue:(CGFloat)value
                 inputRange:(NSArray<NSNumber *> *)inputRange
                outputRange:(NSArray<NSNumber *> *)outputRange
            extrapolateLeft:(JSCoreAnimationExtrapolateType)extrapolateLeft
           extrapolateRight:(JSCoreAnimationExtrapolateType)extrapolateRight;

/// 按照中心缩放之后偏移的XY值
+ (CGPoint)scaleOffsetPointInSize:(CGSize)size
                           scaleX:(CGFloat)scaleX
                           scaleY:(CGFloat)scaleY;

+ (CGFloat)radiansToDegrees:(CGFloat)radians;

+ (CGFloat)degreesToRadians:(CGFloat)degrees;

@end

NS_ASSUME_NONNULL_END
