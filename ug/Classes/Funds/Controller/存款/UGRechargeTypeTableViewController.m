//
//  UGRechargeTypeTableViewController.m
//  ug
//
//  Created by ug on 2019/5/3.
//  Copyright © 2019 ug. All rights reserved.
//  存款界面==

#import "UGRechargeTypeTableViewController.h"
#import "UGRechargeTypeCell.h"
#import "UGdepositModel.h"
#import "UGDepositDetailsViewController.h"
#import "UGDepositDetailsNoLineViewController.h"
#import "UGDepositDetailsXNViewController.h"
#import "HelpDocViewController.h"
@interface UGRechargeTypeTableViewController ()
@property (nonatomic, strong) UGdepositModel *mUGdepositModel;
@property (nonatomic, strong) NSMutableArray <UGpaymentModel *> *tableViewDataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

static NSString *rechargeTypeCellid = @"UGRechargeTypeCell";
@implementation UGRechargeTypeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"充值";
    if (APP.isBgColorForMoneyVC) {
        self.tableView.backgroundColor = Skin1.bgColor;
    } else {
        self.tableView.backgroundColor = Skin1.textColor4;
    }

    [self.tableView registerNib:[UINib nibWithNibName:@"UGRechargeTypeCell" bundle:nil] forCellReuseIdentifier:rechargeTypeCellid];
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.tableFooterView = ({
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP.Width, 120)];
        v.backgroundColor = [UIColor clearColor];
        v;
    });
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
    
    self.tableViewDataArray = [NSMutableArray new];
    self.tableView.separatorColor = Skin1.isBlack ? [UIColor lightTextColor] : APP.LineColor;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.tableViewDataArray.count) {
        [self rechargeCashierData];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableViewDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGRechargeTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:rechargeTypeCellid forIndexPath:indexPath];
    UGpaymentModel *model = self.tableViewDataArray[indexPath.row];
    cell.item = model;

    if ([model.pid isEqualToString:@"xnb_online"] ) {
        [cell.mBtn setHidden:APP.isNoOnLineDoc || [APP.SiteId isEqualToString:@"c116"]];
        [cell.mBtn removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
        [cell.mBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
                //虚拟教程
            
            if ([@"c012,test61f" containsString:APP.SiteId]) {
                HelpDocViewController *vc = _LoadVC_from_storyboard_(@"HelpDocViewController");
                vc.webName = @"c012充值";
                vc.title = @"虚拟币教程";
                [NavController1 pushViewController:vc animated:true];
            } else {
                HelpDocViewController *vc = _LoadVC_from_storyboard_(@"HelpDocViewController");
                vc.webName = @"火币";
                vc.title = @"虚拟币教程";
                [NavController1 pushViewController:vc animated:true];
            }
           
        }];
    }
    else if ([model.pid isEqualToString:@"xnb_transfer"]){
        [cell.mBtn setHidden:NO];
        [cell.mBtn removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
        [cell.mBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
                //虚拟教程
            HelpDocViewController *vc = _LoadVC_from_storyboard_(@"HelpDocViewController");
            vc.webName = @"火币";
            vc.title = @"虚拟币教程";
            [NavController1 pushViewController:vc animated:true];
        }];
    }
    else {
        [cell.mBtn setHidden:YES];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UGpaymentModel *model = self.tableViewDataArray[indexPath.row];

        
        if ([model.pid isEqualToString:@"xnb_transfer"]) {

            UGDepositDetailsXNViewController *vc = _LoadVC_from_storyboard_(@"UGDepositDetailsXNViewController");
            vc.item = model;
            [NavController1 pushViewController:vc animated:true];
        }
        else if (![model.pid isEqualToString:@"alihb_online"] && [model.pid containsString:@"online"]) {
            UGDepositDetailsViewController *vc = [UGDepositDetailsViewController new];
            vc.item = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else {
            UGDepositDetailsNoLineViewController *vc = [UGDepositDetailsNoLineViewController new];
            vc.item = model;
            [self.navigationController pushViewController:vc animated:YES];
        }

}


#pragma mark -- 网络请求
//得到支付列表数据
- (void)rechargeCashierData {
    if ([UGUserModel currentUser].isTest) {
        return;
    }
    if (!UGLoginIsAuthorized()) {
        return;
    }
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid};
    
    [SVProgressHUD showWithStatus:nil];
    WeakSelf;
    [CMNetwork rechargeCashierWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            [SVProgressHUD dismiss];
            weakSelf.mUGdepositModel = model.data;
//            NSLog(@"odel.data = %@",model.data);
            
            NSLog(@"转账提示 = %@",weakSelf.mUGdepositModel.depositPrompt);
//            weakSelf.tableViewDataArray = weakSelf.mUGdepositModel.payment;
            NSOperationQueue *waitQueue = [[NSOperationQueue alloc] init];
            [waitQueue addOperationWithBlock:^{
                for (int i = 0; i<weakSelf.mUGdepositModel.payment.count; i++) {
                    
                    UGpaymentModel *uGpaymentModel =  (UGpaymentModel*)[weakSelf.mUGdepositModel.payment objectAtIndex:i];
                    if(![CMCommon arryIsNull:uGpaymentModel.channel]){
                        [weakSelf.tableViewDataArray addObject:uGpaymentModel];
                        uGpaymentModel.quickAmount = weakSelf.mUGdepositModel.quickAmount;
                        uGpaymentModel.transferPrompt = weakSelf.mUGdepositModel.transferPrompt;
                        uGpaymentModel.depositPrompt = weakSelf.mUGdepositModel.depositPrompt;
                    }
                }
                // 同步到主线程
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [weakSelf.tableView reloadData];
                });
            }];
        } failure:^(id msg) {
            [SVProgressHUD dismiss];
//            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }];
}

@end
