//
//  UGRegisterViewController.m
//  ug
//
//  Created by ug on 2019/5/4.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGRegisterViewController.h"
#import "UGLoginViewController.h"
#import "UGEncryptUtil.h"
#import "UGSystemConfigModel.h"
#import "OpenUDID.h"
#import <WebKit/WebKit.h>
#import "UGImgVcodeModel.h"
#import "WKProxy.h"

@interface UGRegisterViewController ()<UITextFieldDelegate,UINavigationControllerDelegate,WKScriptMessageHandler,WKNavigationDelegate,WKUIDelegate>
@property (weak, nonatomic) IBOutlet UITextField *inviterTextF;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextF;
@property (weak, nonatomic) IBOutlet UITextField *checkPasswordTextF;
@property (weak, nonatomic) IBOutlet UITextField *realNameTextF;
@property (weak, nonatomic) IBOutlet UITextField *fundPwdTextF;
@property (weak, nonatomic) IBOutlet UITextField *QQTextF;
@property (weak, nonatomic) IBOutlet UITextField *wechatTextF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextF;
@property (weak, nonatomic) IBOutlet UITextField *emailTextF;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UITextField *smsVcodeTextF;
@property (weak, nonatomic) IBOutlet UITextField *imgVcodeTextF;
@property (weak, nonatomic) IBOutlet UIButton *smsVcodeButton;
@property (weak, nonatomic) IBOutlet UIImageView *imgVcodeImageView;

@property (weak, nonatomic) IBOutlet UIView *inviterView;
@property (weak, nonatomic) IBOutlet UIView *fullNameView;
@property (weak, nonatomic) IBOutlet UIView *fundPwdView;
@property (weak, nonatomic) IBOutlet UIView *qqView;
@property (weak, nonatomic) IBOutlet UIView *wechatView;
@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UIView *emailView;
@property (weak, nonatomic) IBOutlet UIView *smsVcodeView;
@property (weak, nonatomic) IBOutlet UIView *imgVcodeView;
@property (weak, nonatomic) IBOutlet UIView *webBgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inviterViewHightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fullNameViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fundPwdViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *qqViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wechatViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneVeiwHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emailViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *smsVcodeViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgVcodeViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webBgViewHeightConstraint;

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UGImgVcodeModel *imgVcodeModel;
@property (nonatomic, strong) NSString *pwdPlaceholder;

@property (strong, nonatomic) NSTimer* timer;
@property (assign, nonatomic) NSTimeInterval vcodeRequestTime;

@end

