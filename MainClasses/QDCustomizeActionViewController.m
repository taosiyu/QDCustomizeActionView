//
//  QDCustomizeActionControllerViewController.m
//  QDCustomizeAction
//
//  Created by Assassin on 2019/11/13.
//  Copyright © 2019 com.tencent.demo. All rights reserved.
//

#import "QDCustomizeActionViewController.h"
#import "QDCustomizeActionView.h"
#import "QDCustomizeActionHelper.h"
#import "UIWindow+QDCustomizeAction.h"

@interface QDCustomizeActionViewController ()

@property (strong, nonatomic) QDCustomizeActionView *actionView;

@end

@implementation QDCustomizeActionViewController

- (nonnull instancetype)initWithActionView:(nonnull QDCustomizeActionView *)actionView view:(nonnull UIView *)view
{
    self = [super init];
    if (self) {
        self.actionView = actionView;
        
        self.view.backgroundColor = UIColor.clearColor;
        [self.view addSubview:view];
    }
    return self;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:coordinator.transitionDuration animations:^{
            [self setNeedsStatusBarAppearanceUpdate];
            [self.actionView layoutValidateWithSize:size];
        }];
    });
}

#pragma mark

- (BOOL)shouldAutorotate {
    UIViewController *viewController = QDCustomizeActionHelper.appWindow.currentViewController;
    
    if (viewController) {
        return viewController.shouldAutorotate;
    }
    
    return super.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    UIViewController *viewController = QDCustomizeActionHelper.appWindow.currentViewController;
    
    if (viewController) {
        return viewController.supportedInterfaceOrientations;
    }
    
    return super.supportedInterfaceOrientations;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (QDCustomizeActionHelper.isViewControllerBasedStatusBarAppearance) {
        UIViewController *viewController = QDCustomizeActionHelper.appWindow.currentViewController;

        if (viewController) {
            return viewController.preferredStatusBarStyle;
        }
    }

    return super.preferredStatusBarStyle;
}

- (BOOL)prefersStatusBarHidden {
    if (QDCustomizeActionHelper.isViewControllerBasedStatusBarAppearance) {
        UIViewController *viewController = QDCustomizeActionHelper.appWindow.currentViewController;

        if (viewController) {
            return viewController.prefersStatusBarHidden;
        }
    }

    return super.prefersStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    if (QDCustomizeActionHelper.isViewControllerBasedStatusBarAppearance) {
        UIViewController *viewController = QDCustomizeActionHelper.appWindow.currentViewController;

        if (viewController) {
            return viewController.preferredStatusBarUpdateAnimation;
        }
    }

    return super.preferredStatusBarUpdateAnimation;
}


@end
