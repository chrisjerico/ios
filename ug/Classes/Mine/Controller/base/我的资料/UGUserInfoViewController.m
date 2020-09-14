//
//  UGUserInfoViewController.m
//  ug
//
//  Created by ug on 2019/5/10.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGUserInfoViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "SUCache.h"

#import "UGLoginViewController.h"

@interface UGUserInfoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *avaterImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImgeView;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *qqLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyType;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *time2Label;
@property (weak, nonatomic) IBOutlet UIButton *FBbtn;
@property (weak, nonatomic) IBOutlet UILabel *fbLabel;
@property (nonatomic)  BOOL isFBLoginOK;
@end

@implementation UGUserInfoViewController

-(void)dealloc{
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)允许游客访问 { return true; }

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的资料";
    {
        self.view.backgroundColor = Skin1.textColor4;
        self.userNameLabel.textColor = Skin1.textColor1;
        self.timeLabel.textColor = Skin1.textColor2;
        self.accountLabel.textColor = Skin1.textColor1;
        self.fullNameLabel.textColor = Skin1.textColor1;
        self.qqLabel.textColor = Skin1.textColor1;
        self.phoneLabel.textColor = Skin1.textColor1;
        self.emailLabel.textColor = Skin1.textColor1;
        self.moneyType.textColor = Skin1.textColor1;
        self.fbLabel.textColor = Skin1.textColor1;
        ((UILabel *)[self.view viewWithTagString:@"我的资料Label"]).textColor = Skin1.textColor1;
        
        _avaterImageView.layer.masksToBounds = YES;
        _avaterImageView.layer.cornerRadius = 32.5;

    }
    
    [self getSystemConfig];
    [self setupUserInfo];
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
                __self.time2Label.text = @"凌晨，时间不早了记得休息";
                __self.userNameLabel.textColor = [UIColor whiteColor];
                __self.timeLabel.textColor = [UIColor whiteColor];
            }
            else if (hour <=11) {
                __self.titleLabel.text = @"上午好，";
                __self.time2Label.text = @"上午，补充能量继续战斗";
                __self.userNameLabel.textColor = [UIColor blackColor];
                __self.timeLabel.textColor = [UIColor blackColor];
            }
            else if (hour <=17) {
                __self.titleLabel.text = @"下午好，";
                __self.time2Label.text = @"下午，补充能量继续战斗";
                __self.userNameLabel.textColor = [UIColor blackColor];
                __self.timeLabel.textColor = [UIColor blackColor];
            }
            else {
                __self.titleLabel.text = @"晚上好，";
                __self.time2Label.text = @"傍晚，安静的夜晚是不可多得的享受";
                __self.userNameLabel.textColor = [UIColor whiteColor];
                __self.timeLabel.textColor = [UIColor whiteColor];
            }
        }
        
        __self.timeLabel.text = [[NSDate date] stringWithFormat:@"yyyy.MM.dd HH:mm"];
        
        if (!__self) {
            [__timer invalidate];
            __timer = nil;
        }
    }];
    if (__timer.block) {
        __timer.block(nil);
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_updateContent:)
                                                 name:FBSDKProfileDidChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_accessTokenChanged:)
                                                 name:FBSDKAccessTokenDidChangeNotification
                                               object:nil];
}



- (void)getUserInfo {
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid};
    WeakSelf;
    [CMNetwork getUserInfoWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            UGUserModel *user = model.data;
            UGUserModel *oldUser = [UGUserModel currentUser];
            user.sessid = oldUser.sessid;
            user.token = oldUser.token;
            UGUserModel.currentUser = user;
            [weakSelf setupUserInfo];
        } failure:^(id msg) {
            
            
        }];
    }];
}

- (void)setupUserInfo {
    UGUserModel *user = [UGUserModel currentUser];
    [self.avaterImageView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"touxiang-1"]];
    self.userNameLabel.text = user.username;
    self.accountLabel.text = [NSString stringWithFormat:@"账号：%@",user.username];
    self.fullNameLabel.text = [NSString stringWithFormat:@"真实姓名：%@",user.fullName];
    self.qqLabel.text = [NSString stringWithFormat:@"QQ：%@",user.qq];
    self.phoneLabel.text = [NSString stringWithFormat:@"手机：%@", user.phone.length ? _NSString(@"%@******%@", [user.phone substringToIndex:MIN(user.phone.length, 3)], [user.phone substringFromIndex:user.phone.length-MIN(user.phone.length, 2)]) : @""];
    self.emailLabel.text = [NSString stringWithFormat:@"邮箱：%@",user.email];
    self.timeLabel.text = [[NSDate date] stringWithFormat:@"yyyy.MM.dd HH:mm"];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour;
    NSDateComponents *components = [calendar components:unitFlags fromDate:[NSDate date]];
    if (components.hour > 5 && components.hour < 12 ) {
        self.bgImgeView.image = [UIImage imageNamed:@"sun"];
    } else if (components.hour > 12 && components.hour < 18) {
        self.bgImgeView.image = [UIImage imageNamed:@"xiawu"];
    } else if (components.hour > 18 && components.hour < 21) {
        self.bgImgeView.image = [UIImage imageNamed:@"bangwan"];
    } else {
        self.bgImgeView.image = [UIImage imageNamed:@"wuye"];
    }
    
    

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
                 [weakSelf.FBbtn setHidden:!isFSShow];
            } else {
                [weakSelf.FBbtn setHidden:YES];
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
