//
//  UGYNLotteryController.m
//  UGBWApp
//
//  Created by andrew on 2020/7/25.
//  Copyright © 2020 ug. All rights reserved.
//

#import "UGYNLotteryController.h"
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
#import "UGSegmentView.h"
#import "UGLotteryRecordTableViewCell.h"
#import "YNSegmentView.h"

#import "UGLotteryHistoryModel.h"
#import "CMTimeCommon.h"
#import "YNInputView.h"
#import "YNQuickSelectView.h"

#import "YNCollectionFootView.h"
#import "YNCollectionViewCell.h"
#import "CMLabelCommon.h"
@interface UGYNLotteryController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,YBPopupMenuDelegate,WSLWaterFlowLayoutDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *currentIssueLabel;/**<头 上 当前开奖  */
@property (weak, nonatomic) IBOutlet UIButton *historyBtn;/**<头 上 历史记录按钮  */
@property (weak, nonatomic) IBOutlet UILabel *nextIssueLabel;/**<头 下 下期开奖  */
@property (weak, nonatomic) IBOutlet UILabel *closeTimeLabel;/**<头 下 封盘时间  */
@property (weak, nonatomic) IBOutlet UILabel *openTimeLabel;/**<头 下 开奖时间  */

@property (weak, nonatomic) IBOutlet UITextField *amountTextF;/**<底部  下注倍数 */
@property (weak, nonatomic) IBOutlet UILabel *selectLabel;/**<底部  已选中  */
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;/**<底部  金额越南盾  */
@property (weak, nonatomic) IBOutlet UILabel *oddsLabel;/**<底部  赔率  */
//@property (weak, nonatomic) IBOutlet UIButton *chipButton;/**<底部  筹码  */
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
@property (weak, nonatomic) IBOutlet UIView *rightStackView;/**<右边内容*/

@property (nonatomic, strong) UICollectionView *headerCollectionView;
@property (nonatomic, strong) NSIndexPath *typeIndexPath;
@property (nonatomic, strong) NSIndexPath *itemIndexPath;
@property (nonatomic, strong) NSArray <NSString *> *preNumArray;
@property (nonatomic, strong) NSArray <NSString *> *preNumSxArray;

@property (strong, nonatomic) CountDown *countDown;

@property (nonatomic, strong) STBarButtonItem *rightItem1;
@property (nonatomic, strong) WSLWaterFlowLayout *flow;

@property (nonatomic, assign) BOOL showAdPoppuView;

@property (strong, nonatomic)UGYYRightMenuView *yymenuView;

//===============================================
@property (nonatomic, strong) UGSegmentView *segmentView;                           /**<   segment*/
@property (nonatomic, assign) NSInteger segmentIndex;                               /**<   segment选中的Index */
@property (nonatomic, strong) NSMutableArray <NSString *> *lmgmentTitleArray;       /**<   segment 的标题 */
@property (nonatomic, strong) NSMutableArray <NSString *> *lmgmentCodeArray;       /**<   segment 的标题 code*/
@property (nonatomic, strong) NSMutableArray *selArray ;                            /**<  选中的 */
//===============================================
@property (nonatomic, strong) YNSegmentView *ynsegmentView;                           /**<   分栏segment*/
@property (strong, nonatomic)  UIView *yncontentView; /**<   分栏segment下面的内容界面*/
@property (nonatomic, strong) UICollectionView *betCollectionView;/**<   分栏segment下面的选择号码界面*/
@property (strong, nonatomic)  YNInputView *inputView;/**<   分栏segment下面的输入界面*/
@property (strong, nonatomic)  YNQuickSelectView *qsView;/**<   分栏segment下面的快速选择界面*/

//===============================================
@property (nonatomic, assign) int  defaultGold;  //默认金额 18000.0
@property (nonatomic, assign) NSString *  defaultAdds;  //默认赔率。




@end
static NSString *leftTitleCellid = @"UGTimeLotteryLeftTitleCell";
static NSString *lottryBetCellid = @"UGTimeLotteryBetCollectionViewCell";
static NSString *sscBetItem1CellId = @"UGSSCBetItem1Cell";
static NSString *headerViewID = @"UGTimeLotteryBetHeaderView";
static NSString *lotteryResultCellid = @"UGLotteryResultCollectionViewCell";
static NSString *lotterySubResultCellid = @"UGLotterySubResultCollectionViewCell";
static NSString *linkNumCellId = @"YNCollectionViewCell";
static NSString *footViewID = @"YNCollectionFootView";
@implementation UGYNLotteryController


-(UIColor *)getYNSegmentViewColor:(BOOL)selected{
    UIColor *returnColor;
    if (Skin1.isBlack||Skin1.is23) {
        returnColor = selected ? [UIColor whiteColor] : RGBA(159, 166, 173, 1);
        
    } else {
        UIColor *selectedColor = APP.betBgIsWhite ? Skin1.navBarBgColor : [UIColor whiteColor];
        if ([@"c085" containsString:APP.SiteId]) {
            selectedColor = [UIColor blueColor];
        }
        returnColor = selected ? selectedColor : [UIColor blackColor];
    }
    
    return  returnColor;
}

-(void)initYNSegmentView{
    self.ynsegmentView = [[YNSegmentView alloc] initWithFrame:CGRectMake(0, 0, UGScreenW /4 * 3, 50) titleArray:@[@"选择号码",@"输入号码",@"快速选择"]];
    [self.ynsegmentView.segment addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.ynsegmentView.button addTarget:self action:@selector(ynButtonClocked:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightStackView addSubview:self.ynsegmentView];
    WeakSelf
    [self.ynsegmentView.segment setTitleFormatter:^NSAttributedString *(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected) {
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{
            NSForegroundColorAttributeName : [weakSelf getYNSegmentViewColor:selected],
            NSFontAttributeName : [UIFont systemFontOfSize:15]
            
        }];
        return attString;
    }];
    
    self.ynsegmentView.segment.selectionStyle = HMSegmentedControlSelectionStyleBox;
    self.ynsegmentView.segment.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    [self.ynsegmentView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rightStackView.mas_left).with.offset(0);
        make.right.equalTo(self.rightStackView.mas_right).with.offset(0);
        make.top.equalTo(self.segmentView.mas_bottom).offset(1);
        make.height.mas_equalTo(50);
    }];
}

