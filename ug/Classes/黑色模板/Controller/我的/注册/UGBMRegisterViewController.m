//
//  UGBMRegisterViewController.m
//  ug
//
//  Created by ug on 2019/11/3.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGBMRegisterViewController.h"
#import "UGBMHeaderView.h"
#import "UGLoginViewController.h"
#import "UGEncryptUtil.h"
#import "UGSystemConfigModel.h"
#import "OpenUDID.h"
#import <WebKit/WebKit.h>
#import "UGImgVcodeModel.h"
#import "WKProxy.h"
#import "RegExCategories.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "SUCache.h"
#import "UGBMLoginViewController.h"
@interface UGBMRegisterViewController ()<UITextFieldDelegate,UINavigationControllerDelegate,WKScriptMessageHandler,WKNavigationDelegate,WKUIDelegate>
{
     UGBMHeaderView *headView;                /**<   导航头 */
}

@property (weak, nonatomic) IBOutlet UIView *titleView;                 /**<   账号注册View*/
@property (weak, nonatomic) IBOutlet UIView *titleLineView;              /**<   账号注册下面的线 */


@property (weak, nonatomic) IBOutlet UISegmentedControl *mySegmentCV;                        /**<   */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mySegmentHightConstraint;           /**<    */

@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (weak, nonatomic) IBOutlet UITextField *inviterTextF;           /**<   推荐人ID */
@property (weak, nonatomic) IBOutlet UITextField *userNameTextF;           /**<   用户名 */
@property (weak, nonatomic) IBOutlet UILabel *userNameDisabledNotice;           /**<   该账号已被注册，不可用 */
@property (weak, nonatomic) IBOutlet UITextField *passwordTextF;           /**<   用户密码 */
@property (weak, nonatomic) IBOutlet UITextField *checkPasswordTextF;           /**<  确认密码 */
@property (weak, nonatomic) IBOutlet UIImageView *pwdImgeView;           /**<   密码眼睛1*/
@property (weak, nonatomic) IBOutlet UIImageView *pwd2ImageView;           /**<   密码眼睛2 */
@property (weak, nonatomic) IBOutlet UITextField *realNameTextF;           /**<  真实姓名 */
@property (weak, nonatomic) IBOutlet UITextField *fundPwdTextF;           /**<   取款密码 */
@property (weak, nonatomic) IBOutlet UITextField *QQTextF;           /**<   QQ号码 */
@property (weak, nonatomic) IBOutlet UITextField *wechatTextF;           /**<   微信号 */
@property (weak, nonatomic) IBOutlet UITextField *emailTextF;           /**<   邮箱号码*/
@property (weak, nonatomic) IBOutlet UITextField *phoneTextF;           /**<   手机号码 */
@property (weak, nonatomic) IBOutlet UITextField *smsVcodeTextF;           /**<   短信验证码 */
@property (weak, nonatomic) IBOutlet UIButton *smsVcodeButton;           /**<   短信验证码按钮 */
@property (weak, nonatomic) IBOutlet UITextField *imgVcodeTextF;           /**<   图片验证码 */
@property (weak, nonatomic) IBOutlet UIImageView *imgVcodeImageView;           /**<    图片验证码图片 */

@property (weak, nonatomic) IBOutlet UIView *inviterView;           /**<   推荐人IDView */
@property (weak, nonatomic) IBOutlet UIView *fullNameView;           /**<   真实姓名View */
@property (weak, nonatomic) IBOutlet UIView *fundPwdView;           /**<  取款密码View */
@property (weak, nonatomic) IBOutlet UIView *qqView;           /**<   QQ号码View */
@property (weak, nonatomic) IBOutlet UIView *wechatView;           /**<    微信号View */
@property (weak, nonatomic) IBOutlet UIView *emailView;           /**<   邮箱号码View */
@property (weak, nonatomic) IBOutlet UIView *phoneView;           /**<   手机号码View */
@property (weak, nonatomic) IBOutlet UIView *smsVcodeView;           /**<   短信验证码View*/
@property (weak, nonatomic) IBOutlet UIView *imgVcodeView;           /**<   图片验证码View */
@property (weak, nonatomic) IBOutlet UIView *webBgView;           /**<   谷歌验证View */

