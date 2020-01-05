//
//  UGNotDetailViewController.m
//  ug
//
//  Created by ug on 2020/1/4.
//  Copyright © 2020 ug. All rights reserved.
//

#import "UGNotDetailViewController.h"

#import "UGBetsRecordListModel.h"

@interface UGNotDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *totalBetAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *winAmountLabel;

@property (nonatomic, strong) NSMutableArray <UGBetsRecordModel *> *dataArray;
@property(nonatomic, assign) int pageSize;
@property(nonatomic, assign) int pageNumber;
@end

@implementation UGNotDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"彩票注单明细";

    self.tableView.backgroundColor = Skin1.textColor4;

    self.tableView.rowHeight = 50.0;
    //    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 220, 0);
    self.bottomView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6];
    
    [self setupRefreshView];
    [self setupTotalAmountLabelTextColor];
    [self setupWinAmountLabelTextColor];
}

- (void)setupRefreshView
{
    WeakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageNumber = 1;
        [weakSelf getBetsList];
        
    }];
    self.tableView.mj_footer.hidden = YES;
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)setLoadData:(BOOL)loadData {
    _loadData = loadData;
    if (loadData && self.startDate) {
        // 马上进入刷新状态
        dispatch_async(dispatch_get_main_queue(), ^{
            // UI更新代码
            [self.tableView.mj_header beginRefreshing];
        });
        
    }
}

- (void)getBetsList {
    
    self.tableView.mj_footer.hidden = YES;
    if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
        return;
    }
    NSDictionary *params = @{
        @"startDate":self.startDate,
        @"endDate":[CMCommon getDateStringWithLastDate:0]
    };
    NSLog(@"params= %@",params);
    [CMNetwork ticketlotteryStatisticsUrlWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        
        NSLog(@"data= %@",model.data);
        [CMResult processWithResult:model success:^{
            
            if (!model.data) {
                [self.dataArray removeAllObjects];
                [self.tableView reloadData];
                return ;
            }
            UGBetsRecordListModel *listModel = model.data;
            NSArray *array = listModel.tickets;
            self.totalBetAmountLabel.text = [NSString stringWithFormat:@"总笔数：%@",listModel.totalBetCount];
            self.winAmountLabel.text = [NSString stringWithFormat:@"总输赢金额：%@",listModel.totalWinAmount];
            [self setupTotalAmountLabelTextColor];
            [self setupWinAmountLabelTextColor];
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:array];
            [self.tableView reloadData];
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
        
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (Skin1.isBlack) {
        cell.backgroundColor = indexPath.row%2 ? Skin1.textColor4 : Skin1.bgColor;
    } else {
        cell.backgroundColor = indexPath.row%2 ? Skin1.textColor4 : APP.BackgroundColor;
    }
    UGBetsRecordModel *pm = self.dataArray[indexPath.row];
    FastSubViewCode(cell.contentView);
    subLabel(@"时间Label").text = pm.date;
    subLabel(@"星期Label").text = pm.dayOfWeek;
    subLabel(@"笔数Label").text = pm.betCount;
    subLabel(@"中奖笔数Label").text = pm.winCount;
    subLabel(@"中奖金额Label").text = pm.winAmount;
    subLabel(@"输赢Label").text = pm.winLoseAmount;
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)setupTotalAmountLabelTextColor {
    NSMutableAttributedString *abStr = [[NSMutableAttributedString alloc] initWithString:self.totalBetAmountLabel.text];
    [abStr addAttribute:NSForegroundColorAttributeName value:UGRGBColor(240, 211, 88) range:NSMakeRange(4, self.totalBetAmountLabel.text.length - 4)];
    self.totalBetAmountLabel.attributedText = abStr;
}

- (void)setupWinAmountLabelTextColor {
    NSMutableAttributedString *abStr = [[NSMutableAttributedString alloc] initWithString:self.winAmountLabel.text];
    [abStr addAttribute:NSForegroundColorAttributeName value:UGRGBColor(202, 81, 66) range:NSMakeRange(6, self.winAmountLabel.text.length - 6)];
    self.winAmountLabel.attributedText = abStr;
}

- (NSMutableArray<UGBetsRecordModel *> *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