-(void)ynButtonClocked:(UIButton *)sender{
    NSLog(@"ynButtonClocked");
    UGGameplayModel *model = [self.gameDataArray objectAtIndex:self.typeIndexPath.row];
    UGGameplaySectionModel *group = [model.list objectAtIndex:0];
    if (group.list.count) {
        UGGameBetModel *bet = [group.list objectAtIndex:self.segmentIndex];
        
        [CMCommon showTitle:bet.rule];
    }
    
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    
    NSString * title = [segmentedControl.sectionTitles objectAtIndex:segmentedControl.selectedSegmentIndex];
    
    if ([title isEqualToString:@"选择号码"]) {
        [self resetClick:nil];
        [self.yncontentView bringSubviewToFront:self.betCollectionView];
        
    } else if([title isEqualToString:@"输入号码"]){
        
        [self.yncontentView bringSubviewToFront:self.inputView];
    }
    else if([title isEqualToString:@"快速选择"]){
        //得到选中行，选中的segment。 self.segmentIndex self.typeIndexPath
        UGGameplayModel *model = [self.gameDataArray objectAtIndex:self.typeIndexPath.row];
        UGGameplaySectionModel *group = [model.list objectAtIndex:0];
        if (group.list.count) {
            UGGameBetModel *bet = [group.list objectAtIndex:self.segmentIndex];
            self.qsView.bet = bet;
        }
        self.qsView.segmentedControl.selectedSegmentIndex = 0;
        [self.yncontentView bringSubviewToFront:self.qsView];
    }
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
        collectionView.backgroundColor = Skin1.textColor4;
        if (APP.betBgIsWhite) {
            collectionView.backgroundColor =  [UIColor whiteColor];
        } else {
            if (APP.isLight) {
                collectionView.backgroundColor = [Skin1.skitString containsString:@"六合"] ? [Skin1.navBarBgColor colorWithAlphaComponent:0.8] :[Skin1.bgColor colorWithAlphaComponent:0.8];
                
            }
            else{
                collectionView.backgroundColor = [Skin1.skitString containsString:@"六合"] ? Skin1.navBarBgColor : Skin1.bgColor;
                
            }
        }
        
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [collectionView registerNib:[UINib nibWithNibName:@"UGTimeLotteryBetCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:lottryBetCellid];
        [collectionView registerNib:[UINib nibWithNibName:@"UGSSCBetItem1Cell" bundle:nil] forCellWithReuseIdentifier:sscBetItem1CellId];
        [collectionView registerNib:[UINib nibWithNibName:@"YNCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:linkNumCellId];
        [collectionView registerNib:[UINib nibWithNibName:@"UGTimeLotteryBetHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewID];
        [collectionView registerNib:[UINib nibWithNibName:@"YNCollectionFootView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footViewID];
        
        collectionView;
        
    });
    collectionView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
    [self.yncontentView addSubview:collectionView];
    [collectionView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.yncontentView);
    }];
    self.betCollectionView = collectionView;
    
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
        [collectionView registerNib:[UINib nibWithNibName:@"YNCollectionFootView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footViewID];
        collectionView;
        
    });
    
    self.headerCollectionView = collectionView;
    [self.headerOneView addSubview:collectionView];
    [self.headerOneView bringSubviewToFront:self.historyBtn];
    
}


- (void)yncontentViewInit {
    _yncontentView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.rightStackView addSubview:_yncontentView];
    [self.yncontentView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rightStackView.mas_left).with.offset(0);
        make.right.equalTo(self.rightStackView.mas_right).with.offset(0);
        make.top.equalTo(self.ynsegmentView.mas_bottom).offset(1);
        make.bottom.equalTo(self.rightStackView.mas_bottom).offset(1);
    }];
    
}

-(void)inputViewInit{
    _inputView = [[YNInputView alloc] initWithFrame:CGRectZero];
    [self.yncontentView addSubview:_inputView];
    [_inputView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.yncontentView);
    }];
    
}

-(void)qsViewInit{
    _qsView = [[YNQuickSelectView alloc] initWithFrame:CGRectZero];
    [self.yncontentView addSubview:_qsView];
    [_qsView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.yncontentView);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.betButton.layer.cornerRadius = 5;
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
    
    
    //开奖数据
    [self initHeaderCollectionView];
    //第一个分段
    [self.rightStackView addSubview:self.segmentView];
    //分段
    [self initYNSegmentView];
    //内容View
    [self yncontentViewInit];
    //选择号码
    [self initBetCollectionView];
    //输入号码
    [self inputViewInit];
    //快速选择
    [self qsViewInit];
    //选择号码放到最前面
    [self.yncontentView bringSubviewToFront:self.betCollectionView];
    
    [self getGameDatas];
    [self getNextIssueData];
    
    
    [self  setDefaultData:@"PIHAO2"];
    WeakSelf
    self.segmentIndex = 0;
    void (^segmentViewActon)(NSInteger) = ^(NSInteger row) {
        weakSelf.segmentIndex = row;
        NSString * code =  [weakSelf.lmgmentCodeArray objectAtIndex:row];
        
        if ([code isEqualToString:@"PIHAO2"]||[code isEqualToString:@"DIDUAN2"]
            ||[code isEqualToString:@"PIHAO3"]||[code isEqualToString:@"BIAOTI"]
            ||[code isEqualToString:@"ZHUANTI"]||[code isEqualToString:@"BIAOTIWB"]
            ||[code isEqualToString:@"3YINJIE"]||[code isEqualToString:@"3GTEBIE"]
            ||[code isEqualToString:@"3WBDJT"]) {
            //批号2 地段2 1K 批号3 标题 专题 标题尾巴 3个音阶 3更特别 3尾巴的尽头
            weakSelf.ynsegmentView.hidden = NO;
            [weakSelf.ynsegmentView.segment setSectionTitles:@[@"选择号码",@"输入号码",@"快速选择"]];
        }
        else if ([code isEqualToString:@"PIHAO4"]||[code isEqualToString:@"4GTEBIE"]){
            //批号4 4更特别
            weakSelf.ynsegmentView.hidden = NO;
            [weakSelf.ynsegmentView.segment setSectionTitles:@[@"选择号码",@"输入号码"]];
        }
        else if ([code isEqualToString:@"PIANXIE2"]||[code isEqualToString:@"PIANXIE3"]
                 ||[code isEqualToString:@"PIANXIE4"]||[code isEqualToString:@"CHUANSHAO4"]
                 ||[code isEqualToString:@"CHUANSHAO8"]||[code isEqualToString:@"CHUANSHAO10"]){
            //偏斜2 偏斜3 偏斜4 串烧4 串烧8 串烧10
            weakSelf.ynsegmentView.hidden = NO;
            [weakSelf.ynsegmentView.segment setSectionTitles:@[@"输入号码",@"快速选择"]];
        }
        else if ([code isEqualToString:@"TOU"]||[code isEqualToString:@"WEI"]){
            //头 尾
            weakSelf.ynsegmentView.hidden = YES;
        }
        [weakSelf setDefaultData:code];
        
        [weakSelf.betCollectionView reloadData];
        
    };
    self.segmentView.segmentIndexBlock = segmentViewActon;
    self.lmgmentTitleArray = [NSMutableArray new];
    self.lmgmentCodeArray = [NSMutableArray new];
    self.selArray = [NSMutableArray new];
    
    
    self.typeIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    self.itemIndexPath = nil;
    
    [self updateSelectLabelWithCount:0];
    [self setAmountLableCount :0];
    [self setupBarButtonItems];
    SANotificationEventSubscribe(UGNotificationGetUserInfoComplete, self, ^(typeof (self) self, id obj) {
        STButton *button = (STButton *)self.rightItem1.customView;
        [button.imageView.layer removeAllAnimations];
        
        [self setupBarButtonItems];
        
    });
    [self updateCloseLabel];
    [self updateOpenLabel];
    
    self.countDown = [[CountDown alloc] init];
    self.nextIssueCountDown = [[CountDown alloc] init];
    
    [self updateHeaderViewData];
    [self updateCloseLabel];
    [self updateOpenLabel];
    
    
    
    
    
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
    WeakSelf;
    [CMNetwork getNextIssueWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            weakSelf.nextIssueModel = model.data;
            if (weakSelf.nextIssueModel) {
                if (OBJOnceToken(self)) {
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
    [SVProgressHUD showWithStatus:nil];
    WeakSelf;
    [CMNetwork getGameDatasWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            if ([CMCommon stringIsNull:model.data]) {
                [SVProgressHUD showSuccessWithStatus:model.msg];
                return;
                
            }
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UGPlayOddsModel *play = model.data;
                weakSelf.gameDataArray = play.playOdds.mutableCopy;
                
                // 删除enable为NO的数据（不显示出来）
                for (UGGameplayModel *gm in play.playOdds) {
                    for (UGGameplaySectionModel *gsm in gm.list) {
                        if (!gsm.enable)
                            [weakSelf.gameDataArray removeObject:gm];
                    }
                }
                //分段标题
                UGGameplayModel *model = [weakSelf.gameDataArray objectAtIndex:0];
                for (UGGameplaySectionModel *type in model.list) {
                    if (type.list.count) {
                        for (NSDictionary *dic in type.list) {
                            
                            UGGameBetModel *obj = [[UGGameBetModel alloc] mj_setKeyValues:dic];
                            [weakSelf.lmgmentTitleArray addObject:obj.name];
                            [weakSelf.lmgmentCodeArray addObject:obj.code];
                        }
                    }
                }
                [weakSelf handleData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    weakSelf.segmentView.dataArray = self.lmgmentTitleArray;
                    [weakSelf.tableView reloadData];
                    [weakSelf.betCollectionView reloadData];
                    [weakSelf.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
                    [SVProgressHUD dismiss];
                });
            });
            
        } failure:^(id msg) {
            [SVProgressHUD dismiss];
        }];
    }];
}

