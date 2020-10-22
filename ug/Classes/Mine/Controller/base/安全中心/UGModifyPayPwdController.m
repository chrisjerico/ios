//
//  UGModifyPayPwdController.m
//  ug
//
//  Created by ug on 2019/5/7.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModifyPayPwdController.h"
#import "UGEncryptUtil.h"
#import "ResetPasswordApplyVC.h"

@interface UGModifyPayPwdController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *loginPwdTextF;
@property (weak, nonatomic) IBOutlet UITextField *payPwdTextF;
@property (weak, nonatomic) IBOutlet UITextField *checkPayPwdTextF;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *forgetPwdButton;


@end

@implementation UGModifyPayPwdController
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
    self.loginPwdTextF.delegate = self;
    self.payPwdTextF.delegate = self;
    self.checkPayPwdTextF.delegate = self;
    
    FastSubViewCode(self.view);
   [_bgView setBackgroundColor:Skin1.textColor4];
   [subView(@"背景view") setBackgroundColor:Skin1.textColor4];
   [subLabel(@"旧取款密码label") setTextColor:Skin1.textColor1];
   [subTextField(@"旧取款密码txt") setTextColor:Skin1.textColor1];
   [subLabel(@"新密码label") setTextColor:Skin1.textColor1];
   [subTextField(@"新密码txt") setTextColor:Skin1.textColor1];
   [subLabel(@"确认新密码label") setTextColor:Skin1.textColor1];
   [subTextField(@"确认新密码txt") setTextColor:Skin1.textColor1];
    subTextField(@"旧取款密码txt").attributedPlaceholder = [[NSAttributedString alloc] initWithString:subTextField(@"旧取款密码txt").placeholder attributes:@{NSForegroundColorAttributeName:Skin1.textColor3}];
    subTextField(@"新密码txt").attributedPlaceholder = [[NSAttributedString alloc] initWithString:subTextField(@"新密码txt").placeholder attributes:@{NSForegroundColorAttributeName:Skin1.textColor3}];
    subTextField(@"确认新密码txt").attributedPlaceholder = [[NSAttributedString alloc] initWithString:subTextField(@"确认新密码txt").placeholder attributes:@{NSForegroundColorAttributeName:Skin1.textColor3}];
	if (UGSystemConfigModel.currentConfig.switchCoinPwd == 1) {
		[self.forgetPwdButton setHidden:false];
		[self.forgetPwdButton addTarget:self action:@selector(forgetPasswordAction:)];
	}

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];

}

- (IBAction)submit:(id)sender {
    WeakSelf;
    ck_parameters(^{
        ck_parameter_non_empty(self.loginPwdTextF.text, @"请输入旧密码");
        if (self.loginPwdTextF.text.length != 4) {
            [self.navigationController.view makeToast:@"取款密码限制只能输入四位"
                                             duration:1.5
                                             position:CSToastPositionCenter];
            return ;
        }
        ck_parameter_non_empty(self.payPwdTextF.text, @"请输入新密码");
        ck_parameter_non_empty(self.checkPayPwdTextF.text, @"请确认新密码");
        ck_parameter_isEqual(self.payPwdTextF.text, self.checkPayPwdTextF.text, @"两次输入的新密码不一致");
        
    }, ^(id err) {
        [SVProgressHUD showInfoWithStatus:err];
    }, ^{
        NSDictionary *params = @{@"old_pwd":[UGEncryptUtil md5:self.loginPwdTextF.text],
                                 @"new_pwd":[UGEncryptUtil md5:self.payPwdTextF.text],
                                 @"token":[UGUserModel currentUser].sessid
                                 };
        [SVProgressHUD showWithStatus:nil];
 
        [CMNetwork modifyPayPwdWithParams:params completion:^(CMResult<id> *model, NSError *err) {
            [CMResult processWithResult:model success:^{
                [SVProgressHUD showSuccessWithStatus:model.msg];
                [weakSelf.view endEditing:YES];
                weakSelf.loginPwdTextF.text = nil;
                weakSelf.payPwdTextF.text = nil;
                weakSelf.checkPayPwdTextF.text = nil;
            } failure:^(id msg) {
                [SVProgressHUD showErrorWithStatus:msg];
            }];
        }];
    });
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [self.loginPwdTextF resignFirstResponder];
        [self.payPwdTextF resignFirstResponder];
        [self.checkPayPwdTextF resignFirstResponder];
        return NO;
    }
    if ([textField.text stringByReplacingCharactersInRange:range withString:string].length > 30) {
        return NO;
    }
    return YES;
}

- (void)forgetPasswordAction:(UIButton *)sender {
	ResetPasswordApplyVC *vc = [[ResetPasswordApplyVC alloc] init];
	[self.navigationController pushViewController:vc animated:true];
}

@end
