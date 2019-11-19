//
//  QDWindowsObserver.h
//  QDCustomizeAction
//
//  Created by Assassin on 2019/11/18.
//  Copyright © 2019 com.tencent.demo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QDWindowsObserver : NSObject

+ (instancetype)sharedInstance;

- (void)startObserving;

@end

NS_ASSUME_NONNULL_END
