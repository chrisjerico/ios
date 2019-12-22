//
//  UGBMLoginViewController.m
//  ug
//
//  Created by ug on 2019/11/3.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGBMLoginViewController.h"
#import "UGEncryptUtil.h"
#import "UGRegisterViewController.h"
#import <WebKit/WebKit.h>
#import "UGImgVcodeModel.h"
#import "UGSecurityCenterViewController.h"
#import "SLWebViewController.h"

@interface UGBMLoginViewController ()<UITextFieldDelegate,UINavigationControllerDelegate,WKScriptMessageHandler,WKNavigationDelegate,WKUIDelegate>
{
    NSString *ggCode;
    NSString *gCheckUserName;
}
@property (weak, nonatomic) IBOutlet UIView *webBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webBgViewHeightConstraint;

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UGImgVcodeModel *imgVcodeModel;
@property (nonatomic, assign) NSInteger errorTimes;
@end

@implementation UGBMLoginViewController

- (BOOL)允许未登录访问 { return true; }
- (BOOL)允许游客访问 { return true; }

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.fd_interactivePopDisabled = true;
    self.fd_prefersNavigationBarHidden = YES;
    
    FastSubViewCode(self.view);
    subTextField(@"密码txt").delegate = self;
    subTextField(@"账号txt").delegate = self;
    self.navigationController.delegate = self;
    [self.webBgView addSubview:self.webView];
    NSString *url = [NSString stringWithFormat:@"%@%@",APP.Host,swiperVerifyUrl];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
    self.webBgView.hidden = YES;
    self.webBgViewHeightConstraint.constant = 0.1;
    
    subTextField(@"密码txt").clearButtonMode=UITextFieldViewModeNever;
    subTextField(@"密码txt").secureTextEntry = YES;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
       //检查记住密码标记，如果为YES，那么就读取用户名和密码并为TextField赋值
       ///并将图标背景设置为记住状态，如果为NO，那么设置背景为未记住状态
    if([userDefault boolForKey:@"isRememberPsd"])
    {
       [userDefault setBool:YES forKey:@"isRememberPsd"];
        subImageView(@"记住密码图片").image = [UIImage imageNamed:@"dagou"];
        subTextField(@"账号txt").text = [userDefault stringForKey:@"userName" ];
        subTextField(@"密码txt").text = [userDefault stringForKey:@"userPsw" ];
          
    }
    else if(![userDefault boolForKey:@"isRememberPsd"])
    {
        [userDefault setBool:NO forKey:@"isRememberPsd"];
        subImageView(@"记住密码图片").image = [UIImage imageNamed:@"dagou_off"];
    }
    
    
    
    [subButton(@"登录按钮") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
        [self loginClick:nil];
    }];
    
    [subButton(@"注册按钮") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
        [self showRegister:nil];
    }];
    
    [subButton(@"试玩按钮") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
        [self playAction:nil];
    }];
    
    [subButton(@"关闭按钮") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
                 [self goHomeAction:nil];
     }];
    
    [subButton(@"回到首页") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
                 [self goHomeAction:nil];
     }];
    
    [subButton(@"记住密码按钮") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
        [self recoredBtnClick:nil];
    }];
    
    [subButton(@"忘记密码按钮") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
        [NavController1 pushVCWithUserCenterItemType:UCI_在线客服];
    }];
    
    [subButton(@"眼睛按钮") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
           [self pwdTextSwitch:subButton(@"眼睛按钮")];
    }];
    
    [self getSystemConfig];
}

- (void)pwdTextSwitch:(UIButton *)sender {
    
    // 前提:在xib中设置按钮的默认与选中状态的背景图
    // 切换按钮的状态
    sender.selected = !sender.selected;
    FastSubViewCode(self.view);
    if (sender.selected) { // 按下去了就是明文
        NSString *tempPwdStr = subTextField(@"密码txt").text;
        subTextField(@"密码txt").text = @""; // 这句代码可以防止切换的时候光标偏移
        subTextField(@"密码txt").secureTextEntry = NO;
        subTextField(@"密码txt").text = tempPwdStr;
        
        [subImageView(@"眼睛图片") setImage:[UIImage imageNamed:@"yanjing"]];
        
    } else { // 暗文
        
        NSString *tempPwdStr = subTextField(@"密码txt").text;
        subTextField(@"密码txt").text = @"";
        subTextField(@"密码txt").secureTextEntry = YES;
        subTextField(@"密码txt").text = tempPwdStr;
        [subImageView(@"眼睛图片") setImage:[UIImage imageNamed:@"BMeye_1"]];
    }
}

- (void)recoredBtnClick:(id)sender {
     FastSubViewCode(self.view);
     NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
     if([userDefault boolForKey:@"isRememberPsd"])
    {
        [userDefault setBool:NO forKey:@"isRememberPsd"];
        subImageView(@"记住密码图片").image = [UIImage imageNamed:@"dagou_off"];
    }
    else
    {
        subImageView(@"记住密码图片").image = [UIImage imageNamed:@"dagou"];
        [userDefault setBool:YES forKey:@"isRememberPsd"];
    }
    [userDefault synchronize];
   
}

- (void)goHomeAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)playAction:(id)sender {
    SANotificationEventPost(UGNotificationTryPlay, nil);
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)showRegister:(id)sender {
    for (UIViewController *vc in self.navigationController.childViewControllers) {
        if ([vc isKindOfClass:UGRegisterViewController.class]) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }
    [self.navigationController pushViewController:_LoadVC_from_storyboard_(@"UGRegisterViewController") animated:true];
    
}