@property (weak, nonatomic) IBOutlet UIButton *goLoginButton;           /**<   返回登录*/
@property (weak, nonatomic) IBOutlet UIButton *goHomeButton;           /**<   回到首页 */
@property (weak, nonatomic) IBOutlet UIButton *registerButton;           /**<   注册按钮 */

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inviterViewHightConstraint;           /**<   推荐人ID*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userHightConstraint;           /**<   用户名 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fullNameViewHeightConstraint;           /**<   真实姓名 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fundPwdViewHeightConstraint;           /**<   取款密码 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *qqViewHeightConstraint;           /**<   QQ号码 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wechatViewHeightConstraint;           /**<   微信号 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emailViewHeightConstraint;           /**<   邮箱号码 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneVeiwHeightConstraint;           /**<   手机号码 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *smsVcodeViewHeightConstraint;           /**<   短信验证码*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgVcodeViewHeightConstraint;           /**<   图片验证码 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webBgViewHeightConstraint;           /**<   谷歌验证 */


@property (nonatomic, strong) WKWebView *webView;                       /**<   用户名 */
@property (nonatomic, strong) UGImgVcodeModel *imgVcodeModel;           /**<   用户名 */

@property (strong, nonatomic) NSTimer* timer;                            /**<   用户名 */
@property (assign, nonatomic) NSTimeInterval vcodeRequestTime;           /**<   用户名 */





@property (nonatomic, strong) NSString *regType;
@end

@implementation UGBMRegisterViewController

- (void)skin {
    [self.registerButton setBackgroundColor:Skin1.navBarBgColor];
    [self.goHomeButton setTitleColor:Skin1.navBarBgColor forState:UIControlStateNormal];
    [self.goLoginButton setTitleColor:Skin1.navBarBgColor forState:UIControlStateNormal];
}

