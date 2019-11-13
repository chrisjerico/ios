//
//  ViewController.m
//  ChinaDailyForiPad
//  Copyright © 2018年 https://www.jianshu.com/u/e15d1f644bea All rights reserved.
//

#import "SLWebViewController.h"
#import <WebKit/WebKit.h>
#import "SLPrefixHeader.pch"
#import "STBarButtonItem.h"

// WKWebView 内存不释放的问题解决
@interface WeakWebViewScriptMessageDelegate : NSObject<WKScriptMessageHandler>
    
    //WKScriptMessageHandler 这个协议类专门用来处理JavaScript调用原生OC的方法
@property (nonatomic, weak) id<WKScriptMessageHandler> scriptDelegate;


- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;
    
@end

@implementation WeakWebViewScriptMessageDelegate
    
- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate {
    self = [super init];
    if (self) {
        _scriptDelegate = scriptDelegate;
    }
    return self;
}
    
#pragma mark - WKScriptMessageHandler
    //遵循WKScriptMessageHandler协议，必须实现如下方法，然后把方法向外传递
    //通过接收JS传出消息的name进行捕捉的回调方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    if ([self.scriptDelegate respondsToSelector:@selector(userContentController:didReceiveScriptMessage:)]) {
        [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
    }
}
    
    @end

@interface SLWebViewController ()<WKScriptMessageHandler, WKUIDelegate, WKNavigationDelegate>
    
@property (nonatomic, strong) WKWebView *webView;
//网页加载进度视图
@property (nonatomic, strong) UIProgressView * progressView;

@property (nonatomic, strong) STBarButtonItem *backBtn;
@property (nonatomic, strong) STBarButtonItem *closeBtn;
@property (nonatomic, strong) STBarButtonItem *homeBtn;
    
@end

@implementation SLWebViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    //TODO: 页面appear 禁用
   [[IQKeyboardManager sharedManager] setEnable:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    //TODO: 页面Disappear 启用
   [[IQKeyboardManager sharedManager] setEnable:YES];
}
- (BOOL)允许未登录访问 { return true; }
- (BOOL)允许游客访问 { return true; }

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationItem];
    
    [self.view addSubview:self.webView];
	[self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.view);
	}];
    [self.view addSubview:self.progressView];
    //添加监测网页加载进度的观察者
    [self.webView addObserver:self
                   forKeyPath:NSStringFromSelector(@selector(estimatedProgress))
                      options:0
                      context:nil];
    [self.webView addObserver:self
                   forKeyPath:@"title"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    
}
    
    //kvo 监听进度 必须实现此方法
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                      context:(void *)context{
    
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))]
        && object == _webView) {
    
        self.progressView.progress = _webView.estimatedProgress;
        if (_webView.estimatedProgress >= 1.0f) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressView.progress = 0;
            });
        }
        
    }else if([keyPath isEqualToString:@"title"]
             && object == _webView){
        self.navigationItem.title = _webView.title;
    }else{
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}

- (void)setupNavigationItem{
    self.navigationItem.leftBarButtonItem = [STBarButtonItem barButtonItemWithImageName:@"c_navi_back" target:self action:@selector(goBackAction:)];

}
    
#pragma mark -- Event Handle
    
- (void)goBackAction:(id)sender{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}
    
- (void)backHomeAction:(id)sender{
    NSArray *array = self.webView.backForwardList.backList;
    if (array.count) {
        [self.webView goToBackForwardListItem:array.firstObject];

    }
}

- (void)closeAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
    
#pragma mark -- Getter
    
- (UIProgressView *)progressView
    {
        if (!_progressView){
            _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 2)];
            _progressView.tintColor = [UIColor greenColor];
            _progressView.trackTintColor = [UIColor clearColor];
        }
        return _progressView;
    }
    
