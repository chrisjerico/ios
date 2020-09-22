//
//  JYLoginViewController.m
//  ug
//
//  Created by ug on 2020/2/11.
//  Copyright © 2020 ug. All rights reserved.
//

#import "JYLoginViewController.h"
#import "UGEncryptUtil.h"
#import "STBarButtonItem.h"
#import "UGRegisterViewController.h"
#import <WebKit/WebKit.h>
#import "UGImgVcodeModel.h"
#import "UGSecurityCenterViewController.h"
#import "SLWebViewController.h"
#import "JYRegisterViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "SUCache.h"
#import "FBTransitionViewController.h"
@interface JYLoginViewController ()<UITextFieldDelegate,UINavigationControllerDelegate,WKScriptMessageHandler,WKNavigationDelegate,WKUIDelegate>
{
    NSString *ggCode;
    NSString *gCheckUserName;
}
@property (nonatomic, strong) NSString *gCheckUserName;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextF;                    /**<   用户名*/
@property (weak, nonatomic) IBOutlet UITextField *passwordTextF;                    /**<   密码 */
@property (weak, nonatomic) IBOutlet UIButton *loginButton;                         /**<   登录按钮 */
@property (weak, nonatomic) IBOutlet UIView *webBgView;                             /**<   阿里的web条*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webBgViewHeightConstraint;/**<    阿里的web条高 */
@property (weak, nonatomic) IBOutlet UIImageView *gouImageView;                     /**<   打勾图 */
@property (weak, nonatomic) IBOutlet UIButton *gouButton;                           /**<   打勾按钮 */
@property (weak, nonatomic) IBOutlet UIImageView *pwdImgeView;                      /**<  密码是否明文图片 */

@property (nonatomic, strong) WKWebView *webView;                                   /**<   加载阿里的web条*/
@property (nonatomic, strong) UGImgVcodeModel *imgVcodeModel;                       /**<  验证码 */
@property (nonatomic, assign) NSInteger errorTimes;                                 /**<   */


@property (weak, nonatomic) IBOutlet UIButton *rigesterButton;                       /**<  注册 */
@property (weak, nonatomic) IBOutlet UIButton *playButton;                           /**<  试玩 */
@property (weak, nonatomic) IBOutlet UIButton *FSloginButton;                      /**<  FB登录按钮 */
@property (nonatomic)  BOOL isFBLoginOK;
@end

@implementation JYLoginViewController


- (BOOL)允许未登录访问 { return true; }
- (BOOL)允许游客访问 { return true; }

-(void)viewWillAppear:(BOOL)animated{
//    [self viewWillAppear:animated];

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
    self.tabBarController.tabBar.hidden = YES;
}

-(void)dealloc{
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.fd_interactivePopDisabled = true;
    
    self.navigationItem.title = @"登录";
    self.loginButton.layer.cornerRadius = 22;
    self.loginButton.layer.masksToBounds = YES;
    [self.loginButton setBackgroundColor:Skin1.navBarBgColor];
    
    self.userNameTextF.delegate = self;
    self.passwordTextF.delegate = self;
    self.navigationController.delegate = self;
    [self.webBgView addSubview:self.webView];
    NSString *url = [NSString stringWithFormat:@"%@%@",APP.Host,swiperVerifyUrl];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
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
    
 
    
    [self.FSloginButton setTitleColor:Skin1.navBarBgColor forState:UIControlStateNormal];
    
    self.FSloginButton.layer.cornerRadius = 5;
    self.FSloginButton.layer.masksToBounds = YES;
    [self.FSloginButton setTitleColor:Skin1.navBarBgColor forState:UIControlStateNormal];
    [self.FSloginButton setHidden:YES];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_updateContent:)
                                                 name:FBSDKProfileDidChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_accessTokenChanged:)
                                                 name:FBSDKAccessTokenDidChangeNotification
                                               object:nil];
     self.isFBLoginOK = NO;
    
    if (self.isfromFB) {
        [self.FSloginButton setHidden:self.isfromFB];
        [self.rigesterButton setHidden:self.isfromFB];
        [self.playButton setHidden:self.isfromFB];
        if (![CMCommon stringIsNull:UGUserModel.currentUser.username]) {
            self.userNameTextF.text =  UGUserModel.currentUser.username;
        }
        [self.loginButton setTitle:@"绑定" forState:(UIControlStateNormal)];
    } else {
         [self.loginButton setTitle:@"登录" forState:(UIControlStateNormal)];
         [self getSystemConfig];
    }

 
    [self.userNameTextF setEnabled:!self.isNOfboauthLogin];
    
}
#pragma mark - 事件
#pragma mark -登录相关
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
                                 @"ggCode":self->ggCode.length ? self->ggCode : @"",
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
        
        if (self.isfromFB) {
            //==>绑定旧账号 ==》成功后无密码登录
            [self fbauthBindAccounAction];
            
            
        }
        else{
            
            [self loginAction:mutDict];
        }
        
        
        
      
    });
}

