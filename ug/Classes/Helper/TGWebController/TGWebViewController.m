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

- (void)setUrl:(NSString *)url {
    if (!self.tgWebView) {
        self.tgWebView  = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        self.tgWebView.navigationDelegate = self;
        [self.view addSubview:self.tgWebView];
    }
    if (![url hasPrefix:@"http"] ) {
        [self.navigationController.view makeToast:@"该url不包含http" duration:1.5 position:CSToastPositionCenter];
        return;
    }
    _url = url;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
     NSLog(@"self.url = %@",url);
    [self.tgWebView loadRequest:request];
}

- (void)setWebViewFrame:(CGRect)frame{
    self.tgWebView.frame = frame;
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
