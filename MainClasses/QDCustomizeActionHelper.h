//
//  QDCustomizeActionHelper.h
//  QDCustomizeAction
//
//  Created by Assassin on 2019/11/13.
//  Copyright © 2019 com.tencent.demo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class QDCustomizeActionView;

static inline BOOL isIPhoneXSeries() {
    BOOL iPhoneXSeries = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return iPhoneXSeries;
    }
    
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            iPhoneXSeries = YES;
        }
    }
    
    return iPhoneXSeries;
}

static inline double kStatusBarAndNavigationBarHeight() {
    if (&isIPhoneXSeries) {
        return 68.f;
    }
    
    return 44.f;
}

extern CGFloat const QDAlertViewPaddingWidth;
extern CGFloat const QDAlertViewPaddingHeight;
extern CGFloat const QDAlertViewButtonImageOffsetFromTitle;

@interface QDCustomizeActionHelper : NSObject

+ (void)animateWithDuration:(NSTimeInterval)duration
                 animations:(void(^)())animations
                 completion:(void(^)(BOOL finished))completion;

+ (void)keyboardAnimateWithNotificationUserInfo:(NSDictionary *)notificationUserInfo
                                     animations:(void(^)(CGFloat keyboardHeight))animations;

+ (UIWindow *)appWindow;
+ (UIWindow *)keyWindow;
+ (CGFloat)separatorHeight;
+ (CGFloat)statusBarHeight;
+ (CGFloat)homeIndicatorHeight;

+ (BOOL)isCancelButtonSeparate:(QDCustomizeActionView *)alertView;

+ (UIImage *)image1x1WithColor:(UIColor *)color;

+ (BOOL)isViewControllerBasedStatusBarAppearance;

@end

NS_ASSUME_NONNULL_END
