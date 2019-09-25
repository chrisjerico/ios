//
//  UGGoogleAuthenticationSecondViewController.m
//  ug
//
//  Created by ug on 2019/9/25.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGGoogleAuthenticationSecondViewController.h"
#import "UGgaCaptchaModel.h"

@interface UGGoogleAuthenticationSecondViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIButton *mcopyButton;
@property (weak, nonatomic) IBOutlet UIButton *returnButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic)  UGgaCaptchaModel *model;
@end

@implementation UGGoogleAuthenticationSecondViewController

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
//得到日期列表数据
- (void)getCheckinListData {
    
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid};
    
    [SVProgressHUD showWithStatus:nil];
    WeakSelf;
    [CMNetwork secureGaCaptchaWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            [SVProgressHUD dismiss];
            weakSelf.model = model.data;
            NSLog(@"checkinList = %@",weakSelf.model);
            
            
          
            
          
            
            
            
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
