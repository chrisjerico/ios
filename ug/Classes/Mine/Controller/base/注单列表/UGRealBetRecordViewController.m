//
//  UGRealBetRecordViewController.m
//  ug
//
//  Created by ug on 2019/7/23.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGRealBetRecordViewController.h"

// Tool
#import "MOFSPickerManager.h"

// Model
#import "UGBetsRecordListModel.h"

// View
#import "SRActionSheet.h"
#import "UGRealBetRecordCell.h"
#import "STBarButtonItem.h"
#import "YBPopupMenu.h"
#import "STButton.h"
#import "UGCalenderAlertView.h"  // 日历控件


@implementation Model

@end

@interface UGRealBetRecordViewController ()<UITableViewDelegate,UITableViewDataSource,YBPopupMenuDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *betAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *winAmountLabel;
@property (weak, nonatomic) IBOutlet UIStackView *bottomStackView;

@property (nonatomic, strong) STButton *titleView;

@property (nonatomic, strong) NSMutableArray <UGBetsRecordModel *> *dataArray;
@property(nonatomic, assign) int pageSize;
@property(nonatomic, assign) int pageNumber;
@end

//分页初始值
static int page = 1;
static int size = 20;
static NSString *realBetRecordCellId = @"UGRealBetRecordCell";
@implementation UGRealBetRecordViewController
-(void)skin{
    [self.view setBackgroundColor: Skin1.bgColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!_gameType.length) {
        _gameType = @"real";
    }
    self.view.backgroundColor = Skin1.bgColor;

    self.navigationItem.titleView = self.titleView;
    self.navigationItem.rightBarButtonItem = [STBarButtonItem barButtonItemWithImageName:@"riqi" target:self action:@selector(rightBarButtonItemClick)];
    [self.view setBackgroundColor: Skin1.bgColor];
    
    SANotificationEventSubscribe(UGNotificationWithSkinSuccess, self, ^(typeof (self) self, id obj) {
        [self skin];
    });
    
    FastSubViewCode(self.view);
    [self.view setBackgroundColor:Skin1.textColor4];
    [subLabel(@"游戏label") setTextColor:Skin1.textColor1];
    [subLabel(@"时间label") setTextColor:Skin1.textColor1];
    [subLabel(@"下注金额label") setTextColor:Skin1.textColor1];
    [subLabel(@"输赢label") setTextColor:Skin1.textColor1];
    [self.tableView setBackgroundColor:Skin1.textColor4];
    
    self.startDate = [[NSDate date] stringWithFormat:@"yyyy-MM-dd"];
    
    self.pageSize = size;
    self.pageNumber = page;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 50;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.separatorColor = Skin1.isBlack ? [UIColor lightTextColor] : APP.LineColor;
    [self.tableView registerNib:[UINib nibWithNibName:@"UGRealBetRecordCell" bundle:nil] forCellReuseIdentifier:realBetRecordCellId];
    
    [self setupRefreshView];
    [self getBetsList];
    _bottomStackView.axis = [LanguageHelper shared].isCN ? UILayoutConstraintAxisHorizontal : UILayoutConstraintAxisVertical;
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

- (void)getBetsList {
    // 游戏分类：lottery=彩票，real=真人，card=棋牌，game=电子游戏，sport=体育 ，esport 电竞 fish捕鱼
    // 注单状态：1=待开奖，2=已中奖，3=未中奖，4=已撤单
    if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
        return;
    }
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"category":self.gameType,
//                             @"status":self.status,
                             @"page":@(self.pageNumber),
                             @"rows":@(self.pageSize),
                             @"startDate":self.startDate,
                             @"endDate":self.startDate,
                             };
    __weakSelf_(__self);
    [CMNetwork getBetsListWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            if (!model.data) {
                [__self.dataArray removeAllObjects];
                [__self.tableView reloadData];
                return ;
            }
            UGBetsRecordListModel *listModel = model.data;
            NSArray *array = listModel.list;
            __self.betAmountLabel.text = listModel.totalBetAmount;
            __self.winAmountLabel.text = listModel.totalWinAmount;
            if (__self.pageNumber == 1 ) {
                [__self.dataArray removeAllObjects];
            }
            [__self.dataArray addObjectsFromArray:array];
            [__self.tableView reloadData];
            
            if (array.count < __self.pageSize) {
                [__self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
                [__self.tableView.mj_footer setHidden:YES];
            } else {
                __self.pageNumber ++;
                [__self.tableView.mj_footer setState:MJRefreshStateIdle];
                [__self.tableView.mj_footer setHidden:NO];
            }
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
            NSLog(@"错误信息：%@",msg);
        }];
        
        if ([__self.tableView.mj_header isRefreshing])
            [__self.tableView.mj_header endRefreshing];
            
        if ([__self.tableView.mj_footer isRefreshing])
            [__self.tableView.mj_footer endRefreshing];
    }];
    
}

