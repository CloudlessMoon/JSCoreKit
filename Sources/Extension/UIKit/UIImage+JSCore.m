//
//  UIImage+JSCore.m
//  JSCoreKit
//
//  Created by jiasong on 2024/10/16.
//

#import "UIImage+JSCore.h"
#import "JSCoreMacroMethod.h"

@implementation UIImage (JSCore)

- (BOOL)js_opaque {
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(self.CGImage);
    BOOL opaque = alphaInfo == kCGImageAlphaNoneSkipLast
    || alphaInfo == kCGImageAlphaNoneSkipFirst
    || alphaInfo == kCGImageAlphaNone;
    return opaque;
}

- (UIImage *)js_imageResizedInLimitedSize:(CGSize)size {
    return [self js_imageResizedInLimitedSize:size resizingMode:JSCoreImageResizingModeScaleAspectFit];
}

- (UIImage *)js_imageResizedInLimitedSize:(CGSize)size resizingMode:(JSCoreImageResizingMode)resizingMode {
    CGSize imageSize = self.size;
    CGFloat scale = self.scale;
    CGRect drawingRect = CGRectZero;// 图片绘制的 rect
    CGSize contextSize = CGSizeZero;// 画布的大小
    
    if (CGSizeEqualToSize(size, imageSize) && scale == self.scale) {
        return self;
    }
    
    if (resizingMode >= JSCoreImageResizingModeScaleAspectFit && resizingMode <= JSCoreImageResizingModeScaleAspectFillBottom) {
        CGFloat horizontalRatio = size.width / imageSize.width;
        CGFloat verticalRatio = size.height / imageSize.height;
        CGFloat ratio = 0;
        if (resizingMode >= JSCoreImageResizingModeScaleAspectFill && resizingMode < (JSCoreImageResizingModeScaleAspectFill + 10)) {
            ratio = MAX(horizontalRatio, verticalRatio);
        } else {
            // 默认按 JSCoreImageResizingModeScaleAspectFit
            ratio = MIN(horizontalRatio, verticalRatio);
        }
        CGSize resizedSize = CGSizeMake(imageSize.width * ratio, imageSize.height * ratio);
        contextSize = CGSizeMake(MIN(size.width, resizedSize.width), MIN(size.height, resizedSize.height));
        drawingRect.origin.x = JSCGFloatGetCenter(contextSize.width, resizedSize.width);
        
        CGFloat originY = 0;
        if (resizingMode % 10 == 1) {
            // toTop
            originY = 0;
        } else if (resizingMode % 10 == 2) {
            // toBottom
            originY = contextSize.height - resizedSize.height;
        } else {
            // default is Center
            originY = JSCGFloatGetCenter(contextSize.height, resizedSize.height);
        }
        drawingRect.origin.y = originY;
        
        drawingRect.size = resizedSize;
    } else {
        // 默认按照 JSCoreImageResizingModeScaleToFill
        drawingRect = JSCGRectMakeWithSize(size);
        contextSize = size;
    }
    
    return [UIImage js_imageWithSize:contextSize opaque:self.js_opaque scale:scale actions:^(CGContextRef contextRef) {
        [self drawInRect:drawingRect];
    }];
}

+ (UIImage *)js_imageWithSize:(CGSize)size opaque:(BOOL)opaque scale:(CGFloat)scale actions:(void (^)(CGContextRef contextRef))actionBlock {
    if (!actionBlock || JSCGSizeIsEmpty(size)) {
        return nil;
    }
    UIGraphicsImageRendererFormat *format = [[UIGraphicsImageRendererFormat alloc] init];
    format.scale = scale;
    format.opaque = opaque;
    UIGraphicsImageRenderer *render = [[UIGraphicsImageRenderer alloc] initWithSize:size format:format];
    UIImage *imageOut = [render imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
        CGContextRef context = rendererContext.CGContext;
        actionBlock(context);
    }];
    return imageOut;
}

@end
