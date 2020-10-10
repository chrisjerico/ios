//
//  UGWithdrawalVC.m
//  UGBWApp
//
//  Created by fish on 2020/10/7.
//  Copyright © 2020 ug. All rights reserved.
//

#import "UGWithdrawalVC.h"
#import "UGYubaoConversionViewController.h"
#import "WithdrawalAcctModel.h"
#import "UGbankModel.h"
#import "YBPopupMenu.h"

@interface UGWithdrawalVC ()
@property (weak, nonatomic) IBOutlet UIView *tipsView1; /**<   您还未绑定提款账户 */
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;/**<   虚拟币汇率Label */

@property (nonatomic, strong) NSMutableArray <WithdrawalAcctModel *>*wams;
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) WithdrawalAcctModel *selectedWam;
@end

@implementation UGWithdrawalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _wams = @[].mutableCopy;
    _titles = @[].mutableCopy;
    
    FastSubViewCode(self.view);
    subLabel(@"金额上下限Label").text = [NSString stringWithFormat:@"单笔下限%@，上限%@",[SysConf.minWithdrawMoney removeFloatAllZero],[SysConf.maxWithdrawMoney removeFloatAllZero]];
    subButton(@"提交Button").backgroundColor = Skin1.navBarBgColor;
    subLabel(@"虚拟币汇率Label").hidden = true;
    
    if (Skin1.isBlack) {
        self.view.backgroundColor = Skin1.bgColor;
        _tipsView1.backgroundColor = Skin1.bgColor;
        subTextField(@"取款金额TextField").textColor = Skin1.textColor1;
        subTextField(@"取款密码TextField").textColor = Skin1.textColor1;
        subTextField(@"取款金额TextField").placeholderColor = Skin1.textColor3;
        subTextField(@"取款密码TextField").placeholderColor = Skin1.textColor3;
        subLabel(@"未绑定提示Label").textColor = Skin1.textColor1;
        subLabel(@"金额上下限Label").textColor = Skin1.textColor1;
        subButton(@"提款账号Button").backgroundColor = Skin1.bgColor;
        [subButton(@"提款账号Button") setTitleColor:Skin1.textColor1 forState:UIControlStateNormal];
    }
    
    NSMutableArray <UGbankModel *>*virtualList = @[].mutableCopy;
    [NetworkManager1 system_bankList:UGWithdrawalTypeVirtual].completionBlock = ^(CCSessionModel *sm) {
        sm.noShowErrorHUD = true;
        if (!sm.error) {
            for (NSDictionary *dict in sm.responseObject[@"data"]) {
                [virtualList addObject:[UGbankModel mj_objectWithKeyValues:dict]];
            }
        }
    };
    
    __weakSelf_(__self);
    [self xw_addNotificationForName:UITextFieldTextDidChangeNotification block:^(NSNotification * _Nonnull noti) {
        CGFloat rate = 0;
        for (UGbankModel *bm in virtualList) {
            if ([bm.bankId isEqualToString:__self.selectedWam.bankId])
                rate = bm.currencyRate.doubleValue;
        }
        CGFloat amount = subTextField(@"取款金额TextField").text.doubleValue;
        subLabel(@"虚拟币汇率Label").hidden = !(__self.selectedWam.type == UGWithdrawalTypeVirtual && rate > 0.0001);
        subLabel(@"虚拟币汇率Label").text = _NSString(@"=%@ USDT　　1 USDT = %@ CNY", [AppDefine stringWithFloat:rate * amount decimal:8], [AppDefine stringWithFloat:1/rate decimal:4]);
    }];
    
    [NetworkManager1 user_bankCard:UGWithdrawalTypeAll].completionBlock = ^(CCSessionModel *sm) {
        if (!sm.error) {
            [__self.wams removeAllObjects];
            for (NSDictionary *dict in sm.responseObject[@"data"]) {
                if ([dict[@"data"] allKeys].count)
                [__self.wams addObject:[WithdrawalAcctModel mj_objectWithKeyValues:dict]];
            }
            __self.tipsView1.hidden = __self.wams.count;
            
        } else {
            __self.tipsView1.hidden = UserI.hasBankCard;
        }
    };
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    __weakSelf_(__self);
    [NetworkManager1 user_bankCard:UGWithdrawalTypeAll].completionBlock = ^(CCSessionModel *sm) {
        if (!sm.error) {
            [__self.wams removeAllObjects];
            for (NSDictionary *dict in sm.responseObject[@"data"]) {
                if ([dict[@"data"] allKeys].count)
                [__self.wams addObject:[WithdrawalAcctModel mj_objectWithKeyValues:dict]];
            }
            __self.tipsView1.hidden = __self.wams.count;
            
        } else {
            __self.tipsView1.hidden = UserI.hasBankCard;
        }
    };
}

