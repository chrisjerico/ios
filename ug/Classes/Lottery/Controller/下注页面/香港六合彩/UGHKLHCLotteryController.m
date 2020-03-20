//
//  UGHKMarkSixLotteryController.m
//  ug
//
//  Created by ug on 2019/5/23.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGHKLHCLotteryController.h"
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
#import "STBarButtonItem.h"
#import "UGAllNextIssueListModel.h"
#import "UGMarkSixLotteryBetItem0Cell.h"
#import "UGMarkSixLotteryBetItem1Cell.h"
#import "UGLotteryRecordController.h"
#import "WMNavTabBar.h"
#import "SGSegmentedControl.h"
#import "UGMailBoxTableViewController.h"
#import "UGChangLongController.h"
#import "UGFundsViewController.h"
#import "UGBetRecordViewController.h"
#import "UGLotteryRulesView.h"
#import "UGSegmentView.h"

#import "UGLotteryAdPopView.h"
#import "UGPCDDLotteryController.h"
#import "UGJSK3LotteryController.h"
#import "UGBJPK10LotteryController.h"
#import "UGQXCLotteryController.h"
#import "UGSSCLotteryController.h"
#import "UGGD11X5LotteryController.h"
#import "UGXYNCLotteryController.h"
#import "UGBJKL8LotteryController.h"
#import "UGGDKL10LotteryController.h"
#import "UGFC3DLotteryController.h"
#import "UGPK10NNLotteryController.h"
#import "UIColor+YYUI.h"
#import "UGYYRightMenuView.h"
#import "UGLotterySettingModel.h"

@interface UGHKLHCLotteryController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,WSLWaterFlowLayoutDelegate,YBPopupMenuDelegate,SGSegmentedControlDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *currentIssueLabel;            /**<   当前期数Label */
@property (weak, nonatomic) IBOutlet UIView *currentIssueCollectionBgView;  /**<   当前期开奖号码的背景VIew */
@property (weak, nonatomic) IBOutlet UILabel *nextIssueLabel;               /**<   下期数Label */
@property (weak, nonatomic) IBOutlet UILabel *closeTimeLabel;               /**<   下期封盘时间Label */
@property (weak, nonatomic) IBOutlet UILabel *openTimeLabel;                /**<   下期开奖时间Label */
@property (weak, nonatomic) IBOutlet UIView *nextIssueView;                 /**<   下期信息父View */
@property (weak, nonatomic) IBOutlet UIView *bottomView;                    /**<   底部信息父View */
@property (weak, nonatomic) IBOutlet UIView *bottomCloseView;               /**<   底部封盘View */

@property (weak, nonatomic) IBOutlet UITextField *amountTextF;  /**<   下注金额TextField */
@property (weak, nonatomic) IBOutlet UILabel *selectLabel;      /**<   注数Label */
@property (weak, nonatomic) IBOutlet UIButton *chipButton;      /**<   筹码Button */

@property (nonatomic, strong) STBarButtonItem *rightItem1;              /**<   导航条上的余额Item */
@property (nonatomic, strong) UGYYRightMenuView *yymenuView;            /**<   右侧边栏 */
@property (nonatomic, strong) UICollectionView *headerCollectionView;   /**<   顶部当前期开奖号码CollectionView */
@property (nonatomic, strong) UITableView *tableView;                   /**<   玩法列表TableView */
@property (nonatomic, strong) UICollectionView *betCollectionView;      /**<   下注号码CollectionView */

@property (nonatomic, strong) WSLWaterFlowLayout *flow;         /**<   瀑布流控件 */

@property (nonatomic, strong) UGSegmentView *segmentView;       /**<   号码上面的‘子玩法’滑块View */
@property (nonatomic, assign) NSInteger segmentIndex;           /**<   选中的‘子玩法’下标 */
@property (nonatomic, strong) UIScrollView *zodiacScrollView;   /**<   12生肖ScrollView */

@property (nonatomic, strong) CountDown *countDown;             /**<   倒数器 */
@property (nonatomic, strong) CountDown *nextIssueCountDown;    /**<   下期倒数器 */

@property (nonatomic, strong) NSArray <NSString *> *chipArray;               /**<   筹码数组 */
@property (nonatomic, strong) UGPlayOddsModel *playOddsModel;   /**<   玩法赔率Model */
@property (nonatomic, strong) NSMutableArray <UGGameplayModel *>*gameDataArray;    /**<   玩法列表 */
@property (nonatomic, strong) NSArray <NSString *> *preNumArray;
@property (nonatomic, strong) NSArray <NSString *> *subPreNumArray;
@property (nonatomic, strong) NSArray <NSString *> *numColorArray;
@property (nonatomic, strong) NSMutableArray <NSString *> *tmTitleArray;     /**<   特码 的子玩法标题Array */
@property (nonatomic, strong) NSMutableArray <NSString *> *lmTitleArray;     /**<   连码 的子玩法标题Array */
@property (nonatomic, strong) NSMutableArray <NSString *> *ztTitleArray;     /**<   正特 的子玩法标题Array */
@property (nonatomic, strong) NSMutableArray <NSString *> *lxTitleArray;     /**<   连肖 的子玩法标题Array */
@property (nonatomic, strong) NSMutableArray <NSString *> *lwTitleArray;     /**<   连尾 的子玩法标题Array */

@property (nonatomic, strong) NSIndexPath *typeIndexPath;       /**<   类型下标 */
@property (nonatomic, strong) NSIndexPath *itemIndexPath;       /**<   item下标 */
@property (nonatomic, assign) BOOL showAdPoppuView;             /**<   显示广告 */

@property (nonatomic, strong) NSString *headerViewTitle ; /**<section 头 自选不中*/
@property (nonatomic, strong) NSString *hxheaderViewTitle ; /**<section 头 合肖*/

@end

static NSString *leftTitleCellid = @"UGTimeLotteryLeftTitleCell";
static NSString *markSixBetItem0 = @"UGMarkSixLotteryBetItem0Cell";
static NSString *markSixBetItem1 = @"UGMarkSixLotteryBetItem1Cell";
static NSString *lottryBetCellid = @"UGTimeLotteryBetCollectionViewCell";
static NSString *headerViewID = @"UGTimeLotteryBetHeaderView";
static NSString *lotteryResultCellid = @"UGLotteryResultCollectionViewCell";
static NSString *lotterySubResultCellid = @"UGLotterySubResultCollectionViewCell";


