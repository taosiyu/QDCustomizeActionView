//
//  QDCustomizeActionControllerViewController.h
//  QDCustomizeAction
//
//  Created by Assassin on 2019/11/13.
//  Copyright © 2019 com.tencent.demo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class QDCustomizeActionView;

typedef NS_ENUM(NSInteger, QDAlertControllerStyle) {
    QDAlertControllerStyleAlert = 0,
    QDAlertControllerStyleActionSheet
};

@interface QDCustomizeActionViewController : UIViewController

- (nonnull instancetype)initWithActionView:(nonnull QDCustomizeActionView *)actionView view:(nonnull UIView *)view;

@end

NS_ASSUME_NONNULL_END
