//
//  QDCustomizeActionView.h
//  QDCustomizeAction
//
//  Created by Assassin on 2019/11/13.
//  Copyright © 2019 com.tencent.demo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QDCustomizeActionHelper.h"
#import "QDCustomizeShared.h"

NS_ASSUME_NONNULL_BEGIN

@class QDCustomizeActionView,QDCustomizeViewButton;
@protocol QDCustomizeAlertViewDelegate;

typedef NS_ENUM(NSUInteger, QDAlertViewWindowLevel) {
    QDAlertViewWindowLevelAboveStatusBar = 0,
    QDAlertViewWindowLevelBelowStatusBar = 1
};

typedef NS_ENUM(NSUInteger, QDAlertViewStyle) {
    QDAlertViewStyleAlert       = 0,
    QDAlertViewStyleActionSheet = 1
};

#pragma mark - Types

typedef void (^ _Nullable QDAlertViewCompletionHandler)();
typedef void (^ _Nullable QDAlertViewHandler)(QDCustomizeActionView * _Nonnull alertView);
typedef void (^ _Nullable QDAlertViewActionHandler)(QDCustomizeActionView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title);

extern NSString * _Nonnull const QDAlertViewActionNotification;
extern NSString * _Nonnull const QDAlertViewCancelNotification;

extern NSString * _Nonnull const QDAlertViewDidDismissAfterActionNotification;
extern NSString * _Nonnull const QDAlertViewDidDismissAfterCancelNotification;

@interface QDCustomizeActionView : NSObject <UIAppearance>

@property (assign, nonatomic, readonly, getter=isShowing) BOOL showing;

@property (assign, nonatomic, readonly, getter=isVisible) BOOL visible;

@property (assign, nonatomic, readonly) QDAlertViewStyle style;

@property (assign, nonatomic) CGFloat cancelButtonOffsetY UI_APPEARANCE_SELECTOR;
/** Default is NSNotFound */
@property (assign, nonatomic) CGFloat heightMax UI_APPEARANCE_SELECTOR;
/**
 Top and bottom offsets from borders of the screen
 Default is 8.0
 */
@property (assign, nonatomic) CGFloat offsetVertical UI_APPEARANCE_SELECTOR;

/** Default is LGAlertViewWindowLevelAboveStatusBar */
@property (assign, nonatomic) QDAlertViewWindowLevel windowLevel;
/** View that you associate to alert view while initialization */
@property (strong, nonatomic, readonly, nullable) UIView *innerView;

/** Default is 0 */
@property (assign, nonatomic) NSInteger tag;

@property (assign, nonatomic) CGFloat width UI_APPEARANCE_SELECTOR;

@property (strong, nonatomic, nullable) UIColor *tintColor;

@property (strong, nonatomic, nullable) UIColor *separatorsColor UI_APPEARANCE_SELECTOR;
/** Default is NO */
@property (assign, nonatomic, getter=isShowsVerticalScrollIndicator) BOOL showsVerticalScrollIndicator UI_APPEARANCE_SELECTOR;

/**
Default is [UIColor colorWithWhite:0.0 alpha:0.35]
*/
@property (strong, nonatomic, nullable) UIColor *coverColor;
/** Default is nil */
@property (strong, nonatomic, nullable) UIBlurEffect *coverBlurEffect UI_APPEARANCE_SELECTOR;
/** Default is 1.0 */
@property (assign, nonatomic) CGFloat coverAlpha UI_APPEARANCE_SELECTOR;
/** Default is UIColor.whiteColor */
@property (strong, nonatomic, nullable) UIColor *backgroundColor UI_APPEARANCE_SELECTOR;
/** Default is nil */
@property (strong, nonatomic, nullable) UIBlurEffect *backgroundBlurEffect UI_APPEARANCE_SELECTOR;

/**
 Default:12.0
 */
@property (assign, nonatomic) CGFloat layerCornerRadius UI_APPEARANCE_SELECTOR;
/** Default is nil */
@property (strong, nonatomic, nullable) UIColor *layerBorderColor UI_APPEARANCE_SELECTOR;
/** Default is 0.0 */
@property (assign, nonatomic) CGFloat layerBorderWidth UI_APPEARANCE_SELECTOR;
/** Default is nil */
@property (strong, nonatomic, nullable) UIColor *layerShadowColor UI_APPEARANCE_SELECTOR;
/** Default is 0.0 */
@property (assign, nonatomic) CGFloat layerShadowRadius UI_APPEARANCE_SELECTOR;
/** Default is CGPointZero */
@property (assign, nonatomic) CGPoint layerShadowOffset UI_APPEARANCE_SELECTOR;

#pragma mark - Animation properties

/** Default is 0.5 */
@property (assign, nonatomic) NSTimeInterval animationDuration;

