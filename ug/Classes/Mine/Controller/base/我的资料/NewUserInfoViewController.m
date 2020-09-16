//
//  NewUserInfoViewController.m
//  UGBWApp
//
//  Created by ug on 2020/9/16.
//  Copyright © 2020 ug. All rights reserved.
//

#import "NewUserInfoViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "SUCache.h"

#import "UGLoginViewController.h"
@interface NewUserInfoViewController ()
{
    
}
//===================================================
@property (weak, nonatomic) IBOutlet UIView *mheadView; /**<    头 */
@property (weak, nonatomic) IBOutlet UIButton *refreshFirstButton;    /**<    刷新按钮 */
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;/**<    昵称 */
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;   /**<    余额 */
@property (weak, nonatomic) IBOutlet UILabel *realNameLabel;/**<    真实名 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;/**<    下午好*/

@property (weak, nonatomic) IBOutlet UIButton *FBbtn;
@property (weak, nonatomic) IBOutlet UIView *FBView;
@property (weak, nonatomic) IBOutlet UILabel *fbLabel;
@property (nonatomic)  BOOL isFBLoginOK;
@end

@implementation NewUserInfoViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = Skin1.bgColor;
    [_mheadView setBackgroundColor:Skin1.navBarBgColor];
    self.headImageView.layer.cornerRadius = self.headImageView.height / 2 ;
    self.headImageView.layer.masksToBounds = YES;
    
    self.title = @"个人资料";
    
    [self getSystemConfig];
    [self getUserInfo];
    
    __weakSelf_(__self);
    __block NSTimer *__timer = [NSTimer scheduledTimerWithInterval:1 repeats:true block:^(NSTimer *timer) {
        {
            NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit |                 NSSecondCalendarUnit;
            NSDateComponents *dateComponent = [[NSCalendar currentCalendar] components:unitFlags fromDate:[NSDate date]];
            int hour = (int)[dateComponent hour];
            
            NSLog(@"hour is: %d", hour);
            if (hour <=5) {
                __self.titleLabel.text = @"凌晨好，";
                
            }
            else if (hour <=11) {
                __self.titleLabel.text = @"上午好，";
                
            }
            else if (hour <=17) {
                __self.titleLabel.text = @"下午好，";
                
            }
            else {
                __self.titleLabel.text = @"晚上好，";
                
            }
        }
        
        
        if (!__self) {
            [__timer invalidate];
            __timer = nil;
        }
    }];
    if (__timer.block) {
        __timer.block(nil);
    }
    
    
    SANotificationEventSubscribe(UGNotificationGetUserInfoComplete, self, ^(typeof (self) self, id obj) {
        [self setupUserInfo];
    });
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_updateContent:)
                                                 name:FBSDKProfileDidChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_accessTokenChanged:)
                                                 name:FBSDKAccessTokenDidChangeNotification
                                               object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];//不NavBar
    
}

#pragma mark -- 网络请求
// 刷新余额
- (IBAction)refreshBalance:(id)sender {
    [self getUserInfo];
}
- (void)getUserInfo {
    [self startAnimation];
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid};
    WeakSelf;
    [CMNetwork getUserInfoWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            UGUserModel *user = model.data;
            UGUserModel *oldUser = [UGUserModel currentUser];
            user.sessid = oldUser.sessid;
            user.token = oldUser.token;
            UGUserModel.currentUser = user;
            [weakSelf stopAnimation];
            [weakSelf setupUserInfo];
        } failure:^(id msg) {
            [self stopAnimation];
        }];
    }];
}

//刷新余额动画
- (void)startAnimation {
    CABasicAnimation *ReFreshAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    ReFreshAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
    ReFreshAnimation.duration = 1;
    ReFreshAnimation.repeatCount = HUGE_VALF;
    [self.refreshFirstButton.layer addAnimation:ReFreshAnimation forKey:@"rotationAnimation"];
}

//刷新余额动画
- (void)stopAnimation {
    [self.refreshFirstButton.layer removeAllAnimations];
}