-(void)loginAction:(NSMutableDictionary *)mutDict
{
    WeakSelf;
    [SVProgressHUD showWithStatus:@"正在登录..."];
     [CMNetwork userLoginWithParams:mutDict completion:^(CMResult<id> *model, NSError *err) {
         [CMResult processWithResult:model success:^{
             if (model.code == 0) {
                 [weakSelf loginOK:model];
             }

         } failure:^(id msg) {
             
             if (model.code == 1) {
                 UGUserModel *user = model.data;
                 NSLog(@"user.needFullName = %d",user.needFullName);
                 if (user.needFullName) {
                     
                     //弹窗
                     // 使用一个变量接收自定义的输入框对象 以便于在其他位置调用
                     
                     __block UITextField *tf = nil;
                     
                     [LEEAlert alert].config
                     .LeeTitle(@"请输入绑定的真实姓名")
                     .LeeAddTextField(^(UITextField *textField) {
                         // 这里可以进行自定义的设置
                         textField.placeholder = @"请输入真实姓名";
                         
                         if (@available(iOS 13.0, *)) {
                             textField.textColor = [UIColor secondaryLabelColor];
                             
                         } else {
                             textField.textColor = [UIColor darkGrayColor];
                         }
                         
                         tf = textField; //赋值
                     })
                     .LeeAddAction(^(LEEAction *action) {
                         
                         action.title = @"关闭";
                         
                         action.titleColor = [UIColor darkGrayColor];
                         
                         action.backgroundColor = [UIColor colorWithRed:249/255.0f green:249/255.0f blue:249/255.0f alpha:1.0f];
                         
                         action.backgroundHighlightColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:239/255.0f alpha:1.0f];
                         
                         action.insets = UIEdgeInsetsMake(0, 10, 10, 10);
                         
                         action.borderPosition = LEEActionBorderPositionTop
                         | LEEActionBorderPositionBottom
                         | LEEActionBorderPositionLeft
                         | LEEActionBorderPositionRight;
                         
                         action.borderWidth = 1.0f;
                         
                         action.borderColor = action.backgroundHighlightColor;
                         
                         action.cornerRadius = 5.0f;
                         
                         action.clickBlock = ^{
                             
                             // 取消点击事件Block
                         };
                     })
                     .LeeAddAction(^(LEEAction *action) {
                         
                         action.title = @"确定";
                         
                         action.titleColor = [UIColor whiteColor];
                         
                         action.backgroundColor = [UIColor colorWithRed:90/255.0f green:154/255.0f blue:239/255.0f alpha:1.0f];
                         
                         action.backgroundHighlightColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:239/255.0f alpha:1.0f];
                         
                         action.insets = UIEdgeInsetsMake(0, 10, 10, 10);
                         
                         action.borderPosition = LEEActionBorderPositionTop
                         | LEEActionBorderPositionBottom
                         | LEEActionBorderPositionLeft
                         | LEEActionBorderPositionRight;
                         
                         action.borderWidth = 1.0f;
                         
                         action.borderColor = action.backgroundHighlightColor;
                         
                         action.cornerRadius = 5.0f;
                         
                         action.clickBlock = ^{
                             
                             //点击事件Block
                             NSString *fullName = tf.text;
                             
                             NSDictionary *params = @{@"usr":self.userNameTextF.text,
                                                      @"pwd":[UGEncryptUtil md5:self.passwordTextF.text],
                                                      @"ggCode":self->ggCode.length ? self->ggCode : @"",
                                                      @"fullName":fullName,
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
                             
                             [weakSelf loginAction:mutDict];
                         };
                     })
                     .leeShouldActionClickClose(^(NSInteger index){
                         // 是否可以关闭回调, 当即将关闭时会被调用 根据返回值决定是否执行关闭处理
                         // 这里演示了与输入框非空校验结合的例子
                         BOOL result = ![tf.text isEqualToString:@""];
                         result = index == 0 ? result : YES;
                         return result;
                     })
                     .LeeShow();
     
                     
                 }
                 
             }
             
             weakSelf.errorTimes += 1;
             if (weakSelf.errorTimes == 4) {
                 if (![UGSystemConfigModel  currentConfig].loginVCode) {
                     weakSelf.webBgView.hidden = NO;
                     weakSelf.webBgViewHeightConstraint.constant = 120;
                     [weakSelf webLoadURL];
                 }
                 
             }
             
             UGUserModel *user = (UGUserModel*) model.data;
             
             NSInteger intGgCheck =  user.ggCheck;
             
             if (intGgCheck == 1) {
                 
                 weakSelf.gCheckUserName = self.userNameTextF.text;
                 [weakSelf showLeeView];
             }
             if ([weakSelf.userNameTextF.text isEqualToString:weakSelf.gCheckUserName]) {
                 
                 [weakSelf showLeeView];
                 
             }
             
             if (weakSelf.webBgView.hidden == NO) {
                 [weakSelf.webView reload];
                 weakSelf.imgVcodeModel = nil;
             }
             
             [SVProgressHUD showErrorWithStatus:msg];
             
         }];
     }];
}

