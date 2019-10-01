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

@property (nonatomic, strong) NSString *pwdPlaceholder;
@end

@implementation UGModifyLoginPwdController
-(void)skin{
    [self.view setBackgroundColor: [[UGSkinManagers shareInstance] setbgColor]];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor: [[UGSkinManagers shareInstance] setbgColor]];
    SANotificationEventSubscribe(UGNotificationWithSkinSuccess, self, ^(typeof (self) self, id obj) {
        
        [self skin];
    });
    self.submitButton.layer.cornerRadius = 3;
    self.submitButton.layer.masksToBounds = YES;
    self.oldLoginPwdTextF.delegate = self;
    self.loginPwdTextF.delegate = self;
    self.checkLoginPwdTextF.delegate = self;
    
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
    
    //添加通知，来控制键盘和输入框的位置
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
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

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationCurve:7];
    if (self.checkLoginPwdTextF.isFirstResponder) {
        
        self.view.y = -100;
    }else {
        self.view.y = 0;
    }
    [UIView commitAnimations];
    
}

#pragma mark ----- 键盘显示的时候的处理
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    //获得键盘的大小
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationCurve:7];
    if (self.checkLoginPwdTextF.isFirstResponder) {
        
        self.view.y = -100;
    }else {
        self.view.y = 0;
    }
    [UIView commitAnimations];
}

#pragma mark -----    键盘消失的时候的处理
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationCurve:7];
    if (self.checkLoginPwdTextF.isFirstResponder) {
        
        self.view.y = 0;
    }
    [UIView commitAnimations];
}


@end
