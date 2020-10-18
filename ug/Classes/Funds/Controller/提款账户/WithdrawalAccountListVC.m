//
//  WithdrawalAccountListVC.m
//  UGBWApp
//
//  Created by fish on 2020/10/7.
//  Copyright © 2020 ug. All rights reserved.
//

#import "WithdrawalAccountListVC.h"
#import "BindWithdrawalAccountVC.h"

#import "SlideSegmentView1.h"

#import "WithdrawalAcctModel.h"

@interface WithdrawalAccountListVC ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *realnameTextField;
@property (weak, nonatomic) IBOutlet UIView *tipsView1; /**<   联系客服 */
@property (weak, nonatomic) IBOutlet UIView *tipsView2; /**<   完善真实姓名 */

@property (nonatomic, strong) UIBarButtonItem *navRightButton;  /**<   导航条按钮 */
@property (nonatomic, strong) SlideSegmentView1 *ssv1;          /**<   分页布局 */
@property (nonatomic, strong) NSArray <WithdrawalTypeModel *>*typeList; /**<   数据 */
@end

@implementation WithdrawalAccountListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _tipsView1.hidden = true;
    _tipsView2.hidden = UserI.fullName.stringByTrim.length;
    __weakSelf_(__self);
    _navRightButton = [[UIBarButtonItem alloc] initWithCustomView:({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [btn setTitle:@"新增" forState:UIControlStateNormal];
        [btn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            if (__self.tipsView1.hidden && __self.tipsView2.hidden) {
                if (UserI.hasFundPwd) {
                    BindWithdrawalAccountVC *vc = _LoadVC_from_storyboard_(@"BindWithdrawalAccountVC");
                    vc.wt = __self.typeList[__self.ssv1.selectedIndex].type;
                    vc.didBindAccount = ^(UGWithdrawalType wt, NSString * _Nonnull acct) {
                        __self.ssv1.selectedIndex = [__self.typeList indexOfValue:@(wt) keyPath:@"type"];
                    };
                    [NavController1 pushViewController:vc animated:true];
                } else {
                    [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGSetupPayPwdController") animated:true];
                }
            }
        }];
        btn;
    })];
    
    
    FastSubViewCode(self.view);
    subButton(@"去在线客服Button").backgroundColor = Skin1.navBarBgColor;
    subButton(@"提交真实姓名Button").backgroundColor = Skin1.navBarBgColor;
    [SVProgressHUD show];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    __weakSelf_(__self);
    [NetworkManager1 user_bankCard].completionBlock = ^(CCSessionModel *sm, id resObject, NSError *err) {
        [SVProgressHUD dismiss];
        if (!sm.error) {
            NSMutableArray *temp = @[].mutableCopy;
            for (NSDictionary *dict in sm.resObject[@"data"]) {
                WithdrawalTypeModel *wtm = [WithdrawalTypeModel mj_objectWithKeyValues:dict];
                if (wtm.isshow) {
                    for (WithdrawalAcctModel *wam in wtm.data) {
                        wam.name = wtm.name;
                        wam.minWithdrawMoney = wtm.minWithdrawMoney;
                        wam.maxWithdrawMoney = wtm.maxWithdrawMoney;
                    }
                    [temp addObject:wtm];
                }
            }
            
            WithdrawalTypeModel *wtm = [WithdrawalTypeModel new];
            wtm.name = @"全部";
            wtm.isshow = true;
            NSMutableArray <WithdrawalAcctModel *>*data = @[].mutableCopy;
            for (WithdrawalTypeModel *w in temp) {
                if (w.canAdd) {
                    wtm.canAdd = true;
                }
                [data addObjectsFromArray:w.data];
            }
            wtm.data = [data copy];
            [temp insertObject:wtm atIndex:0];
            __self.typeList = [temp copy];
            [__self setupSSV];
        }
    };
}


