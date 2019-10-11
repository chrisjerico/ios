//
//  UGHappyTenLotteryController.m
//  ug
//
//  Created by ug on 2019/6/16.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGGDKL10LotteryController.h"
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
#import "UGLotteryRecordController.h"
#import "WSLWaterFlowLayout.h"
#import "UGSegmentView.h"
#import "UGSSCBetItem1Cell.h"
#import "UGLinkNumCollectionViewCell.h"

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
#import "UGFC3DLotteryController.h"
#import "UGPK10NNLotteryController.h"

#import "UGYYRightMenuView.h"

@interface UGGDKL10LotteryController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,YBPopupMenuDelegate,UITextFieldDelegate,WSLWaterFlowLayoutDelegate>
@property (weak, nonatomic) IBOutlet UILabel *currentIssueLabel;
@property (weak, nonatomic) IBOutlet UIView *currentIssueCollectionBgView;
@property (weak, nonatomic) IBOutlet UILabel *nextIssueLabel;
@property (weak, nonatomic) IBOutlet UILabel *closeTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *openTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *nextIssueView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *bottomCloseView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeidhtConstraint;

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
@property (nonatomic, strong) NSArray *preNumArray;
@property (nonatomic, strong) NSArray *preNumSxArray;

@property (strong, nonatomic)  CountDown *countDown;
@property (nonatomic, strong) CountDown *nextIssueCountDown;
@property (nonatomic, strong) STBarButtonItem *rightItem1;
@property (nonatomic, strong) UGSegmentView *segmentView;
@property (nonatomic, strong) NSMutableArray *segmentTitleArray;
@property (nonatomic, assign) NSInteger segmentIndex;
@property (nonatomic, assign) BOOL showAdPoppuView;

@property (strong, nonatomic)UGYYRightMenuView *yymenuView;

@end

static NSString *leftTitleCellid = @"UGTimeLotteryLeftTitleCell";
static NSString *lottryBetCellid = @"UGTimeLotteryBetCollectionViewCell";
static NSString *sscBetItem1CellId = @"UGSSCBetItem1Cell";
static NSString *linkNumCellId = @"UGLinkNumCollectionViewCell";
static NSString *headerViewID = @"UGTimeLotteryBetHeaderView";
static NSString *lotteryResultCellid = @"UGLotteryResultCollectionViewCell";
static NSString *lotterySubResultCellid = @"UGLotterySubResultCollectionViewCell";
@implementation UGGDKL10LotteryController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor =  [UIColor whiteColor];
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
    [self.view addSubview:self.segmentView];
    WeakSelf
    self.segmentIndex = 0;
    self.segmentView.segmentIndexBlock = ^(NSInteger row) {
        weakSelf.segmentIndex = row;
        [weakSelf.betCollectionView reloadData];
        [weakSelf resetClick:nil];
    };
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
    
    self.chipArray = @[@"10",@"100",@"1000",@"10000",@"清除"];
    self.countDown = [[CountDown alloc] init];
    self.nextIssueCountDown = [[CountDown alloc] init];
    
    [self updateHeaderViewData];
    [self updateCloseLabel];
    [self updateOpenLabel];
    if ([CMCommon isPhoneX]) {
        self.bottomViewHeidhtConstraint.constant = 90;
        
    }else {
        self.bottomViewHeidhtConstraint.constant = 60;
        
    }
    
    [self getGameDatas];
    [self getNextIssueData];
    
    //添加通知，来控制键盘和输入框的位置
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
   
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
        if ([[weakSelf.nextIssueModel.curOpenTime dateWithFormat:@"yyyy-MM-dd HH:mm:ss"] timeIntervalSinceDate:[NSDate date]] < 0) {
            [weakSelf getNextIssueData];
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.countDown destoryTimer];
    [self.nextIssueCountDown destoryTimer];
}

- (IBAction)showChatRoom:(id)sender {
    UGChatViewController *chatVC = [[UGChatViewController alloc] init];
    chatVC.webTitle = @"聊天室";
    chatVC.fromView = @"game";
    NSString *colorStr = [[UGSkinManagers shareInstance] setChatNavbgStringColor];
    chatVC.url = [NSString stringWithFormat:@"%@%@%@&loginsessid=%@&id=%@color=%@",baseServerUrl,newChatRoomUrl,[UGUserModel currentUser].token,[UGUserModel currentUser].sessid,self.gameId,colorStr];
    //    [NSString stringWithFormat:@"%@%@?id=%@",baseServerUrl,chatRoomUrl,self.gameId];
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
            
        }];
    }];
}

