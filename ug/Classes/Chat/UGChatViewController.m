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
    
}

- (BOOL)允许游客访问 { return true; }

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"聊天室";
    self.fd_prefersNavigationBarHidden = YES;
    
    // WebView.frame
    [self setWebViewFrame:CGRectMake(0, 0, UGScreenW, ({
        CGFloat h = APP.Height;
        if ([NavController1.viewControllers.firstObject isKindOfClass:[UGChatViewController class]])
            h -= APP.Height - TabBarController1.tabBar.y;
        h;
    }))];
    
    // 设置URL
    __weakSelf_(__self);
    {
        void (^setupUrl)(void) = ^{
            [__self.tgWebView stopLoading];
            if (__self.shareBetJson.length) {
                __self.url = APP.chatShareUrl;
            } else if (__self.gameId.length) {
                __self.url = [APP chatGameUrl:__self.gameId];
            } else {
                __self.url = APP.chatHomeUrl;
            }
            [__self.tgWebView reloadFromOrigin];
        };
        SANotificationEventSubscribe(UGNotificationWithSkinSuccess, self, ^(typeof (self) self, id obj) {
            setupUrl();
        });
        setupUrl();
    }
    
    // 返回按钮
    {
        __weakSelf_(__self);
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.frame = CGRectMake(APP.Width-80, APP.StatusBarHeight, 40, 45);
        [_closeBtn setImage:[UIImage imageNamed:@"c_login_close_fff"] forState:UIControlStateNormal];
        [_closeBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
            [__self.navigationController popViewControllerAnimated:true];
        }];
        
        if (self.navigationController.viewControllers.firstObject != self){
             [self.view addSubview:_closeBtn];
        }
    }
    
    // 每秒判断一下 window.canShare 参数为YES才进行分享
    if (_shareBetJson.length) {
        __weakSelf_(__self);
        __block NSTimer *__timer = nil;
        __timer = [NSTimer scheduledTimerWithInterval:1 repeats:true block:^(NSTimer *timer) {
            [__self.tgWebView evaluateJavaScript:@"window.canShare" completionHandler:^(id obj, NSError *error) {
                NSLog(@"是否可以分享：%d", [obj boolValue]);
                if ([obj isKindOfClass:[NSNumber class]] && [obj boolValue]) {
                    [__self.tgWebView evaluateJavaScript:__self.shareBetJson completionHandler:^(id _Nullable result, NSError * _Nullable error) {
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
    _statusBarBgView.backgroundColor = Skin1.navBarBgColor;
    [self.view addSubview:_statusBarBgView];
    
    if ([self.title isEqualToString:@"聊天室"] && !_shareBetJson.length) {
        if (OBJOnceToken(UserI)) {
            [self.tgWebView stopLoading];
            self.url = APP.chatHomeUrl;
            [self.tgWebView reloadFromOrigin];
        }
    }
}

- (void)setShareBetJson:(NSString *)shareBetJson {
    _shareBetJson = shareBetJson;
    NSLog(@"shareBetJson = %@", shareBetJson);
    if (![CMCommon stringIsNull:shareBetJson]){
        [self.view addSubview:_closeBtn];
    }
}

@end
