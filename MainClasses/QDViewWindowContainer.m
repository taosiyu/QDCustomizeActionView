//
//  QDViewWindowContainer.m
//  QDCustomizeAction
//
//  Created by Assassin on 2019/11/18.
//  Copyright © 2019 com.tencent.demo. All rights reserved.
//

#import "QDViewWindowContainer.h"

@implementation QDViewWindowContainer

- (instancetype)initWithWindow:(UIWindow *)window {
    self = [super init];
    if (self) {
        self.window = window;
    }
    return self;
}

+ (instancetype)containerWithWindow:(UIWindow *)window {
    return [[self alloc] initWithWindow:window];
}


@end