@implementation UGHKLHCLotteryController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化数组
    {
        _gameDataArray = [NSMutableArray array];
        
        _tmTitleArray = [NSMutableArray array];
        _lwTitleArray = [NSMutableArray array];
        _lxTitleArray = [NSMutableArray array];
        _ztTitleArray = [NSMutableArray array];
        _lmTitleArray = [NSMutableArray array];
        _headerViewTitle = @"自选不中";
        _hxheaderViewTitle = @"合肖";
    }
    
    
    self.chipButton.layer.cornerRadius = 5;
    self.chipButton.layer.masksToBounds = YES;
    self.chipButton.layer.masksToBounds = YES;
    self.amountTextF.delegate = self;
    [self.view addSubview:self.tableView];
    self.bottomCloseView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.bottomCloseView.hidden = YES;
    [self.view addSubview:self.segmentView];
    //    [self.view addSubview:self.zodiacScrollView];
    WeakSelf
    self.segmentIndex = 0;
    self.segmentView.segmentIndexBlock = ^(NSInteger row) {
        weakSelf.segmentIndex = row;
        [weakSelf.betCollectionView reloadData];
        [weakSelf resetClick:nil];
        
        // 取消生肖按钮的选中状态
        for (UIButton *btn in weakSelf.zodiacScrollView.subviews) {
            if ([btn isKindOfClass:[UIButton class]])
                btn.selected = false;
        }
    };
    [self initHeaderCollectionView];
    [self initBetCollectionView];
    
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
    self.chipArray = @[@"10", @"100", @"1000", @"10000", @"清除"];
    self.countDown = [[CountDown alloc] init];
    [self updateHeaderViewData];
    self.nextIssueCountDown = [[CountDown alloc] init];
    
    [self updateHeaderViewData];
    [self updateCloseLabel];
    [self updateOpenLabel];
    
    [self getGameDatas];
    [self getNextIssueData];
    
    // 轮循刷新封盘时间、开奖时间
    // 轮循刷新封盘时间、开奖时间
    if (OBJOnceToken(self)) {
        self.timer = [NSTimer scheduledTimerWithInterval:1 repeats:true block:^(NSTimer *timer) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // UI更新代码
                [weakSelf updateCloseLabelText];
                [weakSelf updateOpenLabelText];
            });
            
            if (!weakSelf) {
                [timer invalidate];
                timer = nil;
            }
        }];
    }
    
    if (OBJOnceToken(self)) {
        // 轮循请求下期数据
        [self.nextIssueCountDown countDownWithSec:NextIssueSec PER_SECBlock:^{
            UGNextIssueModel *nim = weakSelf.nextIssueModel;
            if ([[nim.curOpenTime dateWithFormat:@"yyyy-MM-dd HH:mm:ss"] timeIntervalSinceDate:[NSDate date]] < 0
                || nim.curIssue.intValue != nim.preIssue.intValue+1) {
                [weakSelf getNextIssueData];
            }
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view bringSubviewToFront:self.bottomView];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

// 去聊天室
- (IBAction)showChatRoom:(id)sender {
    //    UGChatViewController *chatVC = [[UGChatViewController alloc] init];
    //    chatVC.roomId = self.gameId;
    //    [self.navigationController pushViewController:chatVC animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSSelectChatRoom" object:nil userInfo:nil];
    
}

- (void)setupBarButtonItems {
    STBarButtonItem *item0 = [STBarButtonItem barButtonItemLeftWithImageName:@"shuaxin" title:[NSString stringWithFormat:@"¥%@", [[UGUserModel currentUser].balance removeFloatAllZero]] target:self action:@selector(refreshBalance)];
    self.rightItem1 = item0;
    STBarButtonItem *item1 = [STBarButtonItem barButtonItemWithImageName:@"gengduo" target:self action:@selector(showRightMenueView)];
    self.navigationItem.rightBarButtonItems = @[item1, item0];
}

// 获取下期信息
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

// 彩票游戏数据
- (void)getGameDatas {
    NSDictionary *params = @{@"id":self.gameId};
    [SVProgressHUD showWithStatus:nil];
    [CMNetwork getGameDatasWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            [SVProgressHUD dismiss];
            UGPlayOddsModel *play = model.data;
            self.playOddsModel = play;
            [self.view addSubview:self.zodiacScrollView];
            
            self.gameDataArray = [play.playOdds mutableCopy];
            for (UGGameplayModel *gm in play.playOdds) {
                for (UGGameplaySectionModel *gsm in gm.list) {
                    
                    for (UGGameBetModel *gbm in gsm.list){
                        NSLog(@"gsm.typeName= %@",gsm.typeName);
                        if ([gsm.typeName isEqualToString:@"合肖"]) {
                            NSLog(@"gsm.list = %@",gsm.list);
                        }
                        gbm.gameEnable = gsm.enable;
                    }
                    
                    for (UGGameBetModel *gbm in gsm.lhcOddsArray){
                        NSLog(@"gsm.typeName222222= %@",gsm.typeName);
                        if ([gsm.typeName isEqualToString:@"合肖"]) {
                            NSLog(@"gsm.lhcOddsArray = %@",gsm.lhcOddsArray);
                        }
                        gbm.gameEnable = gsm.enable;
                    }
                }
  
            }
            
            // 删除enable为NO的数据（不显示出来）
            for (UGGameplayModel *gm in play.playOdds) {
                for (UGGameplaySectionModel *gsm in gm.list) {
                    if (!gsm.enable)
                        [self.gameDataArray removeObject:gm];
                }
            }
            [self handleData];
            
            if ([self.gameDataArray.firstObject.name isEqualToString:@"特码"]) {
                if (self.segmentView.hidden) {
                    self.betCollectionView.y += self.segmentView.height;
                    self.betCollectionView.height -= self.segmentView.height;
                }
                if (self.zodiacScrollView.hidden) {
                    self.betCollectionView.y += self.zodiacScrollView.height;
                    self.betCollectionView.height -= self.zodiacScrollView.height;
                }
                self.zodiacScrollView.hidden = false;
                self.segmentView.hidden = NO;
            }
            self.segmentView.dataArray = self.tmTitleArray;
            [self.tableView reloadData];
            [self.betCollectionView reloadData];
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        } failure:^(id msg) {
             [SVProgressHUD dismiss];
        }];
    }];
}

- (void)setNextIssueModel:(UGNextIssueModel *)nextIssueModel {
    [super setNextIssueModel:nextIssueModel];
    self.preNumArray = [nextIssueModel.preNum componentsSeparatedByString:@","];
    if (nextIssueModel.preNumSx.length) {
        self.subPreNumArray = [nextIssueModel.preNumSx componentsSeparatedByString:@","];
    }
    self.navigationItem.title = nextIssueModel.title;
}

// 显示侧边栏
- (void)showRightMenueView {
    if ([Skin1.skitType isEqualToString:@"金沙主题"]) {
        [JS_Sidebar show];
        return;
    }
    self.yymenuView = [[UGYYRightMenuView alloc] initWithFrame:CGRectMake(UGScreenW /2 , 0, UGScreenW / 2, UGScerrnH)];
    self.yymenuView.titleType = @"2";
    self.yymenuView.gameId = self.gameId;
    self.yymenuView.gameName = self.nextIssueModel.title;
    //此处为重点
    WeakSelf;
    self.yymenuView.backToHomeBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:NO];
        if (weakSelf.gotoTabBlock) {
            weakSelf.gotoTabBlock();
        }
    };
    [self.yymenuView show];
}

// 刷新余额
- (void)refreshBalance {
    [self startAnimation];
    SANotificationEventPost(UGNotificationGetUserInfo, nil);
}