- (void)getGameDatas {
    NSDictionary *params = @{@"id":self.gameId};
    [CMNetwork getGameDatasWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            UGPlayOddsModel *play = model.data;
            self.gameDataArray = play.playOdds.mutableCopy;
            for (UGGameplayModel *model in self.gameDataArray) {
                if ([@"连码" isEqualToString:model.name]) {
                    
                    for (UGGameplaySectionModel *type in model.list) {
                        [self.segmentTitleArray addObject:type.alias];
                    }
                }
            }
            [self handleData];
            self.segmentView.dataArray = self.segmentTitleArray;
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
        if ([CMCommon arryIsNull:array]) {
            [self.navigationController.view makeToast:@"请输入投注金额"
                                             duration:1.5
                                             position:CSToastPositionCenter];
            return ;
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
    UGGameplayModel *lastModel = self.gameDataArray[self.typeIndexPath.row];
    self.typeIndexPath = indexPath;
    UGGameplayModel *model = self.gameDataArray[indexPath.row];
    if ([@"连码" isEqualToString:lastModel.name]) {
        [self resetClick:nil];
    }
    
    if ([@"连码" isEqualToString:model.name]) {
        if (self.segmentView.hidden) {
            
            self.betCollectionView.y += self.segmentView.height;
            self.betCollectionView.height -= self.segmentView.height;
        }
        self.segmentView.hidden = NO;
        [self resetClick:nil];
        
    }else {
        if (!self.segmentView.hidden) {
            
            self.betCollectionView.y -= self.segmentView.height;
            self.betCollectionView.height += self.segmentView.height;
        }
        self.segmentView.hidden = YES;
    }
    
    [self.betCollectionView reloadData];
    [self.betCollectionView setContentOffset:CGPointMake(0, 0) animated:YES];
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (collectionView == self.betCollectionView) {
        if (self.gameDataArray.count) {
            
            UGGameplayModel *model = self.gameDataArray[self.typeIndexPath.row];
            if ([@"连码" isEqualToString:model.name]) {
                return 1;
            }
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
        UGGameplayModel *model = self.gameDataArray[self.typeIndexPath.row];
        UGGameplaySectionModel *type = nil;
        if ([@"连码" isEqualToString:model.name]) {
            type = model.list[self.segmentIndex];
            
        }else {
            type = model.list[indexPath.section];
            
        }
        UGGameBetModel *game = type.list[indexPath.row];
        if ([@"正码" isEqualToString:model.name]) {
            game.name = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
        }
        if ([@"第一球" isEqualToString:model.name] ||
            [@"第二球" isEqualToString:model.name] ||
            [@"第三球" isEqualToString:model.name] ||
            [@"第四球" isEqualToString:model.name] ||
            [@"第五球" isEqualToString:model.name] ||
            [@"第六球" isEqualToString:model.name] ||
            [@"第七球" isEqualToString:model.name] ||
            [@"第八球" isEqualToString:model.name] ||
            [@"正码" isEqualToString:model.name]) {
            if (indexPath.row < 20) {
                UGSSCBetItem1Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:sscBetItem1CellId forIndexPath:indexPath];
                cell.item = game;
                return cell;
            }
        }
        if ([@"连码" isEqualToString:model.name]) {
            UGLinkNumCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:linkNumCellId forIndexPath:indexPath];
            cell.item = game;
            return cell;
        }
        UGTimeLotteryBetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:lottryBetCellid forIndexPath:indexPath];
        
        cell.item = game;
        return cell;
    }else {
        if (indexPath.section == 0) {
            
            UGLotteryResultCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:lotteryResultCellid forIndexPath:indexPath];
            cell.title = self.preNumArray[indexPath.row];
            cell.showAdd = NO;
            cell.showBorder = NO;
            return cell;
        }else {
            UGLotterySubResultCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:lotterySubResultCellid forIndexPath:indexPath];
            cell.title = self.preNumSxArray[indexPath.row];
            return cell;
        }
    }
    
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UGTimeLotteryBetHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewID forIndexPath:indexPath];
        if (collectionView == self.betCollectionView) {
            UGGameplayModel *model = self.gameDataArray[self.typeIndexPath.row];
            UGGameplaySectionModel *type = nil;
            if ([@"连码" isEqualToString:model.name]) {
                type = model.list[self.segmentIndex];
                UGBetModel *bet = type.list.firstObject;
                headerView.title = [NSString stringWithFormat:@"赔率：%@",[bet.odds removeFloatAllZero]];
            }else {
                type = model.list[indexPath.section];
                headerView.title = type.name;
            }
           
        }else {
            
            headerView.title = @"";
        }
        return headerView;
        
    }
    return nil;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.betCollectionView) {
        if (self.bottomCloseView.hidden == NO) {
            [SVProgressHUD showInfoWithStatus:@"封盘中"];
            return;
        }
        UGGameplayModel *model = self.gameDataArray[self.typeIndexPath.row];
        UGGameplaySectionModel *type = nil;
        if ([@"连码" isEqualToString:model.name]) {
            type = model.list[self.segmentIndex];
        }else {
            type = model.list[indexPath.section];
        }
        UGGameBetModel *game = type.list[indexPath.row];
        if ([@"连码" isEqualToString:model.name]) {
            NSInteger count = 0;
            for (UGGameBetModel *bet in type.list) {
                if (bet.select) {
                    count ++;
                }
            }
            NSString *title = self.segmentTitleArray[self.segmentIndex];
            if ([@"任选二" isEqualToString:title] ||
                [@"选二连组" isEqualToString:title] ||
                [@"任选三" isEqualToString:title] ||
                [@"选三前组" isEqualToString:title]) {
                
                if (count == 7 && !game.select) {
                    [SVProgressHUD showInfoWithStatus:@"不允许超过7个选项"];
                }else {
                    game.select = !game.select;
                }
            }else if ([@"任选四" isEqualToString:title] ||
                      [@"任选五" isEqualToString:title]) {
                if (count == 5 && !game.select) {
                    [SVProgressHUD showInfoWithStatus:@"不允许超过5个选项"];
                }else {
                    game.select = !game.select;
                }
            }else {
                
            }
            
            
        }else {
            
            game.select = !game.select;
        }
        
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
                if ([@"连码" isEqualToString:model.name]) {
                    NSInteger num = 0;
                    for (UGGameBetModel *bet in type.list) {
                        if (bet.select) {
                            num ++;
                        }
                    }
                    NSString *title = self.segmentTitleArray[self.segmentIndex];
                    if ([@"任选二" isEqualToString:title] ||
                        [@"选二连组" isEqualToString:title]) {
                        if (num >= 2) {
                            count += [CMCommon pickNum:2 totalNum:num];
                        }
                    }else if ([@"任选三" isEqualToString:title] ||
                              [@"选三前组" isEqualToString:title]) {
                        if (num >= 3) {
                            count += [CMCommon pickNum:3 totalNum:num];
                        }
                    }else if ([@"任选四" isEqualToString:title]) {
                        if (num >= 4) {
                            count += [CMCommon pickNum:4 totalNum:num];
                        }
                    }else if ([@"任选五" isEqualToString:title]) {
                        if (num >= 5) {
                            count += [CMCommon pickNum:5 totalNum:num];
                        }
                    }else {
                        
                    }
                    
                    continue;
                }
                
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
	if (self.typeIndexPath.row > 4 && self.typeIndexPath.row < 9 && indexPath.row > 33) {
		return CGSizeMake((UGScreenW / 4 * 3 - 4) / 2, 40);
	}
    if (self.typeIndexPath.row == 1 ||
        self.typeIndexPath.row == 2 ||
        self.typeIndexPath.row == 3 ||
        self.typeIndexPath.row == 4 ||
        self.typeIndexPath.row == 5 ||
        self.typeIndexPath.row == 6 ||
        self.typeIndexPath.row == 7 ||
        self.typeIndexPath.row == 8 ) {
        if (indexPath.row < 18 || indexPath.row > 33) {
            
            return CGSizeMake((UGScreenW / 4 * 3 - 4) / 3, 40);
        }
    }
    if (self.typeIndexPath.row == 9) {
        if (indexPath.row > 17) {
            return CGSizeMake((UGScreenW / 4 * 3 - 4) / 2, 40);
        }
        return CGSizeMake((UGScreenW / 4 * 3 - 4) / 3, 40);
    }
    return CGSizeMake((UGScreenW / 4 * 3 - 4) / 2, 40);
}
/** 头视图Size */
-(CGSize )waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForHeaderViewInSection:(NSInteger)section{
    return CGSizeMake(UGScreenW / 4 * 3 - 1, 35);
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
        collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(UGScreenW / 4 + 1 , 114, UGScreenW / 4 * 3 - 1, height) collectionViewLayout:flow];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [collectionView registerNib:[UINib nibWithNibName:@"UGTimeLotteryBetCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:lottryBetCellid];
        [collectionView registerNib:[UINib nibWithNibName:@"UGSSCBetItem1Cell" bundle:nil] forCellWithReuseIdentifier:sscBetItem1CellId];
        [collectionView registerNib:[UINib nibWithNibName:@"UGLinkNumCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:linkNumCellId];
        [collectionView registerNib:[UINib nibWithNibName:@"UGTimeLotteryBetHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewID];
        collectionView;
        
    });
    collectionView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
    self.betCollectionView = collectionView;
    [self.view addSubview:collectionView];
    
}

- (void)initHeaderCollectionView {
    
    UICollectionViewFlowLayout *layout = ({
        
        layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(24, 24);
        layout.minimumInteritemSpacing = 1;
        layout.minimumLineSpacing = 1;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.headerReferenceSize = CGSizeMake(300, 3);
        layout;
        
    });
    
    UICollectionView *collectionView = ({
        
        collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(120 , 5, UGScreenW - 120 , 100) collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [collectionView registerNib:[UINib nibWithNibName:@"UGLotteryResultCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:lotteryResultCellid];
        [collectionView registerNib:[UINib nibWithNibName:@"UGLotterySubResultCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:lotterySubResultCellid];
        [collectionView registerNib:[UINib nibWithNibName:@"UGTimeLotteryBetHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewID];
        collectionView;
        
    });
    
    self.headerCollectionView = collectionView;
    [self.view addSubview:collectionView];
    
}

- (void)updateHeaderViewData {
    self.currentIssueLabel.text = [NSString stringWithFormat:@"%@期",self.nextIssueModel.preIssue];
    self.nextIssueLabel.text = [NSString stringWithFormat:@"%@期",self.nextIssueModel.curIssue];
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
    if (self.closeTimeLabel.text.length) {
        
        NSMutableAttributedString *abStr = [[NSMutableAttributedString alloc] initWithString:self.closeTimeLabel.text];
        [abStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3, self.closeTimeLabel.text.length - 3)];
        self.closeTimeLabel.attributedText = abStr;
    }
    
}

- (void)updateOpenLabel {
    if (self.openTimeLabel.text.length) {
        
        NSMutableAttributedString *abStr = [[NSMutableAttributedString alloc] initWithString:self.openTimeLabel.text];
        [abStr addAttribute:NSForegroundColorAttributeName value:UGNavColor range:NSMakeRange(3, self.openTimeLabel.text.length - 3)];
        self.openTimeLabel.attributedText = abStr;
    }
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

#pragma mark ----- 键盘显示的时候的处理
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    
//    //获得键盘的大小
//    NSDictionary* info = [aNotification userInfo];
//    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
//
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.25];
//    [UIView setAnimationCurve:7];
//    self.view.y -= kbSize.height;
//    //    self.bottomViewBottomConstraint.constant = kbSize.height;
//    [UIView commitAnimations];
}

#pragma mark -----    键盘消失的时候的处理
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    
//    //获得键盘的大小
//    NSDictionary* info = [aNotification userInfo];
//    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.25];
//    [UIView setAnimationCurve:7];
//    self.view.y += kbSize.height;
//    //    self.bottomViewBottomConstraint.constant = 0;
//    [UIView commitAnimations];
}

//连码玩法数据处理
- (void)handleData {
    
    for (UGGameplayModel *model in self.gameDataArray) {
        if ([@"连码" isEqualToString:model.name]) {
            for (UGGameplaySectionModel *group in model.list) {
                if (group.list.count) {
                    UGGameBetModel *play = group.list.firstObject;
                    NSMutableArray *array = [NSMutableArray array];
                    for (int i = 0; i < 20; i++) {
                        UGGameBetModel *bet = [[UGGameBetModel alloc] init];
                        [bet setValuesForKeysWithDictionary:play.mj_keyValues];
                        bet.alias = bet.name;
                        bet.typeName = group.name;
                        bet.name = [NSString stringWithFormat:@"%d",i + 1];
                        [array addObject:bet];
                    }
                    group.list = array.copy;
                }
            }
        }
    }
}

- (UITableView *)tableView {
    float height;
    if ([CMCommon isPhoneX]) {
        
        height = UGScerrnH - 88 - 83 - 114;
    }else {
        height = UGScerrnH - 64 - 49 - 114;
    }
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 114, UGScreenW / 4, height) style:UITableViewStyleGrouped];
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

- (UGSegmentView *)segmentView {
    if (_segmentView == nil) {
        _segmentView = [[UGSegmentView alloc] initWithFrame:CGRectMake(UGScreenW / 4, 114, UGScreenW /4 * 3, 50) titleArray:self.segmentTitleArray];
        _segmentView.hidden = YES;
        
    }
    return _segmentView;
    
}

- (NSMutableArray *)gameDataArray {
    if (_gameDataArray == nil) {
        _gameDataArray = [NSMutableArray array];
    }
    return _gameDataArray;
}

- (NSMutableArray *)segmentTitleArray {
    if (_segmentTitleArray == nil) {
        _segmentTitleArray = [NSMutableArray array];
    }
    return _segmentTitleArray;
}

@end

