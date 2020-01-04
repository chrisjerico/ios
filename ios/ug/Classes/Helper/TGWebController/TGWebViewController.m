//
//  TGWebViewController.m
//  TGWebViewController
//
//  Created by 赵群涛 on 2017/9/15.
//  Copyright © 2017年 QR. All rights reserved.
//

#import "TGWebViewController.h"

#import <WebKit/WebKit.h>

@interface TGWebViewController ()<WKNavigationDelegate>

//@property (nonatomic) WKWebView *tgWebView;


@end

@implementation TGWebViewController

- (BOOL)允许未登录访问 { return true; }
- (BOOL)允许游客访问 { return true; }

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tgWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    [self setUpUI];
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
    if (!self.tgWebView) {
        self.tgWebView  = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        self.tgWebView.navigationDelegate = self;
        [self.view addSubview:self.tgWebView];
        [self.tgWebView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(self.parentViewController ? 0 : APP.StatusBarHeight);
            make.left.right.bottom.equalTo(self.view);
        }];
    }
    NSURL *url = [NSURL URLWithString:urlStr];
    if (url.scheme == nil) {
        url = [NSURL URLWithString:_NSString(@"http://%@", urlStr)];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
     NSLog(@"self.url = %@", url);
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
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
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