//越南玩法数据处理
- (void)handleData {
    
    for (UGGameplayModel *model in self.gameDataArray) {
        
        UGGameplaySectionModel *group = [model.list objectAtIndex:0];
        if (group.list.count) {
            
            NSMutableArray<UGGameBetModel *> *datalist = [NSMutableArray new];
            for (int i = 0; i < group.list.count; i++) {
                NSDictionary *dic = (NSDictionary *) [group.list objectAtIndex:i];
                UGGameBetModel *bet = [[UGGameBetModel alloc] mj_setKeyValues:dic];
                //                        ==========选择号码数组================================================================
                //批号2 地段21K号 标题 专题 标题尾巴// 加 十 个
                if ([bet.code isEqualToString:@"PIHAO2"]||[bet.code isEqualToString:@"DIDUAN2"]
                    ||[bet.code isEqualToString:@"BIAOTI"]||[bet.code isEqualToString:@"ZHUANTI"]
                    ||[bet.code isEqualToString:@"BIAOTIWB"]) {
                    //批号2 地段21K号 标题 专题 标题尾巴
                    // 加 十 个
                    NSMutableArray *sectionArray = [NSMutableArray array];
                    for (int i = 0; i< 2; i++) {
                        UGGameplaySectionModel * sectionModel = [[UGGameplaySectionModel alloc] init];
                        if (i == 0 ) {
                            sectionModel.name = @"十";
                        }else if (i == 1 ) {
                            sectionModel.name = @"个";
                        }
                        
                        [sectionArray addObject:sectionModel];
                    }
                    
                    for (UGGameplaySectionModel *sectionModel in sectionArray) {
                        NSMutableArray *array = [NSMutableArray array];
                        for (int i = 0; i < 10; i++) {
                            UGGameBetModel *betM = [[UGGameBetModel alloc] init];
                            [betM setValuesForKeysWithDictionary:bet.mj_keyValues];
                            betM.alias = bet.name;
                            betM.typeName = group.name;
                            betM.codeName = group.code;
                            betM.name = [NSString stringWithFormat:@"%d",i ];
                            [array addObject:betM];
                        }
                        sectionModel.list = array.copy;
                    }
                    
                    bet.ynList = sectionArray.copy;
                    
                    
                }
                //批号3 3个音阶 3更特别 3尾巴的尽头 // 加 百 十 个
                if ([bet.code isEqualToString:@"PIHAO3"]||[bet.code isEqualToString:@"3YINJIE"]
                    ||[bet.code isEqualToString:@"3GTEBIE"]||[bet.code isEqualToString:@"3WBDJT"]) {
                    NSMutableArray *sectionArray = [NSMutableArray array];
                    for (int i = 0; i< 3; i++) {
                        UGGameplaySectionModel * sectionModel = [[UGGameplaySectionModel alloc] init];
                        if (i == 0 ) {
                            sectionModel.name = @"百";
                        }else if (i == 1 ) {
                            sectionModel.name = @"十";
                        }else if (i == 2 ) {
                            sectionModel.name = @"个";
                        }
                        
                        [sectionArray addObject:sectionModel];
                    }
                    
                    for (UGGameplaySectionModel *sectionModel in sectionArray) {
                        NSMutableArray *array = [NSMutableArray array];
                        for (int i = 0; i < 10; i++) {
                            UGGameBetModel *betM = [[UGGameBetModel alloc] init];
                            [betM setValuesForKeysWithDictionary:bet.mj_keyValues];
                            betM.alias = bet.name;
                            betM.typeName = group.name;
                            betM.codeName = group.code;
                            betM.name = [NSString stringWithFormat:@"%d",i ];
                            [array addObject:betM];
                        }
                        sectionModel.list = array.copy;
                    }
                    
                    bet.ynList = sectionArray.copy;
                }
                //头 尾 // 加  十
                if ([bet.code isEqualToString:@"TOU"]||[bet.code isEqualToString:@"WEI"]) {
                    NSMutableArray *sectionArray = [NSMutableArray array];
                    for (int i = 0; i< 1; i++) {
                        UGGameplaySectionModel * sectionModel = [[UGGameplaySectionModel alloc] init];
                        if (i == 0 ) {
                            sectionModel.name = @"十";
                        }
                        [sectionArray addObject:sectionModel];
                    }
                    
                    for (UGGameplaySectionModel *sectionModel in sectionArray) {
                        NSMutableArray *array = [NSMutableArray array];
                        for (int i = 0; i < 10; i++) {
                            UGGameBetModel *betM = [[UGGameBetModel alloc] init];
                            [betM setValuesForKeysWithDictionary:bet.mj_keyValues];
                            betM.alias = bet.name;
                            betM.typeName = group.name;
                            betM.codeName = group.code;
                            betM.name = [NSString stringWithFormat:@"%d",i ];
                            [array addObject:betM];
                        }
                        sectionModel.list = array.copy;
                    }
                    
                    bet.ynList = sectionArray.copy;
                }
                //4更特别 // 加  千 百 十 个
                if ([bet.code isEqualToString:@"PIHAO4"]||[bet.code isEqualToString:@"4GTEBIE"]) {
                    NSMutableArray *sectionArray = [NSMutableArray array];
                    for (int i = 0; i< 4; i++) {
                        UGGameplaySectionModel * sectionModel = [[UGGameplaySectionModel alloc] init];
                        if (i == 0 ) {
                            sectionModel.name = @"千";
                        }
                        else if (i == 1 ) {
                            sectionModel.name = @"百";
                        }
                        else if (i == 2 ) {
                            sectionModel.name = @"十";
                        }
                        else if (i == 3 ) {
                            sectionModel.name = @"个";
                        }
                        [sectionArray addObject:sectionModel];
                    }
                    
                    for (UGGameplaySectionModel *sectionModel in sectionArray) {
                        NSMutableArray *array = [NSMutableArray array];
                        for (int i = 0; i < 10; i++) {
                            UGGameBetModel *betM = [[UGGameBetModel alloc] init];
                            [betM setValuesForKeysWithDictionary:bet.mj_keyValues];
                            betM.alias = bet.name;
                            betM.typeName = group.name;
                            betM.codeName = group.code;
                            betM.name = [NSString stringWithFormat:@"%d",i ];
                            [array addObject:betM];
                        }
                        sectionModel.list = array.copy;
                    }
                    
                    bet.ynList = sectionArray.copy;
                }
                //                        ==========快速选择数组================================================================
                //批号2 地段21K号 标题 专题 标题尾巴  串烧4 串烧8 串烧10// 加 00-99
                if ([bet.code isEqualToString:@"PIHAO2"]||[bet.code isEqualToString:@"DIDUAN2"]
                    ||[bet.code isEqualToString:@"BIAOTI"]||[bet.code isEqualToString:@"ZHUANTI"]
                    ||[bet.code isEqualToString:@"BIAOTIWB"]||[bet.code isEqualToString:@"CHUANSHAO4"]
                    ||[bet.code isEqualToString:@"CHUANSHAO8"]||[bet.code isEqualToString:@"CHUANSHAO10"]) {
                    NSMutableArray *sectionArray = [NSMutableArray array];
                    for (int i = 0; i< 1; i++) {
                        UGGameplaySectionModel * sectionModel = [[UGGameplaySectionModel alloc] init];
                        if (i == 0 ) {
                            sectionModel.name = @"00-99";
                        }
                        [sectionArray addObject:sectionModel];
                    }
                    
                    for (UGGameplaySectionModel *sectionModel in sectionArray) {
                        NSMutableArray *array = [NSMutableArray array];
                        for (int i = 0; i < 100; i++) {
                            UGGameBetModel *betM = [[UGGameBetModel alloc] init];
                            [betM setValuesForKeysWithDictionary:bet.mj_keyValues];
                            betM.alias = bet.name;
                            betM.typeName = group.name;
                            betM.codeName = group.code;
                            if (i< 10) {
                                betM.name = [NSString stringWithFormat:@"0%d",i ];
                            } else {
                                betM.name = [NSString stringWithFormat:@"%d",i ];
                            }
                            
                            [array addObject:betM];
                        }
                        sectionModel.list = array.copy;
                    }
                    
                    bet.ynFastList = sectionArray.copy;
                }
                //批号3 3个音阶 3更特别 3尾巴的尽头 // 加 000-999
                if ([bet.code isEqualToString:@"PIHAO3"]||[bet.code isEqualToString:@"3YINJIE"]
                    ||[bet.code isEqualToString:@"3GTEBIE"]||[bet.code isEqualToString:@"3WBDJT"]) {
                    NSMutableArray *sectionArray = [NSMutableArray array];
                    for (int i = 0; i< 10; i++) {
                        UGGameplaySectionModel * sectionModel = [[UGGameplaySectionModel alloc] init];
                        sectionModel.name = [NSString stringWithFormat:@"%d00-%d99",i,i];
                        sectionModel.yni = i;
                        [sectionArray addObject:sectionModel];
                    }
                    
                    for (UGGameplaySectionModel *sectionModel in sectionArray) {
                        
                        
                        NSMutableArray *array = [NSMutableArray array];
                        for (int i = 0; i < 100; i++) {
                            UGGameBetModel *betM = [[UGGameBetModel alloc] init];
                            [betM setValuesForKeysWithDictionary:bet.mj_keyValues];
                            betM.alias = bet.name;
                            betM.typeName = group.name;
                            betM.codeName = group.code;
                            
                            if (sectionModel.yni == 0) {
                                if (i<10) {
                                    betM.name = [NSString stringWithFormat:@"00%d",i ];
                                }
                                else {
                                    betM.name = [NSString stringWithFormat:@"0%d",i ];
                                }
                            } else {
                                betM.name = [NSString stringWithFormat:@"%d",i+sectionModel.yni*100];
                            }
                            
                            
                            [array addObject:betM];
                        }
                        sectionModel.list = array.copy;
                    }
                    
                    bet.ynFastList = sectionArray.copy;
                }
                
                
                [datalist addObject:bet];
                
            }
            
            [group setList:datalist.copy];
            
            
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
    [self.selArray removeAllObjects];
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
        for (UGGameplayModel *model in self.gameDataArray) {
            if (!model.select) {
                continue;
            }
            NSLog(@"model.code ======================== %@",model.code);
            NSLog(@"model.name ======================== %@",model.name);
            selCode = model.code;
            
            if ([model.name isEqualToString:@"官方玩法"]) {
                
                for (UGGameBetModel *game in self.selArray) {
                    if (game.select) {
                        game.money = self.amountTextF.text;
                        [array addObject:game];
                    }
                    
                }
                
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
            
        }
        NSMutableArray *dicArray = [UGGameBetModel mj_keyValuesArrayWithObjectArray:array];
        [self goUGBetDetailViewObjArray:array.copy dicArray:dicArray.copy issueModel:self.nextIssueModel  gameType:self.nextIssueModel.gameId selCode:selCode];
        
        
    });
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
        
        //设置segmentView标题 和 code 数据
        self.segmentIndex = 0;
        [self segmentViewTitleAndCode:model];
        
        //判断ynsegmentView 标题 和 隐藏
        [self determineYnsegmentViewTitle:model.code];
    }
    
}

