//
//  JSCoreHelper+Animation.m
//  JSCoreKit
//
//  Created by jiasong on 2021/1/22.
//

#import "JSCoreHelper+Animation.h"

@implementation JSCoreHelper (Animation)

+ (UIViewAnimationOptions)animationOptionsCurveIn {
    return 8<<16;
}

+ (UIViewAnimationOptions)animationOptionsCurveOut {
    return 7<<16;
}

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
        if (extrapolateRight == JSCoreAnimationExtrapolateTypeIdentity) {
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
    return degrees * M_PI / 180.0;
}

+ (CGFloat)bounceFromValue:(CGFloat)fromValue toValue:(CGFloat)toValue time:(CGFloat)time coeff:(CGFloat)coeff {
    // 以下算法来源于社区：
    // How UIScrollView works: https://medium.com/@esskeetit/how-uiscrollview-works-e418adc47060
    // Grant Paul's Twitter: https://twitter.com/chpwn/status/285540192096497664
    coeff = coeff == -1 ? 0.55 : coeff;// 0.55 为系统 UIScrollView 的默认系数，这里我们也将其作为我们的默认系数
    CGFloat d = toValue;
    CGFloat x = (d - fromValue) * time;
    CGFloat result = fromValue + d + 1.0 - (1.0 / (coeff * x / d + 1)) * d;
    //    NSLog(@"[%.2f-%.2f], coeff = %.2f, x = %.2f, result = %.2f", fromValue, d, coeff, x, result);
    return result;
}

@end
