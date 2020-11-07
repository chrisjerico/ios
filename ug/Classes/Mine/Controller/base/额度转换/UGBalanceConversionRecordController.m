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
#import "UITableView+LSEmpty.h"
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
    
    FastSubViewCode(self.view);
    subLabel(@"游戏TitleLabel").textColor = Skin1.textColor1;
    subLabel(@"金额TitleLabel").textColor = Skin1.textColor1;
    subLabel(@"日期TitleLabel").textColor = Skin1.textColor1;
    subLabel(@"模式TitleLabel").textColor = Skin1.textColor1;
    
    self.tableView.startTip = YES;
    self.tableView.tipTitle = @"暂无更多数据";
    
    // 刷新额度转换记录
    SANotificationEventSubscribe(UGNotificationGetUserInfoComplete, self, ^(typeof (self) self, id obj) {
        [self getTransferLogs];
    });
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
    WeakSelf;
    [CMNetwork transferLogsWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            UGBalanceTransferLogsListModel *listModel = model.data;
            NSArray *array = listModel.list;
            if (weakSelf.pageNumber == 1 ) {
                
                [weakSelf.dataArray removeAllObjects];
            }
            
            [weakSelf.dataArray addObjectsFromArray:array];
            [weakSelf.tableView reloadData];
            if (array.count < weakSelf.pageSize) {
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
            [weakSelf.tableView.mj_footer endRefreshing];
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
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (NSMutableArray<UGBalanceTransferLogsModel *> *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
