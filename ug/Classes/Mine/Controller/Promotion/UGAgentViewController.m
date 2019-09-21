//
//  UGAgentViewController.m
//  ug
//
//  Created by ug on 2019/9/15.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGAgentViewController.h"
#import "UITextView+Extension.h"

@interface UGAgentViewController ()
@property (weak, nonatomic) IBOutlet UITextField *qqTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextView;
@property (weak, nonatomic) IBOutlet UITextView *remarkTextView;

@end

@implementation UGAgentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title  = @"代理申请";
     [_remarkTextView setPlaceholderWithText:@"申请理由(6-30个字符必填项)" Color:[UIColor grayColor]];
    _remarkTextView.layer.borderColor = [UIColor grayColor].CGColor;//边框颜色
    _remarkTextView.layer.borderWidth = 1;//边框宽度
    
}


- (IBAction)buttonClicked:(id)sender {
    
    NSString *qqStr = [_qqTextField.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    NSString *phoneStr = [_phoneTextView.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *remarkStr = [_remarkTextView.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    

    
    BOOL isOk = [CMCommon stringIsNull:phoneStr ];
    
     BOOL isOk2 = [CMCommon stringIsNull:qqStr ];
    
    if (![CMCommon stringIsNull:qqStr ] || ![CMCommon stringIsNull:phoneStr ] ) {
       
    }
    else{
        [self.view makeToast:@"QQ号和手机号必须填一个"];
        return;
    }
    if (remarkStr.length<6 ||  remarkStr.length>30) {
        [self.view makeToast:@"申请理由大于6 小于30"];
        return;
    }
    
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"action":@"apply",
                             @"qq":qqStr,
                             @"phone":phoneStr,
                             @"content":remarkStr
                             };
    
    [SVProgressHUD showWithStatus:nil];
    //    WeakSelf;
    [CMNetwork teamAgentApplyWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            [SVProgressHUD showSuccessWithStatus:model.msg];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(id msg) {
            
            [SVProgressHUD showErrorWithStatus:msg];
            
        }];
    }];
    
}

@end
