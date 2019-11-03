//
//  UGMailBoxTableViewController.m
//  ug
//
//  Created by ug on 2019/5/7.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGMailBoxTableViewController.h"
#import "UGMessageTableViewCell.h"
#import "QDAlertView.h"
#import "UGMessageModel.h"
#import "MJRefresh.h"

@interface UGMailBoxTableViewController ()

@property (nonatomic, strong) NSMutableArray <UGMessageModel *> *dataArray;
@property(nonatomic, assign) int pageSize;
@property(nonatomic, assign) int pageNumber;
@end
//分页初始值
static int page = 1;
static int size = 20;
static NSString *messageCellid = @"UGMessageTableViewCell";
@implementation UGMailBoxTableViewController

- (BOOL)允许游客访问 { return true; }

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.navigationItem.title = @"站内信";
    self.pageSize = size;
    self.pageNumber = page;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"UGMessageTableViewCell" bundle:nil] forCellReuseIdentifier:messageCellid];
    self.tableView.rowHeight = 44;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    [self setupRefreshView];
    [self loadMessageList];
}

//添加上下拉刷新
- (void)setupRefreshView
{
    WeakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageNumber = 1;
        [weakSelf loadMessageList];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMessageList];
    }];
    self.tableView.mj_footer.hidden = YES;
    
}

- (void)loadMessageList {
    if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
        return;
    }
    NSDictionary *params = @{@"page":@(self.pageNumber),
                             @"rows":@(self.pageSize),
                             @"token":[UGUserModel currentUser].sessid,
                             @"type":@""
                             };
    
    [CMNetwork getMessageListWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            UGMessageListModel *message = model.data;
            NSArray *array = message.list;
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

- (void)modifyMessageState:(UGMessageModel *)item {
    if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
        return;
    }
    NSDictionary *params = @{@"id":item.messageId,
                             @"token":[UGUserModel currentUser].sessid,
                             };
    [CMNetwork modifyMessageStateWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            item.isRead = YES;
            [self.tableView reloadData];
            SANotificationEventPost(UGNotificationGetUserInfo, nil);
        } failure:^(id msg) {
            [SVProgressHUD dismiss];
        }];
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
    UGMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:messageCellid forIndexPath:indexPath];
    cell.item = self.dataArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UGMessageModel *model = self.dataArray[indexPath.row];
    [QDAlertView showWithTitle:model.title message:model.content];
    if (model.isRead == 0) {
        
        [self modifyMessageState:model];
    }

}

- (NSMutableArray<UGMessageModel *> *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];

    }
    
    return _dataArray;
}

@end
