//
//  BindWithdrawalAccountVC.m
//  UGBWApp
//
//  Created by fish on 2020/10/7.
//  Copyright © 2020 ug. All rights reserved.
//

#import "BindWithdrawalAccountVC.h"
#import "YBPopupMenu.h"
#import "WithdrawalAcctModel.h"
#import "UGbankModel.h"

@interface BindWithdrawalAccountVC ()<YBPopupMenuDelegate>
@property (weak, nonatomic) IBOutlet UIStackView *bankStackView;    /**<   银行卡StackView */
@property (weak, nonatomic) IBOutlet UIStackView *alipayStackView;  /**<   支付宝StackView */
@property (weak, nonatomic) IBOutlet UIStackView *virtualStackView; /**<   虚拟币StackView */
@property (weak, nonatomic) IBOutlet UIStackView *wechatStackView;  /**<   微信StackView */

@property (nonatomic, strong) NSArray <WithdrawalTypeModel *>*typeList; /**<   我的提款账户列表，用于判断是否还能再添加账户 */
@property (nonatomic, strong) NSArray <UGbankModel *>*bankList;     /**<   银行渠道列表 */
@property (nonatomic, strong) NSArray <UGbankModel *>*virtualList;  /**<   虚拟币渠道列表 */
@property (nonatomic, strong) NSArray <NSString *>*blockchainList;  /**<   当前虚拟币渠道的链名称列表 */
@property (nonatomic, strong) UGbankModel *selectedBank;            /**<   选中的银行 */
@property (nonatomic, strong) UGbankModel *selectedWeChat;          /**<   选中的微信 */
@property (nonatomic, strong) UGbankModel *selectedAlipay;          /**<   选中的支付宝 */
@property (nonatomic, strong) UGbankModel *selectedVirtual;         /**<   选中的虚拟币 */
@property (nonatomic, strong) NSString *selectedBlockchain;         /**<   选中的链名称 */
@property (nonatomic, assign) UGWithdrawalType selectedWT;          /**<   选中的提款渠道类型 */
@end

@implementation BindWithdrawalAccountVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FastSubViewCode(self.view);
    subLabel(@"真实姓名Label").text = UserI.fullName;
    subTextField(@"微信绑定手机号TextField").hidden = true;
    subButton(@"选择区块链Button").superview.hidden = true;
    subButton(@"确定Button").backgroundColor = Skin1.navBarBgColor;
    _bankStackView.hidden = true;
    _wechatStackView.hidden = true;
    _alipayStackView.hidden = true;
    _virtualStackView.hidden = true;
    
    [SVProgressHUD show];
    for (UIView *subview in self.view.subviews) {
        subview.hidden = true;
    }
    __weakSelf_(__self);
    [NetworkManager1 user_bankCard].completionBlock = ^(CCSessionModel *sm, id resObject, NSError *err) {
        [SVProgressHUD dismiss];
        for (UIView *subview in __self.view.subviews) {
            subview.hidden = false;
        }
        if (!sm.error) {
            NSMutableArray *temp = @[].mutableCopy;
            for (NSDictionary *dict in sm.resObject[@"data"]) {
                WithdrawalTypeModel *wam = [WithdrawalTypeModel mj_objectWithKeyValues:dict];
                if (wam.isshow && wam.canAdd) {
                    [temp addObject:wam];
                }
            }
            __self.typeList = [temp copy];
            NSInteger idx = [__self.typeList indexOfValue:@(__self.wt) keyPath:@"type"];
            [__self ybPopupMenuDidSelectedAtIndex:idx ybPopupMenu:({
                YBPopupMenu *pm = [YBPopupMenu new];
                pm.tagString = @"选择提款类型";
                pm;
            })];
        }
    };
}

#pragma mark - IBAction

