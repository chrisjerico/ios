//
//  UGBetRecordTableViewController.m
//  ug
//
//  Created by ug on 2019/5/17.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGBetRecordTableViewController.h"
#import "UGBetRecordTableViewCell.h"
#import "UGBetRecordDetailViewController.h"
#import "UGBetRecordViewController.h"
#import "UGBetRecorddHeaderView.h"
#import "UGBetsRecordListModel.h"
#import "UGLotteryRecordCell.h"
#import "CountDown.h"
@interface UGBetRecordTableViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeightConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBottomConstraints;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *totalBetAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *winAmountLabel;

@property (nonatomic, strong) CountDown *countDown;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, assign) int pageSize;
@property(nonatomic, assign) int pageNumber;
@end

//分页初始值
static int page = 1;
static int size = 20;
static NSString *betRecordCellid = @"UGLotteryRecordCell";
@implementation UGBetRecordTableViewController
-(void)skin{
    [self.view setBackgroundColor: [[UGSkinManagers shareInstance] setbgColor]];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageSize = size;
    self.pageNumber = page;
    [self.view setBackgroundColor: [[UGSkinManagers shareInstance] setbgColor]];
    SANotificationEventSubscribe(UGNotificationWithSkinSuccess, self, ^(typeof (self) self, id obj) {
        
        [self skin];
    });
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 125;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 44;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 220, 0);
    [self.tableView registerNib:[UINib nibWithNibName:@"UGLotteryRecordCell" bundle:nil] forCellReuseIdentifier:betRecordCellid];
    if ([CMCommon isPhoneX]) {
        self.bottomViewHeightConstraints.constant = 70;
        self.bottomViewBottomConstraints.constant = 85;
    }else {
        self.bottomViewHeightConstraints.constant = 50;
        self.bottomViewBottomConstraints.constant = 60;
    }
    self.bottomView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6];
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
    [self setupTotalAmountLabelTextColor];
    [self setupWinAmountLabelTextColor];
    
}

- (void)viewWillAppear:(BOOL)animated {
    if ([@"2" isEqualToString:self.status] || [@"3" isEqualToString:self.status]) {
        self.winAmountLabel.hidden = NO;
    }else {
        self.winAmountLabel.hidden = YES;
        
    }
    
    WeakSelf
    [self.countDown countDownWithSec:10 PER_SECBlock:^{
        if ([@"1" isEqualToString:self.status]) {
            
            [weakSelf getBetsList];
        }
    }];

}

- (void)viewWillDisappear:(BOOL)animated {
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

}

- (void)setLoadData:(BOOL)loadData {
    _loadData = loadData;
    if (loadData && self.status && self.startDate && self.gameType) {
        [self getBetsList];
    }
}

- (void)getBetsList {
//    游戏分类：lottery=彩票，real=真人，card=棋牌，game=电子游戏，sport=体育 ，注单状态：1=待开奖，2=已中奖，3=未中奖，4=已撤单
    self.tableView.mj_footer.hidden = YES;
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
                [self.dataArray removeAllObjects];
                [self.tableView reloadData];
                return ;
            }
            UGBetsRecordListModel *listModel = model.data;
            NSArray *array = listModel.list;
            self.totalBetAmountLabel.text = [NSString stringWithFormat:@"总下注金额：%@",listModel.totalBetAmount];
            self.winAmountLabel.text = [NSString stringWithFormat:@"总输赢金额：%@",listModel.totalWinAmount];
            [self setupTotalAmountLabelTextColor];
            [self setupWinAmountLabelTextColor];
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

- (void)cancelBetWith:(UGBetsRecordModel *)model {
    
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"orderId":model.betId
                             };
    [SVProgressHUD showWithStatus:nil];
    [CMNetwork cancelBetWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            [SVProgressHUD showSuccessWithStatus:model.msg];
            [self.dataArray removeObject:model];
            [self.tableView reloadData];
            [self getBetsList];
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

- (void)setupTotalAmountLabelTextColor {
    
    NSMutableAttributedString *abStr = [[NSMutableAttributedString alloc] initWithString:self.totalBetAmountLabel.text];
    [abStr addAttribute:NSForegroundColorAttributeName value:UGRGBColor(240, 211, 88) range:NSMakeRange(6, self.totalBetAmountLabel.text.length - 6)];
    self.totalBetAmountLabel.attributedText = abStr;
    
}

- (void)setupWinAmountLabelTextColor {
    
    NSMutableAttributedString *abStr = [[NSMutableAttributedString alloc] initWithString:self.winAmountLabel.text];
    [abStr addAttribute:NSForegroundColorAttributeName value:UGRGBColor(202, 81, 66) range:NSMakeRange(6, self.winAmountLabel.text.length - 6)];
    self.winAmountLabel.attributedText = abStr;
    
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
