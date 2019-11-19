//
//  QDAlertViewTextField.m
//  QDCustomizeAction
//
//  Created by Assassin on 2019/11/18.
//  Copyright © 2019 com.tencent.demo. All rights reserved.
//

#import "QDAlertViewTextField.h"
#import "QDCustomizeActionHelper.h"

@implementation QDAlertViewTextField

- (CGRect)textRectForBounds:(CGRect)bounds {
    bounds.origin.x += QDAlertViewPaddingWidth;
    bounds.size.width -= QDAlertViewPaddingWidth * 2.0;

    if (self.leftView) {
        bounds.origin.x += CGRectGetWidth(self.leftView.bounds) + QDAlertViewPaddingWidth;
        bounds.size.width -= CGRectGetWidth(self.leftView.bounds) + QDAlertViewPaddingWidth;
    }

    if (self.rightView) {
        bounds.size.width -= CGRectGetWidth(self.rightView.bounds) + QDAlertViewPaddingWidth;
    }
    else if (self.clearButtonMode == UITextFieldViewModeAlways) {
        bounds.size.width -= 20.0;
    }

    return bounds;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    bounds.origin.x += QDAlertViewPaddingWidth;
    bounds.size.width -= QDAlertViewPaddingWidth * 2.0;

    if (self.leftView) {
        bounds.origin.x += CGRectGetWidth(self.leftView.bounds) + QDAlertViewPaddingWidth;
        bounds.size.width -= CGRectGetWidth(self.leftView.bounds) + QDAlertViewPaddingWidth;
    }

    if (self.rightView) {
        bounds.size.width -= CGRectGetWidth(self.rightView.bounds) + QDAlertViewPaddingWidth;
    }
    else if (self.clearButtonMode == UITextFieldViewModeAlways) {
        bounds.size.width -= 20.0;
    }

    return bounds;
}


@end
