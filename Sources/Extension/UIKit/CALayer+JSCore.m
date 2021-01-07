//
//  CALayer+JSCore.m
//  JSCoreKit
//
//  Created by jiasong on 2020/12/13.
//

#import "CALayer+JSCore.h"
#import "JSCoreMacroVariable.h"

@implementation CALayer (JSCore)

- (void)js_removeDefaultAnimations {
    static NSMutableDictionary<NSString *, id<CAAction>> *actions = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        actions = @{NSStringFromSelector(@selector(bounds)): [NSNull null],
                    NSStringFromSelector(@selector(position)): [NSNull null],
                    NSStringFromSelector(@selector(zPosition)): [NSNull null],
                    NSStringFromSelector(@selector(anchorPoint)): [NSNull null],
                    NSStringFromSelector(@selector(anchorPointZ)): [NSNull null],
                    NSStringFromSelector(@selector(transform)): [NSNull null],
                    JSBeginIgnoreClangWarning(-Wundeclared-selector)
                    NSStringFromSelector(@selector(hidden)): [NSNull null],
                    NSStringFromSelector(@selector(doubleSided)): [NSNull null],
                    JSEndIgnoreClangWarning
                    NSStringFromSelector(@selector(sublayerTransform)): [NSNull null],
                    NSStringFromSelector(@selector(masksToBounds)): [NSNull null],
                    NSStringFromSelector(@selector(contents)): [NSNull null],
                    NSStringFromSelector(@selector(contentsRect)): [NSNull null],
                    NSStringFromSelector(@selector(contentsScale)): [NSNull null],
                    NSStringFromSelector(@selector(contentsCenter)): [NSNull null],
                    NSStringFromSelector(@selector(minificationFilterBias)): [NSNull null],
                    NSStringFromSelector(@selector(backgroundColor)): [NSNull null],
                    NSStringFromSelector(@selector(cornerRadius)): [NSNull null],
                    NSStringFromSelector(@selector(borderWidth)): [NSNull null],
                    NSStringFromSelector(@selector(borderColor)): [NSNull null],
                    NSStringFromSelector(@selector(opacity)): [NSNull null],
                    NSStringFromSelector(@selector(compositingFilter)): [NSNull null],
                    NSStringFromSelector(@selector(filters)): [NSNull null],
                    NSStringFromSelector(@selector(backgroundFilters)): [NSNull null],
                    NSStringFromSelector(@selector(shouldRasterize)): [NSNull null],
                    NSStringFromSelector(@selector(rasterizationScale)): [NSNull null],
                    NSStringFromSelector(@selector(shadowColor)): [NSNull null],
                    NSStringFromSelector(@selector(shadowOpacity)): [NSNull null],
                    NSStringFromSelector(@selector(shadowOffset)): [NSNull null],
                    NSStringFromSelector(@selector(shadowRadius)): [NSNull null],
                    NSStringFromSelector(@selector(shadowPath)): [NSNull null]}.mutableCopy;
        
        if (@available(iOS 11.0, *)) {
            [actions addEntriesFromDictionary:@{NSStringFromSelector(@selector(maskedCorners)): [NSNull null]}];
        }
        
        if ([self isKindOfClass:[CAShapeLayer class]]) {
            [actions addEntriesFromDictionary:@{NSStringFromSelector(@selector(path)): [NSNull null],
                                                NSStringFromSelector(@selector(fillColor)): [NSNull null],
                                                NSStringFromSelector(@selector(strokeColor)): [NSNull null],
                                                NSStringFromSelector(@selector(strokeStart)): [NSNull null],
                                                NSStringFromSelector(@selector(strokeEnd)): [NSNull null],
                                                NSStringFromSelector(@selector(lineWidth)): [NSNull null],
                                                NSStringFromSelector(@selector(miterLimit)): [NSNull null],
                                                NSStringFromSelector(@selector(lineDashPhase)): [NSNull null]}];
        }
        
        if ([self isKindOfClass:[CAGradientLayer class]]) {
            [actions addEntriesFromDictionary:@{NSStringFromSelector(@selector(colors)): [NSNull null],
                                                NSStringFromSelector(@selector(locations)): [NSNull null],
                                                NSStringFromSelector(@selector(startPoint)): [NSNull null],
                                                NSStringFromSelector(@selector(endPoint)): [NSNull null]}];
        }
    });
    
    self.actions = actions;
}

@end
