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
#import "UGSecurityCenterViewController.h"
#import "SLWebViewController.h"

@interface UGLoginViewController ()<UITextFieldDelegate,UINavigationControllerDelegate,WKScriptMessageHandler,WKNavigationDelegate,WKUIDelegate>
{
    NSString *ggCode;
    NSString *gCheckUserName;
}
@property (weak, nonatomic) IBOutlet UITextField *userNameTextF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextF;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *rigesterButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (weak, nonatomic) IBOutlet UIView *webBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webBgViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *gouImageView;
@property (weak, nonatomic) IBOutlet UIButton *gouButton;

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UGImgVcodeModel *imgVcodeModel;
@property (nonatomic, assign) NSInteger errorTimes;

@property (weak, nonatomic) IBOutlet UIButton *goHomeButton;
@property (weak, nonatomic) IBOutlet UIButton *btn_c49goHome;
@property (weak, nonatomic) IBOutlet UIImageView *pwdImgeView;
@end

@implementation UGLoginViewController

- (void)skin {
    [self.loginButton setBackgroundColor:Skin1.navBarBgColor];
    [self.rigesterButton setTitleColor:Skin1.navBarBgColor forState:UIControlStateNormal];
    [self.playButton setTitleColor:Skin1.navBarBgColor forState:UIControlStateNormal];
    [self.goHomeButton setTitleColor:Skin1.navBarBgColor forState:UIControlStateNormal];
    
    
}

- (BOOL)允许未登录访问 { return true; }
- (BOOL)允许游客访问 { return true; }

