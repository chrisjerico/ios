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
    if (self.navigationController.viewControllers.firstObject == self) {
        self.navigationController.navigationBarHidden = true;
    }
   
    // 设置URL
    __weakSelf_(__self);
    {
        void (^setupUrl)(void) = ^{
            [__self.tgWebView stopLoading];
            if (__self.shareBetJson.length) {
                __self.url = APP.chatShareUrl;
            } else if (__self.gameId.length) {
                if ([__self.gameId isEqualToString:@"主聊天室"]) {
                    __self.url = [APP chatGameUrl:@"0" hide:__self.hideHead];
                } else {
                    __self.url = [APP chatGameUrl:__self.gameId hide:__self.hideHead];
                }
//                NSLog(@"__self.url = %@",__self.url);
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
    
//    if ([self.title isEqualToString:@"聊天室"] && !_shareBetJson.length) {
//        if (OBJOnceToken(UserI)) {
//            [self.tgWebView stopLoading];
//            self.url = APP.chatHomeUrl;
//            [self.tgWebView reloadFromOrigin];
//            NSLog(@"self.url = %@",self.url);
//        }
//    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.tgWebView.scrollView.backgroundColor = Skin1.bgColor;
}

- (void)setShareBetJson:(NSString *)shareBetJson {
    _shareBetJson = shareBetJson;
    NSLog(@"shareBetJson = %@", shareBetJson);
    if (![CMCommon stringIsNull:shareBetJson]){
        [self.view addSubview:_closeBtn];
    }
}

- (void)setChangeRoomJson:(NSString *)changeRoomJson {
    _changeRoomJson = changeRoomJson;
    NSLog(@"changeRoomJson = %@", changeRoomJson);
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        //需要在主线程执行的代码
        [self goChangeRoomJS];
    }];
    
    

}

-(void)goChangeRoomJS{
    // 每秒判断一下 window.canShare 参数为YES才进行分享
       if (_changeRoomJson.length) {
           __weakSelf_(__self);
           __block NSTimer *__timer = nil;
           __timer = [NSTimer scheduledTimerWithInterval:1 repeats:true block:^(NSTimer *timer) {
               
               NSLog(@"在运行");
               [__self.tgWebView evaluateJavaScript:@"window.canShare" completionHandler:^(id obj, NSError *error) {
                   NSLog(@"是否可以切换：%d", [obj boolValue]);
                   if ([obj isKindOfClass:[NSNumber class]] && [obj boolValue]) {
                       [__self.tgWebView evaluateJavaScript:__self.changeRoomJson completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                           NSLog(@"切换结果：%@----%@", result, error);
                           [CMCommon showSystemTitle:[NSString stringWithFormat:@"切换成功！%@",__self.changeRoomJson]];
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

@end
