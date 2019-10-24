//
//  UGChatViewController.m
//  ug
//
//  Created by ug on 2019/9/21.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGChatViewController.h"
#import "STBarButtonItem.h"

@interface UGChatViewController ()
@property (nonatomic) UIView *statusBarBgView;
@property (nonatomic) UIButton *closeBtn;
@end


@implementation UGChatViewController

- (void)skin {
     if([self.url containsString:@"logintoken"]) {
         self.url = ({
             NSString *url = _NSString(@"%@%@%@&loginsessid=%@&color=%@&back=hide&from=app", baseServerUrl, newChatRoomUrl, [UGUserModel currentUser].token, [UGUserModel currentUser].sessid, [[UGSkinManagers shareInstance] setChatNavbgStringColor]);
             if (_gameId.length)
                 url = [url stringByAppendingFormat:@"&id=%@", self.gameId];
             url;
         });
     } else {
        self.url = _NSString(@"%@%@%@&color=%@&back=hide&from=app", baseServerUrl, chatRoomUrl,SysConf.chatRoomName,[[UGSkinManagers shareInstance] setChatNavbgStringColor]);
     }
}

- (BOOL)允许游客访问 { return true; }

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SANotificationEventSubscribe(UGNotificationWithSkinSuccess, self, ^(typeof (self) self, id obj) {
        [self skin];
    });
    
    if ([CMCommon stringIsNull:self.url]) {
        NSLog(@"url = %@",self.url);
        self.url = ({
               NSString *url = _NSString(@"%@%@%@&loginsessid=%@&color=%@&back=hide&from=app", baseServerUrl, newChatRoomUrl, [UGUserModel currentUser].token, [UGUserModel currentUser].sessid, [[UGSkinManagers shareInstance] setChatNavbgStringColor]);
               if (_gameId.length)
                   url = [url stringByAppendingFormat:@"&id=%@", self.gameId];
            
            NSLog(@"viewDidLoad url = %@",url);
               url;
           });
    }
    
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
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.frame = CGRectMake(APP.Width-80, APP.StatusBarHeight, 40, 45);
        [_closeBtn setImage:[UIImage imageNamed:@"c_login_close_fff"] forState:UIControlStateNormal];
        [_closeBtn handleControlEvents:UIControlEventTouchUpInside actionBlock:^(__kindof UIControl *sender) {
            [__self.navigationController popViewControllerAnimated:true];
        }];
        
        if (self.navigationController.viewControllers.firstObject != self){
             [self.view addSubview:_closeBtn];
        }
    }
    
    // 每秒判断一下 window.canShare 参数为YES才进行分享
    if (_jsonStr.length) {
        __weakSelf_(__self);
        __block NSTimer *__timer = nil;
        __timer = [NSTimer scheduledTimerWithInterval:1 repeats:true block:^(NSTimer *timer) {
            [__self.tgWebView evaluateJavaScript:@"window.canShare" completionHandler:^(id obj, NSError *error) {
                NSLog(@"是否可以分享：%d", [obj boolValue]);
                if ([obj isKindOfClass:[NSNumber class]] && [obj boolValue]) {
                    [__self.tgWebView evaluateJavaScript:__self.jsonStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                        NSLog(@"分享结果：%@----%@", result, error);
                    }];
                    [__timer invalidate];
                    __timer = nil;
                }
                
                if (!__self) {
                    [__timer invalidate];
                    __timer = nil;
                }
            }];
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (OBJOnceToken(self)) {
        _statusBarBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP.Width, APP.StatusBarHeight)];
    }
    _statusBarBgView.backgroundColor = [UGSkinManagers.shareInstance setNavbgColor];
    [self.view addSubview:_statusBarBgView];
    
    if ([self.title isEqualToString:@"聊天室"]) {
        if (OBJOnceToken(UserI)) {
            [self.tgWebView stopLoading];
            self.url = _NSString(@"%@%@%@&loginsessid=%@&color=%@&back=hide&from=app", baseServerUrl, newChatRoomUrl, [UGUserModel currentUser].token, [UGUserModel currentUser].sessid, [[UGSkinManagers shareInstance] setChatNavbgStringColor]);
            [self.tgWebView reloadFromOrigin];
        }
    }
}

- (void)setJsonStr:(NSString *)jsonStr {
    _jsonStr = jsonStr;
    NSLog(@"_jsonStr = %@",_jsonStr);
    if (![CMCommon stringIsNull:_jsonStr]){
        [self.view addSubview:_closeBtn];
    }
}

@end
