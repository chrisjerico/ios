//
//  UGGoogleAuthenticationFirstViewController.m
//  ug
//
//  Created by ug on 2019/9/25.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGGoogleAuthenticationFirstViewController.h"
#import "UGGoogleAuthenticationSecondViewController.h"

@interface UGGoogleAuthenticationFirstViewController ()
@property (weak, nonatomic) IBOutlet UIButton *myButton;
@property (weak, nonatomic) IBOutlet UILabel *myTitle;
@property (weak, nonatomic) IBOutlet UIButton *appleButton;

@end

@implementation UGGoogleAuthenticationFirstViewController
-(void)skin{
     [self initView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.extendedLayoutIncludesOpaqueBars = YES;
    SANotificationEventSubscribe(UGNotificationWithSkinSuccess, self, ^(typeof (self) self, id obj) {
        
        [self skin];
    });
    
    
    [self initView];
   
}

-(void)initView{
     UGUserModel *user = [UGUserModel currentUser];
    
    if (user.isBindGoogleVerifier) {
           //已经绑定了
           _myTitle.text = @"(已启用)您已经成功启用二次验证，登录时请输入您手机上的谷歌验证器显示的6位数字，进行登录二次验证。如果您删除了谷歌验证器，或遗失手机，请联系客服。";
           [_appleButton setHidden:YES];
           [_myButton setBackgroundColor:[UIColor redColor]];
           [_myButton setTitle:@"点击停用谷歌验证器" forState:UIControlStateNormal];
       } else {
           //没绑定
           _myTitle.text = @"您将通过谷歌身份验证器免费获得验证码，增强您的账号资金安全。如果您的手机已经安装谷歌验证器，请点击下一步进行绑定，如果没有请根据您的设备选择下方链接进行安装。";
             [_appleButton setHidden:NO];
             [self.myButton setBackgroundColor:UGNavColor];
             [_myButton setTitle:@"我已安装，下一步" forState:UIControlStateNormal];
       }
}
-(void)viewDidLayoutSubviews{
    self.myButton.layer.masksToBounds = YES;
    //如果想要有点弧度的不是地球那么圆的可以设置
    self.myButton.layer.cornerRadius = 3;//这个值越大弧度越大
    

  
}
- (IBAction)myButtonClicked:(id)sender {
    
    if (UGSystemConfigModel.currentConfig.googleVerifier) {
        //已经绑定了
        [self secureGaCaptchaWithUnbind];
    } else {
        //没绑定
        UGGoogleAuthenticationSecondViewController *vc = [UGGoogleAuthenticationSecondViewController new];
           [self.navigationController pushViewController:vc animated:YES];
    }
   
}

- (IBAction)downLoadAction:(id)sender {
}

//e二维码解绑
- (void)secureGaCaptchaWithUnbind {
    if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
        return;
    }
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"action":@"unbind",
                             };
    
    [SVProgressHUD showWithStatus:nil];
    WeakSelf;
    [CMNetwork secureGaCaptchaWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            
           
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
             [SVProgressHUD showSuccessWithStatus:model.msg];
                
            });
 
            
        } failure:^(id msg) {
            
            [SVProgressHUD showErrorWithStatus:msg];
            
        }];
    }];
}
@end
