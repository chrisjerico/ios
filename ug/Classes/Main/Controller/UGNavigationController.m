//
//  UGNavigationController.m
//  ug
//
//  Created by ug on 2019/5/3.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGNavigationController.h"
#import "UGBMMemberCenterViewController.h"
#import "UGBMBrowseViewController.h"
@interface UGNavigationController ()

@end

@implementation UGNavigationController

static UGNavigationController *_navController = nil;

+ (instancetype)shared {
    return _navController;
}

+ (void)load {
    // 获取哪个类下的导航条,管理自己下导航条
    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedIn:self, nil];
    // 设置背景图片
//    [bar setBackgroundImage:[UIImage imageNamed:@"Rectangle"] forBarMetrics:UIBarMetricsDefault];
    
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _navController = self;
    
    //去除导航栏下方的横线
    [self.navigationBar setBackgroundImage:[UIImage new]
                            forBarPosition:UIBarPositionAny
                                barMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[UIImage new]];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self.topViewController preferredStatusBarStyle];
}

- (UIView *)topView {
    return _navController.viewControllers.lastObject.view;
}
- (UIViewController *)firstVC{
    return _navController.viewControllers.firstObject;
}

- (UIViewController *)lastVC{
    return _navController.viewControllers.lastObject;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // push权限判断
    if (self.viewControllers.count && ![UGTabbarController canPushToViewController:viewController])
        return;
    
    // 判断下是否是非根控制器
    if (self.childViewControllers.count) { // 不是根控制器
        // 设置非根控制器的返回按钮
        // 设置返回按钮
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [backButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [backButton setImage:[UIImage imageNamed:@"c_navi_back"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"c_navi_back"] forState:UIControlStateHighlighted];
        [backButton sizeToFit];
        [backButton handleControlEvents:UIControlEventTouchUpInside actionBlock:^(__kindof UIControl *sender) {
            [NavController1 popViewControllerAnimated:true];
        }];
        UIView *containView = [[UIView alloc] initWithFrame:backButton.bounds];
        [containView addSubview:backButton];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:containView];
        // 设置返回按钮
        viewController.navigationItem.leftBarButtonItem = item;
        
        if ([viewController isKindOfClass:UGBMBrowseViewController.class]||[viewController isKindOfClass:UGBMMemberCenterViewController.class]) {
             // 不隐藏底部条
                viewController.hidesBottomBarWhenPushed = NO;
        }
        else{
             // 隐藏底部条
               viewController.hidesBottomBarWhenPushed = YES;
        }
        
   
    }
    
    // 真正在执行跳转
    [super pushViewController:viewController animated:animated];
}

@end
