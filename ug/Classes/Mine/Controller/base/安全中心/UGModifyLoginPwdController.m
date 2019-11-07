//
//  UGModifyLoginPwdController.m
//  ug
//
//  Created by ug on 2019/5/7.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModifyLoginPwdController.h"
#import "UGEncryptUtil.h"
#import "UGSystemConfigModel.h"

@interface UGModifyLoginPwdController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *oldLoginPwdTextF;
@property (weak, nonatomic) IBOutlet UITextField *loginPwdTextF;
@property (weak, nonatomic) IBOutlet UITextField *checkLoginPwdTextF;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (strong, nonatomic) IBOutlet UIView *bgView;

@property (nonatomic, strong) NSString *pwdPlaceholder;
@end

@implementation UGModifyLoginPwdController
-(void)skin{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    SANotificationEventSubscribe(UGNotificationWithSkinSuccess, self, ^(typeof (self) self, id obj) {
        [self skin];
    });
    self.submitButton.layer.cornerRadius = 3;
    self.submitButton.layer.masksToBounds = YES;
    [self.submitButton setBackgroundColor:Skin1.navBarBgColor];
    
    self.oldLoginPwdTextF.delegate = self;
    self.loginPwdTextF.delegate = self;
    self.checkLoginPwdTextF.delegate = self;
    
    FastSubViewCode(self.view);
    [_bgView setBackgroundColor:Skin1.textColor4];
    [subView(@"背景view") setBackgroundColor:Skin1.textColor4];
    [subLabel(@"原登录密码label") setTextColor:Skin1.textColor1];
    [subLabel(@"原登录密码txt") setTextColor:Skin1.textColor1];
    // "通过KVC修改占位文字的颜色"
    [subLabel(@"原登录密码txt") setValue:Skin1.textColor3 forKeyPath:@"_placeholderLabel.textColor"];
    [subLabel(@"新密码label") setTextColor:Skin1.textColor1];
    [subLabel(@"新密码txt") setTextColor:Skin1.textColor1];
    // "通过KVC修改占位文字的颜色"
    [subLabel(@"新密码txt") setValue:Skin1.textColor3 forKeyPath:@"_placeholderLabel.textColor"];
    [subLabel(@"确认新密码label") setTextColor:Skin1.textColor1];
    [subLabel(@"确认新密码txt") setTextColor:Skin1.textColor1];
    // "通过KVC修改占位文字的颜色"
    [subLabel(@"确认新密码txt") setValue:Skin1.textColor3 forKeyPath:@"_placeholderLabel.textColor"];
    
     UGSystemConfigModel *config = [UGSystemConfigModel currentConfig];
    if (config.pass_limit == 0) {
        
        self.pwdPlaceholder = [NSString stringWithFormat:@"请输入%ld到%ld位长度的密码",config.pass_length_min,config.pass_length_max];
    }else if(config.pass_limit == 1) {
        self.pwdPlaceholder = [NSString stringWithFormat:@"请输入%ld到%ld位数字字母组成的密码",config.pass_length_min,config.pass_length_max];
        
    }else {
        self.pwdPlaceholder = [NSString stringWithFormat:@"请输入%ld到%ld位数字字母符号组成的密码",config.pass_length_min,config.pass_length_max];
    }
    self.loginPwdTextF.placeholder = self.pwdPlaceholder;
    self.checkLoginPwdTextF.placeholder = self.pwdPlaceholder;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (IBAction)submit:(id)sender {
    UGSystemConfigModel *config = [UGSystemConfigModel currentConfig];
    ck_parameters(^{
        ck_parameter_non_empty(self.oldLoginPwdTextF.text, @"请输入原密码");
        ck_parameter_non_empty(self.loginPwdTextF.text, @"请输入新密码");
        ck_parameter_less_length(self.loginPwdTextF.text, [NSString stringWithFormat:@"%ld",config.pass_length_min], self.pwdPlaceholder);
       
        if (self.loginPwdTextF.text.length > config.pass_length_max) {
            [self.navigationController.view makeToast:[NSString stringWithFormat:@"请输入%ld到%ld位长度的密码",config.pass_length_min,config.pass_length_max]
                                             duration:1.5
                                             position:CSToastPositionCenter];
        }
        
        ck_parameter_non_empty(self.checkLoginPwdTextF.text, @"请确认新密码");
        ck_parameter_less_length(self.checkLoginPwdTextF.text, [NSString stringWithFormat:@"%ld",config.pass_length_min], self.pwdPlaceholder);
        
        if (self.checkLoginPwdTextF.text.length > config.pass_length_max) {
            [self.navigationController.view makeToast:[NSString stringWithFormat:@"请输入%ld到%ld位长度的密码",config.pass_length_min,config.pass_length_max]
                                             duration:1.5
                                             position:CSToastPositionCenter];
        }
        
        ck_parameter_isEqual(self.loginPwdTextF.text, self.checkLoginPwdTextF.text, @"两次输入的新密码不一致");
        
    }, ^(id err) {
        [SVProgressHUD showInfoWithStatus:err];
    }, ^{
        NSDictionary *params = @{@"old_pwd":[UGEncryptUtil md5:self.oldLoginPwdTextF.text],
                                 @"new_pwd":[UGEncryptUtil md5:self.loginPwdTextF.text],
                                 @"token":[UGUserModel currentUser].sessid
                                 };
        [SVProgressHUD showWithStatus:nil];
        [CMNetwork modifyLoginPwdWithParams:params completion:^(CMResult<id> *model, NSError *err) {
            [CMResult processWithResult:model success:^{
                [SVProgressHUD showSuccessWithStatus:model.msg];
                [self.view endEditing:YES];
                self.oldLoginPwdTextF.text = nil;
                self.loginPwdTextF.text = nil;
                self.checkLoginPwdTextF.text = nil;
            } failure:^(id msg) {
                [SVProgressHUD showErrorWithStatus:msg];
            }];
        }];
    });
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [self.oldLoginPwdTextF resignFirstResponder];
        [self.loginPwdTextF resignFirstResponder];
        [self.checkLoginPwdTextF resignFirstResponder];
        return NO;
    }
    
    if ([textField.text stringByReplacingCharactersInRange:range withString:string].length > 30) {
        return NO;
    }
    return YES;
}

@end
