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
    if (self.js_canScroll) {
        return CGPointMake(self.contentSize.width - self.js_width + self.adjustedContentInset.right,
                           self.contentSize.height - self.js_height + self.adjustedContentInset.bottom);
    } else {
        return CGPointMake(-self.adjustedContentInset.left, -self.adjustedContentInset.top);
    }
}

- (void)js_scrollToOffset:(CGPoint)offset animated:(BOOL)animated {
    if (!self.js_canScroll) {
        return;
    }
    
    if (!CGPointEqualToPoint(self.contentOffset, offset)) {
        CGRect maxRect = CGRectMake(-self.adjustedContentInset.left,
                                    -self.adjustedContentInset.top,
                                    self.contentSize.width - self.js_width + self.adjustedContentInset.right + self.adjustedContentInset.left,
                                    self.contentSize.height - self.js_height + self.adjustedContentInset.bottom + self.adjustedContentInset.top);
        if (!CGRectContainsPoint(maxRect, offset)) {
            CGFloat x = MIN(MAX(offset.x, CGRectGetMinX(maxRect)), CGRectGetMaxX(maxRect));
            CGFloat y = MIN(MAX(offset.y, CGRectGetMinY(maxRect)), CGRectGetMaxY(maxRect));
            offset = CGPointMake(x, y);
        }
        [self setContentOffset:offset animated:animated];
    }
}

@end