- (void)updateHeaderViewData {
    self.currentIssueLabel.text = _NSString(@"%@期", self.nextIssueModel.preIssue);
    self.nextIssueLabel.text = _NSString(@"%@期", self.nextIssueModel.curIssue);
    _currentIssueLabel.hidden = !self.nextIssueModel.preIssue.length;
    _nextIssueLabel.hidden = !self.nextIssueModel.curIssue.length;
    [self updateCloseLabelText];
    [self updateOpenLabelText];
    CGSize size = [self.nextIssueModel.preIssue sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
    self.headerCollectionView.x = 30 + size.width;
    [self.headerCollectionView reloadData];
}

- (void)updateCloseLabelText{
    
    NSString *timeStr = [CMCommon getNowTimeWithEndTimeStr:self.nextIssueModel.curCloseTime currentTimeStr:self.nextIssueModel.serverTime];
    if (self.nextIssueModel.isSeal || timeStr == nil) {
        timeStr = @"封盘中";
        self.bottomCloseView.hidden = NO;
        [self resetClick:nil];
    } else {
        self.bottomCloseView.hidden = YES;
    }
    self.closeTimeLabel.text = [NSString stringWithFormat:@"封盘:%@",timeStr];
    [self updateCloseLabel];
}


- (void)updateOpenLabelText {
    NSString *timeStr = [CMCommon getNowTimeWithEndTimeStr:self.nextIssueModel.curOpenTime currentTimeStr:self.nextIssueModel.serverTime];
    if (timeStr == nil) {
        timeStr = @"获取下一期";
    } else {
        
    }
    self.openTimeLabel.text = [NSString stringWithFormat:@"开奖:%@",timeStr];
    [self updateOpenLabel];
}


#pragma mark - IBAction

// 筹码弹框
- (IBAction)chipClick:(id)sender {
    if (self.amountTextF.isFirstResponder) {
        [self.amountTextF resignFirstResponder];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            YBPopupMenu *popView = [[YBPopupMenu alloc] initWithTitles:self.chipArray icons:nil menuWidth:CGSizeMake(100, 200) delegate:self];
            popView.fontSize = 14;
            popView.type = YBPopupMenuTypeDefault;
            [popView showRelyOnView:self.chipButton];
        });
    } else {
        YBPopupMenu *popView = [[YBPopupMenu alloc] initWithTitles:self.chipArray icons:nil menuWidth:CGSizeMake(100, 200) delegate:self];
        popView.fontSize = 14;
        popView.type = YBPopupMenuTypeDefault;
        [popView showRelyOnView:self.chipButton];
    }
}

// 重置
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
    
    // 取消生肖按钮的选中状态
    for (UIButton *btn in _zodiacScrollView.subviews) {
        if ([btn isKindOfClass:[UIButton class]])
            btn.selected = false;
    }
}

// 下注
- (IBAction)betClick:(id)sender {
    [self.amountTextF resignFirstResponder];
    ck_parameters(^{
        ck_parameter_non_equal(self.selectLabel.text, @"已选中 0 注", @"请选择玩法");
        ck_parameter_non_empty(self.amountTextF.text, @"请输入投注金额");
    }, ^(id err) {
        [SVProgressHUD showInfoWithStatus:err];
    }, ^{
        NSString *selName = @"";
        NSString *selCode = @"";
        NSMutableArray *array = [NSMutableArray array];
        for (UGGameplayModel *model in self.gameDataArray) {
            if (!model.select) {
                continue;
            }
            NSLog(@"model.code ======================== %@",model.code);
            NSLog(@"model.name ======================== %@",model.name);
            selCode = model.code;
            selName = model.name;
            for (UGGameplaySectionModel *type in model.list) {
                if ([@"自选不中" isEqualToString:type.name]) {
                    NSMutableString *str = [[NSMutableString alloc] init];
                    NSInteger count = 0;
                    UGGameBetModel *betModel;
                    
                    for (UGGameBetModel *bet in type.list) {
                        if (bet.select) {
                            count ++;
                            [str appendString:[NSString stringWithFormat:@",%@",bet.name]];
                        }
                    }

                    for (UGGameBetModel * model in type.lhcOddsArray) {
                        
                        if ([model.name containsString:@","]) {
                            NSArray  *arr = [model.name componentsSeparatedByString:@","];
                            if (arr.count == count) {
                                betModel = model;
                            }
                        }
                        else{
                            if (model.name.intValue == count) {
                                betModel = model;
                            }
                        }
                    }
                    
                    betModel.select = 1;
                    betModel.name = [str substringFromIndex:1];
                    NSArray *array = [NSArray arrayWithObject:betModel];
                    type.zxbzlist = array.copy;
                    
                }
                
                if ([@"合肖" isEqualToString:type.name]) {
                    NSMutableString *str = [[NSMutableString alloc] init];
                    NSInteger count = 0;
                    for (UGGameBetModel *bet in type.list) {
                        if (bet.select) {
                            count += 1;
                            [str appendString:[NSString stringWithFormat:@",%@",bet.name]];
                        }
                    }
                    
                    UGGameBetModel *betModel = type.lhcOddsArray[count - 2];
                    betModel.select = 1;
                    betModel.name = [str substringFromIndex:1];
                    betModel.betInfo = [str substringFromIndex:1];
                    betModel.typeName = type.name;
                    NSArray *array = [NSArray arrayWithObject:betModel];
                    type.list = array.copy;
                    
                }
                
                if ([@"自选不中" isEqualToString:type.name]) {
                    for (UGGameBetModel *game in type.zxbzlist) {
                        if (game.select) {
                            game.money = self.amountTextF.text;
                            game.title = type.name;
                            [array addObject:game];
                        }
                    }
                }
                else{
                    for (UGGameBetModel *game in type.list) {
                        if (game.select) {
                            game.money = self.amountTextF.text;
                            game.title = type.name;
                            [array addObject:game];
                        }
                    }
                }
                
            }
        }
         NSLog(@"array ============ %@",array);
        if ([CMCommon arryIsNull:array]) {
            [self.navigationController.view makeToast:@"请选择玩法" duration:1.5 position:CSToastPositionCenter];
            return ;
        }
        UGBetDetailView *betDetailView = [[UGBetDetailView alloc] init];
        betDetailView.dataArray = array;
        betDetailView.nextIssueModel = self.nextIssueModel;
        betDetailView.code = selCode;
        WeakSelf
        betDetailView.betClickBlock = ^{
            [weakSelf handleData];
            [weakSelf resetClick:nil];
        };
        betDetailView.cancelBlock = ^{
            [weakSelf handleData];
            [weakSelf resetClick:nil];
        };
        [betDetailView show];
    });
}

#pragma mark - YBPopupMenuDelegate

- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu {
    if (index >= 0 ) {
        if (index < self.chipArray.count - 1) {
            float n1 = [CMCommon floatForNSString:self.amountTextF.text];
            float n2 = [CMCommon floatForNSString:self.chipArray[index]];
            float sum = n1 + n2;
            self.amountTextF.text = [NSString stringWithFormat:@"%.2f",sum];
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
    self.segmentIndex = 0;
    UGGameplayModel *model = self.gameDataArray[indexPath.row];
    
    NSDictionary *dict = @{@"特码":self.tmTitleArray,
                           @"连码":self.lmTitleArray,
                           @"正特":self.ztTitleArray,
                           @"连肖":self.lxTitleArray,
                           @"连尾":self.lwTitleArray,
    };
    self.segmentView.dataArray = dict[model.name];
    _segmentView.hidden = !dict[model.name];
    _zodiacScrollView.hidden = ![model.name isEqualToString:@"特码"];
    
    
    {
        CGFloat y = _segmentView.y;
        CGFloat h = APP.Height - ([CMCommon isPhoneX] ? 88 : 64) - 154 - APP.StatusBarHeight;
        if (!_segmentView.hidden) {
            y += _segmentView.height;
            h -= _segmentView.height;
        }
        if (!_zodiacScrollView.hidden) {
            y += _zodiacScrollView.height;
            h -= _zodiacScrollView.height;
        }
        _betCollectionView.y = y;
        _betCollectionView.height = h;
    }
    [self.betCollectionView reloadData];
    [self.betCollectionView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    
    [self resetClick:nil];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (collectionView == self.betCollectionView) {
        if (self.gameDataArray.count) {
            UGGameplayModel *model = self.gameDataArray[self.typeIndexPath.row];
            if ([@"连码" isEqualToString:model.name] ||
                [@"连肖" isEqualToString:model.name] ||
                [@"连尾" isEqualToString:model.name]) {
                return 1;
            } else if ([@"正特" isEqualToString:model.name]){
                return 2;
            } else if ([@"特码" isEqualToString:model.name]) {
                return 3;
            } else {
                return model.list.count;
            }
        }
        return 0;
    }
    return 2;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.betCollectionView) {
        UGGameplayModel *model = self.gameDataArray[self.typeIndexPath.row];
        UGGameplaySectionModel *type = nil;
        if ([@"正特" isEqualToString:model.name]) {
            type = model.list[self.segmentIndex * 2 + section];
        } else {
            type = model.list[section];
        }
        return type.list.count;
    } else {
        return self.preNumArray.count ? (self.preNumArray.count + 1) : 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.betCollectionView) {
        UGGameplayModel *model = self.gameDataArray[self.typeIndexPath.row];
        UGGameplaySectionModel *type = nil;
        if ([@"连码" isEqualToString:model.name] ||
            [@"连肖" isEqualToString:model.name] ||
            [@"连尾" isEqualToString:model.name]) {
            type = model.list[self.segmentIndex];
        } else if ([@"正特" isEqualToString:model.name]) {
            type = model.list[self.segmentIndex * 2 + indexPath.section];
        } else if ([@"特码" isEqualToString:model.name]) {
            NSString *tl =  [self.tmTitleArray objectAtIndex:self.segmentIndex];
            
            if ([tl isEqualToString:@"特码B"]) {
                type = model.list[indexPath.section + 3];
            } else {
                type = model.list[indexPath.section];
            }

        } else {
            type = model.list[indexPath.section];
        }
        UGGameBetModel *game = type.list[indexPath.row];
        
        if ([@"特码" isEqualToString:model.name]) {
            if (indexPath.section == 0 ||
                indexPath.section == 3) {
                UGMarkSixLotteryBetItem0Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:markSixBetItem0 forIndexPath:indexPath];
                cell.item = game;
                return cell;
            } else {
                UGTimeLotteryBetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:lottryBetCellid forIndexPath:indexPath];
                cell.item = game;
                return cell;
            }
        }
        if ([@"两面" isEqualToString:model.name] ||
            [@"正码1-6" isEqualToString:model.name] ||
            [@"色波" isEqualToString:model.name] ||
            [@"总肖" isEqualToString:model.name] ||
            [@"五行" isEqualToString:model.name]) {
            UGTimeLotteryBetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:lottryBetCellid forIndexPath:indexPath];
            cell.item = game;
            return cell;
        }
        if ([@"平特一肖" isEqualToString:model.name] ||
            [@"平特尾数" isEqualToString:model.name] ||
            [@"特肖" isEqualToString:model.name] ||
            [@"连肖" isEqualToString:model.name] ||
            [@"合肖" isEqualToString:model.name] ||
            [@"连尾" isEqualToString:model.name] ||
            [@"正肖" isEqualToString:model.name]) {
            UGMarkSixLotteryBetItem1Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:markSixBetItem1 forIndexPath:indexPath];
            cell.playModel = self.playOddsModel;
            cell.item = game;
            return cell;
        }
        if ([@"头/尾数" isEqualToString:model.name]) {
            if (indexPath.section == 0) {
                UGTimeLotteryBetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:lottryBetCellid forIndexPath:indexPath];
                cell.item = game;
                return cell;
            }
            UGMarkSixLotteryBetItem1Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:markSixBetItem1 forIndexPath:indexPath];
            cell.playModel = self.playOddsModel;
            cell.item = game;
            return cell;
        }
        
        if ([@"正码" isEqualToString:model.name] ||
            [@"自选不中" isEqualToString:model.name]) {
            if (indexPath.section == 1) {
                UGTimeLotteryBetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:lottryBetCellid forIndexPath:indexPath];
                NSLog(@"game.typeName =%@",game.typeName);
                game.typeName= model.name;
                cell.item = game;
                return cell;
            }
            UGMarkSixLotteryBetItem0Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:markSixBetItem0 forIndexPath:indexPath];
            
            game.typeName= model.name;
            cell.item = game;
            return cell;
        }
        
        if ([@"正特" isEqualToString:model.name]) {
            if (indexPath.section % 2 == 0) {
                UGMarkSixLotteryBetItem0Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:markSixBetItem0 forIndexPath:indexPath];
                cell.item = game;
                return cell;
            }
            UGTimeLotteryBetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:lottryBetCellid forIndexPath:indexPath];
            cell.item = game;
            return cell;
            
        }
        if ([@"连码" isEqualToString:model.name]) {
            UGMarkSixLotteryBetItem0Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:markSixBetItem0 forIndexPath:indexPath];
            if (indexPath.row < 9) {
                game.name = [NSString stringWithFormat:@"0%ld",indexPath.row + 1];
            } else {
                game.name = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
            }
            cell.item = game;
            return cell;
        }
        
        if (indexPath.section == 2) {
            UGTimeLotteryBetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:lottryBetCellid forIndexPath:indexPath];
            cell.item = game;
            return cell;
        }
        
        UGMarkSixLotteryBetItem0Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:markSixBetItem0 forIndexPath:indexPath];
        cell.item = game;
        return cell;
        
    } else {
        if (indexPath.section == 0) {
            
            UGLotteryResultCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:lotteryResultCellid forIndexPath:indexPath];
            cell.showBorder = NO;
            
            cell.showBall6 = APP.isBall6;
            
            if (indexPath.row == 6) {
                cell.showAdd = YES;
            } else {
                cell.showAdd = NO;
            }
            if (indexPath.row < 6) {
                cell.title = self.preNumArray[indexPath.row];
                cell.color = [CMCommon getHKLotteryNumColorString:self.preNumArray[indexPath.row]];
            }
            if (indexPath.row == 7) {
                cell.title = self.preNumArray[indexPath.row - 1];
                cell.color = [CMCommon getHKLotteryNumColorString:self.preNumArray[indexPath.row - 1]];
            }
            return cell;
        } else {
            UGLotterySubResultCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:lotterySubResultCellid forIndexPath:indexPath];
            if (indexPath.row == 6) {
                cell.showAdd = YES;
            } else {
                cell.showAdd = NO;
            }
            if (indexPath.row < 6) {
                cell.title = self.subPreNumArray[indexPath.row];
            }
            if (indexPath.row == 7) {
                cell.title = self.subPreNumArray[indexPath.row - 1];
                
            }
            return cell;
        }
    }
    
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        UGTimeLotteryBetHeaderView*  headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewID forIndexPath:indexPath];
        
        if (collectionView == self.betCollectionView) {
            if (APP.isShowBorder) {
                [CMCommon addBordeView:headerView Width:1 Color:[CMCommon bordeColor]];
            }
            UGGameplayModel *model = self.gameDataArray[self.typeIndexPath.row];
            UGGameplaySectionModel *type = nil;
            if ([@"连码" isEqualToString:model.name] ||
                [@"连肖" isEqualToString:model.name] ||
                [@"连尾" isEqualToString:model.name]) {
                type = model.list[self.segmentIndex];
            } else if ([@"正特" isEqualToString:model.name]){
                type = model.list[self.segmentIndex * 2 + indexPath.section];
            } else if ([@"特码" isEqualToString:model.name]) {
                
                NSString *tl =  [self.tmTitleArray objectAtIndex:self.segmentIndex];
                
                if ([tl isEqualToString:@"特码B"]) {
                    type = model.list[indexPath.section + 3];
                    
                } else {
                    type = model.list[indexPath.section];
                }
                NSLog(@"type.alias = %@",type.alias);
                //                if (self.segmentIndex) {
                //                    type = model.list[indexPath.section + 3];
                //                } else {
                //                    type = model.list[indexPath.section];
                //                }
            } else {
                type = model.list[indexPath.section];
            }
            headerView.titleLabel.text = type.alias;
            
            if ([@"自选不中" isEqualToString:type.alias]) {
                headerView.titleLabel.text = _headerViewTitle;
            }
            if ([@"合肖" isEqualToString:type.alias]) {
                headerView.titleLabel.text = _hxheaderViewTitle;
            }
        } else {
            headerView.titleLabel.text = @"";
        }
        
        if (APP.betSizeIsBig) {
            headerView.titleLabel.font = APP.cellBigFont;
        } else {
            headerView.titleLabel.font = APP.cellNormalFont;
        }
        
        
        // 如果显示的是赔率，则把赔率标红