- (void)loginClick:(id)sender {
    FastSubViewCode(self.view);
    ck_parameters(^{
        ck_parameter_non_empty(subTextField(@"账号txt").text, @"请输入用户名");
        ck_parameter_non_empty(subTextField(@"密码txt").text, @"请输入密码");
        
    }, ^(id err) {
        [SVProgressHUD showInfoWithStatus:err];
        
    }, ^{
        if (self.errorTimes >= 4 && !self.imgVcodeModel) {
            [SVProgressHUD showInfoWithStatus:@"请完成滑动验证"];
            return ;

        }

        NSDictionary *params = @{@"usr":subTextField(@"账号txt").text,
                                 @"pwd":[UGEncryptUtil md5:subTextField(@"密码txt").text],
                                 @"ggCode":self->ggCode.length ? ggCode : @"",
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
                
                // 退出登录上一个账号
                if (UGUserModel.currentUser)
                    [CMNetwork userLogoutWithParams:@{@"token":[UGUserModel currentUser].sessid} completion:nil];
                
                UGUserModel *user = model.data;
                UGUserModel.currentUser = user;
                
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                if([userDefault boolForKey:@"isRememberPsd"])
                {
                    [userDefault setObject:subTextField(@"账号txt").text forKey:@"userName"];
                    [userDefault setObject:subTextField(@"密码txt").text forKey:@"userPsw"];
                }
                
                SANotificationEventPost(UGNotificationLoginComplete, nil);
                
                NSArray *simplePwds = [[NSArray alloc] initWithObjects:@"111111",@"000000",@"222222",@"333333",@"444444",@"555555",@"666666",@"777777",@"888888",@"999999",@"123456",@"654321",@"abcdef",@"aaaaaa",@"qwe123", nil];
                
                BOOL isGoRoot = YES;
                
                for (int i= 0; i<simplePwds.count; i++) {
                    NSString *str = [simplePwds objectAtIndex:i];
                    if ([subTextField(@"密码txt").text isEqualToString:str]) {
 
                        isGoRoot = NO;
                        break;
                    }
                }
              
                if (isGoRoot) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                } else {
                    [self.navigationController.view makeToast:@"你的密码过于简单，可能存在风险，请把密码修改成复杂密码" duration:3.0 position:CSToastPositionCenter];
                    UGSecurityCenterViewController *vc = [[UGSecurityCenterViewController alloc] init] ;
                    vc.fromVC = @"fromLoginViewController";
                    [self.navigationController pushViewController:vc animated:YES];
                }
               
            } failure:^(id msg) {

                self.errorTimes += 1;
                if (self.errorTimes == 4) {
                    self.webBgView.hidden = NO;
                    self.webBgViewHeightConstraint.constant = 120;
                }
                UGUserModel *user = (UGUserModel*) model.data;

                NSInteger intGgCheck =  user.ggCheck;
                
                if (intGgCheck == 1) {
                    
                    self->gCheckUserName = subTextField(@"账号txt").text;
                   [self showLeeView];
                }
                if ([subTextField(@"账号txt").text isEqualToString:self->gCheckUserName]) {
                    
                    [self showLeeView];
                    
                }
               
                if (self.webBgView.hidden == NO) {
                    [self.webView reload];
                    self.imgVcodeModel = nil;
                }
                
                [SVProgressHUD showErrorWithStatus:msg];
                
            }];
        }];
    });
}
-(void)showLeeView{
    // 使用一个变量接收自定义的输入框对象 以便于在其他位置调用
    
    __block UITextField *tf = nil;
    
    [LEEAlert alert].config
    .LeeTitle(@"请输入谷歌验证码")
    .LeeAddTextField(^(UITextField *textField) {
        
        // 这里可以进行自定义的设置
        textField.placeholder = @"请输入谷歌验证码";
        
        textField.textColor = [UIColor darkGrayColor];
        
        tf = textField; //赋值
    })
    
    .LeeAction(@"确定", ^{
        NSLog(@"tf.text = %@",tf.text);
        
        self->ggCode = tf.text;
        
        [self loginClick:nil];
    })
    .leeShouldActionClickClose(^(NSInteger index){
        // 是否可以关闭回调, 当即将关闭时会被调用 根据返回值决定是否执行关闭处理
        // 这里演示了与输入框非空校验结合的例子
        BOOL result = ![tf.text isEqualToString:@""];
        result = index == 0 ? result : YES;
        return result;
    })
    .LeeCancelAction(@"取消", nil) // 点击事件的Block如果不需要可以传nil
    .LeeShow();
}

#pragma mark - textFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    FastSubViewCode(self.view);
    if ([string isEqualToString:@"\n"]) {
        [subTextField(@"账号txt") resignFirstResponder];
        [subTextField(@"密码txt") resignFirstResponder];
        return NO;
    }
    if (textField == subTextField(@"账号txt")) {
        
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
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential,card);
    } else {
        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
    }
    [_webView evaluateJavaScript:@"document.body.style.backgroundColor=\"#171717\"" completionHandler:nil];
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
        
        [_webView setOpaque:NO];
    }
    return _webView;
}

// 获取系统配置
- (void)getSystemConfig {
    [CMNetwork getSystemConfigWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
       
        [CMResult processWithResult:model success:^{
            
            NSLog(@"model = %@",model);
            
            UGSystemConfigModel *config = model.data;
            UGSystemConfigModel.currentConfig = config;

            NSString *title =[NSString stringWithFormat:@"COPYRIGHT © %@ RESERVED",config.webName];
            FastSubViewCode(self.view);
//            [self.bottomLabel setText:title];
            subLabel(@"标识label").text = title;
            SANotificationEventPost(UGNotificationGetSystemConfigComplete, nil);
        } failure:^(id msg) {
            
        }];
    }];
}


@end