// 选择提款类型
- (IBAction)onSelectWithdrawalTypeBtnClick:(UIButton *)sender {
    if (!_typeList) {
        [SVProgressHUD show];
        __weakSelf_(__self);
        [NetworkManager1 user_bankCard].completionBlock = ^(CCSessionModel *sm, id resObject, NSError *err) {
            [SVProgressHUD dismiss];
            if (!sm.error) {
                NSMutableArray *temp = @[].mutableCopy;
                for (NSDictionary *dict in sm.resObject[@"data"]) {
                    WithdrawalTypeModel *wam = [WithdrawalTypeModel mj_objectWithKeyValues:dict];
                    if (wam.isshow && wam.canAdd) {
                        [temp addObject:wam];
                    }
                }
                __self.typeList = [temp copy];
                [__self onSelectWithdrawalTypeBtnClick:sender];
            }
        };
        return;
    }
    NSArray *titles = [_typeList valueForKey:@"name"];
    YBPopupMenu *popView = [[YBPopupMenu alloc] initWithTitles:titles icons:nil menuWidth:CGSizeMake(300, 150) delegate:self];
    popView.tagString = @"选择提款类型";
    popView.fontSize = 15;
    popView.type = YBPopupMenuTypeDefault;
    [popView showRelyOnView:sender];
}

// 选择银行卡
- (IBAction)onSelectBankTypeBtnClick:(UIButton *)sender {
    __weakSelf_(__self);
    [NetworkManager1 system_bankList:UGWithdrawalTypeBankCard].completionBlock = ^(CCSessionModel *sm, id resObject, NSError *err) {
        if (!sm.error) {
            NSMutableArray *temp = @[].mutableCopy;
            for (NSDictionary *dict in sm.resObject[@"data"]) {
                [temp addObject:[UGbankModel mj_objectWithKeyValues:dict]];
            }
            __self.bankList = [temp copy];
            NSArray *titles = [__self.bankList valueForKey:@"name"];
            YBPopupMenu *popView = [[YBPopupMenu alloc] initWithTitles:titles icons:nil menuWidth:CGSizeMake(300, 150) delegate:__self];
            popView.tagString = @"选择银行";
            popView.fontSize = 15;
            popView.type = YBPopupMenuTypeDefault;
            [popView showRelyOnView:sender];
        }
    };
}

// 选择虚拟币
- (IBAction)onSelectVirtualTypeBtnClick:(UIButton *)sender {
    __weakSelf_(__self);
    [NetworkManager1 system_bankList:UGWithdrawalTypeVirtual].completionBlock = ^(CCSessionModel *sm, id resObject, NSError *err) {
        if (!sm.error) {
            NSMutableArray *temp = @[].mutableCopy;
            for (NSDictionary *dict in sm.resObject[@"data"]) {
                [temp addObject:[UGbankModel mj_objectWithKeyValues:dict]];
            }
            __self.virtualList = [temp copy];
            NSArray *titles = [__self.virtualList valueForKey:@"name"];
            YBPopupMenu *popView = [[YBPopupMenu alloc] initWithTitles:titles icons:nil menuWidth:CGSizeMake(300, 150) delegate:__self];
            popView.tagString = @"选择虚拟币";
            popView.fontSize = 15;
            popView.type = YBPopupMenuTypeDefault;
            [popView showRelyOnView:sender];
        }
    };
}

// 选择虚拟币区块链
- (IBAction)onSelectBlockchainTypeBtnClick:(UIButton *)sender {
    NSArray *titles = _blockchainList;
    YBPopupMenu *popView = [[YBPopupMenu alloc] initWithTitles:titles icons:nil menuWidth:CGSizeMake(300, 150) delegate:self];
    popView.tagString = @"选择区块链";
    popView.fontSize = 15;
    popView.type = YBPopupMenuTypeDefault;
    [popView showRelyOnView:sender];
}

