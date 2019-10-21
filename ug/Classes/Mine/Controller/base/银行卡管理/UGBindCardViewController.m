//
//  UGBankCardViewController.m
//  ug
//
//  Created by ug on 2019/5/9.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGBindCardViewController.h"
#import "YBPopupMenu.h"
#import "UGbankModel.h"

@interface UGBindCardViewController ()<YBPopupMenuDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *bankTypeTextF;
@property (weak, nonatomic) IBOutlet UITextField *bankAddressTextF;
@property (weak, nonatomic) IBOutlet UITextField *cardNumberTextF;
@property (weak, nonatomic) IBOutlet UITextField *nameTextF;
@property (weak, nonatomic) IBOutlet UIButton *bankTypeButton;
@property (weak, nonatomic) IBOutlet UIImageView *bankTypeArrow;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (nonatomic, strong) NSArray *bankListArray;
@property (nonatomic, strong) NSMutableArray *titlesArray;
@property (nonatomic, assign) NSInteger selIndex;


@end

@implementation UGBindCardViewController

- (void)skin {
    [self.submitButton setBackgroundColor:UGNavColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"银行卡管理";
    SANotificationEventSubscribe(UGNotificationWithSkinSuccess, self, ^(typeof (self) self, id obj) {
        [self skin];
    });
    self.submitButton.layer.cornerRadius = 3;
    self.submitButton.layer.masksToBounds = YES;
    [self.submitButton setBackgroundColor:UGNavColor];
    self.selIndex = -1;
    self.bankAddressTextF.delegate = self;
    self.cardNumberTextF.delegate = self;
    self.nameTextF.delegate = self;
    
    {
        // 若注册时填了真实姓名，则自动填充且不允许用户自己输入姓名
        _nameTextF.text = UserI.fullName;
        _nameTextF.userInteractionEnabled = ![UserI.fullName stringByReplacingOccurrencesOfString:@" " withString:@""].length;
    }
    
    [self getBankList];
}

- (void)getBankList {
    [SVProgressHUD showWithStatus:@"获取银行列表..."];
    [CMNetwork getBankListWithParams:@{@"status":@"0"} completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            [SVProgressHUD showSuccessWithStatus:model.msg];
            self.bankListArray = model.data;
            for (UGbankModel *bank in self.bankListArray) {
                [self.titlesArray addObject:bank.name];
            }
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
            
        }];
    }];
    
}

- (IBAction)showBankList:(id)sender {
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI);
    self.bankTypeArrow.transform = transform;
    YBPopupMenu *popView = [[YBPopupMenu alloc] initWithTitles:self.titlesArray icons:nil menuWidth:CGSizeMake(self.bankTypeButton.width / 3 * 2, 300) delegate:self];
    popView.fontSize = 14;
    popView.type = YBPopupMenuTypeDefault;
    [popView showRelyOnView:self.bankTypeButton];
    
}

- (IBAction)submit:(id)sender {
    NSLog(@"go");
    ck_parameters(^{
        ck_parameter_non_empty(self.bankTypeTextF.text, @"请选择开户银行");
        ck_parameter_non_empty(self.bankAddressTextF.text, @"请输入开户行地址");
        ck_parameter_non_empty(self.cardNumberTextF.text, @"请输入银行卡号");
        ck_parameter_more_length(self.cardNumberTextF.text, @"19", @"请输入6到19位数的银行卡号");
        ck_parameter_less_length(self.cardNumberTextF.text, @"6", @"请输入6到19位数的银行卡号");
        ck_parameter_non_empty(self.nameTextF.text, @"请输入持卡人姓名");
    }, ^(id err) {
        [SVProgressHUD showInfoWithStatus:err];
    }, ^{
        UGbankModel *bank = self.bankListArray[self.selIndex];
        NSDictionary *params = @{@"bank_id":bank.bankId,
                                 @"bank_addr":self.bankAddressTextF.text,
                                 @"bank_card":self.cardNumberTextF.text,
                                 @"owner_name":self.nameTextF.text,
                                 @"token":[UGUserModel currentUser].sessid
                                 };
        [SVProgressHUD showWithStatus:nil];
        [CMNetwork bindCardWithParams:params completion:^(CMResult<id> *model, NSError *err) {
            [CMResult processWithResult:model success:^{
                [SVProgressHUD showSuccessWithStatus:model.msg];
                [UGUserModel currentUser].hasBankCard = YES;
                [self.navigationController popToRootViewControllerAnimated:YES];
            } failure:^(id msg) {
                [SVProgressHUD showErrorWithStatus:msg];
                
            }];
        }];
        
    });
    
}

#pragma mard - YBPopupMenuDelegate

- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu {
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI * 2);
    self.bankTypeArrow.transform = transform;
    if (index >= 0) {
        self.bankTypeTextF.text = self.titlesArray[index];
        self.selIndex = index;
        
    }
}

- (NSMutableArray *)titlesArray {
    if (_titlesArray == nil) {
        _titlesArray = [NSMutableArray array];
    }
    return _titlesArray;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [self.view endEditing:YES];
        return NO;
    }
    
    if (textField == self.cardNumberTextF) {
        
        if (textField.text.length + string.length - range.length > 19) {
            return NO;
        }
    }else if (textField == self.nameTextF) {
        if (textField.text.length + string.length - range.length > 10) {
            return NO;
        }
        
    }else {
        if (textField.text.length + string.length - range.length > 30) {
            return NO;
        }
    }
    
    return YES;
}

@end