- (void)rightBarButtonItemClick {
    static NSDate *selectedDate = nil;
    if (OBJOnceToken(self)) {
        selectedDate = [NSDate date];
    }
    
    // 选择日期
    __weakSelf_(__self);
    UGCalenderAlertView *cav = _LoadView_from_nib_(@"UGCalenderAlertView");
    cav.selectedDate = selectedDate;
    cav.didSelectedDate = ^(NSDate *date) {
        selectedDate = date;
        __self.startDate = [date stringWithFormat:@"yyyy-MM-dd"];
        [__self getBetsList];
    };
    [cav show];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGRealBetRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:realBetRecordCellId forIndexPath:indexPath];
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
}


#pragma mark - YBPopupMenuDelegate

- (void)titleViewClick {
    Model *model0 = [Model new];
    model0.gameName = @"真人注单";
    model0.gameType = @"real";
    
    Model *model1 = [Model new];
    model1.gameName = @"棋牌注单";
    model1.gameType = @"card";
    
    Model *model2 = [Model new];
    model2.gameName = @"电子注单";
    model2.gameType = @"game";
    
    Model *model3 = [Model new];
    model3.gameName = @"体育注单";
    model3.gameType = @"sport";
    
    Model *model4 = [Model new];
    model4.gameName = @"捕鱼注单";
    model4.gameType = @"fish";
    
    Model *model5 = [Model new];
    model5.gameName = @"电竞注单";
    model5.gameType = @"esport";
    
    //自行创建实例方法
    __weakSelf_(__self);
    MOFSPickerView *p = [MOFSPickerView new];
    p.attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:16], NSForegroundColorAttributeName : [UIColor blackColor]};
    [p showMOFSPickerViewWithCustomDataArray:@[model0, model1, model2, model3, model4, model5] keyMapper:@"gameName" commitBlock:^(id model) {
        Model *item = (Model *)model;
        if (![__self.gameType isEqualToString:item.gameType]) {
            __self.gameType = item.gameType;
            [__self.titleView setTitle:item.gameName forState:UIControlStateNormal];
            [__self.tableView.mj_header beginRefreshing];
        }
    } cancelBlock:^{}];
}


#pragma mark - Getter

- (STButton *)titleView {
    if (_titleView == nil) {
        STButton *titleButton = [[STButton alloc] init];
        titleButton.titleSideType = STButtonTypeTitleLeft;
        
        if ([self.gameType isEqualToString:@"real"]) {
            [titleButton setTitle:@"真人注单" forState:UIControlStateNormal];
        }
        else if([self.gameType isEqualToString:@"card"]) {
            
            [titleButton setTitle:@"棋牌注单" forState:UIControlStateNormal];
        }
        else if([self.gameType isEqualToString:@"game"]) {
            [titleButton setTitle:@"电子注单" forState:UIControlStateNormal];
        }
        else if([self.gameType isEqualToString:@"sport"]) {
            [titleButton setTitle:@"体育注单" forState:UIControlStateNormal];
        }
        else if([self.gameType isEqualToString:@"fish"]) {
            [titleButton setTitle:@"捕鱼注单" forState:UIControlStateNormal];
        }
        else if([self.gameType isEqualToString:@"esport"]) {
            [titleButton setTitle:@"电竞注单" forState:UIControlStateNormal];
        }
        else {
            [titleButton setTitle:@"真人注单" forState:UIControlStateNormal];
        }
        
        [titleButton setImage:[UIImage imageNamed:@"baijiantou"] forState:UIControlStateNormal];
        [titleButton addTarget:self action:@selector(titleViewClick)];
        _titleView = titleButton;
    }
    return _titleView;
}

- (NSMutableArray<UGBetsRecordModel *> *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
