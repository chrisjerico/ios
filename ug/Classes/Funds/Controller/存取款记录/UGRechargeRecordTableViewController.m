//
//  UGRechargeRecordTableViewController.m
//  ug
//
//  Created by ug on 2019/5/3.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGRechargeRecordTableViewController.h"
#import "UGRechargeRecordCell.h"
#import "UGFundDetailsCell.h"
#import "UGRechargeLogsModel.h"
#import "UGFundRecordDetailView.h"
#import "UGWithdrawRecordDetailView.h"
@interface UGRechargeRecordTableViewController ()

@property (nonatomic, strong) NSMutableArray <UGRechargeLogsModel *> *dataArray;
@property (nonatomic, strong) NSString *startTime;

@property(nonatomic, assign) int pageSize;
@property(nonatomic, assign) int pageNumber;
@end
//分页初始值
static int page = 1;
static int size = 20;

static NSString *fundDetailsCell = @"UGFundDetailsCell";
static NSString *rechargeRecordCellid = @"UGRechargeRecordCell";
@implementation UGRechargeRecordTableViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    SANotificationEventSubscribe(UGNotificationWithdrawalsSuccess, self, ^(typeof (self) self, id obj) {
        [self getWithdrawData];
    });
    
    SANotificationEventSubscribe(UGNotificationWithRecordOfDeposit, self, ^(typeof (self) self, id obj) {
        // 马上进入刷新状态
        [self.tableView.mj_header beginRefreshing];
    });
    [self.view setBackgroundColor: Skin1.bgColor];
    self.pageSize = size;
    self.pageNumber = page;
    self.tableView.rowHeight = 50;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 120, 0);
    [self.tableView registerNib:[UINib nibWithNibName:@"UGFundDetailsCell" bundle:nil] forCellReuseIdentifier:fundDetailsCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"UGRechargeRecordCell" bundle:nil] forCellReuseIdentifier:rechargeRecordCellid];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSDate *currentDate = [NSDate date];
    NSTimeInterval oneDay = 24 * 60 * 60;
    NSDate *startDay = [currentDate initWithTimeIntervalSinceNow:-(oneDay * 30)];
    self.startTime = [formatter stringFromDate:startDay];
    
    [self setupRefreshView];
    if (self.recordType == RecordTypeWithdraw) {
        [self getWithdrawData];
    } else {
        [self getRechargeData];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

//添加上下拉刷新
- (void)setupRefreshView
{
    WeakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageNumber = 1;
        if (weakSelf.recordType == RecordTypeWithdraw) {
            [weakSelf getWithdrawData];
        }else {
            
            [weakSelf getRechargeData];
        }
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (weakSelf.recordType == RecordTypeWithdraw) {
            [weakSelf getWithdrawData];
        }else {
            
            [weakSelf getRechargeData];
        }
    }];
    self.tableView.mj_footer.hidden = YES;
    
}

