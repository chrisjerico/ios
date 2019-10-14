//
//  UGChatViewController.m
//  ug
//
//  Created by ug on 2019/9/21.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGChatViewController.h"

@interface UGChatViewController ()

@end

@implementation UGChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    int height = 60;
    
    if ([self.fromView isEqualToString:@"game"]) {
        height = 0;
    }
    if ([CMCommon isPhoneX]) {
        [self setWebViewFrame:CGRectMake(0, 0, UGScreenW, UGScerrnH - IPHONE_SAFEBOTTOMAREA_HEIGHT-height)];
    } else {
        [self setWebViewFrame:CGRectMake(0, 0, UGScreenW, UGScerrnH - height)];
    }
    
    
    // 返回按钮
    {
        __weakSelf_(__self);
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(APP.Width-80, APP.StatusBarHeight, 40, 45);
        [btn setImage:[UIImage imageNamed:@"c_login_close_fff"] forState:UIControlStateNormal];
        [btn handleControlEvents:UIControlEventTouchUpInside actionBlock:^(__kindof UIControl *sender) {
            [__self.navigationController popViewControllerAnimated:true];
        }];
        [self.view addSubview:btn];
    }
}

- (void)setUrl:(NSString *)url {
    [super setUrl:[url stringByAppendingString:@"&back=hide"]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

      
}

@end
