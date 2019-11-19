//
//  QDCustomizeActionHelper.m
//  QDCustomizeAction
//
//  Created by Assassin on 2019/11/13.
//  Copyright © 2019 com.tencent.demo. All rights reserved.
//

#import "QDCustomizeActionHelper.h"
#import "QDCustomizeActionView.h"

CGFloat const QDAlertViewPaddingWidth = 10.0;
CGFloat const QDAlertViewPaddingHeight = 8.0;
CGFloat const QDAlertViewButtonImageOffsetFromTitle = 8.0;

@implementation QDCustomizeActionHelper

+ (void)animateWithDuration:(NSTimeInterval)duration
                 animations:(void(^)())animations
                 completion:(void(^)(BOOL finished))completion {
    [UIView animateWithDuration:duration
                          delay:0.0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0.5
                        options:0
                     animations:animations
                     completion:completion];
}

+ (void)keyboardAnimateWithNotificationUserInfo:(NSDictionary *)notificationUserInfo
                                     animations:(void(^)(CGFloat keyboardHeight))animations {
    CGFloat keyboardHeight = (notificationUserInfo[UIKeyboardFrameEndUserInfoKey] ? CGRectGetHeight([notificationUserInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue]) : 0.0);

    if (!keyboardHeight) return;

    NSTimeInterval animationDuration = [notificationUserInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    int animationCurve = [notificationUserInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];

    if (animations) {
        animations(keyboardHeight);
    }

    [UIView commitAnimations];
}

+ (BOOL)isViewControllerBasedStatusBarAppearance {
    static BOOL isViewControllerBasedStatusBarAppearance;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        if (UIDevice.currentDevice.systemVersion.floatValue >= 9.0) {
            isViewControllerBasedStatusBarAppearance = YES;
        }
        else {
            NSNumber *viewControllerBasedStatusBarAppearance = [NSBundle.mainBundle objectForInfoDictionaryKey:@"UIViewControllerBasedStatusBarAppearance"];
            isViewControllerBasedStatusBarAppearance = (viewControllerBasedStatusBarAppearance == nil ? YES : viewControllerBasedStatusBarAppearance.boolValue);
        }
    });

    return isViewControllerBasedStatusBarAppearance;
}

+ (BOOL)isCancelButtonSeparate:(QDCustomizeActionView *)alertView {
    return alertView.style == QDAlertViewStyleActionSheet && alertView.cancelButtonOffsetY != NSNotFound && alertView.cancelButtonOffsetY > 0.0;
}

+ (CGFloat)statusBarHeight {
    UIApplication *sharedApplication = [UIApplication sharedApplication];
    return sharedApplication.isStatusBarHidden ? 0.0 : CGRectGetHeight(sharedApplication.statusBarFrame);
}

+ (UIWindow *)appWindow {
    return [UIApplication sharedApplication].windows[0];
}

+ (UIWindow *)keyWindow {
    return [UIApplication sharedApplication].keyWindow;
}

+ (CGFloat)separatorHeight {
    return 1.0;
}

+ (CGFloat)homeIndicatorHeight
{
    CGFloat height = 0;
    if (@available(iOS 11.0, *)) {
        height += [UIApplication sharedApplication].delegate.window.safeAreaInsets.bottom;
    }
    return height;
}

+ (UIImage *)image1x1WithColor:(UIColor *)color {
    if (!color) return nil;

    CGRect rect = CGRectMake(0.0, 0.0, 1.0, 1.0);

    UIGraphicsBeginImageContext(rect.size);

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

@end