-(void)segmentViewTitleAndCode:(UGGameplayModel *)model{
    [self.lmgmentTitleArray removeAllObjects];
    [self.lmgmentCodeArray removeAllObjects];
    
    for (UGGameplaySectionModel *type in model.list) {
        if (type.list.count) {
            for (UGGameBetModel *obj in type.list) {
                [self.lmgmentTitleArray addObject:obj.name];
                [self.lmgmentCodeArray addObject:obj.code];
            }
        }
    }
    self.segmentView.dataArray = self.lmgmentTitleArray;
    self.segmentView.hidden = NO;
    
}

-(void)determineYnsegmentViewTitle:(NSString *)code{
    
    if ([code isEqualToString:@"TW"]) {
        
        [self resetClick:nil];
        [self.yncontentView bringSubviewToFront:self.betCollectionView];
        self.ynsegmentView.hidden = YES;
        
        if (self.ynsegmentView.hidden) {
            [self.yncontentView  mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.rightStackView.mas_left).with.offset(0);
                make.right.equalTo(self.rightStackView.mas_right).with.offset(0);
                make.top.equalTo(self.segmentView.mas_bottom).offset(1);
                make.bottom.equalTo(self.rightStackView.mas_bottom).offset(1);
            }];
        }
        
        
        
    } else {
        
        self.ynsegmentView.hidden = NO;
        if (!self.ynsegmentView.hidden) {
            [self.yncontentView  mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.rightStackView.mas_left).with.offset(0);
                make.right.equalTo(self.rightStackView.mas_right).with.offset(0);
                make.top.equalTo(self.ynsegmentView.mas_bottom).offset(1);
                make.bottom.equalTo(self.rightStackView.mas_bottom).offset(1);
            }];
        }
        if ([code isEqualToString:@"4GD"]) {
            [self.ynsegmentView.segment setSectionTitles:@[@"选择号码",@"输入号码"]];
            [self resetClick:nil];
            [self.yncontentView bringSubviewToFront:self.betCollectionView];
        }
        else if([code isEqualToString:@"BL"]||[code isEqualToString:@"LBXC"]
                ||[code isEqualToString:@"3GD"]){
            [self.ynsegmentView.segment setSectionTitles:@[@"选择号码",@"输入号码",@"快速选择"]];
            [self resetClick:nil];
            [self.yncontentView bringSubviewToFront:self.betCollectionView];
        }
        else if([code isEqualToString:@"DDQX"]||[code isEqualToString:@"CQ"]){
            [self.ynsegmentView.segment setSectionTitles:@[@"输入号码",@"快速选择"]];
            [self.yncontentView bringSubviewToFront:self.inputView];
        }
    }
    
    [self.ynsegmentView.segment setSelectedSegmentIndex:0];
    
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (collectionView == self.betCollectionView) {
        if (self.gameDataArray.count) {
            
            UGGameplayModel *model = self.gameDataArray[self.typeIndexPath.row];
            
            UGGameplaySectionModel *group = [model.list objectAtIndex:0];
            if (group.list.count) {
                
                UGGameBetModel *bet =  [group.list objectAtIndex:self.segmentIndex];
                //批号2 地段21K号 标题 专题 标题尾巴// 加 十 个
                if ([bet.code isEqualToString:@"PIHAO2"]||[bet.code isEqualToString:@"DIDUAN2"]
                    ||[bet.code isEqualToString:@"BIAOTI"]||[bet.code isEqualToString:@"ZHUANTI"]
                    ||[bet.code isEqualToString:@"BIAOTIWB"]){
                    return 2;
                }
                //批号3 3个音阶 3更特别 3尾巴的尽头 // 加 百 十 个
                if ([bet.code isEqualToString:@"PIHAO3"]||[bet.code isEqualToString:@"3YINJIE"]
                    ||[bet.code isEqualToString:@"3GTEBIE"]||[bet.code isEqualToString:@"3WBDJT"]){
                    return 3;
                }
                //头 尾 // 加  十
                if ([bet.code isEqualToString:@"TOU"]||[bet.code isEqualToString:@"WEI"]){
                    return 1;
                }
                //4更特别 // 加  千 百 十 个
                if ([bet.code isEqualToString:@"PIHAO4"]||[bet.code isEqualToString:@"4GTEBIE"]){
                    return 4;
                }
                
            }
            
        }
        
        return 0;
        
    }
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.betCollectionView) {
        return 10;
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
        UGGameBetModel *game = nil;
        
        UGGameplaySectionModel *group = [model.list objectAtIndex:0];
        if (group.list.count) {
            
            UGGameBetModel *bet = [group.list objectAtIndex:self.segmentIndex];
            UGGameplaySectionModel * sectionModel = bet.ynList[indexPath.section];
            game =  sectionModel.list[indexPath.row];
            
        }
        
        YNCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:linkNumCellId forIndexPath:indexPath];
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
            UGGameplaySectionModel *group = model.list[0];
            UGGameBetModel *bet =  [group.list objectAtIndex:self.segmentIndex];
            UGGameplaySectionModel * sectionModel = bet.ynList[indexPath.section];
            headerView.titleLabel.text = sectionModel.name;
            
        }else {
            
            headerView.titleLabel.text = @"";
            
        }
        return headerView;
        
    }
    else if([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        YNCollectionFootView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footViewID forIndexPath:indexPath];
        if (collectionView == self.betCollectionView) {
            
            WeakSelf;
            [footerView.allButton removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
            [footerView.bigButton removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
            [footerView.smallButton removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
            [footerView.pButton removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
            [footerView.accidButton removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
            [footerView.removeButton removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
            [footerView.allButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
                
                UGGameplayModel *model = self.gameDataArray[self.typeIndexPath.row];
                UGGameplaySectionModel *group = [model.list objectAtIndex:0];
                if (group.list.count) {
                    UGGameBetModel *bet = [group.list objectAtIndex:self.segmentIndex];
                    UGGameplaySectionModel * sectionModel = bet.ynList[indexPath.section];
                    for (int i = 0; i< sectionModel.list.count; i++) {
                        UGGameBetModel *game =  sectionModel.list[i];
                        if (!game.enable) {
                            return;
                        }
                        game.select = YES;
                    }
                    //刷新Section
                    [UIView performWithoutAnimation:^{
                        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:indexPath.section];
                        [weakSelf.betCollectionView reloadSections:indexSet];
                    }];
                    
                    
                    [self calculate:bet];
                    
                }
            }];//所有
            
            [footerView.bigButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
                
                [weakSelf removeAllCellsAtIndexPath:indexPath];
                
                UGGameplayModel *model = self.gameDataArray[self.typeIndexPath.row];
                UGGameplaySectionModel *group = [model.list objectAtIndex:0];
                if (group.list.count) {
                    UGGameBetModel *bet = [group.list objectAtIndex:self.segmentIndex];
                    UGGameplaySectionModel * sectionModel = bet.ynList[indexPath.section];
                    for (int i = 0; i< sectionModel.list.count; i++) {
                        UGGameBetModel *game =  sectionModel.list[i];
                        if (!game.enable) {
                            return;
                        }
                        if (game.name.intValue >= 5) {
                            game.select = YES;
                        }
                        
                    }
                    
                    //刷新Section
                    [UIView performWithoutAnimation:^{
                        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:indexPath.section];
                        [weakSelf.betCollectionView reloadSections:indexSet];
                    }];
                    
                    [self calculate:bet];
                    
                }
            }];//大数
            
            [footerView.smallButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
                
                [weakSelf removeAllCellsAtIndexPath:indexPath];
                
                UGGameplayModel *model = self.gameDataArray[self.typeIndexPath.row];
                UGGameplaySectionModel *group = [model.list objectAtIndex:0];
                if (group.list.count) {
                    UGGameBetModel *bet = [group.list objectAtIndex:self.segmentIndex];
                    UGGameplaySectionModel * sectionModel = bet.ynList[indexPath.section];
                    for (int i = 0; i< sectionModel.list.count; i++) {
                        UGGameBetModel *game =  sectionModel.list[i];
                        if (!game.enable) {
                            return;
                        }
                        if (game.name.intValue < 5) {
                            game.select = YES;
                        }
                        
                    }
                    
                    [UIView performWithoutAnimation:^{
                        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:indexPath.section];
                        [weakSelf.betCollectionView reloadSections:indexSet];
                    }];
                    
                    [self calculate:bet];
                    
                }
            }];//小数
            
            [footerView.pButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
                
                [weakSelf removeAllCellsAtIndexPath:indexPath];
                
                UGGameplayModel *model = self.gameDataArray[self.typeIndexPath.row];
                UGGameplaySectionModel *group = [model.list objectAtIndex:0];
                if (group.list.count) {
                    UGGameBetModel *bet = [group.list objectAtIndex:self.segmentIndex];
                    UGGameplaySectionModel * sectionModel = bet.ynList[indexPath.section];
                    for (int i = 0; i< sectionModel.list.count; i++) {
                        UGGameBetModel *game =  sectionModel.list[i];
                        if (!game.enable) {
                            return;
                        }
                        if (game.name.intValue %2 != 0) {
                            game.select = YES;
                        }
                        
                    }
                    
                    [UIView performWithoutAnimation:^{
                        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:indexPath.section];
                        [weakSelf.betCollectionView reloadSections:indexSet];
                    }];
                    
                    [self calculate:bet];
                }
            }];//奇数
            
            [footerView.accidButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
                
                [weakSelf removeAllCellsAtIndexPath:indexPath];
                
                UGGameplayModel *model = self.gameDataArray[self.typeIndexPath.row];
                UGGameplaySectionModel *group = [model.list objectAtIndex:0];
                if (group.list.count) {
                    UGGameBetModel *bet = [group.list objectAtIndex:self.segmentIndex];
                    UGGameplaySectionModel * sectionModel = bet.ynList[indexPath.section];
                    for (int i = 0; i< sectionModel.list.count; i++) {
                        UGGameBetModel *game =  sectionModel.list[i];
                        if (!game.enable) {
                            return;
                        }
                        if (game.name.intValue %2 == 0) {
                            game.select = YES;
                        }
                        
                    }
                    
                    [UIView performWithoutAnimation:^{
                        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:indexPath.section];
                        [weakSelf.betCollectionView reloadSections:indexSet];
                    }];
                    
                    [self calculate:bet];
                }
            }];//偶数
            
            [footerView.removeButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
                
                [weakSelf removeAllCellsAtIndexPath:indexPath];
                
                [UIView performWithoutAnimation:^{
                    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:indexPath.section];
                    [weakSelf.betCollectionView reloadSections:indexSet];
                }];
                
                UGGameplayModel *model = self.gameDataArray[self.typeIndexPath.row];
                UGGameplaySectionModel *group = [model.list objectAtIndex:0];
                if (group.list.count) {
                    UGGameBetModel *bet = [group.list objectAtIndex:self.segmentIndex];
                    [self calculate:bet];
                }
                
            }];//移除
            
            
            return footerView;
        }else {
            
            return nil;
            
        }
        
    }
    return nil;
    
}