@implementation UGRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_interactivePopDisabled = YES;
    self.navigationItem.title = @"注册";
    self.registerButton.layer.cornerRadius = 5;
    self.registerButton.layer.masksToBounds = YES;
    self.userNameTextF.delegate = self;
    self.passwordTextF.delegate = self;
    self.checkPasswordTextF.delegate = self;
    self.realNameTextF.delegate = self;
    self.wechatTextF.delegate = self;
    self.QQTextF.delegate = self;
    self.phoneTextF.delegate = self;
    self.inviterTextF.delegate = self;
    self.fundPwdTextF.delegate = self;
    self.emailTextF.delegate = self;
    self.smsVcodeTextF.delegate = self;
    self.imgVcodeTextF.delegate = self;
    
    [self setupSubViews];
    
    UGSystemConfigModel *config = [UGSystemConfigModel currentConfig];
    if (config.reg_vcode == 1) {
        
        [self getImgVcode:nil];
    }
    [self.webBgView addSubview:self.webView];
    
    if (config.pass_limit == 0) {
        
        self.pwdPlaceholder = [NSString stringWithFormat:@"请输入%ld到%ld位长度的密码",config.pass_length_min,config.pass_length_max];
    }else if(config.pass_limit == 1) {
        self.pwdPlaceholder = [NSString stringWithFormat:@"请输入%ld到%ld位数字字母组成的密码",config.pass_length_min,config.pass_length_max];
        
    }else {
        self.pwdPlaceholder = [NSString stringWithFormat:@"请输入%ld到%ld位数字字母符号组成的密码",config.pass_length_min,config.pass_length_max];
    }
    self.passwordTextF.placeholder = self.pwdPlaceholder;
    NSString *url = [NSString stringWithFormat:@"%@%@",baseServerUrl,swiperVerifyUrl];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
    
    if (!config.allowreg) {
        [QDAlertView showWithTitle:nil message:config.closeregreason cancelButtonTitle:nil otherButtonTitle:@"确定" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (IBAction)getSmsVcode:(id)sender {
    
    ck_parameters(^{
        ck_parameter_non_empty(self.phoneTextF.text, @"请输入手机号");
    }, ^(id err) {
        [SVProgressHUD showInfoWithStatus:err];
    }, ^{
        
        [SVProgressHUD showWithStatus:@"发送中..."];
        [self.smsVcodeButton setTitle:@"发送中..." forState:UIControlStateNormal];
        [CMNetwork getSmsVcodeWithParams:@{@"phone":self.phoneTextF.text} completion:^(CMResult<id> *model, NSError *err) {
            [CMResult processWithResult:model success:^{
                [SVProgressHUD showSuccessWithStatus:model.msg];
                [self setVcodeRequestTime:NSDate.new.timeIntervalSince1970];
            } failure:^(id msg) {
                [SVProgressHUD showErrorWithStatus:msg];
                [self.smsVcodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
            }];
        }];
    });
}

- (IBAction)getImgVcode:(id)sender {
    
    [CMNetwork getImgVcodeWithParams:@{@"accessToken":[OpenUDID value]} completion:^(CMResult<id> *model, NSError *err) {
        if (!err) {
            NSData *data = (NSData *)model;
            NSString *imageStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            imageStr = [imageStr substringFromIndex:22];
            NSData *decodedImageData = [[NSData alloc] initWithBase64EncodedString:imageStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *decodedImage = [UIImage imageWithData:decodedImageData];
            self.imgVcodeImageView.image = decodedImage;
        }else {
            
        }
     
    }];
}

- (IBAction)registerClick:(id)sender {
    UGSystemConfigModel *config = [UGSystemConfigModel currentConfig];

    NSInteger result = 0;
    if (self.passwordTextF.text.length) {
        result = [CMCommon judgePasswordStrength:self.passwordTextF.text];
        if (config.pass_limit == 1) {
            if (result) {
                result = 1;
            }
        }
    }
    ck_parameters(^{
        if (config.hide_reco == 2) {
            ck_parameter_non_empty(self.inviterTextF.text, @"请输入推荐人ID");
        }
        ck_parameter_non_empty(self.userNameTextF.text, @"请输入用户名");
        ck_parameter_less_length(self.passwordTextF.text, [NSString stringWithFormat:@"%ld",config.pass_length_min], self.pwdPlaceholder);
        
        if (config.pass_limit) {
            
            ck_parameter_isEqual([NSString stringWithFormat:@"%ld",config.pass_limit], [NSString stringWithFormat:@"%ld",result], self.pwdPlaceholder);
        }
        
        ck_parameter_non_empty(self.checkPasswordTextF.text, @"请确认密码");
        ck_parameter_isEqual(self.passwordTextF.text, self.checkPasswordTextF.text, @"两次输入的密码不一致");
    
        if (config.reg_name == 2) {
            ck_parameter_non_empty(self.realNameTextF.text, @"请输入真实姓名");
        }
        if (config.reg_fundpwd == 2) {
            ck_parameter_non_empty(self.fundPwdTextF.text, @"请输入4位数字的取款密码");
        }
        if (config.reg_qq == 2) {
            ck_parameter_non_empty(self.QQTextF.text, @"请输入QQ号码");
        }
        if (config.reg_wx == 2) {
            ck_parameter_non_empty(self.wechatTextF.text, @"请输入微信号");
        }
        if (config.reg_phone == 2 || config.smsVerify) {
            ck_parameter_non_empty(self.phoneTextF.text, @"请输入11位手机号码");
        }
        if (config.reg_email == 2) {
            ck_parameter_non_empty(self.emailTextF.text, @"请输入邮箱");
        }
        
        if (config.reg_vcode == 0) {
            
    
        }else if (config.reg_vcode == 1 ||
                  config.reg_vcode == 3) {
            
            ck_parameter_non_empty(self.imgVcodeTextF.text, @"请输入验证");
        
        }else if (config.reg_vcode == 2) {
            
        }else {
           
            
        }
        
        if (config.smsVerify) {
             ck_parameter_non_empty(self.smsVcodeTextF.text, @"请输入短信验证");
        }
        
    }, ^(id err) {
        
        [SVProgressHUD showInfoWithStatus:err];

    }, ^{
        
        if (config.reg_vcode == 2) {
            if (!self.imgVcodeModel) {
                [SVProgressHUD showInfoWithStatus:@"请先滑动验证"];
                return ;
            }
        }
        
        if (config.reg_email && self.emailTextF.text.length) {
            if (![CMCommon isValidateEmail:self.emailTextF.text]) {
                [SVProgressHUD showInfoWithStatus:@"输入的邮箱格式不正确"];
                return;
            }
        }
        
//        （注册来源：0:未知, 1:PC, 2:原生安卓, 3:原生IOS, 4:安卓H5, 5:IOSH5, 6:豪华版安卓, 7:豪华版IOS）
        NSDictionary *params = @{@"inviter":self.inviterTextF.text.length ? self.inviterTextF.text : @"",
                                 @"usr":self.userNameTextF.text,
                                 @"pwd":[UGEncryptUtil md5:self.passwordTextF.text],
                                 @"fundPwd":self.fundPwdTextF.text.length ? [UGEncryptUtil md5:self.fundPwdTextF.text] : @"",
                                 @"fullName":self.realNameTextF.text.length ? self.realNameTextF.text : @"",
                                 @"qq":self.QQTextF.text.length ? self.QQTextF.text : @"",
                                 @"wx":self.wechatTextF.text.length ? self.wechatTextF.text : @"",
                                 @"phone":self.phoneTextF.text.length ? self.phoneTextF.text : @"",
                                 @"device":@"3",
                                 @"accessToken":[OpenUDID value],
                                 @"smsCode":self.smsVcodeTextF.text ? self.smsVcodeTextF.text : @"",
                                 @"imgCode":self.imgVcodeTextF.text ? self.imgVcodeTextF.text : @"",
                                 @"email":self.emailTextF.text ? self.emailTextF.text : @""
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
        [SVProgressHUD showWithStatus:@"正在注册..."];
        [CMNetwork registerWithParams:mutDict completion:^(CMResult<id> *model, NSError *err) {
            [CMResult processWithResult:model success:^{

                [SVProgressHUD showSuccessWithStatus:model.msg];
                [self.view endEditing:YES];
                UGUserModel *user = model.data;
                if (user.autoLogin) {
                    
                    [self login];
                }else {
                    self.inviterTextF.text = nil;
                    self.userNameTextF.text = nil;
                    self.passwordTextF.text = nil;
                    self.checkPasswordTextF.text = nil;
                    self.realNameTextF.text = nil;
                    self.fundPwdTextF.text = nil;
                    self.QQTextF.text = nil;
                    self.wechatTextF.text = nil;
                    self.phoneTextF.text = nil;
                    self.emailTextF.text = nil;
                    self.smsVcodeTextF.text = nil;
                    self.imgVcodeTextF.text = nil;
                    [self showLogin:nil];
                }
                
            } failure:^(id msg) {
                
                [SVProgressHUD showErrorWithStatus:msg];
            }];
        }];
        
    });
    
}

- (void)login {
    NSDictionary *params = @{@"usr":self.userNameTextF.text,
                             @"pwd":[UGEncryptUtil md5:self.passwordTextF.text]
                             };
    
    [SVProgressHUD showWithStatus:@"正在登录..."];
    [CMNetwork userLoginWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            [SVProgressHUD showSuccessWithStatus:model.msg];
            UGUserModel *user = model.data;
            UGUserModel.currentUser = user;
            SANotificationEventPost(UGNotificationLoginComplete, nil);
            [self.navigationController popToRootViewControllerAnimated:YES];
        } failure:^(id msg) {
            
            [SVProgressHUD showErrorWithStatus:msg];
            
        }];
    }];
    
}

- (IBAction)showLogin:(id)sender {
    for (UIViewController *vc in self.navigationController.childViewControllers) {
        if ([vc isKindOfClass:UGLoginViewController.class]) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
            
        }
    }
    UGLoginViewController *registerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UGLoginViewController"];
    [self.navigationController pushViewController:registerVC animated:YES];
    
}

- (void)setupSubViews {
//    0隐藏，1选填，2必填
    UGSystemConfigModel *config = [UGSystemConfigModel currentConfig];
    
    if (config.hide_reco) {
        if (config.hide_reco == 1) {
            self.inviterTextF.placeholder = @"请输入推荐人ID(选填)";
        }
    }else {
        self.inviterView.hidden = YES;
        self.inviterViewHightConstraint.constant = 0.1;
    }
    if (config.reg_name) {
        if (config.reg_name == 1) {
            self.realNameTextF.placeholder = @"请输入真实姓名(选填)";
        }
    }else {
        self.fullNameView.hidden = YES;
        self.fullNameViewHeightConstraint.constant = 0.1;
    }
    if (config.reg_fundpwd) {
        if (config.reg_fundpwd == 1) {
            self.fundPwdTextF.placeholder = @"请输入4位数字的取款密码(选填)";
        }
    }else {
        self.fundPwdView.hidden = YES;
        self.fundPwdViewHeightConstraint.constant = 0.1;
    }
    if (config.reg_qq) {
        if (config.reg_qq == 1) {
            self.QQTextF.placeholder = @"请输入QQ号码(选填)";
        }
    }else {
        self.qqView.hidden = YES;
        self.qqViewHeightConstraint.constant = 0.1;
    }
    if (config.reg_wx) {
        if (config.reg_wx == 1) {
            self.wechatTextF.placeholder = @"请输入微信号(选填)";
        }
    }else {
        self.wechatView.hidden = YES;
        self.wechatViewHeightConstraint.constant = 0.1;
    }
    if (config.reg_phone || config.smsVerify) {
        if (config.reg_phone == 1 && !config.smsVerify) {
            self.phoneTextF.placeholder = @"请输入11位手机号码(选填)";
        }
    }else {
        self.phoneView.hidden = YES;
        self.phoneVeiwHeightConstraint.constant = 0.1;
    }
    if (config.reg_email) {
        if (config.reg_email == 1) {
            self.emailTextF.placeholder = @"请输入邮箱(选填)";
        }
    }else {
        self.emailView.hidden = YES;
        self.emailViewHeightConstraint.constant = 0.1;
    }
    
    if (!config.smsVerify) {
      
        self.smsVcodeView.hidden = YES;
        self.smsVcodeViewHeightConstraint.constant = 0.1;
    }
    
    if (config.reg_vcode == 0) {
        self.imgVcodeView.hidden = YES;
        self.webBgView.hidden = YES;
        self.imgVcodeViewHeightConstraint.constant = 0.1;
        self.webBgViewHeightConstraint.constant = 0.1;
    }else if (config.reg_vcode == 2) {

        self.imgVcodeView.hidden = YES;
        self.imgVcodeViewHeightConstraint.constant = 0.1;
    }else if (config.reg_vcode == 1 ||
              config.reg_vcode == 3) {
        
        self.webBgView.hidden = YES;
        self.webBgViewHeightConstraint.constant = 0.1;
      
    }else {

    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [self.view endEditing:YES];
        return NO;
    }
    if (textField == self.phoneTextF ||
        textField == self.smsVcodeTextF ||
        textField == self.imgVcodeTextF) {
        if (textField.text.length + string.length - range.length > 11) {
            return NO;
        }
    }else if (textField == self.emailTextF){
        if (textField.text.length + string.length - range.length > 40) {
            return NO;
        }
        
    }else if(textField == self.fundPwdTextF) {
        if (textField.text.length + string.length - range.length > 4) {
            return NO;
        }
    }else if(textField == self.passwordTextF ||
             textField == self.checkPasswordTextF) {
        UGSystemConfigModel *config = [UGSystemConfigModel currentConfig];
        if (textField.text.length + string.length - range.length > config.pass_length_max) {
            return NO;
        }
    }else {
        if (textField.text.length + string.length - range.length > 20) {
            return NO;
        }
    }
    
    return YES;

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

#pragma mark timer

- (void)_timeClean {
    
    [self.timer invalidate];
    [self setTimer:nil];
    self.smsVcodeButton.enabled = YES;
    [self.smsVcodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
}

- (void)_timeOverHandler {
    
    NSTimeInterval sec = NSDate.new.timeIntervalSince1970 - self.vcodeRequestTime;
    if (sec < 60) {
        NSString* str = [NSString stringWithFormat:@"%d s", 60 - (int)sec];
        [self.smsVcodeButton setTitle:str forState:UIControlStateNormal];
        [self.smsVcodeButton setTitleColor:UGBlueColor forState:UIControlStateNormal];
        self.smsVcodeButton.enabled = NO;
    } else {
        self.smsVcodeButton.enabled = YES;
        [self.smsVcodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self _timeClean];
    }
    
}

- (void)setVcodeRequestTime:(NSTimeInterval)vcodeRequestTime {
    _vcodeRequestTime = vcodeRequestTime;
    
    // 更新
    [self _timeOverHandler];
    
    if (self.timer != nil) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.timer != nil) {
            return;
        }
        // warning: 只有在计时完成才会释放
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                      target:[WKProxy proxyWithObject:self]
                                                    selector:@selector(_timeOverHandler)
                                                    userInfo:nil
                                                     repeats:true];
        
        [self.timer fire];
    });
}



@end
