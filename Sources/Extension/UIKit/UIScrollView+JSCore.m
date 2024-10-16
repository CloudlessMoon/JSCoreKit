//
//  UIScrollView+JSCore.m
//  JSCoreKit
//
//  Created by jiasong on 2021/4/30.
//

#import "UIScrollView+JSCore.h"
#import "JSCoreMacroMethod.h"
#import "UIView+JSCoreLayout.h"

@implementation UIScrollView (JSCore)

- (BOOL)js_canScroll {
    // 没有高度就不用算了，肯定不可滚动，这里只是做个保护
    if (JSCGSizeIsEmpty(self.bounds.size)) {
        return NO;
    }
    BOOL canVerticalScroll = self.contentSize.height + JSUIEdgeInsetsGetVerticalValue(self.adjustedContentInset) > CGRectGetHeight(self.bounds);
    BOOL canHorizontalScoll = self.contentSize.width + JSUIEdgeInsetsGetHorizontalValue(self.adjustedContentInset) > CGRectGetWidth(self.bounds);
    return canVerticalScroll || canHorizontalScoll;
}

- (CGPoint)js_minimumContentOffset {
    return CGPointMake(-self.adjustedContentInset.left, -self.adjustedContentInset.top);
}

- (CGPoint)js_maximumContentOffset {
    CGPoint minimum = self.js_minimumContentOffset;
    CGPoint maximum = CGPointMake(self.contentSize.width - CGRectGetWidth(self.bounds) + self.adjustedContentInset.right,
                                  self.contentSize.height - CGRectGetHeight(self.bounds) + self.adjustedContentInset.bottom);
    return CGPointMake(MAX(minimum.x, maximum.x), MAX(minimum.y, maximum.y));
}

- (void)js_scrollToOffset:(CGPoint)offset animated:(BOOL)animated {
    if (!self.js_canScroll) {
        return;
    }
    
    CGPoint minimumOffset = self.js_minimumContentOffset;
    CGPoint maximumOffset = self.js_maximumContentOffset;
    CGFloat x = MIN(MAX(offset.x, minimumOffset.x), maximumOffset.x);
    CGFloat y = MIN(MAX(offset.y, minimumOffset.y), maximumOffset.y);
    [self setContentOffset:CGPointMake(x, y) animated:animated];
}

@end
