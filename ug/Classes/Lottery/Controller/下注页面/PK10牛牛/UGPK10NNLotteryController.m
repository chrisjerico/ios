//
//  UGPK10LotteryController.m
//  ug
//
//  Created by ug on 2019/6/17.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGPK10NNLotteryController.h"
#import "UGTimeLotteryLeftTitleCell.h"
#import "UGTimeLotteryBetCollectionViewCell.h"
#import "UGTimeLotteryBetHeaderView.h"
#import "UGLotteryResultCollectionViewCell.h"
#import "UGLotterySubResultCollectionViewCell.h"
#import "UGGameplayModel.h"
#import "YBPopupMenu.h"
#import "UGBetDetailView.h"
#import "STBarButtonItem.h"
#import "CountDown.h"
#import "UGAllNextIssueListModel.h"
#import "STBarButtonItem.h"
#import "UGMailBoxTableViewController.h"
#import "UGChangLongController.h"
#import "UGRightMenuView.h"
#import "UGFundsViewController.h"
#import "UGBetRecordViewController.h"
#import "UGLotteryRulesView.h"
#import "WSLWaterFlowLayout.h"
#import "UGPK10SubResultCollectionViewCell.h"
#import "UGLotteryRecordController.h"

#import "UGLotteryAdPopView.h"
#import "UGPCDDLotteryController.h"
#import "UGJSK3LotteryController.h"
#import "UGHKLHCLotteryController.h"
#import "UGBJPK10LotteryController.h"
#import "UGQXCLotteryController.h"
#import "UGSSCLotteryController.h"
#import "UGGD11X5LotteryController.h"
#import "UGXYNCLotteryController.h"
#import "UGBJKL8LotteryController.h"
#import "UGGDKL10LotteryController.h"
#import "UGFC3DLotteryController.h"

#import "UGYYRightMenuView.h"

@interface UGPK10NNLotteryController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,YBPopupMenuDelegate,UITextFieldDelegate,WSLWaterFlowLayoutDelegate>
@property (weak, nonatomic) IBOutlet UILabel *currentIssueLabel;
@property (weak, nonatomic) IBOutlet UIView *currentIssueCollectionBgView;
@property (weak, nonatomic) IBOutlet UILabel *nextIssueLabel;
@property (weak, nonatomic) IBOutlet UILabel *closeTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *openTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *nextIssueView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *bottomCloseView;

@property (weak, nonatomic) IBOutlet UITextField *amountTextF;
@property (weak, nonatomic) IBOutlet UILabel *selectLabel;
@property (weak, nonatomic) IBOutlet UIButton *chipButton;
@property (weak, nonatomic) IBOutlet UIButton *betButton;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *headerCollectionView;

@property (nonatomic, strong) UICollectionView *betCollectionView;

@property (nonatomic, strong) NSArray *chipArray;
@property (nonatomic, strong) NSMutableArray *gameDataArray;
@property (nonatomic, strong) NSIndexPath *typeIndexPath;
@property (nonatomic, strong) NSIndexPath *itemIndexPath;

@property (strong, nonatomic)  CountDown *countDown;
@property (nonatomic, strong) CountDown *nextIssueCountDown;
@property (nonatomic, strong) STBarButtonItem *rightItem1;
@property (nonatomic, strong) NSArray *preNumArray;
@property (nonatomic, strong) NSArray *preNumSxArray;
@property (nonatomic, strong) NSArray *winArray;
@property (nonatomic, strong) WSLWaterFlowLayout *headerFlow;
@property (nonatomic, assign) BOOL showAdPoppuView;

@property (strong, nonatomic)UGYYRightMenuView *yymenuView;

@end

