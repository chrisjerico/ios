//
//  UGLotteryRecordController.m
//  ug
//
//  Created by ug on 2019/6/2.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGLotteryRecordController.h"
#import "STBarButtonItem.h"
#import "YBPopupMenu.h"
#import "UGLotteryRecordTableViewCell.h"
#import "UGAllNextIssueListModel.h"
#import "UGLotteryHistoryModel.h"


@interface UGLotteryRecordController ()<YBPopupMenuDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *logoView;     /**<   彩种图标ImageView */
@property (weak, nonatomic) IBOutlet UILabel *gameNameLabel;    /**<   彩种名Label */
@property (weak, nonatomic) IBOutlet UIImageView *arrowView;    /**<   箭头ImageView */
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;        /**<   日期Label */
@property (weak, nonatomic) IBOutlet UIButton *lotteryButton;   /**<   选择彩种Button */

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) YBPopupMenu *lotteryTypePopView;  /**<   彩种选择弹框 */
@property (nonatomic, readonly) NSArray<UGAllNextIssueListModel *> *lotteryGamesArray;/**<   彩票大厅数据 */

@property (nonatomic, strong) NSMutableArray <NSString *> *dateArray;
@property (nonatomic, strong) NSMutableArray <UGNextIssueModel *> *gameArray;
@property (nonatomic, strong) NSMutableArray <NSString *> *gameNameArray;
@property (nonatomic, strong) NSMutableArray <UGLotteryHistoryModel *> *dataArray;
@property (nonatomic, assign) NSInteger selGameIndex;
@end

static NSString *lotteryRecordCellid = @"UGLotteryRecordTableViewCell";
@implementation UGLotteryRecordController

- (BOOL)允许游客访问 { return true; }

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化数据
    {
        _gameArray = [NSMutableArray array];
        _dataArray = [NSMutableArray array];
        _gameNameArray = [NSMutableArray array];
        _dateArray = [NSMutableArray array];
        
        for (int i = 0; i < 7; i++) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *currentDate = [NSDate date];
            NSTimeInterval oneDay = 24 * 60 * 60;
            NSDate *startDay = [currentDate initWithTimeIntervalSinceNow:-(oneDay * i)];
            NSString *startDateStr = [formatter stringFromDate:startDay];
            [_dateArray addObject:startDateStr];
        }
    }
    FastSubViewCode(self.view)
    if ([Skin1.skitType isEqualToString:@"黑色模板"]) {
        self.view.backgroundColor = Skin1.bgColor;
        [_gameNameLabel setTextColor:Skin1.textColor1];
        [_dateLabel setTextColor:Skin1.textColor1];
        _arrowView.image =  [UIImage imageNamed:@"baijiantou"];
        [subLabel(@"开奖号码label") setTextColor:Skin1.textColor1];
        [subLabel(@"期数label") setTextColor:Skin1.textColor1];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
        [_gameNameLabel setTextColor:[UIColor blackColor]];
        [_dateLabel setTextColor:[UIColor blackColor]];
        _arrowView.image =  [UIImage imageNamed:@"jiantou1"];
        [subLabel(@"开奖号码label") setTextColor:[UIColor blackColor]];
        [subLabel(@"期数label") setTextColor:[UIColor blackColor]];
    }
    
    self.navigationItem.title = @"开奖记录";
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"UGLotteryRecordTableViewCell" bundle:nil] forCellReuseIdentifier:lotteryRecordCellid];
    self.navigationItem.rightBarButtonItem = [STBarButtonItem barButtonItemWithImageName:@"riqi" target:self action:@selector(rightBarButonItemClick)];
    self.dateLabel.text = self.dateArray.firstObject;
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getLotteryHistory];
    }];
    
    // 初始化彩种列表数据
    {
        _lotteryGamesArray = UGAllNextIssueListModel.lotteryGamesArray;
        __weakSelf_(__self);
        void (^setupData)(void) = ^{
            for (UGAllNextIssueListModel *listModel in __self.lotteryGamesArray) {
                for (UGNextIssueModel *model in listModel.list) {
                    if ([@[@"7", @"11", @"9"] containsObject: model.gameId]) {
                        // bug fix: 52941 彩种：开奖记录中去掉秒秒彩类彩票。
                        continue;
                    }
                    if ([model.gameId isEqualToString:__self.gameId]) {
                        __self.gameNameLabel.text = model.title;
                        [__self.logoView sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:[UIImage imageNamed:@"loading"]];
                    }
                    [__self.gameArray addObject:model];
                    [__self.gameNameArray addObject:model.title];
                }
            }
            for (UGNextIssueModel *model in __self.gameArray) {
                if ([model.gameId isEqualToString:__self.gameId]) {
                    __self.selGameIndex = [__self.gameArray indexOfObject:model];
                }
            }
            [self getLotteryHistory];
        };
        if ([CMCommon arryIsNull:_lotteryGamesArray] || [CMCommon stringIsNull:_gameId]) {
            // 获取彩票大厅数据
            [CMNetwork getAllNextIssueWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
                [CMResult processWithResult:model success:^{
                    self->_lotteryGamesArray = UGAllNextIssueListModel.lotteryGamesArray = model.data;
                    
                    UGAllNextIssueListModel *model = self.lotteryGamesArray.firstObject;
                    UGNextIssueModel *game = model.list.firstObject;
                    __self.gameId = game.gameId;
                    setupData();
                    
                } failure:^(id msg) {
                    [SVProgressHUD dismiss];
                }];
            }];
        } else {
            setupData();
        }
    }
}

