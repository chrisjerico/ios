//
//  UGSelFiveLotteryController.m
//  ug
//
//  Created by ug on 2019/6/15.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGGD11X5LotteryController.h"
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
#import "MailBoxTableViewController.h"

#import "UGChangLongController.h"
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
#import "UGXYNCLotteryController.h"
#import "UGBJKL8LotteryController.h"
#import "UGGDKL10LotteryController.h"
#import "UGFC3DLotteryController.h"
#import "UGPK10NNLotteryController.h"

#import "UGYYRightMenuView.h"

#import "UGLotteryHistoryModel.h"
#import "UGLotteryRecordTableViewCell.h"
#import "CMTimeCommon.h"

@interface UGGD11X5LotteryController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,YBPopupMenuDelegate,UITextFieldDelegate,WSLWaterFlowLayoutDelegate>
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
@property (nonatomic, strong) UGSegmentView *segmentView;
@property (nonatomic, strong) NSMutableArray <NSString *> *lmgmentTitleArray;
@property (nonatomic, strong) NSMutableArray <NSString *> *zxgmentTitleArray;
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
@implementation UGGD11X5LotteryController

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
            if (self.nextIssueModel) {
                if (OBJOnceToken(self)) {
                    [self getLotteryHistory ];
                }
            }
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
						[self.lmgmentTitleArray addObject:type.alias];
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
            
            // 删除enable为NO的数据（不显示出来）
            for (UGGameplayModel *gm in play.playOdds) {
                for (UGGameplaySectionModel *gsm in gm.list) {
                    if (!gsm.enable)
                        [self.gameDataArray removeObject:gm];
                }
            }
			[self handleData];
			self.segmentView.dataArray = self.lmgmentTitleArray;
			[self.tableView reloadData];
			[self.betCollectionView reloadData];
			[self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
		} failure:^(id msg) {
			
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
        NSString *selCode = @"";
		NSMutableArray *array = [NSMutableArray array];
		
		UGGameplayModel *play = self.gameDataArray[self.typeIndexPath.row];
    
        NSLog(@"play.code=%@",play.code);
		if ([@"直选" isEqualToString:play.name]) {
            
            selCode = play.code;
			if (play.list.count) {
				NSMutableArray *mutArr0 = [NSMutableArray array];
				NSMutableArray *mutArr1 = [NSMutableArray array];
				NSMutableArray *mutArr2 = [NSMutableArray array];
				if (self.segmentIndex == 0) {
					UGGameplaySectionModel *model0 = play.list[0];
					for (UGGameplayModel *bet in model0.list) {
						if (bet.select) {
							[mutArr0 addObject:bet];
						}
					}
					UGGameplaySectionModel *model1 = play.list[1];
					for (UGGameplayModel *bet in model1.list) {
						if (bet.select) {
							[mutArr1 addObject:bet];
						}
					}
					if (mutArr0.count == 0 || mutArr1.count == 0) {
						[SVProgressHUD showInfoWithStatus:@"下注内容不正确，请重新下注"];
						return ;
					}
				}else {
					UGGameplaySectionModel *model0 = play.list[2];
					for (UGGameplayModel *bet in model0.list) {
						if (bet.select) {
							[mutArr0 addObject:bet];
						}
					}
					UGGameplaySectionModel *model1 = play.list[3];
					for (UGGameplayModel *bet in model1.list) {
						if (bet.select) {
							[mutArr1 addObject:bet];
						}
					}
					UGGameplaySectionModel *model2 = play.list[4];
					for (UGGameplayModel *bet in model2.list) {
						if (bet.select) {
							[mutArr2 addObject:bet];
						}
					}
					if (mutArr0 == 0 || mutArr1 == 0 || mutArr2 == 0) {
						[SVProgressHUD showInfoWithStatus:@"下注内容不正确，请重新下注"];
						return;
					}
					
				}
				
				if (mutArr2.count) {
					
					for (int i = 0; i < mutArr0.count; i++) {
						
						for (int y = 0; y < mutArr1.count; y++) {
							
							for (int z = 0; z < mutArr2.count; z++) {
								UGGameBetModel *beti = mutArr0[i];
								UGGameBetModel *bety = mutArr1[y];
								UGGameBetModel *betz = mutArr2[z];
								UGGameBetModel *bet = [[UGGameBetModel alloc] init];
								[bet setValuesForKeysWithDictionary:beti.mj_keyValues];
								NSMutableString *name = [[NSMutableString alloc] init];
								[name appendString:beti.name];
								[name appendString:@","];
								[name appendString:bety.name];
								[name appendString:@","];
								[name appendString:betz.name];
								bet.name = name;
								bet.money = self.amountTextF.text;
								bet.title = bet.alias;
								bet.betInfo = name;
								[array addObject:bet];
							}
						}
					}
					
				}else {
					for (int i = 0; i < mutArr0.count; i++) {
						
						for (int y = 0; y < mutArr1.count; y++) {
							
							UGGameBetModel *beti = mutArr0[i];
							UGGameBetModel *bety = mutArr1[y];
							UGGameBetModel *bet = [[UGGameBetModel alloc] init];
							[bet setValuesForKeysWithDictionary:beti.mj_keyValues];
							NSMutableString *name = [[NSMutableString alloc] init];
							[name appendString:beti.name];
							[name appendString:@","];
							[name appendString:bety.name];
							bet.name = name;
							bet.money = self.amountTextF.text;
							bet.title = bet.alias;
							bet.betInfo = name;
							[array addObject:bet];
							
						}
					}
					
				}
				
			}
			
			
		}else {
			
         
			for (UGGameplayModel *model in self.gameDataArray) {
				if (!model.select) {
					continue;
				}
                NSLog(@"model.code ======================== %@",model.code);
                selCode = model.code;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:self.tableView]) {
        return  40.0;
    } else {
        UGLotteryHistoryModel *model = self.dataArray.firstObject;
        if ([@"bjkl8" isEqualToString:model.gameType] ||
            [@"pk10nn" isEqualToString:model.gameType] ||
            [@"jsk3" isEqualToString:model.gameType]
            ) {
            return 100;
        }
        return 80;
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
          UGGameplayModel *lastModel = self.gameDataArray[self.typeIndexPath.row];
          self.typeIndexPath = indexPath;
          UGGameplayModel *model = self.gameDataArray[indexPath.row];
          if ([@"连码" isEqualToString:lastModel.name]) {
              [self resetClick:nil];
          }
          
          if ([@"连码" isEqualToString:model.name]) {
              self.segmentView.dataArray = self.lmgmentTitleArray;
              if (self.segmentView.hidden) {
                  
                  self.betCollectionView.y += self.segmentView.height;
                  self.betCollectionView.height -= self.segmentView.height;
              }
              self.segmentView.hidden = NO;
              [self resetClick:nil];
          }else if ([@"直选" isEqualToString:model.name]) {
              self.segmentView.dataArray = self.zxgmentTitleArray;
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
	if (collectionView == self.betCollectionView) {
		if (self.gameDataArray.count) {
			
			UGGameplayModel *model = self.gameDataArray[self.typeIndexPath.row];
			if ([@"连码" isEqualToString:model.name]) {
				return 1;
			}else if ([@"直选" isEqualToString:model.name]) {
				if (self.segmentIndex == 0) {
					return 3;
				}
				return 4;;
			}else {
				
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
		if ([@"直选" isEqualToString:model.name] && section == 0) {
			return 0;
		}
		if (!model.list.count) {
			return 0;
		}
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
			
		}else if ([@"直选" isEqualToString:model.name]) {
			if (self.segmentIndex == 0) {
				type = model.list[indexPath.section - 1];
			}else {
				type = model.list[indexPath.section + 1];
			}
			
		}else {
			type = model.list[indexPath.section];
			
		}
		UGGameBetModel *game = type.list[indexPath.row];
		if ([@"连码" isEqualToString:model.name]) {
			game.name = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
		}
		if ([@"第一球" isEqualToString:model.name] ||
			[@"第二球" isEqualToString:model.name] ||
			[@"第三球" isEqualToString:model.name] ||
			[@"第四球" isEqualToString:model.name] ||
			[@"第五球" isEqualToString:model.name] ||
			[@"一中一" isEqualToString:model.name]) {
			if (indexPath.row < 11) {
				UGSSCBetItem1Cell *Cell = [collectionView dequeueReusableCellWithReuseIdentifier:sscBetItem1CellId forIndexPath:indexPath];
				Cell.item = game;
				return Cell;
			}
		}
		if ([@"连码" isEqualToString:model.name] ||
			[@"直选" isEqualToString:model.name]) {
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
				if (model.list.count) {
					
					type = model.list[self.segmentIndex];
					UGBetModel *bet = type.list.firstObject;
                    if (APP.betOddsIsRed) {
                        headerView.titleLabel.attributedText = ({
                            
                            NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] initWithString:[[NSString stringWithFormat:@"%.4f",[CMCommon newOgOdds: [bet.odds  floatValue] rebate:[Global getInstanse].rebate]] removeFloatAllZero] attributes:@{NSForegroundColorAttributeName:Skin1.textColor1}];
                            [mas addAttributes:@{NSForegroundColorAttributeName:APP.AuxiliaryColor2} withString:[bet.odds removeFloatAllZero]];
                            mas;
                        });
                    } else {
                        headerView.titleLabel.text =  [[NSString stringWithFormat:@"%.4f",[CMCommon newOgOdds: [bet.odds  floatValue] rebate:[Global getInstanse].rebate]] removeFloatAllZero];

                    }
				}
			}else if ([@"直选" isEqualToString:model.name]) {
				if (!model.list.count) {
					headerView.titleLabel.text = @"";
					return headerView;
				}
				if (indexPath.section == 0) {
					
					if (self.segmentIndex == 0) {
						type = model.list[0];
						
					}else {
						type = model.list[2];
					}
					UGGameBetModel *bet = type.list.firstObject;
        
                    if (APP.betOddsIsRed) {
                        headerView.titleLabel.attributedText = ({
                            NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] initWithString: [[NSString stringWithFormat:@"%.4f",[CMCommon newOgOdds: [bet.odds  floatValue] rebate:[Global getInstanse].rebate]] removeFloatAllZero] attributes:@{NSForegroundColorAttributeName:Skin1.textColor1}];
                            [mas addAttributes:@{NSForegroundColorAttributeName:APP.AuxiliaryColor2} withString:[bet.odds removeFloatAllZero]];
                            mas;
                        });
                    } else {
                        
                        headerView.titleLabel.text =  [[NSString stringWithFormat:@"%.4f",[CMCommon newOgOdds: [bet.odds  floatValue] rebate:[Global getInstanse].rebate]] removeFloatAllZero];
                    }
				}else {
					
					if (self.segmentIndex == 0) {
						type = model.list[indexPath.section - 1];
					}else {
						type = model.list[indexPath.section + 1];
					}
					headerView.titleLabel.text = type.name;
				}
			}else {
				type = model.list[indexPath.section];
				headerView.titleLabel.text = type.name;
			}
		}else {
			
			headerView.titleLabel.text = @"";
		}
        
        if (APP.betSizeIsBig) {
            headerView.titleLabel.font = APP.cellBigFont;
        } else {
            headerView.titleLabel.font = APP.cellNormalFont;
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
		}else if ([@"直选" isEqualToString:model.name]) {
			
			if (self.segmentIndex == 0) {
				type = model.list[indexPath.section - 1];
			}else {
				type = model.list[indexPath.section + 1];
			}
		}else {
			type = model.list[indexPath.section];
		}
		UGGameBetModel *game = type.list[indexPath.row];
        if (!(game.gameEnable && game.enable)) {
             return;
        }
		if ([@"直选" isEqualToString:model.name]) {
			UGGameplaySectionModel *sectionModel = nil;
			if (self.segmentIndex == 0) {
				if (indexPath.section == 1) {
					sectionModel = model.list[1];
					
				}else {
					sectionModel = model.list[0];
				}
				UGGameBetModel *bet = sectionModel.list[indexPath.row];
				if (!bet.select) {
					game.select = !game.select;
				}
			}else {
				if (indexPath.section == 1) {
					sectionModel = model.list[3];
					UGGameBetModel *bet = sectionModel.list[indexPath.row];
					if (!bet.select) {
						sectionModel = model.list[4];
						UGGameBetModel *bet = sectionModel.list[indexPath.row];
						if (!bet.select) {
							game.select = !game.select;
						}
					}
				}else if (indexPath.section == 2) {
					sectionModel = model.list[2];
					UGGameBetModel *bet = sectionModel.list[indexPath.row];
					if (!bet.select) {
						sectionModel = model.list[4];
						UGGameBetModel *bet = sectionModel.list[indexPath.row];
						if (!bet.select) {
							game.select = !game.select;
						}
					}
					
				}else {
					sectionModel = model.list[2];
					UGGameBetModel *bet = sectionModel.list[indexPath.row];
					if (!bet.select) {
						sectionModel = model.list[3];
						UGGameBetModel *bet = sectionModel.list[indexPath.row];
						if (!bet.select) {
							game.select = !game.select;
						}
					}
					
				}
			}
			
		}else if ([@"连码" isEqualToString:model.name]) {
			NSInteger count = 0;
			for (UGGameBetModel *bet in type.list) {
				if (bet.select) {
					count ++;
				}
			}
			NSString *title = self.lmgmentTitleArray[self.segmentIndex];
			if ([@"二中二" isEqualToString:title]) {
				
				if (count == 2 && !game.select) {
					[SVProgressHUD showInfoWithStatus:@"不允许超过2个选项"];
				}else {
					game.select = !game.select;
				}
			}else if ([@"三中三" isEqualToString:title]) {
				if (count == 3 && !game.select) {
					[SVProgressHUD showInfoWithStatus:@"不允许超过3个选项"];
				}else {
					game.select = !game.select;
				}
			}else if ([@"四中四" isEqualToString:title]) {
				if (count == 4 && !game.select) {
					[SVProgressHUD showInfoWithStatus:@"不允许超过4个选项"];
				}else {
					game.select = !game.select;
				}
			}else if ([@"五中五" isEqualToString:title] ||
					  [@"前二组选" isEqualToString:title] ||
					  [@"前三组选" isEqualToString:title]) {
				if (count == 5 && !game.select) {
					[SVProgressHUD showInfoWithStatus:@"不允许超过5个选项"];
				}else {
					game.select = !game.select;
				}
			}else if ([@"六中五" isEqualToString:title]) {
				if (count == 6 && !game.select) {
					[SVProgressHUD showInfoWithStatus:@"不允许超过6个选项"];
				}else {
					game.select = !game.select;
				}
			}else if ([@"七中五" isEqualToString:title]) {
				if (count == 7 && !game.select) {
					[SVProgressHUD showInfoWithStatus:@"不允许超过7个选项"];
				}else {
					game.select = !game.select;
				}
			}else if ([@"八中五" isEqualToString:title]) {
				if (count == 8 && !game.select) {
					[SVProgressHUD showInfoWithStatus:@"不允许超过8个选项"];
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
		
		//        计算选中的注数
		NSInteger count = 0;
		for (UGGameplayModel *model in self.gameDataArray) {
			if (!model.select) {
				continue;
			}
			for (UGGameplaySectionModel *type in model.list) {
				if ([@"连码" isEqualToString:model.name]) {
					NSInteger num = 0;
					for (UGGameBetModel *bet in type.list) {
						if (bet.select) {
							num ++;
						}
					}
					NSString *title = self.lmgmentTitleArray[self.segmentIndex];
					if ([@"二中二" isEqualToString:title]) {
						if (num >= 2) {
							count += 1;
						}
					}else if ([@"三中三" isEqualToString:title]) {
						if (num >= 3) {
							count += 1;
						}
					}else if ([@"四中四" isEqualToString:title]) {
						if (num >= 4) {
							count += 1;
						}
					}else if ([@"五中五" isEqualToString:title]) {
						if (num >= 5) {
							count += 1;
						}
					}else if ([@"六中五" isEqualToString:title]) {
						if (num >= 6) {
							count += 1;
						}
					}else if ([@"七中五" isEqualToString:title]) {
						if (num >= 7) {
							count += 1;
						}
					}else if ([@"八中五" isEqualToString:title]) {
						if (num >= 8) {
							count += 1;
						}
					}else if ([@"前二组选" isEqualToString:title]) {
						if (num >= 2) {
							count += [CMCommon pickNum:2 totalNum:num];
						}
					}else if ([@"前三组选" isEqualToString:title]) {
						if (num >= 3) {
							count += [CMCommon pickNum:3 totalNum:num];
						}
					}else {
						
					}
					
					continue;
				} else if ([@"直选" isEqualToString:model.name]) {
					NSMutableArray *array = [NSMutableArray array];
					UGGameplayModel *play = self.gameDataArray[self.typeIndexPath.row];
					if (play.list.count) {
						NSMutableArray *mutArr0 = [NSMutableArray array];
						NSMutableArray *mutArr1 = [NSMutableArray array];
						NSMutableArray *mutArr2 = [NSMutableArray array];
						if (self.segmentIndex == 0) {
							UGGameplaySectionModel *model0 = play.list[0];
							for (UGGameplayModel *bet in model0.list) {
								if (bet.select) {
									[mutArr0 addObject:bet];
								}
							}
							UGGameplaySectionModel *model1 = play.list[1];
							for (UGGameplayModel *bet in model1.list) {
								if (bet.select) {
									[mutArr1 addObject:bet];
								}
							}
							if (mutArr0.count == 0 || mutArr1.count == 0) {
								return ;
							}
						}else {
							UGGameplaySectionModel *model0 = play.list[2];
							for (UGGameplayModel *bet in model0.list) {
								if (bet.select) {
									[mutArr0 addObject:bet];
								}
							}
							UGGameplaySectionModel *model1 = play.list[3];
							for (UGGameplayModel *bet in model1.list) {
								if (bet.select) {
									[mutArr1 addObject:bet];
								}
							}
							UGGameplaySectionModel *model2 = play.list[4];
							for (UGGameplayModel *bet in model2.list) {
								if (bet.select) {
									[mutArr2 addObject:bet];
								}
							}
							if (mutArr0 == 0 || mutArr1 == 0 || mutArr2 == 0) {
								return;
							}
							
						}
						
						if (mutArr2.count) {
							
							for (int i = 0; i < mutArr0.count; i++) {
								
								for (int y = 0; y < mutArr1.count; y++) {
									
									for (int z = 0; z < mutArr2.count; z++) {
										UGGameBetModel *beti = mutArr0[i];
										UGGameBetModel *bety = mutArr1[y];
										UGGameBetModel *betz = mutArr2[z];
										UGGameBetModel *bet = [[UGGameBetModel alloc] init];
										[bet setValuesForKeysWithDictionary:beti.mj_keyValues];
										NSMutableString *name = [[NSMutableString alloc] init];
										[name appendString:beti.name];
										[name appendString:@","];
										[name appendString:bety.name];
										[name appendString:@","];
										[name appendString:betz.name];
										bet.name = name;
										bet.money = self.amountTextF.text;
										bet.title = bet.alias;
										bet.betInfo = name;
										[array addObject:bet];
									}
								}
							}
							
						}else {
							for (int i = 0; i < mutArr0.count; i++) {
								
								for (int y = 0; y < mutArr1.count; y++) {
									
									UGGameBetModel *beti = mutArr0[i];
									UGGameBetModel *bety = mutArr1[y];
									UGGameBetModel *bet = [[UGGameBetModel alloc] init];
									[bet setValuesForKeysWithDictionary:beti.mj_keyValues];
									NSMutableString *name = [[NSMutableString alloc] init];
									[name appendString:beti.name];
									[name appendString:@","];
									[name appendString:bety.name];
									bet.name = name;
									bet.money = self.amountTextF.text;
									bet.title = bet.alias;
									bet.betInfo = name;
									[array addObject:bet];
									
								}
							}
							
						}
						
					}
					count = array.count;
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
	
	UGGameplayModel *model = self.gameDataArray[self.typeIndexPath.row];
	if ([@"第一球" isEqualToString:model.name] ||
        [@"第二球" isEqualToString:model.name] ||
        [@"第三球" isEqualToString:model.name] ||
        [@"第四球" isEqualToString:model.name] ||
        [@"第五球" isEqualToString:model.name]) {
		if (indexPath.row < 9) {
			return CGSizeMake((UGScreenW / 4 * 3 - 4) / 3, 40);
		}
	}
	if ([@"一中一" isEqualToString:model.name] ||
		[@"连码" isEqualToString:model.name] ||
		[@"直选" isEqualToString:model.name]) {
		if (indexPath.row < 9) {
			return CGSizeMake((UGScreenW / 4 * 3 - 4) / 3, 40);
		}
		return CGSizeMake((UGScreenW / 4 * 3 - 4) / 2, 40);
		
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
		collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0 , 0, UGScreenW / 4 * 3 - 1, height) collectionViewLayout:flow];
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
	}else {
		self.bottomCloseView.hidden = YES;
	}
	self.closeTimeLabel.text = [NSString stringWithFormat:@"封盘:%@",timeStr];
	[self updateCloseLabel];
	
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

//连码玩法数据处理
- (void)handleData {
	
	for (UGGameplayModel *model in self.gameDataArray) {
		if ([@"连码" isEqualToString:model.name]) {
			for (UGGameplaySectionModel *group in model.list) {
				if (group.list.count) {
					UGGameBetModel *play = group.list.firstObject;
					NSMutableArray *array = [NSMutableArray array];
					for (int i = 0; i < 11; i++) {
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
		
		if ([@"直选" isEqualToString:model.name]) {
			if (!model.list.count) {
				return;
			}
			UGGameplaySectionModel *section0 = model.list.firstObject;
			UGGameplaySectionModel *section1 = model.list.lastObject;
			[self.zxgmentTitleArray addObject:section0.alias];
			[self.zxgmentTitleArray addObject:section1.alias];
			NSMutableArray *sectionArray = [NSMutableArray array];
			for (int i = 0; i < 5; i++) {
				UGGameplaySectionModel * sectionModel = [[UGGameplaySectionModel alloc] init];
				if (i < 2) {
					[sectionModel setValuesForKeysWithDictionary:section0.mj_keyValues];
				}else {
					[sectionModel setValuesForKeysWithDictionary:section1.mj_keyValues];
				}
				sectionModel.typeName = sectionModel.name;
				//                sectionModel.alias = sectionModel.name;
				if (i == 0 || i == 2) {
					
					sectionModel.name = @"第一球";
					
				}else if (i == 1 || i == 3) {
					sectionModel.name = @"第二球";
				}else {
					sectionModel.name = @"第三球";
				}
				[sectionArray addObject:sectionModel];
				
			}
			
			for (UGGameplaySectionModel *sectionModel in sectionArray) {
				UGGameBetModel *play = sectionModel.list.firstObject;
				NSMutableArray *array = [NSMutableArray array];
				for (int i = 0; i < 11; i++) {
					UGGameBetModel *bet = [[UGGameBetModel alloc] init];
					[bet setValuesForKeysWithDictionary:play.mj_keyValues];
					bet.alias = bet.name;
					bet.typeName = model.name;
					bet.name = [NSString stringWithFormat:@"%d",i + 1];
					[array addObject:bet];
				}
				sectionModel.list = array.copy;
			}
			
			model.list = sectionArray.copy;
			
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


- (UGSegmentView *)segmentView {
    if (_segmentView == nil) {
        _segmentView = [[UGSegmentView alloc] initWithFrame:CGRectMake(0, 0, UGScreenW /4 * 3, 50) titleArray:self.lmgmentTitleArray];
        _segmentView.hidden = YES;
        
    }
    return _segmentView;
    
}


- (NSMutableArray<UGGameplayModel *> *)gameDataArray {
	if (_gameDataArray == nil) {
		_gameDataArray = [NSMutableArray array];
	}
	return _gameDataArray;
}

- (NSMutableArray *)lmgmentTitleArray {
	if (_lmgmentTitleArray == nil) {
		_lmgmentTitleArray = [NSMutableArray array];
	}
	return _lmgmentTitleArray;
	
}

- (NSMutableArray *)zxgmentTitleArray {
	if (_zxgmentTitleArray == nil) {
		_zxgmentTitleArray = [NSMutableArray array];
	}
	return _zxgmentTitleArray;
}

#pragma mark - BetRadomProtocal
- (NSUInteger)minSectionsCountForBet {
	UGGameplayModel *model = self.gameDataArray[self.typeIndexPath.row];
	
	if ([@"两面" isEqualToString:model.name]) {
		return 6;
	}
	if ([@"直选" isEqualToString:model.name]) {
		NSInteger count = [self numberOfSectionsInCollectionView:self.betCollectionView];
		return count;
	}
	return 1;
}
- (NSUInteger)minItemsCountForBetIn:(NSUInteger)section {
	
	UGGameplayModel *model = self.gameDataArray[self.typeIndexPath.row];
	
	if ([@"两面" isEqualToString:model.name] && section == 0) {
		return 0;
	}
	
	if ([@"连码" isEqualToString:model.name]) {
		NSString *title = self.lmgmentTitleArray[self.segmentIndex];
		if ([@"二中二" isEqualToString:title] || [@"前二组选" isEqualToString:title]) {
			return 2;
		}else if ([@"三中三" isEqualToString:title] || [@"前三组选" isEqualToString:title]) {
			return 3;
			
		}else if ([@"四中四" isEqualToString:title]) {
			return 4;
		}else if ([@"五中五" isEqualToString:title]) {
			return 5;
		}else if ([@"六中五" isEqualToString:title]) {
			return 6;
		}else if ([@"七中五" isEqualToString:title]) {
			return 7;
		}else if ([@"八中五" isEqualToString:title]) {
			return 8;
		}
		
	}
	if ([@"直选" isEqualToString:model.name] && section == 0) {
		return 0;
	}
	return 1;
}
@end

