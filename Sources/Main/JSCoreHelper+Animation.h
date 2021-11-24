//
//  JSCoreHelper+Animation.h
//  JSCoreKit
//
//  Created by jiasong on 2021/1/22.
//

#import "JSCoreHelper.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JSCoreAnimationExtrapolateType) {
    JSCoreAnimationExtrapolateTypeIdentity = 0,
    JSCoreAnimationExtrapolateTypeClamp,
    JSCoreAnimationExtrapolateTypeExtend,
};

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

/// Convert radians to degrees.
+ (CGFloat)radiansToDegrees:(CGFloat)radians;

/// Convert degrees to radians.
+ (CGFloat)degreesToRadians:(CGFloat)degrees;

/**
 类似系统 UIScrollView 在拖拽到内容尽头时会越拖越难拖的效果。
 @param fromValue 初始值，一般为 0。
 @param toValue 目标值，也即你希望拖拽到的极限距离。
 @param time 当前拖拽距离相对于极限距离的百分比，0 表示在 fromValue，1 表示拖拽到与极限距离相同的大小，大于1表示拖拽得比极限距离还远。
 @param coeff 取值范围-1~+∞。值越大，拖拽的初期越容易拖动。例如 0.1 表示从头到尾都很难拖动，9表示一开始稍微拖一下就可以动很长距离（也可以理解为只需要很短的拖拽动作就可以很快接近极限距离）。-1 表示用默认的 0.55，也即系统的 UIScrollView 的系数。
 @return 返回当前 time 对应的移动距离，返回值大于等于 fromValue，小于 toValue（只会无限接近，不可能等于）。
 */
+ (CGFloat)bounceFromValue:(CGFloat)fromValue
                   toValue:(CGFloat)toValue
                      time:(CGFloat)time
                     coeff:(CGFloat)coeff;

@end

NS_ASSUME_NONNULL_END