- (void)getRechargeData {
    if (UserI.isTest) {
        return;
    }
    if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
        return;
    }
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"page":@(self.pageNumber),
                             @"rows":@(self.pageSize),
                             @"startTime":self.startTime,
                             @"endTime":@""
                             };
    WeakSelf;
    [CMNetwork rechargeLogsWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            UGRechargeLogsListModel *listModel = model.data;
            NSArray *array = listModel.list;
            if (weakSelf.pageNumber == 1 ) {
                
                [weakSelf.dataArray removeAllObjects];
            }
            
            [weakSelf.dataArray addObjectsFromArray:array];
            [weakSelf.tableView reloadData];
            if (array.count < self.pageSize) {
                [weakSelf.tableView.mj_footer setState:MJRefreshStateNoMoreData];
                [weakSelf.tableView.mj_footer setHidden:YES];
            }else{
                weakSelf.pageNumber ++;
                [weakSelf.tableView.mj_footer setState:MJRefreshStateIdle];
                [weakSelf.tableView.mj_footer setHidden:NO];
            }
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
        
        if ([weakSelf.tableView.mj_header isRefreshing]) {
            [weakSelf.tableView.mj_header endRefreshing];
        }
        
        if ([weakSelf.tableView.mj_footer isRefreshing]) {
            [weakSelfweakSelf.tableView.mj_footer endRefreshing];
        }
    }];
    
}
//取款
- (void)getWithdrawData {
    if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
        return;
    }
    if ([UGUserModel currentUser].isTest) {
        return;
    }
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"page":@(self.pageNumber),
                             @"rows":@(self.pageSize),
                             @"startTime":self.startTime,
                             @"endTime":@""
                             };
    WeakSelf;
    [CMNetwork withdrawLogsWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            UGRechargeLogsListModel *listModel = model.data;
            NSArray *array = listModel.list;
            if (weakSelf.pageNumber == 1 ) {
                
                [weakSelf.dataArray removeAllObjects];
            }
            
            [weakSelf.dataArray addObjectsFromArray:array];
            [weakSelf.tableView reloadData];
            if (array.count < self.pageSize) {
                [weakSelf.tableView.mj_footer setState:MJRefreshStateNoMoreData];
                [weakSelf.tableView.mj_footer setHidden:YES];
            }else{
                weakSelf.pageNumber ++;
                [weakSelf.tableView.mj_footer setState:MJRefreshStateIdle];
                [weakSelf.tableView.mj_footer setHidden:NO];
            }
        } failure:^(id msg) {
//            [SVProgressHUD showErrorWithStatus:msg];
        }];
        
        if ([weakSelf.tableView.mj_header isRefreshing]) {
            [weakSelf.tableView.mj_header endRefreshing];
        }
        
        if ([weakSelf.tableView.mj_footer isRefreshing]) {
            [weakSelf.tableView.mj_footer endRefreshing];
        }
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.recordType == RecordTypeWithdraw) {
        //1
        UGRechargeRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:rechargeRecordCellid forIndexPath:indexPath];
        cell.item = self.dataArray[indexPath.row];
        return cell;
    }else {
        UGFundDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:fundDetailsCell forIndexPath:indexPath];
        cell.rechargeitem = self.dataArray[indexPath.row];
        return cell;
    }
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (self.recordType == RecordTypeWithdraw) {
       //1
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UGScreenW, 44)];
        headerView.backgroundColor = Skin1.textColor4;
        UILabel *timeLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, UGScreenW / 3, 44)];
        timeLable.text = @"时间";
        timeLable.textColor = Skin1.textColor1;
        timeLable.font = [UIFont systemFontOfSize:14 weight:UIFontWeightHeavy];
        timeLable.textAlignment = NSTextAlignmentCenter;
        
        UILabel *amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(timeLable.frame) + 10, 0, (UGScreenW - CGRectGetMaxX(timeLable.frame) - 10) / 2, 44)];
        amountLabel.text = @"金额";
        amountLabel.textColor = Skin1.textColor1;
        amountLabel.textAlignment = NSTextAlignmentCenter;
        amountLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightHeavy];
        
        UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(amountLabel.frame), 0, UGScreenW - CGRectGetMaxX(amountLabel.frame), 44)];
        stateLabel.text = @"状态";
        stateLabel.textAlignment = NSTextAlignmentCenter;
        stateLabel.textColor = Skin1.textColor1;
        stateLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightHeavy];
        

        
        [headerView addSubview:timeLable];
        [headerView addSubview:amountLabel];
        [headerView addSubview:stateLabel];

        
        return headerView;
    }else {
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UGScreenW, 44)];
        headerView.backgroundColor = Skin1.textColor4;
        UILabel *timeLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, UGScreenW / 4, 44)];
        timeLable.text = @"时间";
        timeLable.textColor = Skin1.textColor1;
        timeLable.font = [UIFont systemFontOfSize:14 weight:UIFontWeightHeavy];
        timeLable.textAlignment = NSTextAlignmentCenter;
        
        UILabel *amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(timeLable.frame), 0,UGScreenW / 4, 44)];
        amountLabel.text = @"金额";
        amountLabel.textColor = Skin1.textColor1;
        amountLabel.textAlignment = NSTextAlignmentCenter;
        amountLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightHeavy];
        
        UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(amountLabel.frame), 0, UGScreenW / 4, 44)];
        stateLabel.text = @"存款方式";
        stateLabel.textAlignment = NSTextAlignmentCenter;
        stateLabel.textColor = Skin1.textColor1;
        stateLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightHeavy];
        
        UILabel *balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(stateLabel.frame), 0, UGScreenW / 4, 44)];
        balanceLabel.text = @"状态";
        balanceLabel.textAlignment = NSTextAlignmentCenter;
        balanceLabel.textColor = Skin1.textColor1;
        balanceLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightHeavy];
        
 
        
        [headerView addSubview:timeLable];
        [headerView addSubview:amountLabel];
        [headerView addSubview:stateLabel];
        [headerView addSubview:balanceLabel];
        
        return headerView;
    }
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.recordType == 0) {
        
        UGFundRecordDetailView *detailView = [[UGFundRecordDetailView alloc] initWithFrame:CGRectMake(30, (UGScerrnH - (UGScreenW * 1.2 - 60)) / 2 , UGScreenW - 60, UGScreenW * 1.2 - 60)];
        detailView.item = self.dataArray[indexPath.row];
        [detailView show];
    }else {
        UGWithdrawRecordDetailView *detailView = [[UGWithdrawRecordDetailView alloc] initWithFrame:CGRectMake(30, (UGScerrnH - (UGScreenW * 1.2 - 60)) / 2 , UGScreenW - 60, UGScreenW * 1.2 - 60)];
        detailView.item = self.dataArray[indexPath.row];
        [detailView show];
    }
}

- (NSMutableArray<UGRechargeLogsModel *> *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
