//
//  UIImage+JSCore.h
//  JSCoreKit
//
//  Created by jiasong on 2024/10/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JSCoreImageResizingMode) {
    JSCoreImageResizingModeScaleToFill            = 0,    // 将图片缩放到给定的大小，不考虑宽高比例
    JSCoreImageResizingModeScaleAspectFit         = 10,   // 默认的缩放方式，将图片保持宽高比例不变的情况下缩放到不超过给定的大小（但缩放后的大小不一定与给定大小相等），不会产生空白也不会产生裁剪
    JSCoreImageResizingModeScaleAspectFill        = 20,   // 将图片保持宽高比例不变的情况下缩放到不超过给定的大小（但缩放后的大小不一定与给定大小相等），若有内容超出则会被裁剪。若裁剪则上下居中裁剪。
    JSCoreImageResizingModeScaleAspectFillTop,            // 将图片保持宽高比例不变的情况下缩放到不超过给定的大小（但缩放后的大小不一定与给定大小相等），若有内容超出则会被裁剪。若裁剪则水平居中、垂直居上裁剪。
    JSCoreImageResizingModeScaleAspectFillBottom          // 将图片保持宽高比例不变的情况下缩放到不超过给定的大小（但缩放后的大小不一定与给定大小相等），若有内容超出则会被裁剪。若裁剪则水平居中、垂直居下裁剪。
};

@interface UIImage (JSCore)

@property (nonatomic, readonly) BOOL js_opaque;

- (nullable UIImage *)js_imageResizedInLimitedSize:(CGSize)size;
- (nullable UIImage *)js_imageResizedInLimitedSize:(CGSize)size resizingMode:(JSCoreImageResizingMode)resizingMode;

@end

NS_ASSUME_NONNULL_END
