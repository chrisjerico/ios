//
//  UGWriteMessageViewController.m
//  ug
//
//  Created by ug on 2019/5/6.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGWriteMessageViewController.h"
#import "YBPopupMenu.h"

@interface UGWriteMessageViewController ()<UITextViewDelegate,YBPopupMenuDelegate>

@property (strong, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIView *bg2View;
@property (weak, nonatomic) IBOutlet UILabel *messageTypeLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (nonatomic, strong) NSArray <NSString *> *typeArray;

@end

@implementation UGWriteMessageViewController
-(void)skin{
    
      [self.submitButton setBackgroundColor:Skin1.navBarBgColor];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contentTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.contentTextView.layer.borderWidth = 0.8;
    self.contentTextView.delegate = self;
    [self.bgView setBackgroundColor: Skin1.textColor4];
    [self.bg2View setBackgroundColor: Skin1.textColor4];
    [_messageTypeLabel setTextColor:Skin1.textColor1];
    [_contentTextView setTextColor:Skin1.textColor1];
    [_numberLabel setTextColor:Skin1.textColor3];
    [_placeholderLabel setTextColor:Skin1.textColor3];
    
    
    SANotificationEventSubscribe(UGNotificationWithSkinSuccess, self, ^(typeof (self) self, id obj) {
        
        [self skin];
    });    self.submitButton.layer.cornerRadius = 3;
    self.submitButton.layer.masksToBounds = YES;
    [self.submitButton setBackgroundColor:Skin1.navBarBgColor];
    self.typeArray = @[@"反馈类型：提交建议",@"反馈类型：我要投诉"];
    self.messageTypeLabel.text = self.typeArray[self.feedType];
}

- (IBAction)submitClick:(id)sender {
 
    ck_parameters(^{
        ck_parameter_non_empty(self.contentTextView.text, @"请输入内容");
    }, ^(id err) {
        [SVProgressHUD showInfoWithStatus:err];
    }, ^{
        if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
            return;
        }
        NSDictionary *params = @{@"pid":@"",
                                 @"token":[UGUserModel currentUser].sessid,
                                 @"type":@(self.feedType),
                                 @"content":self.contentTextView.text
                                 };
        [SVProgressHUD showWithStatus:nil];
        WeakSelf;
        [CMNetwork writeMessageWithParams:params completion:^(CMResult<id> *model, NSError *err) {
            [CMResult processWithResult:model success:^{
                [SVProgressHUD showSuccessWithStatus:model.msg];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            } failure:^(id msg) {
                [SVProgressHUD showErrorWithStatus:msg];
            }];
        }];
    });
    
}

#pragma mark - text view delegate
- (void)textViewDidChange:(UITextView *)textView
{
    self.placeholderLabel.hidden = self.contentTextView.text.length;
    if ([textView.text length] > 200) {
        textView.text = [textView.text substringWithRange:NSMakeRange(0, 200)];
        [textView.undoManager removeAllActions];
        return;
    }
    NSInteger wordCount = textView.text.length;
    self.numberLabel.text = [NSString stringWithFormat:@"%ld/200",(long)wordCount];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
