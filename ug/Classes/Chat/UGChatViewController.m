//
//  UGChatViewController.m
//  ug
//
//  Created by ug on 2019/9/21.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGChatViewController.h"
#import "STBarButtonItem.h"
//#import "WKWebViewJavascriptBridge.h"
@interface UGChatViewController ()
//@property WKWebViewJavascriptBridge *webViewBridge;
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
    
    self.fd_prefersNavigationBarHidden = NO;
    
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
    
//    _webViewBridge = [WKWebViewJavascriptBridge bridgeForWebView:self.tgWebView];
//       [_webViewBridge setWebViewDelegate:self];
//    self.navigationItem.rightBarButtonItem = [STBarButtonItem barButtonItemWithImageName:@"gengduo" target:self action:@selector(rightBarBtnClick)];
}

#pragma mark --其他方法
- (void)rightBarBtnClick {
    
    NSMutableArray *list = [NSMutableArray new];
   [list addObject:@{@"betMoney" : @"1.00" , @"index" : @"0",@"name" : @"鼠,牛",@"odds" : @"4.1200"}];
   [list addObject:@{@"betMoney" : @"1.00" , @"index" : @"1",@"name" : @"鼠,虎",@"odds" : @"4.1200"}];
   [list addObject:@{@"betMoney" : @"1.00" , @"index" : @"2",@"name" : @"牛,虎",@"odds" : @"4.1200"}];
    
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    NSMutableArray *betParams = [NSMutableArray new];
      [betParams addObject:@{@"money" : @"1.00" , @"playId" : @"709901",@"name" : @"鼠,牛",@"odds" : @"4.1200"}];
      [betParams addObject:@{@"money" : @"1.00" , @"playId" : @"709901",@"name" : @"鼠,虎",@"odds" : @"4.1200"}];
      [betParams addObject:@{@"money" : @"1.00" , @"playId" : @"709901",@"name" : @"牛,虎",@"odds" : @"4.1200"}];
    
    NSMutableArray *playNameArray = [NSMutableArray new];
      [playNameArray addObject:@{@"playName1" : @"二连肖-鼠,牛" , @"playName2" : @"鼠,牛"}];
      [playNameArray addObject:@{@"playName1" : @"二连肖-鼠,虎" , @"playName2" : @"鼠,虎"}];
      [playNameArray addObject:@{@"playName1" : @"二连肖-牛，虎" , @"playName2" : @"牛,虎"}];
  
    [params setValue:betParams forKey:@"betParams"];
    [params setValue:playNameArray forKey:@"playNameArray"];
      [params setValue:@"LX" forKey:@"code"];
      [params setValue:@"157131900" forKey:@"ftime"];
      [params setValue:@"70" forKey:@"gameId"];
      [params setValue:@"香港六合彩" forKey:@"gameName"];

    
      [params setValue:[[NSNumber alloc] initWithBool:NO] forKey:@"specialPlay"];
      [params setValue:@"3.00" forKey:@"totalMoney"];
      [params setValue:@"3" forKey:@"totalNums"];
      [params setValue:@"2019116" forKey:@"turnNum"];
    
    NSMutableDictionary *values = [NSMutableDictionary new];
       [values setValue:list forKey:@"list"];
         [values setValue:params forKey:@"params"];
    NSString *listjsonString;
    {
       NSError *error;
       NSData *jsonData = [NSJSONSerialization dataWithJSONObject:list options:NSJSONWritingPrettyPrinted error:&error];
       listjsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    NSString *paramsjsonString;
    {
        NSError *parseError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&parseError];
        paramsjsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }

   
   NSString *jsonStr = [NSString stringWithFormat:@"shareBet(%@, %@)",listjsonString,paramsjsonString];
    // 在需要调用JS的地方执行如下代码
    // 有参数
    
    [self.tgWebView evaluateJavaScript:jsonStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
         NSLog(@"%@----%@",result, error);
     }];
    
}


- (void)setUrl:(NSString *)url {
    [super setUrl:[url stringByAppendingString:@"&back=hide"]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - UIWebViewDelegate


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
//    [super webView :webView  didFinishNavigation:navigation];
    if (self.jsonStr) {
        [self.tgWebView evaluateJavaScript:self.jsonStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                   NSLog(@"%@----%@",result, error);
               }];
    }
   
}
@end
