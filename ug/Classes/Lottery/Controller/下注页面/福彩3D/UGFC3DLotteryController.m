////
//  UGWelfareLotteryController.m
//  ug
//
//  Created by ug on 2019/6/16.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGFC3DLotteryController.h"
#import "UGTimeLotteryLeftTitleCell.h"
#import "UGTimeLotteryBetCollectionViewCell.h"
#import "UGTimeLotteryBetHeaderView.h"
#import "UGLotteryResultCollectionViewCell.h"
#import "UGLotterySubResultCollectionViewCell.h"
#import "UGGameplayModel.h"
#import "UGBetDetailView.h"
#import "STBarButtonItem.h"
#import "CountDown.h"
#import "UGAllNextIssueListModel.h"
#import "STBarButtonItem.h"
#import "UGChangLongController.h"
#import "UGFundsViewController.h"
#import "UGBetRecordViewController.h"
#import "UGLotteryRulesView.h"
#import "WSLWaterFlowLayout.h"
#import "UGLotteryRecordController.h"
#import "UGSSCBetItem1Cell.h"

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
#import "UGPK10NNLotteryController.h"
#import "UGYYRightMenuView.h"

#import "UGLotteryHistoryModel.h"
#import "UGLotteryRecordTableViewCell.h"
#import "CMTimeCommon.h"
#import "UGSegmentView.h"
#import "UGLinkNumCollectionViewCell.h"
@interface UGFC3DLotteryController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,WSLWaterFlowLayoutDelegate>
@property (weak, nonatomic) IBOutlet UILabel *currentIssueLabel;/**<头 上 当前开奖  */
@property (weak, nonatomic) IBOutlet UIButton *historyBtn;/**<头 上 历史记录按钮  */
@property (weak, nonatomic) IBOutlet UILabel *nextIssueLabel;/**<头 下 下期开奖  */
@property (weak, nonatomic) IBOutlet UILabel *closeTimeLabel;/**<头 下 封盘时间  */
@property (weak, nonatomic) IBOutlet UILabel *openTimeLabel;/**<头 下 开奖时间  */

@property (nonatomic, strong) UICollectionView *headerCollectionView;
@property (nonatomic, strong) UICollectionView *betCollectionView;

@property (nonatomic, strong) NSIndexPath *typeIndexPath;
@property (nonatomic, strong) NSIndexPath *itemIndexPath;

@property (strong, nonatomic) CountDown *countDown;
@property (nonatomic, strong) STBarButtonItem *rightItem1;
@property (nonatomic, strong) NSArray <NSString *> *preNumArray;
@property (nonatomic, strong) NSArray <NSString *> *preNumSxArray;
@property (nonatomic, assign) BOOL showAdPoppuView;

@property (strong, nonatomic)UGYYRightMenuView *yymenuView;

@property (weak, nonatomic) IBOutlet UIView *headerOneView;/**<头 上*/
@property (weak, nonatomic) IBOutlet UIView *headerMidView;/**<头 中*/
@property (weak, nonatomic) IBOutlet UIView *nextIssueView;/**<头 下*/
@property (weak, nonatomic) IBOutlet UIView *contentView;  /**<内容*/
@property (weak, nonatomic) IBOutlet UIView *iphoneXBottomView;/**<iphoneX的t底部*/



@property (weak, nonatomic) IBOutlet UITableView *headerTabView;/**<   历史开奖*/
@property (nonatomic, strong) NSMutableArray <UGLotteryHistoryModel *> *dataArray;/**<   历史开奖数据*/
@property (nonatomic, weak)IBOutlet UITableView *tableView;                   /**<   玩法列表TableView */
@property (nonatomic, strong) NSMutableArray <UGGameplayModel *>*gameDataArray;    /**<   玩法列表 */
@property (weak, nonatomic) IBOutlet UIStackView *rightStackView;/**<右边内容*/

//定位玩法
@property (nonatomic, strong) UGSegmentView *segmentView;  /**<    */

@property (nonatomic, strong) NSMutableArray <NSString *> *fsgmentTitleArray; /**<   复式   组选三 组选六*/
@property (nonatomic, assign) NSInteger segmentIndex;
@property (nonatomic, strong) NSString *erchonghao;//2重号
@property (nonatomic, strong) NSString *danhao;//单号

@property (nonatomic, strong) UGGameBetModel *erchonghaoModel;//2重号
@property (nonatomic, strong) UGGameBetModel *danhaoModel;//单号

@property (nonatomic, strong) NSMutableArray *selArray ;                            /**<  组选6选中的 */

@property (nonatomic, strong) NSMutableArray <NSString *> *rzgmentTitleArray; /**<   二字 */


@end

static NSString *leftTitleCellid = @"UGTimeLotteryLeftTitleCell";
static NSString *lottryBetCellid = @"UGTimeLotteryBetCollectionViewCell";
static NSString *sscBetItem1CellId = @"UGSSCBetItem1Cell";
static NSString *headerViewID = @"UGTimeLotteryBetHeaderView";
static NSString *lotteryResultCellid = @"UGLotteryResultCollectionViewCell";
static NSString *lotterySubResultCellid = @"UGLotterySubResultCollectionViewCell";
static NSString *linkNumCellId = @"UGLinkNumCollectionViewCell";
@implementation UGFC3DLotteryController

- (NSMutableArray *)rzgmentTitleArray {
    if (_rzgmentTitleArray == nil) {
        _rzgmentTitleArray = [NSMutableArray array];
    }
    return _rzgmentTitleArray;
}


- (NSMutableArray *)fsgmentTitleArray {
    if (_fsgmentTitleArray == nil) {
        _fsgmentTitleArray = [NSMutableArray array];
    }
    return _fsgmentTitleArray;
    
}

- (UGSegmentView *)segmentView {
    if (_segmentView == nil) {
        _segmentView = [[UGSegmentView alloc] initWithFrame:CGRectMake(0, 0, UGScreenW /4 * 3, 50) titleArray:self.fsgmentTitleArray];
        _segmentView.hidden = YES;
        
    }
    return _segmentView;
    
}

-(void)viewDidLayoutSubviews{
    [self tableViewInit];
    [self headertableViewInit];
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    [self.tableView  mas_remakeConstraints:^(MASConstraintMaker *make)
     {
        make.left.equalTo(self.contentView.mas_left).with.offset(0);
        make.top.bottom.equalTo(self.contentView).offset(0);
        make.width.mas_equalTo(UGScreenW / 4);
    }];
    [self.rightStackView  mas_remakeConstraints:^(MASConstraintMaker *make)
     {
        make.left.equalTo(_tableView.mas_right).with.offset(0);
        make.top.right.bottom.equalTo(self.contentView).offset(0);
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.danhao = @"";
    self.erchonghao = @"";
    self.danhaoModel = [UGGameBetModel new];
    self.erchonghaoModel = [UGGameBetModel new];
    
    FastSubViewCode(self.view)

    [self.rightStackView addSubview:self.segmentView];
    [self initBetCollectionView];
    [self initHeaderCollectionView];
    
    WeakSelf
    self.segmentIndex = 0;
    self.segmentView.segmentIndexBlock = ^(NSInteger row) {
        weakSelf.segmentIndex = row;
        [weakSelf.betCollectionView reloadData];
        [weakSelf resetClick:nil];
    };
    self.selArray = [NSMutableArray new];
    
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
                [weakSelf getLotteryHistory];
            }
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
 
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.countDown destoryTimer];
    [self.nextIssueCountDown destoryTimer];
}

- (IBAction)showChatRoom:(id)sender {
    UGChatViewController *chatVC = [[UGChatViewController alloc] init];
    chatVC.roomId = self.gameId;
    [self.navigationController pushViewController:chatVC animated:YES];
}

- (void)setupBarButtonItems {
    STBarButtonItem *item0 = [STBarButtonItem barButtonItemLeftWithImageName:@"shuaxin" title:[NSString stringWithFormat:@"¥%@",[UGUserModel currentUser].balance ] target:self action:@selector(refreshBalance)];
    self.rightItem1 = item0;
    STBarButtonItem *item1 = [STBarButtonItem barButtonItemWithImageName:@"gengduo" target:self action:@selector(showRightMenueView)];
    self.navigationItem.rightBarButtonItems = @[item1,item0];
}

