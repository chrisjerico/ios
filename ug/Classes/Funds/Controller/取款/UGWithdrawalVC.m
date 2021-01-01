//
//  UGWithdrawalVC.m
//  UGBWApp
//
//  Created by fish on 2020/10/7.
//  Copyright © 2020 ug. All rights reserved.
//

#import "UGWithdrawalVC.h"
#import "UGYubaoConversionViewController.h"
#import "BindWithdrawalAccountVC.H"

#import "WithdrawalAcctModel.h"
#import "UGbankModel.h"

#import "YBPopupMenu.h"

@interface UGWithdrawalVC ()<YBPopupMenuDelegate>
@property (weak, nonatomic) IBOutlet UIView *tipsView1; /**<   您还未绑定提款账户 */
@property (weak, nonatomic) IBOutlet UIView *bindAcctView;/**<   绑定提款账户View */

@property (nonatomic, strong) NSMutableArray *acctList; /**<   账户列表（元素可能是WithdrawalAcctModel、WithdrawalTypeModel，要判断元素类型） */
@property (nonatomic, strong) NSMutableArray *titles;   /**<   标题列表 */
@property (nonatomic, strong) NSMutableArray <UGbankModel *>*sysBankList;      /**<   提款渠道列表，只用到里面的虚拟币汇率 */
@property (nonatomic, strong) WithdrawalAcctModel *selectedWam; /**<   选中的账户 */
@property (nonatomic, strong) WithdrawalTypeModel *selectedWtm; /**<   选中的账户 */
@property (nonatomic, strong) NSString *virtualAmount;          /**<   虚拟币金额 */
@property (nonatomic, strong) NSString *justBindAccount;       /**<   刚绑定的账号，绑定成功后优先显示 */
@end

@implementation UGWithdrawalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _acctList = @[].mutableCopy;
    _titles = @[].mutableCopy;
    _sysBankList = @[].mutableCopy;
    self.title = @"取款";
    
    FastSubViewCode(self.view);
    subLabel(@"金额上下限Label").text = [NSString stringWithFormat:@"单笔下限-，上限-"];
    subButton(@"提交Button").backgroundColor = Skin1.navBarBgColor;
    subButton(@"添加提款账户Button").backgroundColor = Skin1.navBarBgColor;
    subLabel(@"虚拟币汇率Label").hidden = true;
    subTextField(@"取款金额TextField").superview.hidden = true;
    subTextField(@"取款密码TextField").hidden = true;
    subButton(@"切换到利息宝取款Button").hidden = !UserI.yuebaoSwitch;
    _bindAcctView.hidden = true;
    // 虚线边框
    {
        CGRect rect = CGRectMake(0, 0, APP.Width-32, 64);
        CAShapeLayer *border = [CAShapeLayer layer];
        border.strokeColor = Skin1.textColor3.CGColor;
        border.fillColor = [UIColor clearColor].CGColor;
        border.path = [UIBezierPath bezierPathWithRect:rect].CGPath;
        border.frame = rect;
        border.lineWidth = 1.f;
        border.lineDashPattern = @[@4, @2];
        [_bindAcctView.layer addSublayer:border];
    }
    
    
    
    
    if (Skin1.isBlack) {
        self.view.backgroundColor = Skin1.bgColor;
        _tipsView1.backgroundColor = Skin1.bgColor;
        subTextField(@"取款金额TextField").textColor = Skin1.textColor1;
        subTextField(@"取款密码TextField").textColor = Skin1.textColor1;
        subTextField(@"取款金额TextField").placeholderColor = Skin1.textColor3;
        subTextField(@"取款密码TextField").placeholderColor = Skin1.textColor3;
        subLabel(@"未绑定提示Label").textColor = Skin1.textColor1;
        subLabel(@"金额上下限Label").textColor = Skin1.textColor1;
        subLabel(@"绑定账户Label").textColor = Skin1.textColor1;
        subButton(@"提款账号Button").backgroundColor = Skin1.bgColor;
        [subButton(@"提款账号Button") setTitleColor:Skin1.textColor1 forState:UIControlStateNormal];
    }
    
    __weakSelf_(__self);
    [self xw_addNotificationForName:UITextFieldTextDidChangeNotification block:^(NSNotification * _Nonnull noti) {
        CGFloat currencyRate = 0;
        CGFloat rateOffset = 0;
        for (UGbankModel *bm in __self.sysBankList) {
            if ([bm.bankId isEqualToString:__self.selectedWam.bankId]) {
                currencyRate = bm.currencyRate.doubleValue;
                rateOffset = bm.rate.doubleValue;
            }
        }
        currencyRate *= 1.0 + rateOffset / 100.0;
        CGFloat amount = subTextField(@"取款金额TextField").text.doubleValue;
        __self.virtualAmount = currencyRate > 0.000001 ? [AppDefine stringWithFloat:currencyRate * amount decimal:2] : nil;
        subLabel(@"虚拟币汇率Label").hidden = !(__self.selectedWam.type == UGWithdrawalTypeVirtual && __self.virtualAmount && amount > 0.01);
        subLabel(@"虚拟币汇率Label").text = _NSString(@"=%@ %@　　1 %@ = %@ CNY", __self.virtualAmount, __self.selectedWam.bankCode, __self.selectedWam.bankCode, [AppDefine stringWithFloat:1/currencyRate decimal:2]);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData];
}

