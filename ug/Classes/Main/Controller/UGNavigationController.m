//
//  UGNavigationController.m
//  ug
//
//  Created by ug on 2019/5/3.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGNavigationController.h"

@interface UGNavigationController ()

@end

@implementation UGNavigationController

+ (void)load
{
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
//    attr[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20];
    attr[NSForegroundColorAttributeName] =  [UIColor whiteColor];
    
    // 获取哪个类下的导航条,管理自己下导航条
    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedIn:self, nil];
    // 设置背景图片
//    [bar setBackgroundImage:[UIImage imageNamed:@"Rectangle"] forBarMetrics:UIBarMetricsDefault];
    
    [bar setTitleTextAttributes:attr];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //去除导航栏下方的横线
    [self.navigationBar setBackgroundImage:[UIImage new]
                            forBarPosition:UIBarPositionAny
                                barMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[UIImage new]];

}

- (UIStatusBarStyle)preferredStatusBarStyle {
    UIViewController* topVC = self.topViewController;
    return [topVC preferredStatusBarStyle];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
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
        // 设置内容内边距,修改按钮位置
        //        backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        UIView *containView = [[UIView alloc] initWithFrame:backButton.bounds];
        [containView addSubview:backButton];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:containView];
        // 设置返回按钮
        viewController.navigationItem.leftBarButtonItem = item;
        // 隐藏底部条
        viewController.hidesBottomBarWhenPushed = YES;
        
    }
    
    // 真正在执行跳转
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
    
    [self popViewControllerAnimated:YES];
    
}



@end
