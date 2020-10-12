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

@interface UGWithdrawalVC ()<YBPopupMenuDelegate>
@property (weak, nonatomic) IBOutlet UIView *tipsView1; /**<   您还未绑定提款账户 */
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;/**<   虚拟币汇率Label */
@property (weak, nonatomic) IBOutlet UIView *bindAcctView;

@property (nonatomic, strong) NSMutableArray *acctList; /**<   账户列表（元素可能是WithdrawalAcctModel、WithdrawalTypeModel，要判断元素类型） */
@property (nonatomic, strong) NSMutableArray *titles;   /**<   标题列表 */
@property (nonatomic, strong) WithdrawalAcctModel *selectedWam; /**<   选中的账户 */
@property (nonatomic, strong) NSString *virtualAmount;          /**<   虚拟币金额 */
@end

@implementation UGWithdrawalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _acctList = @[].mutableCopy;
    _titles = @[].mutableCopy;
    
    FastSubViewCode(self.view);
    subLabel(@"金额上下限Label").text = [NSString stringWithFormat:@"单笔下限%@，上限%@",[SysConf.minWithdrawMoney removeFloatAllZero],[SysConf.maxWithdrawMoney removeFloatAllZero]];
    subButton(@"提交Button").backgroundColor = Skin1.navBarBgColor;
    subLabel(@"虚拟币汇率Label").hidden = true;
    subTextField(@"取款金额TextField").superview.hidden = true;
    subTextField(@"取款密码TextField").hidden = true;
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
        if (rate > 0.000001) {
            __self.virtualAmount = [AppDefine stringWithFloat:rate * amount decimal:8];
        }
        subLabel(@"虚拟币汇率Label").hidden = !(__self.selectedWam.type == UGWithdrawalTypeVirtual && amount > 0.0001);
        subLabel(@"虚拟币汇率Label").text = _NSString(@"=%@ USDT　　1 USDT = %@ CNY", __self.virtualAmount, [AppDefine stringWithFloat:1/rate decimal:2]);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData];
}

- (void)reloadData {
    __weakSelf_(__self);
    FastSubViewCode(self.view);
    [NetworkManager1 user_bankCard].completionBlock = ^(CCSessionModel *sm) {
        if (!sm.error) {
            [__self.acctList removeAllObjects];
            for (NSDictionary *dict in sm.responseObject[@"data"]) {
                WithdrawalTypeModel *wtm = [WithdrawalTypeModel mj_objectWithKeyValues:dict];
                if (!wtm.isshow) continue;
                for (WithdrawalAcctModel *wam in wtm.data) {
                    wam.name = wtm.name;
                    [__self.acctList addObject:wam];
                }
                if (!wtm.data.count) {
                    [__self.acctList addObject:wtm];
                }
            }
            __self.tipsView1.hidden = __self.acctList.count;
            
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
                            title = _NSString(@"%@（%@，尾号%@，%@）", wam.name, wam.bankName, [wam.bankCard substringFromIndex:wam.bankCard.length-4], wam.ownerName);
                            break;
                        case UGWithdrawalTypeVirtual: {
                            NSString *acct = [wam.bankCard ciphertextWithHead:5 tail:5];
                            if (wam.bankAddr.stringByTrim.length) {
                                title = _NSString(@"%@（%@，%@，%@）", wam.name, acct, wam.bankAddr, wam.ownerName);
                            } else {
                                title = _NSString(@"%@（%@，%@）", wam.name, acct, wam.ownerName);
                            }
                            break;
                        }
                        case UGWithdrawalTypeAlipay: {
                            NSString *acct = [wam.bankCard ciphertextWithHead:4 tail:4];
                            title = _NSString(@"%@（%@，%@）", wam.name, acct, wam.ownerName);
                        }
                        case UGWithdrawalTypeWeChat:
                        default: {
                            NSString *acct = [wam.bankCard ciphertextWithHead:3 tail:3];
                            title = _NSString(@"%@（%@，%@）", wam.name, acct, wam.ownerName);
                            break;
                        }
                    }
                    [__self.titles addObject:title];
                }
                if (!__self.selectedWam) {
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

- (IBAction)onBindWithdrawalAcctBtnClick:(UIButton *)sender {
    [NavController1 pushViewController:_LoadVC_from_storyboard_(@"BindWithdrawalAccountVC") animated:true];
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
    YBPopupMenu *popView = [[YBPopupMenu alloc] initWithTitles:_titles icons:@[] menuWidth:CGSizeMake(APP.Width-50, 200) delegate:self];
    popView.fontSize = 14;
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
    [NetworkManager1 withdraw_apply:_selectedWam.wid amount:amount virtualAmount:_virtualAmount pwd:pwd].completionBlock = ^(CCSessionModel *sm) {
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
    WithdrawalAcctModel *wam = _acctList[index];
    BOOL isAcct = ![wam isKindOfClass:[WithdrawalTypeModel class]];
    
    FastSubViewCode(self.view);
    [subButton(@"提款账号Button") setTitle:_titles[index] forState:UIControlStateNormal];
    subTextField(@"取款金额TextField").superview.hidden = !isAcct;
    subTextField(@"取款密码TextField").hidden = !isAcct;
    _bindAcctView.hidden = isAcct;
    
    if (isAcct) {
        _selectedWam = _acctList[index];
        [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:nil];
    } else {
        subLabel(@"绑定账户Label").text = _NSString(@"绑定%@账号", wam.name);
    }
}

@end