- (void)getNextIssueData {
    NSDictionary *params = @{@"id":self.gameId};
    WeakSelf;
    [CMNetwork getNextIssueWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            weakSelf.nextIssueModel = model.data;
            if (self.nextIssueModel) {
                if (OBJOnceToken(self)) {
                    [weakSelf getLotteryHistory ];
                }
            }
            [weakSelf showAdPoppuView:model.data];
            [weakSelf updateHeaderViewData];
             [SVProgressHUD dismiss];
        } failure:^(id msg) {
            [SVProgressHUD dismiss];
        }];
    }];
}

- (void)getGameDatas {
    NSDictionary *params = @{@"id":self.gameId};
    WeakSelf;
    [CMNetwork getGameDatasWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            UGPlayOddsModel *play = model.data;
            weakSelf.gameDataArray = play.playOdds.mutableCopy;
            if (weakSelf.fsgmentTitleArray.count) {
                [weakSelf.fsgmentTitleArray removeAllObjects];
            } else {
                weakSelf.fsgmentTitleArray = [NSMutableArray new];
            }
            
            for (UGGameplayModel *model in weakSelf.gameDataArray) {
                
                if ([@"DWD" isEqualToString:model.code]) {
                    for (UGGameplaySectionModel *type in model.list) {
                        [weakSelf.fsgmentTitleArray addObject:type.alias];
                    }
                }
                
                if ([@"EZ" isEqualToString:model.code]) {
                    for (UGGameplaySectionModel *type in model.list) {
                        [weakSelf.rzgmentTitleArray addObject:type.alias];
                    }
                }
            }
            
            for (UGGameplayModel *gm in play.playOdds) {
                for (UGGameplaySectionModel *gsm in gm.list) {
                    for (UGGameBetModel *gbm in gsm.lhcOddsArray){
                        gbm.gameEnable = gsm.enable;
                    }
                    for (UGGameBetModel *gbm in gsm.list){
                        gbm.gameEnable = gsm.enable;
                    }
                }
            }
            
            
            [weakSelf handleData];
            weakSelf.segmentView.dataArray = weakSelf.fsgmentTitleArray;
            [weakSelf.tableView reloadData];
            [weakSelf betCollectionViewConstraints];
            [weakSelf.betCollectionView reloadData];
            [weakSelf.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];

            [SVProgressHUD dismiss];
        } failure:^(id msg) {
            [SVProgressHUD dismiss];
        }];
    }];
}



- (void)setNextIssueModel:(UGNextIssueModel *)nextIssueModel {
    [super setNextIssueModel:nextIssueModel];
    self.preNumArray = [nextIssueModel.preNum componentsSeparatedByString:@","];
    if (nextIssueModel.preNumSx.length) {
        self.preNumSxArray = [nextIssueModel.preNumSx componentsSeparatedByString:@","];
    }
    self.navigationItem.title = nextIssueModel.title;
}

- (void)showRightMenueView {
    if ([Skin1.skitType isEqualToString:@"金沙主题"]) {
        [JS_Sidebar show];
        return;
    }
    self.yymenuView = [[UGYYRightMenuView alloc] initWithFrame:CGRectMake(UGScreenW /2 , 0, UGScreenW / 2, UGScerrnH)];
    self.yymenuView.titleType = @"2";
    self.yymenuView.gameId = self.gameId;
    self.yymenuView.gameName = self.nextIssueModel.title;
    [self.yymenuView show];
}

- (void)refreshBalance {
    [self startAnimation];
    SANotificationEventPost(UGNotificationGetUserInfo, nil);
    
}

//按选择顺序
-(void)selArryAddGame:(UGGameBetModel *)game{
    if (game.select) {
        [_selArray addObject:game];
    } else {
        if ([_selArray containsObject:game]) {
            [_selArray removeObject:game];
        }
    }
}


