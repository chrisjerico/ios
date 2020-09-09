//
//  UGBetRecordTableViewController.m
//  ug
//
//  Created by ug on 2019/5/17.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGBetRecordTableViewController.h"
#import "UGBetRecordDetailViewController.h"
#import "UGBetRecordViewController.h"
#import "UGBetRecorddHeaderView.h"
#import "UGBetsRecordListModel.h"
#import "UGLotteryRecordCell.h"
#import "CountDown.h"

@interface UGBetRecordTableViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIStackView *bottomStackView;
@property (weak, nonatomic) IBOutlet UILabel *totalBetAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *winAmountLabel;

@property (nonatomic, strong) CountDown *countDown;
@property (nonatomic, strong) NSMutableArray <UGBetsRecordModel *> *dataArray;
@property(nonatomic, assign) int pageSize;
@property(nonatomic, assign) int pageNumber;
@end

//分页初始值
static int page = 1;
static int size = 20;
static NSString *betRecordCellid = @"UGLotteryRecordCell";
@implementation UGBetRecordTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"彩票注单记录";
    self.pageSize = size;
    self.pageNumber = page;
    self.tableView.backgroundColor = Skin1.textColor4;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 44;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 220, 0);
    [self.tableView registerNib:[UINib nibWithNibName:@"UGLotteryRecordCell" bundle:nil] forCellReuseIdentifier:betRecordCellid];
    UIView *footerVC = [[UIView alloc] init];
    footerVC.backgroundColor = [UIColor whiteColor];
    footerVC.size = CGSizeMake(UGScreenW, 44);
    UIButton *button = [[UIButton alloc] initWithFrame:footerVC.bounds];
    [button setTitle:@"查看更多" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showBetRrecordList) forControlEvents:UIControlEventTouchUpInside];
    [footerVC addSubview:button];
    self.tableView.tableFooterView = footerVC;
    self.tableView.tableFooterView.hidden = YES;
    self.countDown = [[CountDown alloc] init];
    
    [self setupRefreshView];
    _bottomStackView.axis = [LanguageHelper shared].isCN ? UILayoutConstraintAxisHorizontal : UILayoutConstraintAxisVertical;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([@"2" isEqualToString:self.status] || [@"3" isEqualToString:self.status]) {
        self.winAmountLabel.hidden = NO;
    } else {
        self.winAmountLabel.hidden = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.countDown destoryTimer];
}

- (void)setupRefreshView
{
    WeakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageNumber = 1;
        [weakSelf getBetsList];
        
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getBetsList];
    }];
    self.tableView.mj_footer.hidden = YES;
    
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];

}

- (void)setLoadData:(BOOL)loadData {
    _loadData = loadData;
    if (loadData && self.status && self.startDate && self.gameType) {
         // 马上进入刷新状态
        __weakSelf_(__self);
        dispatch_async(dispatch_get_main_queue(), ^{
           // UI更新代码
           [__self.tableView.mj_header beginRefreshing];
        });
        
    }
}

- (void)getBetsList {
    // 游戏分类：lottery=彩票，real=真人，card=棋牌，game=电子游戏，sport=体育 ，
    // 注单状态：1=待开奖，2=已中奖，3=未中奖，4=已撤单
    self.tableView.mj_footer.hidden = YES;
    if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
        return;
    }
    __weakSelf_(__self);
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"category":self.gameType,
                             @"status":self.status,
                             @"page":@(self.pageNumber),
                             @"rows":@(self.pageSize),
                             @"startDate":self.startDate,
                             @"endDate":@""
                             };
    [CMNetwork getBetsListWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        
        [CMResult processWithResult:model success:^{
            
            if (!model.data) {
                [__self.dataArray removeAllObjects];
                [__self.tableView reloadData];
                return ;
            }
            UGBetsRecordListModel *listModel = model.data;
            NSArray *array = listModel.list;
            __self.totalBetAmountLabel.text = listModel.totalBetAmount;
            __self.winAmountLabel.text = listModel.totalWinAmount;
            if (__self.pageNumber == 1 ) {
                [__self.dataArray removeAllObjects];
            }
            
            [__self.dataArray addObjectsFromArray:array];
            [__self.tableView reloadData];
            
            if (array.count < __self.pageSize) {
                [__self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
                [__self.tableView.mj_footer setHidden:YES];
            }else{
                __self.pageNumber ++;
                [__self.tableView.mj_footer setState:MJRefreshStateIdle];
                [__self.tableView.mj_footer setHidden:NO];
            }
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
        
        if ([__self.tableView.mj_header isRefreshing]) {
            [__self.tableView.mj_header endRefreshing];
        }
        
        if ([__self.tableView.mj_footer isRefreshing]) {
            [__self.tableView.mj_footer endRefreshing];
        }
    }];
    
}

- (void)cancelBetWith:(UGBetsRecordModel *)model {
    if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
        return;
    }
    __weakSelf_(__self);
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"orderId":model.betId
                             };
    [SVProgressHUD showWithStatus:nil];
    [CMNetwork cancelBetWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            [SVProgressHUD showSuccessWithStatus:model.msg];
            [__self.dataArray removeObject:model];
            [__self.tableView reloadData];
            [__self getBetsList];
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }];
}

- (void)setShowFooterView:(BOOL)showFooterView {
    _showFooterView = showFooterView;
    self.tableView.tableFooterView.hidden = !showFooterView;
}

- (void)showBetRrecordList {
    UGBetRecordViewController *recordVC = [[UGBetRecordViewController alloc] init];
    [self.navigationController pushViewController:recordVC animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGLotteryRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:betRecordCellid forIndexPath:indexPath];
    UGBetsRecordModel *model = self.dataArray[indexPath.row];
    cell.item = model;
    if (Skin1.isBlack) {
        cell.backgroundColor = indexPath.row%2 ? Skin1.textColor4 : Skin1.bgColor;
    } else {
        cell.backgroundColor = indexPath.row%2 ? Skin1.textColor4 : APP.BackgroundColor;
    }
    WeakSelf
    cell.cancelBlock = ^{
        [QDAlertView showWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"您要撤销注单号%@订单吗？",model.betId] cancelButtonTitle:@"取消" otherButtonTitle:@"确定" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf cancelBetWith:model];
                });
            }
        }];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.showFooterView) {
        return 20;
    }
    return 0.001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSMutableArray<UGBetsRecordModel *> *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