- (WKWebView *)webView{
    
    if(_webView == nil){
        
        //创建网页配置对象
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        
        // 创建设置对象
        WKPreferences *preference = [[WKPreferences alloc]init];
        //最小字体大小 当将javaScriptEnabled属性设置为NO时，可以看到明显的效果
        preference.minimumFontSize = 0;
        //设置是否支持javaScript 默认是支持的
        preference.javaScriptEnabled = YES;
        // 在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
        preference.javaScriptCanOpenWindowsAutomatically = YES;
        config.preferences = preference;
        
        // 是使用h5的视频播放器在线播放, 还是使用原生播放器全屏播放
        config.allowsInlineMediaPlayback = YES;
        //设置视频是否需要用户手动播放  设置为NO则会允许自动播放
        config.requiresUserActionForMediaPlayback = YES;
        //设置是否允许画中画技术 在特定设备上有效
        config.allowsPictureInPictureMediaPlayback = YES;
        //设置请求的User-Agent信息中应用程序名称 iOS9后可用
        config.applicationNameForUserAgent = @"ChinaDailyForiPad";
        
        //自定义的WKScriptMessageHandler 是为了解决内存不释放的问题
        WeakWebViewScriptMessageDelegate *weakScriptMessageDelegate = [[WeakWebViewScriptMessageDelegate alloc] initWithDelegate:self];
        //这个类主要用来做native与JavaScript的交互管理
        WKUserContentController * wkUController = [[WKUserContentController alloc] init];
        //注册一个name为jsToOcNoPrams的js方法 设置处理接收JS方法的对象
        [wkUController addScriptMessageHandler:weakScriptMessageDelegate  name:@"jsToOcNoPrams"];
        [wkUController addScriptMessageHandler:weakScriptMessageDelegate  name:@"jsToOcWithPrams"];
        
          //应用于 ajax 请求的 cookie 设置
        if (UGLoginIsAuthorized()) {
            
            UGUserModel *user = [UGUserModel currentUser];
            NSString *cookieSource = [NSString stringWithFormat:@"document.cookie = 'loginsessid=%@';document.cookie = 'logintoken=%@';", user.sessid,user.token];
            WKUserScript *cookieScript = [[WKUserScript alloc] initWithSource:cookieSource injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
            [wkUController addUserScript:cookieScript];
        }
        
        config.userContentController = wkUController;
        
        //以下代码适配文本大小
        NSString *jSString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        //用于进行JavaScript注入
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        [config.userContentController addUserScript:wkUScript];
        
        _webView = [[WKWebView alloc] initWithFrame: CGRectZero configuration:config];
        // UI代理
        _webView.UIDelegate = self;
        // 导航代理
        _webView.navigationDelegate = self;
        // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
        _webView.allowsBackForwardNavigationGestures = YES;
        
    }
    return _webView;
}

- (void)setUrlStr:(NSString *)urlStr {
    _urlStr = urlStr;
    [self setCookie];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    if (UGLoginIsAuthorized()) {
        
        UGUserModel *user = [UGUserModel currentUser];
        [request addValue:[NSString stringWithFormat:@"loginsessid=%@", user.sessid] forHTTPHeaderField:@"Cookie"];
        [request addValue:[NSString stringWithFormat:@"logintoken=%@", user.token] forHTTPHeaderField:@"Cookie"];
    }

    [self.webView loadRequest:request];

}

- (void)setCookie{

    if (!UGLoginIsAuthorized()) {
        return;
    }
    UGUserModel *user = [UGUserModel currentUser];
    NSMutableDictionary *properties = [NSMutableDictionary dictionary];
    
    [properties setValue:user.sessid forKey:NSHTTPCookieValue];
    [properties setValue:@"loginsessid" forKey:NSHTTPCookieName];
    [properties setValue:[[NSURL URLWithString:self.urlStr] host] forKey:NSHTTPCookieDomain];
    [properties setValue:[[NSURL URLWithString:self.urlStr] path] forKey:NSHTTPCookiePath];
    [properties setValue:[NSDate dateWithTimeIntervalSinceNow:60*60*24] forKey:NSHTTPCookieExpires];
    NSHTTPCookie *cookieuser = [[NSHTTPCookie alloc] initWithProperties:properties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieuser];
    
    NSMutableDictionary *properties1 = [NSMutableDictionary dictionary];
    [properties1 setValue:user.sessid forKey:NSHTTPCookieValue];
    [properties1 setValue:@"logintoken" forKey:NSHTTPCookieName];
    [properties1 setValue:[[NSURL URLWithString:self.urlStr] host] forKey:NSHTTPCookieDomain];
    [properties1 setValue:[[NSURL URLWithString:self.urlStr] path] forKey:NSHTTPCookiePath];
    [properties1 setValue:[NSDate dateWithTimeIntervalSinceNow:60*60*24] forKey:NSHTTPCookieExpires];

    NSHTTPCookie *cookieuser1 = [[NSHTTPCookie alloc] initWithProperties:properties1];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieuser1];

}
    
    //解决第一次进入的cookie丢失问题
