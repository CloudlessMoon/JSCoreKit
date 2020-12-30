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
 @param block 要执行的一段逻辑
 @param identifier 唯一的标记，建议在 identifier 里添加当前这段业务的特有名称，例如用于 swizzle 的可以加“swizzled”前缀，以避免与其他业务共用同一个 identifier 引发 bug
 */
+ (BOOL)executeBlock:(void (NS_NOESCAPE ^)(void))block oncePerIdentifier:(NSString *)identifier;

@end

@interface JSCoreHelper (UIGraphic)

/// 获取一像素的大小
+ (CGFloat)pixelOne;

@end

@interface JSCoreHelper (Device)

+ (BOOL)isIPad;
+ (BOOL)isIPod;
+ (BOOL)isIPhone;
+ (BOOL)isSimulator;

/// 带物理凹槽的刘海屏或者使用 Home Indicator 类型的设备
+ (BOOL)isNotchedScreen;

+ (CGSize)screenSizeFor65Inch;
+ (CGSize)screenSizeFor61Inch;
+ (CGSize)screenSizeFor58Inch;
+ (CGSize)screenSizeFor55Inch;
+ (CGSize)screenSizeFor47Inch;
+ (CGSize)screenSizeFor40Inch;
+ (CGSize)screenSizeFor35Inch;

// 用于获取 isNotchedScreen 设备的 insets，注意对于 iPad Pro 11-inch 这种无刘海凹槽但却有使用 Home Indicator 的设备，它的 top 返回0，bottom 返回 safeAreaInsets.bottom 的值
+ (UIEdgeInsets)safeAreaInsetsForDeviceWithNotch;

// 状态栏动态高度
+ (CGFloat)statusBarHeight;
// 状态栏静态高度
+ (CGFloat)statusBarHeightConstant;

/**
 在 iPad 分屏模式下可获得实际运行区域的窗口大小，如需适配 iPad 分屏，建议用这个方法来代替 [UIScreen mainScreen].bounds.size
 @return 应用运行的窗口大小
 */
+ (CGSize)applicationSize;

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