//取消全部的选中
-(void)removeAllCellsAtIndexPath:(NSIndexPath *)indexPath {
    UGGameplayModel *model = self.gameDataArray[self.typeIndexPath.row];
    UGGameplaySectionModel *group = [model.list objectAtIndex:0];
    if (group.list.count) {
        UGGameBetModel *bet = [group.list objectAtIndex:self.segmentIndex];
        UGGameplaySectionModel * sectionModel = bet.ynList[indexPath.section];
        for (int i = 0; i< sectionModel.list.count; i++) {
            UGGameBetModel *game =  sectionModel.list[i];
            if (!game.enable) {
                return;
            }
            
            game.select = NO;
            
            
        }
    }
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
    if (collectionView == self.betCollectionView) {
        if (self.bottomCloseView.hidden == NO) {
            [SVProgressHUD showInfoWithStatus:@"封盘中"];
            return;
        }
        
        UGGameplayModel *model = self.gameDataArray[self.typeIndexPath.row];
        UGGameplaySectionModel *obj = [model.list objectAtIndex:0];
        UGGameBetModel *bet = [obj.list objectAtIndex:self.segmentIndex];
        //批号2 地段21K号 标题 专题 标题尾巴// 加 十 个
        if ([bet.code isEqualToString:@"PIHAO2"]||[bet.code isEqualToString:@"DIDUAN2"]
            ||[bet.code isEqualToString:@"BIAOTI"]||[bet.code isEqualToString:@"ZHUANTI"]
            ||[bet.code isEqualToString:@"BIAOTIWB"]) {
            
            UGGameplaySectionModel *type = bet.ynList[indexPath.section];
            UGGameBetModel *game = type.list[indexPath.row];
            if (!game.enable) {
                return;
            }
            game.select = !game.select;
        }
        //头 尾 // 加  十
        else  if ([bet.code isEqualToString:@"TOU"]||[bet.code isEqualToString:@"WEI"]) {
            UGGameplaySectionModel *type = bet.ynList[indexPath.section];
            UGGameBetModel *game = type.list[indexPath.row];
            if (!game.enable) {
                return;
            }
            game.select = !game.select;
        }
        //批号3 3个音阶 3更特别 3尾巴的尽头 // 加 百 十 个
        else if ([bet.code isEqualToString:@"PIHAO3"]||[bet.code isEqualToString:@"3YINJIE"]
                 ||[bet.code isEqualToString:@"3GTEBIE"]||[bet.code isEqualToString:@"3WBDJT"]) {
            UGGameplaySectionModel *type = bet.ynList[indexPath.section];
            UGGameBetModel *game = type.list[indexPath.row];
            if (!game.enable) {
                return;
            }
            game.select = !game.select;
        }
        else if([bet.code isEqualToString:@"PIHAO4"]||[bet.code isEqualToString:@"4GTEBIE"]) {
            UGGameplaySectionModel *type = bet.ynList[indexPath.section];
            UGGameBetModel *game = type.list[indexPath.row];
            if (!game.enable) {
                return;
            }
            game.select = !game.select;
        }
        
        [self.betCollectionView reloadData];
        
        NSInteger number = 0;
        for (UGGameBetModel *type in obj.list) {
            for (UGGameplaySectionModel *type1 in type.ynList) {
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
        
        [self calculate:bet];
    }
    
}


-(void)calculate:(UGGameBetModel *)bet{
    
    
    //        计算选中的注数
    NSInteger count = 0;
    
    //批号2 地段21K号 标题 专题 标题尾巴// 加 十 个
    if ([bet.code isEqualToString:@"PIHAO2"]||[bet.code isEqualToString:@"DIDUAN2"]
        ||[bet.code isEqualToString:@"BIAOTI"]||[bet.code isEqualToString:@"ZHUANTI"]
        ||[bet.code isEqualToString:@"BIAOTIWB"]) {
        
        [self ezdwActionModel:bet count:count];
    }
    //头 尾 // 加  十
    else  if ([bet.code isEqualToString:@"TOU"]||[bet.code isEqualToString:@"WEI"]) {
        [self yzdwActionModel:bet count:count];
    }
    //批号3 3个音阶 3更特别 3尾巴的尽头 // 加 百 十 个
    else if ([bet.code isEqualToString:@"PIHAO3"]||[bet.code isEqualToString:@"3YINJIE"]
             ||[bet.code isEqualToString:@"3GTEBIE"]||[bet.code isEqualToString:@"3WBDJT"]) {
        [self szdwActionModel:bet count:count];
        
    }
    //4更特别 // 加  千 百 十 个
    else if([bet.code isEqualToString:@"PIHAO4"]||[bet.code isEqualToString:@"4GTEBIE"]) {
        [self sszdwActionModel:bet count:count];
    }
    
}
//一字定位 计算选中的注数  十个
-(void)yzdwActionModel:(UGGameBetModel *)model count:(NSInteger)count{
    
    NSMutableArray *array = [NSMutableArray array];
    if (model.ynList.count) {
        NSMutableArray *mutArr1 = [NSMutableArray array];
        
        UGGameplaySectionModel *model1 = model.ynList[0];
        for (UGGameplayModel *bet in model1.list) {
            if (bet.select) {
                [mutArr1 addObject:bet];
            }
        }
        
        if (mutArr1.count == 0 ) {
            count = 0;
            [self  setLabelDataCount:count];
            return;
        }
        
        for (int i = 0; i < mutArr1.count; i++) {
            
            UGGameBetModel *beti = mutArr1[i];
            UGGameBetModel *bet = [[UGGameBetModel alloc] init];
            [bet setValuesForKeysWithDictionary:beti.mj_keyValues];
            NSMutableString *name = [[NSMutableString alloc] init];
            [name appendString:beti.name];
            bet.name = name;
            bet.betInfo = name;
            bet.title = bet.alias;
            bet.betMultiple = self.amountTextF.text;
            bet.money = [NSString stringWithFormat:@"%f",self.defaultGold] ;
            [array addObject:bet];
            
        }
        
        if (mutArr1.count == 0 ) {
            count = 0;
            [self  setLabelDataCount:count];
            
        } else {
            count = array.count;
            NSLog(@"count = %ld",(long)count);
            [self  setLabelDataCount:count];
        }
    }
}

//二字定位 计算选中的注数  十个
-(void)ezdwActionModel:(UGGameBetModel *)model count:(NSInteger)count{
    
    NSMutableArray *array = [NSMutableArray array];
    if (model.ynList.count) {
        NSMutableArray *mutArr1 = [NSMutableArray array];
        NSMutableArray *mutArr2 = [NSMutableArray array];
        
        UGGameplaySectionModel *model1 = model.ynList[0];
        for (UGGameplayModel *bet in model1.list) {
            if (bet.select) {
                [mutArr1 addObject:bet];
            }
        }
        UGGameplaySectionModel *model2 = model.ynList[1];
        for (UGGameplayModel *bet in model2.list) {
            if (bet.select) {
                [mutArr2 addObject:bet];
            }
        }
        if (mutArr1.count == 0 || mutArr2.count == 0) {
            count = 0;
            [self  setLabelDataCount:count];
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
                bet.betInfo = name;
                bet.title = bet.alias;
                bet.betMultiple = self.amountTextF.text;
                bet.money = [NSString stringWithFormat:@"%f",self.defaultGold] ;
                [array addObject:bet];
                
            }
        }
        
        if (mutArr1.count == 0 || mutArr2.count == 0) {
            count = 0;
            [self  setLabelDataCount:count];
            
        } else {
            count = array.count;
            NSLog(@"count = %ld",(long)count);
            [self  setLabelDataCount:count];
        }
    }
}

//三字定位 计算选中的注数  百 十 个
-(void)szdwActionModel:(UGGameBetModel *)model count:(NSInteger)count{
    
    NSMutableArray *array = [NSMutableArray array];
    
    if (model.ynList.count) {
        NSMutableArray *mutArr1 = [NSMutableArray array];
        NSMutableArray *mutArr2 = [NSMutableArray array];
        NSMutableArray *mutArr3 = [NSMutableArray array];
        
        UGGameplaySectionModel *model1 = model.ynList[0];
        for (UGGameplayModel *bet in model1.list) {
            if (bet.select) {
                [mutArr1 addObject:bet];
            }
        }
        UGGameplaySectionModel *model2 = model.ynList[1];
        for (UGGameplayModel *bet in model2.list) {
            if (bet.select) {
                [mutArr2 addObject:bet];
            }
        }
        UGGameplaySectionModel *model3 = model.ynList[2];
        for (UGGameplayModel *bet in model3.list) {
            if (bet.select) {
                [mutArr3 addObject:bet];
            }
        }
        if (mutArr1.count == 0 || mutArr2.count == 0|| mutArr3.count == 0) {
            count = 0;
            [self  setLabelDataCount:count];
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
                    bet.title = bet.alias;
                    bet.betInfo = name;
                    bet.betMultiple = self.amountTextF.text;
                    bet.money = [NSString stringWithFormat:@"%d",self.defaultGold] ;
                    [array addObject:bet];
                }
            }
        }
        
        if (mutArr1.count == 0 || mutArr2.count == 0|| mutArr3.count == 0) {
            count = 0;
            [self  setLabelDataCount:count];
            
        } else {
            count = array.count;
            NSLog(@"count = %ld",(long)count);
            [self  setLabelDataCount:count];
        }
    }
}

