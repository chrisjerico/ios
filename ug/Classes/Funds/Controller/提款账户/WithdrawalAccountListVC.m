//
//  WithdrawalAccountListVC.m
//  UGBWApp
//
//  Created by fish on 2020/10/7.
//  Copyright © 2020 ug. All rights reserved.
//

#import "WithdrawalAccountListVC.h"
#import "BindWithdrawalAccountVC.h"

#import "UITableView+Refresh.h"
#import "SlideSegmentView1.h"

#import "WithdrawalAcctModel.h"

@interface WithdrawalAccountListVC ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *realnameTextField;
@property (weak, nonatomic) IBOutlet UIView *tipsView1; /**<   联系客服 */
@property (weak, nonatomic) IBOutlet UIView *tipsView2; /**<   完善真实姓名 */

@property (nonatomic, strong) SlideSegmentView1 *ssv1;
@property (nonatomic, strong) NSArray <NSDictionary *>*dataArrayList;
@end

@implementation WithdrawalAccountListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tipsView1.hidden = true;
    _tipsView2.hidden = UserI.fullName.stringByTrim.length;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [btn setTitle:@"新增" forState:UIControlStateNormal];
        [btn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            [NavController1 pushViewController:_LoadVC_from_storyboard_(@"BindWithdrawalAccountVC") animated:true];
        }];
        btn;
    })];
    
    
    FastSubViewCode(self.view);
    subButton(@"去在线客服Button").backgroundColor = Skin1.navBarBgColor;
    subButton(@"提交真实姓名Button").backgroundColor = Skin1.navBarBgColor;
    
    
    __weakSelf_(__self);
    NSArray *titles = @[@"全部", @"银行卡", @"支付宝", @"微信", @"虚拟币", ];
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
        NSDictionary *dict = @{
            @"全部":@(UGWithdrawalTypeAll),
            @"银行卡":@(UGWithdrawalTypeBankCard),
            @"支付宝":@(UGWithdrawalTypeAlipay),
            @"微信":@(UGWithdrawalTypeWeChat),
            @"虚拟币":@(UGWithdrawalTypeVirtual),
        };
        UGWithdrawalType wt = [dict[title] intValue];
        [tv setupHeaderRefreshRequest:^CCSessionModel *(UITableView *tv) {
            return [NetworkManager1 user_bankCard:wt];
        } completion:^NSArray *(UITableView *tv, CCSessionModel *sm) {
            if (!sm.error) {
                __self.dataArrayList = sm.responseObject[@"data"];
                for (int i=0; i<titles.count; i++) {
                    NSString *title = titles[i];
                    UITableView *tv = __self.ssv1.contentViews[i];
                    [tv.dataArray removeAllObjects];
                    
                    NSArray *dataArray = [dict[title] intValue] == UGWithdrawalTypeAll ? __self.dataArrayList : [__self.dataArrayList objectsWithValue:dict[title] keyPath:@"type"];
                    for (NSDictionary *subD in dataArray) {
                        if ([subD[@"data"] allKeys].count) {
                            [tv.dataArray addObject:[WithdrawalAcctModel mj_objectWithKeyValues:subD]];
                        }
                    }
                }
            }
            
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
                    make.centerX.equalTo(tv.noDataTipsLabel);
                }];
            }
            return nil;
        }];
        [tvs addObject:tv];
    }
    
    SlideSegmentView1 *ssv1 = _ssv1 = _LoadView_from_nib_(@"SlideSegmentView1");
    ssv1.frame = CGRectMake(0, 0, APP.Width, 100);
    ssv1.contentViews = tvs;
    ssv1.titleBar.titleForItemAtIndex = ^NSString *(NSUInteger idx) {
        return titles[idx];
    };
    __weak_Obj_(ssv1, __ssv1);
    ssv1.didSelectedIndex = ^(NSUInteger idx) {
        UITableView *tv = __ssv1.contentViews[idx];
        if (!tv.dataArray.count) {
            [tv.mj_header beginRefreshing];
        } else {
            [tv reloadData];
        }
    };
    
    [self.view insertSubview:ssv1 atIndex:0];
    [ssv1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        make.width.mas_equalTo(APP.Width);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [((UITableView *)_ssv1.contentViews[_ssv1.selectedIndex]).mj_header beginRefreshing];
}

#pragma mark - IBAction

- (IBAction)onCancelBtnClick:(UIButton *)sender {
    if ([sender.tagString isEqualToString:@"取消真实姓名Button"]) {
        [NavController1 popViewControllerAnimated:true];
    } else {
        _tipsView1.hidden = true;
    }
}

// 设置真实姓名
- (IBAction)onSetRealNameBtnClick:(UIButton *)sender {
    NSString *realname = _realnameTextField.text.stringByTrim;
    if (!realname.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入真实姓名"];
    }
    __weakSelf_(__self);
    [NetworkManager1 user_profileName:realname].completionBlock = ^(CCSessionModel *sm) {
        if (!sm.error) {
            [SVProgressHUD showSuccessWithStatus:sm.responseObject[@"msg"]];
            __self.tipsView2.hidden = true;
        }
    };
}

// 联系客服
- (IBAction)onContactCustomerServiceBtnClick:(UIButton *)sender {
    [NavController1 pushVCWithUserCenterItemType:UCI_在线客服];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableView.dataArray.count;
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
    WithdrawalAcctModel *wam = tableView.dataArray[indexPath.row];
    FastSubViewCode(cell);
    subImageView(@"账户类型ImageView").image = [UIImage imageNamed:imgDict[@(wam.type).stringValue]];
    subLabel(@"账户类型Label").text = wam.name;
    switch (wam.type) {
        case UGWithdrawalTypeBankCard:
            subLabel(@"标题1Label").text = @"开户姓名：";
            subLabel(@"标题2Label").text = @"开户账号：";
            subLabel(@"标题3Label").text = @"开户地址：";
            subLabel(@"内容1Label").text = wam.username;
            subLabel(@"内容2Label").text = wam.account;
            subLabel(@"内容3Label").text = wam.countname;
            break;
        case UGWithdrawalTypeWeChat:
            subLabel(@"标题1Label").text = @"真实姓名：";
            subLabel(@"标题2Label").text = @"绑定手机号：";
            subLabel(@"标题3Label").text = @"微信号：";
            subLabel(@"内容1Label").text = wam.username;
            subLabel(@"内容2Label").text = @"";
            subLabel(@"内容3Label").text = wam.account;
            subLabel(@"标题2Label").superview.hidden = true;
            break;
        case UGWithdrawalTypeAlipay:
            subLabel(@"标题1Label").text = @"真实姓名：";
            subLabel(@"标题2Label").text = @"";
            subLabel(@"标题3Label").text = @"支付宝账号：";
            subLabel(@"内容1Label").text = wam.username;
            subLabel(@"内容2Label").text = @"";
            subLabel(@"内容3Label").text = wam.account;
            subLabel(@"标题2Label").superview.hidden = true;
            break;
        case UGWithdrawalTypeVirtual:
            subLabel(@"标题1Label").text = @"币种：";
            subLabel(@"标题2Label").text = @"链名称：";
            subLabel(@"标题3Label").text = @"钱包地址：";
            subLabel(@"内容1Label").text = wam.ownerName;
            subLabel(@"内容2Label").text = wam.countname;
            subLabel(@"内容3Label").text = wam.account;
            break;
            
        default:;
    }
    
    [subButton(@"编辑Button") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
    [subButton(@"编辑Button") addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        __self.tipsView1.hidden = false;
    }];
    return cell;
}

@end
