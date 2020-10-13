//
//  UGBeijingRacingController.m
//  ug
//
//  Created by ug on 2019/5/27.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGBJPK10LotteryController.h"
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
#import "WSLWaterFlowLayout.h"
#import "UGChangLongController.h"
#import "UGFundsViewController.h"
#import "UGBetRecordViewController.h"
#import "UGLotteryRulesView.h"
#import "UGLotteryRecordController.h"
#import "UGSSCBetItem1Cell.h"

#import "UGLotteryAdPopView.h"
#import "UGPCDDLotteryController.h"
#import "UGJSK3LotteryController.h"
#import "UGHKLHCLotteryController.h"
#import "UGQXCLotteryController.h"
#import "UGSSCLotteryController.h"
#import "UGGD11X5LotteryController.h"
#import "UGXYNCLotteryController.h"
#import "UGBJKL8LotteryController.h"
#import "UGGDKL10LotteryController.h"
#import "UGFC3DLotteryController.h"
#import "UGPK10NNLotteryController.h"

#import "UGYYRightMenuView.h"
//官方玩法 --View
#import "UGSegmentView.h"
#import "UGLotteryHistoryModel.h"
#import "UGLotteryRecordTableViewCell.h"
#import "CMTimeCommon.h"
#import "UGBJPK10LotteryBetCollectionHeader.h"

@interface UGBJPK10LotteryController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,YBPopupMenuDelegate,WSLWaterFlowLayoutDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *currentIssueLabel;/**<头 上 当前开奖  */
@property (weak, nonatomic) IBOutlet UIButton *historyBtn;/**<头 上 历史记录按钮  */
@property (weak, nonatomic) IBOutlet UILabel *nextIssueLabel;/**<头 下 下期开奖  */
@property (weak, nonatomic) IBOutlet UILabel *closeTimeLabel;/**<头 下 封盘时间  */
@property (weak, nonatomic) IBOutlet UILabel *openTimeLabel;/**<头 下 开奖时间  */

@property (weak, nonatomic) IBOutlet UITextField *amountTextF;/**<底部  下注金额 */
@property (weak, nonatomic) IBOutlet UILabel *selectLabel;/**<底部  已选中  */
@property (weak, nonatomic) IBOutlet UIButton *chipButton;/**<底部  筹码  */
@property (weak, nonatomic) IBOutlet UIButton *betButton; /**<底部  下注  */
@property (weak, nonatomic) IBOutlet UIButton *resetButton;/**<底部  重置  */
@property (weak, nonatomic) IBOutlet UIView *bottomCloseView;/**<底部  封盘  */

@property (weak, nonatomic) IBOutlet UIView *headerOneView;/**<头 上*/
@property (weak, nonatomic) IBOutlet UIView *headerMidView;/**<头 中*/
@property (weak, nonatomic) IBOutlet UIView *nextIssueView;/**<头 下*/
@property (weak, nonatomic) IBOutlet UIView *contentView;  /**<内容*/
@property (weak, nonatomic) IBOutlet UIView *bottomView;         /**<   底部 */
@property (weak, nonatomic) IBOutlet UIView *iphoneXBottomView;/**<iphoneX的t底部*/

@property (weak, nonatomic) IBOutlet UITableView *headerTabView;/**<   历史开奖*/
@property (nonatomic, strong) NSMutableArray <UGLotteryHistoryModel *> *dataArray;/**<   历史开奖数据*/
@property (nonatomic, weak)IBOutlet UITableView *tableView;                   /**<   玩法列表TableView */
@property (nonatomic, strong) NSMutableArray <UGGameplayModel *>*gameDataArray;    /**<   玩法列表 */
@property (weak, nonatomic) IBOutlet UIStackView *rightStackView;/**<右边内容*/

