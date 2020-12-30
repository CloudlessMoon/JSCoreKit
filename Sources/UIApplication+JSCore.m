//
//  UIApplication+JSCore.m
//  JSCoreKit
//
//  Created by jiasong on 2020/12/15.
//

#import "UIApplication+JSCore.h"

@implementation UIApplication (JSCore)

- (nullable UIWindow *)js_keyWindow {
    UIWindow *originalKeyWindow = nil;
    if (@available(iOS 13.0, *)) {
        NSSet<UIScene *> *connectedScenes = self.connectedScenes;
        for (UIScene *scene in connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive && [scene isKindOfClass:[UIWindowScene class]]) {
                UIWindowScene *windowScene = (UIWindowScene *)scene;
                for (UIWindow *window in windowScene.windows) {
                    if (window.isKeyWindow) {
                        originalKeyWindow = window;
                        break;
                    }
                }
            }
        }
    }
    if (!originalKeyWindow) {
        UIWindow *window = self.windows.firstObject;
        if (window.isKeyWindow) {
            originalKeyWindow = window;
        } else {
            if (CGRectEqualToRect(self.keyWindow.bounds, UIScreen.mainScreen.bounds)) {
                originalKeyWindow = self.keyWindow;
            } else {
                originalKeyWindow = window;
            }
        }
    }
    return originalKeyWindow;
}

@end