/**
 Only if (style == QDAlertViewStyleAlert)
 Default is 1.2
 */
@property (assign, nonatomic) CGFloat initialScale UI_APPEARANCE_SELECTOR;

/**
 Only if (style == QDAlertViewStyleAlert)
 Default is 0.95
 */
@property (assign, nonatomic) CGFloat finalScale UI_APPEARANCE_SELECTOR;

#pragma mark - Title properties

@property (copy, nonatomic, readonly, nullable) NSString *title;

/**
 Default:blackColor
 */
@property (strong, nonatomic, nullable) UIColor *titleTextColor UI_APPEARANCE_SELECTOR;
/** Default is NSTextAlignmentCenter */
@property (assign, nonatomic) NSTextAlignment titleTextAlignment UI_APPEARANCE_SELECTOR;

@property (strong, nonatomic, nullable) UIFont *titleFont UI_APPEARANCE_SELECTOR;

#pragma mark - Message properties

@property (copy, nonatomic, readonly, nullable) NSString *message;

@property (strong, nonatomic, nullable) UIColor *messageTextColor UI_APPEARANCE_SELECTOR;
/** Default is NSTextAlignmentCenter */
@property (assign, nonatomic) NSTextAlignment messageTextAlignment UI_APPEARANCE_SELECTOR;
/** Default is [UIFont systemFontOfSize:14.0] */
@property (strong, nonatomic, nullable) UIFont *messageFont UI_APPEARANCE_SELECTOR;

#pragma mark - Buttons properties

/** Default is YES */
@property (assign, nonatomic, getter=isCancelButtonEnabled) BOOL buttonsEnabled;

@property (assign, nonatomic) CGFloat buttonsHeight UI_APPEARANCE_SELECTOR;

/** Default is QDAlertViewButtonIconPositionLeft */
@property (assign, nonatomic) QDAlertViewButtonIconPosition buttonsIconPosition UI_APPEARANCE_SELECTOR;

#pragma mark - Cancel button properties

@property (copy, nonatomic, readonly, nullable) NSString *cancelButtonTitle;
/** Default is YES */
@property (assign, nonatomic, getter=isCancelButtonEnabled) BOOL cancelButtonEnabled;
/** Default is tintColor */
@property (strong, nonatomic, nullable) UIColor *cancelButtonTitleColor UI_APPEARANCE_SELECTOR;

#pragma mark - Delegate

@property (weak, nonatomic, nullable) id <QDCustomizeAlertViewDelegate> delegate;

#pragma mark - CallBacks

/** To avoid retain cycle, do not forget about weak reference to self */
@property (copy, nonatomic) QDAlertViewHandler willDismissHandler;
/** To avoid retain cycle, do not forget about weak reference to self */
@property (copy, nonatomic) QDAlertViewHandler didDismissHandler;
/** To avoid retain cycle, do not forget about weak reference to self */
@property (copy, nonatomic) QDAlertViewActionHandler actionHandler;
/** To avoid retain cycle, do not forget about weak reference to self */
@property (copy, nonatomic) QDAlertViewHandler cancelHandler;

#pragma mark - function

- (nonnull instancetype)initWithViewAndTitle:(nullable NSString *)title style:(QDAlertViewStyle)style;

- (void)showAnimated:(BOOL)animated completionHandler:(QDAlertViewCompletionHandler)completionHandler;

- (void)layoutValidateWithSize:(CGSize)size;

- (void)addAction:(QDCustomizeViewButton *)action;

@end

#pragma mark - Delegate

@protocol QDCustomizeAlertViewDelegate <NSObject>

@optional

- (void)alertViewWillShow:(nonnull QDCustomizeActionView *)alertView;
- (void)alertViewDidShow:(nonnull QDCustomizeActionView *)alertView;

- (void)alertViewWillDismiss:(nonnull QDCustomizeActionView *)alertView;
- (void)alertViewDidDismiss:(nonnull QDCustomizeActionView *)alertView;

- (void)alertView:(nonnull QDCustomizeActionView *)alertView clickedButtonAtIndex:(NSUInteger)index title:(nullable NSString *)title;
- (void)alertViewCancelled:(nonnull QDCustomizeActionView *)alertView;
- (void)alertViewDestructed:(nonnull QDCustomizeActionView *)alertView;

- (void)alertView:(nonnull QDCustomizeActionView *)alertView didDismissAfterClickedButtonAtIndex:(NSUInteger)index title:(nullable NSString *)title;
- (void)alertViewDidDismissAfterCancelled:(nonnull QDCustomizeActionView *)alertView;
- (void)alertViewDidDismissAfterDestructed:(nonnull QDCustomizeActionView *)alertView;

@end

NS_ASSUME_NONNULL_END