-(void)viewWillAppear:(BOOL)animated{
//    [self viewWillAppear:animated];
    
    if ([@"c049,c008" containsString:APP.SiteId]) {
        [self.goHomeButton setTitle:@"在线客服" forState:(UIControlStateNormal)];
        [self.btn_c49goHome setHidden:NO];
        
    } else {
        [self.goHomeButton setTitle:@"回到首页" forState:(UIControlStateNormal)];
        [self.btn_c49goHome setHidden:YES];
    }
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    //检查记住密码标记，如果为YES，那么就读取用户名和密码并为TextField赋值
    ///并将图标背景设置为记住状态，如果为NO，那么设置背景为未记住状态
    if([userDefault boolForKey:@"isRememberPsd"])
    {
        [userDefault setBool:YES forKey:@"isRememberPsd"];
         self.gouImageView.image = [UIImage imageNamed:@"dagou"];
         self.userNameTextF.text = [userDefault stringForKey:@"userName" ];
         self.passwordTextF.text = [userDefault stringForKey:@"userPsw" ];
       
    }
    else if(![userDefault boolForKey:@"isRememberPsd"])
    {
         [userDefault setBool:NO forKey:@"isRememberPsd"];
         self.gouImageView.image = [UIImage imageNamed:@"dagou_off"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_interactivePopDisabled = true;
    SANotificationEventSubscribe(UGNotificationWithSkinSuccess, self, ^(typeof (self) self, id obj) {
        [self skin];
    });
    
    self.navigationItem.title = @"登录";
    self.loginButton.layer.cornerRadius = 5;
    self.loginButton.layer.masksToBounds = YES;
    [self.loginButton setBackgroundColor:Skin1.navBarBgColor];
    
    self.rigesterButton.layer.cornerRadius = 5;
    self.rigesterButton.layer.masksToBounds = YES;
     [self.rigesterButton setTitleColor:Skin1.navBarBgColor forState:UIControlStateNormal];
    
    self.playButton.layer.cornerRadius = 5;
    self.playButton.layer.masksToBounds = YES;
    [self.playButton setTitleColor:Skin1.navBarBgColor forState:UIControlStateNormal];
    
    self.goHomeButton.layer.cornerRadius = 5;
    self.goHomeButton.layer.masksToBounds = YES;
    [self.goHomeButton setTitleColor:Skin1.navBarBgColor forState:UIControlStateNormal];
    
    self.btn_c49goHome.layer.cornerRadius = 5;
    self.btn_c49goHome.layer.masksToBounds = YES;
    [self.btn_c49goHome setTitleColor:Skin1.navBarBgColor forState:UIControlStateNormal];
    
    self.userNameTextF.delegate = self;
    self.passwordTextF.delegate = self;
    self.navigationController.delegate = self;
    [self.webBgView addSubview:self.webView];
    [self.webView  mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.equalTo(self.view.mas_left).with.offset(20);
         make.right.equalTo(self.view.mas_right).with.offset(-20);
         make.top.equalTo(self.webBgView.mas_top);
         make.height.mas_equalTo(120);
    }];
    
  
    self.webBgView.hidden = YES;
    self.webBgViewHeightConstraint.constant = 0.1;
    
    self.passwordTextF.clearButtonMode=UITextFieldViewModeNever;
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    //检查记住密码标记，如果为YES，那么就读取用户名和密码并为TextField赋值
    ///并将图标背景设置为记住状态，如果为NO，那么设置背景为未记住状态
    if([userDefault boolForKey:@"isRememberPsd"])
    {
        [userDefault setBool:YES forKey:@"isRememberPsd"];
         self.gouImageView.image = [UIImage imageNamed:@"dagou"];
         self.userNameTextF.text = [userDefault stringForKey:@"userName" ];
         self.passwordTextF.text = [userDefault stringForKey:@"userPsw" ];
       
    }
    else if(![userDefault boolForKey:@"isRememberPsd"])
    {
         [userDefault setBool:NO forKey:@"isRememberPsd"];
         self.gouImageView.image = [UIImage imageNamed:@"dagou_off"];
    }
    
    [self getSystemConfig];
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
                                 @"ggCode":self->ggCode.length ? ggCode : @"",
                                 @"device":@"3",    // 0未知，1PC，2原生安卓，3原生iOS，4安卓H5，5iOS_H5，6豪华安卓，7豪华iOS，8混合安卓，9混合iOS，10聊天安卓，11聊天iOS
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
                if (UGUserModel.currentUser) {
                    [CMNetwork userLogoutWithParams:@{@"token":[UGUserModel currentUser].sessid} completion:nil];
                    UGUserModel.currentUser = nil;
                    SANotificationEventPost(UGNotificationUserLogout, nil);
                }
               
                
                UGUserModel *user = model.data;
                UGUserModel.currentUser = user;
                
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                if([userDefault boolForKey:@"isRememberPsd"])
                {
                    [userDefault setObject:self.userNameTextF.text forKey:@"userName"];
                    [userDefault setObject:self.passwordTextF.text forKey:@"userPsw"];
                }
                
                SANotificationEventPost(UGNotificationLoginComplete, nil);
                
                NSArray *simplePwds = [[NSArray alloc] initWithObjects:@"111111",@"000000",@"222222",@"333333",@"444444",@"555555",@"666666",@"777777",@"888888",@"999999",@"123456",@"654321",@"abcdef",@"aaaaaa",@"qwe123", nil];
                
                BOOL isGoRoot = YES;
                
                for (int i= 0; i<simplePwds.count; i++) {
                    NSString *str = [simplePwds objectAtIndex:i];
                    if ([self.passwordTextF.text isEqualToString:str]) {
 
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
                    if (![UGSystemConfigModel  currentConfig].loginVCode) {
                        self.webBgView.hidden = NO;
                        self.webBgViewHeightConstraint.constant = 120;
                        [self webLoadURL];
                    }
                   
                }
                
                UGUserModel *user = (UGUserModel*) model.data;
                
                NSInteger intGgCheck =  user.ggCheck;
                
                if (intGgCheck == 1) {
                    
                    self->gCheckUserName = self.userNameTextF.text;
                   [self showLeeView];
                }
                if ([self.userNameTextF.text isEqualToString:self->gCheckUserName]) {
                    
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

- (void)getSystemConfig {
    
    [CMNetwork getSystemConfigWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            UGSystemConfigModel *config = model.data;
            UGSystemConfigModel.currentConfig = config;
            NSLog(@"登录增加了滑动验证码配置==%d",[UGSystemConfigModel  currentConfig].loginVCode);

            if ([UGSystemConfigModel  currentConfig].loginVCode) {
                self.webBgView.hidden = NO;
                self.webBgViewHeightConstraint.constant = 120;
                [self webLoadURL];
            } else {
                self.webBgView.hidden = YES;
                self.webBgViewHeightConstraint.constant = 0.1;
            }
            
            
           
            
            SANotificationEventPost(UGNotificationGetSystemConfigComplete, nil);
        } failure:^(id msg) {
            [SVProgressHUD dismiss];
        }];
    }];
}


-(void)webLoadURL{
    NSString *url = [NSString stringWithFormat:@"%@%@",APP.Host,swiperVerifyUrl];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
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

- (IBAction)playAction:(id)sender {
    SANotificationEventPost(UGNotificationTryPlay, nil);
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)goHomeAction:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)c49goHomeAction:(id)sender {
    
    if ([@"c049,c008" containsString:APP.SiteId]) {
        //在线客服
        [NavController1 pushVCWithUserCenterItemType:UCI_在线客服];

    } else {
        //去首页
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (IBAction)recoredBtnClick:(id)sender {
    
     NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
     if([userDefault boolForKey:@"isRememberPsd"])
    {
        [userDefault setBool:NO forKey:@"isRememberPsd"];
        self.gouImageView.image = [UIImage imageNamed:@"dagou_off"];
    }
    else
    {
        self.gouImageView.image = [UIImage imageNamed:@"dagou"];
        [userDefault setBool:YES forKey:@"isRememberPsd"];
    }
    [userDefault synchronize];
   
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


- (IBAction)pwdTextSwitch:(UIButton *)sender {
    
    // 前提:在xib中设置按钮的默认与选中状态的背景图
    // 切换按钮的状态
    sender.selected = !sender.selected;
    
    if (sender.selected) { // 按下去了就是明文
        
        NSString *tempPwdStr = self.passwordTextF.text;
        self.passwordTextF.text = @""; // 这句代码可以防止切换的时候光标偏移
        self.passwordTextF.secureTextEntry = NO;
        self.passwordTextF.text = tempPwdStr;
        
        [self.pwdImgeView setImage:[UIImage imageNamed:@"yanjing"]];
        
    } else { // 暗文
        
        NSString *tempPwdStr = self.passwordTextF.text;
        self.passwordTextF.text = @"";
        self.passwordTextF.secureTextEntry = YES;
        self.passwordTextF.text = tempPwdStr;
        [self.pwdImgeView setImage:[UIImage imageNamed:@"biyan"]];
    }
}
@end
