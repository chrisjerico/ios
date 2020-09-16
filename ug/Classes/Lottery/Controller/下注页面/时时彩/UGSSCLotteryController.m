//
//  UGTimeLotteryController.m
//  ug
//
//  Created by ug on 2019/5/11.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGSSCLotteryController.h"
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
#import "UGChangLongController.h"
#import "UGFundsViewController.h"
#import "UGBetRecordViewController.h"
#import "UGLotteryRulesView.h"
#import "UGLotteryRecordController.h"
#import "WSLWaterFlowLayout.h"
#import "UGSSCBetItem1Cell.h"
#import "UGLotteryAdPopView.h"

#import "UGPCDDLotteryController.h"
#import "UGJSK3LotteryController.h"
#import "UGHKLHCLotteryController.h"
#import "UGBJPK10LotteryController.h"
#import "UGQXCLotteryController.h"
#import "UGGD11X5LotteryController.h"
#import "UGXYNCLotteryController.h"
#import "UGBJKL8LotteryController.h"
#import "UGGDKL10LotteryController.h"
#import "UGFC3DLotteryController.h"
#import "UGPK10NNLotteryController.h"

#import "UGYYRightMenuView.h"
#import "UGLinkNumCollectionViewCell.h"

#import "UGLotteryHistoryModel.h"
#import "UGLotteryRecordTableViewCell.h"
#import "CMTimeCommon.h"
#import "UGSegmentView.h"
#import "CMLabelCommon.h"
@interface UGSSCLotteryController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,YBPopupMenuDelegate,UITextFieldDelegate,WSLWaterFlowLayoutDelegate>
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
@property (nonatomic, assign) BOOL getNextIssue;
@property (nonatomic, assign) BOOL showAdPoppuView;


@property (weak, nonatomic) IBOutlet UIView *middleView;

@property (nonatomic, strong) UGSegmentView *segmentView;  /**<    */
@property (nonatomic, strong) NSMutableArray <NSString *> *yzgmentTitleArray; /**<   一字定位 */
@property (nonatomic, strong) NSMutableArray <NSString *> *rzgmentTitleArray; /**<   二字定位 */
@property (nonatomic, strong) NSMutableArray <NSString *> *szgmentTitleArray; /**<   三字定位 */

@property (nonatomic, strong) NSMutableArray <NSString *> *bdwgmentTitleArray; /**<   不定位 */
@property (nonatomic, assign) NSInteger segmentIndex;


@property (strong, nonatomic)UGYYRightMenuView *yymenuView;
@end

static NSString *leftTitleCellid = @"UGTimeLotteryLeftTitleCell";
static NSString *lottryBetCellid = @"UGTimeLotteryBetCollectionViewCell";
static NSString *sscBetItem1CellId = @"UGSSCBetItem1Cell";
static NSString *headerViewID = @"UGTimeLotteryBetHeaderView";
static NSString *lotteryResultCellid = @"UGLotteryResultCollectionViewCell";
static NSString *lotterySubResultCellid = @"UGLotterySubResultCollectionViewCell";
static NSString *linkNumCellId = @"UGLinkNumCollectionViewCell";

static NSString *dwdheaderViewID = @"DWDCollectionReusableView";

@implementation UGSSCLotteryController

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
    
    //一字
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

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    
//    [self.middleView  mas_remakeConstraints:^(MASConstraintMaker *make)
//     {
//         make.top.equalTo(self.view.mas_top).with.offset(0);
//         make.left.equalTo(self.view.mas_left).with.offset(0);
//         make.right.equalTo(self.view.mas_right).with.offset(0);
//         make.height.mas_equalTo(70.0).offset(0);
//
//     }];
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
//    UGChatViewController *chatVC = [[UGChatViewController alloc] init];
//    chatVC.roomId = self.gameId;
//    [self.navigationController pushViewController:chatVC animated:YES];
    
     [[NSNotificationCenter defaultCenter] postNotificationName:@"NSSelectChatRoom" object:nil userInfo:nil];
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
            
            
        }];
    }];
}

