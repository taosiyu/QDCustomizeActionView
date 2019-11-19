//
//  QDCustomizeViewButton.h
//  QDCustomizeAction
//
//  Created by Assassin on 2019/11/14.
//  Copyright © 2019 com.tencent.demo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QDCustomizeActionHelper.h"
#import "QDCustomizeShared.h"
#import "QDActionButtonLayout.h"

NS_ASSUME_NONNULL_BEGIN

@class QDCustomizeViewButton;

typedef NS_ENUM(NSInteger,QDAlertActionStyle) {
    QDAlertActionStyleDefault = 0,
    QDAlertActionStyleCancel,
    QDAlertActionStyleDone
};

typedef void(^QDAlertActionHandler)(QDCustomizeViewButton *_Nonnull);

@interface QDCustomizeViewButton : UIButton

/**
 按钮title
 */
@property (nonatomic, copy, nullable) NSString *title;

@property (nonatomic, strong)QDActionButtonLayout *buttonLayout;

@property (nonatomic, assign) QDAlertActionStyle style;

@property (assign, nonatomic) QDAlertViewButtonIconPosition iconPosition;

@property (nonatomic, copy, nullable) QDAlertActionHandler handler;

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state;

+ (instancetype)actionWithTitle:(NSString *)title style:(QDAlertActionStyle)style handler:(void (^)(QDCustomizeViewButton * _Nonnull))hanlder;

@end

NS_ASSUME_NONNULL_END
