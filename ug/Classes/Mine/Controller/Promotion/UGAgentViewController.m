//
//  UGAgentViewController.m
//  ug
//
//  Created by ug on 2019/9/15.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGAgentViewController.h"
#import "UITextView+Extension.h"
#import "UGagentApplyInfo.h"

@interface UGAgentViewController ()<UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *qqTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextView;
@property (weak, nonatomic) IBOutlet UITextView *remarkTextView;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UIButton *okButton;

@end

@implementation UGAgentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title  = @"代理申请";

    
    self.extendedLayoutIncludesOpaqueBars = YES;
    
     [_remarkTextView setPlaceholderWithText:@"申请理由(6-30个字符必填项)" Color:[UIColor grayColor]];
    _remarkTextView.layer.borderColor = [UIColor grayColor].CGColor;//边框颜色
    _remarkTextView.layer.borderWidth = 1;//边框宽度
    _qqTextField.delegate = self;
    _phoneTextView.delegate = self;
    _qqTextField.delegate = self;
    
    
    if ([self.fromVC  isEqualToString:@"UGAgentRefusedViewController"]) {
        UIImage *sureImage = [UIImage imageNamed:@"back_icon"];
        UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        float width = 10.0;
        if (sureImage.size.width<width) {
            sureButton.bounds = CGRectMake(0 , 0, width, sureImage.size.height );
            UIEdgeInsets e = UIEdgeInsetsMake(0, sureImage.size.width-width, 0, 0);// CGFloat top, left, bottom, right;
            [sureButton setImageEdgeInsets:e];
        }
        else if (sureImage.size.width >30.0){
            
            //压缩图片大小
            sureImage = [CMCommon imageWithImage:sureImage scaledToSize:CGSizeMake(20, 20)];
            sureButton.contentEdgeInsets =UIEdgeInsetsMake(0, -25, 0, 0);
            [sureButton setImage:sureImage forState:UIControlStateNormal];
            sureButton.frame = CGRectMake(0, 0, 60, 30);
        }
        else{
            sureButton.bounds = CGRectMake( 0, 0, sureImage.size.width, sureImage.size.height );
        }
        
        [sureButton setImage:sureImage forState:UIControlStateNormal];
        
        [sureButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *sureButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sureButton];
        self.navigationItem.leftBarButtonItem = sureButtonItem;
    }
    
    
    if (_item) {
        NSNumber *numberStatus = _item.reviewStatus;
     
        int intStatus = [numberStatus intValue];
        if (intStatus == 1) {
            [self.tagLabel setHidden:NO];
            [self.remarkTextView setEditable:NO];
            [self.tagLabel setHidden:NO];
            self.okButton.userInteractionEnabled=NO;//交互关闭
            self.okButton.alpha=0.4;//透明度

            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                //需要在主线程执行的代码
                // 需要在主线程执行的代码
                self.qqTextField.text = self->_item.qq;
                self.phoneTextView.text = self->_item.mobile;
                self.remarkTextView.text = self->_item.applyReason;
            }];
  
            
            
        }
        else if (intStatus == 0){
            [self.tagLabel setHidden:YES];
            [self.remarkTextView setEditable:YES];
            self.okButton.userInteractionEnabled=YES;//交互关闭
            self.okButton.alpha=1.0;//透明度
        }
        
    }
    else{
        [self.tagLabel setHidden:YES];
        [self.remarkTextView setEditable:YES];
        self.okButton.userInteractionEnabled=YES;//交互关闭
        self.okButton.alpha=1.0;//透明度
    }
}



- (void)setItem:(UGagentApplyInfo *)item {
    _item = item;
  

}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (_item) {
        NSNumber *numberStatus = self.item.reviewStatus;
        int intStatus = [numberStatus intValue];
        if (intStatus == 1) {
            return NO;
        } else {
            return YES;
        }
    } else {
        return YES;
    }
   

    

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
            
            if ([self.fromVC  isEqualToString:@"UGAgentRefusedViewController"]) {
                [self back];
            }
            else{
                 [self.navigationController popViewControllerAnimated:YES];
            }
           
        } failure:^(id msg) {
            
            [SVProgressHUD showErrorWithStatus:msg];
            
        }];
    }];
    
}

-(void)back
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
