//
//  QDWebViewController.m

#import "QDWebViewController.h"
#import "STBarButtonItem.h"
#import <WebKit/WebKit.h>
#import "UIWebView+DKProgress.h"
#import "UGBackToastView.h"
//目前忽略证书用这个方法，
@interface NSURLRequest(ForSSL)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;
+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString*)host;
@end

@implementation NSURLRequest(ForSSL)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host {
    return YES;
}

+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString*)host {
    
}
@end

@interface QDWebViewController() <WKNavigationDelegate, WKUIDelegate, UIWebViewDelegate,
UIActionSheetDelegate> {
    NSString *requestUrl;
    NSURL *errorUrl;
}

@property(nonatomic, strong) UIView *errorView;
@property(nonatomic, strong) UILabel *rightLabel;
@property(nonatomic, strong) UIBarButtonItem *backBtn;
@property(nonatomic, strong) UIBarButtonItem *closeBtn;
@property(nonatomic, assign) NSInteger deleteJSDate;
@property(nonatomic, strong) UIWebView *webView;
@property(nonatomic, readwrite, copy) NSString* startPage;
@property (nonatomic, strong) UIProgressView * progressView;
@property (nonatomic, strong) UIButton *backView;
@end

@implementation QDWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView = [[UIWebView alloc] init];
    [self.view addSubview:self.webView];
    //    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
    
    if (self.enterGame) {
        self.fd_prefersNavigationBarHidden = YES;
        [self.navigationController setNavigationBarHidden:YES];
        self.webView.frame = self.view.bounds;
        AppDelegate  *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appDelegate.allowRotation = 1;
        
        if (@available(iOS 11.0, *)) {
            self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        
        [self.view addSubview:self.backView];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self.backView addGestureRecognizer:pan];
        [self.backView addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        
    } else {
        
        self.navigationItem.title = self.navigationTitle;
        STBarButtonItem *item0 = [STBarButtonItem barButtonItemWithImageName:@"c_navi_back" target:self action:@selector(pageBack)];
        STBarButtonItem *item1 = [STBarButtonItem barButtonItemWithImageName:@"c_login_close" target:self action:@selector(doClose)];
        self.navigationItem.leftBarButtonItems = @[item0,item1];
        if ([CMCommon isPhoneX]) {
            self.webView.frame = CGRectMake(0, -44, UGScreenW, UGScerrnH - 34);
        }else {
            self.webView.frame = CGRectMake(0, -44, UGScreenW, UGScerrnH - 20);
        }
    
        self.webView.y = - 44;
        
        self.webView.dk_progressLayer = [[DKProgressLayer alloc] initWithFrame:CGRectMake(0, 42, UGScreenW, 2)];
        self.webView.dk_progressLayer.progressColor = [UIColor greenColor];
        self.webView.dk_progressLayer.progressStyle = _style;
        [self.navigationController.navigationBar.layer addSublayer:self.webView.dk_progressLayer];
    }
    
    // 退出页面前切换回竖屏
    [self.navigationController aspect_hookSelector:@selector(popViewControllerAnimated:) withOptions:AspectPositionBefore usingBlock:^(id <AspectInfo>ai) {
        AppDelegate  *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appDelegate.allowRotation = 0;
        
        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
            // 防止更改设备的横竖屏不起作用
            SEL seletor = NSSelectorFromString(@"setOrientation:");
            
            NSInvocation *invocatino = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:seletor]];
            [invocatino setSelector:seletor];
            [invocatino setTarget:[UIDevice currentDevice]];
            int val = UIInterfaceOrientationPortrait;
            [invocatino setArgument:&val atIndex:2];
            [invocatino invoke];
        }
    }  error:nil];
}

- (BOOL)prefersStatusBarHidden {
    return YES;// 返回YES表示隐藏，返回NO表示显示
}

- (void)viewWillLayoutSubviews {
    self.webView.frame = self.view.bounds;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]){
      
        [storage deleteCookie:cookie];
        
    }
    [self setCookie];
