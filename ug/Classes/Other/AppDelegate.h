//
//  AppDelegate.h
//  ug
//
//  Created by ug on 2019/4/30.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//允许横竖屏切换
@property(nonatomic, assign) BOOL allowRotation;

@property(nonatomic, assign) BOOL notiveViewHasShow;//503弹窗控制只弹1次

@end