- (NSString *)readCurrentCookieWithDomain:(NSString *)domainStr{
    NSHTTPCookieStorage*cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSMutableString * cookieString = [[NSMutableString alloc]init];
    for (NSHTTPCookie*cookie in [cookieJar cookies]) {
        [cookieString appendFormat:@"%@=%@;",cookie.name,cookie.value];
    }
    
    //删除最后一个“;”
    if ([cookieString hasSuffix:@";"]) {
        [cookieString deleteCharactersInRange:NSMakeRange(cookieString.length - 1, 1)];
    }
    
    return cookieString;
}
    
    //解决 页面内跳转（a标签等）还是取不到cookie的问题
- (void)getCookie{
    
    //取出cookie
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    //js函数
    NSString *JSFuncString =
    @"function setCookie(name,value,expires)\
    {\
    var oDate=new Date();\
    oDate.setDate(oDate.getDate()+expires);\
    document.cookie=name+'='+value+';expires='+oDate+';path=/'\
    }\
    function getCookie(name)\
    {\
    var arr = document.cookie.match(new RegExp('(^| )'+name+'=([^;]*)(;|$)'));\
    if(arr != null) return unescape(arr[2]); return null;\
    }\
    function delCookie(name)\
    {\
    var exp = new Date();\
    exp.setTime(exp.getTime() - 1);\
    var cval=getCookie(name);\
    if(cval!=null) document.cookie= name + '='+cval+';expires='+exp.toGMTString();\
    }";
    
    //拼凑js字符串
    NSMutableString *JSCookieString = JSFuncString.mutableCopy;
    for (NSHTTPCookie *cookie in cookieStorage.cookies) {
        NSString *excuteJSString = [NSString stringWithFormat:@"setCookie('%@', '%@', 1);", cookie.name, cookie.value];
        [JSCookieString appendString:excuteJSString];
    }
    //执行js
    [_webView evaluateJavaScript:JSCookieString completionHandler:nil];
    
}

    //被自定义的WKScriptMessageHandler在回调方法里通过代理回调回来，绕了一圈就是为了解决内存不释放的问题
    //通过接收JS传出消息的name进行捕捉的回调方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
   
    
}
    
#pragma mark -- WKNavigationDelegate
    /*
     WKNavigationDelegate主要处理一些跳转、加载处理操作，WKUIDelegate主要处理JS脚本，确认框，警告框等
     */
    
    // 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    
}
    
    // 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [self.progressView setProgress:0.0f animated:NO];
    
}
    
    // 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {

    
}
    
    // 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    [self getCookie];
    
    if ([self.webView canGoBack]) {
        self.navigationItem.leftBarButtonItems = @[self.backBtn,self.closeBtn];
        self.navigationItem.rightBarButtonItem = self.homeBtn;
    }else {
        self.navigationItem.leftBarButtonItems = @[self.backBtn];
        self.navigationItem.rightBarButtonItem = nil;
        
    }
    
}
    
    //提交发生错误时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self.progressView setProgress:0.0f animated:NO];
}
    
    // 接收到服务器跳转请求即服务重定向时之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    
}
    
    // 根据WebView对于即将跳转的HTTP请求头信息和相关信息来决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {

