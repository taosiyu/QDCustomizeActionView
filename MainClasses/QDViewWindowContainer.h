//
//  QDViewWindowContainer.h
//  QDCustomizeAction
//
//  Created by Assassin on 2019/11/18.
//  Copyright © 2019 com.tencent.demo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QDViewWindowContainer : NSObject

- (instancetype)initWithWindow:(UIWindow *)window;

+ (instancetype)containerWithWindow:(UIWindow *)window;

@property (weak, nonatomic) UIWindow *window;

@end

NS_ASSUME_NONNULL_END