//四字定位 计算选中的注数   千 百 十 个
-(void)sszdwActionModel:(UGGameBetModel *)model count:(NSInteger)count{
    
    NSMutableArray *array = [NSMutableArray array];
    
    if (model.ynList.count) {
        NSMutableArray *mutArr1 = [NSMutableArray array];
        NSMutableArray *mutArr2 = [NSMutableArray array];
        NSMutableArray *mutArr3 = [NSMutableArray array];
        NSMutableArray *mutArr4 = [NSMutableArray array];
        
        UGGameplaySectionModel *model1 = model.ynList[0];
        for (UGGameplayModel *bet in model1.list) {
            if (bet.select) {
                [mutArr1 addObject:bet];
            }
        }
        UGGameplaySectionModel *model2 = model.ynList[1];
        for (UGGameplayModel *bet in model2.list) {
            if (bet.select) {
                [mutArr2 addObject:bet];
            }
        }
        UGGameplaySectionModel *model3 = model.ynList[2];
        for (UGGameplayModel *bet in model3.list) {
            if (bet.select) {
                [mutArr3 addObject:bet];
            }
        }
        
        UGGameplaySectionModel *model4 = model.ynList[3];
        for (UGGameplayModel *bet in model4.list) {
            if (bet.select) {
                [mutArr4 addObject:bet];
            }
        }
        if (mutArr1.count == 0 || mutArr2.count == 0|| mutArr3.count == 0|| mutArr4.count == 0) {
            count = 0;
            [self  setLabelDataCount:count];
            return;
        }
        
        
        for (int i = 0; i < mutArr1.count; i++) {
            
            for (int y = 0; y < mutArr2.count; y++) {
                
                for (int z = 0; z < mutArr3.count; z++) {
                    for (int k = 0; k < mutArr4.count; k++) {
                        UGGameBetModel *beti = mutArr1[i];
                        UGGameBetModel *bety = mutArr2[y];
                        UGGameBetModel *betz = mutArr3[z];
                        UGGameBetModel *betk = mutArr4[k];
                        UGGameBetModel *bet = [[UGGameBetModel alloc] init];
                        [bet setValuesForKeysWithDictionary:beti.mj_keyValues];
                        NSMutableString *name = [[NSMutableString alloc] init];
                        [name appendString:beti.name];
                        [name appendString:@","];
                        [name appendString:bety.name];
                        [name appendString:@","];
                        [name appendString:betz.name];
                        [name appendString:@","];
                        [name appendString:betk.name];
                        bet.name = name;
                        bet.title = bet.alias;
                        bet.betInfo = name;
                        bet.betMultiple = self.amountTextF.text;
                        bet.money = [NSString stringWithFormat:@"%d",self.defaultGold] ;
                        [array addObject:bet];
                    }
                }
            }
        }
        
        if (mutArr1.count == 0 || mutArr2.count == 0|| mutArr3.count == 0|| mutArr4.count == 0) {
            count = 0;
            [self  setLabelDataCount:count];
            
        } else {
            count = array.count;
            NSLog(@"count = %ld",(long)count);
            [self  setLabelDataCount:count];
        }
    }
}
#pragma mark - 显示金额

