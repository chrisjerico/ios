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

@property (nonatomic, strong) NSMutableArray *dateArray;
@property (nonatomic, strong) NSMutableArray *gameArray;
@property (nonatomic, strong) NSMutableArray *gameNameArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger selGameIndex;

@end

static NSString *lotteryRecordCellid = @"UGLotteryRecordTableViewCell";
@implementation UGLotteryRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"开奖记录";
    self.view.backgroundColor = UGBackgroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"UGLotteryRecordTableViewCell" bundle:nil] forCellReuseIdentifier:lotteryRecordCellid];
    self.navigationItem.rightBarButtonItem = [STBarButtonItem barButtonItemWithImageName:@"riqi" target:self action:@selector(rightBarButonItemClick)];
    self.dateLabel.text = self.dateArray.firstObject;
    
    if ([CMCommon arryIsNull:_lotteryGamesArray  ]) {
        [self getAllNextIssueData];
    }
    else{
        for (UGAllNextIssueListModel *listModel in self.lotteryGamesArray) {
            for (UGNextIssueModel *model in listModel.list) {
                if ([model.gameId isEqualToString:self.gameId]) {
                    self.gameNameLabel.text = model.title;
                    [self.logoView sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:[UIImage imageNamed:@"loading"]];
                }
                [self.gameArray addObject:model];
                [self.gameNameArray addObject:model.title];
            }
        }
        for (UGNextIssueModel *model in self.gameArray) {
            if ([model.gameId isEqualToString:self.gameId]) {
                self.selGameIndex = [self.gameArray indexOfObject:model];
            }
        }
        [self getLotteryHistory];
    }
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getLotteryHistory];
    }];
    
    
 
}

- (void)getLotteryHistory {
    UGNextIssueModel *model = self.gameArray[self.selGameIndex];
    NSDictionary *params = @{@"id":model.gameId,
                             @"date":self.dateLabel.text
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

- (NSMutableArray *)dateArray {
    if (_dateArray == nil) {
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
    return _dateArray;

}

- (NSMutableArray *)gameArray {
    if (_gameArray == nil) {
        _gameArray = [NSMutableArray array];
    }
    return _gameArray;
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)gameNameArray {
    if (_gameNameArray == nil) {
        _gameNameArray = [NSMutableArray array];
    }
    return _gameNameArray;
}


- (void)getAllNextIssueData {
    
    [CMNetwork getAllNextIssueWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            self->_lotteryGamesArray = model.data;
            
             UGAllNextIssueListModel *model = self.lotteryGamesArray.firstObject;
            UGNextIssueModel *game = model.list.firstObject;
            self->_gameId = game.gameId;
            
            for (UGAllNextIssueListModel *listModel in self.lotteryGamesArray) {
                for (UGNextIssueModel *model in listModel.list) {
                    if ([model.gameId isEqualToString:self.gameId]) {
                        self.gameNameLabel.text = model.title;
                        [self.logoView sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:[UIImage imageNamed:@"loading"]];
                    }
                    [self.gameArray addObject:model];
                    [self.gameNameArray addObject:model.title];
                }
            }
            for (UGNextIssueModel *model in self.gameArray) {
                if ([model.gameId isEqualToString:self.gameId]) {
                    self.selGameIndex = [self.gameArray indexOfObject:model];
                }
            }
            [self getLotteryHistory];
            
        } failure:^(id msg) {
            
        }];
    }];
    
}
@end