- (void)getGameDatas {
    NSDictionary *params = @{@"id":self.gameId};
    WeakSelf;
     [CMNetwork getGameDatasWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            HJSonLog(@" 返回的json = %@",model);
            
            UGPlayOddsModel *play = model.data;
            NSLog(@"model.data = %@",model.data);
            weakSelf.gameDataArray = play.playOdds.mutableCopy;
            for (UGGameplayModel *model in weakSelf.gameDataArray) {
                if ([@"一字定位" isEqualToString:model.name]) {
                    for (UGGameplaySectionModel *type in model.list) {
                        [weakSelf.yzgmentTitleArray addObject:type.alias];
                    }
                }
                if ([@"二字定位" isEqualToString:model.name]) {
                       for (UGGameplaySectionModel *type in model.list) {
                           [weakSelf.rzgmentTitleArray addObject:type.alias];
                       }
                   }
                if ([@"三字定位" isEqualToString:model.name]) {
                       for (UGGameplaySectionModel *type in model.list) {
                           [weakSelf.szgmentTitleArray addObject:type.alias];
                       }
                   }
                if ([@"不定位" isEqualToString:model.name]) {
                    for (UGGameplaySectionModel *type in model.list) {
                        [weakSelf.bdwgmentTitleArray addObject:type.alias];
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
            


            [self handleData];
            self.segmentView.dataArray = self.yzgmentTitleArray;
            [self.tableView reloadData];
            NSLog(@"weakSelf.gameDataArray = %@",weakSelf.gameDataArray);
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
    __weakSelf_(__self);
    if (self.amountTextF.isFirstResponder) {
        [self.amountTextF resignFirstResponder];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            YBPopupMenu *popView = [[YBPopupMenu alloc] initWithTitles:__self.chipArray icons:nil menuWidth:CGSizeMake(100, 200) delegate:__self];
            popView.fontSize = 14;
            popView.type = YBPopupMenuTypeDefault;
            [popView showRelyOnView:__self.chipButton];
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
            for (UGGameplaySectionModel *type2 in type.ezdwlist) {
                for (UGGameBetModel *game in type2.list) {
                    game.select = NO;
                }
            }
            for (UGGameplaySectionModel *type in model.list) {
                UGGameplaySectionModel *sectionModel = type.ezdwlist[0];
                for (UGGameBetModel *game in sectionModel.list) {
                    game.select = NO;
                }
            }
        }
    }
    [self.betCollectionView reloadData];
    [self.tableView reloadData];
    [self.tableView selectRowAtIndexPath:self.typeIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    
}

//不定位下注方法
-(void)bdwBetActionMode:(UGGameplayModel *)type array :(NSMutableArray *__strong *) array selCode :(NSString *__strong *)selCode{
    NSLog(@"type=%@",type);
    *selCode = type.code;
    if (type.list.count) {
        NSLog(@"self.segmentIndex = %ld",(long)self.segmentIndex);
        UGGameplaySectionModel *play = type.list[self.segmentIndex];
        if (play.ezdwlist.count) {
            NSMutableArray *mutArr1 = [NSMutableArray array];
          
            
            UGGameplaySectionModel *model1 = play.ezdwlist[1];
            for (UGGameplayModel *bet in model1.list) {
                if (bet.select) {
                    [mutArr1 addObject:bet];
                }
            }
           
            if (mutArr1.count == 0 ) {
                [SVProgressHUD showInfoWithStatus:@"下注内容不正确，请重新下注"];
                return;
            }
            
            for (int i = 0; i < mutArr1.count; i++) {
                
              
                    
                    UGGameBetModel *beti = mutArr1[i];
                    UGGameBetModel *bet = [[UGGameBetModel alloc] init];
                    [bet setValuesForKeysWithDictionary:beti.mj_keyValues];
                    NSMutableString *name = [[NSMutableString alloc] init];
                    [name appendString:beti.name];
                    bet.name = name;
                    bet.money = self.amountTextF.text;
                    bet.title = bet.alias;
                    bet.betInfo = name;
                    [*array addObject:bet];

            }
            
        }
    }
   
}
//二字定位下注方法
-(void)ezdwBetActionMode:(UGGameplayModel *)type array :(NSMutableArray *__strong *) array selCode :(NSString *__strong *)selCode{
    NSLog(@"type=%@",type);
    *selCode = type.code;
    if (type.list.count) {
        NSLog(@"self.segmentIndex = %ld",(long)self.segmentIndex);
        UGGameplaySectionModel *play = type.list[self.segmentIndex];
        if (play.ezdwlist.count) {
            NSMutableArray *mutArr1 = [NSMutableArray array];
            NSMutableArray *mutArr2 = [NSMutableArray array];
            
            UGGameplaySectionModel *model1 = play.ezdwlist[1];
            for (UGGameplayModel *bet in model1.list) {
                if (bet.select) {
                    [mutArr1 addObject:bet];
                }
            }
            UGGameplaySectionModel *model2 = play.ezdwlist[2];
            for (UGGameplayModel *bet in model2.list) {
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
                    bet.money = self.amountTextF.text;
                    bet.title = bet.alias;
                    bet.betInfo = name;
                    [*array addObject:bet];
                    
                }
            }
            
        }
    }
   
}

//三字定位下注方法
-(void)szdwBetActionMode:(UGGameplayModel *)type array :(NSMutableArray *__strong *) array selCode :(NSString *__strong *)selCode{

    *selCode = type.code;
    if (type.list.count) {
        UGGameplaySectionModel *play = type.list[self.segmentIndex];
        if (play.ezdwlist.count) {
            NSMutableArray *mutArr1 = [NSMutableArray array];
            NSMutableArray *mutArr2 = [NSMutableArray array];
            NSMutableArray *mutArr3 = [NSMutableArray array];
            
            UGGameplaySectionModel *model1 = play.ezdwlist[1];
            for (UGGameplayModel *bet in model1.list) {
                if (bet.select) {
                    [mutArr1 addObject:bet];
                }
            }
            UGGameplaySectionModel *model2 = play.ezdwlist[2];
            for (UGGameplayModel *bet in model2.list) {
                if (bet.select) {
                    [mutArr2 addObject:bet];
                }
            }
            UGGameplaySectionModel *model3 = play.ezdwlist[3];
            for (UGGameplayModel *bet in model3.list) {
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
                        bet.money = self.amountTextF.text;
                        bet.title = bet.alias;
                        bet.betInfo = name;
                        [*array addObject:bet];
                    }
                }
            }
            
        }
    }
   
}

- (IBAction)betClick:(id)sender {
    [self.amountTextF resignFirstResponder];
    ck_parameters(^{
         ck_parameter_non_equal(self.selectLabel.text, @"0", @"请选择玩法");
        ck_parameter_non_empty(self.amountTextF.text, @"请输入投注金额");
    }, ^(id err) {
        [SVProgressHUD showInfoWithStatus:err];
    }, ^{
        NSString *selName = @"";
        NSString *selCode = @"";
        NSMutableArray *array = [NSMutableArray array];
        
        UGGameplayModel *type = self.gameDataArray[self.typeIndexPath.row];
        if ([@"二字定位" isEqualToString:type.name]) {
            [self ezdwBetActionMode:type array:&array selCode:&selCode];
        }
        else if ([@"不定位" isEqualToString:type.name]) {
            [self bdwBetActionMode:type array:&array selCode:&selCode];
        }
        else if ([@"三字定位" isEqualToString:type.name]) {
            [self szdwBetActionMode:type array:&array selCode:&selCode];
        }
        else if ([@"定位胆" isEqualToString:type.name]) {
            for (UGGameplayModel *model in self.gameDataArray) {
                
//                if (!model.select) {
//                    continue;
//                }
                for (UGGameplaySectionModel *type in model.list) {
                    UGGameplaySectionModel *sectionModel = type.ezdwlist[0];
                    for (UGGameBetModel *game in sectionModel.list) {
                        if (game.select) {
                            game.money = self.amountTextF.text;
                            if ([game.alias isEqualToString:@""]) {
                                game.alias = type.alias;
                            }
                            game.betInfo = game.name;
                            [array addObject:game];
                        }
                    }
                }
                
            }
            
        }
        else{
            for (UGGameplayModel *model in self.gameDataArray) {
                
                if (!model.select) {
                    continue;
                }
                
                NSLog(@"model.code ======================== %@",model.code);
                selCode = model.code;
                selName = model.name;
                for (UGGameplaySectionModel *type in model.list) {
                    for (UGGameBetModel *game in type.list) {
                        if (game.select) {
                            game.money = self.amountTextF.text;
                            if ([game.alias isEqualToString:@""]) {
                                game.alias = type.alias;
                            }
                            if ([game.title isEqualToString:@"一字定位"]) {
                                game.betInfo = game.name;
                            }
          
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
        self.typeIndexPath = indexPath;
        UGGameplayModel *model = self.gameDataArray[indexPath.row];
        if ([@"一字定位" isEqualToString:model.name]) {
       
            self.segmentView.dataArray = self.yzgmentTitleArray;
     
            if (self.segmentView.hidden) {
                
                self.betCollectionView.y += self.segmentView.height;
                self.betCollectionView.height -= self.segmentView.height;
            }
            self.segmentIndex = 0;
            self.segmentView.hidden = NO;
            [self resetClick:nil];
            
        }
        else  if ([@"不定位" isEqualToString:model.name]) {
            
            self.segmentView.dataArray = self.bdwgmentTitleArray;
            
            if (self.segmentView.hidden) {
                
                self.betCollectionView.y += self.segmentView.height;
                self.betCollectionView.height -= self.segmentView.height;
            }
            self.segmentIndex = 0;
            self.segmentView.hidden = NO;
            [self resetClick:nil];
            
        }
       else if ([@"二字定位" isEqualToString:model.name]) {
             self.segmentView.dataArray = self.rzgmentTitleArray;
             if (self.segmentView.hidden) {
                 
                 self.betCollectionView.y += self.segmentView.height;
                 self.betCollectionView.height -= self.segmentView.height;
             }
             self.segmentIndex = 0;
             self.segmentView.hidden = NO;
             [self resetClick:nil];
             
         }
      else   if ([@"三字定位" isEqualToString:model.name]) {
    
             self.segmentView.dataArray = self.szgmentTitleArray;
             if (self.segmentView.hidden) {
                 
                 self.betCollectionView.y += self.segmentView.height;
                 self.betCollectionView.height -= self.segmentView.height;
             }
             self.segmentIndex = 0;
             self.segmentView.hidden = NO;
             [self resetClick:nil];
             
         }
      else   if ([@"定位胆" isEqualToString:model.name]) {
          
          if (!self.segmentView.hidden) {
              
              self.betCollectionView.y -= self.segmentView.height;
              self.betCollectionView.height += self.segmentView.height;
          }
          self.segmentView.hidden = YES;
          [self resetClick:nil];
          
      }
        
      else {
          if (!self.segmentView.hidden) {
              
              self.betCollectionView.y -= self.segmentView.height;
              self.betCollectionView.height += self.segmentView.height;
          }
          self.segmentView.hidden = YES;
          
      }
        __weakSelf_(__self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [__self.betCollectionView reloadData];
            [__self.betCollectionView setContentOffset:CGPointMake(0, 0) animated:YES];
        });


    }
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (collectionView == self.betCollectionView) {
        if (self.gameDataArray.count) {
            
            UGGameplayModel *model = self.gameDataArray[self.typeIndexPath.row];
            if ([@"一字定位" isEqualToString:model.name]) {
                return 1;
            }
            if ([@"不定位" isEqualToString:model.name]) {
                return 2;
            }
            else if ([@"二字定位" isEqualToString:model.name]) {

                return 3;
            }
            else if ([@"三字定位" isEqualToString:model.name]) {

                return 4;
            }
            else if ([@"定位胆" isEqualToString:model.name]) {
                
                return model.list.count;
            }
            else {
                
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
        UGGameplaySectionModel *type = model.list[section];

        if ([@"二字定位" isEqualToString:model.name] && section == 0) {
            return 0;
        }
        if ([@"不定位" isEqualToString:model.name] && section == 0) {
            return 0;
        }
        
        if ([@"三字定位" isEqualToString:model.name] && section == 0) {
             return 0;
        }
        
        if ([@"二字定位" isEqualToString:model.name]) {
            UGGameplaySectionModel *type = model.list[self.segmentIndex];
            UGGameplaySectionModel *obj = type.ezdwlist[section];
            return obj.list.count;
        }
        else if ([@"不定位" isEqualToString:model.name]) {
            UGGameplaySectionModel *type = model.list[self.segmentIndex];
            UGGameplaySectionModel *obj = type.ezdwlist[section];
            return obj.list.count;
        }
        else if ([@"三字定位" isEqualToString:model.name]) {
            UGGameplaySectionModel *type = model.list[self.segmentIndex];
            UGGameplaySectionModel *obj = type.ezdwlist[section];
            return obj.list.count;
        }
        else if ([@"定位胆" isEqualToString:model.name]) {
            
            return 10;
        }
        
        else {
             return type.list.count;
        }
       
    }
    else {
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
        if ([@"一字定位" isEqualToString:model.name]) {
            type = model.list[self.segmentIndex];
            game = type.list[indexPath.row];
            
        }
        else if ([@"不定位" isEqualToString:model.name]) {
            type = model.list[self.segmentIndex];
            UGGameplaySectionModel *obj = type.ezdwlist[indexPath.section];
            game = obj.list[indexPath.row];
              
        }
        else if ([@"二字定位" isEqualToString:model.name]) {
            type = model.list[self.segmentIndex];
            UGGameplaySectionModel *obj = type.ezdwlist[indexPath.section];
            game = obj.list[indexPath.row];
    
        }
        else  if ([@"三字定位" isEqualToString:model.name]) {
            type = model.list[self.segmentIndex];
            UGGameplaySectionModel *obj = type.ezdwlist[indexPath.section];
            game = obj.list[indexPath.row];
        }
        else  if ([@"定位胆" isEqualToString:model.name]) {
            type = model.list[indexPath.section];
            UGGameplaySectionModel *obj = type.ezdwlist[0];
            game = obj.list[indexPath.row];
        }
        else {
            type = model.list[indexPath.section];
            game = type.list[indexPath.row];
        }

        if ([@"1-5球" isEqualToString:model.name] ||
            [@"第一球" isEqualToString:model.name] ||
            [@"第二球" isEqualToString:model.name] ||
            [@"第三球" isEqualToString:model.name] ||
            [@"第四球" isEqualToString:model.name] ||
            [@"第五球" isEqualToString:model.name]) {
            if (indexPath.row < 10) {
                UGSSCBetItem1Cell *Cell = [collectionView dequeueReusableCellWithReuseIdentifier:sscBetItem1CellId forIndexPath:indexPath];
                Cell.item = game;
                return Cell;
            }
        }
        if ([@"龙虎斗" isEqualToString:model.name] && game.name.length > 1) {
            if ([game.name containsString:@"龙"]) {
                game.name = @"龙";
            }
            if ([game.name containsString:@"虎"]) {
                game.name = @"虎";
            }
            if ([game.name containsString:@"和"]) {
                game.name = @"和";
            }
        }
        
        NSLog(@":model.name=%@",model.name);
        if ([@"一字定位" isEqualToString:model.name] ) {
                UGLinkNumCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:linkNumCellId forIndexPath:indexPath];
                cell.item = game;
                return cell;
        }
        if ([@"不定位" isEqualToString:model.name] ) {
                UGLinkNumCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:linkNumCellId forIndexPath:indexPath];
                cell.item = game;
                return cell;
        }
        if ([@"二字定位" isEqualToString:model.name] ) {
            
     
                UGLinkNumCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:linkNumCellId forIndexPath:indexPath];
                cell.item = game;
                return cell;
        }
        if ([@"三字定位" isEqualToString:model.name] ) {

                 UGLinkNumCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:linkNumCellId forIndexPath:indexPath];
                 cell.item = game;
                 return cell;
         }
        if ([@"定位胆" isEqualToString:model.name] ) {
            
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
            cell.titleColor = UGGreenColor;
            return cell;
        }
    }
    
}

-(void)operationAllCellsAtIndexPath:(NSIndexPath *)indexPath parameter:(NSString *)para{
    
    // UI更新代码
    UGGameplayModel *model = self.gameDataArray[self.typeIndexPath.row];
    UGGameplaySectionModel *type =model.list[indexPath.section];
    UGGameplaySectionModel *sectionModel = type.ezdwlist[0];
    if (sectionModel.list.count) {
    
        for (int i = 0; i< sectionModel.list.count; i++) {
            UGGameBetModel *game =  sectionModel.list[i];
            if (!game.enable) {
                return;
            }
            
            if ([para isEqualToString:@"所有"]) {
                game.select = YES;
            }
            else if ([para isEqualToString:@"大数"]) {
                if (game.name.intValue >= 5) {
                    game.select = YES;
                }
            }
            else if ([para isEqualToString:@"小数"]) {
                if (game.name.intValue < 5) {
                    game.select = YES;
                }
            }
            else if ([para isEqualToString:@"奇数"]) {
                if (game.name.intValue %2 != 0) {
                    game.select = YES;
                }
            }
            else if ([para isEqualToString:@"偶数"]) {
                if (game.name.intValue %2 == 0) {
                    game.select = YES;
                }
            }
            else{
                game.select = NO;//移除
            }
            
        }
        
        //刷新Section
        [UIView performWithoutAnimation:^{
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:indexPath.section];
            [self.betCollectionView reloadSections:indexSet];
        }];
        
        [self dwdActionModel:model];
    }
    
}


-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
            UGTimeLotteryBetHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewID forIndexPath:indexPath];
            if (collectionView == self.betCollectionView) {
                UGGameplayModel *model = self.gameDataArray[self.typeIndexPath.row];
                UGGameplaySectionModel *type = nil;
                if ([@"定位胆" isEqualToString:model.name]) {
                    [headerView.btnbgView setHidden:NO];
                    {
                    WeakSelf;
                    [headerView.removeBtn removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
                    [headerView.bigBtn removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
                    [headerView.allBtn removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
                    
                    [headerView.smallBtn removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
                    [headerView.jiBtn removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
                    [headerView.ouBtn removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
                    
                    
                    [headerView.allBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
                        
                        [weakSelf operationAllCellsAtIndexPath:indexPath parameter:@""];
                        [weakSelf operationAllCellsAtIndexPath:indexPath parameter:@"所有"];
                        
                    }];//所有
                    
                    [headerView.bigBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
                        
                        [weakSelf operationAllCellsAtIndexPath:indexPath parameter:@""];
                        [weakSelf operationAllCellsAtIndexPath:indexPath parameter:@"大数"];
                    }];//大数
                    
                    [headerView.smallBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
                        
                        [weakSelf operationAllCellsAtIndexPath:indexPath parameter:@""];
                        [weakSelf operationAllCellsAtIndexPath:indexPath parameter:@"小数"];
                        
                    }];//小数
                    
                    [headerView.jiBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
                        
                        [weakSelf operationAllCellsAtIndexPath:indexPath parameter:@""];
                        [weakSelf operationAllCellsAtIndexPath:indexPath parameter:@"奇数"];
                    }];//奇数
                    
                    [headerView.ouBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
                        
                        [weakSelf operationAllCellsAtIndexPath:indexPath parameter:@""];
                        [weakSelf operationAllCellsAtIndexPath:indexPath parameter:@"偶数"];
                        
                    }];//偶数
                    
                    [headerView.removeBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
                        
                        [weakSelf operationAllCellsAtIndexPath:indexPath parameter:@""];
                        
                    }];//移除
                    }
                    
                    if (model.list.count) {
                        
                        type = model.list[indexPath.section];
                        UGGameplaySectionModel *section = type.ezdwlist[0];
                        
                        if (APP.betOddsIsRed) {
                            headerView.titleLabel.text = section.name;
                            [CMLabelCommon setRichNumberWithLabel:headerView.titleLabel Color:APP.AuxiliaryColor2 FontSize:15.0];
                        } else {
                            headerView.titleLabel.text =  section.name;
                            
                        }
                    }
                }
                
                else if ([@"一字定位" isEqualToString:model.name]) {
                    [headerView.btnbgView setHidden:YES];
                    if (model.list.count) {
                        
                        type = model.list[self.segmentIndex];
                        UGBetModel *bet = type.list.firstObject;
                        NSLog(@"bet.odds =%@",bet.odds);
                        if (bet == nil) {
                            bet = [UGBetModel new];
                            bet.odds = @"9.8";
                        }
                        
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
                }
                else if ([@"不定位" isEqualToString:model.name]) {
                    [headerView.btnbgView setHidden:YES];

                    if (!model.list.count) {
                        headerView.titleLabel.text = @"";
                        return headerView;
                    }
                    if (indexPath.section == 0) {
                        type = model.list[self.segmentIndex];
                        UGGameBetModel *bet = type.list.firstObject;
                        NSLog(@"bet.odds =%@",bet.odds);
                        if (bet == nil) {
                            bet = [UGGameBetModel new];
                            bet.odds = @"3.59";
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
                        type = model.list[self.segmentIndex ];
                        UGGameplaySectionModel *obj = type.ezdwlist[indexPath.section];
                        headerView.titleLabel.text = obj.name;
                    }
                    
                }
                else if ([@"二字定位" isEqualToString:model.name]) {
                    
                    [headerView.btnbgView setHidden:YES];

                    if (!model.list.count) {
                        headerView.titleLabel.text = @"";
                        return headerView;
                    }
                    if (indexPath.section == 0) {
                        type = model.list[self.segmentIndex];
                        UGGameBetModel *bet = type.list.firstObject;
                        NSLog(@"bet.odds =%@",bet.odds);
                        if (bet == nil) {
                            bet = [UGGameBetModel new];
                            bet.odds = @"83";
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
                        type = model.list[self.segmentIndex ];
                        UGGameplaySectionModel *obj = type.ezdwlist[indexPath.section];
                        headerView.titleLabel.text = obj.name;
                    }
                    else if (indexPath.section == 2){
                        type = model.list[self.segmentIndex ];
                        UGGameplaySectionModel *obj = type.ezdwlist[indexPath.section];
                        headerView.titleLabel.text = obj.name;
                    }
                }
                else if ([@"三字定位" isEqualToString:model.name]) {
                    [headerView.btnbgView setHidden:YES];

                    if (!model.list.count) {
                        headerView.titleLabel.text = @"";
                        return headerView;
                    }
                    if (indexPath.section == 0) {
                        type = model.list[self.segmentIndex];
                        UGGameBetModel *bet = type.list.firstObject;
                        NSLog(@"bet.odds =%@",bet.odds);
                        if (bet == nil) {
                            bet = [UGGameBetModel new];
                            bet.odds = @"700";
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
                        type = model.list[self.segmentIndex ];
                        UGGameplaySectionModel *obj = type.ezdwlist[indexPath.section];
                        headerView.titleLabel.text = obj.name;
                    }
                    else if (indexPath.section == 2){
                        type = model.list[self.segmentIndex ];
                        UGGameplaySectionModel *obj = type.ezdwlist[indexPath.section];
                        headerView.titleLabel.text = obj.name;
                    }
                    else if (indexPath.section == 3){
                        type = model.list[self.segmentIndex ];
                        UGGameplaySectionModel *obj = type.ezdwlist[indexPath.section];
                        headerView.titleLabel.text = obj.name;
                    }
                    
                }
                else{
                    [headerView.btnbgView setHidden:YES];
                    type = model.list[indexPath.section];
                    headerView.titleLabel.text = type.alias;
                }
                
            }
            else {
                [headerView.btnbgView setHidden:YES];
                headerView.titleLabel.text = @"";
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
        if ([@"一字定位" isEqualToString:model.name]) {
            UGGameplaySectionModel *type = model.list[self.segmentIndex];
            UGGameBetModel *game = type.list[indexPath.row];
            if (!(game.gameEnable && game.enable)) {
                return;
            }
            game.select = !game.select;
            
        }
       else  if ([@"不定位" isEqualToString:model.name]) {
            
            UGGameplaySectionModel *obj = model.list[self.segmentIndex];
            UGGameplaySectionModel *type = obj.ezdwlist[indexPath.section];
            UGGameBetModel *game = type.list[indexPath.row];
            if (!(game.gameEnable && game.enable)) {
                return;
            }
            game.select = !game.select;
            
        }
        else if ([@"二字定位" isEqualToString:model.name] ) {
            
            UGGameplaySectionModel *obj = model.list[self.segmentIndex];
            UGGameplaySectionModel *type = obj.ezdwlist[indexPath.section];
            UGGameBetModel *game = type.list[indexPath.row];
            if (!(game.gameEnable && game.enable)) {
                return;
            }
            game.select = !game.select;
            
        }
        else if ([@"三字定位" isEqualToString:model.name] ) {
            UGGameplaySectionModel *obj = model.list[self.segmentIndex];
            UGGameplaySectionModel *type = obj.ezdwlist[indexPath.section];
            UGGameBetModel *game = type.list[indexPath.row];
            if (!(game.gameEnable && game.enable)) {
                return;
            }
            game.select = !game.select;
            
        }
        else if([@"定位胆" isEqualToString:model.name] ) {
            UGGameplaySectionModel *type = model.list[indexPath.section];
            UGGameplaySectionModel *section = type.ezdwlist[0];
            UGGameBetModel *game = section.list[indexPath.row];
            NSLog(@"game = %@",game.name);
            if (!(game.gameEnable && game.enable)) {
                return;
            }
            game.select = !game.select;
            
        }
        else {
            UGGameplaySectionModel *type = model.list[indexPath.section];
            UGGameBetModel *game = type.list[indexPath.row];
            if (!(game.gameEnable && game.enable)) {
                return;
            }
            game.select = !game.select;
        }

        [self.betCollectionView reloadData];
        
        NSInteger number = 0;
        for (UGGameplaySectionModel *type in model.list) {
            for (UGGameBetModel *game in type.list) {
                game.title = type.name;
                if (game.select) {
                    number ++;
                }
            }
        }
        
        for (UGGameplaySectionModel *type in model.list) {
            for (UGGameplaySectionModel *type1 in type.ezdwlist) {
                for (UGGameBetModel *game in type1.list) {
                    game.title = type.name;
                    if (game.select) {
                        number ++;
                    }
                }
            }
        }
        model.select = number;
        [self.tableView reloadData];
        [self.tableView selectRowAtIndexPath:self.typeIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        
        
        //        计算选中的注数
        NSInteger count = 0;
        
        if ([@"二字定位" isEqualToString:model.name]) {
            [self ezdwActionModel:model count:count];
        }
        else if ([@"不定位" isEqualToString:model.name]) {
              [self bdwActionModel:model count:count];
        }
        else if ([@"三字定位" isEqualToString:model.name]) {
            [self szdwActionModel:model count:count];
        }
        else if ([@"定位胆" isEqualToString:model.name]) {
            [self dwdActionModel:model];
        }
        else {
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
    
}

#pragma mark - 计算选中的注数
//定位胆 计算选中的注数
-(void)dwdActionModel:(UGGameplayModel *)model {
    
    int count  = 0 ;
    
    for (UGGameplaySectionModel *type in model.list) {
        UGGameplaySectionModel *sectionModel = type.ezdwlist[0];
        for (UGGameBetModel *game in sectionModel.list) {
            if (game.select) {
                count ++;
            }
        }
    }
    
    [self updateSelectLabelWithCount:count];
}

//不定位 计算选中的注数
-(void)bdwActionModel:(UGGameplayModel *)model count:(NSInteger)count{
    
      NSMutableArray *array = [NSMutableArray array];
      UGGameplaySectionModel *play = model.list[self.segmentIndex];
      if (play.ezdwlist.count) {
          NSMutableArray *mutArr1 = [NSMutableArray array];
          
          UGGameplaySectionModel *model1 = play.ezdwlist[1];
          for (UGGameplayModel *bet in model1.list) {
              if (bet.select) {
                  [mutArr1 addObject:bet];
              }
          }
        
          if (mutArr1.count == 0 ) {
              count = 0;
              [self updateSelectLabelWithCount:count];
              return;
          }
          
          for (int i = 0; i < mutArr1.count; i++) {

                  UGGameBetModel *beti = mutArr1[i];
                  UGGameBetModel *bet = [[UGGameBetModel alloc] init];
                  [bet setValuesForKeysWithDictionary:beti.mj_keyValues];
                  NSMutableString *name = [[NSMutableString alloc] init];
                  [name appendString:beti.name];
                  bet.name = name;
                  bet.money = self.amountTextF.text;
                  bet.title = bet.alias;
                  bet.betInfo = name;
                  [array addObject:bet];
          }
          
          if (mutArr1.count == 0 ) {
              count = 0;
              [self updateSelectLabelWithCount:count];
            
          } else {
              count = array.count;
              NSLog(@"count = %ld",(long)count);
              [self updateSelectLabelWithCount:count];
          }
      }
}

//二字定位 计算选中的注数
-(void)ezdwActionModel:(UGGameplayModel *)model count:(NSInteger)count{
    
      NSMutableArray *array = [NSMutableArray array];
      UGGameplaySectionModel *play = model.list[self.segmentIndex];
      if (play.ezdwlist.count) {
          NSMutableArray *mutArr1 = [NSMutableArray array];
          NSMutableArray *mutArr2 = [NSMutableArray array];
          
          UGGameplaySectionModel *model1 = play.ezdwlist[1];
          for (UGGameplayModel *bet in model1.list) {
              if (bet.select) {
                  [mutArr1 addObject:bet];
              }
          }
          UGGameplaySectionModel *model2 = play.ezdwlist[2];
          for (UGGameplayModel *bet in model2.list) {
              if (bet.select) {
                  [mutArr2 addObject:bet];
              }
          }
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
                  bet.money = self.amountTextF.text;
                  bet.title = bet.alias;
                  bet.betInfo = name;
                  [array addObject:bet];
                  
              }
          }
          
          if (mutArr1.count == 0 || mutArr2.count == 0) {
              count = 0;
              [self updateSelectLabelWithCount:count];
            
          } else {
              count = array.count;
              NSLog(@"count = %ld",(long)count);
              [self updateSelectLabelWithCount:count];
          }
      }
}

//三字定位 计算选中的注数
-(void)szdwActionModel:(UGGameplayModel *)model count:(NSInteger)count{
    
      NSMutableArray *array = [NSMutableArray array];
      UGGameplaySectionModel *play = model.list[self.segmentIndex];
      if (play.ezdwlist.count) {
          NSMutableArray *mutArr1 = [NSMutableArray array];
          NSMutableArray *mutArr2 = [NSMutableArray array];
          NSMutableArray *mutArr3 = [NSMutableArray array];
          
          UGGameplaySectionModel *model1 = play.ezdwlist[1];
          for (UGGameplayModel *bet in model1.list) {
              if (bet.select) {
                  [mutArr1 addObject:bet];
              }
          }
          UGGameplaySectionModel *model2 = play.ezdwlist[2];
          for (UGGameplayModel *bet in model2.list) {
              if (bet.select) {
                  [mutArr2 addObject:bet];
              }
          }
          UGGameplaySectionModel *model3 = play.ezdwlist[3];
          for (UGGameplayModel *bet in model3.list) {
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
                      bet.money = self.amountTextF.text;
                      bet.title = bet.alias;
                      bet.betInfo = name;
                      [array addObject:bet];
                  }
              }
          }
          
          if (mutArr1.count == 0 || mutArr2.count == 0|| mutArr3.count == 0) {
              count = 0;
              [self updateSelectLabelWithCount:count];
            
          } else {
              count = array.count;
              NSLog(@"count = %ld",(long)count);
              [self updateSelectLabelWithCount:count];
          }
      }
}


#pragma mark - WSLWaterFlowLayoutDelegate
//返回每个item大小
- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    UGGameplayModel *model = self.gameDataArray[self.typeIndexPath.row];
    if ([@"一字定位" isEqualToString:model.name] ||
        [@"不定位" isEqualToString:model.name] ||
        [@"二字定位" isEqualToString:model.name] ||
        [@"三字定位" isEqualToString:model.name]||
        [@"定位胆" isEqualToString:model.name]) {
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
    if ([@"定位胆" isEqualToString:model.name]) {
         return CGSizeMake(UGScreenW / 4 * 3 - 1, 70);
    } else {
         return CGSizeMake(UGScreenW / 4 * 3 - 1, 35);
    }
   
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
//        [collectionView registerNib:[UINib nibWithNibName:@"DWDCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:dwdheaderViewID];
        collectionView;
        
    });
    collectionView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
    self.betCollectionView = collectionView;
    [self.rightStackView addSubview:collectionView];
    
}

- (void)initHeaderCollectionView {
    
    UICollectionViewFlowLayout *layout = ({
        
        layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(26, 26);
        layout.minimumInteritemSpacing = 1;
        layout.minimumLineSpacing = 1;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.headerReferenceSize = CGSizeMake(300, 3);
        layout;
        
    });
    
    UICollectionView *collectionView = ({
       
        collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(110 , 5, UGScreenW - 130 , 60) collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [collectionView registerNib:[UINib nibWithNibName:@"UGLotteryResultCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:lotteryResultCellid];
        [collectionView registerNib:[UINib nibWithNibName:@"UGLotterySubResultCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:lotterySubResultCellid];
        [collectionView registerNib:[UINib nibWithNibName:@"UGTimeLotteryBetHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewID];
//        [collectionView registerNib:[UINib nibWithNibName:@"DWDCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:dwdheaderViewID];
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
    CGSize size = [self.nextIssueModel.preIssue sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
    self.headerCollectionView.x = 25 + size.width;
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
        self.getNextIssue = YES;
    }else {
        self.getNextIssue = NO;
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

//一字定位玩法数据处理
- (void)handleData {
    for (UGGameplayModel *model in self.gameDataArray) {
        if ([@"一字定位" isEqualToString:model.name]) {
            NSLog(@"model = %@",model);
            for (UGGameplaySectionModel *group in model.list) {
                if (group.list.count) {
                    UGGameBetModel *play = group.list.firstObject;
                    NSMutableArray *array = [NSMutableArray array];
                    for (int i = 0; i < 10; i++) {
                        UGGameBetModel *bet = [[UGGameBetModel alloc] init];
                        [bet setValuesForKeysWithDictionary:play.mj_keyValues];
                        bet.alias = bet.name;
                        bet.typeName = group.name;
                        bet.name = [NSString stringWithFormat:@"%d",i ];
                        bet.betInfo = bet.name;
                        [array addObject:bet];
                    }
                    group.list = array.copy;
                }
            }
        }
        
        if ([@"不定位" isEqualToString:model.name]) {
            NSLog(@"model = %@",model);
            if (!model.list.count) {
                return;
            }
            
            int lenth = (int )model.list.count;
            
            for (int i = 0; i < lenth; i++) {
                UGGameplaySectionModel *group = [model.list objectAtIndex:i];
                
                if (group.list.count) {
                    UGGameBetModel *play = group.list.firstObject;
                    NSMutableArray *sectionArray = [NSMutableArray array];
                    NSLog(@"group.alias =%@",group.alias);
                    for (int i = 0; i< 2; i++) {
                        UGGameplaySectionModel * sectionModel = [[UGGameplaySectionModel alloc] init];
                        if (i == 0 ) {
                            sectionModel.name = play.odds;
                        }else if (i == 1 ) {
                            sectionModel.name = @"玩法提示：从0~9中任选1个号码为1注";
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
        
        if ([@"二字定位" isEqualToString:model.name]) {
            if (!model.list.count) {
                return;
            }
            
            int lenth = (int )model.list.count;
            
            for (int i = 0; i < lenth; i++) {
                UGGameplaySectionModel *group = [model.list objectAtIndex:i];
                
                if (group.list.count) {
                    UGGameBetModel *play = group.list.firstObject;
                    NSMutableArray *sectionArray = [NSMutableArray array];
                    NSLog(@"group.alias =%@",group.alias);
                    for (int i = 0; i< 3; i++) {
                        UGGameplaySectionModel * sectionModel = [[UGGameplaySectionModel alloc] init];
                        if (i == 0 ) {
                            sectionModel.name = play.odds;
                        }else if (i == 1 ) {
                            sectionModel.name = [NSString stringWithFormat:@"%@定位", [group.alias substringToIndex:1]] ;
                        }
                        else if (i == 2 ) {
                            sectionModel.name = [NSString stringWithFormat:@"%@定位", [group.alias substringFromIndex:group.alias.length-1] ];
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
        
        if ([@"三字定位" isEqualToString:model.name]) {
            
            if (!model.list.count) {
                return;
            }
            
            int lenth = (int )model.list.count;
            
            for (int i = 0; i < lenth; i++) {
                UGGameplaySectionModel *group = [model.list objectAtIndex:i];
                
                if (group.list.count) {
                    UGGameBetModel *play = group.list.firstObject;
                    NSMutableArray *sectionArray = [NSMutableArray array];
                    NSLog(@"group.alias =%@",group.alias);
                    for (int i = 0; i< 4; i++) {
                        UGGameplaySectionModel * sectionModel = [[UGGameplaySectionModel alloc] init];
                        if (i == 0 ) {
                            sectionModel.name = play.odds;
                        }else if (i == 1 ) {
                            
                            if ([group.alias isEqualToString:@"前三"]) {
                                sectionModel.name = @"万定位";
                            }
                            else if([group.alias isEqualToString:@"中三"]) {
                                sectionModel.name = @"千定位" ;
                            }
                            else{
                                sectionModel.name = @"百定位" ;
                            }
                            
                        }
                        else if (i == 2 ) {
                            if ([group.alias isEqualToString:@"前三"]) {
                                sectionModel.name = @"千定位";
                            }
                            else if([group.alias isEqualToString:@"中三"]) {
                                sectionModel.name = @"百定位" ;
                            }
                            else{
                                sectionModel.name = @"十定位" ;
                            }
                        }
                        else if (i == 3 ) {
                            if ([group.alias isEqualToString:@"前三"]) {
                                sectionModel.name = @"百定位";
                            }
                            else if([group.alias isEqualToString:@"中三"]) {
                                sectionModel.name = @"十定位" ;
                            }
                            else{
                                sectionModel.name = @"个定位" ;
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
        
        if ([@"定位胆" isEqualToString:model.name]){
            if (!model.list.count) {
                return;
            }
            int lenth = (int )model.list.count;
            for (int i = 0; i < lenth; i++) {
                UGGameplaySectionModel *group = [model.list objectAtIndex:i];
                NSMutableArray *sectionArray = [NSMutableArray array];
                UGGameBetModel *play = group.list.firstObject;
                //测试
//                play.gameEnable = YES;
                
                UGGameplaySectionModel * sectionModel = [[UGGameplaySectionModel alloc] init];
                sectionModel.name = [NSString stringWithFormat:@"%@定位:%@",play.name,[play.odds removeFloatAllZero]];
                [sectionArray addObject:sectionModel];
                
                NSMutableArray *array = [NSMutableArray array];
                for (int i = 0; i < 10; i++) {
                    UGGameBetModel *bet = [[UGGameBetModel alloc] init];
                    [bet setValuesForKeysWithDictionary:play.mj_keyValues];
                    bet.alias = bet.name;
                    bet.typeName = group.name;
                    bet.name = [NSString stringWithFormat:@"%d",i ];
                    [array addObject:bet];
                    
                    //测试
//                    bet.gameEnable = YES;
                }
                sectionModel.list = array.copy;
                group.ezdwlist = sectionArray.copy;
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

- (UGSegmentView *)segmentView {
    if (_segmentView == nil) {
        _segmentView = [[UGSegmentView alloc] initWithFrame:CGRectMake(0, 0, UGScreenW /4 * 3, 50) titleArray:self.yzgmentTitleArray];
        _segmentView.hidden = YES;
        
    }
    return _segmentView;
    
}

- (NSMutableArray *)yzgmentTitleArray {
    if (_yzgmentTitleArray == nil) {
        _yzgmentTitleArray = [NSMutableArray array];
    }
    return _yzgmentTitleArray;
    
}

- (NSMutableArray *)rzgmentTitleArray {
    if (_rzgmentTitleArray == nil) {
        _rzgmentTitleArray = [NSMutableArray array];
    }
    return _rzgmentTitleArray;
}

- (NSMutableArray *)szgmentTitleArray {
    if (_szgmentTitleArray == nil) {
        _szgmentTitleArray = [NSMutableArray array];
    }
    return _szgmentTitleArray;
    
}
#pragma mark - BetRadomProtocal
- (NSUInteger)minSectionsCountForBet {
	UGGameplayModel *model = self.gameDataArray[self.typeIndexPath.row];
	if ([@"两面" isEqualToString:model.name] || [@"1-5球" isEqualToString:model.name] ||  [@"龙虎斗" isEqualToString:model.name]) {
		return [self numberOfSectionsInCollectionView:self.betCollectionView];
	}
	if ([@"二字定位" isEqualToString:model.name]) {
		return 2;
	}
	if ([@"三字定位" isEqualToString:model.name]) {
		return 3;
	}
	if ([@"前中后" isEqualToString:model.name]) {
		return 3;
	}
	
	if ([@"不定位" isEqualToString:model.name]) {
		return [self numberOfSectionsInCollectionView:self.betCollectionView];
	}
	
	return 1;
}

- (NSUInteger)minItemsCountForBetIn:(NSUInteger)section {

	UGGameplayModel *model = self.gameDataArray[self.typeIndexPath.row];
	if ([@"两面" isEqualToString:model.name] && section == 0) {
		return 0;
	}
	if ([@"不定位" isEqualToString:model.name] && section == 0) {
		return 0;
	}
	
	return 1;
}


//重写机选方法
-(void)randomNumber {
	
	[self resetClick:self.radomNumberButton];
	UGGameplayModel *model = self.gameDataArray[self.typeIndexPath.row];

	NSIndexPath * lastPath;
	NSInteger sectionTotalCount = [self numberOfSectionsInCollectionView:self.betCollectionView];
	NSUInteger sectionCount = [self minSectionsCountForBet];
	NSMutableSet * sectionSet = [NSMutableSet setWithCapacity: sectionCount];
	while (sectionSet.count < sectionCount) {
		
		NSInteger radomSection = arc4random()%sectionTotalCount;
	if ([model.name isEqualToString:@"二字定位"] || [model.name isEqualToString:@"三字定位"]) {
		radomSection = arc4random()%(sectionTotalCount-1) + 1;
	}
		[sectionSet addObject:[NSNumber numberWithInteger:radomSection]];
	}
	
	
	
	for (NSNumber *sectionNumber in sectionSet) {
		NSUInteger itemsCountInSection =  [self collectionView:self.betCollectionView numberOfItemsInSection:sectionNumber.integerValue];
		NSUInteger minItemsCountInsection = [self minItemsCountForBetIn:sectionNumber.integerValue];
		NSMutableSet * itemSet = [NSMutableSet setWithCapacity: sectionCount];
		while (itemSet.count<minItemsCountInsection) {
			NSInteger radomItemNumberInSection = arc4random()%itemsCountInSection;
			[itemSet addObject:[NSNumber numberWithInteger:radomItemNumberInSection]];
		}
		for (NSNumber *itemNumber in itemSet) {
			NSIndexPath * path = [NSIndexPath indexPathForItem:itemNumber.integerValue inSection:sectionNumber.integerValue];
			[self collectionView:self.betCollectionView didSelectItemAtIndexPath: path];
			lastPath = path;
			
		}
	}
	
	if (self.betCollectionView.contentSize.height > self.betCollectionView.bounds.size.height) {
		[self.betCollectionView layoutIfNeeded];
		[self.betCollectionView scrollToItemAtIndexPath:lastPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:true];
	}
	
}
- (NSMutableArray *)bdwgmentTitleArray {
    if (_bdwgmentTitleArray == nil) {
        _bdwgmentTitleArray = [NSMutableArray array];
    }
    return _bdwgmentTitleArray;
    
}


@end