static NSString *leftTitleCellid = @"UGTimeLotteryLeftTitleCell";
static NSString *lottryBetCellid = @"UGTimeLotteryBetCollectionViewCell";
static NSString *headerViewID = @"UGTimeLotteryBetHeaderView";
static NSString *lotteryResultCellid = @"UGLotteryResultCollectionViewCell";
static NSString *lotterySubResultCellid = @"UGPK10SubResultCollectionViewCell";
@implementation UGPK10NNLotteryController
@synthesize nextIssueModel  = _nextIssueModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.chipButton.layer.cornerRadius = 5;
    self.chipButton.layer.masksToBounds = YES;
    self.betButton.layer.cornerRadius = 5;
    self.chipButton.layer.masksToBounds = YES;
    self.resetButton.layer.cornerRadius = 5;
    self.resetButton.layer.masksToBounds = YES;
    self.amountTextF.delegate = self;
    [self.view addSubview:self.tableView];
    self.bottomCloseView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.bottomCloseView.hidden = YES;
    
    [self initBetCollectionView];
    [self initHeaderCollectionView];
    
    self.typeIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    self.itemIndexPath = nil;
    
    [self updateSelectLabelWithCount:0];
    [self setupBarButtonItems];
    SANotificationEventSubscribe(UGNotificationGetUserInfoComplete, self, ^(typeof (self) self, id obj) {
        STButton *button = (STButton *)self.rightItem1.customView;
        [button.imageView.layer removeAllAnimations];
        
        [self setupBarButtonItems];
        
    });
    [self updateCloseLabel];
    [self updateOpenLabel];
    self.chipArray = @[@"10",@"100",@"1000",@"10000",@"清除"];
    
    self.countDown = [[CountDown alloc] init];
    self.nextIssueCountDown = [[CountDown alloc] init];
    
    [self updateHeaderViewData];
    [self updateCloseLabel];
    [self updateOpenLabel];
    [self getGameDatas];
    [self getNextIssueData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view bringSubviewToFront:self.bottomView];
    WeakSelf
    // 轮循刷新封盘时间、开奖时间
    static NSTimer *timer = nil;
    [timer invalidate];
    timer = [NSTimer scheduledTimerWithInterval:0.2 repeats:true block:^(NSTimer *timer) {
        [weakSelf updateCloseLabelText];
        [weakSelf updateOpenLabelText];
        if (!weakSelf) {
            [timer invalidate];
            timer = nil;
        }
    }];
    // 轮循请求下期数据
    [self.nextIssueCountDown countDownWithSec:NextIssueSec PER_SECBlock:^{
        UGNextIssueModel *nim = weakSelf.nextIssueModel;
        if ([[nim.curOpenTime dateWithFormat:@"yyyy-MM-dd HH:mm:ss"] timeIntervalSinceDate:[NSDate date]] < 0
            || nim.curIssue.intValue != nim.preIssue.intValue+1) {
            [weakSelf getNextIssueData];
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.countDown destoryTimer];
    [self.nextIssueCountDown destoryTimer];
}

- (IBAction)showChatRoom:(id)sender {
    UGChatViewController *chatVC = [[UGChatViewController alloc] init];
    chatVC.gameId = _gameId;
    [self.navigationController pushViewController:chatVC animated:YES];
}

- (void)setupBarButtonItems {
    STBarButtonItem *item0 = [STBarButtonItem barButtonItemLeftWithImageName:@"shuaxin" title:[NSString stringWithFormat:@"¥%@",[[UGUserModel currentUser].balance removeFloatAllZero]] target:self action:@selector(refreshBalance)];
    self.rightItem1 = item0;
    STBarButtonItem *item1 = [STBarButtonItem barButtonItemWithImageName:@"gengduo" target:self action:@selector(showRightMenueView)];
    self.navigationItem.rightBarButtonItems = @[item1,item0];
}

- (void)getNextIssueData {
    NSDictionary *params = @{@"id":self.gameId};
    [CMNetwork getNextIssueWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            self.nextIssueModel = model.data;
            [self showAdPoppuView:model.data];
            [self updateHeaderViewData];
        } failure:^(id msg) {
            [SVProgressHUD dismiss];
        }];
    }];
}

- (void)getGameDatas {
    NSDictionary *params = @{@"id":self.gameId};
    [CMNetwork getGameDatasWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            UGPlayOddsModel *play = model.data;
            self.gameDataArray = play.playOdds.mutableCopy;
//            // 删除enable为NO的数据（不显示出来）
//            for (UGGameplayModel *gm in play.playOdds) {
//                for (UGGameplaySectionModel *gsm in gm.list) {
//                    if (!gsm.enable)
//                        [self.gameDataArray removeObject:gm];
//                }
//            }
            [self.tableView reloadData];
            [self.betCollectionView reloadData];
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
            
        } failure:^(id msg) {
        
        }];
    }];
}