//   NSString *cookieSource = [NSString stringWithFormat:@"document.cookie = 'loginsessid=%@,logintoken=%@';", @"GWYhHe2GGwZaF6wva2FgM5GY",@"6a3c89534d9dbc5717949612f098e50e"];
//    NSString *cookieSource1 = [NSString stringWithFormat:@"document.cookie = 'logintoken=%@';", @"6a3c89534d9dbc5717949612f098e50e"];
//
//    [webView evaluateJavaScript:cookieSource completionHandler:^(id result, NSError *error) {
//        NSLog(@"cookie-------%@",result);
//
//    }];

    decisionHandler(WKNavigationActionPolicyAllow);
    
}
    
    // 根据客户端受到的服务器响应头以及response相关信息来决定是否可以跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    NSString * urlStr = navigationResponse.response.URL.absoluteString;
    NSLog(@"当前跳转地址：%@",urlStr);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}
    
    //需要响应身份验证时调用 同样在block中需要传入用户身份凭证
//- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{

    //用户身份信息
//    NSURLCredential * newCred = [[NSURLCredential alloc] initWithUser:@"user123" password:@"123" persistence:NSURLCredentialPersistenceNone];
//    //为 challenge 的发送方提供 credential
//    [challenge.sender useCredential:newCred forAuthenticationChallenge:challenge];
//    completionHandler(NSURLSessionAuthChallengeUseCredential,newCred);
    
//}
    
    //进程被终止时调用
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    
}
    
#pragma mark -- WKUIDelegate
    
    /**
     *  web界面中有弹出警告框时调用
     *
     *  @param webView           实现该代理的webview
     *  @param message           警告框中的内容
     *  @param completionHandler 警告框消失调用
     */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"HTML的弹出框" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
//    [alertController addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        completionHandler();
//    }])];
//    [self presentViewController:alertController animated:YES completion:nil];
}
    // 确认框
    //JavaScript调用confirm方法后回调的方法 confirm是js中的确定框，需要在block中把用户选择的情况传递进去
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
//    [alertController addAction:([UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        completionHandler(NO);
//    }])];
//    [alertController addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        completionHandler(YES);
//    }])];
//    [self presentViewController:alertController animated:YES completion:nil];
}
    // 输入框
    //JavaScript调用prompt方法后回调的方法 prompt是js中的输入框 需要在block中把用户输入的信息传入
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
//    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//        textField.text = defaultText;
//    }];
//    [alertController addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        completionHandler(alertController.textFields[0].text?:@"");
//    }])];
//    [self presentViewController:alertController animated:YES completion:nil];
}
    // 页面是弹出窗口 _blank 处理

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    
    return nil;
}
    
- (void)dealloc{
    //移除注册的js方法
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"jsToOcNoPrams"];
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"jsToOcWithPrams"];
    //移除观察者
	
	@try {
		    [_webView removeObserver:self
		                  forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
		    [_webView removeObserver:self
		                  forKeyPath:NSStringFromSelector(@selector(title))];
		
	} @catch (NSException *exception) {
		
	}

}
    
- (STBarButtonItem *)backBtn {
    if (_backBtn == nil) {
        _backBtn = [STBarButtonItem barButtonItemWithImageName:@"c_navi_back" target:self action:@selector(goBackAction:)];
    }
    
    return _backBtn;
}

- (STBarButtonItem *)closeBtn {
    if (_closeBtn == nil) {
        _closeBtn = [STBarButtonItem barButtonItemWithImageName:@"c_login_close" target:self action:@selector(closeAction:)];
    }
    
    return _closeBtn;
}

- (STBarButtonItem *)homeBtn {
    if (_homeBtn == nil) {
        _homeBtn = [STBarButtonItem barButtonItemWithTitle:@"首页" target:self action:@selector(backHomeAction:)];
    }
    return _homeBtn;
}
    
@end
