//
//  UGYubaoInComeController.m
//  ug
//
//  Created by ug on 2019/5/29.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGYubaoInComeController.h"
#import "UGYubaoIncomeTableViewCell.h"
#import "UGYuebaoProfitReportModel.h"
@interface UGYubaoInComeController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSString *startTime;
@property(nonatomic, assign) int pageSize;
@property(nonatomic, assign) int pageNumber;
@end
//分页初始值
static int page = 1;
static int size = 20;

@implementation UGYubaoInComeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageSize = size;
    self.pageNumber = page;
    self.navigationItem.title = @"收益报表";
    self.view.badgeBgColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 50;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSDate *currentDate = [NSDate date];
    NSTimeInterval oneDay = 24 * 60 * 60;
    NSDate *startDay = [currentDate initWithTimeIntervalSinceNow:-(oneDay * 3)];
    self.startTime = [formatter stringFromDate:startDay];
    [self setupRefreshView];
    
    [self getIncomeData];
}

//添加上下拉刷新
- (void)setupRefreshView
{
    WeakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageNumber = 1;
        [weakSelf getIncomeData];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getIncomeData];
    }];
    self.tableView.mj_footer.hidden = YES;
}

- (void)getIncomeData {
    if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
        return;
    }
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"page":@(self.pageNumber),
                             @"rows":@(self.pageSize),
                             @"startTime":self.startTime,
                             @"endTime":@""
                             };
    [CMNetwork yuebaoProfitReportWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            UGYuebaoProfitReportListModel *listModel = model.data;
            NSArray *array = listModel.list;
            if (self.pageNumber == 1 ) {
                
                [self.dataArray removeAllObjects];
            }
            
            [self.dataArray addObjectsFromArray:array];
            [self.tableView reloadData];
            if (array.count < self.pageSize) {
                [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
                [self.tableView.mj_footer setHidden:YES];
            }else{
                self.pageNumber ++;
                [self.tableView.mj_footer setState:MJRefreshStateIdle];
                [self.tableView.mj_footer setHidden:NO];
            }
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
        
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
        }
        
        if ([self.tableView.mj_footer isRefreshing]) {
            [self.tableView.mj_footer endRefreshing];
        }
    }];
    
    
}

#pragma mark table datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGYubaoIncomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UGYubaoIncomeTableViewCell" forIndexPath:indexPath];
    cell.item = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
