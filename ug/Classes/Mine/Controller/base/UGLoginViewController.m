//
//  UGLoginViewController.m
//  ug
//
//  Created by ug on 2019/5/4.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGLoginViewController.h"
#import "UGEncryptUtil.h"
#import "STBarButtonItem.h"
#import "UGRegisterViewController.h"
#import <WebKit/WebKit.h>
#import "UGImgVcodeModel.h"

@interface UGLoginViewController ()<UITextFieldDelegate,UINavigationControllerDelegate,WKScriptMessageHandler,WKNavigationDelegate,WKUIDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameTextF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextF;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIView *webBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webBgViewHeightConstraint;

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UGImgVcodeModel *imgVcodeModel;
@property (nonatomic, assign) NSInteger errorTimes;
@end

@implementation UGLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_interactivePopDisabled = YES;
    self.navigationItem.title = @"登录";
    self.loginButton.layer.cornerRadius = 5;
    self.loginButton.layer.masksToBounds = YES;
    self.userNameTextF.delegate = self;
    self.passwordTextF.delegate = self;
    self.navigationController.delegate = self;
    [self.webBgView addSubview:self.webView];
    NSString *url = [NSString stringWithFormat:@"%@%@",baseServerUrl,swiperVerifyUrl];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
    self.webBgView.hidden = YES;
    self.webBgViewHeightConstraint.constant = 0.1;
}

- (IBAction)loginClick:(id)sender {
    
    ck_parameters(^{
        ck_parameter_non_empty(self.userNameTextF.text, @"请输入用户名");
        ck_parameter_non_empty(self.passwordTextF.text, @"请输入密码");
        
    }, ^(id err) {
        [SVProgressHUD showInfoWithStatus:err];
        
    }, ^{
        if (self.errorTimes >= 4 && !self.imgVcodeModel) {
            [SVProgressHUD showInfoWithStatus:@"请完成滑动验证"];
            return ;

        }
        NSDictionary *params = @{@"usr":self.userNameTextF.text,
                                 @"pwd":[UGEncryptUtil md5:self.passwordTextF.text],
                                 };
      
        NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] initWithDictionary:params];
        if (self.imgVcodeModel) {
            NSString *sid = @"slideCode[nc_sid]";
            NSString *token = @"slideCode[nc_token]";
            NSString *sig = @"slideCode[nc_sig]";
            [mutDict setValue:self.imgVcodeModel.nc_csessionid forKey:sid];
            [mutDict setValue:self.imgVcodeModel.nc_token forKey:token];
            [mutDict setObject:self.imgVcodeModel.nc_value forKey:sig];
            
        }
        [SVProgressHUD showWithStatus:@"正在登录..."];
    
        [CMNetwork userLoginWithParams:mutDict completion:^(CMResult<id> *model, NSError *err) {
            [CMResult processWithResult:model success:^{
                
                [SVProgressHUD showSuccessWithStatus:model.msg];
                UGUserModel *user = model.data;
                UGUserModel.currentUser = user;
                SANotificationEventPost(UGNotificationLoginComplete, nil);
                [self.navigationController popToRootViewControllerAnimated:YES];
            } failure:^(id msg) {
                if (self.webBgView.hidden == NO) {
                    [self.webView reload];
                    self.imgVcodeModel = nil;
                }
                self.errorTimes += 1;
                if (self.errorTimes == 4) {
                    self.webBgView.hidden = NO;
                    self.webBgViewHeightConstraint.constant = 120;
                }
                
                [SVProgressHUD showErrorWithStatus:msg];
                
            }];
        }];
    });
}

- (IBAction)showRegister:(id)sender {
    for (UIViewController *vc in self.navigationController.childViewControllers) {
        if ([vc isKindOfClass:UGRegisterViewController.class]) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }
    UGRegisterViewController *registerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UGRegisterViewController"];
    [self.navigationController pushViewController:registerVC animated:YES];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [self.userNameTextF resignFirstResponder];
        [self.passwordTextF resignFirstResponder];
        return NO;
    }
    if (textField == self.userNameTextF) {
        
        if (textField.text.length + string.length - range.length > 20) {
            return NO;
        }
    }else {
        if (textField.text.length + string.length - range.length > 20) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (!UGLoginIsAuthorized() && ![viewController isKindOfClass:self.class] && ![viewController isKindOfClass:[UGRegisterViewController class]]) {
        SANotificationEventPost(UGNotificationloginCancel, nil);

    }
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"postSwiperData"]) {
        if (message.body) {
            NSDictionary *dict = message.body;
            self.imgVcodeModel = [[UGImgVcodeModel alloc] initWithDictionary:dict error:nil];
        }
        
    }
    
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    decisionHandler(WKNavigationActionPolicyAllow);
    
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
    
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {

    
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {

}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler {
    
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    
    
}


- (WKWebView *)webView {
    if (_webView == nil) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
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
       
        _webView = [[WKWebView alloc] initWithFrame:self.webBgView.bounds
                                            configuration:config];
        _webView.navigationDelegate = self;
    }
    return _webView;
}

@end
