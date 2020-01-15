//
//  TGWebViewController.m
//  TGWebViewController
//
//  Created by 赵群涛 on 2017/9/15.
//  Copyright © 2017年 QR. All rights reserved.
//

#import "TGWebViewController.h"
#import "SLWebViewController.h"
#import <WebKit/WebKit.h>

@interface TGWebViewController ()<WKNavigationDelegate>

//@property (nonatomic) WKWebView *tgWebView;
@property (nonatomic, assign) BOOL willReloadURL;   // 是否需要重新加载URL

@end

@implementation TGWebViewController

- (BOOL)允许未登录访问 { return true; }
- (BOOL)允许游客访问 { return true; }

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tgWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.tgWebView.navigationDelegate = self;
    [self.view addSubview:self.tgWebView];
    if (_url.length) {
        self.url = _url;
    }
    
    [self.tgWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    [self setUpUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (OBJOnceToken(self)) {
        [self.tgWebView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(self.parentViewController ? 0 : APP.StatusBarHeight);
            make.left.right.bottom.equalTo(self.view);
        }];
    }
}

- (void)setUpUI {
    self.webProgressLayer = [[TGWebProgressLayer alloc] init];
    self.webProgressLayer.frame = CGRectMake(0, self.navigationController.navigationBar.height-2, WIDTH, 2);
    self.webProgressLayer.strokeColor = self.progressColor.CGColor;
    [self.navigationController.navigationBar.layer addSublayer:self.webProgressLayer];
}

- (void)setWebTitle:(NSString *)webTitle{
    _webTitle = webTitle;
    self.title = self.webTitle;
}

- (void)setUrl:(NSString *)urlStr {
    _url = urlStr;
    NSURL *url = [NSURL URLWithString:urlStr];
    if (url.scheme == nil) {
        url = [NSURL URLWithString:_NSString(@"http://%@", urlStr)];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSLog(@"self.url============================ %@", url);
//    [CMCommon showSystemTitle:[NSString stringWithFormat:@"我发送的url = %@",url]];
    
//    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        // 需要在主线程执行的代码
//
//        [CMCommon goUrl:@"http://rwmenpc200yzvjjmx.ptplayyy.com/h5chat/#/chatRoom?roomId=1&roomName=%E6%89%AB%E9%9B%B710%E5%8C%851%E7%82%B91%E5%80%8D&password&isChatBan=false&isShareBet=false&typeId=0&sortId=1&chatRedBagSetting=%5Bobject%20Object%5D&isMine=1&minAmount=10.00&maxAmount=1000.00&oddsRate=1.10&quantity=10"];
//    });
    [self.tgWebView loadRequest:request];
}


#pragma mark - UIWebViewDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [HUDHelper showLoadingViewWithSuperview:self.view];
    [self.webProgressLayer tg_startLoad];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [HUDHelper hideLoadingView:self.view];
    [self.webProgressLayer tg_finishedLoadWithError:nil];
    
//    [CMCommon showToastTitle:[NSString stringWithFormat:@"url = %@",self.tgWebView.URL]];
    
    NSLog(@"self.tgWebView.URL = %@",self.tgWebView.URL);
//      [CMCommon showTitle:[NSString stringWithFormat:@"didFinishNavigation 返回的url = %@",self.tgWebView.URL.absoluteString]];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [HUDHelper hideLoadingView:self.view];
    [self.webProgressLayer tg_finishedLoadWithError:error];
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential,card);
    }
}
//1、使用WKWebView的时候，点击链接不让其跳转到系统自带的Safar浏览器的设置方法：
 - (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {

    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {//跳转别的应用如系统浏览器
        // 对于跨域，需要手动跳转
//        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        SLWebViewController *vc = [SLWebViewController new];
        vc.urlStr = navigationAction.request.URL.absoluteString;
        [NavController1 pushViewController:vc animated:true];
        // 不允许web内跳转
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {//应用的web内跳转
        decisionHandler (WKNavigationActionPolicyAllow);
    }
    return ;//不添加会崩溃

}

//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
//  WKNavigationActionPolicy actionPolicy = WKNavigationActionPolicyAllow;
//
//    NSString * urlStr = navigationAction.request.URL.absoluteString;
//   BOOL  linkBool  =  [JCCommonTool isLinkAddressLinkValueTo:urlStr];//自己封装的验证是否是链接的方法
//    if (linkBool == YES) {
//  actionPolicy = WKNavigationActionPolicyCancel;
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
//    }
//    decisionHandler(actionPolicy);
//}
#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
     if ([keyPath isEqualToString:@"title"]) {
        if (object == self.tgWebView) {
            if ([CMCommon stringIsNull:_webTitle]) {
                 self.title = self.tgWebView.title;
            }
        } else{
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
}

- (void)dealloc {
    [self.webProgressLayer tg_closeTimer];
    [_webProgressLayer removeFromSuperlayer];
    _webProgressLayer = nil;
}

@end