//显示金额
-(void)setAmountLableCount:(int)count{
    int amount = count * self.defaultGold;
    NSString *amountStr;
    if ([UGSystemConfigModel.currentConfig.currency isEqualToString:@"VND"]) {
        amountStr = [NSString stringWithFormat:@"金额:%d 越南盾",amount];
    }
    else {
        amountStr = [NSString stringWithFormat:@"金额:%d 元",amount];
    }
    self.amountLabel.text = amountStr;
    [CMLabelCommon setRichNumberWithLabel:self.amountLabel Color:RGBA(247, 211, 72, 1) FontSize:16];
}

-(void)setLabelDataCount:(int  )count{
    dispatch_async(dispatch_get_main_queue(), ^{
        // UI更新代码
        [self setAmountLableCount:count ];
        [self updateSelectLabelWithCount:count ];
    });
}

//显示赔率
-(void)setOuntoddsLabelLable{
    NSString *amountStr = [NSString stringWithFormat:@"赔率:1:%@",[self.defaultAdds removeFloatAllZero]];
    self.oddsLabel.text = amountStr;
}

//显示选中的
- (void)updateSelectLabelWithCount:(NSInteger)count {
    NSString *amountStr = [NSString stringWithFormat:@"已选择:%ld 个",(long)count];
    self.selectLabel.text = amountStr;
    [self.selectLabel setTextColor:[UIColor whiteColor]];
    [CMLabelCommon setRichNumberWithLabel:self.selectLabel Color:RGBA(247, 211, 72, 1) FontSize:16];

}

#pragma mark - WSLWaterFlowLayoutDelegate

//返回每个item大小
- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((UGScreenW / 4 * 3 - 11) / 5, (UGScreenW / 4 * 3 - 11) / 5);
    
}

/** 头视图Size */
-(CGSize )waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForHeaderViewInSection:(NSInteger)section {
    return CGSizeMake(UGScreenW / 4 * 3 - 1, 35);
}