//        headerView.titleLabel.textColor = Skin1.textColor1;
        if (APP.betOddsIsRed && [headerView.titleLabel.text containsString:@"赔率："]) {
            headerView.titleLabel.attributedText = ({
                NSMutableAttributedString *mas = headerView.titleLabel.attributedText.mutableCopy;
                [mas addAttributes:@{NSForegroundColorAttributeName:APP.AuxiliaryColor2} range:NSMakeRange(0, mas.length)];
                [mas addAttributes:@{NSForegroundColorAttributeName:Skin1.textColor1} withString:@"赔率："];
                mas;
            });
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
        if ([@"连码" isEqualToString:model.name] ||
            [@"连肖" isEqualToString:model.name] ||
            [@"连尾" isEqualToString:model.name]) {
            type = model.list[self.segmentIndex];
        } else if ([@"正特" isEqualToString:model.name]) {
            type = model.list[self.segmentIndex * 2 + indexPath.section];
        } else if ([@"特码" isEqualToString:model.name]) {
            NSString *tl =  [self.tmTitleArray objectAtIndex:self.segmentIndex];
            
            if ([tl isEqualToString:@"特码B"]) {
                type = model.list[indexPath.section + 3];
            } else {
                type = model.list[indexPath.section ];
            }
            //            if (self.segmentIndex) {//B
            //                type = model.list[indexPath.section + 3];
            //            } else {//B
            //                type = model.list[indexPath.section];
            //            }
        } else {
            type = model.list[indexPath.section];
        }
        
        
        
        // 修改game.select
        {
            UGGameBetModel *game = type.list[indexPath.row];
            
            if ([game.typeName isEqualToString:@"合肖"]||[game.typeName isEqualToString:@"自选不中"]) {
                
            } else {
                if (!(game.gameEnable && game.enable)) {
                    return;
                }
            }
            
            
            
            if ([@"自选不中" isEqualToString:type.name]) {
                NSInteger count = 0;
                
                
                for (UGGameBetModel *bet in type.list) {
                    if (bet.select)
                        count ++;
                }
                
                
                if (count == 12 && !game.select) {
                    [SVProgressHUD showInfoWithStatus:@"不允许超过12个选项"];
                } else {
                    game.select = !game.select;
                }
            } else if ([@"合肖" isEqualToString:type.name]) {
                NSInteger count = 0;
                for (UGGameBetModel *bet in type.list) {
                    if (bet.select)
                        count ++;
                }
                if (count == 11 && !game.select) {
                    [SVProgressHUD showInfoWithStatus:@"不允许超过11个选项"];
                } else {
                    game.select = !game.select;
                }
            } else if ([@"连码" isEqualToString:model.name]) {
                NSInteger count = 0;
                for (UGGameBetModel *bet in type.list) {
                    if (bet.select) {
                        count ++;
                    }
                }
                NSString *title = self.lmTitleArray[self.segmentIndex];
                if ([@"三中二" isEqualToString:title] ||
                    [@"二全中" isEqualToString:title] ||
                    [@"二中特" isEqualToString:title] ||
                    [@"特串" isEqualToString:title] ) {
                    
                    if (count == 7 && !game.select) {
                        [SVProgressHUD showInfoWithStatus:@"不允许超过7个选项"];
                    } else {
                        game.select = !game.select;
                    }
                } else if ([@"三全中" isEqualToString:title]) {
                    if (count == 10 && !game.select) {
                        [SVProgressHUD showInfoWithStatus:@"不允许超过10个选项"];
                    } else {
                        game.select = !game.select;
                    }
                } else if ([@"四全中" isEqualToString:title]) {
                    if (count == 4 && !game.select) {
                        [SVProgressHUD showInfoWithStatus:@"不允许超过4个选项"];
                    } else {
                        game.select = !game.select;
                    }
                } else {
                    
                }
            } else {
                game.select = !game.select;
            }
            [self.betCollectionView reloadData];
        }
        
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
        
        //        计算选中多少注
        NSInteger count = 0;
        for (UGGameplayModel *model in self.gameDataArray) {
            
            
            for (UGGameplaySectionModel *type in model.list) {
                
                
                
                
                //                最少选择5个
                if ([@"自选不中" isEqualToString:type.name]) {
                    NSInteger num = 0;
                    for (UGGameBetModel *bet in type.list) {
                        if (bet.select) {
                            num ++;
                        }
                    }
                    if (num >= 5) {
                        count ++;
                    }
                    
                    
                    continue;
                }
                //                最少选择2个玩法
                if ([@"合肖" isEqualToString:model.name]) {
                    NSInteger num = 0;
                    for (UGGameBetModel *bet in type.list) {
                        if (bet.select) {
                            num ++;
                        }
                    }
                    if (num >= 2) {
                        count ++;
                    }
                    continue;
                }
                
                if ([@"连尾" isEqualToString:model.name] ||
                    [@"连肖" isEqualToString:model.name]) {
                    NSInteger num = 0;
                    for (UGGameBetModel *bet in type.list) {
                        if (bet.select) {
                            num ++;
                        }
                    }
                    if (self.segmentIndex == 0) {
                        if (num >= 2) {
                            count += [CMCommon pickNum:2 totalNum:num];
                        }
                    } else if (self.segmentIndex == 1){
                        if (num >= 3) {
                            count += [CMCommon pickNum:3 totalNum:num];
                        }
                        
                    } else if (self.segmentIndex == 2){
                        if (num >= 4) {
                            count += [CMCommon pickNum:4 totalNum:num];
                        }
                        
                    } else {
                        if (num >= 5) {
                            count += [CMCommon pickNum:5 totalNum:num];
                        }
                    }
                    
                    continue;
                }
                if ([@"连码" isEqualToString:model.name]) {
                    NSInteger num = 0;
                    for (UGGameBetModel *bet in type.list) {
                        if (bet.select) {
                            num ++;
                        }
                    }
                    NSString *title = self.lmTitleArray[self.segmentIndex];
                    if ([@"三中二" isEqualToString:title] ||
                        [@"三全中" isEqualToString:title]) {
                        if (num >= 3) {
                            count += [CMCommon pickNum:3 totalNum:num];
                        }
                    } else if ([@"二全中" isEqualToString:title] ||
                               [@"二中特" isEqualToString:title] ||
                               [@"特串" isEqualToString:title]) {
                        if (num >= 2) {
                            count += [CMCommon pickNum:2 totalNum:num];
                        }
                    } else if ([@"四全中" isEqualToString:title]) {
                        if (num >= 4) {
                            count += [CMCommon pickNum:4 totalNum:num];
                        }
                    } else {
                        
                    }
                    
                    continue;
                }
                
                for (UGGameBetModel *game in type.list) {
                    if (game.select)
                        count ++;
                }
            }
        }
        //自选不中，5--12 时，要显示赔率：
        if ([@"自选不中" isEqualToString:type.name]) {
            NSInteger num = 0;
            for (UGGameBetModel *bet in type.list) {
                if (bet.select){
                    num ++;
                }
            }
            if (num >= 5  && num <= 12) {
                UGGameBetModel *model = type.lhcOddsArray[num-5];
                self.headerViewTitle = [NSString stringWithFormat:@"赔率：%@",model.odds];
            }
            else{
                self.headerViewTitle = @"自选不中";
            }
        }
        
        //合肖，2--11 时，要显示赔率：
        if ([@"合肖" isEqualToString:type.name]) {
            NSInteger num = 0;
            for (UGGameBetModel *bet in type.list) {
                if (bet.select){
                    num ++;
                }
            }
            if (num >= 2  && num <= 11) {
                UGGameBetModel *model = type.lhcOddsArray[num-2];
                self.hxheaderViewTitle = [NSString stringWithFormat:@"赔率：%@",model.odds];
            }
            else{
                self.hxheaderViewTitle = @"合肖";
            }
            
        }
        [self updateSelectLabelWithCount:count];
    }
}

