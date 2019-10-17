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
    // 在 [super viewDidLoad] 前面配置url
    self.url = ({
        NSString *url = _NSString(@"%@%@%@&loginsessid=%@&color=%@&back=hide", baseServerUrl, newChatRoomUrl, [UGUserModel currentUser].token, [UGUserModel currentUser].sessid, [[UGSkinManagers shareInstance] setChatNavbgStringColor]);
        if (_gameId.length)
            url = [url stringByAppendingFormat:@"&id=%@", self.gameId];
        url;
    });
    
    [super viewDidLoad];


    self.title = @"聊天室";
    
    self.fd_prefersNavigationBarHidden = YES;
    
    [self setWebViewFrame:CGRectMake(0, 0, UGScreenW, ({
        CGFloat h = APP.Height;
        if ([NavController1.viewControllers.firstObject isKindOfClass:[UGChatViewController class]])
            h -= APP.Height - TabBarController1.tabBar.y;
        h;
    }))];
    
    // 返回按钮
    {
        __weakSelf_(__self);
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(APP.Width-80, APP.StatusBarHeight, 40, 45);
        [btn setImage:[UIImage imageNamed:@"c_login_close_fff"] forState:UIControlStateNormal];
        [btn handleControlEvents:UIControlEventTouchUpInside actionBlock:^(__kindof UIControl *sender) {
            [__self.navigationController popViewControllerAnimated:true];
        }];
        
        if (self.navigationController.viewControllers.firstObject != self)
          [self.view addSubview:btn];
    }
}

@end