- (void)getLotteryHistory {
    UGNextIssueModel *model = self.gameArray[self.selGameIndex];
    BOOL lessDataType = [model.title isEqualToString:@"七星彩"] || [model.title isEqualToString:@"香港六合彩"];
    self.navigationItem.rightBarButtonItem = lessDataType ? nil : [STBarButtonItem barButtonItemWithImageName:@"riqi" target:self action:@selector(rightBarButonItemClick)];
    _dateLabel.hidden = lessDataType;
    
    
    NSDictionary *params = @{@"id":model.gameId,
                             @"date":lessDataType ? nil : self.dateLabel.text,
                             };
    [CMNetwork getLotteryHistoryWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [self.tableView.mj_header endRefreshing];
        [CMResult processWithResult:model success:^{
            self.dataArray = [((UGLotteryHistoryListModel *)model.data).list mutableCopy];
            [self.tableView reloadData];
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }];
    
}

- (IBAction)showLottetyType:(id)sender {
    CGAffineTransform transfrom = CGAffineTransformMakeRotation(M_PI);
    self.arrowView.transform = transfrom;
    YBPopupMenu *popView = [[YBPopupMenu alloc] initWithTitles:self.gameNameArray icons:nil menuWidth:CGSizeMake(150, 280) delegate:self];
    popView.fontSize = 15;
    popView.type = YBPopupMenuTypeDefault;
    [popView showRelyOnView:self.lotteryButton];
    self.lotteryTypePopView = popView;
}

- (void)rightBarButonItemClick {
    YBPopupMenu *popView = [[YBPopupMenu alloc] initWithTitles:self.dateArray icons:nil menuWidth:CGSizeMake(160, 280) delegate:self];
    popView.fontSize = 16;
    popView.type = YBPopupMenuTypeDefault;
    float y = 0;
    if ([CMCommon isPhoneX]) {
        y = 88;
    } else {
        y = 64;
    }
    [popView showAtPoint:CGPointMake(UGScreenW - 75, y + 5)];
}

#pragma mark - UITableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGLotteryRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lotteryRecordCellid forIndexPath:indexPath];
    cell.item = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGLotteryHistoryModel *model = self.dataArray.firstObject;
    if ([@"bjkl8" isEqualToString:model.gameType] ||
        [@"pk10nn" isEqualToString:model.gameType] ||
        [@"jsk3" isEqualToString:model.gameType]
        ) {
        return 100;
    }
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

#pragma mark - YBPopupMenuDelegate

- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu {
    if (index >= 0) {
        if (ybPopupMenu == self.lotteryTypePopView ) {
            UGNextIssueModel *model = self.gameArray[index];
            self.gameNameLabel.text = model.title;
            [self.logoView sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:[UIImage imageNamed:@"loading"]];
            if (self.selGameIndex != index) {
                self.selGameIndex = index;
                [self getLotteryHistory];
            }
        } else {
            self.dateLabel.text = self.dateArray[index];
            [self getLotteryHistory];
        }
    }
    if (ybPopupMenu == self.lotteryTypePopView) {
        self.arrowView.transform = CGAffineTransformMakeRotation(M_PI * 2);
    }
}

@end
