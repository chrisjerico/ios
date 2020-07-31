//
//  UGNotDetailViewController.m
//  ug
//
//  Created by ug on 2020/1/4.
//  Copyright © 2020 ug. All rights reserved.
//

#import "UGNotDetailViewController.h"
#import "BetDetailViewController.h"
#import "UGBetsRecordListModel.h"

@interface UGNotDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIStackView *bottomStackView;
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
    [self setupRefreshView];
    _bottomStackView.axis = [LanguageHelper shared].isCN ? UILayoutConstraintAxisHorizontal : UILayoutConstraintAxisVertical;
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
        @"endDate":[CMCommon getDateStringWithLastDate:0],
        @"token":[UGUserModel currentUser].sessid,
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
            self.totalBetAmountLabel.text = listModel.totalBetCount;
            self.winAmountLabel.text = listModel.totalWinAmount;
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
    FastSubViewCode(cell.contentView);
    if (OBJOnceToken(cell)) {
        subLabel(@"时间Label").textColor = Skin1.isBlack ? [UIColor whiteColor] : [UIColor blackColor];
        subLabel(@"星期Label").textColor = Skin1.isBlack ? [UIColor whiteColor] : [UIColor blackColor];
        subLabel(@"笔数Label").textColor = Skin1.isBlack ? [UIColor whiteColor] : [UIColor blackColor];
        subLabel(@"中奖笔数Label").textColor = Skin1.isBlack ? [UIColor whiteColor] : [UIColor blackColor];
        subLabel(@"中奖金额Label").textColor = Skin1.isBlack ? [UIColor whiteColor] : [UIColor blackColor];
        subLabel(@"输赢Label").textColor = Skin1.isBlack ? [UIColor whiteColor] : [UIColor blackColor];
    }
    if (Skin1.isBlack) {
        cell.backgroundColor = indexPath.row%2 ? Skin1.textColor4 : Skin1.bgColor;
    } else {
        cell.backgroundColor = indexPath.row%2 ? Skin1.textColor4 : APP.BackgroundColor;
    }
    UGBetsRecordModel *pm = self.dataArray[indexPath.row];
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
    
      UGBetsRecordModel *model = self.dataArray[indexPath.row];
    
    NSLog(@"model.time = %@",model.date);
    
     NSArray  *array = [model.date componentsSeparatedByString:@" "];//--分隔符
    if (![CMCommon arryIsNull:array]) {
        NSString *date = [array objectAtIndex:0];
        
        BetDetailViewController *recordVC = _LoadVC_from_storyboard_(@"BetDetailViewController");
        recordVC.date = date;
        [NavController1 pushViewController:recordVC animated:true];

    }
}

- (NSMutableArray<UGBetsRecordModel *> *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
