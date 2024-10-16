//
//  JSCoreHelper+LayoutGuide.m
//  JSCoreKit
//
//  Created by jiasong on 2024/10/16.
//

#import "JSCoreHelper+LayoutGuide.h"

@implementation JSCoreHelper (LayoutGuide)

+ (CGFloat)displayScale {
    if (@available(iOS 13.0, *)) {
        NSAssert(UITraitCollection.currentTraitCollection.displayScale >= 1, @"");
        CGFloat displayScale = UITraitCollection.currentTraitCollection.displayScale ? : UIScreen.mainScreen.scale;
        return MAX(displayScale, 1);
    } else {
        return MAX(UIScreen.mainScreen.scale, 1);
    }
}

@end