-(void)loginOK:(CMResult<id> *)model
{
    [SVProgressHUD showSuccessWithStatus:model.msg];
    
    // 退出登录上一个账号
    if (UGUserModel.currentUser) {
        [CMNetwork userLogoutWithParams:@{@"token":[UGUserModel currentUser].sessid} completion:nil];
        UGUserModel.currentUser = nil;
        SANotificationEventPost(UGNotificationUserLogout, nil);
    }
    
    NSLog(@"model.data = %@",model.data);
    
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


//去注册界面
- (IBAction)showRegister:(id)sender {
    for (UIViewController *vc in self.navigationController.childViewControllers) {
        if ([vc isKindOfClass:JYRegisterViewController.class]) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }
    JYRegisterViewController *registerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"JYRegisterViewController"];
    [self.navigationController pushViewController:registerVC animated:YES];
    
//    [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGRegisterViewController") animated:YES];
    
}
//免费试玩
- (IBAction)playAction:(id)sender {
    SANotificationEventPost(UGNotificationTryPlay, nil);
    [self.navigationController popToRootViewControllerAnimated:YES];
}
//去首页
- (IBAction)goHomeAction:(id)sender {

    [self.navigationController popToRootViewControllerAnimated:YES];
}
//去电脑网页
- (IBAction)goPCVC:(id)sender {
    TGWebViewController *qdwebVC = [[TGWebViewController alloc] init];
    qdwebVC.url = pcUrl;
    qdwebVC.webTitle = UGSystemConfigModel.currentConfig.webName;
    [NavController1 pushViewController:qdwebVC animated:YES];
}

//记住密码
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

