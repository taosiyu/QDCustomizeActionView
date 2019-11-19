//
//  QDCustomizeViewButton.m
//  QDCustomizeAction
//
//  Created by Assassin on 2019/11/14.
//  Copyright © 2019 com.tencent.demo. All rights reserved.
//

#import "QDCustomizeViewButton.h"
#import "QDCustomizeActionViewController.h"

@implementation QDCustomizeViewButton

+ (instancetype)actionWithTitle:(NSString *)title style:(QDAlertActionStyle)style handler:(void (^)(QDCustomizeViewButton * _Nonnull))hanlder{
    QDCustomizeViewButton *button = [QDCustomizeViewButton buttonWithType:UIButtonTypeCustom];
    [button configureProperties];
    button.handler = hanlder;
    button.style = style;
    button.title = title;
    return button;
}

//设置默认值
- (void)configureProperties
{
    QDActionButtonLayout *layout        = [QDActionButtonLayout new];
    layout.titleColor                   = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0];
    layout.titleColorHighlighted        = [UIColor whiteColor];
    layout.titleColorDisabled           = [UIColor grayColor];
    
    layout.backgroundColor              = [UIColor clearColor];
    layout.backgroundColorHighlighted   = [UIColor blueColor];
    layout.backgroundColorDisabled      = nil;
    
    layout.iconImage                    = nil;
    layout.iconImageHighlighted         = nil;
    layout.iconImageDisabled            = nil;
    
    layout.textAlignment                = NSTextAlignmentCenter;
    layout.font                         = [UIFont boldSystemFontOfSize:18.0];
    layout.numberOfLines                = 0;
    layout.lineBreakMode                = NSLineBreakByWordWrapping;
    layout.minimumScaleFactor           = 1.0f;
    layout.adjustsFontSizeToFitWidth    = YES;
    
    self.buttonLayout = layout;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        self.titleLabel.backgroundColor = UIColor.clearColor;
        self.imageView.backgroundColor = UIColor.clearColor;
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        self.contentEdgeInsets = UIEdgeInsetsMake(QDAlertViewPaddingHeight,
        QDAlertViewPaddingWidth,
        QDAlertViewPaddingHeight,
        QDAlertViewPaddingWidth);

        self.adjustsImageWhenHighlighted = NO;
        self.adjustsImageWhenDisabled = NO;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (!self.imageView.image || !self.titleLabel.text.length) {
        return;
    }

    CGRect imageViewFrame = self.imageView.frame;
    CGRect titleLabelFrame = self.titleLabel.frame;

    if (self.iconPosition == QDAlertViewButtonIconPositionLeft) {
        if (self.titleLabel.textAlignment == NSTextAlignmentLeft) {
            imageViewFrame.origin.x = self.contentEdgeInsets.left;
            titleLabelFrame.origin.x = CGRectGetMaxX(imageViewFrame) + QDAlertViewButtonImageOffsetFromTitle;
        }
        else if (self.titleLabel.textAlignment == NSTextAlignmentRight) {
            imageViewFrame.origin.x = self.contentEdgeInsets.left;
            titleLabelFrame.origin.x = CGRectGetWidth(self.bounds) - self.contentEdgeInsets.right;
        }
        else {
            imageViewFrame.origin.x -= QDAlertViewButtonImageOffsetFromTitle / 2.0;
            titleLabelFrame.origin.x += QDAlertViewButtonImageOffsetFromTitle / 2.0;
        }
    }
    else {
        if (self.titleLabel.textAlignment == NSTextAlignmentLeft) {
            titleLabelFrame.origin.x = self.contentEdgeInsets.left;
            imageViewFrame.origin.x = CGRectGetWidth(self.bounds) - self.contentEdgeInsets.right - CGRectGetWidth(imageViewFrame);
        }
        else if (self.titleLabel.textAlignment == NSTextAlignmentRight) {
            imageViewFrame.origin.x = CGRectGetWidth(self.bounds) - self.contentEdgeInsets.right - CGRectGetWidth(imageViewFrame);
            titleLabelFrame.origin.x = CGRectGetMinX(imageViewFrame) - QDAlertViewButtonImageOffsetFromTitle - CGRectGetWidth(titleLabelFrame);
        }
        else {
            imageViewFrame.origin.x += CGRectGetWidth(titleLabelFrame) + (QDAlertViewButtonImageOffsetFromTitle / 2.0);
            titleLabelFrame.origin.x -= CGRectGetWidth(imageViewFrame) + (QDAlertViewButtonImageOffsetFromTitle / 2.0);
        }
    }
    self.imageView.frame = imageViewFrame;
    self.titleLabel.frame = titleLabelFrame;
}

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state {
    [self setBackgroundImage:[QDCustomizeActionHelper image1x1WithColor:color] forState:state];
}

@end