- (void)reloadCurrencyRate:(void (^)(void))completion {
    __weakSelf_(__self);
    [NetworkManager1 system_bankList:UGWithdrawalTypeAll].completionBlock = ^(CCSessionModel *sm, id resObject, NSError *err) {
        sm.noShowErrorHUD = true;
        if (!sm.error) {
            [__self.sysBankList removeAllObjects];
            for (NSDictionary *dict in sm.resObject[@"data"]) {
                [__self.sysBankList addObject:[UGbankModel mj_objectWithKeyValues:dict]];
            }
            if (completion) {
                completion();
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:nil];
        }
    };
}

- (void)reloadData {
    __weakSelf_(__self);
    if (!_sysBankList.count) {
        [self reloadCurrencyRate:^{
            if (__self.sysBankList.count) {
                [__self reloadData];
            }
        }];
        return;
    }
    
    FastSubViewCode(self.view);
    [NetworkManager1 user_bankCard].completionBlock = ^(CCSessionModel *sm, id resObject, NSError *err) {
        sm.noShowErrorHUD = true;
        if (!sm.error || sm.resObject[@"data"][@"allAccountList"]) {
            NSMutableArray *wams = @[].mutableCopy;
            NSMutableArray *wtms = @[].mutableCopy;
            for (NSDictionary *dict in sm.resObject[@"data"][@"allAccountList"]) {
                WithdrawalTypeModel *wtm = [WithdrawalTypeModel mj_objectWithKeyValues:dict];
                if (!wtm.isshow) continue;
                for (WithdrawalAcctModel *wam in wtm.data) {
                    if (![__self.sysBankList containsValue:wam.bankId keyPath:@"bankId"]) continue;
                    wam.name = wtm.name;
                    wam.minWithdrawMoney = wtm.minWithdrawMoney;
                    wam.maxWithdrawMoney = wtm.maxWithdrawMoney;
                    [wams addObject:wam];
                }
                if (!wtm.data.count) {
                    [wtms addObject:wtm];
                }
            }
            __self.acctList = [wams arrayByAddingObjectsFromArray:wtms].mutableCopy;
            __self.tipsView1.hidden = false;
            for (WithdrawalTypeModel *wtm in __self.acctList) {
                if ([wtm isKindOfClass:[WithdrawalAcctModel class]]) {
                    __self.tipsView1.hidden = true;
                    break;
                }
            }
            
            if (__self.acctList.count) {
                [__self.titles removeAllObjects];
                for (WithdrawalAcctModel *wam in __self.acctList) {
                    if ([wam isKindOfClass:[WithdrawalTypeModel class]]) {
                        [__self.titles addObject:_NSString(@"%@（未绑定）", wam.name)];
                        continue;
                    }
                    NSString *title = nil;
                    switch (wam.type) {
                        case UGWithdrawalTypeBankCard:
                            title = _NSString(@"%@（%@，尾号%@，%@）", wam.name, wam.bankName, [wam.bankCard substringFromIndex:(int)wam.bankCard.length-4], wam.ownerName);
                            break;
                        case UGWithdrawalTypeVirtual: {
                            NSString *acct = [wam.bankCard ciphertextWithHead:4 tail:4 style:0];
                            if (wam.bankAddr.stringByTrim.length) {
                                title = _NSString(@"%@（%@，%@，%@）", wam.name, acct, wam.bankAddr, wam.name);
                            } else {
                                title = _NSString(@"%@（%@，%@）", wam.name, acct, wam.name);
                            }
                            break;
                        }
                        case UGWithdrawalTypeAlipay: {
                            NSString *acct = [wam.bankCard ciphertextWithHead:4 tail:4 style:0];
                            title = _NSString(@"%@（%@，%@）", wam.name, acct, wam.ownerName);
                            break;
                        }
                        case UGWithdrawalTypeWeChat:
                        default: {
                            NSString *acct = [wam.bankCard ciphertextWithHead:3 tail:3 style:0];
                            if (wam.bankAddr.stringByTrim.length) {
                                title = _NSString(@"%@（%@，手机尾号%@, %@）", wam.name, acct, [wam.bankAddr substringFromIndex:MAX((int)wam.bankAddr.length-4, 0)], wam.ownerName);
                            } else {
                                title = _NSString(@"%@（%@，%@）", wam.name, acct, wam.ownerName);
                            }
                            break;
                        }
                    }
                    [__self.titles addObject:title];
                }
                if (__self.justBindAccount.length) {
                    NSInteger idx = [__self.acctList indexOfValue:__self.justBindAccount keyPath:@"bankCard"];
                    [__self ybPopupMenuDidSelectedAtIndex:idx ybPopupMenu:nil];
                    __self.justBindAccount = nil;
                } else if (__self.selectedWtm) {
                    NSInteger idx = [__self.acctList indexOfValue:@(__self.selectedWtm.type) keyPath:@"type"];
                    [__self ybPopupMenuDidSelectedAtIndex:idx ybPopupMenu:nil];
                } else if (!__self.selectedWam) {
                    [__self ybPopupMenuDidSelectedAtIndex:0 ybPopupMenu:nil];
                }
            }
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

// 绑定提款账号
- (IBAction)onBindWithdrawalAcctBtnClick:(UIButton *)sender {
    __weakSelf_(__self);
    BindWithdrawalAccountVC *vc = _LoadVC_from_storyboard_(@"BindWithdrawalAccountVC");
    vc.wt = _selectedWtm.type;
    vc.didBindAccount = ^(UGWithdrawalType wt, NSString * _Nonnull acct) {
        __self.justBindAccount = acct;
    };
    [NavController1 pushViewController:vc animated:true];
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
    YBPopupMenu *popView = [[YBPopupMenu alloc] initWithTitles:_titles icons:@[] menuWidth:CGSizeMake(APP.Width-50, 185) delegate:self];
    popView.fontSize = 14;
    popView.type = YBPopupMenuTypeDefault;
    [popView showRelyOnView:sender];
}

// 申请提款
- (IBAction)onSubmitBtnClick:(UIButton *)sender {
    if (_selectedWtm) return;
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
    
    WithdrawalAcctModel *wam = _selectedWam;
    if (amount.floatValue < wam.minWithdrawMoney.floatValue ||
        (amount.floatValue > wam.maxWithdrawMoney.floatValue && wam.maxWithdrawMoney.doubleValue > 0)) {
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"单笔取款金额范围：%@-%@", wam.minWithdrawMoney, wam.maxWithdrawMoney]];
        return ;
    }
    
    [self.view endEditing:YES];
    
    __weakSelf_(__self);
    [SVProgressHUD showWithStatus:nil];
    void (^apply)(void) = ^{
        // 提交申请
        [NetworkManager1 withdraw_apply:wam.wid amount:amount virtualAmount:__self.virtualAmount pwd:pwd].completionBlock = ^(CCSessionModel *sm, id resObject, NSError *err) {
            if (!sm.error) {
                [SVProgressHUD showSuccessWithStatus:sm.resObject[@"msg"]];
                subTextField(@"取款金额TextField").text = nil;
                subTextField(@"取款密码TextField").text = nil;
                subLabel(@"虚拟币汇率Label").hidden = true;
                
                //发送通知给取款记录
                SANotificationEventPost(UGNotificationWithdrawalsSuccess, nil);
                if (__self.withdrawSuccessBlock) {
                    __self.withdrawSuccessBlock();
                }
            } else {
                [__self reloadCurrencyRate:nil];
            }
        };
    };
    if (wam.type == UGWithdrawalTypeVirtual && __self.virtualAmount) {
        [self reloadCurrencyRate:^{
            CGFloat currencyRate = 0;
            CGFloat rateOffset = 0;
            for (UGbankModel *bm in __self.sysBankList) {
                if ([bm.bankId isEqualToString:wam.bankId]) {
                    currencyRate = bm.currencyRate.doubleValue;
                    rateOffset = bm.rate.doubleValue;
                }
            }
            currencyRate *= 1.0 + rateOffset / 100.0;
            NSString *virtualAmount = currencyRate > 0.000001 ? [AppDefine stringWithFloat:currencyRate * amount.doubleValue decimal:2] : nil;
            if (virtualAmount != __self.virtualAmount) {
                [HUDHelper showMsg:@"当前汇率已变更，已为您更新为最新汇率"];
                return;
            }
            apply();
        }];
    } else {
        apply();
    }
}


#pragma mark - YBPopupMenuDelegate

- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu {
    if (index < 0) return;
    WithdrawalAcctModel *wam = _acctList[index];
    BOOL isAcct = ![wam isKindOfClass:[WithdrawalTypeModel class]];
    
    FastSubViewCode(self.view);
    [subButton(@"提款账号Button") setTitle:_titles[index] forState:UIControlStateNormal];
    subTextField(@"取款金额TextField").superview.hidden = !isAcct;
    subTextField(@"取款密码TextField").hidden = !isAcct;
    subLabel(@"金额上下限Label").text = [NSString stringWithFormat:@"单笔下限%@，上限%@", wam.minWithdrawMoney, wam.maxWithdrawMoney];
    _bindAcctView.hidden = isAcct;
    
    _selectedWam = isAcct ? _acctList[index] : nil;
    _selectedWtm = !isAcct ? _acctList[index] : nil;
    if (isAcct) {
        [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:nil];
    } else {
        subLabel(@"绑定账户Label").text = _NSString(@"绑定%@账号", wam.name);
    }
}

@end