- (void)setNextIssueModel:(UGNextIssueModel *)nextIssueModel {
    _nextIssueModel = nextIssueModel;
    self.preNumArray = [nextIssueModel.preNum componentsSeparatedByString:@","];
    if (nextIssueModel.preNumSx.length) {
        self.preNumSxArray = [nextIssueModel.preNumSx componentsSeparatedByString:@","];
    }
    self.winArray = [nextIssueModel.preNumStringWin componentsSeparatedByString:@","];
    self.navigationItem.title = nextIssueModel.title;

}

- (void)showRightMenueView {
    self.yymenuView = [[UGYYRightMenuView alloc] initWithFrame:CGRectMake(UGScreenW /2 , 0, UGScreenW / 2, UGScerrnH)];
    self.yymenuView.lotteryGamesArray = self.lotteryGamesArray;
    self.yymenuView.titleType = @"2";
    self.yymenuView.gameId = self.gameId;
    self.yymenuView.gameName = self.nextIssueModel.title;
    //此处为重点
    WeakSelf;
    self.yymenuView .gotoSeeBlock = ^{
        
        [weakSelf.navigationController popViewControllerAnimated:NO];
        if (weakSelf.gotoTabBlock) {
            weakSelf.gotoTabBlock();
        }
    };
    [self.yymenuView show];
}

- (void)refreshBalance {
    [self startAnimation];
    SANotificationEventPost(UGNotificationGetUserInfo, nil);
    
}

- (IBAction)chipClick:(id)sender {
    if (self.amountTextF.isFirstResponder) {
        [self.amountTextF resignFirstResponder];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            YBPopupMenu *popView = [[YBPopupMenu alloc] initWithTitles:self.chipArray icons:nil menuWidth:CGSizeMake(100, 200) delegate:self];
            popView.fontSize = 14;
            popView.type = YBPopupMenuTypeDefault;
            [popView showRelyOnView:self.chipButton];
        });
    }else {
        YBPopupMenu *popView = [[YBPopupMenu alloc] initWithTitles:self.chipArray icons:nil menuWidth:CGSizeMake(100, 200) delegate:self];
        popView.fontSize = 14;
        popView.type = YBPopupMenuTypeDefault;
        [popView showRelyOnView:self.chipButton];
    }
    
}

- (IBAction)resetClick:(id)sender {
    [self.amountTextF resignFirstResponder];
    [self updateSelectLabelWithCount:0];
    self.amountTextF.text = nil;
    for (UGGameplayModel *model in self.gameDataArray) {
        model.select = NO;
        for (UGGameplaySectionModel *type in model.list) {
            for (UGGameBetModel *game in type.list) {
                game.select = NO;
            }
        }
    }
    [self.betCollectionView reloadData];
    [self.tableView reloadData];
    [self.tableView selectRowAtIndexPath:self.typeIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (IBAction)betClick:(id)sender {
    [self.amountTextF resignFirstResponder];
    ck_parameters(^{
        ck_parameter_non_equal(self.selectLabel.text, @"已选中 0 注", @"请选择玩法");
        ck_parameter_non_empty(self.amountTextF.text, @"请输入投注金额");
    }, ^(id err) {
        [SVProgressHUD showInfoWithStatus:err];
    }, ^{
        NSMutableArray *array = [NSMutableArray array];
        for (UGGameplayModel *model in self.gameDataArray) {
            if (!model.select) {
                continue;
            }
            for (UGGameplaySectionModel *type in model.list) {
                for (UGGameBetModel *game in type.list) {
                    if (game.select) {
                        game.money = self.amountTextF.text;
                        game.title = type.name;
                        [array addObject:game];
                    }
                    
                }
            }
        }
        
        UGBetDetailView *betDetailView = [[UGBetDetailView alloc] init];
        betDetailView.dataArray = array;
        betDetailView.nextIssueModel = self.nextIssueModel;
        WeakSelf
        betDetailView.betClickBlock = ^{
            [weakSelf resetClick:nil];
        };
        [betDetailView show];
        
    });
}

#pragma mark - YBPopupMenuDelegate

- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu {
    if (index >= 0 ) {
        if (index < self.chipArray.count - 1) {
            self.amountTextF.text = self.chipArray[index];
        }else {
            self.amountTextF.text = nil;
            
        }
    }
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.gameDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UGTimeLotteryLeftTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:leftTitleCellid forIndexPath:indexPath];
    UGGameplayModel *model = self.gameDataArray[indexPath.row];
    cell.item = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.typeIndexPath = indexPath;
    [self.betCollectionView reloadData];
    [self.betCollectionView setContentOffset:CGPointMake(0, 0) animated:YES];
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (collectionView == self.betCollectionView) {
        if (self.gameDataArray.count) {
            
            UGGameplayModel *model = self.gameDataArray[self.typeIndexPath.row];
            return model.list.count;
        }
        return 0;
    }
    return 2;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.betCollectionView) {
        UGGameplayModel *model = self.gameDataArray[self.typeIndexPath.row];
        UGGameplaySectionModel *type = model.list[section];
        return type.list.count;
    }else {
        if (section == 0) {
            return self.preNumArray.count;
        }
        return self.preNumSxArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.betCollectionView) {
        UGTimeLotteryBetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:lottryBetCellid forIndexPath:indexPath];
        UGGameplayModel *model = self.gameDataArray[self.typeIndexPath.row];
        UGGameplaySectionModel *type = model.list[indexPath.section];
        UGGameBetModel *game = type.list[indexPath.row];
        cell.item = game;
        return cell;
    }else {
        if (indexPath.section == 0) {
            
            UGLotteryResultCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:lotteryResultCellid forIndexPath:indexPath];
            cell.title = self.preNumArray[indexPath.row];
            cell.showAdd = NO;
            cell.showBorder = NO;
            cell.layer.cornerRadius = 3;
            cell.layer.masksToBounds = YES;
            cell.backgroundColor = [CMCommon getPreNumColor:self.preNumArray[indexPath.row]];
            return cell;
        }else {
            UGPK10SubResultCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:lotterySubResultCellid forIndexPath:indexPath];
            cell.tag = indexPath.row;
            cell.result = self.preNumSxArray[indexPath.row];
            cell.win = [self.nextIssueModel.winningPlayers containsObject:@(indexPath.row)];
            if (indexPath.row == 0) {
                cell.win = !self.nextIssueModel.winningPlayers.count;
            }
            return cell;
        }
    }
    
}

