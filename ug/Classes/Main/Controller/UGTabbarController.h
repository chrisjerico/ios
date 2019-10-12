//
//  UGTabbarController.h
//  ug
//
//  Created by ug on 2019/4/30.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TabBarController1 [UGTabbarController shared]

NS_ASSUME_NONNULL_BEGIN

@interface UGTabbarController : UITabBarController

+ (instancetype)shared;
@end

NS_ASSUME_NONNULL_END