#pragma mark - UIS
- (void)setupUserInfo {
    
    UGUserModel *user = [UGUserModel currentUser];
    NSLog(@"user.avatar = %@",user.avatar);
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"touxiang-1"]];
    self.userNameLabel.text = user.username;
    
    double floatString = [user.balance doubleValue];
    self.moneyLabel.text =  [NSString stringWithFormat:@"￥%.2f",floatString];
    
    [self.realNameLabel setHidden:YES];
    if (![CMCommon stringIsNull:user.fullName]) {
        self.realNameLabel.text = user.fullName;
    }
    else{
        self.realNameLabel.text = @"";
    }
    
    FastSubViewCode(self.view);
    [subLabel(@"账号label") setText:user.username];
    [subLabel(@"真实姓名label") setText:user.fullName];
    [subLabel(@"真实姓名label") setText:user.fullName];
    [subLabel(@"QQlabel") setText:user.qq];
    [subLabel(@"手机label") setText:[NSString stringWithFormat:@"手机：%@", user.phone.length ? _NSString(@"%@******%@", [user.phone substringToIndex:MIN(user.phone.length, 3)], [user.phone substringFromIndex:user.phone.length-MIN(user.phone.length, 2)]) : @""]];
    [subLabel(@"邮箱label") setText:user.email];
    
    [self.FBbtn setHidden:user.isTest];
    
    if (![CMCommon stringIsNull:user.oauth.facebook_id] && ![user.oauth.facebook_id isEqualToString:@"0"]) {
        
        [self.FBbtn setBackgroundColor:RGBA(75, 154, 208, 1)];
        [self.FBbtn setTitle:@"FB已绑定" forState:(UIControlStateNormal)];
        
        NSString *fsname = @"";
        if (![CMCommon stringIsNull:user.oauth.facebook_name]) {
            fsname = user.oauth.facebook_name;
        }
        self.fbLabel.text = [NSString stringWithFormat:@"Facebook:%@",fsname];
        [self.FBbtn removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
        WeakSelf;
        [self.FBbtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
            
            
            [weakSelf fboauthUnbind];
        }];
    }
    else{
        [self.FBbtn setBackgroundColor:RGBA(170, 170, 170, 1)];
        [self.FBbtn setTitle:@"未绑定FB" forState:(UIControlStateNormal)];
        [self.FBbtn removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
        WeakSelf;
        [self.FBbtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
            //            可点击按键进行绑定
            [weakSelf fbBind];
        }];
    }
    
}

- (void)getSystemConfig {
    WeakSelf;
    [CMNetwork getSystemConfigWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            UGSystemConfigModel *config = model.data;
            UGSystemConfigModel.currentConfig = config;
            
            if (config.oauth.mSwith) {
                BOOL isFSShow = config.oauth.platform.facebook;
                [weakSelf.FBView setHidden:!isFSShow];
            } else {
                [weakSelf.FBView setHidden:YES];
            }
            
            SANotificationEventPost(UGNotificationGetSystemConfigComplete, nil);
        } failure:^(id msg) {
            [SVProgressHUD dismiss];
        }];
    }];
}


#pragma mark -  FB方法

//去绑定
- (void)fbBind {
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

- (void)labelDisplayWithProfile:(FBSDKProfile *)profile{
    NSInteger slot = 0;
    if (profile) {
        SUCacheItem *cacheItem = [SUCache itemForSlot:slot];
        cacheItem.profile = profile;
        [SUCache saveItem:cacheItem slot:slot];
        //        NSURL *imgURL = [profile imageURLForPictureMode:FBSDKProfilePictureModeNormal size:CGSizeMake(50, 50)];
        
    }
}

#pragma mark - Notification

- (void)_updateContent:(NSNotification *)notification {
    FBSDKProfile *profile = notification.userInfo[FBSDKProfileChangeNewKey];
    [self labelDisplayWithProfile:profile];
    
    //                    是否绑定
    if (self.isFBLoginOK) {
        NSInteger slot = 0;
        SUCacheItem *cacheItem = [SUCache itemForSlot:slot];
        // 去绑定
        [self gobingVC];
        self.isFBLoginOK = NO;
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
            // 去绑定
            [weakSelf gobingVC];
            
        }
    }];
}

-(void)gobingVC{
    dispatch_async(dispatch_get_main_queue(), ^{
        // UI更新代码
        UGLoginViewController *loginVC = _LoadVC_from_storyboard_(@"UGLoginViewController") ;
        loginVC.isfromFB = YES;
        loginVC.isNOfboauthLogin = YES;
        [self.navigationController pushViewController:loginVC animated:YES];
    });
}

- (void)fboauthUnbind {
    NSDictionary *params = @{
        @"token":[UGUserModel currentUser].sessid,
        @"platform":@"facebook",
        
    };
    WeakSelf;
    [CMNetwork oauthUnbindUrlWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            if (model.code == 0) {//成功
                [weakSelf getUserInfo];
                [SVProgressHUD showSuccessWithStatus:model.msg];
            }
            else{
                [SVProgressHUD showErrorWithStatus:model.msg];
            }
            
        } failure:^(id msg) {
            
            [SVProgressHUD showErrorWithStatus:model.msg];
        }];
    }];
}

@end
