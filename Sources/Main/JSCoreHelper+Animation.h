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

@property (class, nonatomic, readonly) UIViewAnimationOptions animationOptionsCurveIn NS_REFINED_FOR_SWIFT;
@property (class, nonatomic, readonly) UIViewAnimationOptions animationOptionsCurveOut NS_REFINED_FOR_SWIFT;

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
