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
    [self.view setBackgroundColor:Skin1.textColor4];
    [self.myTitle setTextColor:Skin1.textColor1];
    [self getUserInfo];
   
}
- (void)getUserInfo {

    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid};
    [CMNetwork getUserInfoWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        
        [CMResult processWithResult:model success:^{
            UGUserModel *user = model.data;
            UGUserModel *oldUser = [UGUserModel currentUser];
            user.sessid = oldUser.sessid;
            user.token = oldUser.token;
            UGUserModel.currentUser = user;
           [self initView];
        } failure:^(id msg) {
        
        }];
    }];
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
             [self.myButton setBackgroundColor:Skin1.navBarBgColor];
             [_myButton setTitle:@"我已安装，下一步" forState:UIControlStateNormal];
       }
}
-(void)viewDidLayoutSubviews{
    self.myButton.layer.masksToBounds = YES;
    //如果想要有点弧度的不是地球那么圆的可以设置
    self.myButton.layer.cornerRadius = 3;//这个值越大弧度越大
    

  
}
- (IBAction)myButtonClicked:(id)sender {
    UGUserModel *user = [UGUserModel currentUser];
     if (user.isBindGoogleVerifier) {
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
    
     // 使用一个变量接收自定义的输入框对象 以便于在其他位置调用
               __block NSString *code = @"";
              __block UITextField *tf = nil;
              
              [LEEAlert alert].config
              .LeeTitle(@"请输入6位验证码")
              .LeeContent(@"")
              .LeeAddTextField(^(UITextField *textField) {
                  
                  // 这里可以进行自定义的设置
                  
                  textField.placeholder = @"输入框";
                  
                  textField.textColor = [UIColor darkGrayColor];
                  
                  tf = textField; //赋值
              })
              .LeeAction(@"确定", ^{
                  NSLog(@"tf.text = %@",tf.text);
                  
                  code = tf.text;
                  
                  if ([CMCommon stringIsNull:code]) {
                         [self.view makeToast:@"请填写验证码"];
                         return;
                }
                 if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
                     return;
                 }
                 NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                                          @"action":@"unbind",
                                          @"code":code,
                                          };
                 
                 [SVProgressHUD showWithStatus:nil];
                 
                 [CMNetwork secureGaCaptchaWithParams:params completion:^(CMResult<id> *model, NSError *err) {
                     [CMResult processWithResult:model success:^{

                         dispatch_async(dispatch_get_main_queue(), ^{
                             
                          [SVProgressHUD showSuccessWithStatus:model.msg];
                          [self.navigationController popToRootViewControllerAnimated:YES];
                         });
              
                         
                     } failure:^(id msg) {
                         
                         [SVProgressHUD showErrorWithStatus:msg];
                         
                     }];
                 }];
                  
                  
              })
              .leeShouldActionClickClose(^(NSInteger index){
                  // 是否可以关闭回调, 当即将关闭时会被调用 根据返回值决定是否执行关闭处理
                  // 这里演示了与输入框非空校验结合的例子
                  BOOL result = ![tf.text isEqualToString:@""];
                  result = index == 0 ? result : YES;
                  return result;
              })
              .LeeCancelAction(@"取消", nil) // 点击事件的Block如果不需要可以传nil
              .LeeShow();
    
   
}
@end