- (void)setupSSV {
    if (_ssv1) {
        [(UITableView *)_ssv1.contentViews[_ssv1.selectedIndex] reloadData];
        self.navigationItem.rightBarButtonItem = _typeList[_ssv1.selectedIndex].canAdd ? _navRightButton  : nil;
        _ssv1.titleBar.barHeight = _typeList[0].data.count ? 44 : 0;
        _ssv1.selectedIndex = _ssv1.selectedIndex;
        return;
    }
    
    __weakSelf_(__self);
    NSArray *titles = [_typeList valueForKey:@"name"];
    NSMutableArray *tvs = @[].mutableCopy;
    for (NSString *title in titles) {
        UITableView *tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 100, 200) style:UITableViewStylePlain];
        tv.delegate = self;
        tv.dataSource = self;
        tv.rowHeight = 150;
        [tv registerNib:[UINib nibWithNibName:@"WithdrawalAccountCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        tv.separatorStyle = UITableViewCellSeparatorStyleNone;
        tv.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 8)];
        tv.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 8)];
        [tvs addObject:tv];
    }
    
    SlideSegmentView1 *ssv1 = _ssv1 = _LoadView_from_nib_(@"SlideSegmentView1");
    ssv1.frame = CGRectMake(0, 0, APP.Width, 100);
    [ssv1 setupTitles:titles contents:tvs];
    ssv1.bigScrollView.scrollEnabled = true;
    ssv1.titleBar.barHeight = _typeList[0].data.count ? 44 : 0;
    ssv1.titleBar.insetVertical = 5;
    ssv1.titleBar.updateCellForItemAtIndex = ^(SlideSegmentBar1 *titleBar, UICollectionViewCell *cell, UILabel *label, NSUInteger idx, BOOL selected) {
        label.text = titles[idx];
        label.font = selected ? [UIFont boldSystemFontOfSize:15] : [UIFont systemFontOfSize:15];
        label.textColor = selected ? Skin1.navBarBgColor : [UIColor grayColor];
    };
    ssv1.titleBar.underlineColor = Skin1.navBarBgColor;
    ssv1.didSelectedIndexChange = ^(SlideSegmentView1 *ssv1, NSUInteger idx) {
        UITableView *tv = ssv1.contentViews[idx];
        if (OBJOnceToken(tv.noDataTipsLabel)) {
            tv.noDataTipsLabel.text = @"";
            tv.noDataTipsLabel.height = 200;
            UILabel *lb = [UILabel new];
            lb.text = @"空空如也\n点击右上角“新增”添加提款账户吧";
            lb.numberOfLines = 0;
            lb.textAlignment = NSTextAlignmentCenter;
            lb.font = [UIFont systemFontOfSize:13];
            lb.textColor = [UIColor colorWithHex:0x666666];
            [tv.noDataTipsLabel addSubview:lb];
            [lb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.left.right.equalTo(tv.noDataTipsLabel);
            }];
            
            UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"空空如也"]];
            imgView.contentMode = UIViewContentModeScaleAspectFit;
            [tv.noDataTipsLabel addSubview:imgView];
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(tv.noDataTipsLabel).mas_offset(-60);
                make.top.equalTo(tv.noDataTipsLabel).mas_offset(100);
                make.centerX.equalTo(tv.noDataTipsLabel);
            }];
        }
        tv.noDataTipsLabel.hidden = __self.typeList[idx].data.count;
        [tv reloadData];
        __self.navigationItem.rightBarButtonItem = __self.typeList[idx].canAdd ? __self.navRightButton  : nil;
    };
    
    [self.view insertSubview:ssv1 atIndex:0];
    [ssv1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        make.width.mas_equalTo(APP.Width);
    }];
}


#pragma mark - IBAction

- (IBAction)onCancelBtnClick:(UIButton *)sender {
    if ([sender.tagString isEqualToString:@"取消真实姓名Button"]) {
        [NavController1 popViewControllerAnimated:true];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.tipsView1.alpha = 0;
        } completion:^(BOOL finished) {
            self.tipsView1.hidden = true;
            self.tipsView1.alpha = 1;
        }];
    }
}