- (BOOL)允许未登录访问 { return true; }
- (BOOL)允许游客访问 { return true; }

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [headView.leftwardMarqueeView pause];//fixbug  发热  掉电快
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"skitType= %@",Skin1.skitType);
    NSLog(@"skitString= %@",Skin1.skitString);
    
    if ([Skin1.skitString isEqualToString:@"GPK版香槟金"]) {
        _titleLineView.backgroundColor = Skin1.bgColor;
    }
        
    self.view.backgroundColor = Skin1.bgColor;
    NSMutableArray <UIColor *> *colors = @[].mutableCopy;
    [colors addObject:Skin1.navBarBgColor];
    [colors addObject:Skin1.bgColor];
    self.titleView.backgroundColor =  [UIColor colorWithPatternImage:[UIImage gradientImageWithBounds:self.titleView.bounds andColors:colors andGradientType:GradientDirectionTopToBottom]];
    
    self.fd_prefersNavigationBarHidden = YES;
    SANotificationEventSubscribe(UGNotificationWithSkinSuccess, self, ^(typeof (self) self, id obj) {
        [self skin];
    });
    SANotificationEventSubscribe(UGNotificationGetSystemConfigComplete, self, ^(typeof (self) self, id obj) {
        if (SysConf.domainBindAgentId.intValue > 0) {
            self.inviterTextF.text = SysConf.domainBindAgentId;
            self.inviterTextF.userInteractionEnabled = false;
        }
    });
    if (SysConf.domainBindAgentId.intValue > 0) {
        _inviterTextF.text = SysConf.domainBindAgentId;
        _inviterTextF.userInteractionEnabled = false;
    }
    
    [self creatView];
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    [self.userNameDisabledNotice setHidden:true];
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
    self.regType = @"user";
    self.checkPasswordTextF.secureTextEntry = YES;
    self.passwordTextF.secureTextEntry = YES;
    
    //限制弹出数字键盘
    
    self.inviterTextF.keyboardType = UIKeyboardTypeNumberPad;
    
    self.passwordTextF.clearButtonMode=UITextFieldViewModeNever;
    
    self.checkPasswordTextF.clearButtonMode=UITextFieldViewModeNever;
    
    [self setupSubViews];
    
    UGSystemConfigModel *config = [UGSystemConfigModel currentConfig];
    if (config.reg_vcode == 1) {
        
        [self getImgVcode:nil];
    }

    [self.webBgView addSubview:self.webView];
    
    
    self.passwordTextF.placeholder = ({
        NSString *placeholder = nil;
        if (config.pass_limit == 0) {
            placeholder = [NSString stringWithFormat:@"请输入%ld到%ld位长度的密码", config.pass_length_min, config.pass_length_max];
        } else if(config.pass_limit == 1) {
            placeholder = [NSString stringWithFormat:@"请输入%ld到%ld位数字字母组成的密码", config.pass_length_min, config.pass_length_max];
        } else {
            placeholder = [NSString stringWithFormat:@"请输入%ld到%ld位数字字母符号组成的密码", config.pass_length_min, config.pass_length_max];
        }
        placeholder;
    });
    NSString *url = [NSString stringWithFormat:@"%@%@",APP.Host,swiperVerifyUrl];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
    
    if (!config.allowreg) {
        [QDAlertView showWithTitle:nil message:config.closeregreason cancelButtonTitle:nil otherButtonTitle:@"确定" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

-(void)creatView{
//===============导航头布局=================
   headView = [[UGBMHeaderView alloc] initView];
   [self.view addSubview:headView];
   [headView mas_makeConstraints:^(MASConstraintMaker *make) { //数组额你不必须都是view
       make.top.equalTo(self.view.mas_top).with.offset(k_Height_StatusBar);
       make.left.equalTo(self.view.mas_left).offset(0);
       make.height.equalTo([NSNumber numberWithFloat:110]);
       make.width.equalTo([NSNumber numberWithFloat:UGScreenW]);
   }];
    
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
        WeakSelf;
        [CMNetwork getSmsVcodeWithParams:@{@"phone":self.phoneTextF.text} completion:^(CMResult<id> *model, NSError *err) {
            [CMResult processWithResult:model success:^{
                [SVProgressHUD showSuccessWithStatus:model.msg];
                [weakSelf setVcodeRequestTime:NSDate.new.timeIntervalSince1970];
            } failure:^(id msg) {
                [SVProgressHUD showErrorWithStatus:msg];
                [weakSelf.smsVcodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
            }];
        }];
    });
}

- (IBAction)getImgVcode:(id)sender {
    WeakSelf;
    [CMNetwork getImgVcodeWithParams:@{@"accessToken":[OpenUDID value]} completion:^(CMResult<id> *model, NSError *err) {
        if (!err) {
            NSData *data = (NSData *)model;
            NSString *imageStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            imageStr = [imageStr substringFromIndex:22];
            NSData *decodedImageData = [[NSData alloc] initWithBase64EncodedString:imageStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *decodedImage = [UIImage imageWithData:decodedImageData];
            weakSelf.imgVcodeImageView.image = decodedImage;
        } else {
            
        }
    }];
}

- (IBAction)registerClick:(id)sender {
    UGSystemConfigModel *config = [UGSystemConfigModel currentConfig];
    ck_parameters(^{
        if (config.hide_reco == 2) {
            ck_parameter_non_empty(self.inviterTextF.text, @"请输入推荐人ID");
            
            if (self.inviterTextF.text.length>10) {
                
                [self.view makeToast:@"长度在1到10之前"
                                                 duration:2.0
                                                 position:CSToastPositionCenter];
                return ;
            }
            
            
        }
        ck_parameter_non_empty(self.userNameTextF.text, @"请输入用户名");
        if (self.userNameTextF.text.length<6 ||
            self.userNameTextF.text.length>15 ||
            self.userNameTextF.text.hasSpecialCharacter ||
            self.userNameTextF.text.hasChinese) {
            @throw __ck_parameter_exception(@"请输入6-15位英文或数字的组合的用户名");
        }
        
        // 校验密码格式
        {
            UITextField *tf = self.passwordTextF;
            ck_parameter_less_length(tf.text, _NSString(@"%ld", (long)config.pass_length_min), tf.placeholder);
            
            if (config.pass_limit == 1) {
                ck_parameter_non_zero(_NSString(@"%d", (tf.text.hasNumber && tf.text.hasLetter)), tf.placeholder);
            }
            else if (config.pass_limit == 2) {
                BOOL hasSymbols = false;
                NSString *symbols = @" (@、!\"#$%&,()*+,-./:;[{</|=]}>^`?_";
                for (NSString *s in symbols) {
                    if ([tf.text containsString:s]) {
                        hasSymbols = true;
                        break;
                    }
                }
                ck_parameter_non_zero(_NSString(@"%d", (tf.text.hasNumber && tf.text.hasLetter && hasSymbols)), tf.placeholder);
            }
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
            
    
        } else if (config.reg_vcode == 1 ||
                  config.reg_vcode == 3) {
            
            ck_parameter_non_empty(self.imgVcodeTextF.text, @"请输入验证");
        
        } else if (config.reg_vcode == 2) {
            
        } else {
           
            
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
                                 @"email":self.emailTextF.text ? self.emailTextF.text : @"",
                                 @"regType":self.regType
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
            NSInteger slot = 0;
            NSString *uuid =  [SUCache itemForSlot:slot].profile.userID;
            NSString *name =  [SUCache itemForSlot:slot].profile.name;
            FBSDKAccessToken *token = [SUCache itemForSlot:slot].token;
            
//            [mutDict setValue:token.tokenString forKey:@"oauth_token"];
            [mutDict setValue:uuid forKey:@"oauth[uuid]"];
            [mutDict setValue:name forKey:@"oauth[name]"];
            [mutDict setValue:@"facebook" forKey:@"oauth[platform]"];
        }
        [SVProgressHUD showWithStatus:@"正在注册..."];
        WeakSelf;
        [CMNetwork registerWithParams:mutDict completion:^(CMResult<id> *model, NSError *err) {
             weakSelf.imgVcodeModel = nil;
            [weakSelf.webView reload];
            [CMResult processWithResult:model success:^{

                [SVProgressHUD showSuccessWithStatus:model.msg];
                [weakSelf.view endEditing:YES];
                UGUserModel *user = model.data;
                if (user.autoLogin) {
                    
                    [weakSelf login];
                } else {
                    weakSelf.inviterTextF.text = nil;
                    weakSelf.userNameTextF.text = nil;
                    weakSelf.passwordTextF.text = nil;
                    weakSelf.checkPasswordTextF.text = nil;
                    weakSelf.realNameTextF.text = nil;
                    weakSelf.fundPwdTextF.text = nil;
                    weakSelf.QQTextF.text = nil;
                    weakSelf.wechatTextF.text = nil;
                    weakSelf.phoneTextF.text = nil;
                    weakSelf.emailTextF.text = nil;
                    weakSelf.smsVcodeTextF.text = nil;
                    weakSelf.imgVcodeTextF.text = nil;
                    [weakSelf showLogin:nil];
                }
                if (self.isfromFB) {
                    for (UIViewController *vc in self.navigationController.childViewControllers) {
                        if ([vc isKindOfClass:UGBMLoginViewController.class]) {
                            [self.navigationController popViewControllerAnimated:YES];
                            return;
                        }
                    }
                    UGBMLoginViewController *registerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UGBMLoginViewController"];
                    [self.navigationController pushViewController:registerVC animated:YES];
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
    WeakSelf;
    [CMNetwork userLoginWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            [SVProgressHUD showSuccessWithStatus:model.msg];
            UGUserModel *user = model.data;
            UGUserModel.currentUser = user;
            SANotificationEventPost(UGNotificationLoginComplete, nil);
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        } failure:^(id msg) {
            
            [SVProgressHUD showErrorWithStatus:msg];
            
        }];
    }];
    
}
- (IBAction)goHomeAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)myValueChanged:(id)sender {
    UISegmentedControl *sc = (UISegmentedControl*)sender;
    if (sc.selectedSegmentIndex == 0) {
        NSLog(@"用户");
        self.regType = @"user";

    } else {
        NSLog(@"代理");
        self.regType = @"agent";

    }
    
}

- (IBAction)showLogin:(id)sender {
    
    for (UIViewController *vc in self.navigationController.childViewControllers) {
        if ([vc isKindOfClass:UGLoginViewController.class]) {
            [self.navigationController popViewControllerAnimated:YES];
            return;

        }
    }
    UGLoginViewController *registerVC = _LoadVC_from_storyboard_(@"UGLoginViewController");
    [self.navigationController pushViewController:registerVC animated:YES];
    
}

- (void)setupSubViews {
    
//    0隐藏，1选填，2必填
    UGSystemConfigModel *config = [UGSystemConfigModel currentConfig];
   
    if ([config.agentRegbutton isEqualToString:@"1"]) {
        self.mySegmentCV.hidden = NO;
        self.mySegmentHightConstraint.constant = 28;
    } else {
        self.mySegmentCV.hidden = YES;
        self.mySegmentHightConstraint.constant = 0.1;
    }
    
    if (config.hide_reco) {
        if (config.hide_reco == 1) {
            
            if (APP.isShowWZ) {
                self.inviterTextF.placeholder = @"请输入推荐人ID(如果没有，可不填写)";
            } else {
                self.inviterTextF.placeholder = @"请输入推荐人ID(选填)";
            }
        }
    } else {
        self.inviterView.hidden = YES;
        self.inviterViewHightConstraint.constant = 0.1;
    }
    if (config.reg_name) {
        if (config.reg_name == 1) {
            self.realNameTextF.placeholder = @"请输入真实姓名(选填)";
        }
    } else {
        self.fullNameView.hidden = YES;
        self.fullNameViewHeightConstraint.constant = 0.1;
    }
    if (config.reg_fundpwd) {
        if (config.reg_fundpwd == 1) {
            self.fundPwdTextF.placeholder = @"请输入4位数字的取款密码(选填)";
        }
    } else {
        self.fundPwdView.hidden = YES;
        self.fundPwdViewHeightConstraint.constant = 0.1;
    }
    if (config.reg_qq) {
        if (config.reg_qq == 1) {
            self.QQTextF.placeholder = @"请输入QQ号码(选填)";
        }
    } else {
        self.qqView.hidden = YES;
        self.qqViewHeightConstraint.constant = 0.1;
    }
    if (config.reg_wx) {
        if (config.reg_wx == 1) {
            self.wechatTextF.placeholder = @"请输入微信号(选填)";
        }
    } else {
        self.wechatView.hidden = YES;
        self.wechatViewHeightConstraint.constant = 0.1;
    }
    if (config.reg_phone || config.smsVerify) {
        if (config.reg_phone == 1 && !config.smsVerify) {
            self.phoneTextF.placeholder = @"请输入11位手机号码(选填)";
        }
    } else {
        self.phoneView.hidden = YES;
        self.phoneVeiwHeightConstraint.constant = 0.1;
    }
    if (config.reg_email) {
        if (config.reg_email == 1) {
            self.emailTextF.placeholder = @"请输入邮箱(选填)";
        }
    } else {
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
    } else if (config.reg_vcode == 2) {

        self.imgVcodeView.hidden = YES;
        self.imgVcodeViewHeightConstraint.constant = 0.1;
    } else if (config.reg_vcode == 1 ||
              config.reg_vcode == 3) {
        
        self.webBgView.hidden = YES;
        self.webBgViewHeightConstraint.constant = 0.1;
      
    } else {

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
    } else if (textField == self.emailTextF){
        if (textField.text.length + string.length - range.length > 40) {
            return NO;
        }
        
    } else if(textField == self.fundPwdTextF) {
        if (textField.text.length + string.length - range.length > 4) {
            return NO;
        }
    } else if(textField == self.passwordTextF || textField == self.checkPasswordTextF) {
        UGSystemConfigModel *config = [UGSystemConfigModel currentConfig];
        if (textField.text.length + string.length - range.length > config.pass_length_max) {
            return NO;
        }
    }
    else if (textField == self.inviterTextF) {
        return [self validateNumber:string];
    }
    else {
        if (textField.text.length + string.length - range.length > 20) {
            return NO;
        }
    }
    
    return YES;

}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField != self.userNameTextF) {
        return;
    }
    [CMNetwork.manager requestWithMethod:[[NSString stringWithFormat:@"%@/wjapp/api.php?c=user&a=exists", APP.Host] stringToRestfulUrlWithFlag:RESTFUL]
                                  params:@{@"usr": textField.text}
                                   model:nil
                                    post:true
                              completion:^(CMResult<id> *model, NSError *err) {
        
        if (model.code == 1) {
            [self.userNameDisabledNotice setHidden:false];
            self.userNameDisabledNotice.text = model.msg;
        } else {
            [self.userNameDisabledNotice setHidden:true];
        }
    }];
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
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

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler {
    
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
    
    if ([Skin1.skitString isEqualToString:@"GPK版香槟金"]) {
            [_webView evaluateJavaScript:@"document.body.style.backgroundColor=\"#483428\"" completionHandler:nil];
    } else {
            [_webView evaluateJavaScript:@"document.body.style.backgroundColor=\"#171717\"" completionHandler:nil];
    }

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
        
//        [_webView setBackgroundColor:Skin1.bgColor];
        [_webView setOpaque:NO];
//         _webView.scrollView.backgroundColor = Skin1.bgColor;
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

- (IBAction)pwd2TextSwitch:(UIButton *)sender {
    
    // 前提:在xib中设置按钮的默认与选中状态的背景图
    // 切换按钮的状态
    sender.selected = !sender.selected;
    
    if (sender.selected) { // 按下去了就是明文
        
        NSString *tempPwdStr = self.checkPasswordTextF.text;
        self.checkPasswordTextF.text = @""; // 这句代码可以防止切换的时候光标偏移
        self.checkPasswordTextF.secureTextEntry = NO;
        self.checkPasswordTextF.text = tempPwdStr;
        
        [self.pwd2ImageView setImage:[UIImage imageNamed:@"yanjing"]];
        
    } else { // 暗文
        
        NSString *tempPwdStr = self.checkPasswordTextF.text;
        self.checkPasswordTextF.text = @"";
        self.checkPasswordTextF.secureTextEntry = YES;
        self.checkPasswordTextF.text = tempPwdStr;
        [self.pwd2ImageView setImage:[UIImage imageNamed:@"biyan"]];
    }
}

@end

