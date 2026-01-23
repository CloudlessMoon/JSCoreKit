//
//  JSCoreHelper+LayoutGuide.m
//  JSCoreKit
//
//  Created by jiasong on 2024/10/16.
//

#import "JSCoreHelper+LayoutGuide.h"
#import <UIKit/UIKit.h>

@implementation JSCoreHelper (LayoutGuide)

+ (CGFloat)displayScale {
    CGFloat displayScale = UIScreen.mainScreen.traitCollection.displayScale;
    NSAssert(displayScale >= 1, @"");
    return MAX(displayScale, 1);
}

@end