// 确定
- (IBAction)onSubmitBtnClick:(UIButton *)sender {
    FastSubViewCode(self.view);
    
    NSString *wid = nil;
    NSString *addr = nil;
    NSString *acct = nil;
    switch (_selectedWT) {
        case UGWithdrawalTypeWeChat:
            wid = _selectedWeChat.bankId;
            acct = subTextField(@"微信号TextField").text;
            break;
        case UGWithdrawalTypeVirtual:
            wid = _selectedVirtual.bankId;
            addr = _selectedBlockchain;
            acct = subTextField(@"虚拟币地址TextField").text;
            break;
        case UGWithdrawalTypeAlipay:
            wid = _selectedAlipay.bankId;
            acct = subTextField(@"支付宝号TextField").text;
            break;
        case UGWithdrawalTypeBankCard:
            wid = _selectedBank.bankId;
            addr = subTextField(@"银行开户地址TextField").text;
            acct = subTextField(@"银行卡号TextField").text;
            break;
            
        default:;
    }
    BOOL err = false;
    if (!wid.length) err = true;
    if (!acct.length) err = true;
    if (!addr.length && (_selectedWT == UGWithdrawalTypeBankCard || (_selectedWT == UGWithdrawalTypeVirtual && _blockchainList.count))) {
        err = true;
    }
    if (err) {
        [SVProgressHUD showErrorWithStatus:@"请完善资料"];
        return;
    }
    
    [SVProgressHUD show];
    [NetworkManager1 user_bindBank:_selectedWT wid:wid addr:addr acct:acct].completionBlock = ^(CCSessionModel *sm, id resObject, NSError *err) {
        [SVProgressHUD dismiss];
        if (!sm.error) {
            [SVProgressHUD showSuccessWithStatus:sm.resObject[@"msg"]];
            [NavController1 popViewControllerAnimated:true];
        }
    };
}


#pragma mark - YBPopupMenuDelegate

- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu {
    if (index < 0) return;
    FastSubViewCode(self.view);
    if ([ybPopupMenu.tagString isEqualToString:@"选择提款类型"]) {
        NSString *key = _typeList[index].name;
        UGWithdrawalType wt = _typeList[index].type;
        
        __weakSelf_(__self);
        void (^refreshUI)(void) = ^{
            __self.bankStackView.hidden = wt != UGWithdrawalTypeBankCard;
            __self.wechatStackView.hidden = wt != UGWithdrawalTypeWeChat;
            __self.alipayStackView.hidden = wt != UGWithdrawalTypeAlipay;
            __self.virtualStackView.hidden = wt != UGWithdrawalTypeVirtual;
            [subButton(@"选择提款类型Button") setTitle:key forState:UIControlStateNormal];
        };
        if (wt == UGWithdrawalTypeAlipay || wt == UGWithdrawalTypeWeChat) {
            [NetworkManager1 system_bankList:wt].completionBlock = ^(CCSessionModel *sm, id resObject, NSError *err) {
                NSMutableArray *temp = @[].mutableCopy;
                for (NSDictionary *dict in sm.resObject[@"data"]) {
                    [temp addObject:[UGbankModel mj_objectWithKeyValues:dict]];
                }
                if (wt == UGWithdrawalTypeWeChat) {
                    __self.selectedWeChat = temp.firstObject;
                }
                if (wt == UGWithdrawalTypeAlipay) {
                    __self.selectedAlipay = temp.firstObject;
                }
                __self.selectedWT = wt;
                refreshUI();
            };
        } else {
            _selectedWT = wt;
            refreshUI();
        }
    }
    else if ([ybPopupMenu.tagString isEqualToString:@"选择银行"]) {
        UGbankModel *bm = _selectedBank = _bankList[index];
        [subButton(@"选择银行Button") setTitle:bm.name forState:UIControlStateNormal];
    }
    else if ([ybPopupMenu.tagString isEqualToString:@"选择虚拟币"]) {
        UGbankModel *bm = _selectedVirtual = _virtualList[index];
        NSMutableArray *temp = @[].mutableCopy;
        for (NSString *l in [bm.home componentsSeparatedByString:@","]) {
            if (l.length)
                [temp addObject:l];
        }
        _blockchainList = [temp copy];
        _selectedBlockchain = nil;
        subButton(@"选择区块链Button").superview.hidden = !_blockchainList.count;
        [subButton(@"选择虚拟币Button") setTitle:bm.name forState:UIControlStateNormal];
        [subButton(@"选择区块链Button") setTitle:@"选择链名称" forState:UIControlStateNormal];
    }
    else if ([ybPopupMenu.tagString isEqualToString:@"选择区块链"]) {
        _selectedBlockchain = _blockchainList[index];
        [subButton(@"选择区块链Button") setTitle:_selectedBlockchain forState:UIControlStateNormal];
    }
}


@end
