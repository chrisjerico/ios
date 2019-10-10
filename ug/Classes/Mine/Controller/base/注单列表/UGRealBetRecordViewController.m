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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeightConstraint;

@property (nonatomic, strong) STButton *titleView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, assign) int pageSize;
@property(nonatomic, assign) int pageNumber;
@end

//分页初始值
static int page = 1;
static int size = 20;
static NSString *realBetRecordCellId = @"UGRealBetRecordCell";
@implementation UGRealBetRecordViewController
-(void)skin{
    [self.view setBackgroundColor: [[UGSkinManagers shareInstance] setbgColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UGBackgroundColor;
    self.navigationItem.title = @"真人注单";
    self.navigationItem.titleView = self.titleView;
    self.navigationItem.rightBarButtonItem = [STBarButtonItem barButtonItemWithImageName:@"riqi" target:self action:@selector(rightBarButtonItemClick)];
    [self.view setBackgroundColor: [[UGSkinManagers shareInstance] setbgColor]];
    
    SANotificationEventSubscribe(UGNotificationWithSkinSuccess, self, ^(typeof (self) self, id obj) {
        [self skin];
    });
    
    self.startDate = [[NSDate date] stringWithFormat:@"yyyy-MM-dd"];
    
    self.pageSize = size;
    self.pageNumber = page;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 50;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self.tableView registerNib:[UINib nibWithNibName:@"UGRealBetRecordCell" bundle:nil] forCellReuseIdentifier:realBetRecordCellId];
    
    if ([CMCommon isPhoneX]) {
        self.bottomViewHeightConstraint.constant = 70;
    }else {
        self.bottomViewHeightConstraint.constant = 50;
    }
    
    [self setupRefreshView];
    [self getBetsList];
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
    // 游戏分类：lottery=彩票，real=真人，card=棋牌，game=电子游戏，sport=体育 ，
    // 注单状态：1=待开奖，2=已中奖，3=未中奖，4=已撤单
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"category":self.gameType,
//                             @"status":self.status,
                             @"page":@(self.pageNumber),
                             @"rows":@(self.pageSize),
                             @"startDate":self.startDate,
                             @"endDate":self.startDate,
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
            self.betAmountLabel.text = [NSString stringWithFormat:@"总下注金额：%@",listModel.totalBetAmount];
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
            } else {
                self.pageNumber ++;
                [self.tableView.mj_footer setState:MJRefreshStateIdle];
                [self.tableView.mj_footer setHidden:NO];
            }
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
        
        if ([self.tableView.mj_header isRefreshing])
            [self.tableView.mj_header endRefreshing];
            
        if ([self.tableView.mj_footer isRefreshing])
            [self.tableView.mj_footer endRefreshing];
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

- (void)setupTotalAmountLabelTextColor {
    NSMutableAttributedString *abStr = [[NSMutableAttributedString alloc] initWithString:self.betAmountLabel.text];
    [abStr addAttribute:NSForegroundColorAttributeName value:UGRGBColor(240, 211, 88) range:NSMakeRange(6, self.betAmountLabel.text.length - 6)];
    self.betAmountLabel.attributedText = abStr;
}

- (void)setupWinAmountLabelTextColor {
    NSMutableAttributedString *abStr = [[NSMutableAttributedString alloc] initWithString:self.winAmountLabel.text];
    [abStr addAttribute:NSForegroundColorAttributeName value:UGRGBColor(202, 81, 66) range:NSMakeRange(6, self.winAmountLabel.text.length - 6)];
    self.winAmountLabel.attributedText = abStr;
}

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
    
    //自行创建实例方法
    MOFSPickerView *p = [MOFSPickerView new];
    p.attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:16], NSForegroundColorAttributeName : [UIColor blackColor]};
    [p showMOFSPickerViewWithCustomDataArray:@[model0, model1, model2, model3, model4] keyMapper:@"gameName" commitBlock:^(id model) {
        Model *item = (Model *)model;
        if (![self.gameType isEqualToString:item.gameType]) {
            self.gameType = item.gameType;
            [self.titleView setTitle:item.gameName forState:UIControlStateNormal];
            [self getBetsList];
        }
    } cancelBlock:nil];
}


#pragma mark - Getter

- (STButton *)titleView {
    if (_titleView == nil) {
        STButton *titleButton = [[STButton alloc] init];
        titleButton.titleSideType = STButtonTypeTitleLeft;
        [titleButton setTitle:@"真人注单" forState:UIControlStateNormal];
        [titleButton setImage:[UIImage imageNamed:@"baijiantou"] forState:UIControlStateNormal];
        [titleButton addTarget:self action:@selector(titleViewClick)];
        _titleView = titleButton;
    }
    return _titleView;
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
