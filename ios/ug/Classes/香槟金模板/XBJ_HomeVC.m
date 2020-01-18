//
//  XBJ_HomeVC.m
//  ug
//
//  Created by tim swift on 2020/1/18.
//  Copyright © 2020 ug. All rights reserved.
//

#import "XBJ_HomeVC.h"

@interface XBJ_HomeVC ()
@property (nonatomic, strong) UIView *customizedStatusBar ;

@end

@implementation XBJ_HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (@available(ios 13.0, *)) {
        if (self.customizedStatusBar) {
            self.customizedStatusBar.hidden = YES;
        }
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setStatusBarBackgroundColor:[UIColor whiteColor]];
    
}

- (void)setStatusBarBackgroundColor:(UIColor *)color {
  
    UIView *statusBar;
    if (@available(iOS 13.0, *)) {// iOS 13 不能直接获取到statusbar 手动添加个view到window上当做statusbar背景
        UIWindow *keyWindow = [self getKeyWindow];
        statusBar = [[UIView alloc] initWithFrame:keyWindow.windowScene.statusBarManager.statusBarFrame];
        [keyWindow addSubview:statusBar];
        self.customizedStatusBar = statusBar;
    } else {
        statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    }
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

- (UIWindow *)getKeyWindow
{
    NSArray *array = [UIApplication sharedApplication].windows;
    UIWindow *window = [array objectAtIndex:0];
    if (!window.hidden || window.isKeyWindow) {
        return window;
    }
    for (UIWindow *window in array) {
        if (!window.hidden || window.isKeyWindow) {
            return window;
        }
    }
    return nil;
}

@end
