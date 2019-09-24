//
//  UGAgentRefusedViewController.m
//  ug
//
//  Created by ug on 2019/9/24.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGAgentRefusedViewController.h"
#import "UGagentApplyInfo.h"
#import "UGAgentViewController.h"
@interface UGAgentRefusedViewController ()<UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *qqTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextView;
@property (weak, nonatomic) IBOutlet UITextView *whyTextView;
@property (weak, nonatomic) IBOutlet UITextView *refusedTextView;
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@end

@implementation UGAgentRefusedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title  = @"代理申请";
    self.extendedLayoutIncludesOpaqueBars = YES;
    _qqTextField.delegate = self;
    _phoneTextView.delegate = self;
    _userTextField.delegate = self;
     [self.whyTextView setEditable:NO];
     [self.refusedTextView setEditable:NO];
    
    if (_item) {

            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                //需要在主线程执行的代码
                // 需要在主线程执行的代码
                self.qqTextField.text = self->_item.qq;
                self.phoneTextView.text = self->_item.mobile;
                self.userTextField.text = self->_item.username;
                self.whyTextView.text = self->_item.applyReason;
                self.refusedTextView.text = self->_item.reviewResult;
                
                self.qqTextField.text = @"111";
                self.phoneTextView.text = @"123123";
                self.userTextField.text = @"weqrqwer";
                self.whyTextView.text = @"wqwerqwerqwerqwerqwerqwerqwerqwerqwrqwerqwerwqwerqwerqwerqwerqwerqwerqwerqwerqwrqwerqwerwqwerqwerqwerqwerqwerqwerqwerqwerqwrqwerqwerwqwerqwerqwerqwerqwerqwerqwerqwerqwrqwerqwerwqwerqwerqwerqwerqwerqwerqwerqwerqwrqwerqwerwqwerqwerqwerqwerqwerqwerqwerqwerqwrqwerqwerwqwerqwerqwerqwerqwerqwerqwerqwerqwrqwerqwerwqwerqwerqwerqwerqwerqwerqwerqwerqwrqwerqwerwqwerqwerqwerqwerqwerqwerqwerqwerqwrqwerqwerwqwerqwerqwerqwerqwerqwerqwerqwerqwrqwerqwerwqwerqwerqwerqwerqwerqwerqwerqwerqwrqwerqwerwqwerqwerqwerqwerqwerqwerqwerqwerqwrqwerqwerwqwerqwerqwerqwerqwerqwerqwerqwerqwrqwerqwerwqwerqwerqwerqwerqwerqwerqwerqwerqwrqwerqwerwqwerqwerqwerqwerqwerqwerqwerqwerqwrqwerqwerwqwerqwerqwerqwerqwerqwerqwerqwerqwrqwerqwerwqwerqwerqwerqwerqwerqwerqwerqwerqwrqwerqwerwqwerqwerqwerqwerqwerqwerqwerqwerqwrqwerqwerwqwerqwerqwerqwerqwerqwerqwerqwerqwrqwerqwerwqwerqwerqwerqwerqwerqwerqwerqwerqwrqwerqwerwqwerqwerqwerqwerqwerqwerqwerqwerqwrqwerqwerwqwerqwerqwerqwerqwerqwerqwerqwerqwrqwerqwerwqwerqwerqwerqwerqwerqwerqwerqwerqwrqwerqwerwqwerqwerqwerqwerqwerqwerqwerqwerqwrqwerqwerwqwerqwerqwerqwerqwerqwerqwerqwerqwrqwerqwerwqwerqwerqwerqwerqwerqwerqwerqwerqwrqwerqwerwqwerqwerqwerqwerqwerqwerqwerqwerqwrqwerqwer";
                self.refusedTextView.text = @"2222wqwerqwerqwerqwerqwerqwerqwerqwerqwrqwerqwerwqwerqwerqwerqwerqwerqwerqwerqwerqwrqwerqwerwqwerqwerqwerqwerqwerqwerqwerqwerqwrqwerqwerwqwerqwerqwerqwerqwerqwerqwerqwerqwrqwerqwerwqwerqwerqwerqwerqwerqwerqwerqwerqwrqwerqwerwqwerqwerqwerqwerqwerqwerqwerqwerqwrqwerqwerwqwerqwerqwerqwerqwerqwerqwerqwerqwrqwerqwerwqwerqwerqwerqwerqwerqwerqwerqwerqwrqwerqwerwqwerqwerqwerqwerqwerqwerqwerqwerqwrqwerqwerwqwerqwerqwerqwerqwerqwerqwerqwerqwrqwerqwerwqwerqwerqwerqwerqwerqwerqwerqwerqwrqwerqwerwqwerqwerqwerqwerqwerqwerqwerqwerqwrqwerqwerwqwerqwerqwerqwerqwerqwerqwerqwerqwrqwerqwerwqwerqwerqwerqwerqwerqwerqwerqwerqwrqwerqwerwqwerqwerqwerqwerqwerqwerqwerqwerqwrqwerqwerwqwerqwerqwerqwerqwerqwerqwerqwerqwrqwerqwerwqwerqwerqwerqwerqwerqwerqwerqwerqwrqwerqwerwqwerqwerqwerqwerqwerqwerqwerqwerqwrqwerqwerwqwerqwerqwerqwerqwerqwerqwerqwerqwrqwerqwerwqwerqwerqwerqwerqwerqwerqwerqwerqwrqwerqwerwqwerqwerqwerqwerqwerqwerqwerqwerqwrqwerqwerwqwerqwerqwerqwerqwerqwerqwerqwerqwrqwerqwerwqwerqwerqwerqwerqwerqwerqwerqwerqwrqwerqwerwqwerqwerqwerqwerqwerqwerqwerqwerqwrqwerqwerwqwerqwerqwerqwerqwerqwerqwerqwerqwrqwerqwerwqwerqwerqwerqwerqwerqwerqwerqwerqwrqwerqwerwqwerqwerqwerqwerqwerqwerqwerqwerqwrqwerqwer";
                
            }];
            
            
            
    }
    
}

- (void)setItem:(UGagentApplyInfo *)item {
    _item = item;
    
    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

        return NO;
 
}
- (IBAction)buttonClicked:(id)sender {
    
    UGAgentViewController *incomeVC = [[UGAgentViewController alloc] init];
    incomeVC.fromVC = @"UGAgentRefusedViewController";
    [self.navigationController pushViewController:incomeVC animated:YES];
}

@end