- (IBAction)resetClick:(id)sender {
    [super resetClick:sender];
    
    for (UGGameplayModel *model in self.gameDataArray) {
        model.selectedCount = NO;
        for (UGGameplaySectionModel *type in model.list) {
            for (UGGameBetModel *game in type.list) {
                game.select = NO;
            }
            for (UGGameplaySectionModel *type2 in type.ezdwlist) {
                for (UGGameBetModel *game in type2.list) {
                    game.select = NO;
                }
            }
        }
        
    }
    [self.selArray removeAllObjects];
    [self.betCollectionView reloadData];
    [self.tableView reloadData];
    [self.tableView selectRowAtIndexPath:self.typeIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (IBAction)betClick:(id)sender {
    WeakSelf;
    FastSubViewCode(self.view)
    [subTextField(@"TKL下注TxtF") resignFirstResponder];
    ck_parameters(^{
            ck_parameter_non_equal(subLabel(@"TKL已选中label"), @"已选中0注", @"请选择玩法");
            ck_parameter_non_empty(subTextField(@"TKL下注TxtF"), @"请输入投注金额");
       
    }, ^(id err) {
        [SVProgressHUD showInfoWithStatus:err];
    }, ^{
        NSString *selCode = @"";
        NSString *selName = @"";
        NSMutableArray *array = [NSMutableArray array];
        
        UGGameplayModel *model = weakSelf.gameDataArray[weakSelf.typeIndexPath.row];
        if ([model.code isEqualToString:@"DWD"]) {
            UGGameplaySectionModel *type = model.list[weakSelf.segmentIndex];
            if ([type.ezdwcode isEqualToString:@"DWDFS"]) {
                [weakSelf szdwBetActionMode:model array:&array selCode:&selCode];
            }
            else if([type.ezdwcode isEqualToString:@"DWDZXS"]) {
                
                if (weakSelf.erchonghao.length && weakSelf.danhao.length) {
                    UGGameBetModel *bet = [[UGGameBetModel alloc] init];
                    [bet setValuesForKeysWithDictionary:weakSelf.erchonghaoModel.mj_keyValues];
                    NSMutableString *name = [[NSMutableString alloc] init];
                    [name appendString:self.erchonghaoModel.name];
                    [name appendString:@","];
                    [name appendString:self.erchonghaoModel.name];
                    [name appendString:@","];
                    [name appendString:self.danhaoModel.name];
                    bet.name = name;
                    bet.money = subTextField(@"TKL下注TxtF").text;
                    bet.title = bet.alias;
                    bet.betInfo = name;
                    [array addObject:bet];
                }
                else{
                    [SVProgressHUD showInfoWithStatus:@"下注内容不正确，请重新下注"];
                    return;
                }
                
                
            }
            else if([type.ezdwcode isEqualToString:@"DWDZXL"]||[type.ezdwcode isEqualToString:@"DWDZXSFS"]||[type.ezdwcode isEqualToString:@"DWDZXLFS"]){
                
                if (self.selArray.count) {
                    
                    if (self.selArray.count != 3) {
                        [SVProgressHUD showInfoWithStatus:@"下注内容不正确，请重新下注"];
                        return;
                    }
                    
                    UGGameBetModel *beti = self.selArray[0];
                    UGGameBetModel *bety = self.selArray[1];
                    UGGameBetModel *betz = self.selArray[2];
                    UGGameBetModel *bet = [[UGGameBetModel alloc] init];
                    [bet setValuesForKeysWithDictionary:beti.mj_keyValues];
                    NSMutableString *name = [[NSMutableString alloc] init];
                    [name appendString:beti.name];
                    [name appendString:@","];
                    [name appendString:bety.name];
                    [name appendString:@","];
                    [name appendString:betz.name];
                    bet.name = name;
                    bet.money = subTextField(@"TKL下注TxtF").text;
                    bet.title = bet.alias;
                    bet.betInfo = name;
                    [array addObject:bet];
                }
                
            }
            
        }
        
        if ([@"EZ" isEqualToString:model.code]) {
            [self ezdwBetActionMode:model array:&array selCode:&selCode];
        }
        else {
            for (UGGameplayModel *model in weakSelf.gameDataArray) {
                if (!model.selectedCount) {
                    continue;
                }
                NSLog(@"model.code ======================== %@",model.code);
                selCode = model.code;
                selName = model.name;
                for (UGGameplaySectionModel *type in model.list) {
                    for (UGGameBetModel *game in type.list) {
                        if (game.select) {
                            game.money = subTextField(@"TKL下注TxtF").text;
                            game.title = type.name;
//                            game.betInfo = type.name;
                            [array addObject:game];
                        }
                        
                    }
                }
            }
        }
        
        
        
        NSMutableArray *dicArray = [UGGameBetModel mj_keyValuesArrayWithObjectArray:array];
        [weakSelf goUGBetDetailViewObjArray:array.copy dicArray:dicArray.copy issueModel:weakSelf.nextIssueModel  gameType:weakSelf.nextIssueModel.gameId selCode:selCode];
        
    });
}
//二字定位下注方法
-(void)ezdwBetActionMode:(UGGameplayModel *)type array :(NSMutableArray *__strong *) array selCode :(NSString *__strong *)selCode{
    NSLog(@"type=%@",type);
    FastSubViewCode(self.view)
    *selCode = type.code;
    if (type.list.count) {
        NSLog(@"self.segmentIndex = %ld",(long)self.segmentIndex);
        UGGameplaySectionModel *play = type.list[self.segmentIndex];
        if (play.ezdwlist.count) {
            NSMutableArray *mutArr1 = [NSMutableArray array];
            NSMutableArray *mutArr2 = [NSMutableArray array];
            
            UGGameplaySectionModel *model1 = play.ezdwlist[1];
            for (UGGameBetModel *bet in model1.list) {
                if (bet.select) {
                    [mutArr1 addObject:bet];
                }
            }
            UGGameplaySectionModel *model2 = play.ezdwlist[2];
            for (UGGameBetModel *bet in model2.list) {
                if (bet.select) {
                    [mutArr2 addObject:bet];
                }
            }
            if (mutArr1.count == 0 || mutArr2.count == 0) {
                [SVProgressHUD showInfoWithStatus:@"下注内容不正确，请重新下注"];
                return;
            }
            
            for (int i = 0; i < mutArr1.count; i++) {
                
                for (int y = 0; y < mutArr2.count; y++) {
                    
                    UGGameBetModel *beti = mutArr1[i];
                    UGGameBetModel *bety = mutArr2[y];
                    UGGameBetModel *bet = [[UGGameBetModel alloc] init];
                    [bet setValuesForKeysWithDictionary:beti.mj_keyValues];
                    NSMutableString *name = [[NSMutableString alloc] init];
                    [name appendString:beti.name];
                    [name appendString:@","];
                    [name appendString:bety.name];
                    bet.name = name;
                    bet.money = subTextField(@"TKL下注TxtF").text;
                    bet.title = bet.alias;
                    bet.betInfo = name;
                    [*array addObject:bet];
                    
                }
            }
            
        }
    }
    
}
//复式下注方法
-(void)szdwBetActionMode:(UGGameplayModel *)type array :(NSMutableArray *__strong *) array selCode :(NSString *__strong *)selCode{
    FastSubViewCode(self.view)
    *selCode = type.code;
    if (type.list.count) {
        UGGameplaySectionModel *play = type.list[self.segmentIndex];
        if (play.ezdwlist.count) {
            NSMutableArray *mutArr1 = [NSMutableArray array];
            NSMutableArray *mutArr2 = [NSMutableArray array];
            NSMutableArray *mutArr3 = [NSMutableArray array];
            
            UGGameplaySectionModel *model1 = play.ezdwlist[1];
            for (UGGameBetModel *bet in model1.list) {
                if (bet.select) {
                    [mutArr1 addObject:bet];
                }
            }
            UGGameplaySectionModel *model2 = play.ezdwlist[2];
            for (UGGameBetModel *bet in model2.list) {
                if (bet.select) {
                    [mutArr2 addObject:bet];
                }
            }
            UGGameplaySectionModel *model3 = play.ezdwlist[3];
            for (UGGameBetModel *bet in model3.list) {
                if (bet.select) {
                    [mutArr3 addObject:bet];
                }
            }
            if (mutArr1.count == 0 || mutArr2.count == 0|| mutArr3.count == 0) {
                [SVProgressHUD showInfoWithStatus:@"下注内容不正确，请重新下注"];
                return;
            }
            
            for (int i = 0; i < mutArr1.count; i++) {
                
                for (int y = 0; y < mutArr2.count; y++) {
                    
                    for (int z = 0; z < mutArr3.count; z++) {
                        UGGameBetModel *beti = mutArr1[i];
                        UGGameBetModel *bety = mutArr2[y];
                        UGGameBetModel *betz = mutArr3[z];
                        UGGameBetModel *bet = [[UGGameBetModel alloc] init];
                        [bet setValuesForKeysWithDictionary:beti.mj_keyValues];
                        NSMutableString *name = [[NSMutableString alloc] init];
                        [name appendString:beti.name];
                        [name appendString:@","];
                        [name appendString:bety.name];
                        [name appendString:@","];
                        [name appendString:betz.name];
                        bet.name = name;
                        bet.money = subTextField(@"TKL下注TxtF").text;
                        bet.title = bet.alias;
                        bet.betInfo = name;
                        [*array addObject:bet];
                    }
                }
            }
            
        }
    }
    
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.tableView]) {
        return self.gameDataArray.count;
    } else {
        return self.dataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:self.tableView]) {
        UGTimeLotteryLeftTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:leftTitleCellid forIndexPath:indexPath];
        UGGameplayModel *model = self.gameDataArray[indexPath.row];
        cell.item = model;
        return cell;
    } else {
        UGLotteryRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UGLotteryRecordTableViewCell" forIndexPath:indexPath];
        cell.isOneRow = APP.isOneRow;
        cell.item = self.dataArray[indexPath.row];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.tableView]) {
        UGGameplayModel *lastModel = self.gameDataArray[self.typeIndexPath.row];
        self.typeIndexPath = indexPath;
        if ([@"DWD,EZ" containsString:lastModel.code]) {
            [self resetClick:nil];
        }
        UGGameplayModel *model = self.gameDataArray[indexPath.row];
        
        // 定位胆
        if ([@"DWD" isEqualToString:model.code]) {
            self.segmentView.dataArray = self.fsgmentTitleArray;
            self.segmentIndex = 0;
            self.segmentView.hidden = NO;
            [self resetClick:nil];
        }
        // 二字
        else if ([@"EZ" isEqualToString:model.code]) {
            self.segmentView.dataArray = self.rzgmentTitleArray;
            self.segmentIndex = 0;
            self.segmentView.hidden = NO;
            [self resetClick:nil];
            
        }
        else {
            self.segmentView.hidden = YES;
        }
        [self betCollectionViewConstraints];
        __weakSelf_(__self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [__self.betCollectionView reloadData];
            [__self.betCollectionView setContentOffset:CGPointMake(0, 0) animated:YES];
        });
    }
    
}


