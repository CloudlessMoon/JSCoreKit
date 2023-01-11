//
//  JSCoreHelper+Device.h
//  JSCoreKit
//
//  Created by jiasong on 2023/1/11.
//

#import <JSCoreKit/JSCoreKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSCoreHelper (Device)

@property (class, nonatomic, readonly) BOOL isMac;
@property (class, nonatomic, readonly) BOOL isMacCatalystApp;
@property (class, nonatomic, readonly) BOOL isiOSAppOnMac;

@property (class, nonatomic, readonly) BOOL isIPad;
@property (class, nonatomic, readonly) BOOL isIPod;
@property (class, nonatomic, readonly) BOOL isIPhone;
@property (class, nonatomic, readonly) BOOL isSimulator;

@end

NS_ASSUME_NONNULL_END
