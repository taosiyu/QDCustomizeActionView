//
//  QDCustomizeActionCell.h
//  QDCustomizeAction
//
//  Created by Assassin on 2019/11/14.
//  Copyright © 2019 com.tencent.demo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QDCustomizeShared.h"

NS_ASSUME_NONNULL_BEGIN

@interface QDCustomizeActionCell : UITableViewCell

@property (strong, nonatomic, readonly, nonnull) UIView *separatorView;

@property (strong, nonatomic, nullable) UIColor *titleColor;
@property (strong, nonatomic, nullable) UIColor *titleColorHighlighted;
@property (strong, nonatomic, nullable) UIColor *titleColorDisabled;

@property (strong, nonatomic, nullable) UIColor *backgroundColorNormal;
@property (strong, nonatomic, nullable) UIColor *backgroundColorHighlighted;
@property (strong, nonatomic, nullable) UIColor *backgroundColorDisabled;

@property (strong, nonatomic, nullable) UIImage *image;
@property (strong, nonatomic, nullable) UIImage *imageHighlighted;
@property (strong, nonatomic, nullable) UIImage *imageDisabled;

@property (assign, nonatomic) QDAlertViewButtonIconPosition iconPosition;

@property (assign, nonatomic) BOOL enabled;

@end

NS_ASSUME_NONNULL_END
