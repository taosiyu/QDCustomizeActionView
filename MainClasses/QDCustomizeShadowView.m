//
//  QDCustomizeShadowView.m
//  QDCustomizeAction
//
//  Created by Assassin on 2019/11/18.
//  Copyright © 2019 com.tencent.demo. All rights reserved.
//

#import "QDCustomizeShadowView.h"

@implementation QDCustomizeShadowView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    if ((!self.strokeColor && !self.shadowColor) || (!self.strokeWidth && !self.shadowBlur)) return;

    CGContextRef context = UIGraphicsGetCurrentContext();

    // Fill

    if (self.shadowBlur && self.shadowColor) {
        CGContextSetShadowWithColor(context, CGSizeZero, self.shadowBlur, self.shadowColor.CGColor);
    }

    CGRect drawRect = CGRectMake(self.shadowBlur,
                                 self.shadowBlur,
                                 CGRectGetWidth(rect) - self.shadowBlur * 2.0,
                                 CGRectGetHeight(rect) - self.shadowBlur * 2.0);

    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:drawRect
                                               byRoundingCorners:UIRectCornerAllCorners
                                                     cornerRadii:CGSizeMake(self.cornerRadius, self.cornerRadius)];
    [path closePath];

    [UIColor.blackColor setFill];
    [path fill];

    // Remove black background

    CGContextSetShadowWithColor(context, CGSizeZero, 0.0, nil);

    CGContextSetBlendMode(context, kCGBlendModeClear);
    [path fill];
    CGContextSetBlendMode(context, kCGBlendModeNormal);
}


@end
