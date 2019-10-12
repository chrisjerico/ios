//
//  UGGoogleAuthenticationSecondViewController.m
//  ug
//
//  Created by ug on 2019/9/25.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGGoogleAuthenticationSecondViewController.h"
#import "UGgaCaptchaModel.h"
#import "UGGoogleAuthenticationThirdViewController.h"

@interface UGGoogleAuthenticationSecondViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIButton *mcopyButton;
@property (weak, nonatomic) IBOutlet UIButton *returnButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic)  UGgaCaptchaModel *model;
@end

@implementation UGGoogleAuthenticationSecondViewController
-(void)skin{
    [self.view setBackgroundColor: [[UGSkinManagers shareInstance] setbgColor]];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"二次验证";
    SANotificationEventSubscribe(UGNotificationWithSkinSuccess, self, ^(typeof (self) self, id obj) {
        
        [self skin];
    });
    [self secureGaCaptchaWithGen];
}
-(void)viewDidLayoutSubviews{
    self.returnButton.layer.masksToBounds = YES;
    //如果想要有点弧度的不是地球那么圆的可以设置
    self.returnButton.layer.cornerRadius = 3;//这个值越大弧度越大
    
    [self.returnButton setBackgroundColor:UGNavColor];
    
    self.nextButton.layer.masksToBounds = YES;
    //如果想要有点弧度的不是地球那么圆的可以设置
    self.nextButton.layer.cornerRadius = 3;//这个值越大弧度越大
    
    [self.nextButton setBackgroundColor:UGNavColor];
    
}
#pragma mark -- 网络请求
//e二维码数据
- (void)secureGaCaptchaWithGen {
    if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
        return;
    }
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"action":@"gen",
                             };
    
    [SVProgressHUD showWithStatus:nil];
    WeakSelf;
    [CMNetwork secureGaCaptchaWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            [SVProgressHUD dismiss];
            
            weakSelf.model = model.data;
            NSLog(@"checkinList = %@",weakSelf.model);
            
            UGgaCaptchaModel *obj = model.data;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSString *url =[CMCommon imgformat:obj.qrcode];
                [self.myImageView sd_setImageWithURL:[NSURL URLWithString: url] placeholderImage:[UIImage imageNamed:@"placeholder"]];//m_logo
                self.numberLabel.text = obj.secret;
                
            });
 
            
        } failure:^(id msg) {
            
            [SVProgressHUD showErrorWithStatus:msg];
            
        }];
    }];
}


- (IBAction)copyAction:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.numberLabel.text;
    [SVProgressHUD showInfoWithStatus:@"复制成功"];
}
- (IBAction)returnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)nextAction:(id)sender {
    UGGoogleAuthenticationThirdViewController *vc = [[UGGoogleAuthenticationThirdViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
