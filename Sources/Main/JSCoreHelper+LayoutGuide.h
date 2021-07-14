//
//  JSCoreHelper+LayoutGuide.h
//  JSCoreKit
//
//  Created by jiasong on 2021/7/8.
//

#import "JSCoreHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSCoreHelper (LayoutGuide)

/// 在 iOS 13 以上返回 UIStatusBarStyleDarkContent，在 iOS 12 及以下返回 UIStatusBarStyleDefault
@property (class, nonatomic, readonly) UIStatusBarStyle statusBarStyleDarkContent;

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

/// 用于获取 isNotchedScreen 设备的 insets，注意对于 iPad Pro 11-inch 这种无刘海凹槽但却有使用 Home Indicator 的设备，它的 top 返回0，bottom 返回 safeAreaInsets.bottom 的值
@property (class, nonatomic, readonly) UIEdgeInsets safeAreaInsetsForDeviceWithNotch;

/// 获取一像素的大小
@property (class, nonatomic, readonly) CGFloat pixelOne;

/// 用户界面横屏了才会返回YES
@property (class, nonatomic, readonly) BOOL isLandscape;

/// 无论支不支持横屏，只要设备横屏了，就会返回YES
@property (class, nonatomic, readonly) BOOL isLandscapeDevice;

/// 屏幕尺寸，会根据横竖屏的变化而变化
@property (class, nonatomic, readonly) CGSize screenSize;

/// 设备尺寸，跟横竖屏无关
@property (class, nonatomic, readonly) CGSize deviceSize;

/// 在 iPad 分屏模式下可获得实际运行区域的窗口大小，如需适配 iPad 分屏，建议用这个方法来代替 [UIScreen mainScreen].bounds.size
@property (class, nonatomic, readonly) CGSize applicationSize;

@end

NS_ASSUME_NONNULL_END
