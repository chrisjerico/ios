//
//  PlatWebViewController.m
//  UGBWApp
//
//  Created by ug on 2020/8/20.
//  Copyright © 2020 ug. All rights reserved.
//

#import "PlatWebViewController.h"
#import <WebKit/WebKit.h>
#import "TGWebProgressLayer.h"
#import "SLWebViewController.h"
@interface PlatWebViewController ()<WKNavigationDelegate, WKScriptMessageHandler>
@property (nonatomic,strong) TGWebProgressLayer *webProgressLayer;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@end

@implementation PlatWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.bgView setBackgroundColor: Skin1.navBarBgColor];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    {
        // 设置偏好设置
        config.preferences = [[WKPreferences alloc] init];
        // 默认为0
        config.preferences.minimumFontSize = 10;
        // 默认认为YES
        config.preferences.javaScriptEnabled = YES;
        // 在iOS上默认为NO，表示不能自动通过窗口打开
        config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        // web内容处理池
        config.processPool = [[WKProcessPool alloc] init];
        // 通过JS与webview内容交互
        config.userContentController = [[WKUserContentController alloc] init];
        // 我们可以在WKScriptMessageHandler代理中接收到
        [config.userContentController addScriptMessageHandler:self name:@"postSwiperData"];
    }
   
    self.mWKView.navigationDelegate = self;
    if (_url.length) {
        self.url = _url;
    }
    [self setUpUI];
    
    self.navigationController.navigationBar.backgroundColor = Skin1.navBarBgColor;
    UIButton * rightItem = [UIButton buttonWithType:UIButtonTypeSystem];
    [rightItem setTitle:@"取消" forState:UIControlStateNormal];
    [rightItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightItem addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItem];
    
    
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
    

    [self.mWKView loadRequest:request];
}

- (IBAction)closeAction:(id)sender {
    [_supVC dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - UIWebViewDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {

      [SVProgressHUD showWithStatus:nil];
    [self.webProgressLayer tg_startLoad];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
//    [HUDHelper hideLoadingView:self.view];
     [SVProgressHUD dismiss];
    [self.webProgressLayer tg_finishedLoadWithError:nil];
    
//    [CMCommon showToastTitle:[NSString stringWithFormat:@"url = %@",self.tgWebView.URL]];
    
    NSLog(@"self.mWKView.URL = %@",self.mWKView.URL);
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


#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if (_didReceiveScriptMessage) {
        _didReceiveScriptMessage(message.name, message.body);
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
     if ([keyPath isEqualToString:@"title"]) {
        if (object == self.mWKView) {
            if ([CMCommon stringIsNull:_webTitle]) {
                 self.title = self.mWKView.title;
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