@property (nonatomic, strong) UICollectionView *headerCollectionView;
@property (nonatomic, strong) UICollectionView *betCollectionView;
@property (nonatomic, strong) NSArray <NSString *> *chipArray;
@property (nonatomic, strong) NSIndexPath *typeIndexPath;
@property (nonatomic, strong) NSIndexPath *itemIndexPath;
@property (nonatomic, strong) NSArray <NSString *> *preNumArray;
@property (nonatomic, strong) NSArray <NSString *> *preNumSxArray;

@property (strong, nonatomic) CountDown *countDown;

@property (nonatomic, strong) STBarButtonItem *rightItem1;
@property (nonatomic, strong) WSLWaterFlowLayout *flow;

@property (nonatomic, assign) BOOL showAdPoppuView;

@property (strong, nonatomic)UGYYRightMenuView *yymenuView;

//======================================官方玩法=========
@property (nonatomic, strong) UGSegmentView *segmentView;                           /**<   segment*/
@property (nonatomic, assign) NSInteger segmentIndex;                               /**<   segment选中的Index */
@property (nonatomic, strong) NSMutableArray <NSString *> *lmgmentTitleArray;       /**<   segment 的标题 */
@property (nonatomic, strong) NSMutableArray *selArray ;                            /**<  官方玩法选中的 */
@property (nonatomic, assign) NSInteger ezdwSegmentIndex;
//===============================================

@end

static NSString *leftTitleCellid = @"UGTimeLotteryLeftTitleCell";
static NSString *lottryBetCellid = @"UGTimeLotteryBetCollectionViewCell";
static NSString *sscBetItem1CellId = @"UGSSCBetItem1Cell";
static NSString *headerViewID = @"UGTimeLotteryBetHeaderView";
static NSString *lotteryResultCellid = @"UGLotteryResultCollectionViewCell";
static NSString *lotterySubResultCellid = @"UGLotterySubResultCollectionViewCell";
@implementation UGBJPK10LotteryController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.chipButton.layer.cornerRadius = 5;
    self.chipButton.layer.masksToBounds = YES;
    self.betButton.layer.cornerRadius = 5;
    self.chipButton.layer.masksToBounds = YES;
    self.resetButton.layer.cornerRadius = 5;
    self.resetButton.layer.masksToBounds = YES;
    self.amountTextF.delegate = self;

    self.bottomCloseView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.bottomCloseView.hidden = YES;

    
    
    
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
     
    

     //连码
     [self.rightStackView addSubview:self.segmentView];
     [self initHeaderCollectionView];
     [self initBetCollectionView];
    
    WeakSelf
    self.segmentIndex = 0;
    self.segmentView.segmentIndexBlock = ^(NSInteger row) {
        weakSelf.segmentIndex = row;
        [weakSelf.betCollectionView reloadData];
        [weakSelf resetClick:nil];
    };
    self.lmgmentTitleArray = [NSMutableArray new];
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
    [self.view bringSubviewToFront:self.iphoneXBottomView];
    
    
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
            if (weakSelf.nextIssueModel) {
                if (OBJOnceToken(weakSelf)) {
                    [weakSelf getLotteryHistory ];
                }
            }
            [weakSelf showAdPoppuView:model.data];
            [weakSelf updateHeaderViewData];
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
            
            
            NSLog(@"model.data= %@",model.data);
            UGPlayOddsModel *play = model.data;
            weakSelf.gameDataArray = play.playOdds.mutableCopy;
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
            
            
            //连码
            for (UGGameplayModel *model in weakSelf.gameDataArray) {
                if ([@"官方玩法" isEqualToString:model.name]) {
                    NSLog(@"model.list= %@",model.list);
                    for (UGGameplaySectionModel *type in model.list) {
                        NSLog(@"type.alias= %@",type.alias);
                        [weakSelf.lmgmentTitleArray addObject:type.alias];
                        
                    }
                }
            }
            [weakSelf handleData];
            weakSelf.segmentView.dataArray = weakSelf.lmgmentTitleArray;
            
            [weakSelf.tableView reloadData];
            [weakSelf.betCollectionView reloadData];
            [weakSelf.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
            
        } failure:^(id msg) {
            [SVProgressHUD dismiss];
        }];
    }];
}