// 设置真实姓名
- (IBAction)onSetRealNameBtnClick:(UIButton *)sender {
    NSString *realname = _realnameTextField.text.stringByTrim;
    if (!realname.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入真实姓名"];
    }
    [self.view endEditing:true];
    [SVProgressHUD show];
    __weakSelf_(__self);
    [NetworkManager1 user_profileName:realname].completionBlock = ^(CCSessionModel *sm, id resObject, NSError *err) {
        [SVProgressHUD dismiss];
        if (!sm.error) {
            [SVProgressHUD showSuccessWithStatus:sm.resObject[@"msg"]];
            __self.tipsView2.hidden = true;
            UserI.fullName = realname;
            [(UIButton *)__self.navRightButton.customView sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
    };
}

// 联系客服
- (IBAction)onContactCustomerServiceBtnClick:(UIButton *)sender {
    [self onCancelBtnClick:nil];
    [NavController1 pushVCWithUserCenterItemType:UCI_在线客服];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _typeList[[_ssv1.contentViews indexOfObject:tableView]].data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    __weakSelf_(__self);
    static NSDictionary *imgDict = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imgDict = @{
            @"3":@"微信 支付",
            @"4":@"虚拟币",
            @"1":@"银行卡",
            @"2":@"支付宝",
        };
    });
    WithdrawalAcctModel *wam = _typeList[[_ssv1.contentViews indexOfObject:tableView]].data[indexPath.row];
    FastSubViewCode(cell);
    subImageView(@"账户类型ImageView").image = [UIImage imageNamed:imgDict[@(wam.type).stringValue]];
    subLabel(@"账户类型Label").text = wam.name;
    subLabel(@"标题2Label").superview.hidden = false;
    switch (wam.type) {
        case UGWithdrawalTypeBankCard:
            subLabel(@"标题1Label").text = @"开户姓名：";
            subLabel(@"标题2Label").text = @"开户账号：";
            subLabel(@"标题3Label").text = @"开户地址：";
            subLabel(@"内容1Label").text = wam.ownerName;
            subLabel(@"内容2Label").text = wam.bankCard;
            subLabel(@"内容3Label").text = wam.bankAddr;
            break;
        case UGWithdrawalTypeWeChat:
            subLabel(@"标题1Label").text = @"真实姓名：";
            subLabel(@"标题2Label").text = @"绑定手机号：";
            subLabel(@"标题3Label").text = @"微信号：";
            subLabel(@"内容1Label").text = wam.ownerName;
            subLabel(@"内容2Label").text = wam.bankAddr;
            subLabel(@"内容3Label").text = wam.bankCard;
            subLabel(@"标题2Label").superview.hidden = !wam.bankAddr.stringByTrim.length;
            break;
        case UGWithdrawalTypeAlipay:
            subLabel(@"标题1Label").text = @"真实姓名：";
            subLabel(@"标题2Label").text = @"";
            subLabel(@"标题3Label").text = @"支付宝账号：";
            subLabel(@"内容1Label").text = wam.ownerName;
            subLabel(@"内容2Label").text = @"";
            subLabel(@"内容3Label").text = wam.bankCard;
            subLabel(@"标题2Label").superview.hidden = true;
            break;
        case UGWithdrawalTypeVirtual:
            subLabel(@"标题1Label").text = @"币种：";
            subLabel(@"标题2Label").text = @"链名称：";
            subLabel(@"标题3Label").text = @"钱包地址：";
            subLabel(@"内容1Label").text = wam.bankName;
            subLabel(@"内容2Label").text = wam.bankAddr;
            subLabel(@"内容3Label").text = wam.bankCard;
            subLabel(@"标题2Label").superview.hidden = !wam.bankAddr.stringByTrim.length;
            break;
            
        default:;
    }
    
    [subButton(@"编辑Button") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
    [subButton(@"编辑Button") addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton *sender) {
        __self.tipsView1.hidden = false;
        __self.tipsView1.backgroundColor = [UIColor clearColor];
        __self.tipsView1.transform = CGAffineTransformMakeScale(1.1, 1.1);
        [UIView animateWithDuration:0.15 animations:^{
            __self.tipsView1.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
            __self.tipsView1.transform = CGAffineTransformIdentity;
        }];
    }];
    return cell;
}

@end
