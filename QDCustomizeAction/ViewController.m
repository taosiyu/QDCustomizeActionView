//
//  ViewController.m
//  QDCustomizeAction
//
//  Created by Assassin on 2019/11/13.
//  Copyright © 2019 com.tencent.demo. All rights reserved.
//

#import "ViewController.h"
#import "QDCustomizeActionView.h"
#import "QDCustomizeViewButton.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *uib = [UIButton new];
    [uib setTintColor:[UIColor redColor]];
    [uib setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [uib setTitle:@"点击" forState:UIControlStateNormal];
    [uib setFrame:CGRectMake(0, 0, 100, 30)];
    uib.center = self.view.center;
    [uib addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:uib];
}

- (void)click
{
    QDCustomizeActionView *view = [[QDCustomizeActionView alloc] initWithViewAndTitle:@"测试" style:QDAlertViewStyleActionSheet];
    QDCustomizeViewButton *button1 = [QDCustomizeViewButton actionWithTitle:@"哈哈哈哈1" style:QDAlertActionStyleDefault handler:^(QDCustomizeViewButton * _Nonnull button) {
        NSLog(@"button title = %@",button.title);
    }];
    [view addAction:button1];
    QDCustomizeViewButton *button3 = [QDCustomizeViewButton actionWithTitle:@"哈哈哈哈3" style:QDAlertActionStyleDefault handler:^(QDCustomizeViewButton * _Nonnull button) {
        NSLog(@"button title = %@",button.title);
    }];
    [view addAction:button3];
    QDCustomizeViewButton *button2 = [QDCustomizeViewButton actionWithTitle:@"Cancel" style:QDAlertActionStyleCancel handler:^(QDCustomizeViewButton * _Nonnull button) {
        
    }];
    [view addAction:button2];
    
    for (NSInteger i = 0; i< 1; i++) {
        QDCustomizeViewButton *button22 = [QDCustomizeViewButton actionWithTitle:@"Cancel2" style:QDAlertActionStyleDefault handler:^(QDCustomizeViewButton * _Nonnull button) {
            
        }];
        [view addAction:button22];
    }
    
    [view showAnimated:YES completionHandler:nil];
}


@end