//官方玩法数据处理
- (void)handleData {
    for (UGGameplayModel *model in self.gameDataArray) {
        if (![@"官方玩法" isEqualToString:model.name]) {
			continue;;
        }
		for (UGGameplaySectionModel *group in model.list) {
			if (!group.list.count) {continue;}
			UGGameBetModel *play = group.list.firstObject;
			NSArray * sectionTitleArray = @{@"猜冠军": @[@"猜冠军"],
											@"猜前二": @[@"冠军", @"亚军"],
											@"猜前三": @[@"冠军", @"亚军", @"季军"],
											@"猜前四": @[@"猜前四"],
											@"猜前五": @[@"猜前五"]}[group.alias];
			NSMutableArray *sectionArray = [NSMutableArray array];
			for (NSString * sectionTitle in sectionTitleArray) {
				UGGameplaySectionModel * sectionModel = [[UGGameplaySectionModel alloc] init];
				sectionModel.name = sectionTitle;
				[sectionArray addObject:sectionModel];
			}
			for (UGGameplaySectionModel * sectionModel in sectionArray) {
				NSMutableArray * array = [NSMutableArray array];
				for (int j = 0; j < 10; j ++) {
					UGGameBetModel *bet = [[UGGameBetModel alloc] init];
					[bet setValuesForKeysWithDictionary:play.mj_keyValues];
					bet.typeName = group.name;
					bet.alias = play.name;
					bet.name = [NSString stringWithFormat:@"%d", j+1];
					[array addObject:bet];
				}
				sectionModel.list = array.copy;
			}
			group.ezdwlist = sectionArray.copy;
		}
    }
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

- (void)refreshBalance {
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
			for (UGGameplaySectionModel *section in type.ezdwlist) {
				for (UGGameBetModel *game in section.list) {
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
    [self.amountTextF resignFirstResponder];
    ck_parameters(^{
         ck_parameter_non_equal(self.selectLabel.text, @"0", @"请选择玩法");
        ck_parameter_non_empty(self.amountTextF.text, @"请输入投注金额");
    }, ^(id err) {
        [SVProgressHUD showInfoWithStatus:err];
    }, ^{
        NSString *selCode = @"";
        NSMutableArray *array = [NSMutableArray array];
		UGGameplayModel *model =  self.gameDataArray[self.typeIndexPath.row];
		selCode = model.code;
		if ([model.name isEqualToString:@"官方玩法"]) {
			[self gfwfBetActionMode:model array:&array selCode:&selCode];
		} else {
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
        NSMutableArray *dicArray = [UGGameBetModel mj_keyValuesArrayWithObjectArray:array];
        [self goUGBetDetailViewObjArray:array.copy dicArray:dicArray.copy issueModel:self.nextIssueModel  gameType:self.nextIssueModel.gameId selCode:selCode];
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
        cell.item = self.dataArray[indexPath.row];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
     if ([tableView isEqual:self.tableView]) {
         self.typeIndexPath = indexPath;
		 self.segmentView.segmentIndexBlock(0);
         UGGameplayModel *model = self.gameDataArray[indexPath.row];
         if ([@"官方玩法" isEqualToString:model.name]) {
             self.segmentView.dataArray = self.lmgmentTitleArray;
             if (self.segmentView.hidden) {
                 
                 self.betCollectionView.y += self.segmentView.height;
                 self.betCollectionView.height -= self.segmentView.height;
             }
             self.segmentView.hidden = NO;
             [self resetClick:nil];
         }
         else {
             if (!self.segmentView.hidden) {
                 
                 self.betCollectionView.y -= self.segmentView.height;
                 self.betCollectionView.height += self.segmentView.height;
             }
             self.segmentView.hidden = YES;
             
         }
         [self.betCollectionView reloadData];
         [self.betCollectionView setContentOffset:CGPointMake(0, 0) animated:YES];
     }

}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (collectionView != self.betCollectionView) {
		return [LanguageHelper shared].isCN ? 2 : 1;
    }
	if (!self.gameDataArray.count) {
		return 0;
	}
	UGGameplayModel *model = self.gameDataArray[self.typeIndexPath.row];
	UGGameplaySectionModel *type = model.list[self.segmentIndex];
	if ([@"官方玩法" isEqualToString:model.name]) {
		return self.ezdwSegmentIndex == 1 ? type.ezdwlist.count : 1;
	} else {
		return model.list.count;
	}
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.betCollectionView) {
        UGGameplayModel *model = self.gameDataArray[self.typeIndexPath.row];
		UGGameplaySectionModel *play = model.list[self.segmentIndex];
		if ([@"官方玩法" isEqualToString:model.name]) {
			UGGameplaySectionModel *type = play.ezdwlist[section];
			return type.list.count;
		} else {
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
        
        UGGameplaySectionModel *type;
        if ([@"官方玩法" isEqualToString:model.name]) {
            type = model.list[self.segmentIndex];
        } else {
            type = model.list[indexPath.section];
        }
        
        UGGameBetModel *game = type.list[indexPath.row];
        
        if ([@"冠军" isEqualToString:model.name] ||
            [@"亚军" isEqualToString:model.name] ||
            [@"第三名" isEqualToString:model.name] ||
            [@"第四名" isEqualToString:model.name] ||
            [@"第五名" isEqualToString:model.name] ||
            [@"第六名" isEqualToString:model.name] ||
            [@"第七名" isEqualToString:model.name] ||
            [@"第八名" isEqualToString:model.name] ||
            [@"第八名" isEqualToString:model.name] ||
            [@"第九名" isEqualToString:model.name] ||
            [@"第十名" isEqualToString:model.name] ||
            [@"1-5名" isEqualToString:model.name] ||
            [@"6-10名" isEqualToString:model.name]) {
            
            UGSSCBetItem1Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:sscBetItem1CellId forIndexPath:indexPath];
            cell.item = game;
            if (game.name.integerValue > 0 && game.name.integerValue < 11) {
                
                cell.nameColor = [CMCommon getPreNumColor:game.name];
                cell.nameCornerRadius = 5;
                return cell;
            }
        }
        else if ( [@"官方玩法" isEqualToString:model.name]){
			UGSSCBetItem1Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:sscBetItem1CellId forIndexPath:indexPath];
			UGGameplaySectionModel *section = type.ezdwlist[indexPath.section];
			UGGameBetModel *game = section.list[indexPath.item];
			cell.item = game;
			cell.nameColor = [CMCommon getPreNumColor:game.name];
			cell.nameCornerRadius = 5;
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
            
            NSLog(@"self.nextIssueModel.gameType = %@",self.nextIssueModel.gameType);
            if ([self.nextIssueModel.gameType isEqualToString:@"dlt"]) {
                cell.color = [CMCommon getDLTColor:indexPath.row+1];
            } else {
                cell.backgroundColor = [CMCommon getPreNumColor:self.preNumArray[indexPath.row]];
            }
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
            UGGameplaySectionModel *type = model.list[indexPath.section];
            if ([@"官方玩法" isEqualToString:model.name]) {
                if (model.list.count) {
                    type = model.list[self.segmentIndex];
                    headerView.titleLabel.text = type.alias;
					if ([@"猜前二,猜前三" containsString:type.alias] && indexPath.section == 0) {
						UGBJPK10LotteryBetCollectionHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UGBJPK10LotteryBetCollectionHeader" forIndexPath:indexPath];
						headerView.headerLabel.text = type.alias;
						headerView.segmentValueChangedBlock = ^(NSInteger index){
						self.ezdwSegmentIndex = index;
						[self resetClick:nil];
						};
						return headerView;
					} else if ([@"猜前二,猜前三" containsString:type.alias]) {
						UGGameplaySectionModel * group = type.ezdwlist[indexPath.section];
						headerView.titleLabel.text = group.name;

					}
					
                }
            }
            else {
                headerView.titleLabel.text = type.name;
            }
        }else {
            
            headerView.titleLabel.text = @"";
            
        }
        return headerView;
        
    }
    return nil;
    
}

-(void)selArryAddGame:(UGGameBetModel *)game{
    if (game.select) {
        [_selArray addObject:game];
    } else {
        if ([_selArray containsObject:game]) {
            [_selArray removeObject:game];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView != self.betCollectionView) {
		return;
	}
	if (self.bottomCloseView.hidden == NO) {
		[SVProgressHUD showInfoWithStatus:@"封盘中"];
		return;
	}
	UGGameplayModel *model = self.gameDataArray[self.typeIndexPath.row];
	if ([@"官方玩法" isEqualToString:model.name]) {
		
		UGGameplaySectionModel *obj = model.list[self.segmentIndex];
		UGGameplaySectionModel *type = obj.ezdwlist[indexPath.section];
		UGGameBetModel *game = type.list[indexPath.row];
		if ([self isRepeatNumber:game.name]) {
			[SVProgressHUD showInfoWithStatus:@"不允许选择相同的选项"];
			return;
		}

		if (!(game.gameEnable && game.enable)) {
			return;
		}
		NSInteger typeCount = 0;
		int maxIndexOfSelect = 0;
		for (UGGameBetModel *game in type.list) {
			if (game.select) {
				typeCount ++;
				maxIndexOfSelect = maxIndexOfSelect > game.indexOfSelect ? maxIndexOfSelect: game.indexOfSelect;
			}
		}
		NSInteger maxItemsCount =  [self maxItemsCountForBetIn: indexPath.section];
		if (typeCount < maxItemsCount) {
			game.select = !game.select;
		} else if (game.select){
			game.select = !game.select;
		} else {
			[SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"不允许超过%ld个选项", maxItemsCount]];
		}
		game.indexOfSelect = game.select? maxIndexOfSelect + 1: 0;
		[self.betCollectionView reloadData];
		[self gfwfBetCountWithModel: model];
	} else {
		UGGameplaySectionModel *type = model.list[indexPath.section];
		UGGameBetModel *game = type.list[indexPath.row];
		if (!(game.gameEnable && game.enable)) {
			return;
		}
		game.select = !game.select;
		NSInteger count = 0;
		for (UGGameplaySectionModel *type in model.list) {
			for (UGGameBetModel *game in type.list) {
				if (game.select) {
					count ++;
				}
			}
		}
		[self.betCollectionView reloadData];
		[self updateSelectLabelWithCount:count];
	}
}


//复式下注方法
- (void)generateBetArrayWith: (NSArray<UGGameplaySectionModel*> *)originalArray
						 bet: (nullable UGGameBetModel*)bet
				 resultArray: (NSMutableArray *__strong *)resultArray
					   index: (int) index {
	if (index >= originalArray.count) {
		return;
	}
	UGGameplaySectionModel * section = originalArray[index];
	for (UGGameBetModel * game in section.list) {
		if (!game.select) {
			continue;
		}
		NSString * info = bet? [bet.betInfo stringByAppendingFormat:@",%@", game.name]: game.name;
		UGGameBetModel *bet = [[UGGameBetModel alloc] init];
		[bet setValuesForKeysWithDictionary:game.mj_keyValues];
		bet.betInfo = info;
		bet.money = self.amountTextF.text;
		bet.name = bet.betInfo;
		bet.title = game.alias;
		if (originalArray.lastObject == section) {
			[*resultArray addObject: bet];
		}
		[self generateBetArrayWith:originalArray bet:bet resultArray:resultArray index:index + 1];
	}
	
}

#pragma mark - WSLWaterFlowLayoutDelegate

//返回每个item大小
- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((UGScreenW / 4 * 3 - 4) / 2, 40);
}

/** 头视图Size */
-(CGSize )waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForHeaderViewInSection:(NSInteger)section {
	UGGameplayModel *model = self.gameDataArray[self.typeIndexPath.row];
	UGGameplaySectionModel *type = model.list[section];
	if ([@"官方玩法" isEqualToString:model.name]) {
		if (model.list.count) {
			type = model.list[self.segmentIndex];
			if ([@"猜前二,猜前三" containsString:type.alias] && section == 0) {
				UICollectionView * colllectionView = waterFlowLayout.collectionView;
				return  CGSizeMake(colllectionView.frame.size.width, self.ezdwSegmentIndex == 0 ? 100 : 150);
			}

		}
		
	}
	
    return CGSizeMake(UGScreenW / 4 * 3 - 1, 35);
}

/** 列间距*/
-(CGFloat)columnMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout {
    if (self.typeIndexPath.row == 17) {
        return 10;
    }
    return 1;
}
/** 行间距*/
-(CGFloat)rowMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout {
    if (self.typeIndexPath.row == 17) {
        return 10;
    }
    return 1;
}
/** 边缘之间的间距*/
-(UIEdgeInsets)edgeInsetInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout {
    
    //    if (self.typeIndexPath.row == 17) {
    //        self.betCollectionView.backgroundColor = [UIColor whiteColor];
    //        return UIEdgeInsetsMake(1, 10, 1, 1);
    //    }
    //    self.betCollectionView.backgroundColor = [UIColor clearColor];
    return UIEdgeInsetsMake(1, 1, 1, 1);
}



- (void)initBetCollectionView {
    
    self.flow = [[WSLWaterFlowLayout alloc] init];
    self.flow.delegate = self;
    self.flow.flowLayoutStyle = WSLWaterFlowVerticalEqualHeight;
    
    UICollectionView *collectionView = ({
        float height;
        if ([CMCommon isPhoneX]) {
            height = UGScerrnH - 88 - 83 - 114;
        }else {
            height = UGScerrnH - 64 - 49 - 114;
        }
        collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0 , 0, UGScreenW / 4 * 3 - 1, height) collectionViewLayout:self.flow];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [collectionView registerNib:[UINib nibWithNibName:@"UGTimeLotteryBetCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:lottryBetCellid];
        [collectionView registerNib:[UINib nibWithNibName:@"UGSSCBetItem1Cell" bundle:nil] forCellWithReuseIdentifier:sscBetItem1CellId];
        [collectionView registerNib:[UINib nibWithNibName:@"UGTimeLotteryBetHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewID];
		[collectionView registerNib:[UINib nibWithNibName:@"UGBJPK10LotteryBetCollectionHeader" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UGBJPK10LotteryBetCollectionHeader"];

		
        collectionView;
        
    });
    collectionView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
    self.betCollectionView = collectionView;
      [self.rightStackView addSubview:collectionView];
    
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
        
        collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(120 , 5, UGScreenW - 120 , 55) collectionViewLayout:layout];
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

    
    NSString *preStr = @"";
     if (![CMCommon stringIsNull:self.nextIssueModel.preDisplayNumber]) {
        preStr = self.nextIssueModel.preDisplayNumber;
    } else {
        preStr = self.nextIssueModel.preIssue;
    }
    if (preStr.length >=12) {
        NSString *str4 = [preStr substringFromIndex:2];
        self.currentIssueLabel.text = [NSString stringWithFormat:@"%@期",str4];
    }
    else {
        self.currentIssueLabel.text = [NSString stringWithFormat:@"%@期",preStr];
    
    }
    NSString *curStr = @"";
     if (![CMCommon stringIsNull:self.nextIssueModel.displayNumber]) {
        curStr = self.nextIssueModel.displayNumber;
    } else {
        curStr = self.nextIssueModel.curIssue;
    }
    
    if (curStr.length >=12) {
        NSString *str4 = [curStr substringFromIndex:2];
        self.nextIssueLabel.text = [NSString stringWithFormat:@"%@期",str4];
    }
    else {
        self.nextIssueLabel.text = [NSString stringWithFormat:@"%@期",curStr];
    }
    _currentIssueLabel.hidden = !self.nextIssueModel.preIssue.length;
    _nextIssueLabel.hidden = !self.nextIssueModel.curIssue.length;
    [self updateCloseLabelText];
    [self updateOpenLabelText];
    CGSize size = [self.nextIssueModel.preIssue sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
    if (self.nextIssueModel.curIssue.length >=12) {
       self.headerCollectionView.x = 25 + size.width-18;
    }
    else {
       self.headerCollectionView.x = 25 + size.width;
    }
    
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


- (void)updateOpenLabelText{
    NSString *timeStr = [CMCommon getNowTimeWithEndTimeStr:self.nextIssueModel.curOpenTime currentTimeStr:self.nextIssueModel.serverTime];
    if (timeStr == nil) {
        timeStr = @"获取下一期";
    }
    self.openTimeLabel.text = [NSString stringWithFormat:@"开奖:%@",timeStr];
    if ([timeStr isEqualToString:@"00:01"]&& [[NSUserDefaults standardUserDefaults]boolForKey:@"lotteryHormIsOpen"]) {
        [self  playerLotterySound];
    }
    [self updateOpenLabel];
    
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
        [self.amountTextF resignFirstResponder];
        return NO;
    }
    return YES;
}

- (UITableView *)tableViewInit {

        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"UGTimeLotteryLeftTitleCell" bundle:nil] forCellReuseIdentifier:@"UGTimeLotteryLeftTitleCell"];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.rowHeight = 40;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);

    
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

//官方玩法
- (UGSegmentView *)segmentView {
    if (_segmentView == nil) {
        _segmentView = [[UGSegmentView alloc] initWithFrame:CGRectMake(0, 0, UGScreenW /4 * 3, 50) titleArray:self.lmgmentTitleArray];
        _segmentView.hidden = YES;
        
    }
    return _segmentView;
    
}

#pragma mark - BetRadomProtocal
- (NSUInteger)minSectionsCountForBet {
	UGGameplayModel *model = self.gameDataArray[self.typeIndexPath.row];
	if ([model.name isEqualToString:@"1-5名"] || [model.name isEqualToString:@"6-10名"]) {
		return 5;
	}
	if ([@"两面" isEqualToString:model.name]) {
		return 11;
	}
	if ([@"官方玩法" isEqualToString:model.name]) {
		return [self numberOfSectionsInCollectionView:self.betCollectionView];
	}
	return 1;
}
- (NSUInteger)minItemsCountForBetIn:(NSUInteger)section {
	
	UGGameplayModel *model = self.gameDataArray[self.typeIndexPath.row];
	UGGameplaySectionModel * sectionModel = model.list[self.segmentIndex];
	if ([@"官方玩法" isEqualToString:model.name] && self.ezdwSegmentIndex == 1 && [@"猜前二、猜前三" containsString:sectionModel.alias]) {
		return 1;
	}
	if ([model.name isEqualToString:@"官方玩法"]) {
		return self.segmentIndex + 1;
	}
	if ([@"两面" isEqualToString:model.name] && section == 0) {
		return 0;
	}
	return 1;
}
- (NSUInteger)maxItemsCountForBetIn:(NSUInteger)section {
	UGGameplayModel *model = self.gameDataArray[self.typeIndexPath.row];
	UGGameplaySectionModel * sectionModel = model.list[self.segmentIndex];
	if ([@"官方玩法" isEqualToString:model.name]) {
		if (self.ezdwSegmentIndex == 1 && [@"猜前二、猜前三" containsString:sectionModel.alias]) {
			NSNumber * number = @{@"猜前二": @9, @"猜前三": @8}[sectionModel.alias];
			return [number integerValue];
		} else {
			return [@[@"猜冠军", @"猜前二", @"猜前三", @"猜前四", @"猜前五"] indexOfObject: sectionModel.alias] + 1;
		}
	}
	return 1;
}

-(void)gfwfBetCountWithModel:(UGGameplayModel *)model {
	
	UGGameplaySectionModel * group = model.list[self.segmentIndex];
	
	// 复式的记数方法
	// TO DO: 归类复式玩法
	if ([@"官方玩法" isEqualToString:model.name] && self.ezdwSegmentIndex == 1 && [@"猜前二、猜前三" containsString:group.alias]) {
		NSMutableArray * countArray = [NSMutableArray array];
		[self generateBetArrayWith:group.ezdwlist bet:nil resultArray:&countArray index:0];
		[self updateSelectLabelWithCount:countArray.count];
	} else {
		UGGameplaySectionModel * section = group.ezdwlist[0];
		NSInteger count = 0;
		for (UGGameBetModel * bet in section.list ) {
			if (bet.select) {
				count ++;
			}
		}
		if (count == [self minItemsCountForBetIn:0]) {
			[self updateSelectLabelWithCount:1];
		} else {
			[self updateSelectLabelWithCount:0];
		}
		
	}

}

-(BOOL)isRepeatNumber:(NSString *) numberString{
	UGGameplayModel *model = self.gameDataArray[self.typeIndexPath.row];
	UGGameplaySectionModel * group = model.list[self.segmentIndex];
	if ([@"官方玩法" isEqualToString:model.name] && self.ezdwSegmentIndex == 1 && [@"猜前二、猜前三" containsString:group.alias]) {
		for (UGGameplaySectionModel * section in group.ezdwlist) {
			for (UGGameBetModel * bet in section.list) {
				if (!bet.select) {
					continue;
				}
				return numberString == bet.name;
			}
		}
	}
	return false;
}
-(void)gfwfBetActionMode:(UGGameplayModel *)model array :(NSMutableArray *__strong *) array selCode :(NSString *__strong *)selCode {
	*selCode = model.code;
	if (!model.list.count) {
		return;
	}
	UGGameplaySectionModel *group = model.list[self.segmentIndex];
	
	if ([@"官方玩法" isEqualToString:model.name] && self.ezdwSegmentIndex == 1 && [@"猜前二、猜前三" containsString:group.alias]) {
		[self generateBetArrayWith:group.ezdwlist bet:nil resultArray:array index:0];
	} else {
		NSMutableArray * selectedBetArray = [NSMutableArray array];
		for (UGGameplaySectionModel * sectionModel in group.ezdwlist) {
			for (UGGameBetModel * bet in sectionModel.list) {
				if (!bet.select) {
					continue;
				}
				[selectedBetArray appendObject:bet];
			}
		}
		[selectedBetArray sortUsingComparator:^NSComparisonResult(UGGameBetModel * _Nonnull obj1, UGGameBetModel * _Nonnull obj2) {
			return  obj1.indexOfSelect > obj2.indexOfSelect;
		}];
		UGGameBetModel *tempBet;
		NSString * betName;
		for (UGGameBetModel * bet in selectedBetArray) {
			tempBet = bet;
			betName = betName? [NSString stringWithFormat:@"%@,%@", betName, bet.name]: bet.name;
		}
		UGGameBetModel *bet = [[UGGameBetModel alloc] init];
		[bet setValuesForKeysWithDictionary:tempBet.mj_keyValues];
		bet.name = betName;
		bet.money = self.amountTextF.text;
		bet.title = tempBet.alias;
		bet.betInfo = betName;
		[*array addObject:bet];
	}
	
}
@end

