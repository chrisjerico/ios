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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setUpUI];
}

- (void)setUpUI {
   
    
    
    self.webProgressLayer = [[TGWebProgressLayer alloc] init];
    self.webProgressLayer.frame = CGRectMake(0, self.navigationController.navigationBar.height-2, WIDTH, 2);
    self.webProgressLayer.strokeColor = self.progressColor.CGColor;
    [self.navigationController.navigationBar.layer addSublayer:self.webProgressLayer];

}

-(void)setWebTitle:(NSString *)webTitle{
    _webTitle = webTitle;
    self.title = self.webTitle;
}

-(void)setUrl:(NSString *)url{
    
    if (!self.tgWebView) {
        self.tgWebView  = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        self.tgWebView.navigationDelegate = self;
        [self.view addSubview:self.tgWebView];
    }
    if ( ![url hasPrefix:@"http"] ) {
                 [self.navigationController.view makeToast:@"该url不包含http"
                 duration:1.5
                 position:CSToastPositionCenter];
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
    [self.webProgressLayer tg_startLoad];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.webProgressLayer tg_finishedLoadWithError:nil];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self.webProgressLayer tg_finishedLoadWithError:error];
}

- (void)dealloc {
    [self.webProgressLayer tg_closeTimer];
    [_webProgressLayer removeFromSuperlayer];
    _webProgressLayer = nil;
}

@end