-(void)betCollectionViewConstraints{
    if (!self.segmentView.hidden) {
        [self.betCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) { //数组额你不必须都是view
            
            make.right.left.equalTo(self.rightStackView);
            make.bottom.equalTo(self.rightStackView).offset(50);
            make.top.equalTo(self.segmentView.mas_bottom);
        }];
    }
    else{
        [self.betCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) { //数组额你不必须都是view
            make.right.left.top.equalTo(self.rightStackView);
            make.bottom.equalTo(self.rightStackView).offset(50);
        }];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (collectionView == self.betCollectionView) {
        if (self.gameDataArray.count) {
            UGGameplayModel *model = self.gameDataArray[self.typeIndexPath.row];
            if ([@"DWD" isEqualToString:model.code]) {
                UGGameplaySectionModel *group = [model.list objectAtIndex:self.segmentIndex];
                if ([group.ezdwcode isEqualToString:@"DWDFS"]) {
                    return 4;
                }
                else if ([group.ezdwcode isEqualToString:@"DWDZXS"]) {
                    return 4;
                }
                else{
                    return 3;
                }
                
            }
            else if ([@"EZ" isEqualToString:model.code]) {
                
                return 3;
            }
            else {
                return model.list.count;
            }
            
        }
        return 0;
    }
    return [LanguageHelper shared].isCN ? 2 : 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.betCollectionView) {
        UGGameplayModel *model = self.gameDataArray[self.typeIndexPath.row];
        UGGameplaySectionModel *type = nil;
        
        if ([@"DWD" isEqualToString:model.code]) {
            type = model.list[self.segmentIndex];
            if ([@"DWDZXS" isEqualToString:type.ezdwcode]||[@"DWDZXL" isEqualToString:type.ezdwcode]
                ||[@"DWDZXSFS" isEqualToString:type.ezdwcode] ||[@"DWDZXLFS" isEqualToString:type.ezdwcode] ) {
                if (section == 0 || section == 1) {
                    return 0;
                } else {
                    UGGameplaySectionModel *type = model.list[self.segmentIndex];
                    UGGameplaySectionModel *obj = type.ezdwlist[section];
                    return obj.list.count;
                }
            }
            else{
                if (section == 0 ) {
                    return 0;
                } else {
                    UGGameplaySectionModel *type = model.list[self.segmentIndex];
                    UGGameplaySectionModel *obj = type.ezdwlist[section];
                    return obj.list.count;
                }
            }
            
        }
        
        if ([@"EZ" isEqualToString:model.code] && section == 0) {
            return 0;
        }
        if ([@"EZ" isEqualToString:model.code] ) {
            UGGameplaySectionModel *type = model.list[self.segmentIndex];
            UGGameplaySectionModel *obj = type.ezdwlist[section];
            return obj.list.count;
        }
        else {
            UGGameplaySectionModel *type = model.list[section];
            return type.list.count;
        }
        
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
        UGGameBetModel *game = nil;
        if ([@"DWD" isEqualToString:model.code]) {
            type = model.list[self.segmentIndex];
            UGGameplaySectionModel *obj = type.ezdwlist[indexPath.section];
            game = obj.list[indexPath.row];
        }
        else if ([@"EZ" isEqualToString:model.code]) {
            type = model.list[self.segmentIndex];
            UGGameplaySectionModel *obj = type.ezdwlist[indexPath.section];
            game = obj.list[indexPath.row];
            
        }
        else {
            type = model.list[indexPath.section];
            game = type.list[indexPath.row];
        }
        
        if ([@"第一球" isEqualToString:model.name] ||
            [@"第二球" isEqualToString:model.name] ||
            [@"第三球" isEqualToString:model.name] ||
            [@"跨度" isEqualToString:model.name] ||
            [@"独胆" isEqualToString:model.name] ||
            [@"HSWS" isEqualToString:model.code]) {
            if (indexPath.row < 10) {
                UGSSCBetItem1Cell *Cell = [collectionView dequeueReusableCellWithReuseIdentifier:sscBetItem1CellId forIndexPath:indexPath];
                Cell.item = game;
                return Cell;
            }
        }
        if ([@"HS" isEqualToString:model.code] ) {
            UGSSCBetItem1Cell *Cell = [collectionView dequeueReusableCellWithReuseIdentifier:sscBetItem1CellId forIndexPath:indexPath];
            Cell.item = game;
            return Cell;
        }
        if ([@"DWD" isEqualToString:model.code] ) {
            
            UGLinkNumCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:linkNumCellId forIndexPath:indexPath];
            cell.item = game;
            return cell;
        }
        if ([@"EZ" isEqualToString:model.code]) {
            
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
            if ([@"DWD" isEqualToString:model.code]) {
                if (!model.list.count) {
                    headerView.titleLabel.text = @"";
                    return headerView;
                }
                type = model.list[self.segmentIndex];
                if ([@"DWDFS" isEqualToString:type.ezdwcode]) {
                    if (indexPath.section == 0) {
                        [headerView.xxtitleLabel setHidden:YES];
                        [headerView.titleLabel setHidden:NO];
                        UGGameplaySectionModel *bet = type.ezdwlist.firstObject;
                        NSLog(@"bet.name =%@",bet.name);
                        if (bet == nil) {
                            bet = [UGGameplaySectionModel new];
                            bet.name = @"960";
                        }
                        if (APP.betOddsIsRed) {
                            headerView.titleLabel.attributedText = ({
                                NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] initWithString: [[NSString stringWithFormat:@"%.4f",[CMCommon newOgOdds: [bet.name  floatValue] rebate:[Global getInstanse].rebate]] removeFloatAllZero] attributes:@{NSForegroundColorAttributeName:Skin1.textColor1}];
                                [mas addAttributes:@{NSForegroundColorAttributeName:APP.AuxiliaryColor2} withString:[bet.name removeFloatAllZero]];
                                mas;
                            });
                        } else {
                            
                            headerView.titleLabel.text =  [[NSString stringWithFormat:@"%.4f",[CMCommon newOgOdds: [bet.name  floatValue] rebate:[Global getInstanse].rebate]] removeFloatAllZero];
                        }
                    }
                    else if (indexPath.section == 1){
                        [headerView.xxtitleLabel setHidden:YES];
                        [headerView.titleLabel setHidden:NO];
                        UGGameplaySectionModel *obj = type.ezdwlist[indexPath.section];
                        headerView.titleLabel.text = obj.name;
                    }
                    else if (indexPath.section == 2){
                        [headerView.xxtitleLabel setHidden:YES];
                        [headerView.titleLabel setHidden:NO];
                        UGGameplaySectionModel *obj = type.ezdwlist[indexPath.section];
                        headerView.titleLabel.text = obj.name;
                    }
                    else if (indexPath.section == 3){
                        [headerView.xxtitleLabel setHidden:YES];
                        [headerView.titleLabel setHidden:NO];
                        UGGameplaySectionModel *obj = type.ezdwlist[indexPath.section];
                        headerView.titleLabel.text = obj.name;
                    }
                }
                else if ([@"DWDZXS" isEqualToString:type.ezdwcode]){
                    if (indexPath.section == 0) {
                        [headerView.xxtitleLabel setHidden:YES];
                        [headerView.titleLabel setHidden:NO];
                        UGGameplaySectionModel *bet = type.ezdwlist.firstObject;
                        NSLog(@"bet.name =%@",bet.name);
                        if (bet == nil) {
                            bet = [UGGameplaySectionModel new];
                            bet.name = @"250";
                        }
                        if (APP.betOddsIsRed) {
                            headerView.titleLabel.attributedText = ({
                                NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] initWithString: [[NSString stringWithFormat:@"%.4f",[CMCommon newOgOdds: [bet.name  floatValue] rebate:[Global getInstanse].rebate]] removeFloatAllZero] attributes:@{NSForegroundColorAttributeName:Skin1.textColor1}];
                                [mas addAttributes:@{NSForegroundColorAttributeName:APP.AuxiliaryColor2} withString:[bet.name removeFloatAllZero]];
                                mas;
                            });
                        } else {
                            
                            headerView.titleLabel.text =  [[NSString stringWithFormat:@"%.4f",[CMCommon newOgOdds: [bet.name  floatValue] rebate:[Global getInstanse].rebate]] removeFloatAllZero];
                        }
                    }
                    else if (indexPath.section == 1){
                        UGGameplaySectionModel *obj = type.ezdwlist[indexPath.section];
                        headerView.xxtitleLabel.text = obj.name;
                        headerView.xxtitleLabel.textColor = Skin1.textColor2;
                        headerView.xxtitleLabel.font = [UIFont systemFontOfSize:13];
                        [headerView.xxtitleLabel setHidden:NO];
                        [headerView.titleLabel setHidden:YES];
                    }
                    else if (indexPath.section == 2){
                        UGGameplaySectionModel *obj = type.ezdwlist[indexPath.section];
                        headerView.titleLabel.text = obj.name;
                        [headerView.xxtitleLabel setHidden:YES];
                        [headerView.titleLabel setHidden:NO];
                    }
                    else if (indexPath.section == 3){
                        UGGameplaySectionModel *obj = type.ezdwlist[indexPath.section];
                        headerView.titleLabel.text = obj.name;
                        [headerView.xxtitleLabel setHidden:YES];
                        [headerView.titleLabel setHidden:NO];
                    }
                }
                else{
                    if (indexPath.section == 0) {
                        [headerView.xxtitleLabel setHidden:YES];
                        [headerView.titleLabel setHidden:NO];
                        UGGameplaySectionModel *bet = type.ezdwlist.firstObject;
                        NSLog(@"bet.name =%@",bet.name);
                        if (bet == nil) {
                            bet = [UGGameplaySectionModel new];
                            bet.name = @"134";
                        }
                        if (APP.betOddsIsRed) {
                            headerView.titleLabel.attributedText = ({
                                NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] initWithString: [[NSString stringWithFormat:@"%.4f",[CMCommon newOgOdds: [bet.name  floatValue] rebate:[Global getInstanse].rebate]] removeFloatAllZero] attributes:@{NSForegroundColorAttributeName:Skin1.textColor1}];
                                [mas addAttributes:@{NSForegroundColorAttributeName:APP.AuxiliaryColor2} withString:[bet.name removeFloatAllZero]];
                                mas;
                            });
                        } else {
                            
                            headerView.titleLabel.text =  [[NSString stringWithFormat:@"%.4f",[CMCommon newOgOdds: [bet.name  floatValue] rebate:[Global getInstanse].rebate]] removeFloatAllZero];
                        }
                    }
                    else if (indexPath.section == 1){
                        UGGameplaySectionModel *obj = type.ezdwlist[indexPath.section];
                        headerView.xxtitleLabel.text = obj.name;
                        headerView.xxtitleLabel.textColor = Skin1.textColor2;
                        headerView.xxtitleLabel.font = [UIFont systemFontOfSize:13];
                        [headerView.xxtitleLabel setHidden:NO];
                        [headerView.titleLabel setHidden:YES];
                        
                    }
                    else if (indexPath.section == 2){
                        [headerView.xxtitleLabel setHidden:YES];
                        [headerView.titleLabel setHidden:NO];
                        UGGameplaySectionModel *obj = type.ezdwlist[indexPath.section];
                        headerView.titleLabel.text = obj.name;
                    }
                }
                
            }
            else if ([@"EZ" isEqualToString:model.code]) {
                
                
                if (!model.list.count) {
                    headerView.titleLabel.text = @"";
                    return headerView;
                }
                if (indexPath.section == 0) {
                    [headerView.xxtitleLabel setHidden:YES];
                    [headerView.titleLabel setHidden:NO];
                    type = model.list[self.segmentIndex];
                    UGGameBetModel *bet = type.list.firstObject;
                    NSLog(@"bet.odds =%@",bet.odds);
                    if (bet == nil) {
                        bet = [UGGameBetModel new];
                        bet.odds = @"87.46";
                    }
                    if (APP.betOddsIsRed) {
                        headerView.titleLabel.attributedText = ({
                            NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] initWithString: [[NSString stringWithFormat:@"%.4f",[CMCommon newOgOdds: [bet.odds  floatValue] rebate:[Global getInstanse].rebate]] removeFloatAllZero] attributes:@{NSForegroundColorAttributeName:Skin1.textColor1}];
                            [mas addAttributes:@{NSForegroundColorAttributeName:APP.AuxiliaryColor2} withString:[bet.odds removeFloatAllZero]];
                            mas;
                        });
                    } else {
                        
                        headerView.titleLabel.text =  [[NSString stringWithFormat:@"%.4f",[CMCommon newOgOdds: [bet.odds  floatValue] rebate:[Global getInstanse].rebate]] removeFloatAllZero];
                    }
                }
                else if (indexPath.section == 1){
                    [headerView.xxtitleLabel setHidden:YES];
                    [headerView.titleLabel setHidden:NO];
                    type = model.list[self.segmentIndex ];
                    UGGameplaySectionModel *obj = type.ezdwlist[indexPath.section];
                    headerView.titleLabel.text = obj.name;
                }
                else if (indexPath.section == 2){
                    [headerView.xxtitleLabel setHidden:YES];
                    [headerView.titleLabel setHidden:NO];
                    type = model.list[self.segmentIndex ];
                    UGGameplaySectionModel *obj = type.ezdwlist[indexPath.section];
                    headerView.titleLabel.text = obj.name;
                }
            }
            else {
                [headerView.xxtitleLabel setHidden:YES];
                [headerView.titleLabel setHidden:NO];
                UGGameplaySectionModel *type = model.list[indexPath.section];
                headerView.titleLabel.text = type.name;
            }
            
        }else {
            [headerView.xxtitleLabel setHidden:YES];
            [headerView.titleLabel setHidden:NO];
            headerView.titleLabel.text = @"";
        }
        return headerView;
        
    }
    return nil;
    
}
//选了1个或者没选，
-(int )hasSelected:(NSArray *)list{
    int count = 0;
    for (UGGameBetModel *game in list) {
        if (game.select) {
            count++;
        }
    }
    return count ;
}