//-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//
//    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
//        UGTimeLotteryBetHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewID forIndexPath:indexPath];
//        if (collectionView == self.betCollectionView) {
//            UGGameplayModel *model = self.gameDataArray[self.typeIndexPath.row];
//            UGGameplaySectionModel *type = model.list[indexPath.section];
//            headerView.title = type.name;
//        }else {
//
//            headerView.title = @"";
//        }
//        return headerView;
//
//    }
//    return nil;
//
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.betCollectionView) {
        if (self.bottomCloseView.hidden == NO) {
            [SVProgressHUD showInfoWithStatus:@"封盘中"];
            return;
        }
        UGGameplayModel *model = self.gameDataArray[self.typeIndexPath.row];
        UGGameplaySectionModel *type = model.list[indexPath.section];
        UGGameBetModel *game = type.list[indexPath.row];
        game.select = !game.select;
        [self.betCollectionView reloadData];
        
        NSInteger number = 0;
        for (UGGameplaySectionModel *type in model.list) {
            for (UGGameBetModel *game in type.list) {
                if (game.select) {
                    number ++;
                }
            }
        }
        model.select = number;
        [self.tableView reloadData];
        [self.tableView selectRowAtIndexPath:self.typeIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        
        NSInteger count = 0;
        for (UGGameplayModel *model in self.gameDataArray) {
            for (UGGameplaySectionModel *type in model.list) {
                for (UGGameBetModel *game in type.list) {
                    if (game.select) {
                        count ++;
                    }
                }
            }
        }
        [self updateSelectLabelWithCount:count];
    }
    
}

#pragma mark - WSLWaterFlowLayoutDelegate
//返回每个item大小
- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (waterFlowLayout == self.headerFlow) {
        if (indexPath.section == 0) {
            return CGSizeMake(24, 24);
        }
        return CGSizeMake(40, 40);
    }
    if (indexPath.row > 2) {
        return CGSizeMake((UGScreenW / 4 * 3 - 4) / 2 , 40);
    }
    return CGSizeMake((UGScreenW / 4 * 3 - 4) / 3 , 40);
    
    
}
/** 头视图Size */
-(CGSize )waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForHeaderViewInSection:(NSInteger)section{
    if (waterFlowLayout == self.headerFlow) {
        return  CGSizeMake(300, 3);
    }
    return CGSizeMake(0, 0);
}

