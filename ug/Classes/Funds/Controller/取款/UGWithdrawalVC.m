//
//  UGWithdrawalVC.m
//  UGBWApp
//
//  Created by fish on 2020/10/7.
//  Copyright © 2020 ug. All rights reserved.
//

#import "UGWithdrawalVC.h"
#import "WithdrawalAcctModel.h"
#import "YBPopupMenu.h"

@interface UGWithdrawalVC ()
@property (weak, nonatomic) IBOutlet UIView *tipsView1; /**<   您还未绑定提款账户 */

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
    
    __weakSelf_(__self);
    [NetworkManager1 user_bankCard:UGWithdrawalTypeAll].completionBlock = ^(CCSessionModel *sm) {
        if (!sm.error) {
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
    [NavController1 pushVCWithUserCenterItemType:UCI_利息宝];
}

// 选择提款账号
- (IBAction)onSelectAcctBtnClick:(UIButton *)sender {
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
    [NetworkManager1 withdraw_apply].completionBlock = ^(CCSessionModel *sm) {
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
}

@end