/** 脚视图Size */
-(CGSize )waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForFooterViewInSection:(NSInteger)section{
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

//分段标题
- (UGSegmentView *)segmentView {
    if (_segmentView == nil) {
        _segmentView = [[UGSegmentView alloc] initWithFrame:CGRectMake(0, 0, UGScreenW /4 * 3, 50) titleArray:self.lmgmentTitleArray];
        _segmentView.hidden = NO;
        _segmentView.backgroundColor = Skin1.textColor4;
        if (APP.betBgIsWhite) {
            _segmentView.backgroundColor =  [UIColor whiteColor];
        } else {
            if (APP.isLight) {
                _segmentView.backgroundColor = [Skin1.skitString containsString:@"六合"] ? [Skin1.navBarBgColor colorWithAlphaComponent:0.8] :[Skin1.bgColor colorWithAlphaComponent:0.8];
                
            }
            else{
                _segmentView.backgroundColor = [Skin1.skitString containsString:@"六合"] ? Skin1.navBarBgColor : Skin1.bgColor;
                
            }
        }
        
        
    }
    return _segmentView;
    
}

// 设置默认
- (void)setDefaultData :(NSString *)code {
    
    if ([code isEqualToString:@"PIHAO2"]) {//批号2
        if ([UGSystemConfigModel.currentConfig.currency isEqualToString:@"VND"]) {
            self.defaultGold = 18000;
        } else {
            self.defaultGold = 18;
        }
        self.defaultAdds = @"99";
    }
    else  if ([code isEqualToString:@"DIDUAN2"]) {//地段21k号
        if ([UGSystemConfigModel.currentConfig.currency isEqualToString:@"VND"]) {
            self.defaultGold = 1000;
        } else {
            self.defaultGold = 1;
        }
        self.defaultAdds = @"5.445";
    }
    else  if ([code isEqualToString:@"PIHAO3"]) {//批号3
        if ([UGSystemConfigModel.currentConfig.currency isEqualToString:@"VND"]) {
            self.defaultGold = 17000;
        } else {
            self.defaultGold = 17;
        }
        self.defaultAdds = @"960";
    }
    else  if ([code isEqualToString:@"PIHAO3"]) {//批号3
        if ([UGSystemConfigModel.currentConfig.currency isEqualToString:@"VND"]) {
            self.defaultGold = 17000;
        } else {
            self.defaultGold = 17;
        }
        self.defaultAdds = @"960";
    }
    else  if ([code isEqualToString:@"PIHAO4"]) {//批号4
        if ([UGSystemConfigModel.currentConfig.currency isEqualToString:@"VND"]) {
            self.defaultGold = 16000;
        } else {
            self.defaultGold = 16;
        }
        self.defaultAdds = @"8880";
    }
    else  if ([code isEqualToString:@"PIANXIE2"]) {//偏斜2
        if ([UGSystemConfigModel.currentConfig.currency isEqualToString:@"VND"]) {
            self.defaultGold = 1000;
        } else {
            self.defaultGold = 1;
        }
        self.defaultAdds = @"28";
    }
    else  if ([code isEqualToString:@"PIANXIE3"]) {//偏斜3
        if ([UGSystemConfigModel.currentConfig.currency isEqualToString:@"VND"]) {
            self.defaultGold = 1000;
        } else {
            self.defaultGold = 1;
        }
        self.defaultAdds = @"150";
    }
    else  if ([code isEqualToString:@"PIANXIE4"]) {//偏斜4
        if ([UGSystemConfigModel.currentConfig.currency isEqualToString:@"VND"]) {
            self.defaultGold = 1000;
        } else {
            self.defaultGold = 1;
        }
        self.defaultAdds = @"750";
    }
    else  if ([code isEqualToString:@"BIAOTI"]) {//标题
        if ([UGSystemConfigModel.currentConfig.currency isEqualToString:@"VND"]) {
            self.defaultGold = 1000;
        } else {
            self.defaultGold = 1;
        }
        self.defaultAdds = @"98";
    }
    else  if ([code isEqualToString:@"ZHUANTI"]) {//专题
        if ([UGSystemConfigModel.currentConfig.currency isEqualToString:@"VND"]) {
            self.defaultGold = 1000;
        } else {
            self.defaultGold = 1;
        }
        self.defaultAdds = @"98";
    }
    else  if ([code isEqualToString:@"BIAOTIWB"]) {//标题尾巴
        if ([UGSystemConfigModel.currentConfig.currency isEqualToString:@"VND"]) {
            self.defaultGold = 2000;
        } else {
            self.defaultGold = 2;
        }
        self.defaultAdds = @"98";
    }
    else  if ([code isEqualToString:@"TOU"]) {//头
        if ([UGSystemConfigModel.currentConfig.currency isEqualToString:@"VND"]) {
            self.defaultGold = 1000;
        } else {
            self.defaultGold = 1;
        }
        self.defaultAdds = @"9.8";
    }
    else  if ([code isEqualToString:@"WEI"]) {//尾
        if ([UGSystemConfigModel.currentConfig.currency isEqualToString:@"VND"]) {
            self.defaultGold = 1000;
        } else {
            self.defaultGold = 1;
        }
        self.defaultAdds = @"9.8";
    }
    else  if ([code isEqualToString:@"3YINJIE"]) {//3个音阶
        if ([UGSystemConfigModel.currentConfig.currency isEqualToString:@"VND"]) {
            self.defaultGold = 1000;
        } else {
            self.defaultGold = 1;
        }
        self.defaultAdds = @"960";
    }
    else  if ([code isEqualToString:@"3GTEBIE"]) {//3更特别
        if ([UGSystemConfigModel.currentConfig.currency isEqualToString:@"VND"]) {
            self.defaultGold = 1000;
        } else {
            self.defaultGold = 1;
        }
        self.defaultAdds = @"960";
    }
    else  if ([code isEqualToString:@"3WBDJT"]) {//3尾巴
        if ([UGSystemConfigModel.currentConfig.currency isEqualToString:@"VND"]) {
            self.defaultGold = 2000;
        } else {
            self.defaultGold = 2;
        }
        self.defaultAdds = @"960";
    }
    else  if ([code isEqualToString:@"4GTEBIE"]) {//4更特别
        if ([UGSystemConfigModel.currentConfig.currency isEqualToString:@"VND"]) {
            self.defaultGold = 1000;
        } else {
            self.defaultGold = 1;
        }
        self.defaultAdds = @"8880";
    }
    else  if ([code isEqualToString:@"CHUANSHAO4"]) {//串烧4
        if ([UGSystemConfigModel.currentConfig.currency isEqualToString:@"VND"]) {
            self.defaultGold = 1000;
        } else {
            self.defaultGold = 1;
        }
        self.defaultAdds = @"1.8";
    }
    else  if ([code isEqualToString:@"CHUANSHAO8"]) {//串烧8
        if ([UGSystemConfigModel.currentConfig.currency isEqualToString:@"VND"]) {
            self.defaultGold = 1000;
        } else {
            self.defaultGold = 1;
        }
        self.defaultAdds = @"3.3";
    }
    else  if ([code isEqualToString:@"CHUANSHAO10"]) {//串烧10
        if ([UGSystemConfigModel.currentConfig.currency isEqualToString:@"VND"]) {
            self.defaultGold = 1000;
        } else {
            self.defaultGold = 1;
        }
        self.defaultAdds = @"4.3";
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // UI更新代码
        [self setOuntoddsLabelLable ];
    });
    
}


@end