//    [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.startPage]]];
    self.deleteJSDate = 1;
    
    if ([self.navigationTitle isEqualToString:@"聊天室"]) {
        self.navigationController.navigationBarHidden = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationTitle isEqualToString:@"聊天室"]) {
        self.navigationController.navigationBarHidden = NO;
    }
    
    // 自动游戏额度转出
    SANotificationEventPost(UGNotificationAutoTransferOut, nil);
}

- (void)backClick {
    UGBackToastView *backView = [[UGBackToastView alloc] initWithFrame:CGRectMake((UGScreenW - 300)/2, (UGScerrnH - 200)/2, 300, 200)];
    WeakSelf
    backView.backHomeBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    [backView popupShow];
}

- (void)doClose {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUrlString:(NSString *)urlString {
    _urlString = urlString;
    if ([urlString hasPrefix:@"http:"] || [urlString hasPrefix:@"https:"]) {
        self.startPage = urlString;

    }
}

- (void)pageBack {
    if (self.webView.canGoBack) {
        [self.webView goBack];
        return;
    }
    
    
    if (self.navigationController && [[self.navigationController childViewControllers] count] > 1 ) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark UIWebviewDelegate

//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
//    if (navigationType==UIWebViewNavigationTypeBackForward) {
//        self.webView.canGoBack?[self.webView goBack]:[self.navigationController popViewControllerAnimated:YES];
//    }
//
//    if ([self.webView.subviews containsObject:self.errorView]) {
//        [self.errorView removeFromSuperview];
//    }
//    return YES;
//}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeBackForward) {
        self.webView.canGoBack ? [self.webView goBack] : [self.navigationController popViewControllerAnimated:YES];
    }
    
    // 若跳转到 lobbyURL地址，则退出页面
    {
        static NSString *host = nil;
        if (OBJOnceToken(self)) {
            host = [baseServerUrl copy];
        }
        NSString *url = request.URL.absoluteString;
        if ([url containsString:@"lobbyURL="]) {
            host = [[url componentsSeparatedByString:@"lobbyURL="].lastObject componentsSeparatedByString:@"&"].firstObject;
        }
        if ([request.URL.host isEqualToString:host.lastPathComponent]) {
            [self.navigationController popViewControllerAnimated:true];
        }
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    if ([self.webView.subviews containsObject:self.errorView]) {
        [self.errorView removeFromSuperview];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    // 自动设置页面title
    NSString *webTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (webTitle.length) {
//        self.navigationItem.title = webTitle;
    }
    if ([self.webView.subviews containsObject:self.errorView]) {
        [self.errorView removeFromSuperview];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {

//    [self.webView addSubview:self.errorView];
//    errorUrl = [error.userInfo objectForKey:@"NSErrorFailingURLKey"];

}

- (UIView *)errorView {
    if (_errorView == nil) {
        CGRect noDataFrame = UIEdgeInsetsInsetRect(UIScreen.mainScreen.bounds, UIEdgeInsetsMake(0, 0, 64, 0));
        _errorView = [[UIView alloc] initWithFrame:noDataFrame];
        float y = CGRectGetHeight(noDataFrame) * 0.3;
        float x = CGRectGetWidth(noDataFrame)/2-40;
        UIImageView *noDataView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"network_error_refresh"]];
        noDataView.frame = CGRectMake(x, y, 80, 80);
        noDataView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRefresh)];
        [noDataView addGestureRecognizer:tap];
        
        float xLabel = (CGRectGetWidth(noDataFrame)- 220)/2;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(xLabel, CGRectGetMaxY(noDataView.frame) + 14, 220, 16)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:16];
        label.text = @"网络出错，点击刷新重新加载";
        [_errorView addSubview:noDataView];
        [_errorView addSubview:label];
//        [_errorView setBackgroundColor:[UIColor opacityColorWithHex:0xf1f5f7]];
    }
    
    return _errorView;
}