//
-(NSString * )modelSelected:(NSArray *)list{
    
    UGGameBetModel *mode  =  [UGGameBetModel new];
    mode.name = @"-1";
    
    for (UGGameBetModel *game in list) {
        if (game.select) {
            mode.name  = game.name;
        }
    }
    
    return mode.name;
}

-(void)setDanErCong:(NSIndexPath *)indexPath model:(UGGameBetModel *)game{
    if (indexPath.section == 2) {//2重号
        if (game.select) {
            self.erchonghao = game.name;
            self.erchonghaoModel = game;
        }
    }
    if (indexPath.section == 3) {//单号
        if (game.select) {
            self.danhao = game.name;
            self.danhaoModel = game;
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.betCollectionView) {
        
        if (self.lotteryView.closeView.hidden == NO) {
            [SVProgressHUD showInfoWithStatus:@"封盘中"];
            return;
        }
        
        
        UGGameplayModel *model = self.gameDataArray[self.typeIndexPath.row];
        
        if ([model.code isEqualToString:@"DWD"]) {
            UGGameplaySectionModel *type = model.list[self.segmentIndex];
            if ([type.ezdwcode isEqualToString:@"DWDFS"]) {
                UGGameplaySectionModel *obj = model.list[self.segmentIndex];
                UGGameplaySectionModel *type = obj.ezdwlist[indexPath.section];
                UGGameBetModel *game = type.list[indexPath.row];
                if (!(game.gameEnable && game.enable)) {
                    return;
                }
                game.select = !game.select;
            }
            else if([type.ezdwcode isEqualToString:@"DWDZXS"]) {
                UGGameplaySectionModel *obj = model.list[self.segmentIndex];
                UGGameplaySectionModel *type = obj.ezdwlist[indexPath.section];
                UGGameBetModel *game = type.list[indexPath.row];
                if (!(game.gameEnable && game.enable)) {
                    return;
                }
                //10个里面只能选择1个操作
                int count = [self hasSelected:type.list];
                if (count == 0) {
                    //单号，不能与2重号重复
                    if (indexPath.section == 3) {//单号
                        if ([game.name isEqualToString:self.erchonghao] ) {
                            return;
                        }
                    }
                    //单号，不能与2重号重复
                    if (indexPath.section == 2) {//二重号
                        if ([game.name isEqualToString:self.danhao] ) {
                            return;
                        }
                    }
                    
                    game.select = !game.select;
                    [self setDanErCong:indexPath model:game];
                    
                }
                else if(count == 1) {
                    if (game.select) {
                        game.select = !game.select;
                        [self setDanErCong:indexPath model:game];
                    }
                    else{
                        return;
                    }
                }
                else {
                    return;
                }
                
            }
            else if([type.ezdwcode isEqualToString:@"DWDZXL"]||[type.ezdwcode isEqualToString:@"DWDZXSFS"]||[type.ezdwcode isEqualToString:@"DWDZXLFS"]){
                UGGameplaySectionModel *obj = model.list[self.segmentIndex];
                UGGameplaySectionModel *type = obj.ezdwlist[indexPath.section];
                UGGameBetModel *game = type.list[indexPath.row];
                if (!(game.gameEnable && game.enable)) {
                    return;
                }
                
                NSInteger count = 0;
                for (UGGameBetModel *bet in type.list) {
                    if (bet.select) {
                        count ++;
                    }
                }
                
                if (count == 3 && !game.select) {
                    [SVProgressHUD showInfoWithStatus:@"不允许超过3个选项"];
                }else {
                    game.select = !game.select;
                    [self selArryAddGame:game];
                }
                
            }
            [self.betCollectionView reloadData];
            
            NSInteger selectedCount = 0;
            UGGameplaySectionModel *play = model.list[self.segmentIndex];
            for (UGGameplaySectionModel *type in play.ezdwlist) {
                for (UGGameBetModel *bet in type.list) {
                    if (bet.select) {
                        selectedCount ++;
                    }
                }
            }
            
            model.selectedCount = selectedCount;
            [self.tableView reloadData];
            [self.tableView selectRowAtIndexPath:self.typeIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            
            
            // 计算注数
            NSInteger count = 0;
            if ([type.ezdwcode isEqualToString:@"DWDFS"]) {
                [self szdwActionModel:model count:count];
                return;
            }
            else if([type.ezdwcode isEqualToString:@"DWDZXS"]) {
                if (self.erchonghao.length && self.danhao.length) {
                    count += 1;
                    [self updateSelectLabelWithCount:count];
                     return;
                }
            }
            else if([type.ezdwcode isEqualToString:@"DWDZXL"]||[type.ezdwcode isEqualToString:@"DWDZXSFS"]||[type.ezdwcode isEqualToString:@"DWDZXLFS"]){
                UGGameplaySectionModel *obj = model.list[self.segmentIndex];
                UGGameplaySectionModel *type = obj.ezdwlist[indexPath.section];
                NSInteger num = 0;
                for (UGGameBetModel *bet in type.list) {
                    if (bet.select) {
                        num ++;
                    }
                }
                
                if (num >= 3) {
                    count += 1;
                }
                
                [self updateSelectLabelWithCount:count];
                 return;
                
            }
            
        }
        else if ([@"EZ" isEqualToString:model.code] ) {
            
            UGGameplaySectionModel *obj = model.list[self.segmentIndex];
            UGGameplaySectionModel *type = obj.ezdwlist[indexPath.section];
            UGGameBetModel *game = type.list[indexPath.row];
            if (!(game.gameEnable && game.enable)) {
                return;
            }
            game.select = !game.select;
            [self.betCollectionView reloadData];
            
            // 计算注数
            NSInteger count = 0;
            [self ezdwActionModel:model count:count];
            
        }
        else {
            UGGameplaySectionModel *type = model.list[indexPath.section];
            UGGameBetModel *game = type.list[indexPath.row];
            if (!(game.gameEnable && game.enable)) {
                return;
            }
            game.select = !game.select;
            [self.betCollectionView reloadData];
            
            NSInteger selectedCount = 0;
            for (UGGameplaySectionModel *type in model.list) {
                for (UGGameBetModel *game in type.list) {
                    if (game.select) {
                        selectedCount ++;
                    }
                }
            }
            model.selectedCount = selectedCount;
            [self.tableView reloadData];
            [self.tableView selectRowAtIndexPath:self.typeIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            
            // 计算注数
            NSInteger count = 0;
            for (UGGameplayModel *model in self.gameDataArray) {
                if ([@"DWD,EZ" containsString:model.code]) continue;
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
    
}


//二字 计算选中的注数
-(void)ezdwActionModel:(UGGameplayModel *)model count:(NSInteger)count{
    FastSubViewCode(self.view)
    NSMutableArray *array = [NSMutableArray array];
    UGGameplaySectionModel *play = model.list[self.segmentIndex];
    if (play.ezdwlist.count) {
        NSMutableArray *mutArr1 = [NSMutableArray array];
        NSMutableArray *mutArr2 = [NSMutableArray array];
        
        UGGameplaySectionModel *model1 = play.ezdwlist[1];
        for (UGGameBetModel *bet in model1.list) {
            if (bet.select) {
                [mutArr1 addObject:bet];
            }
        }
        UGGameplaySectionModel *model2 = play.ezdwlist[2];
        for (UGGameBetModel *bet in model2.list) {
            if (bet.select) {
                [mutArr2 addObject:bet];
            }
        }
        
        model.selectedCount = mutArr1.count + mutArr2.count;
        [self.tableView reloadData];
        [self.tableView selectRowAtIndexPath:self.typeIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        
        if (mutArr1.count == 0 || mutArr2.count == 0) {
            count = 0;
            [self updateSelectLabelWithCount:count];
            return;
        }
        
        for (int i = 0; i < mutArr1.count; i++) {
            
            for (int y = 0; y < mutArr2.count; y++) {
                
                UGGameBetModel *beti = mutArr1[i];
                UGGameBetModel *bety = mutArr2[y];
                UGGameBetModel *bet = [[UGGameBetModel alloc] init];
                [bet setValuesForKeysWithDictionary:beti.mj_keyValues];
                NSMutableString *name = [[NSMutableString alloc] init];
                [name appendString:beti.name];
                [name appendString:@","];
                [name appendString:bety.name];
                bet.name = name;
                bet.money = subTextField(@"TKL下注TxtF").text;
                bet.title = bet.alias;
                bet.betInfo = name;
                [array addObject:bet];
                
            }
        }
        
        count = array.count;
        NSLog(@"count = %ld",(long)count);
        [self updateSelectLabelWithCount:count];
    }
}

//复式 计算选中的注数
-(void)szdwActionModel:(UGGameplayModel *)model count:(NSInteger)count{
    FastSubViewCode(self.view)
    NSMutableArray *array = [NSMutableArray array];
    UGGameplaySectionModel *play = model.list[self.segmentIndex];
    if (play.ezdwlist.count) {
        NSMutableArray *mutArr1 = [NSMutableArray array];
        NSMutableArray *mutArr2 = [NSMutableArray array];
        NSMutableArray *mutArr3 = [NSMutableArray array];
        
        UGGameplaySectionModel *model1 = play.ezdwlist[1];
        for (UGGameBetModel *bet in model1.list) {
            if (bet.select) {
                [mutArr1 addObject:bet];
            }
        }
        UGGameplaySectionModel *model2 = play.ezdwlist[2];
        for (UGGameBetModel *bet in model2.list) {
            if (bet.select) {
                [mutArr2 addObject:bet];
            }
        }
        UGGameplaySectionModel *model3 = play.ezdwlist[3];
        for (UGGameBetModel *bet in model3.list) {
            if (bet.select) {
                [mutArr3 addObject:bet];
            }
        }
        
        if (mutArr1.count == 0 || mutArr2.count == 0|| mutArr3.count == 0) {
            count = 0;
            [self updateSelectLabelWithCount:count];
            return;
        }
        
        for (int i = 0; i < mutArr1.count; i++) {
            
            for (int y = 0; y < mutArr2.count; y++) {
                
                for (int z = 0; z < mutArr3.count; z++) {
                    UGGameBetModel *beti = mutArr1[i];
                    UGGameBetModel *bety = mutArr2[y];
                    UGGameBetModel *betz = mutArr3[z];
                    UGGameBetModel *bet = [[UGGameBetModel alloc] init];
                    [bet setValuesForKeysWithDictionary:beti.mj_keyValues];
                    NSMutableString *name = [[NSMutableString alloc] init];
                    [name appendString:beti.name];
                    [name appendString:@","];
                    [name appendString:bety.name];
                    [name appendString:@","];
                    [name appendString:betz.name];
                    bet.name = name;
                    bet.money = subTextField(@"TKL下注TxtF").text;
                    bet.title = bet.alias;
                    bet.betInfo = name;
                    [array addObject:bet];
                }
            }
        }
        
        count = array.count;
        NSLog(@"count = %ld",(long)count);
        [self updateSelectLabelWithCount:count];
    }
}
#pragma mark - WSLWaterFlowLayoutDelegate
//返回每个item大小
- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    UGGameplayModel *model = self.gameDataArray[self.typeIndexPath.row];
    if ([@"EZ" isEqualToString:model.code]) {
        if (indexPath.row < 9) {
            return CGSizeMake((UGScreenW / 4 * 3 - 4) / 3, 40);
        }
        return CGSizeMake((UGScreenW / 4 * 3 - 4) / 1, 40);
        
    }
    return CGSizeMake((UGScreenW / 4 * 3 - 4) / 2, 40);
    
}
/** 头视图Size */
-(CGSize )waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForHeaderViewInSection:(NSInteger)section{
    UGGameplayModel *model = self.gameDataArray[self.typeIndexPath.row];
    UGGameplaySectionModel *type = nil;

    if ([@"DWD" isEqualToString:model.code]) {
        type = model.list[self.segmentIndex];
        if ([@"DWDZXSFS" isEqualToString:type.ezdwcode]||[@"DWDZXLFS" isEqualToString:type.ezdwcode]) {
            if (section == 1) {
                return CGSizeMake(UGScreenW / 4 * 3 - 1, 70);
            }
        }
    }
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
        collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0 , 0, UGScreenW / 4 * 3 - 1, height) collectionViewLayout:flow];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [collectionView registerNib:[UINib nibWithNibName:@"UGTimeLotteryBetCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:lottryBetCellid];
        [collectionView registerNib:[UINib nibWithNibName:@"UGSSCBetItem1Cell" bundle:nil] forCellWithReuseIdentifier:sscBetItem1CellId];
        [collectionView registerNib:[UINib nibWithNibName:@"UGTimeLotteryBetHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewID];
        [collectionView registerNib:[UINib nibWithNibName:@"UGLinkNumCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:linkNumCellId];
        collectionView;
        
    });
    self.betCollectionView = collectionView;
    [self.rightStackView addSubview:collectionView];
    // 这句话会导致提前刷新列表，找不到cellId导致闪退，要放到betCollectionView赋值之后
    collectionView.contentInset = UIEdgeInsetsMake(0, 0, 200, 0);
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
        
        collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(105 , 5, UGScreenW - 120 , 66) collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [collectionView registerNib:[UINib nibWithNibName:@"UGLotteryResultCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:lotteryResultCellid];
        [collectionView registerNib:[UINib nibWithNibName:@"UGLotterySubResultCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:lotterySubResultCellid];
        [collectionView registerNib:[UINib nibWithNibName:@"UGTimeLotteryBetHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewID];
        collectionView;
        
    });
    if (![LanguageHelper shared].isCN) {
        collectionView.height = 50;
        collectionView.centerY = self.headerOneView.height/2 + 2;
    }
    self.headerCollectionView = collectionView;
    [self.headerOneView addSubview:collectionView];
    [self.headerOneView bringSubviewToFront:self.historyBtn];
    
}

- (void)updateHeaderViewData {
    
    
    if (![CMCommon stringIsNull:self.nextIssueModel.preDisplayNumber]) {
        self.currentIssueLabel.text = [NSString stringWithFormat:@"%@期",self.nextIssueModel.preDisplayNumber];
    } else {
        self.currentIssueLabel.text = [NSString stringWithFormat:@"%@期",self.nextIssueModel.preIssue];
    }
    if (![CMCommon stringIsNull:self.nextIssueModel.displayNumber]) {
        self.nextIssueLabel.text = [NSString stringWithFormat:@"%@期",self.nextIssueModel.displayNumber];
    } else {
        self.nextIssueLabel.text = [NSString stringWithFormat:@"%@期",self.nextIssueModel.curIssue];
    }
    
    _currentIssueLabel.hidden = !self.nextIssueModel.preIssue.length;
    _nextIssueLabel.hidden = !self.nextIssueModel.curIssue.length;
    [self updateCloseLabelText];
    [self updateOpenLabelText];
    [self.headerCollectionView reloadData];
}




- (void)updateOpenLabelText {
    NSString *timeStr = [CMCommon getNowTimeWithEndTimeStr:self.nextIssueModel.curOpenTime currentTimeStr:self.nextIssueModel.serverTime];
    if (timeStr == nil) {
        timeStr = @"获取下一期";
    }else {
        
    }
    self.openTimeLabel.text = [NSString stringWithFormat:@"开奖:%@",timeStr];
    if ([timeStr isEqualToString:@"00:01"]&& [[NSUserDefaults standardUserDefaults]boolForKey:@"lotteryHormIsOpen"]) {
        [self  playerLotterySound];
    }
    [self updateOpenLabel];
    
}



//这个方法是有用的不要删除
- (void)updateOpenLabel {}

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
        adView.nm = model;
        [adView show];
        self.showAdPoppuView = YES;
    }
}


#pragma mark - textField delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        FastSubViewCode(self.view)
        [subTextField(@"TKL下注TxtF") resignFirstResponder];
        return NO;
    }
    
    return YES;
}

//一字定位玩法数据处理
- (void)handleData {
    for (UGGameplayModel *model in self.gameDataArray) {
        
        NSLog(@"model=%@",model);
        if ([@"DWD" isEqualToString:model.code]) {
            
            if (model.list.count) {
                int lenth = (int )model.list.count;
                for (int i = 0; i < lenth; i++) {
                    UGGameplaySectionModel *group = [model.list objectAtIndex:i];
                    
                    if (group.list.count) {
                        UGGameBetModel *play = [group.list objectAtIndex:0];
                        
                        if ([play.code isEqualToString:@"DWDFS"]) {
                            NSMutableArray *sectionArray = [NSMutableArray array];
                            for (int i = 0; i< 4; i++) {
                                UGGameplaySectionModel * sectionModel = [[UGGameplaySectionModel alloc] init];
                                if (i == 0 ) {
                                    sectionModel.name = play.odds;
                                }
                                else if (i == 1 ) {
                                    sectionModel.name = @"第一球(百位)";
                                }
                                else if (i == 2 ) {
                                    sectionModel.name = @"第二球(十位)";
                                }
                                else if (i == 3 ) {
                                    sectionModel.name = @"第三球(个位)";
                                }
                                [sectionArray addObject:sectionModel];
                            }
                            for (UGGameplaySectionModel *sectionModel in sectionArray) {
                                NSMutableArray *array = [NSMutableArray array];
                                for (int i = 0; i < 10; i++) {
                                    UGGameBetModel *bet = [[UGGameBetModel alloc] init];
                                    [bet setValuesForKeysWithDictionary:play.mj_keyValues];
                                    bet.alias = bet.name;
                                    bet.typeName = group.name;
                                    bet.name = [NSString stringWithFormat:@"%d",i ];
                                    [array addObject:bet];
                                }
                                sectionModel.list = array.copy;
                            }
                            group.ezdwlist = sectionArray.copy;
                            group.ezdwcode = @"DWDFS";
                        }
                        else if([play.code isEqualToString:@"DWDZXS"]){
                            NSMutableArray *sectionArray = [NSMutableArray array];
                            for (int i = 0; i< 4; i++) {
                                UGGameplaySectionModel * sectionModel = [[UGGameplaySectionModel alloc] init];
                                if (i == 0 ) {
                                    sectionModel.name = play.odds;
                                }
                                else if (i == 1 ) {
                                    sectionModel.name = @"玩法提示：选一个二重号，一个单号组成一注。(单号号码不得与二重号重复)";
                                }
                                else if (i == 2 ) {
                                    sectionModel.name = @"二重号";
                                }
                                else if (i == 3 ) {
                                    sectionModel.name = @"单号";
                                }
                                [sectionArray addObject:sectionModel];
                            }
                            for (UGGameplaySectionModel *sectionModel in sectionArray) {
                                NSMutableArray *array = [NSMutableArray array];
                                for (int i = 0; i < 10; i++) {
                                    UGGameBetModel *bet = [[UGGameBetModel alloc] init];
                                    [bet setValuesForKeysWithDictionary:play.mj_keyValues];
                                    bet.alias = bet.name;
                                    bet.typeName = group.name;
                                    bet.name = [NSString stringWithFormat:@"%d",i ];
                                    [array addObject:bet];
                                }
                                sectionModel.list = array.copy;
                            }
                            group.ezdwlist = sectionArray.copy;
                            group.ezdwcode = @"DWDZXS";
                        }
                        else if([play.code isEqualToString:@"DWDZXL"]||[play.code isEqualToString:@"DWDZXSFS"]||[play.code isEqualToString:@"DWDZXLFS"]){
                            NSMutableArray *sectionArray = [NSMutableArray array];
                            for (int i = 0; i< 3; i++) {
                                UGGameplaySectionModel * sectionModel = [[UGGameplaySectionModel alloc] init];
                                if (i == 0 ) {
                                    sectionModel.name = play.odds;
                                    
                                }
                                else if (i == 1 ) {
                                    if ([play.code isEqualToString:@"DWDZXL"]) {
                                        sectionModel.name = @"玩法提示：任选3个号码组成一注(号码不重复)";
                                    }
                                    else if([play.code isEqualToString:@"DWDZXSFS"]){
                                        sectionModel.name = @"玩法提示：从0~9选择两个号码(或以上)，系统会自动将所选号码的所有组三组合(即三个号中有两个号相同)进行购买，若当期开奖号码的形态为组三且包含了号码，即中奖";
                                    }
                                    else if([play.code isEqualToString:@"DWDZXLFS"]){
                                        sectionModel.name = @"玩法提示：从0~9选择三个号码或多个号码投注，所选号码与开奖号码的百位、十位、个位相同，顺序不限，即为中奖";
                                    }
                                    
                                  
                                }
                                else if (i == 2 ) {
                                    sectionModel.name = @"选号";
                                }
                                
                                [sectionArray addObject:sectionModel];
                            }
                            for (UGGameplaySectionModel *sectionModel in sectionArray) {
                                NSMutableArray *array = [NSMutableArray array];
                                for (int i = 0; i < 10; i++) {
                                    UGGameBetModel *bet = [[UGGameBetModel alloc] init];
                                    [bet setValuesForKeysWithDictionary:play.mj_keyValues];
                                    bet.alias = bet.name;
                                    bet.typeName = group.name;
                                    bet.name = [NSString stringWithFormat:@"%d",i ];
                                    [array addObject:bet];
                                }
                                sectionModel.list = array.copy;
                            }
                            group.ezdwlist = sectionArray.copy;
                            if ([play.code isEqualToString:@"DWDZXL"]) {
                                group.ezdwcode = @"DWDZXL";
                            }
                            else if([play.code isEqualToString:@"DWDZXSFS"]){
                                group.ezdwcode = @"DWDZXSFS";
                            }
                            else if([play.code isEqualToString:@"DWDZXLFS"]){
                                group.ezdwcode = @"DWDZXLFS";
                            }
                           
                        }
                        
                    }
                }
            }
            
        }
        
        
        
        else  if ([@"EZ" isEqualToString:model.code]) {
            
            NSLog(@"model=%@",model);
            
            if (model.list.count) {
                int lenth = (int )model.list.count;
                
                for (int k = 0; k < lenth; k++) {
                    UGGameplaySectionModel *group = [model.list objectAtIndex:k];
                    
                    if (group.list.count) {
                        UGGameBetModel *play = group.list.firstObject;
                        NSMutableArray *sectionArray = [NSMutableArray array];
                        NSLog(@"group.alias =%@",group.alias);
                        for (int i = 0; i< 3; i++) {
                            UGGameplaySectionModel * sectionModel = [[UGGameplaySectionModel alloc] init];
                            if (i == 0 ) {
                                sectionModel.name = play.odds;
                            }else if (i == 1 ) {
                                if (k == 0) {
                                    sectionModel.name = @"第一球（百位）";
                                }
                                else if(k == 1){
                                     sectionModel.name = @"第一球（百位）";
                                }
                                else if(k == 2){
                                     sectionModel.name = @"第二球（十位）";
                                }
                         
                            }
                            else if (i == 2 ) {
                     
                                if (k == 0) {
                                     sectionModel.name = @"第二球（十位）";
                                }
                                else if(k == 1){
                                    sectionModel.name = @"第三球（个位）";
                                }
                                else if(k == 2){
                                    sectionModel.name = @"第三球（个位）";
                                }
                            }
                            [sectionArray addObject:sectionModel];
                        }
                        
                        for (UGGameplaySectionModel *sectionModel in sectionArray) {
                            NSMutableArray *array = [NSMutableArray array];
                            for (int i = 0; i < 10; i++) {
                                UGGameBetModel *bet = [[UGGameBetModel alloc] init];
                                [bet setValuesForKeysWithDictionary:play.mj_keyValues];
                                bet.alias = bet.name;
                                bet.typeName = group.name;
                                bet.name = [NSString stringWithFormat:@"%d",i ];
                                [array addObject:bet];
                            }
                            sectionModel.list = array.copy;
                        }
                        group.ezdwlist = sectionArray.copy;
                    }
                }
            }
            
            
            
        }
    }
    
}

- (UITableView *)tableViewInit {
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"UGTimeLotteryLeftTitleCell" bundle:nil] forCellReuseIdentifier:@"UGTimeLotteryLeftTitleCell"];
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.rowHeight = 40;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 80, 0);
    
    
    return _tableView;
}

- (UITableView *)headertableViewInit {
    
    _headerTabView.delegate = self;
    _headerTabView.dataSource = self;
    [_headerTabView registerNib:[UINib nibWithNibName:@"UGLotteryRecordTableViewCell" bundle:nil] forCellReuseIdentifier:@"UGLotteryRecordTableViewCell"];
    [self.headerTabView setBackgroundColor:[UIColor clearColor]];
    self.headerTabView.delegate = self;
    self.headerTabView.dataSource = self;
    self.headerTabView.estimatedSectionHeaderHeight = 0;
    self.headerTabView.estimatedSectionFooterHeight = 0;
    
    return _headerTabView;
}


- (NSMutableArray<UGGameplayModel *> *)gameDataArray {
    if (_gameDataArray == nil) {
        _gameDataArray = [NSMutableArray array];
        
    }
    return _gameDataArray;
}


#pragma mark - BetRadomProtocal
- (NSUInteger)minSectionsCountForBet {
	UGGameplayModel *model = self.gameDataArray[self.typeIndexPath.row];
	if ([model.name isEqualToString:@"定位胆"] ){
		if (self.segmentIndex == 0 ){
			return 4;
		} else if (self.segmentIndex == 1) {
			return 4;
		} else if (self.segmentIndex == 2) {
			return 3;
		}
	} else if ([model.name isEqualToString:@"二字"] ){
		
		return 3;
		
	}
	return 1;
}

- (NSUInteger)minItemsCountForBetIn:(NSUInteger)section {
	
	UGGameplayModel *model = self.gameDataArray[self.typeIndexPath.row];
	if ([model.name isEqualToString:@"定位胆"]){
		if (self.segmentIndex == 0 ){
			if (section == 0) {
				return 0;
			} else {
				return 1;
			}
		} else if (self.segmentIndex == 1) {
			if (section == 0 || section == 1) {
				return 0;
			} else {
				return 1;
			}
		} else if (self.segmentIndex == 2) {
			if (section == 0 || section == 1) {
				return 0;
			} else {
				return 3;
			}
		}
	} else if ([model.name isEqualToString:@"二字"] ) {
		if (section == 0) {
			return 0;
		} else {
			return 1;
		}
	}
	return 1;
}

@end