- (IBAction)goKefu:(id)sender {
    // 在线客服
     [NavController1 pushVCWithUserCenterItemType:UCI_在线客服];
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

#pragma mark - UITextFieldDelegate
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

- (void)getSystemConfig {
    WeakSelf;
    [CMNetwork getSystemConfigWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            UGSystemConfigModel *config = model.data;
            UGSystemConfigModel.currentConfig = config;
            NSLog(@"登录增加了滑动验证码配置==%d",[UGSystemConfigModel  currentConfig].loginVCode);

            if ([UGSystemConfigModel  currentConfig].loginVCode) {
                weakSelf.webBgView.hidden = NO;
                weakSelf.webBgViewHeightConstraint.constant = 120;
                [weakSelf webLoadURL];
            } else {
                weakSelf.webBgView.hidden = YES;
                weakSelf.webBgViewHeightConstraint.constant = 0.1;
            }
            
            if (config.oauth.mSwith) {
                BOOL isFSShow = config.oauth.platform.facebook;
                 [weakSelf.FSloginButton setHidden:!isFSShow];
            } else {
                [weakSelf.FSloginButton setHidden:YES];
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


#pragma mark - facebook 登录相关
- (IBAction)faceBookLoginAction:(id)sender {
    
    //判断是否已经帮定过
    NSInteger slot = 0;
    FBSDKAccessToken *token = [SUCache itemForSlot:slot].token;
    if (token) { // FB用户曾经已经登录
        [self fbautoLoginWithToken:token];
    }
    else{
        [self FBnewLogin];
    }
}
//facebook自动登录
- (void)fbautoLoginWithToken:(FBSDKAccessToken *)token {
    [FBSDKAccessToken setCurrentAccessToken:token];
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil];
    WeakSelf;
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        //token过期，删除存储的token和profile
        if (error) {
            NSLog(@"用户令牌不再有效.");
            [weakSelf FBnewLogin];
        }
        //做登录完成的操作
        else {
            //                    是否绑定
            [weakSelf fboauthHasBindAction];
            
        }
    }];
}

- (void)fboauthHasBindAction {//FB是否绑定
    NSInteger slot = 0;
    NSString *uuid =  [SUCache itemForSlot:slot].profile.userID;
    NSDictionary *params = @{@"uuid":uuid,
                             @"platform":@"facebook",
    };
    
    WeakSelf;
    [CMNetwork oauthHasBindWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        
        
        [CMResult processWithResult:model success:^{
            
            NSDictionary * disData = model.data;
            //                "uid" : "133",
            //                "facebook_id" : "120134393077235",
            //                "facebook_name" : "尹天奇",
            //                "usr" : "082405"
            
            NSLog(@"model.data = %@",model.data);
            FBSDKAccessToken *token = [SUCache itemForSlot:slot].token;
            if ([CMCommon stringIsNull:[disData objectForKey:@"facebook_id"]])
            {
                //没有绑定
                if (token.tokenString) {
                    //去中间界面
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        SUCacheItem *item = [SUCache itemForSlot:0];
                        FBTransitionViewController *registerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FBTransitionViewController"];
                        registerVC.name = item.profile.name;
                        [self.navigationController pushViewController:registerVC animated:YES];
                        
                    });
                    
                }
            }
            else{
                //已经有绑定
                if (token.tokenString) {
                    if (weakSelf.isNOfboauthLogin) {
                        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                    } else {
                        [weakSelf fboauthLoginUrlAction];
                    }
                }
            }
            weakSelf.isFBLoginOK = NO;
        } failure:^(id msg) {
            
            [SVProgressHUD showErrorWithStatus:msg];
            weakSelf.isFBLoginOK = NO;
            
        }];
    }];
    
}
- (void)fboauthLoginUrlAction {//访问无密码登录接口
    
    
    
    NSInteger slot = 0;
    NSString *uuid =  [SUCache itemForSlot:slot].profile.userID;
    NSString *name =  [SUCache itemForSlot:slot].profile.name;
    NSDictionary *params = @{
                             @"oauth[uuid]":uuid,
                             @"oauth[name]":name,
                             @"oauth[platform]":@"facebook",
                             
    };
    [SVProgressHUD showWithStatus:@"正在登录..."];
    WeakSelf;
    [CMNetwork oauthLoginUrlWithParams:params completion:^(CMResult<id> *model, NSError *err) {

        [CMResult processWithResult:model success:^{
            
            [SVProgressHUD showSuccessWithStatus:model.msg];
            NSLog(@"model.data = %@",model.data);
            // 退出登录上一个账号
            if (UGUserModel.currentUser) {
                [CMNetwork userLogoutWithParams:@{@"token":[UGUserModel currentUser].sessid} completion:nil];
                UGUserModel.currentUser = nil;
                SANotificationEventPost(UGNotificationUserLogout, nil);
            }
            
            UGUserModel *user = model.data;
            UGUserModel.currentUser = user;
            
             SANotificationEventPost(UGNotificationLoginComplete, nil);
            
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            
        } failure:^(id msg) {
            
            [SVProgressHUD showErrorWithStatus:msg];
            
        }];
    }];
    
}

