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
    if ([Skin1.skitType isEqualToString:@"黑色模板"]) {
        [self.view setBackgroundColor:Skin1.bgColor];
        [subLabel(@"标题label") setTextColor:[UIColor whiteColor]];
        [subLabel(@"登录密码label") setTextColor:[UIColor whiteColor]];
        [subLabel(@"取款密码label") setTextColor:[UIColor whiteColor]];
        [subLabel(@"确认密码label") setTextColor:[UIColor whiteColor]];
        [self.loginPwdTextF setTextColor:[UIColor whiteColor]];
        [self.fundPwdTextF setTextColor:[UIColor whiteColor]];
        [self.checkPwdTextF setTextColor:[UIColor whiteColor]];
         // "通过KVC修改占位文字的颜色"
        [self.loginPwdTextF setValue:Skin1.textColor3 forKeyPath:@"_placeholderLabel.textColor"];
        [self.fundPwdTextF setValue:Skin1.textColor3 forKeyPath:@"_placeholderLabel.textColor"];
        [self.checkPwdTextF setValue:Skin1.textColor3 forKeyPath:@"_placeholderLabel.textColor"];
  
        
    } else {
        [self.view setBackgroundColor:Skin1.bgColor];
        [subLabel(@"标题label") setTextColor:[UIColor whiteColor]];
        [subLabel(@"登录密码label") setTextColor:[UIColor whiteColor]];
        [subLabel(@"取款密码label") setTextColor:[UIColor whiteColor]];
        [subLabel(@"确认密码label") setTextColor:[UIColor whiteColor]];
        [self.loginPwdTextF setTextColor:[UIColor whiteColor]];
        [self.fundPwdTextF setTextColor:[UIColor whiteColor]];
        [self.checkPwdTextF setTextColor:[UIColor whiteColor]];
         // "通过KVC修改占位文字的颜色"
        [self.loginPwdTextF setValue:Skin1.textColor3 forKeyPath:@"_placeholderLabel.textColor"];
        [self.fundPwdTextF setValue:Skin1.textColor3 forKeyPath:@"_placeholderLabel.textColor"];
        [self.checkPwdTextF setValue:Skin1.textColor3 forKeyPath:@"_placeholderLabel.textColor"];
    }

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
        [CMNetwork addFundPwdWithParams:params completion:^(CMResult<id> *model, NSError *err) {
            [CMResult processWithResult:model success:^{
                [SVProgressHUD showSuccessWithStatus:model.msg];
                UGUserModel *user = [UGUserModel currentUser];
                user.hasFundPwd = YES;
                if (user.hasBankCard) {
                    [self.navigationController popViewControllerAnimated:YES];
                }else {
                    UGBindCardViewController *bindCardVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UGBindCardViewController"];
                    [self.navigationController pushViewController:bindCardVC animated:YES];
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
