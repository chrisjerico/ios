//
//  UGChatViewController.m
//  ug
//
//  Created by ug on 2019/9/21.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGChatViewController.h"
#import "STBarButtonItem.h"

@interface UGChatViewController (){
    UIButton *closeBtn;
}
@property (nonatomic) UIView *statusBarBgView;

@end


@implementation UGChatViewController

- (void)skin {
     if([self.url containsString:@"logintoken"]) {
         self.url = ({
             NSString *url = _NSString(@"%@%@%@&loginsessid=%@&color=%@&back=hide", baseServerUrl, newChatRoomUrl, [UGUserModel currentUser].token, [UGUserModel currentUser].sessid, [[UGSkinManagers shareInstance] setChatNavbgStringColor]);
             if (_gameId.length)
                 url = [url stringByAppendingFormat:@"&id=%@", self.gameId];
             url;
         });
     } else {
        self.url = _NSString(@"%@%@%@&color=%@&back=hide", baseServerUrl, chatRoomUrl,SysConf.chatRoomName,[[UGSkinManagers shareInstance] setChatNavbgStringColor]);
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
               NSString *url = _NSString(@"%@%@%@&loginsessid=%@&color=%@&back=hide", baseServerUrl, newChatRoomUrl, [UGUserModel currentUser].token, [UGUserModel currentUser].sessid, [[UGSkinManagers shareInstance] setChatNavbgStringColor]);
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
        closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(APP.Width-80, APP.StatusBarHeight, 40, 45);
        [closeBtn setImage:[UIImage imageNamed:@"c_login_close_fff"] forState:UIControlStateNormal];
        [closeBtn handleControlEvents:UIControlEventTouchUpInside actionBlock:^(__kindof UIControl *sender) {
            [__self.navigationController popViewControllerAnimated:true];
        }];
        
        if (self.navigationController.viewControllers.firstObject != self){
             [self.view addSubview:closeBtn];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (OBJOnceToken(self)) {
        _statusBarBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP.Width, APP.StatusBarHeight)];
    }
    _statusBarBgView.backgroundColor = [UGSkinManagers.shareInstance setNavbgColor];
    [self.view addSubview:_statusBarBgView];
}


- (void)setJsonStr:(NSString *)jsonStr {
    _jsonStr = jsonStr;
        NSLog(@"_jsonStr = %@",_jsonStr);
    if (![CMCommon stringIsNull:_jsonStr]){
             [self.view addSubview:closeBtn];
    }
}


#pragma mark - UIWebViewDelegate


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.webProgressLayer tg_finishedLoadWithError:nil];
    if (self.jsonStr.length) {
        [self.tgWebView evaluateJavaScript:self.jsonStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                   NSLog(@"%@----%@",result, error);
               }];
    }
   
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self.webProgressLayer tg_finishedLoadWithError:error];
     NSLog(@"didFailProvisionalNavigation----%@", error);
}

@end