/** 列间距*/
-(CGFloat)columnMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    
    return 1;
}
/** 行间距*/
-(CGFloat)rowMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    
    return 1;
}
/** 边缘之间的间距*/
-(UIEdgeInsets)edgeInsetInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    
    return UIEdgeInsetsMake(1, 1, 1, 1);
}

- (void)initBetCollectionView {
    WSLWaterFlowLayout *flow = [[WSLWaterFlowLayout alloc] init];
    flow.delegate = self;
    flow.flowLayoutStyle = WSLWaterFlowVerticalEqualHeight;
    
    UICollectionView *collectionView = ({
        float height;
        if ([CMCommon isPhoneX]) {
            height = UGScerrnH - 88 - 83 - 114;
        }else {
            height = UGScerrnH - 64 - 49 - 114;
        }
        collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(UGScreenW / 4 + 1 , 134, UGScreenW / 4 * 3 - 1, height) collectionViewLayout:flow];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [collectionView registerNib:[UINib nibWithNibName:@"UGTimeLotteryBetCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:lottryBetCellid];
        [collectionView registerNib:[UINib nibWithNibName:@"UGTimeLotteryBetHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewID];
        collectionView;
        
    });
    collectionView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
    self.betCollectionView = collectionView;
    [self.view addSubview:collectionView];
}

- (void)initHeaderCollectionView {

    WSLWaterFlowLayout *flow = [[WSLWaterFlowLayout alloc] init];
    flow.delegate = self;
    flow.flowLayoutStyle = WSLWaterFlowVerticalEqualHeight;
    self.headerFlow = flow;
    
    UICollectionView *collectionView = ({
        
        collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(120 , 5, UGScreenW - 120 , 100) collectionViewLayout:flow];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [collectionView registerNib:[UINib nibWithNibName:@"UGLotteryResultCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:lotteryResultCellid];
        [collectionView registerNib:[UINib nibWithNibName:@"UGPK10SubResultCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:lotterySubResultCellid];
//        [collectionView registerNib:[UINib nibWithNibName:@"UGTimeLotteryBetHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewID];
        collectionView;
        
    });
    
    self.headerCollectionView = collectionView;
    [self.view addSubview:collectionView];
    
}

- (void)updateHeaderViewData {
    self.currentIssueLabel.text = [NSString stringWithFormat:@"%@期",self.nextIssueModel.preIssue];
    self.nextIssueLabel.text = [NSString stringWithFormat:@"%@期",self.nextIssueModel.curIssue];
    _currentIssueLabel.hidden = !_nextIssueModel.preIssue.length;
    _nextIssueLabel.hidden = !_nextIssueModel.curIssue.length;
    [self updateCloseLabelText];
    [self updateOpenLabelText];
    CGSize size = [self.nextIssueModel.preIssue sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
    self.headerCollectionView.x = 30 + size.width;
    [self.headerCollectionView reloadData];
    
}

- (void)updateSelectLabelWithCount:(NSInteger)count {
    self.selectLabel.text = [NSString stringWithFormat:@"已选中 %ld 注",count];
    NSMutableAttributedString *abStr = [[NSMutableAttributedString alloc] initWithString:self.selectLabel.text];
    [abStr addAttribute:NSForegroundColorAttributeName value:UGNavColor range:NSMakeRange(3, self.selectLabel.text.length - 4)];
    self.selectLabel.attributedText = abStr;
}

- (void)updateCloseLabelText{
    NSString *timeStr = [CMCommon getNowTimeWithEndTimeStr:self.nextIssueModel.curCloseTime currentTimeStr:self.nextIssueModel.serverTime];
    if (self.nextIssueModel.isSeal || timeStr == nil) {
        timeStr = @"封盘中";
        self.bottomCloseView.hidden = NO;
        [self resetClick:nil];
    }else {
        self.bottomCloseView.hidden = YES;
    }
    self.closeTimeLabel.text = [NSString stringWithFormat:@"封盘：%@",timeStr];
    [self updateCloseLabel];
    
}

- (void)updateOpenLabelText {
    NSString *timeStr = [CMCommon getNowTimeWithEndTimeStr:self.nextIssueModel.curOpenTime currentTimeStr:self.nextIssueModel.serverTime];
    if (timeStr == nil) {
        timeStr = @"获取下一期";
    }else {
        
    }
    self.openTimeLabel.text = [NSString stringWithFormat:@"开奖：%@",timeStr];
    [self updateOpenLabel];
    
}

- (void)updateCloseLabel {
    NSMutableAttributedString *abStr = [[NSMutableAttributedString alloc] initWithString:self.closeTimeLabel.text];
    [abStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3, self.closeTimeLabel.text.length - 3)];
    self.closeTimeLabel.attributedText = abStr;
    
}

- (void)updateOpenLabel {
    NSMutableAttributedString *abStr = [[NSMutableAttributedString alloc] initWithString:self.openTimeLabel.text];
    [abStr addAttribute:NSForegroundColorAttributeName value:UGNavColor range:NSMakeRange(3, self.openTimeLabel.text.length - 3)];
    self.openTimeLabel.attributedText = abStr;
}

//刷新余额动画
-(void)startAnimation
{
    CABasicAnimation *ReFreshAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    ReFreshAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
    ReFreshAnimation.duration = 1;
    ReFreshAnimation.repeatCount = HUGE_VALF;
    STButton *button = (STButton *)self.rightItem1.customView;
    [button.imageView.layer addAnimation:ReFreshAnimation forKey:@"rotationAnimation"];
    
}

- (void)showAdPoppuView:(UGNextIssueModel *)model {
    if (model.adEnable && !self.showAdPoppuView) {
        
        UGLotteryAdPopView *adView = [[UGLotteryAdPopView alloc] initWithFrame:CGRectMake(0, self.view.width / 2, self.view.width, self.view.width)];
        adView.picUrl = model.adPic;
        WeakSelf
        adView.adGoBlcok = ^{
            // 去任务大厅
            if ([model.adLink isEqualToString:@"-2"]) {
                [self.navigationController pushViewController:_LoadVC_from_storyboard_(@"UGMissionCenterViewController") animated:YES];
                return ;
            }
            // 去利息宝
            if ([model.adLink isEqualToString:@"-1"]) {
                [self.navigationController pushViewController:_LoadVC_from_storyboard_(@"UGYubaoViewController")  animated:YES];
                return ;
            }
            // 去彩票下注页面
            for (UGAllNextIssueListModel *listMoel in self.lotteryGamesArray) {
                for (UGNextIssueModel *nextModel in listMoel.list) {
                    if ([nextModel.gameId isEqualToString:model.adLink]) {
                        [weakSelf showAdLottery:nextModel];
                        break;
                    }
                }
            }
        };
        [adView show];
        self.showAdPoppuView = YES;
    }
    
}

- (void)showAdLottery:(UGNextIssueModel *)nextModel {
    if ([@"cqssc" isEqualToString:nextModel.gameType]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGSSCLotteryController" bundle:nil];
        UGSSCLotteryController *lotteryVC = [storyboard instantiateInitialViewController];
        lotteryVC.nextIssueModel = nextModel;
        lotteryVC.gameId = nextModel.gameId;
        lotteryVC.lotteryGamesArray = self.lotteryGamesArray;
        [self.navigationController pushViewController:lotteryVC animated:YES];
    }else if ([@"pk10" isEqualToString:nextModel.gameType] ||
              [@"xyft" isEqualToString:nextModel.gameType]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGBJPK10LotteryController" bundle:nil];
        UGBJPK10LotteryController *markSixVC = [storyboard instantiateInitialViewController];
        markSixVC.nextIssueModel = nextModel;
        markSixVC.gameId = nextModel.gameId;
        markSixVC.lotteryGamesArray = self.lotteryGamesArray;
        [self.navigationController pushViewController:markSixVC animated:YES];
        
    }else if ([@"qxc" isEqualToString:nextModel.gameType]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGQXCLotteryController" bundle:nil];
        UGQXCLotteryController *sevenVC = [storyboard instantiateInitialViewController];
        sevenVC.nextIssueModel = nextModel;
        sevenVC.gameId = nextModel.gameId;
        sevenVC.lotteryGamesArray = self.lotteryGamesArray;
        [self.navigationController pushViewController:sevenVC animated:YES];
        
    }else if ([@"lhc" isEqualToString:nextModel.gameType]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGHKLHCLotteryController" bundle:nil];
        UGHKLHCLotteryController *markSixVC = [storyboard instantiateInitialViewController];
        markSixVC.nextIssueModel = nextModel;
        markSixVC.gameId = nextModel.gameId;
        markSixVC.lotteryGamesArray = self.lotteryGamesArray;
        [self.navigationController pushViewController:markSixVC animated:YES];
        
    }else if ([@"jsk3" isEqualToString:nextModel.gameType]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGJSK3LotteryController" bundle:nil];
        UGJSK3LotteryController *fastThreeVC = [storyboard instantiateInitialViewController];
        fastThreeVC.nextIssueModel = nextModel;
        fastThreeVC.gameId = nextModel.gameId;
        fastThreeVC.lotteryGamesArray = self.lotteryGamesArray;
        [self.navigationController pushViewController:fastThreeVC animated:YES];
    }else if ([@"pcdd" isEqualToString:nextModel.gameType]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGPCDDLotteryController" bundle:nil];
        UGPCDDLotteryController *PCVC = [storyboard instantiateInitialViewController];
        PCVC.nextIssueModel = nextModel;
        PCVC.gameId = nextModel.gameId;
        PCVC.lotteryGamesArray = self.lotteryGamesArray;
        [self.navigationController pushViewController:PCVC animated:YES];
        
    }else if ([@"gd11x5" isEqualToString:nextModel.gameType]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGGD11X5LotteryController" bundle:nil];
        UGGD11X5LotteryController *PCVC = [storyboard instantiateInitialViewController];
        PCVC.nextIssueModel = nextModel;
        PCVC.gameId = nextModel.gameId;
        PCVC.lotteryGamesArray = self.lotteryGamesArray;
        [self.navigationController pushViewController:PCVC animated:YES];
        
    }else if ([@"bjkl8" isEqualToString:nextModel.gameType]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGBJKL8LotteryController" bundle:nil];
        UGBJKL8LotteryController *PCVC = [storyboard instantiateInitialViewController];
        PCVC.nextIssueModel = nextModel;
        PCVC.gameId = nextModel.gameId;
        PCVC.lotteryGamesArray = self.lotteryGamesArray;
        [self.navigationController pushViewController:PCVC animated:YES];
        
    }else if ([@"gdkl10" isEqualToString:nextModel.gameType] ||
              [@"xync" isEqualToString:nextModel.gameType]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGGDKL10LotteryController" bundle:nil];
        UGGDKL10LotteryController *PCVC = [storyboard instantiateInitialViewController];
        PCVC.nextIssueModel = nextModel;
        PCVC.gameId = nextModel.gameId;
        PCVC.lotteryGamesArray = self.lotteryGamesArray;
        [self.navigationController pushViewController:PCVC animated:YES];
        
    }else if ([@"fc3d" isEqualToString:nextModel.gameType]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGFC3DLotteryController" bundle:nil];
        UGFC3DLotteryController *markSixVC = [storyboard instantiateInitialViewController];
        markSixVC.nextIssueModel = nextModel;
        markSixVC.gameId = nextModel.gameId;
        markSixVC.lotteryGamesArray = self.lotteryGamesArray;
        [self.navigationController pushViewController:markSixVC animated:YES];
        
    }else if ([@"pk10nn" isEqualToString:nextModel.gameType]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGPK10NNLotteryController" bundle:nil];
        UGPK10NNLotteryController *markSixVC = [storyboard instantiateInitialViewController];
        markSixVC.nextIssueModel = nextModel;
        markSixVC.gameId = nextModel.gameId;
        markSixVC.lotteryGamesArray = self.lotteryGamesArray;
        [self.navigationController pushViewController:markSixVC animated:YES];
        
    }else {
        
    }
}


#pragma mark - textField delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [self.amountTextF resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (UITableView *)tableView {
    float height;
    if ([CMCommon isPhoneX]) {
        
        height = UGScerrnH - 88 - 83 - 114;
    }else {
        height = UGScerrnH - 64 - 49 - 114;
    }
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 134, UGScreenW / 4, height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"UGTimeLotteryLeftTitleCell" bundle:nil] forCellReuseIdentifier:leftTitleCellid];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.rowHeight = 40;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
        
    }
    return _tableView;
}

- (NSMutableArray *)gameDataArray {
    if (_gameDataArray == nil) {
        _gameDataArray = [NSMutableArray array];
        
    }
    return _gameDataArray;
}


@end

