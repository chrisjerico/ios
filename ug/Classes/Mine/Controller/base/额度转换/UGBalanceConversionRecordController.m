//
//  UGBalanceConversionRecordController.m
//  ug
//
//  Created by ug on 2019/5/8.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGBalanceConversionRecordController.h"
#import "UGBalanceTransferLogsCell.h"
#import "UGBalanceTransferLogsModel.h"
@interface UGBalanceConversionRecordController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <UGBalanceTransferLogsModel *> *dataArray;

@property (nonatomic, strong) NSString *startTime;

@property(nonatomic, assign) int pageSize;
@property(nonatomic, assign) int pageNumber;
@end
//分页初始值
static int page = 1;
static int size = 20;
static NSString *transferLogsCellId = @"UGBalanceTransferLogsCell";
@implementation UGBalanceConversionRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageSize = size;
    self.pageNumber = page;
    [self.view setBackgroundColor: Skin1.bgColor];
    self.navigationItem.title = @"额度转换记录";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 50;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"UGBalanceTransferLogsCell" bundle:nil] forCellReuseIdentifier:transferLogsCellId];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSDate *currentDate = [NSDate date];
    NSTimeInterval oneDay = 24 * 60 * 60;
    NSDate *startDay = [currentDate initWithTimeIntervalSinceNow:-(oneDay * 15)];
    self.startTime = [formatter stringFromDate:startDay];
    
    [self setupRefreshView];
    [self getTransferLogs];
}

//添加上下拉刷新
- (void)setupRefreshView
{
    WeakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageNumber = 1;
        [weakSelf getTransferLogs];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getTransferLogs];
    }];
    self.tableView.mj_footer.hidden = YES;
    
}

- (void)getTransferLogs {
    if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
        return;
    }
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"page":@(self.pageNumber),
                             @"rows":@(self.pageSize),
                             @"startTime":self.startTime,
                             @"endTime":@""
                             };
    
    [CMNetwork transferLogsWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            UGBalanceTransferLogsListModel *listModel = model.data;
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

#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGBalanceTransferLogsCell *cell = [tableView dequeueReusableCellWithIdentifier:transferLogsCellId forIndexPath:indexPath];
    cell.item = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (NSMutableArray<UGBalanceTransferLogsModel *> *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
