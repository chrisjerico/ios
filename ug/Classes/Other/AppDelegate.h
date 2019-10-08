//
//  AppDelegate.h
//  ug
//
//  Created by ug on 2019/4/30.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGTabbarController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//允许横竖屏切换
@property(nonatomic, assign) BOOL allowRotation;

@property(nonatomic, assign) BOOL notiveViewHasShow;


@property (strong, nonatomic) UGTabbarController *tabbar;

@end