- (void)setCookie{
    
    if (!UGLoginIsAuthorized()) {
        return;
    }
    UGUserModel *user = [UGUserModel currentUser];
    NSMutableDictionary *properties = [NSMutableDictionary dictionary];
    [properties setValue:user.sessid forKey:NSHTTPCookieValue];
    [properties setValue:@"loginsessid" forKey:NSHTTPCookieName];
    [properties setValue:[[NSURL URLWithString:baseServerUrl] host] forKey:NSHTTPCookieDomain];
    [properties setValue:[[NSURL URLWithString:baseServerUrl] path] forKey:NSHTTPCookiePath];
    [properties setValue:[NSDate dateWithTimeIntervalSinceNow:60*60*24] forKey:NSHTTPCookieExpires];
    NSHTTPCookie *cookieuser = [[NSHTTPCookie alloc] initWithProperties:properties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieuser];
    
    NSMutableDictionary *properties1 = [NSMutableDictionary dictionary];
    [properties1 setValue:user.token forKey:NSHTTPCookieValue];
    [properties1 setValue:@"logintoken" forKey:NSHTTPCookieName];
    [properties1 setValue:[[NSURL URLWithString:baseServerUrl] host] forKey:NSHTTPCookieDomain];
    [properties1 setValue:[[NSURL URLWithString:baseServerUrl] path] forKey:NSHTTPCookiePath];
    [properties1 setValue:[NSDate dateWithTimeIntervalSinceNow:60*60*24] forKey:NSHTTPCookieExpires];
    
    NSHTTPCookie *cookieuser1 = [[NSHTTPCookie alloc] initWithProperties:properties1];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieuser1];
    
}

- (UIProgressView *)progressView
{
    if (!_progressView){
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 2)];
        _progressView.tintColor = [UIColor greenColor];
        _progressView.trackTintColor = [UIColor clearColor];
    }
    return _progressView;
}

- (void)tapRefresh {
    [self.errorView removeFromSuperview];
    [self.webView loadRequest:[NSURLRequest requestWithURL:errorUrl]];
}

- (void) handlePan:(UIPanGestureRecognizer*) recognizer

{
    
    CGPoint translation = [recognizer translationInView:self.view];
    
    CGFloat centerX=recognizer.view.center.x+ translation.x;
    
    CGFloat thecenter=0;
    CGPoint center = CGPointMake(centerX,
                                 
                                 recognizer.view.center.y+ translation.y);
    if (center.x < 30) {
        center.x = 30;
    }
    if (center.x > UGScreenW - 30) {
        center.x = UGScreenW - 30;
    }
    if (center.y < 30) {
        center.y = 30;
    }
    if (center.y > UGScerrnH - 30) {
        center.y = UGScerrnH - 30;
    }
    recognizer.view.center = center;
    
    [recognizer setTranslation:CGPointZero inView:self.view];
    
    if(recognizer.state==UIGestureRecognizerStateEnded|| recognizer.state==UIGestureRecognizerStateCancelled) {
        
        if(centerX>UGScreenW/2) {
            
            thecenter=UGScerrnH-50/2;
            
        }else{
            
            thecenter=50/2;
            
        }
        return;
        
        [UIView animateWithDuration:0.3 animations:^{
            if (self.view.width >= 812) {
                recognizer.view.center=CGPointMake(thecenter - 20,
                                                   recognizer.view.center.y+ translation.y);
            }else {
                
                recognizer.view.center=CGPointMake(thecenter - 5,
                                                   recognizer.view.center.y+ translation.y);
            }
            
        }];
        
    }
}


- (UIButton *)backView {
    if (_backView == nil) {
        _backView = [[UIButton alloc] initWithFrame:CGRectMake(50, 30, 100, 85)];
        [_backView setImage:[UIImage imageNamed:@"backHome"] forState:UIControlStateNormal];
    }
    return _backView;
}


@end
