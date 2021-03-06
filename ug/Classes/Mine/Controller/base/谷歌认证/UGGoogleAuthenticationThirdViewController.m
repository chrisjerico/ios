//
//  UGGoogleAuthenticationThirdViewController.m
//  ug
//
//  Created by ug on 2019/9/25.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGGoogleAuthenticationThirdViewController.h"

@interface UGGoogleAuthenticationThirdViewController ()
@property (weak, nonatomic) IBOutlet UITextField *myTextField;
@property (weak, nonatomic) IBOutlet UILabel *myTitle;
@property (weak, nonatomic) IBOutlet UIButton *returnButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@end

@implementation UGGoogleAuthenticationThirdViewController
-(void)skin{
    [self.view setBackgroundColor: Skin1.bgColor];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"二次验证";
    [self.view setBackgroundColor:Skin1.textColor4];
    [self.myTitle setTextColor:Skin1.textColor1];
    [self.myTextField setTextColor:Skin1.textColor1];
    _myTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_myTextField.placeholder attributes:@{NSForegroundColorAttributeName:Skin1.textColor3}];
    [self.returnButton setBackgroundColor:Skin1.navBarBgColor];
    [self.nextButton setBackgroundColor:Skin1.navBarBgColor];
    [IQKeyboardManager.sharedManager.disabledDistanceHandlingClasses addObject:[self class]];
    
    SANotificationEventSubscribe(UGNotificationWithSkinSuccess, self, ^(typeof (self) self, id obj) {
        [self skin];
    });
    
    [_myTextField becomeFirstResponder];
}

- (void)viewDidLayoutSubviews {
    self.returnButton.layer.masksToBounds = YES;
    //如果想要有点弧度的不是地球那么圆的可以设置
    self.returnButton.layer.cornerRadius = 3;//这个值越大弧度越大
    
    self.nextButton.layer.masksToBounds = YES;
    //如果想要有点弧度的不是地球那么圆的可以设置
    self.nextButton.layer.cornerRadius = 3;//这个值越大弧度越大
}

#pragma mark -- 网络请求
//e二维码数据
- (void)secureGaCaptchaWithBind {
    
    
    
    NSString *code = [self.myTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([CMCommon stringIsNull:code]) {
        [self.view makeToast:@"请填写验证码"];
        return;
    }
    if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
        return;
    }
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"action":@"bind",
                             @"code":code,
                             };
    
    [SVProgressHUD showWithStatus:nil];
    WeakSelf;
    [CMNetwork secureGaCaptchaWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
          [SVProgressHUD showSuccessWithStatus:model.msg];
            
           [weakSelf.navigationController popToRootViewControllerAnimated:YES];
  
        } failure:^(id msg) {
            
            [SVProgressHUD showErrorWithStatus:msg];
            
        }];
    }];
}


- (IBAction)returnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)nextAction:(id)sender {
    [self secureGaCaptchaWithBind];
}

@end
