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
@property (weak, nonatomic) IBOutlet UIButton *returnButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@end

@implementation UGGoogleAuthenticationThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     self.title = @"二次验证";
}

-(void)viewDidLayoutSubviews{
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
    
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"action":@"bind",
                             @"code":code,
                             };
    
    [SVProgressHUD showWithStatus:nil];
    WeakSelf;
    [CMNetwork secureGaCaptchaWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
          [SVProgressHUD showSuccessWithStatus:model.msg];
  
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
