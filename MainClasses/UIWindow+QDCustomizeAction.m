//
//  UIWindow+QDCustomizeAction.m
//  QDCustomizeAction
//
//  Created by Assassin on 2019/11/13.
//  Copyright © 2019 com.tencent.demo. All rights reserved.
//

#import "UIWindow+QDCustomizeAction.h"

@implementation UIWindow (QDCustomizeAction)

- (nullable UIViewController *)currentViewController {
    UIViewController *viewController = self.rootViewController;
    
    if (viewController.presentedViewController) {
        viewController = viewController.presentedViewController;
    }
    
    return viewController;
}

@end
