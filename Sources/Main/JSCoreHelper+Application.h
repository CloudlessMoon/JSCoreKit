//
//  JSCoreHelper+Application.h
//  JSCoreKit
//
//  Created by jiasong on 2021/7/8.
//

#import "JSCoreHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSCoreHelper (Application)

/// App版本号
@property (class, nonatomic, readonly) NSString *appVersion;

/// App Build版本号
@property (class, nonatomic, readonly) NSString *appBuildVersion;

/// 是否来自小组件
@property (class, nonatomic, readonly) BOOL isAppExtension;

/// iPad上判断当前是否是处于分屏模式的
@property (class, nonatomic, readonly) BOOL isSplitScreen;

@end

NS_ASSUME_NONNULL_END
