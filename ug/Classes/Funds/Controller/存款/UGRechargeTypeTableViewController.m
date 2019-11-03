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

@interface UGRechargeTypeTableViewController ()
@property (nonatomic, strong) UGdepositModel *mUGdepositModel;
@property (nonatomic, strong) NSMutableArray <UGpaymentModel *> *tableViewDataArray;
@end

static NSString *rechargeTypeCellid = @"UGRechargeTypeCell";
@implementation UGRechargeTypeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"UGRechargeTypeCell" bundle:nil] forCellReuseIdentifier:rechargeTypeCellid];
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 180, 0);
    
    self.tableViewDataArray = [NSMutableArray new];
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
    if (![model.pid isEqualToString:@"alihb_online"] && [model.pid containsString:@"online"]) {
        UGDepositDetailsViewController *vc = [UGDepositDetailsViewController new];
        vc.item = model;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
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
            self.mUGdepositModel = model.data;
//            NSLog(@"odel.data = %@",model.data);
            
            NSLog(@"转账提示 = %@",self.mUGdepositModel.depositPrompt);
//            self.tableViewDataArray = self.mUGdepositModel.payment;
            NSOperationQueue *waitQueue = [[NSOperationQueue alloc] init];
            [waitQueue addOperationWithBlock:^{
                for (int i = 0; i<self.mUGdepositModel.payment.count; i++) {
                    
                    UGpaymentModel *uGpaymentModel =  (UGpaymentModel*)[self.mUGdepositModel.payment objectAtIndex:i];
                    if(![CMCommon arryIsNull:uGpaymentModel.channel]){
                        [self.tableViewDataArray addObject:uGpaymentModel];
                        uGpaymentModel.quickAmount = self.mUGdepositModel.quickAmount;
                        uGpaymentModel.transferPrompt = self.mUGdepositModel.transferPrompt;
                        uGpaymentModel.depositPrompt = self.mUGdepositModel.depositPrompt;
                    }
                }
                // 同步到主线程
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self.tableView reloadData];
                });
            }];
        } failure:^(id msg) {
            [SVProgressHUD dismiss];
//            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }];
}

@end
