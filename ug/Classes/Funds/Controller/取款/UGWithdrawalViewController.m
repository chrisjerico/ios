//
//  UGWithdrawalViewController.m
//  ug
//
//  Created by ug on 2019/5/3.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGWithdrawalViewController.h"
#import "UGSetupPayPwdController.h"
#import "UGBindCardViewController.h"
#import "UGCardInfoModel.h"
#import "UGEncryptUtil.h"
#import "UGSystemConfigModel.h"
@interface UGWithdrawalViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIView *bandCardView;
@property (weak, nonatomic) IBOutlet UILabel *bandCardTitleLabel;/**<   您还没有绑定银行卡*/
@property (weak, nonatomic) IBOutlet UIButton *bandCardButton;/**<  绑定银行卡*/


@property (weak, nonatomic) IBOutlet UIView *withdrawalView;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@property (weak, nonatomic) IBOutlet UITextField *amountTextF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextF;
@property (weak, nonatomic) IBOutlet UILabel *cardInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *limitLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;   /**<   当前到账银行卡*/




@end

@implementation UGWithdrawalViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UGUserModel *user = [UGUserModel currentUser];
    if (!user.hasBankCard) {
        self.bandCardView.frame = CGRectMake(0, 0, APP.Width, self.withdrawalView.height);
        self.bandCardView.backgroundColor = Skin1.CLBgColor;
        self.bandCardTitleLabel.textColor = Skin1.textColor1;
        
        if ([@"c153" containsString:APP.SiteId]) {
            self.bandCardTitleLabel.text = @"您还没提现银行卡号";
            [self.bandCardButton setTitle:@"提现银行卡" forState:0];
        } else {
            self.bandCardTitleLabel.text = @"您还没有绑定银行卡";
            [self.bandCardButton setTitle:@"绑定银行卡" forState:0];
        }
        [self.view addSubview:self.bandCardView];
    }
    
    if (user.hasBankCard) {
        UGSystemConfigModel *config = [UGSystemConfigModel currentConfig];
        self.limitLabel.text = [NSString stringWithFormat:@"单笔下限%@，上限%@",[config.minWithdrawMoney removeFloatAllZero],[config.maxWithdrawMoney removeFloatAllZero]];
        UGCardInfoModel *card = [UGCardInfoModel currentBankCardInfo];
        if (card) {
            self.cardInfoLabel.text = [NSString stringWithFormat:@"%@,尾号%@，%@",card.bankName,[card.bankCard substringFromIndex:card.bankCard.length - 4],card.ownerName];

        }else {
            [self getCardInfo];
        }
//        （IOS）判断一个view是否为另一个view的子视图
        // 如果myView是self.view本身，也会返回yes
        BOOL isSubView = [self.bandCardView isDescendantOfView:self.view];
        if (isSubView) {
            [self.bandCardView removeFromSuperview];
        }
         
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = Skin1.textColor4;
    [self.limitLabel setTextColor:Skin1.textColor1];
    [self.titleLabel setTextColor:Skin1.textColor1];
    [self.amountTextF setTextColor:Skin1.textColor1];
    [self.cardInfoLabel setTextColor:Skin1.textColor3];
    [self.pwdTextF setTextColor:Skin1.textColor1];
    self.amountTextF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_amountTextF.placeholder attributes:@{NSForegroundColorAttributeName:Skin1.textColor3}];
    self.pwdTextF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_pwdTextF.placeholder attributes:@{NSForegroundColorAttributeName:Skin1.textColor3}];
    
    
    self.commitButton.layer.cornerRadius = 3;
    self.commitButton.layer.masksToBounds = YES;
    [self.commitButton setBackgroundColor:Skin1.navBarBgColor];
    
    self.bandCardButton.layer.cornerRadius = 3;
    self.bandCardButton.layer.masksToBounds = YES;
    [self.bandCardButton setBackgroundColor:Skin1.navBarBgColor];
    self.amountTextF.delegate = self;
    self.pwdTextF.delegate = self;
    
    SANotificationEventSubscribe(UGNotificationFundTitlesTap, self, ^(typeof (self) self, id obj) {
        [self.view endEditing:YES];
        self.amountTextF.text = nil;
        self.pwdTextF.text = nil;
    });
    
}

- (void)getCardInfo {
    
    [SVProgressHUD showWithStatus:nil];
    WeakSelf;
    [CMNetwork getBankCardInfoWithParams:@{@"token":[UGUserModel currentUser].sessid} completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            [SVProgressHUD showSuccessWithStatus:model.msg];
            [UGCardInfoModel setCurrentBankCardInfo:model.data];
            UGCardInfoModel *card = model.data;
            weakSelf.cardInfoLabel.text = [NSString stringWithFormat:@"%@,尾号%@，%@",card.bankName,[card.bankCard substringFromIndex:card.bankCard.length - 4],card.ownerName];
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }];
}

- (IBAction)bandCardClick:(id)sender {
    UGUserModel *user = [UGUserModel currentUser];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGBindCardViewController" bundle:nil];
    if (user.hasFundPwd) {
        
        UGBindCardViewController *bankCardVC = [storyboard instantiateViewControllerWithIdentifier:@"UGBindCardViewController"];
        [self.navigationController pushViewController:bankCardVC animated:YES];
    }else {
        UGSetupPayPwdController *fundVC = [storyboard instantiateViewControllerWithIdentifier:@"UGSetupPayPwdController"];
        [self.navigationController pushViewController:fundVC animated:YES];
    }
}

- (IBAction)withdrawalClick:(id)sender {
    WeakSelf;
    ck_parameters(^{
        ck_parameter_non_empty(weakSelf.amountTextF.text, @"请输入取款金额");
        ck_parameter_non_empty(weakSelf.pwdTextF.text, @"请输入取款密码");
    }, ^(id err) {
        [SVProgressHUD showInfoWithStatus:err];
    }, ^{
        [self.view endEditing:YES];
        
        UGSystemConfigModel *config = [UGSystemConfigModel currentConfig];
        if (weakSelf.amountTextF.text.floatValue < config.minWithdrawMoney.floatValue ||
            weakSelf.amountTextF.text.floatValue > config.maxWithdrawMoney.floatValue) {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"单笔取款金额范围：%@-%@",[config.minWithdrawMoney removeFloatAllZero],[config.maxWithdrawMoney removeFloatAllZero]]];
            return ;
        }
        [SVProgressHUD showWithStatus:nil];
        if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
            return;
        }
        NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                                 @"money":self.amountTextF.text,
                                 @"pwd":[UGEncryptUtil md5:self.pwdTextF.text]
                                 };
        [CMNetwork withdrawApplytWithParams:params completion:^(CMResult<id> *model, NSError *err) {
            [CMResult processWithResult:model success:^{
                [SVProgressHUD showSuccessWithStatus:model.msg];
                weakSelf.amountTextF.text = nil;
                weakSelf.pwdTextF.text = nil;
                //发送通知给取款记录
                SANotificationEventPost(UGNotificationWithdrawalsSuccess, nil);
                
                if (weakSelf.withdrawSuccessBlock) {
                    weakSelf.withdrawSuccessBlock();
                }
            } failure:^(id msg) {
                [SVProgressHUD showErrorWithStatus:msg];
            }];
        }];
    });
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [self.amountTextF resignFirstResponder];
        [self.pwdTextF resignFirstResponder];
        return NO;
    }
    
    return YES;
}

@end