#pragma mark - WSLWaterFlowLayoutDelegate
//返回每个item大小
- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    UGGameplayModel *model = self.gameDataArray[self.typeIndexPath.row];
    CGSize size1 = CGSizeMake((UGScreenW / 4 * 3 - 2), 40);
    CGSize size2 = CGSizeMake((UGScreenW / 4 * 3 - 4) / 2, 40);
    CGSize size3 = CGSizeMake((UGScreenW / 4 * 3 - 4) / 3, 40);
    CGSize size4 = CGSizeMake((UGScreenW / 4 * 3 - 6) / 4, 40);
    CGSize size5 = CGSizeMake((UGScreenW / 4 * 3 - 6) / 5, 40);;
    if ([@"特码" isEqualToString:model.name]) {
        if (indexPath.section == 1 ||
            indexPath.section == 4) {
            return size2;
        } else {
            if (indexPath.row < 45) {
                return size3;
            }
            return size2;
        }
    }
    if ([@"正码" isEqualToString:model.name] ||
        [@"正特" isEqualToString:model.name]) {
        if (indexPath.section % 2) {
            return size2;
        }
        if (indexPath.row > 44) {
            return size2;
        }
        return size3;
        
    } else if ([@"正码1-6" isEqualToString:model.name]) {
        if (indexPath.row > 9) {
            return size3;
        } else {
            return size2;
        }
        
        
    } else if ([@"两面" isEqualToString:model.name] ||
               [@"色波" isEqualToString:model.name] ||
               [@"总肖" isEqualToString:model.name]) {
        
        return size2;
        
    } else if ([@"平特一肖" isEqualToString:model.name] ||
               [@"平特尾数" isEqualToString:model.name] ||
               [@"特肖" isEqualToString:model.name] ||
               [@"连肖" isEqualToString:model.name] ||
               [@"合肖" isEqualToString:model.name] ||
               [@"连尾" isEqualToString:model.name] ||
               [@"正肖" isEqualToString:model.name]) {
        
        return size1;
        
    } else if ([@"头/尾数" isEqualToString:model.name]) {
        
        if (indexPath.section == 0) {
            if (indexPath.row > 1) {
                return size3;
            }
            return size2;
        }
        return size1;
        
    } else if ([@"五行" isEqualToString:model.name]) {
        if (indexPath.row > 3) {
            return size1;
        }
        return size2;
    } else if ([@"自选不中" isEqualToString:model.name]) {
        if (indexPath.row > 44) {
            return size4;
        }
        return size5;
        
    } else if ([@"连码" isEqualToString:model.name]) {
        if (indexPath.row > 44) {
            return size2;
        }
        return size3;
    } else {
        return size2;
    }
    
}

/** 头视图Size */
- (CGSize )waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForHeaderViewInSection:(NSInteger)section{
    return CGSizeMake(UGScreenW / 4 * 3 - 1, 35);
}