- (void)fbauthBindAccounAction {//绑定旧账号
    NSInteger slot = 0;
    NSString *uuid =  [SUCache itemForSlot:slot].profile.userID;
    NSString *name =  [SUCache itemForSlot:slot].profile.name;
    NSDictionary *params = @{
        @"usr":self.userNameTextF.text,
        @"pwd":[UGEncryptUtil md5:self.passwordTextF.text],
        @"uuid":uuid,
        @"name":name,
        @"platform":@"facebook",
        
    };
    [SVProgressHUD showWithStatus:@"正在绑定..."];
    WeakSelf;
    [CMNetwork oauthBindAccountWithParams:params completion:^(CMResult<id> *model, NSError *err) {

        [CMResult processWithResult:model success:^{
            
            [SVProgressHUD showSuccessWithStatus:model.msg];
            if (model.code == 0) {//成功
                if (weakSelf.isNOfboauthLogin) {
                     [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                } else {
                     [weakSelf fboauthLoginUrlAction];
                }
               
            }
            
        } failure:^(id msg) {
            
            [SVProgressHUD showErrorWithStatus:msg];
            
        }];
    }];
    
}

- (void)FBnewLogin {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    
    WeakSelf;
    [login
     logInWithReadPermissions: @[@"public_profile"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        NSLog(@"facebook登录result.grantedPermissions = %@,error = %@",result.grantedPermissions,error);
        if (error) {
            NSLog(@"流程错误");
            weakSelf.isFBLoginOK = NO;
        } else if (result.isCancelled) {
            NSLog(@"取消了");
            weakSelf.isFBLoginOK = NO;
        } else {
            NSLog(@"登录成功");
            weakSelf.isFBLoginOK = YES;
        }
    }];
    
}

#pragma mark - Notification

- (void)_updateContent:(NSNotification *)notification {
    FBSDKProfile *profile = notification.userInfo[FBSDKProfileChangeNewKey];
    [self labelDisplayWithProfile:profile];
    
    //                    是否绑定
    if (self.isFBLoginOK) {
         [self  fboauthHasBindAction];
    }
   
}

- (void)_accessTokenChanged:(NSNotification *)notification
{
    FBSDKAccessToken *token = notification.userInfo[FBSDKAccessTokenChangeNewKey];
    if (!token) {
        [FBSDKAccessToken setCurrentAccessToken:nil];
        [FBSDKProfile setCurrentProfile:nil];
    } else {
        NSInteger slot = 0;
        SUCacheItem *item = [SUCache itemForSlot:slot] ?: [[SUCacheItem alloc] init];
        if (![item.token isEqualToAccessToken:token]) {
            item.token = token;
            [SUCache saveItem:item slot:slot];
        }
    }
}

- (void)labelDisplayWithProfile:(FBSDKProfile *)profile{
    NSInteger slot = 0;
    if (profile) {
        SUCacheItem *cacheItem = [SUCache itemForSlot:slot];
        cacheItem.profile = profile;
        [SUCache saveItem:cacheItem slot:slot];
//        NSString *ss = [NSString stringWithFormat:@"名称 = %@,userID = %@",cacheItem.profile.name,cacheItem.profile.userID];
//        NSURL *imgURL = [profile imageURLForPictureMode:FBSDKProfilePictureModeNormal size:CGSizeMake(50, 50)];
  
    }
}

@end