#pragma mark - IBAction

// 添加提款账号
- (IBAction)onAddWithdrawalAcctBtnClick:(UIButton *)sender {
    [NavController1 pushViewController:_LoadVC_from_storyboard_(@"WithdrawalAccountListVC") animated:true];
}

// 去利息宝
- (IBAction)onYubaoBtnClick:(UIButton *)sender {
    [SVProgressHUD show];
    [CMNetwork getYuebaoInfoWithParams:@{@"token":[UGUserModel currentUser].sessid} completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            UGYubaoConversionViewController *vc = _LoadVC_from_storyboard_(@"UGYubaoConversionViewController");
            vc.infoModel = model.data;
            [NavController1 pushViewController:vc animated:YES];
        } failure:^(id msg) {
            [SVProgressHUD dismiss];
        }];
        [SVProgressHUD dismiss];
    }];
}

// 选择提款账号
- (IBAction)onSelectAcctBtnClick:(UIButton *)sender {
    [_titles removeAllObjects];
    for (WithdrawalAcctModel *wam in _wams) {
        NSString *title = nil;
        switch (wam.type) {
            case UGWithdrawalTypeBankCard:
                title = _NSString(@"%@（%@，尾号%@，%@）", wam.name, wam.bankName, [wam.account substringFromIndex:wam.account.length-4], wam.username);
                break;
            case UGWithdrawalTypeVirtual:
//                NSString *acct = [NSString stringWithFormat:@"%@*****%@", [wam.account substringToIndex:3]];
                title = _NSString(@"%@（%@，%@，%@）", wam.name, wam.account, wam.countname, wam.username);
                break;
            case UGWithdrawalTypeAlipay:
            case UGWithdrawalTypeWeChat:
            default:
                title = _NSString(@"%@（%@，%@）", wam.name, wam.account, wam.username);
                break;
        }
        [_titles addObject:title];
    }
    YBPopupMenu *popView = [[YBPopupMenu alloc] initWithTitles:_titles icons:nil menuWidth:CGSizeMake(300, 150) delegate:self];
    popView.fontSize = 15;
    popView.type = YBPopupMenuTypeDefault;
    [popView showRelyOnView:sender];
}

// 申请提款
- (IBAction)onSubmitBtnClick:(UIButton *)sender {
    FastSubViewCode(self.view);
    NSString *amount = subTextField(@"取款金额TextField").text.stringByTrim;
    NSString *pwd = subTextField(@"取款密码TextField").text.stringByTrim;
    
    if (!amount.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入取款金额"];
        return;
    }
    if (!pwd.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入取款密码"];
        return;
    }
    
    UGSystemConfigModel *config = [UGSystemConfigModel currentConfig];
    if (amount.floatValue < config.minWithdrawMoney.floatValue ||
        amount.floatValue > config.maxWithdrawMoney.floatValue) {
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"单笔取款金额范围：%@-%@",[config.minWithdrawMoney removeFloatAllZero],[config.maxWithdrawMoney removeFloatAllZero]]];
        return ;
    }
    
    [self.view endEditing:YES];
    
    
    
    __weakSelf_(__self);
    [SVProgressHUD showWithStatus:nil];
    [NetworkManager1 withdraw_apply:_selectedWam.type amount:amount pwd:pwd].completionBlock = ^(CCSessionModel *sm) {
        if (!sm.error) {
            [SVProgressHUD showSuccessWithStatus:sm.responseObject[@"msg"]];
            subTextField(@"取款金额TextField").text = nil;
            subTextField(@"取款密码TextField").text = nil;
            
            //发送通知给取款记录
            SANotificationEventPost(UGNotificationWithdrawalsSuccess, nil);
            if (__self.withdrawSuccessBlock) {
                __self.withdrawSuccessBlock();
            }
        }
    };
}


#pragma mark - YBPopupMenuDelegate

- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu {
    if (index < 0) return;
    FastSubViewCode(self.view);
    [subButton(@"提款账号Button") setTitle:_titles[index] forState:UIControlStateNormal];
    _selectedWam = _wams[index];
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:nil];
}

@end