/** 列间距*/
- (CGFloat)columnMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    
    return 0;
}
/** 行间距*/
- (CGFloat)rowMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    
    return 0;
}
/** 边缘之间的间距*/
- (UIEdgeInsets)edgeInsetInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout {
    self.betCollectionView.backgroundColor = [UIColor clearColor];
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)initBetCollectionView {
    
    self.flow = [[WSLWaterFlowLayout alloc] init];
    self.flow.delegate = self;
    self.flow.flowLayoutStyle = WSLWaterFlowVerticalEqualHeight;
    
    UICollectionView *collectionView = ({
        float height;
        if ([CMCommon isPhoneX]) {
            height = UGScerrnH - 88 - 83 - 114;
        } else {
            height = UGScerrnH - 64 - 49 - 114;
        }
        collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(UGScreenW / 4 + 1 , 114, UGScreenW / 4 * 3 - 1, height) collectionViewLayout:self.flow];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [collectionView registerNib:[UINib nibWithNibName:@"UGLotteryResultCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:lotteryResultCellid];
        [collectionView registerNib:[UINib nibWithNibName:@"UGTimeLotteryBetCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:lottryBetCellid];
        [collectionView registerNib:[UINib nibWithNibName:@"UGTimeLotteryBetHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewID];
        [collectionView registerNib:[UINib nibWithNibName:@"UGMarkSixLotteryBetItem0Cell" bundle:nil] forCellWithReuseIdentifier:markSixBetItem0];
        [collectionView registerNib:[UINib nibWithNibName:@"UGMarkSixLotteryBetItem1Cell" bundle:nil] forCellWithReuseIdentifier:markSixBetItem1];
        [collectionView registerNib:[UINib nibWithNibName:@"UGLotterySubResultCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:lotterySubResultCellid];
        collectionView;
        
    });
    collectionView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
    self.betCollectionView = collectionView;
    
    [self.view addSubview:collectionView];
}

- (void)initHeaderCollectionView {
    UICollectionViewFlowLayout *layout = ({
        layout = [[UICollectionViewFlowLayout alloc] init];
        if (APP.isBall6) {
            layout.itemSize = CGSizeMake(28, 28);
            layout.minimumInteritemSpacing = 0;
            layout.minimumLineSpacing = 0;
        } else {
            layout.itemSize = CGSizeMake(24, 24);
            layout.minimumInteritemSpacing = 1;
            layout.minimumLineSpacing = 1;
        }

        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.headerReferenceSize = CGSizeMake(300, 3);
        layout;
    });
    UICollectionView *collectionView = ({
        collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(120 , 5, UGScreenW - 120 , 66) collectionViewLayout:layout];
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

- (void)updateSelectLabelWithCount:(NSInteger)count {
    self.selectLabel.text = [NSString stringWithFormat:@"已选中 %ld 注",count];
    if (Skin1.isBlack||Skin1.is23) {
        NSMutableAttributedString *abStr = [[NSMutableAttributedString alloc] initWithString:self.selectLabel.text];
        [abStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(3, self.selectLabel.text.length - 4)];
        self.selectLabel.attributedText = abStr;
    } else {
        
        if (APP.isYellow) {
            NSMutableAttributedString *abStr = [[NSMutableAttributedString alloc] initWithString:self.selectLabel.text];
            [abStr addAttribute:NSForegroundColorAttributeName value:RGBA(247, 211, 72, 1)  range:NSMakeRange(3, self.selectLabel.text.length - 4)];
            self.selectLabel.attributedText = abStr;
        }
        else{
            NSMutableAttributedString *abStr = [[NSMutableAttributedString alloc] initWithString:self.selectLabel.text];
            [abStr addAttribute:NSForegroundColorAttributeName value:Skin1.navBarBgColor range:NSMakeRange(3, self.selectLabel.text.length - 4)];
            self.selectLabel.attributedText = abStr;
        }
        
    }
}

- (void)updateCloseLabel {
    if (APP.isTextWhite) {
        return;
    }
    if (self.closeTimeLabel.text.length) {
        
        NSMutableAttributedString *abStr = [[NSMutableAttributedString alloc] initWithString:self.closeTimeLabel.text];
        [abStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3, self.closeTimeLabel.text.length - 3)];
        self.closeTimeLabel.attributedText = abStr;
    }
}

//这个方法是有用的不要删除
- (void)updateOpenLabel {}

//刷新余额动画
-(void)startAnimation {
    CABasicAnimation *ReFreshAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    ReFreshAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
    ReFreshAnimation.duration = 1;
    ReFreshAnimation.repeatCount = HUGE_VALF;
    STButton *button = (STButton *)self.rightItem1.customView;
    [button.imageView.layer addAnimation:ReFreshAnimation forKey:@"rotationAnimation"];
}

#pragma mark - SGSegmentedControlDelegate

- (void)SGSegmentedControl:(SGSegmentedControl *)segmentedControl didSelectBtnAtIndex:(NSInteger)index {
    
    
}

- (void)showAdPoppuView:(UGNextIssueModel *)model {
    if (model.adEnable && !self.showAdPoppuView) {
        UGLotteryAdPopView *adView = [[UGLotteryAdPopView alloc] initWithFrame:CGRectMake(0, self.view.width / 2, self.view.width, self.view.width)];
        adView.nm = model;
        [adView show];
        self.showAdPoppuView = YES;
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

//连码玩法数据处理
- (void)handleData {
    
    for (UGGameplayModel *model in self.gameDataArray) {
        if ([@"特码" isEqualToString:model.name]) {
            [self.tmTitleArray removeAllObjects];
            for (int i = 0; i < model.list.count; i++) {
                UGGameplaySectionModel *type = model.list[i];
                type.name = type.alias;
                if (i == 0 || i == 3) {
                    NSLog(@"type.alias = %@",type.alias);
                    [self.tmTitleArray addObject:type.alias];
                }
            }
            if (APP.isBA) {
                self.tmTitleArray = [NSMutableArray arrayWithArray:[CMCommon arrrayReverse:self.tmTitleArray]];
            }
        }
        if ([@"正特" isEqualToString:model.name]) {
            [self.ztTitleArray removeAllObjects];
            for (int i = 0; i < model.list.count; i++) {
                UGGameplaySectionModel *type = model.list[i];
                type.name = type.alias;
                if (!(i % 2)) {
                    [self.ztTitleArray addObject:type.alias];
                }
            }
        }
        if ([@"连肖" isEqualToString:model.name]) {
            [self.lxTitleArray removeAllObjects];
            for (UGGameplaySectionModel *type in model.list) {
                [self.lxTitleArray addObject:type.alias];
                type.name = type.alias;
                for (UGGameBetModel *bet in type.list) {
                    bet.name = bet.alias;
                    bet.typeName = model.name;
                }
            }
        }
        if ([@"连尾" isEqualToString:model.name]) {
            [self.lwTitleArray removeAllObjects];
            for (UGGameplaySectionModel *type in model.list) {
                [self.lwTitleArray addObject:type.alias];
                type.name = type.alias;
                for (UGGameBetModel *bet in type.list) {
                    bet.typeName = model.name;
                    bet.name = [NSString stringWithFormat:@"%@尾",bet.alias];
                }
            }
        }
        if ([@"连码" isEqualToString:model.name]) {
            [self.lmTitleArray removeAllObjects];
            for (UGGameplaySectionModel *type in model.list) {
                [self.lmTitleArray addObject:type.alias];
            }
            for (UGGameplaySectionModel *group in model.list) {
                if (group.list.count) {
                    if (!group.lhcOddsArray.count) {
                        group.lhcOddsArray = group.list.copy;
                    }
                    UGGameBetModel *play = group.list.firstObject;
                    NSMutableArray *array = [NSMutableArray array];
                    for (int i = 0; i < 49; i++) {
                        UGGameBetModel *bet = [[UGGameBetModel alloc] init];
                        [bet setValuesForKeysWithDictionary:play.mj_keyValues];
                        bet.alias = group.alias;
                        bet.typeName = model.name;
                        bet.name = [NSString stringWithFormat:@"%d",i + 1];
                        if ([@"三中二" isEqualToString:group.alias] ||
                            [@"二中特" isEqualToString:group.alias]) {
                            
                            UGGameBetModel *play1 = group.lhcOddsArray.firstObject;
                            UGGameBetModel *play2 = group.lhcOddsArray.lastObject;
                            bet.odds = [NSString stringWithFormat:@"%@/%@",[play1.odds removeFloatAllZero] ,[play2.odds removeFloatAllZero]];
                        }
                        
                        [array addObject:bet];
                    }
                    
                    group.list = array.copy;
                }
            }
        }
        if ([@"合肖" isEqualToString:model.name]) {
            
            
            for (UGGameplaySectionModel *group in model.list) {
                
                NSArray *titles = @[@"鼠",@"牛",@"虎",@"兔",@"龙",@"蛇",@"马",@"羊",@"猴",@"鸡",@"狗",@"猪"];
                NSMutableArray *mutArr = [NSMutableArray array];
                for (int i = 0; i < titles.count; i++) {
                    UGGameBetModel *bet = [[UGGameBetModel alloc] init];
                    bet.name = titles[i];
                    bet.typeName = model.name;
                    bet.odds = @"";
                    bet.gameEnable = YES;
                    bet.enable = YES;
                    [mutArr addObject:bet];
                }
                
                if (!group.lhcOddsArray.count) {
                    
                    group.lhcOddsArray = group.list.copy;
                }
                group.list = mutArr.copy;
            }
        }
        if ([@"自选不中" isEqualToString:model.name]) {
            for (UGGameplaySectionModel *group in model.list) {
                NSMutableArray *mutArr = [NSMutableArray array];
                for (int i = 1; i < 50; i++) {
                    UGGameBetModel *bet = [[UGGameBetModel alloc] init];
                    if (i < 10) {
                        bet.name = [NSString stringWithFormat:@"0%d",i];
                    } else {
                        bet.name = [NSString stringWithFormat:@"%d",i];
                    }
                    bet.odds = @"";
                    [mutArr addObject:bet];
                }
                if (!group.lhcOddsArray.count) {
                    
                    group.lhcOddsArray = group.list.copy;
                }
                group.list = mutArr.copy;
            }
        }
        
    }
}

#pragma mark - getting
- (UITableView *)tableView {
    float height;
    if ([CMCommon isPhoneX]) {
        height = UGScerrnH - 88 - 83 - 114;
    } else {
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
        //        if (Skin1.isBlack) {
        //            [_tableView setBackgroundColor:[UIColor clearColor]];
        //        } else {
        //            [_tableView setBackgroundColor:[UIColor whiteColor]];
        //        }
        
    }
    return _tableView;
}

- (UGSegmentView *)segmentView {
    if (_segmentView == nil) {
        _segmentView = [[UGSegmentView alloc] initWithFrame:CGRectMake(UGScreenW / 4, 114, UGScreenW /4 * 3, 40) titleArray:self.tmTitleArray];
        _segmentView.hidden = YES;
        if (APP.isShowBorder) {
            [CMCommon addBordeView:_segmentView Width:1 Color:[CMCommon bordeColor]];
        }
        
    }
    return _segmentView;
}

- (UIScrollView *)zodiacScrollView {
    if (!_zodiacScrollView) {
        __weakSelf_(__self);
        NSArray *titles = @[@"鼠", @"牛", @"虎", @"兔", @"龙", @"蛇", @"马", @"羊", @"猴", @"鸡", @"狗", @"猪",];
        NSMutableArray *btns = [NSMutableArray array];
        CGFloat w = 60, h = 45;
        UIScrollView *sv ;
        
        if (APP.isShowBorder) {
            [CMCommon addBordeView:sv Width:1 Color:[CMCommon bordeColor]];
            sv = [[UIScrollView alloc] initWithFrame:CGRectMake(_segmentView.x, _segmentView.by, _segmentView.width, h)];
        }
        else{
            sv = [[UIScrollView alloc] initWithFrame:CGRectMake(_segmentView.x, _segmentView.by-5, _segmentView.width, h)];
        }
        sv.contentSize = CGSizeMake(titles.count * w, h);
        for (int i=0; i<titles.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i * w, 0, w, h);
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
            [btn setTitle:titles[i] forState:UIControlStateNormal];
            if (Skin1.isBlack) {
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            } else {
                [btn setTitleColor:APP.TextColor1 forState:UIControlStateNormal];
            }
            [btn setImage:[UIImage imageNamed:@"RadioButton-Unselected"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"RadioButton-Selected"] forState:UIControlStateSelected];
            
            
            // 点击生肖时，选中/取消选中对应号码
            [btn addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
                BOOL selected = sender.selected = !sender.selected;
                NSInteger cnt = 0;
                
                NSArray<UGZodiacModel> *array =  self.playOddsModel.setting.zodiacNums;
                
                NSLog(@"self.playOddsModel= %@",self.playOddsModel);
                NSMutableArray *nums = [NSMutableArray new];
                for (UGZodiacModel *ob in array) {
                    if ([ob.name isEqualToString:titles[i]]) {
                        for (NSNumber *jb in ob.nums) {
                            [nums addObject:[NSString stringWithFormat:@"%@",jb]];
                        }
                        break;
                    }
                }
                
                UGGameplayModel *gm = __self.gameDataArray[__self.typeIndexPath.row];
                NSString *tl =  [self.tmTitleArray objectAtIndex:self.segmentIndex];
                UGGameplaySectionModel *gsm = [gm.list objectWithValue:tl keyPath:@"name"];
                for (UGGameBetModel *gbm in gsm.list) {
                    //                    if ([gbm.name isInteger] && (gbm.name.intValue-1)%12 == 12-1-i)
                    NSString *rs = [self conversionInt:gbm.name];
                    if ([gbm.name isInteger] && [nums containsObject:rs])
                        gbm.select = selected;
                    if (gbm.select)
                        cnt++;
                }
                gm.select = cnt;
                [__self.betCollectionView reloadData];
                [__self updateSelectLabelWithCount:cnt];
            }];
            [btns addObject:btn];
            [sv addSubview:btn];
        }
        
        // 选中号码时，选中/取消选中对应生肖
        [self cc_hookSelector:@selector(collectionView:didSelectItemAtIndexPath:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo>ai) {
            UGGameplayModel *gm = __self.gameDataArray[__self.typeIndexPath.row];
            if ([gm.name isEqualToString:@"特码"]) {
                for (UIButton *btn in btns) {
                    btn.selected = true;
                }
                NSString *tl =  [self.tmTitleArray objectAtIndex:self.segmentIndex];
                UGGameplaySectionModel *gsm = [gm.list objectWithValue:tl keyPath:@"name"];
                for (UGGameBetModel *gbm in gsm.list) {
                    if (!gbm.select) {
                        NSInteger idx = 12-1-(gbm.name.intValue-1)%12;
                        UIButton *btn = btns[idx];
                        if (btn.selected)
                            btn.selected = false;
                    }
                }
            }
        } error:nil];
        
        // 显示zodiacScrollView后取消生肖按钮的选中状态
        [sv cc_hookSelector:@selector(setHidden:) withOptions:AspectPositionAfter usingBlock:^(id <AspectInfo>ai) {
            for (UIButton *btn in btns)
                btn.selected = false;
        } error:nil];
        
        sv.hidden = true;
        _zodiacScrollView = sv;
    }
    return _zodiacScrollView;
}


-(NSString *)conversionInt:(NSString *)intStr{
    NSString *rs;
    if ([@"01,02,03,04,05,06,07,08,09" containsString:intStr]) {
        rs =  [intStr substringFromIndex:intStr.length-1];
        
    } else {
        rs = intStr;
    }
    return rs;
}
- (NSArray<NSString *> *)numColorArray {
    if (_numColorArray == nil) {
        _numColorArray = [self.nextIssueModel.preNumColor componentsSeparatedByString:@","];
    }
    return _numColorArray;
}

@end

