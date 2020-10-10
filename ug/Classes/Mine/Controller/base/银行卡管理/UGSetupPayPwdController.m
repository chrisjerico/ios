//
//  UGSetupPayPwdController.m
//  ug
//
//  Created by ug on 2019/5/24.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGSetupPayPwdController.h"
#import "UGBindCardViewController.h"
#import "UGEncryptUtil.h"

@interface UGSetupPayPwdController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *loginPwdTextF;
@property (weak, nonatomic) IBOutlet UITextField *fundPwdTextF;
@property (weak, nonatomic) IBOutlet UITextField *checkPwdTextF;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@end

@implementation UGSetupPayPwdController
-(void)skin{
    [self.view setBackgroundColor: Skin1.bgColor];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"银行卡管理";
    [self.view setBackgroundColor: [UIColor whiteColor]];
    SANotificationEventSubscribe(UGNotificationWithSkinSuccess, self, ^(typeof (self) self, id obj) {
        
        [self skin];
    });
    self.submitButton.layer.cornerRadius = 3;
    self.submitButton.layer.masksToBounds = YES;
    [self.submitButton setBackgroundColor:Skin1.navBarBgColor];
    FastSubViewCode(self.view)
    if (Skin1.isBlack) {
        [self.view setBackgroundColor:Skin1.bgColor];
        [subLabel(@"标题label") setTextColor:[UIColor whiteColor]];
        [subLabel(@"登录密码label") setTextColor:[UIColor whiteColor]];
        [subLabel(@"取款密码label") setTextColor:[UIColor whiteColor]];
        [subLabel(@"确认密码label") setTextColor:[UIColor whiteColor]];
        [self.loginPwdTextF setTextColor:[UIColor whiteColor]];
        [self.fundPwdTextF setTextColor:[UIColor whiteColor]];
        [self.checkPwdTextF setTextColor:[UIColor whiteColor]];

    } else {
        [self.view setBackgroundColor:[UIColor whiteColor]];
        [subLabel(@"标题label") setTextColor:[UIColor blackColor]];
        [subLabel(@"登录密码label") setTextColor:[UIColor blackColor]];
        [subLabel(@"取款密码label") setTextColor:[UIColor blackColor]];
        [subLabel(@"确认密码label") setTextColor:[UIColor blackColor]];
        [self.loginPwdTextF setTextColor:[UIColor blackColor]];
        [self.fundPwdTextF setTextColor:[UIColor blackColor]];
        [self.checkPwdTextF setTextColor:[UIColor blackColor]];

    }
    [CMCommon textFieldSetPlaceholderLabelColor:Skin1.textColor3 TextField:self.loginPwdTextF];
    [CMCommon textFieldSetPlaceholderLabelColor:Skin1.textColor3 TextField:self.fundPwdTextF];
    [CMCommon textFieldSetPlaceholderLabelColor:Skin1.textColor3 TextField:self.checkPwdTextF];
    self.loginPwdTextF.delegate = self;
    self.fundPwdTextF.delegate = self;
    self.checkPwdTextF.delegate = self;
}

- (IBAction)submitClick:(id)sender {
    ck_parameters(^{
        ck_parameter_non_empty(self.loginPwdTextF.text, @"请输入登录密码");
        ck_parameter_non_empty(self.fundPwdTextF.text, @"请输入取款密码");
        ck_parameter_non_empty(self.checkPwdTextF.text, @"请输入确认取款密码");
        ck_parameter_isEqual(self.fundPwdTextF.text, self.checkPwdTextF.text, @"两次输入的取款密码不一致");
    
    }, ^(id err) {
        [SVProgressHUD showInfoWithStatus:err];
    }, ^{
        if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
            return;
        }
        NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                                 @"login_pwd":[UGEncryptUtil md5:self.loginPwdTextF.text],
                                 @"fund_pwd":[UGEncryptUtil md5:self.fundPwdTextF.text],
                                 };
        [SVProgressHUD showWithStatus:nil];
        WeakSelf;
        [CMNetwork addFundPwdWithParams:params completion:^(CMResult<id> *model, NSError *err) {
            [CMResult processWithResult:model success:^{
                [SVProgressHUD showSuccessWithStatus:model.msg];
                UGUserModel *user = [UGUserModel currentUser];
                user.hasFundPwd = YES;
                if (user.hasBankCard) {
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }else {
                    [NavController1 pushViewController:_LoadVC_from_storyboard_(@"WithdrawalAccountListVC") animated:true];
                }
            } failure:^(id msg) {
                [SVProgressHUD showErrorWithStatus:msg];
                
            }];
        }];
        
    });
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [self.view endEditing:YES];
        return NO;
    }
    
    return YES;
}


@end
