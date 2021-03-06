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
#import "YNHLPrizeDetailView.h"


@interface UGYNLotteryController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,WSLWaterFlowLayoutDelegate,UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *currentIssueLabel;/**<头 上 当前开奖  */
@property (weak, nonatomic) IBOutlet UIButton *historyBtn;/**<头 上 历史记录按钮  */
@property (weak, nonatomic) IBOutlet UILabel *nextIssueLabel;/**<头 下 下期开奖  */
@property (weak, nonatomic) IBOutlet UILabel *closeTimeLabel;/**<头 下 封盘时间  */
@property (weak, nonatomic) IBOutlet UILabel *openTimeLabel;/**<头 下 开奖时间  */

@property (weak, nonatomic) IBOutlet UITextField *amountTextF;/**<底部  下注倍数 */
@property (weak, nonatomic) IBOutlet UILabel *selectLabel;/**<底部  已选中  */
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;/**<底部  金额越南盾  */
@property (weak, nonatomic) IBOutlet UILabel *oddsLabel;/**<底部  赔率  */
@property (weak, nonatomic) IBOutlet UIButton *chipButton;/**<底部  筹码  */
@property (weak, nonatomic) IBOutlet UIButton *betButton; /**<底部  下注  */
@property (weak, nonatomic) IBOutlet UIButton *resetButton;/**<底部  重置  */

@property (weak, nonatomic) IBOutlet UIView *bottomView;                  /**<   底部 */
@property (weak, nonatomic) IBOutlet UIView *bottomCloseView;            /**<底部  封盘  */

@property (weak, nonatomic) IBOutlet UIView *headerOneView;/**<头 上*/
@property (weak, nonatomic) IBOutlet UIView *headerMidView;/**<头 中*/
@property (weak, nonatomic) IBOutlet UIView *nextIssueView;/**<头 下*/
@property (weak, nonatomic) IBOutlet UIView *contentView;  /**<内容*/

@property (weak, nonatomic) IBOutlet UIView *iphoneXBottomView;             /**<iphoneX的t底部*/

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
@property (nonatomic, strong) NSMutableArray <NSString *> *lmgmentOddsArray; /**<   segment 的标题 offlineOdds 赔率*/
@property (nonatomic, strong) NSMutableArray *selArray ;                            /**<  选中的 */
//===============================================
@property (nonatomic, strong) YNSegmentView *ynsegmentView;                           /**<   分栏segment*/
@property (strong, nonatomic)  UIView *yncontentView; /**<   分栏segment下面的内容界面*/
@property (nonatomic, strong) UICollectionView *betCollectionView;/**<   分栏segment下面的选择号码界面*/
@property (strong, nonatomic)  YNInputView *inputView;/**<   分栏segment下面的输入界面*/
@property (strong, nonatomic)  YNQuickSelectView *qsView;/**<   分栏segment下面的快速选择界面*/
@property (nonatomic, strong) NSString *ynSelectStr;                           /**<   分栏segment选中的*/
//===============================================
@property (nonatomic, assign) int  defaultGold;  //默认金额 18000.0
@property (nonatomic, strong) NSString *  defaultAdds;  //默认赔率。
@property (nonatomic, assign) int  amount;//总金额。
//===============================================输入号码
@property (nonatomic, strong) NSString *  inputStr;  //输入字符。
@property (nonatomic, strong) NSMutableArray  * mintArray;//输入字符 数组
@property (nonatomic, assign) int  px2count;//偏斜2总注数。
@property (nonatomic, assign) int  px3count;//偏斜3总注数。
@property (nonatomic, assign) int  px4count;//偏斜4总注数。

@property (nonatomic, assign) int  count;//总注数

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.countDown destoryTimer];
    [self.nextIssueCountDown destoryTimer];
}



#pragma mark - UI初始化方法
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
//分段标题
- (UGSegmentView *)segmentView {
    if (_segmentView == nil) {
        _segmentView = [[UGSegmentView alloc] initWithFrame:CGRectMake(0, 0, UGScreenW /4 * 3, 50) titleArray:self.lmgmentTitleArray];
        _segmentView.hidden = NO;
  
    }
    return _segmentView;
    
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
        
        collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(105 , 5, UGScreenW - 120 , 66) collectionViewLayout:layout];
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
    _inputView.inputTextView.delegate = self;
    
}
-(void)qsViewInit{
    _qsView = [[YNQuickSelectView alloc] initWithFrame:CGRectZero];
    [self.yncontentView addSubview:_qsView];
    
    [_qsView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.yncontentView);
    }];
    
    WeakSelf;
    self.qsView.ynCollectIndexBlock = ^(UICollectionView *collectionView,NSIndexPath* indexPath,NSInteger selectedSegmentIndex) {
        
        if (weakSelf.bottomCloseView.hidden == NO) {
            [SVProgressHUD showInfoWithStatus:@"封盘中"];
            return;
        }
        UGGameBetModel *bet = weakSelf.qsView.bet;

        [weakSelf ynFastCalculate:bet];
   
    };
    
}
-(void)initViews{
    [self tableViewInit];
    [self headertableViewInit];
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
    
}


#pragma mark - 数据初始化方法
- (NSMutableArray<UGGameplayModel *> *)gameDataArray {
    if (_gameDataArray == nil) {
        _gameDataArray = [NSMutableArray array];
        
    }
    return _gameDataArray;
}
//快速选择数据加载
-(void)qsViewSetReloadData{
    UGGameplayModel *model = [self.gameDataArray objectAtIndex:self.typeIndexPath.row];
    UGGameplaySectionModel *group = [model.list objectAtIndex:0];
    self.qsView.segmentedControl.selectedSegmentIndex = 0;
    self.qsView.selectedSegmentIndex = 0;
    if (group.list.count) {
        UGGameBetModel *bet = [group.list objectAtIndex:self.segmentIndex];
      
        NSString * code =  [self.lmgmentCodeArray objectAtIndex:self.segmentIndex];
        
        NSLog(@"code = %@",code);
        if ([code isEqualToString: @"PIANXIE2"]) {
            self.qsView.seleced = YES;
            self.qsView.selecedCount = 2;
        }
        else if([code isEqualToString: @"PIANXIE3"]) {
            self.qsView.seleced = YES;
            self.qsView.selecedCount = 3;
        }
        else if([code isEqualToString: @"PIANXIE4"] ||[code isEqualToString: @"CHUANSHAO4"] ) {
            self.qsView.seleced = YES;
            self.qsView.selecedCount = 4;
        }
        else if([code isEqualToString: @"CHUANSHAO8"]) {
            self.qsView.seleced = YES;
            self.qsView.selecedCount = 8;
        }
        else if([code isEqualToString: @"CHUANSHAO10"]) {
            self.qsView.seleced = YES;
            self.qsView.selecedCount = 10;
        }
        
        else {
            self.qsView.seleced = NO;
            self.qsView.selecedCount = 100000;
        }
        
        self.qsView.bet = bet;
    }
}
-(UIColor *)getYNSegmentViewColor:(BOOL)selected{
    UIColor *returnColor;
    {
        UIColor *selectedColor = [UIColor colorWithRed:52.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
        returnColor = selected ? selectedColor : [UIColor blackColor];
    }
    
    return  returnColor;
}
-(void)viewStyle{
    self.chipButton.layer.cornerRadius = 5;
    self.chipButton.layer.masksToBounds = YES;
    self.betButton.layer.cornerRadius = 5;
    self.resetButton.layer.cornerRadius = 5;
    self.resetButton.layer.masksToBounds = YES;
    self.amountTextF.delegate = self;
    self.amountTextF.keyboardType = UIKeyboardTypeNumberPad;
    [self.amountTextF addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    self.bottomCloseView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.bottomCloseView.hidden = YES;
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    self.chipArray = @[@"10",@"100",@"1000",@"10000",@"清除"];
    
#pragma mark -设置颜色
    [self.ynsegmentView setBackgroundColor:[UIColor clearColor]];
    if (APP.betBgIsWhite && !Skin1.isGPK && !Skin1.isBlack && !Skin1.is23) {
        self.rightStackView.backgroundColor =  [UIColor whiteColor];
        _segmentView.backgroundColor =  [UIColor whiteColor];
        self.betCollectionView.backgroundColor = [UIColor whiteColor];
        self.qsView.contentView.backgroundColor = [UIColor whiteColor];
    } else {
        if (APP.isLight) {
            _segmentView.backgroundColor = [Skin1.skitString containsString:@"六合"] ? [Skin1.navBarBgColor colorWithAlphaComponent:0.8] :[Skin1.bgColor colorWithAlphaComponent:0.8];
            self.rightStackView.backgroundColor = [Skin1.skitString containsString:@"六合"] ? [Skin1.navBarBgColor colorWithAlphaComponent:0.8] :[Skin1.bgColor colorWithAlphaComponent:0.8];
            self.betCollectionView.backgroundColor = [Skin1.skitString containsString:@"六合"] ? Skin1.navBarBgColor :Skin1.bgColor;
            self.qsView.contentView.backgroundColor =  [Skin1.skitString containsString:@"六合"] ? Skin1.navBarBgColor :Skin1.bgColor;
            
        }
        else{
            _segmentView.backgroundColor = [Skin1.skitString containsString:@"六合"] ? Skin1.navBarBgColor : Skin1.bgColor;
            self.rightStackView.backgroundColor = [Skin1.skitString containsString:@"六合"] ? Skin1.navBarBgColor : Skin1.bgColor;
            self.betCollectionView.backgroundColor = [Skin1.skitString containsString:@"六合"] ? Skin1.navBarBgColor : Skin1.bgColor;
            self.qsView.contentView.backgroundColor = [Skin1.skitString containsString:@"六合"] ? Skin1.navBarBgColor : Skin1.bgColor;
        }
    }
}
-(void)initMRDate{
#pragma mark - 进入时默认
    [self viewStyle];
    self.px2count = 0;
    self.px3count = 0;
    self.px4count = 0;

    self.inputView.code = Tip_十;
    [self  setDefaultData:@"PIHAO2"];
    [self  setDefaultOddsData:@"98"];
    [[Global getInstanse] setSelCode:@"PIHAO2"];
    self.segmentIndex = 0;
    //选择号码放到最前面
    [self.yncontentView bringSubviewToFront:self.betCollectionView];
    self.ynSelectStr = @"选择号码";

    
    self.lmgmentTitleArray = [NSMutableArray new];
    self.lmgmentCodeArray = [NSMutableArray new];
    self.lmgmentOddsArray = [NSMutableArray new];
    self.selArray = [NSMutableArray new];
    
    
    self.typeIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    self.itemIndexPath = nil;
    

    [self setLabelDataCount :0];
    [self setupBarButtonItems];

    [self updateCloseLabel];
    [self updateOpenLabel];
    
    self.countDown = [[CountDown alloc] init];
    self.nextIssueCountDown = [[CountDown alloc] init];
    
    [self updateHeaderViewData];
    [self updateCloseLabel];
    [self updateOpenLabel];
}

#pragma mark - 网络数据
-(void)loadWBDate{
    [self getGameDatas];
    [self getNextIssueData];
    [self getUserInfo];
}
- (void)getUserInfo {
    if (!UGLoginIsAuthorized()) {
        return;
    }
    WeakSelf;
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid};
    [CMNetwork getUserInfoWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        
        [CMResult processWithResult:model success:^{
            UGUserModel *user = model.data;
            UGUserModel *oldUser = [UGUserModel currentUser];
            user.sessid = oldUser.sessid;
            user.token = oldUser.token;
            UGUserModel.currentUser = user;
            
            STButton *button = (STButton *)self.rightItem1.customView;
            [button.imageView.layer removeAllAnimations];
            
            [weakSelf setupBarButtonItems];
          
        } failure:^(id msg) {

        }];
    }];
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
    WeakSelf;
    [SVProgressHUD showWithStatus:nil];

    [CMNetwork getGameDatasWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            if ([CMCommon stringIsNull:model.data]) {
                [SVProgressHUD showErrorWithStatus:model.msg];
               
                return;
                
            }
            
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
                    for (int i = 0; i <type.list.count; i++) {
                        NSDictionary *dic = [type.list objectAtIndex:i];
                        UGGameBetModel *obj = [[UGGameBetModel alloc] mj_setKeyValues:dic];
                        [weakSelf.lmgmentTitleArray addObject:obj.name];
                        [weakSelf.lmgmentCodeArray addObject:obj.code];
                        [weakSelf.lmgmentOddsArray addObject:obj.odds];
                        
                        if (i == 0) {
                            [weakSelf setDefaultOddsData:obj.odds];
                            [weakSelf  setDefaultData:obj.code];
                        }
                    }
                }
            }
            [weakSelf handleData];
            [SVProgressHUD dismiss];
        
            weakSelf.segmentView.dataArray = self.lmgmentTitleArray;
            [weakSelf.tableView reloadData];
            [weakSelf.betCollectionView reloadData];
            [weakSelf qsViewSetReloadData ];
            [weakSelf.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
           
            
            
        } failure:^(id msg) {
 
            [SVProgressHUD dismiss];
        }];
    }];
}

#pragma mark - 事件
#pragma mark - 2级选择栏点击事件
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    
    NSString * title = [segmentedControl.sectionTitles objectAtIndex:segmentedControl.selectedSegmentIndex];
    
    if ([title isEqualToString:@"选择号码"]) {
        [self.yncontentView bringSubviewToFront:self.betCollectionView];
        self.ynSelectStr = @"选择号码";
    }
    else if([title isEqualToString:@"输入号码"]){
        
        [self.yncontentView bringSubviewToFront:self.inputView];
        self.ynSelectStr = @"输入号码";
    }
    else if([title isEqualToString:@"快速选择"]){
        
        [self.yncontentView bringSubviewToFront:self.qsView];
        self.ynSelectStr = @"快速选择";
        //得到选中行，选中的segment。 self.segmentIndex self.typeIndexPath
        [self qsViewSetReloadData];
    }
    [self resetClick:nil];
}
#pragma mark - 介绍点击
-(void)ynButtonClocked:(UIButton *)sender{
    UGGameplayModel *model = [self.gameDataArray objectAtIndex:self.typeIndexPath.row];
    UGGameplaySectionModel *group = [model.list objectAtIndex:0];
    if (group.list.count) {
        UGGameBetModel *bet = [group.list objectAtIndex:self.segmentIndex];
        
        if (bet.rule.length) {
            [CMCommon showTitle:bet.rule];
        }
        
    }
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
    SANotificationEventPost(UGNotificationGetUserInfo, nil);
    
}


//重置
- (IBAction)resetClick:(id)sender {
    
    
    {
        //选择号码
        for (UGGameplayModel *model in self.gameDataArray) {
            model.selectedCount = 0;
            UGGameplaySectionModel *group = [model.list objectAtIndex:0];
            for (UGGameBetModel *bet in group.list) {
                for (UGGameplaySectionModel *type2 in bet.ynList) {
                    for (UGGameBetModel *game in type2.list) {
                        game.select = NO;
                    }
                }
            }
            
        }
        [self.selArray removeAllObjects];//选择号码
    }
    
    {
        //输入号码
        self.px2count = 0;
        self.px3count = 0;
        self.px4count = 0;

        
    }
    {
        //快速选择
        for (UGGameplayModel *model in self.gameDataArray) {
            model.selectedCount = 0;
            UGGameplaySectionModel *group = [model.list objectAtIndex:0];
            for (UGGameBetModel *bet in group.list) {
                for (UGGameplaySectionModel *type2 in bet.ynFastList) {
                    for (UGGameBetModel *game in type2.list) {
                        game.select = NO;
                    }
                }
            }
            
        }
        
        UGGameBetModel *fbet = self.qsView.bet;
        
        for (UGGameplaySectionModel *type2 in fbet.ynFastList) {
            for (UGGameBetModel *game in type2.list) {
                game.select = NO;
            }
        }
        
        
        [_qsView.listView.selecedDataArry removeAllObjects];
        [Global getInstanse].hasBgColor = NO;
        
    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // UI更新代码
        [self.inputView.inputTextView setText:@""];
        [self.amountTextF resignFirstResponder];
        [self setLabelDataCount :0];
        self.amountTextF.text = nil;
        [self.qsView reload];
        [self.betCollectionView reloadData];
        [self.tableView reloadData];
        [self.tableView selectRowAtIndexPath:self.typeIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    });
    
    
}

- (IBAction)betClick:(id)sender {
    WeakSelf;
    [self.amountTextF resignFirstResponder];
    
    if (self.count  == 0) {
        [SVProgressHUD showInfoWithStatus:@"请选择玩法"];
        return;
    }
   
        NSString *selCode = @"";
        NSString *selName = @"";
        NSMutableArray *array = [NSMutableArray array];
        UGGameplayModel *model = weakSelf.gameDataArray[self.typeIndexPath.row];
        UGGameplaySectionModel *group = [model.list objectAtIndex:0];
        selCode = model.code;
        UGGameBetModel *bet ;
        BOOL isHide = NO;
        if (group.list.count) {
            
            bet = [group.list objectAtIndex:self.segmentIndex];
            
            
            if ([self.ynSelectStr isEqualToString: @"选择号码"]) {
                //   十
                if ([bet.code isEqualToString:@"TOU"]||[bet.code isEqualToString:@"WEI"]) {
                    
                    [weakSelf yzdwBetActionMode:bet  array:&array] ;
                }// 十 个
                else  if ([bet.code isEqualToString:@"PIHAO2"]||[bet.code isEqualToString:@"DIDUAN2"]
                          ||[bet.code isEqualToString:@"BIAOTI"]||[bet.code isEqualToString:@"ZHUANTI"]
                          ||[bet.code isEqualToString:@"TEBIEBIAOTI"]
                          ||[bet.code isEqualToString:@"BIAOTIWB"]||[bet.code isEqualToString:@"LOT2FIRST"]
                          ||[bet.code isEqualToString:@"ZHUZHANG7"]||[bet.code isEqualToString:@"YIDENGJIANG"]) {
                    
                    [weakSelf ezdwBetActionMode:bet  array:&array] ;
                }//  百 十 个
                else   if ([bet.code isEqualToString:@"PIHAO3"]||[bet.code isEqualToString:@"3YINJIE"]
                           ||[bet.code isEqualToString:@"3GTEBIE"]||[bet.code isEqualToString:@"3WBDJT"]) {
                    
                    [weakSelf szdwBetActionMode:bet  array:&array] ;
                }//千 百 十 个
                else  if ([bet.code isEqualToString:@"PIHAO4"]||[bet.code isEqualToString:@"4GTEBIE"]) {
                    [weakSelf qzdwBetActionMode:bet  array:&array] ;
                }
                
                isHide = NO;
            }
            else  if ([self.ynSelectStr isEqualToString: @"快速选择"]) {
                //批号2 地段21K号 标题 专题 标题尾巴   // 加 00-99
                if ([bet.code isEqualToString:@"PIHAO2"]||[bet.code isEqualToString:@"DIDUAN2"]
                    ||[bet.code isEqualToString:@"BIAOTI"]||[bet.code isEqualToString:@"ZHUANTI"]
                    ||[bet.code isEqualToString:@"TEBIEBIAOTI"]
                    ||[bet.code isEqualToString:@"BIAOTIWB"]
                    ||[bet.code isEqualToString:@"LOT2FIRST"]
                    ||[bet.code isEqualToString:@"ZHUZHANG7"]||[bet.code isEqualToString:@"YIDENGJIANG"]) {
                    
                    
                    
                    [weakSelf fastezdwBetActionMode:bet  array:&array] ;
                } //批号3 3个音阶 3更特别 3尾巴的尽头 // 加 000-999
                else  if ([bet.code isEqualToString:@"PIHAO3"]||[bet.code isEqualToString:@"3YINJIE"]
                          ||[bet.code isEqualToString:@"3GTEBIE"]||[bet.code isEqualToString:@"3WBDJT"]) {
                    
                    [weakSelf fastszdwBetActionMode:bet  array:&array] ;
                }
                else  if ([bet.code isEqualToString:@"PIANXIE2"]) {
                    [weakSelf specialFastezdwBetActionMode:bet array:&array count:2];
                }
                else  if ([bet.code isEqualToString:@"PIANXIE3"]) {
                    [weakSelf specialFastezdwBetActionMode:bet array:&array count:3];
                }
                else  if ([bet.code isEqualToString:@"PIANXIE4"]||[bet.code isEqualToString:@"CHUANSHAO4"]) {
                    [weakSelf specialFastezdwBetActionMode:bet array:&array count:4];
                }
                else  if ([bet.code isEqualToString:@"CHUANSHAO8"]) {
                     [weakSelf specialFastezdwBetActionMode:bet array:&array count:8];
                }
                else  if ([bet.code isEqualToString:@"CHUANSHAO10"]) {
                     [weakSelf specialFastezdwBetActionMode:bet array:&array count:10];
                }
                
                isHide = YES;
            }
            else  if ([self.ynSelectStr isEqualToString: @"输入号码"]) {
                
                [weakSelf judgeInputBetDateArray:&array];
                
                 isHide = YES;
            }
            if ([bet.code isEqualToString:@"TOU"]||[bet.code isEqualToString:@"WEI"]) {
                isHide = YES;
            }// 十 个

        }

        weakSelf.nextIssueModel.defaultAdds = weakSelf.defaultAdds;
        weakSelf.nextIssueModel.multipleStr = [weakSelf getMultipleStr];
        weakSelf.nextIssueModel.totalAmountStr = [NSString stringWithFormat:@"%d",weakSelf.amount];
        weakSelf.nextIssueModel.defname = bet.name;
        
        NSMutableArray *dicArray = [UGGameBetModel mj_keyValuesArrayWithObjectArray:array];
        [weakSelf goYNBetDetailViewObjArray:array.copy dicArray:dicArray.copy issueModel:weakSelf.nextIssueModel  gameType:weakSelf.nextIssueModel.gameId selCode:selCode isHide:isHide ];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadWBDate];
    [self initViews];
    [self initMRDate];
    
    [self.bottomView setBackgroundColor:Skin1.bgColor];
    [self.bottomView insertSubview:({
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP.Width, 200)];
        bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        bgView;
    }) atIndex:0];
#pragma mark - 1级选择栏点击事件
    WeakSelf;
    self.segmentView.segmentIndexBlock = ^(NSInteger row) {
        weakSelf.segmentIndex = row;
        NSString * code =  [weakSelf.lmgmentCodeArray objectAtIndex:row];
        
        if ([code isEqualToString:@"PIHAO2"]||[code isEqualToString:@"DIDUAN2"]
            ||[code isEqualToString:@"PIHAO3"]||[code isEqualToString:@"BIAOTI"]
            ||[code isEqualToString:@"ZHUANTI"] ||[code isEqualToString:@"TEBIEBIAOTI"]
            ||[code isEqualToString:@"BIAOTIWB"]
            ||[code isEqualToString:@"3YINJIE"]||[code isEqualToString:@"3GTEBIE"]
            ||[code isEqualToString:@"3WBDJT"]||[code isEqualToString:@"LOT2FIRST"]
            ||[code isEqualToString:@"ZHUZHANG7"]||[code isEqualToString:@"YIDENGJIANG"]) {
            //批号2 地段2 1K 批号3 标题 专题 标题尾巴 3个音阶 3更特别 3尾巴的尽头  Lot2第一个号码  主张7  一等奖
            weakSelf.ynsegmentView.hidden = NO;
            [weakSelf.ynsegmentView.segment setSectionTitles:@[@"选择号码",@"输入号码",@"快速选择"]];
            [self qsViewSetReloadData ];
        }
        else if ([code isEqualToString:@"PIHAO4"]||[code isEqualToString:@"4GTEBIE"]){
            //批号4 4更特别
            weakSelf.ynsegmentView.hidden = NO;
            [weakSelf.ynsegmentView.segment setSectionTitles:@[@"选择号码",@"输入号码"]];
            //批号4   当2级选择选中第3个时，这时候2级没有3个，必须强行处理下
            [weakSelf.yncontentView bringSubviewToFront:weakSelf.betCollectionView];
            [self.ynsegmentView.segment setSelectedSegmentIndex:0];
            
        }
        else if ([code isEqualToString:@"PIANXIE2"]||[code isEqualToString:@"PIANXIE3"]
                 ||[code isEqualToString:@"PIANXIE4"]||[code isEqualToString:@"CHUANSHAO4"]
                 ||[code isEqualToString:@"CHUANSHAO8"]||[code isEqualToString:@"CHUANSHAO10"]){
            //偏斜2 偏斜3 偏斜4 串烧4 串烧8 串烧10
            weakSelf.ynsegmentView.hidden = NO;
            [weakSelf.ynsegmentView.segment setSectionTitles:@[@"输入号码",@"快速选择"]];
            [self qsViewSetReloadData ];
            
        }
        else if ([code isEqualToString:@"TOU"]||[code isEqualToString:@"WEI"]){
            //头 尾
            weakSelf.ynsegmentView.hidden = YES;
        }
        
        [weakSelf handleTipStrForCode:code];
        [weakSelf resetClick:nil];
        [weakSelf setDefaultData:code];
        
        UGGameplayModel *model = self.gameDataArray[self.typeIndexPath.row];
        UGGameplaySectionModel *obj = model.list[0];
        
        UGGameBetModel *betModel = obj.list[self.segmentIndex];
        NSString * odds =  betModel.odds;
        NSLog(@"code = %@",betModel.code);
        [[Global getInstanse] setSelCode:betModel.code];
        [weakSelf setDefaultOddsData:odds];
    };
    
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




#pragma mark - 选择下注方法
//个下注方法
-(void)yzdwBetActionMode:(UGGameBetModel *)bet   array :(NSMutableArray *__strong *) array {
    
    if (bet.ynList.count) {
        NSMutableArray *mutArr1 = [NSMutableArray array];
        
        UGGameplaySectionModel *model1 = bet.ynList[0];
        for (UGGameBetModel *bet in model1.list) {
            if (bet.select) {
                [mutArr1 addObject:bet];
            }
        }
        
        if (mutArr1.count == 0 ) {
            [SVProgressHUD showInfoWithStatus:@"下注内容不正确，请重新下注"];
            return;
        }
        NSMutableString *nameStr = [[NSMutableString alloc] initWithString:@"【"];
        for (int i = 0; i < mutArr1.count; i++) {
            
            
            UGGameBetModel *beti = mutArr1[i];
            UGGameBetModel *bet = [[UGGameBetModel alloc] init];
            [bet setValuesForKeysWithDictionary:beti.mj_keyValues];
            NSMutableString *name = [[NSMutableString alloc] init];
            [name appendString:beti.name];
            bet.name = name;
            bet.title = bet.alias;
            bet.betInfo = name;
            bet.money = [NSString stringWithFormat:@"%d",[self setDefaultGoldDataForCode:bet.code]] ;
            [*array addObject:bet];
            
            [nameStr appendString:bet.name];
            if (i< mutArr1.count-1) {
                [nameStr appendString:@","];
            } else {
                [nameStr appendString:@"】"];
            }
            
        }
        
        self.nextIssueModel.defnameStr = nameStr;
        
    }
    
}
//十 个下注方法
-(void)ezdwBetActionMode:(UGGameBetModel *)bet   array :(NSMutableArray *__strong *) array {
    
    if (bet.ynList.count) {
        NSMutableArray *mutArr1 = [NSMutableArray array];
        NSMutableArray *mutArr2 = [NSMutableArray array];
        
        UGGameplaySectionModel *model1 = bet.ynList[0];
        for (UGGameBetModel *bet in model1.list) {
            if (bet.select) {
                [mutArr1 addObject:bet];
            }
        }
        UGGameplaySectionModel *model2 = bet.ynList[1];
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
                [name appendString:@"|"];
                [name appendString:bety.name];
                
                bet.name = name;
                bet.title = bet.alias;
                bet.betInfo = name;
                bet.money = [NSString stringWithFormat:@"%d",[self setDefaultGoldDataForCode:bet.code]] ;
                [*array addObject:bet];
                
            }
        }
        
        NSMutableString *nameStr = [[NSMutableString alloc] initWithString:@"【"];
        for (int i = 0; i < mutArr1.count; i++) {
            
            UGGameBetModel *beti = mutArr1[i];
            [nameStr appendString:beti.name];
            
            if (i< mutArr1.count-1) {
                [nameStr appendString:@","];
            } else {
                [nameStr appendString:@"|"];
            }
        }
        for (int i = 0; i < mutArr2.count; i++) {
            
            UGGameBetModel *beti = mutArr2[i];
            [nameStr appendString:beti.name];
            
            if (i< mutArr2.count-1) {
                [nameStr appendString:@","];
            } else {
                [nameStr appendString:@"】"];
            }
        }
        
        self.nextIssueModel.defnameStr = nameStr;
    }
    
}
//百 十 个下注方法
-(void)szdwBetActionMode:(UGGameBetModel *)bet   array :(NSMutableArray *__strong *) array {
    
    if (bet.ynList.count) {
        NSMutableArray *mutArr1 = [NSMutableArray array];
        NSMutableArray *mutArr2 = [NSMutableArray array];
        NSMutableArray *mutArr3 = [NSMutableArray array];
        
        UGGameplaySectionModel *model1 = bet.ynList[0];
        for (UGGameBetModel *bet in model1.list) {
            if (bet.select) {
                [mutArr1 addObject:bet];
            }
        }
        UGGameplaySectionModel *model2 = bet.ynList[1];
        for (UGGameBetModel *bet in model2.list) {
            if (bet.select) {
                [mutArr2 addObject:bet];
            }
        }
        UGGameplaySectionModel *model3 = bet.ynList[2];
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
                    [name appendString:@"|"];
                    [name appendString:bety.name];
                    [name appendString:@"|"];
                    [name appendString:betz.name];
                    bet.name = name;
                    bet.title = bet.alias;
                    bet.betInfo = name;
                    bet.money = [NSString stringWithFormat:@"%d",[self setDefaultGoldDataForCode:bet.code]] ;
                    [*array addObject:bet];
                }
                
            }
        }
        
        NSMutableString *nameStr = [[NSMutableString alloc] initWithString:@"【"];
        for (int i = 0; i < mutArr1.count; i++) {
            
            UGGameBetModel *beti = mutArr1[i];
            [nameStr appendString:beti.name];
            
            if (i< mutArr1.count-1) {
                [nameStr appendString:@","];
            } else {
                [nameStr appendString:@"|"];
            }
        }
        for (int i = 0; i < mutArr2.count; i++) {
            
            UGGameBetModel *beti = mutArr2[i];
            [nameStr appendString:beti.name];
            
            if (i< mutArr2.count-1) {
                [nameStr appendString:@","];
            } else {
                [nameStr appendString:@"|"];
            }
        }
        for (int i = 0; i < mutArr3.count; i++) {
            
            UGGameBetModel *beti = mutArr3[i];
            [nameStr appendString:beti.name];
            
            if (i< mutArr3.count-1) {
                [nameStr appendString:@","];
            } else {
                [nameStr appendString:@"】"];
            }
        }
        
        self.nextIssueModel.defnameStr = nameStr;
        
        
    }
    
}
//千  百 十 个下注方法
-(void)qzdwBetActionMode:(UGGameBetModel *)bet   array :(NSMutableArray *__strong *) array {
    
    if (bet.ynList.count) {
        NSMutableArray *mutArr1 = [NSMutableArray array];
        NSMutableArray *mutArr2 = [NSMutableArray array];
        NSMutableArray *mutArr3 = [NSMutableArray array];
        NSMutableArray *mutArr4 = [NSMutableArray array];
        
        UGGameplaySectionModel *model1 = bet.ynList[0];
        for (UGGameBetModel *bet in model1.list) {
            if (bet.select) {
                [mutArr1 addObject:bet];
            }
        }
        UGGameplaySectionModel *model2 = bet.ynList[1];
        for (UGGameBetModel *bet in model2.list) {
            if (bet.select) {
                [mutArr2 addObject:bet];
            }
        }
        UGGameplaySectionModel *model3 = bet.ynList[2];
        for (UGGameBetModel *bet in model3.list) {
            if (bet.select) {
                [mutArr3 addObject:bet];
            }
        }
        
        UGGameplaySectionModel *model4 = bet.ynList[3];
        for (UGGameBetModel *bet in model4.list) {
            if (bet.select) {
                [mutArr4 addObject:bet];
            }
        }
        if (mutArr1.count == 0 || mutArr2.count == 0|| mutArr3.count == 0|| mutArr4.count == 0) {
            [SVProgressHUD showInfoWithStatus:@"下注内容不正确，请重新下注"];
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
                        [name appendString:@"|"];
                        [name appendString:bety.name];
                        [name appendString:@"|"];
                        [name appendString:betz.name];
                        [name appendString:@"|"];
                        [name appendString:betk.name];
                        bet.name = name;
                        bet.title = bet.alias;
                        bet.betInfo = name;
                        bet.money = [NSString stringWithFormat:@"%d",[self setDefaultGoldDataForCode:bet.code]] ;
                        [*array addObject:bet];
                    }
                }
                
            }
        }
        
        NSMutableString *nameStr = [[NSMutableString alloc] initWithString:@"【"];
        for (int i = 0; i < mutArr1.count; i++) {
            
            UGGameBetModel *beti = mutArr1[i];
            [nameStr appendString:beti.name];
            
            if (i< mutArr1.count-1) {
                [nameStr appendString:@","];
            } else {
                [nameStr appendString:@"|"];
            }
        }
        for (int i = 0; i < mutArr2.count; i++) {
            
            UGGameBetModel *beti = mutArr2[i];
            [nameStr appendString:beti.name];
            
            if (i< mutArr2.count-1) {
                [nameStr appendString:@","];
            } else {
                [nameStr appendString:@"|"];
            }
        }
        for (int i = 0; i < mutArr3.count; i++) {
            
            UGGameBetModel *beti = mutArr3[i];
            [nameStr appendString:beti.name];
            
            if (i< mutArr3.count-1) {
                [nameStr appendString:@","];
            } else {
                [nameStr appendString:@"|"];
            }
        }
        for (int i = 0; i < mutArr4.count; i++) {
            
            UGGameBetModel *beti = mutArr4[i];
            [nameStr appendString:beti.name];
            
            if (i< mutArr4.count-1) {
                [nameStr appendString:@","];
            } else {
                [nameStr appendString:@"】"];
            }
        }
        
        self.nextIssueModel.defnameStr = nameStr;
        
    }
    
}

-(void)calculate:(UGGameBetModel *)bet{
    
    
    //        计算选中的注数
    NSInteger count = 0;
    
    //批号2 地段21K号 标题 专题 标题尾巴  Lot2第一个号码  主张7 一等奖// 加 十 个
    if ([bet.code isEqualToString:@"PIHAO2"]||[bet.code isEqualToString:@"DIDUAN2"]
        ||[bet.code isEqualToString:@"BIAOTI"]||[bet.code isEqualToString:@"ZHUANTI"]
        ||[bet.code isEqualToString:@"TEBIEBIAOTI"]
        ||[bet.code isEqualToString:@"BIAOTIWB"]||[bet.code isEqualToString:@"LOT2FIRST"]
        ||[bet.code isEqualToString:@"ZHUZHANG7"]||[bet.code isEqualToString:@"YIDENGJIANG"]) {
        
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
        for (UGGameBetModel *bet in model1.list) {
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
            bet.betMultiple = [self getMultipleStr];
            bet.money = [NSString stringWithFormat:@"%d",[self setDefaultGoldDataForCode:bet.code]] ;
            NSLog(@"self.defaultGold = %d",self.defaultGold);
            NSLog(@"money = %@",bet.money);
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
        for (UGGameBetModel *bet in model1.list) {
            if (bet.select) {
                [mutArr1 addObject:bet];
            }
        }
        UGGameplaySectionModel *model2 = model.ynList[1];
        for (UGGameBetModel *bet in model2.list) {
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
                [name appendString:@"|"];
                [name appendString:bety.name];
                bet.name = name;
                bet.betInfo = name;
                bet.title = bet.alias;
                bet.betMultiple = [self getMultipleStr];
                bet.money = [NSString stringWithFormat:@"%d",[self setDefaultGoldDataForCode:bet.code]] ;
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
        for (UGGameBetModel *bet in model1.list) {
            if (bet.select) {
                [mutArr1 addObject:bet];
            }
        }
        UGGameplaySectionModel *model2 = model.ynList[1];
        for (UGGameBetModel *bet in model2.list) {
            if (bet.select) {
                [mutArr2 addObject:bet];
            }
        }
        UGGameplaySectionModel *model3 = model.ynList[2];
        for (UGGameBetModel *bet in model3.list) {
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
                    [name appendString:@"|"];
                    [name appendString:bety.name];
                    [name appendString:@"|"];
                    [name appendString:betz.name];
                    bet.name = name;
                    bet.title = bet.alias;
                    bet.betInfo = name;
                    bet.betMultiple = [self getMultipleStr];
                    bet.money = [NSString stringWithFormat:@"%d",[self setDefaultGoldDataForCode:bet.code]] ;
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
        for (UGGameBetModel *bet in model1.list) {
            if (bet.select) {
                [mutArr1 addObject:bet];
            }
        }
        UGGameplaySectionModel *model2 = model.ynList[1];
        for (UGGameBetModel *bet in model2.list) {
            if (bet.select) {
                [mutArr2 addObject:bet];
            }
        }
        UGGameplaySectionModel *model3 = model.ynList[2];
        for (UGGameBetModel *bet in model3.list) {
            if (bet.select) {
                [mutArr3 addObject:bet];
            }
        }
        
        UGGameplaySectionModel *model4 = model.ynList[3];
        for (UGGameBetModel *bet in model4.list) {
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
                        [name appendString:@"|"];
                        [name appendString:bety.name];
                        [name appendString:@"|"];
                        [name appendString:betz.name];
                        [name appendString:@"|"];
                        [name appendString:betk.name];
                        bet.name = name;
                        bet.title = bet.alias;
                        bet.betInfo = name;
                        bet.betMultiple = [self getMultipleStr];
                        bet.money = [NSString stringWithFormat:@"%d",[self setDefaultGoldDataForCode:bet.code]] ;
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

#pragma mark - 快速下注方法

-(void)ynFastCalculate:(UGGameBetModel *)bet{
    //        计算选中的注数
    NSInteger count = 0;
    
    //批号2 地段21K号 标题 专题 标题尾巴  串烧4 串烧8 串烧10// 加 00-99
    if ([bet.code isEqualToString:@"PIHAO2"]||[bet.code isEqualToString:@"DIDUAN2"]
        ||[bet.code isEqualToString:@"BIAOTI"]||[bet.code isEqualToString:@"ZHUANTI"]
        ||[bet.code isEqualToString:@"TEBIEBIAOTI"]
        ||[bet.code isEqualToString:@"BIAOTIWB"]
        ||[bet.code isEqualToString:@"LOT2FIRST"]
        ||[bet.code isEqualToString:@"ZHUZHANG7"]||[bet.code isEqualToString:@"YIDENGJIANG"]) {
        
        [self fastEzdwActionModel:bet count:count];
    }
    //批号3 3个音阶 3更特别 3尾巴的尽头 // 加 000-999
    else if ([bet.code isEqualToString:@"PIHAO3"]||[bet.code isEqualToString:@"3YINJIE"]
        ||[bet.code isEqualToString:@"3GTEBIE"]||[bet.code isEqualToString:@"3WBDJT"]) {
        
        [self fastSzdwActionModel:bet count:count];
    }
    else  if ([bet.code isEqualToString: @"PIANXIE2"]) {
        [self specialFastEzdwActionModel:bet number:2];
    }
    else if([bet.code isEqualToString: @"PIANXIE3"]) {
        [self specialFastEzdwActionModel:bet number:3];
    }
    else if([bet.code isEqualToString: @"PIANXIE4"] ||[bet.code isEqualToString: @"CHUANSHAO4"] ) {
        [self specialFastEzdwActionModel:bet number:4];
    }
    else if([bet.code isEqualToString: @"CHUANSHAO8"]) {
        [self specialFastEzdwActionModel:bet number:8];
    }
    else if([bet.code isEqualToString: @"CHUANSHAO10"]) {
        [self specialFastEzdwActionModel:bet number:10];
    }

}

//特殊玩法
-(void)specialFastEzdwActionModel:(UGGameBetModel *)model number:(NSInteger)number{

    if (model.ynFastList.count) {
        
        NSMutableArray *mutArr1 = [NSMutableArray array];
        
        UGGameplaySectionModel *model1 = model.ynFastList[0];
        for (UGGameBetModel *bet in model1.list) {
            if (bet.select) {
                [mutArr1 addObject:bet];
            }
        }
        
        if (mutArr1.count == 0 ) {
            [self  setLabelDataCount:0];
            return;
        }

        if (mutArr1.count != number ) {
     
            [self  setLabelDataCount:0];
            
        } else {
           
            [self  setLabelDataCount:1];
        }
    }
}

//二字定位 计算选中的注数  十个
-(void)fastEzdwActionModel:(UGGameBetModel *)model count:(NSInteger)count{
    
    NSMutableArray *array = [NSMutableArray array];
    
    if (model.ynFastList.count) {
        
        NSMutableArray *mutArr1 = [NSMutableArray array];
        
        UGGameplaySectionModel *model1 = model.ynFastList[0];
        for (UGGameBetModel *bet in model1.list) {
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
            bet.betInfo = bet.name;
            bet.title = bet.alias;
            bet.betMultiple = [self getMultipleStr];
            bet.money = [NSString stringWithFormat:@"%d",[self setDefaultGoldDataForCode:model.code]] ;
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

//三字定位 计算选中的注数 百十个
-(void)fastSzdwActionModel:(UGGameBetModel *)model count:(NSInteger)count{
    
    NSMutableArray *array = [NSMutableArray array];
    
    if (model.ynFastList.count) {
        
        NSMutableArray *mutArr1 = [NSMutableArray array];
        
        
        for (int i = 0; i< model.ynFastList.count; i++) {
            UGGameplaySectionModel *model1 = model.ynFastList[i];
            for (UGGameBetModel *bet in model1.list) {
                if (bet.select) {
                    [mutArr1 addObject:bet];
                }
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
            bet.betInfo = bet.name;
            bet.title = bet.alias;
            bet.betMultiple = [self getMultipleStr];
            bet.money = [NSString stringWithFormat:@"%d",[self setDefaultGoldDataForCode:model.code]] ;
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

#pragma mark - 快速选择下注方法
//特殊玩法下注方法
-(void)specialFastezdwBetActionMode:(UGGameBetModel *)bet   array :(NSMutableArray *__strong *) array  count:(int) mcount {
    
    if (bet.ynFastList.count) {
        NSMutableArray *mutArr1 = [NSMutableArray array];
        
        UGGameplaySectionModel *model1 = bet.ynFastList[0];
        for (UGGameBetModel *bet in model1.list) {
            if (bet.select) {
                [mutArr1 addObject:bet];
            }
        }
        
        if (mutArr1.count == 0 ) {
            [SVProgressHUD showInfoWithStatus:@"下注内容不正确，请重新下注"];
            return;
        }
        if (mutArr1.count != mcount ) {
            [SVProgressHUD showInfoWithStatus:@"下注内容不正确，请重新下注"];
            return;
        }

        UGGameBetModel *bet = [[UGGameBetModel alloc] init];
        UGGameBetModel *bet0 = mutArr1[0];
        [bet setValuesForKeysWithDictionary:bet0.mj_keyValues];
        bet.title = bet.alias;
        bet.money = [NSString stringWithFormat:@"%d",[self setDefaultGoldDataForCode:bet.code]] ;
        
        NSMutableString *nameStr = [[NSMutableString alloc] initWithString:@"【"];
        NSMutableString *name = [[NSMutableString alloc] init];
        
        for (int i = 0; i < mutArr1.count; i++) {
            UGGameBetModel *beti = mutArr1[i];
            [name appendString:beti.name];
            [nameStr appendString:beti.name];
            if (i< mutArr1.count-1) {
                [nameStr appendString:@";"];
                [name appendString:@","];
            } else {
                [nameStr appendString:@"】"];
            }
            
        }
        bet.name = name;
        bet.betInfo = name;
        [*array addObject:bet];
        
        self.nextIssueModel.defnameStr = nameStr;
        
    }
    
}

//2 位下注方法
-(void)fastezdwBetActionMode:(UGGameBetModel *)bet   array :(NSMutableArray *__strong *) array {
    
    if (bet.ynFastList.count) {
        NSMutableArray *mutArr1 = [NSMutableArray array];
        
        UGGameplaySectionModel *model1 = bet.ynFastList[0];
        for (UGGameBetModel *bet in model1.list) {
            if (bet.select) {
                [mutArr1 addObject:bet];
            }
        }
        
        if (mutArr1.count == 0 ) {
            [SVProgressHUD showInfoWithStatus:@"下注内容不正确，请重新下注"];
            return;
        }
        NSMutableString *nameStr = [[NSMutableString alloc] initWithString:@"【"];
        for (int i = 0; i < mutArr1.count; i++) {
            
            
            UGGameBetModel *beti = mutArr1[i];
            UGGameBetModel *bet = [[UGGameBetModel alloc] init];
            [bet setValuesForKeysWithDictionary:beti.mj_keyValues];
            NSMutableString *name = [[NSMutableString alloc] init];
            [name appendString:beti.name];
            bet.name = name;
            bet.title = bet.alias;
            bet.betInfo = name;
            bet.money = [NSString stringWithFormat:@"%d",[self setDefaultGoldDataForCode:bet.code]] ;
            [*array addObject:bet];
            
            [nameStr appendString:bet.name];
            if (i< mutArr1.count-1) {
                [nameStr appendString:@";"];
            } else {
                [nameStr appendString:@"】"];
            }
            
        }
        
        self.nextIssueModel.defnameStr = nameStr;
        
    }
    
}

//3 位下注方法
-(void)fastszdwBetActionMode:(UGGameBetModel *)bet   array :(NSMutableArray *__strong *) array {
    
    if (bet.ynFastList.count) {
        NSMutableArray *mutArr1 = [NSMutableArray array];
        
        
        for (int i = 0; i< bet.ynFastList.count; i++) {
            UGGameplaySectionModel *model1 = bet.ynFastList[i];
            for (UGGameBetModel *bet in model1.list) {
                if (bet.select) {
                    [mutArr1 addObject:bet];
                }
            }
        }
        
        if (mutArr1.count == 0 ) {
            [SVProgressHUD showInfoWithStatus:@"下注内容不正确，请重新下注"];
            return;
        }
        NSMutableString *nameStr = [[NSMutableString alloc] initWithString:@"【"];
        for (int i = 0; i < mutArr1.count; i++) {
            
            
            UGGameBetModel *beti = mutArr1[i];
            UGGameBetModel *bet = [[UGGameBetModel alloc] init];
            [bet setValuesForKeysWithDictionary:beti.mj_keyValues];
            NSMutableString *name = [[NSMutableString alloc] init];
            [name appendString:beti.name];
            bet.name = name;
            bet.title = bet.alias;
            bet.betInfo = name;
            bet.money = [NSString stringWithFormat:@"%d",[self setDefaultGoldDataForCode:bet.code]] ;
            [*array addObject:bet];
            
            [nameStr appendString:bet.name];
            if (i< mutArr1.count-1) {
                [nameStr appendString:@";"];
            } else {
                [nameStr appendString:@"】"];
            }
            
        }
        
        self.nextIssueModel.defnameStr = nameStr;
        
    }
    
}


#pragma mark - 数据组装
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
                //批号2 地段21K号 标题 专题 标题尾巴   Lot2第一个号码  主张7  一等奖// 加 十 个
                if ([bet.code isEqualToString:@"PIHAO2"]||[bet.code isEqualToString:@"DIDUAN2"]
                    ||[bet.code isEqualToString:@"BIAOTI"]||[bet.code isEqualToString:@"ZHUANTI"]
                    ||[bet.code isEqualToString:@"TEBIEBIAOTI"]
                    ||[bet.code isEqualToString:@"BIAOTIWB"]||[bet.code isEqualToString:@"LOT2FIRST"]
                    ||[bet.code isEqualToString:@"ZHUZHANG7"]||[bet.code isEqualToString:@"YIDENGJIANG"]) {
                    
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
                
                
                //批号2 地段21K号 标题 专题 标题尾巴  串烧4 串烧8 串烧10  偏斜2 偏斜3 偏斜4  Lot2第一个号码 主张7  一等奖// 加 00-99
                if ([bet.code isEqualToString:@"PIHAO2"]||[bet.code isEqualToString:@"DIDUAN2"]
                    ||[bet.code isEqualToString:@"BIAOTI"]||[bet.code isEqualToString:@"ZHUANTI"]
                    ||[bet.code isEqualToString:@"TEBIEBIAOTI"]
                    ||[bet.code isEqualToString:@"BIAOTIWB"]||[bet.code isEqualToString:@"CHUANSHAO4"]
                    ||[bet.code isEqualToString:@"CHUANSHAO8"]||[bet.code isEqualToString:@"CHUANSHAO10"]
                    ||[bet.code isEqualToString:@"PIANXIE2"]||[bet.code isEqualToString:@"PIANXIE3"]
                    ||[bet.code isEqualToString:@"PIANXIE4"]||[bet.code isEqualToString:@"LOT2FIRST"]
                    ||[bet.code isEqualToString:@"ZHUZHANG7"]||[bet.code isEqualToString:@"YIDENGJIANG"]) {
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

-(void)handleTipStrForCode:(NSString *)code{
    //批号2   地段21k号 标题 专题  标题尾巴      Lot2第一个号码 主张7 一等奖
    if ([code isEqualToString:@"PIHAO2"]||[code isEqualToString:@"DIDUAN2"]
        ||[code isEqualToString:@"BIAOTI"]||[code isEqualToString:@"ZHUANTI"]
        ||[code isEqualToString:@"TEBIEBIAOTI"]
        ||[code isEqualToString:@"BIAOTIWB"]||[code isEqualToString:@"LOT2FIRST"]
        ||[code isEqualToString:@"ZHUZHANG7"]||[code isEqualToString:@"YIDENGJIANG"]) {
        self.inputView.code = Tip_十;
    }
    
    //批号3 3个音阶  3更特别  3尾巴
    else  if ([code isEqualToString:@"PIHAO3"]||[code isEqualToString:@"3YINJIE"]
              ||[code isEqualToString:@"3GTEBIE"]||[code isEqualToString:@"3WBDJT"]) {
        self.inputView.code = Tip_百;
    }
    //批号4  4更特别
    else   if ([code isEqualToString:@"PIHAO4"]||[code isEqualToString:@"4GTEBIE"]) {
        self.inputView.code = Tip_千;
    }
    //偏斜2
    else   if ([code isEqualToString:@"PIANXIE2"]) {
        self.inputView.code = Tip_偏斜2;
    } //偏斜3
    else   if ([code isEqualToString:@"PIANXIE3"]) {
        self.inputView.code = Tip_偏斜3;
    } // 偏斜4
    else   if ([code isEqualToString:@"PIANXIE4"]) {
        self.inputView.code = Tip_偏斜4;
    }// 串烧4
    else   if ([code isEqualToString:@"CHUANSHAO4"]) {
        self.inputView.code = Tip_串烧4;
    } //串烧8
    else   if ([code isEqualToString:@"CHUANSHAO8"]) {
        self.inputView.code = Tip_串烧8;
    } //串烧10
    else   if ([code isEqualToString:@"CHUANSHAO10"]) {
        self.inputView.code = Tip_串烧10;
    }
    
    
}


#pragma mark - textView delegate
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.markedTextRange == nil) {
        self.inputStr  = textView.text;
        NSString * selcode =  [self.lmgmentCodeArray objectAtIndex:self.segmentIndex];
        if ([selcode isEqualToString:@"PIANXIE2"]||[selcode isEqualToString:@"PIANXIE3"]
            ||[selcode isEqualToString:@"PIANXIE4"]){
            [self judgeForInputDate:textView.text];
        } else {
            [self judgeInputDate:textView.text];
        }
    }
}



-(BOOL)isbigArray:(NSArray  *)arr {
    int number = 0;
    NSLog(@"sarr = %@",arr);
    if (self.inputView.code == Tip_千 ) {
        number = 9999;
    }
    else  if (self.inputView.code  == Tip_百) {
        number = 999;
    }
    else  {
        number = 99;
    }
    
    return [CMCommon isbigArray:arr number:number];
}

-(BOOL)isLengthArray:(NSArray  *)arr {
    int length = 0;
    NSLog(@"sarr = %@",arr);
    if (self.inputView.code == Tip_千 ) {
        length = 4;
    }
    else  if (self.inputView.code  == Tip_百) {
        length = 3;
    }
    else  {
        length = 2;
    }
    
    return [CMCommon isLengthArray:arr length:length];
}


-(BOOL)isRepeatArray:(NSString *)str {
    
    BOOL isRepeat = NO;
    NSArray  *array = [self.inputStr componentsSeparatedByString:@"|"];
    NSMutableArray  *marray = [NSMutableArray new];
    
    for (NSString *objStr in array) {
        NSArray  * arr = [CMCommon arraySeparated:objStr split:@", ;"];//分隔符逗
        
        if ([CMCommon isRepeatArray:arr] ) {
            isRepeat = YES;
            break;
        }
        if ([CMCommon isNullArray:arr] ) {
            isRepeat = YES;
            break;
        }
        if ([CMCommon isbigArray:arr number:99 ] ) {
            isRepeat = YES;
            break;
        }
        if ([CMCommon isLengthArray:arr length:2 ] ) {
            isRepeat = YES;
            break;
        }
        [marray addObject:arr];
    }
    
    if (!isRepeat) {
        for (int i = 0; i< marray.count-1; i++) {
            NSArray  * arr1 = [marray objectAtIndex:i];
            
            for (int j = i + 1; j < marray.count; j++) {
                NSArray  * arr2 = [marray objectAtIndex:j];
                
                if ([CMCommon array:arr1 isEqualTo:arr2]) {
                    isRepeat = YES;
                    break;
                }
                
            }
        }
    }
    
    return isRepeat;
}
-(void)judgeForInputDate:(NSString *)str{
    
    if ([self isRepeatArray:str]) {
        [self  setLabelDataCount:0];
        return;
    }
    
    NSArray  *arr = [self.inputStr componentsSeparatedByString:@"|"];//分隔符逗号
    if (arr.count == 0 ) {
        [self judgeInputDate:str];
        return;
    }
    
    
    NSString * selcode =  [self.lmgmentCodeArray objectAtIndex:self.segmentIndex];
    if ([selcode isEqualToString:@"PIANXIE2"]) {
        _px2count = 0;
    }
    else if ([selcode isEqualToString:@"PIANXIE3"]){
        _px3count = 0;
    }
    else {
        _px4count = 0;
    }
    
    
    for (NSString *objStr in arr) {
        [self judgeInputDate:objStr];
    }
    
    if ([selcode isEqualToString:@"PIANXIE2"]) {
        [self  setLabelDataCount:_px2count];
    }
    else if ([selcode isEqualToString:@"PIANXIE3"]){
        [self  setLabelDataCount:_px3count];
    }
    else {
        [self  setLabelDataCount:_px4count];
    }
    
}



#pragma mark - 输入下注
-(void)judgeInputDate:(NSString *)str{
    
    if([str containsString:@"|"]) {
        [self  setLabelDataCount:0];
        return;
    }
    

    NSArray *arr = [CMCommon arraySeparated:str split:@", ;"];
    
    if (arr.count == 0 ) {
        [self  setLabelDataCount:0];
        return;
    }
    
    NSString * selcode =  [self.lmgmentCodeArray objectAtIndex:self.segmentIndex];
    
    if ([selcode isEqualToString:@"CHUANSHAO4"]
        ||[selcode isEqualToString:@"CHUANSHAO8"]||[selcode isEqualToString:@"CHUANSHAO10"]){
        [self specialInputActionModel :arr  ];
    }
    else if ([selcode isEqualToString:@"PIANXIE2"]||[selcode isEqualToString:@"PIANXIE3"]
             ||[selcode isEqualToString:@"PIANXIE4"]){
        [self pxSpecialInputActionModel :arr ];
    }
    else {
        [self inputActionModel :arr ];
    }
    
    
    
}

#pragma mark - 输入号码下注方法
-(void)judgeInputBetDateArray:(NSMutableArray *__strong *) array {
    
    NSString * selcode =  [self.lmgmentCodeArray objectAtIndex:self.segmentIndex];
    if ([selcode isEqualToString:@"PIANXIE2"]||[selcode isEqualToString:@"PIANXIE3"]
        ||[selcode isEqualToString:@"PIANXIE4"]){
        
        [self judgeForInputBetDate:array];
    } else {
        [self judgeInputDate:@"" arry:array];
    }
    
}

-(void)judgeForInputBetDate:(NSMutableArray *__strong *) array {
    NSArray  *arr = [self.inputStr componentsSeparatedByString:@"|"];//分隔符逗号
    if (arr.count == 0 ) {
        [self judgeInputDate:@"" arry:array];
        return;
    }
    
    [*array removeAllObjects];
    
    for (NSString *objStr in arr) {
        [self judgeInputDate:objStr arry:array];
    }
    
    NSMutableString *nameStr = [[NSMutableString alloc] initWithString:@"【"];
    [nameStr appendString:[CMCommon strReplace:self.inputStr spChar:@";" split:@", ;"]];
    [nameStr appendString:@"】"];
    self.nextIssueModel.defnameStr = nameStr;
    
}

-(void)judgeInputDate:(NSString *)str  arry:(NSMutableArray *__strong *) array {
    NSArray  *arr;
    if ([CMCommon stringIsNull:str]) {
        arr = [CMCommon arraySeparated:self.inputStr split:@", ;"];
    }
    else{
        arr =  [CMCommon arraySeparated:str split:@", ;"];
    }
    if (arr.count == 0 ) {
        [self  setLabelDataCount:0];
        return;
    }
    
    NSString * selcode =  [self.lmgmentCodeArray objectAtIndex:self.segmentIndex];
    
    if ([selcode isEqualToString:@"CHUANSHAO4"]
        ||[selcode isEqualToString:@"CHUANSHAO8"]||[selcode isEqualToString:@"CHUANSHAO10"]){
        [self specialInputBetActionModel :arr   array : array ];
    }
    else if ([selcode isEqualToString:@"PIANXIE2"]||[selcode isEqualToString:@"PIANXIE3"]
             ||[selcode isEqualToString:@"PIANXIE4"]){
        [self pxSpecialInputBetActionModel :arr    array : array ];
    }
    else {
        [self inputBetActionModel :arr   array : array ];
    }
    
    NSMutableString *nameStr = [[NSMutableString alloc] initWithString:@"【"];
    [nameStr appendString:[CMCommon strReplace:self.inputStr spChar:@";" split:@", ;"]];
    [nameStr appendString:@"】"];
    self.nextIssueModel.defnameStr = nameStr;

    
    
}


//
-(void)inputActionModel:(NSArray  *)arr{
    
    if ([CMCommon isRepeatArray:arr] ) {
        [self  setLabelDataCount:0];
        return;
    }
    if ([CMCommon isNullArray:arr] ) {
        [self  setLabelDataCount:0];
        return;
    }
    if ([self isbigArray:arr ]) {
        [self  setLabelDataCount:0];
        return;
    }
    if ([self  isLengthArray:arr ] ) {
        [self  setLabelDataCount:0];
        return;
    }
    
   
    int count;
    NSMutableArray* intArray = [NSMutableArray new];
    if (arr.count) {
        
        for (NSString *obj in arr) {
            NSLog(@"obj = %@",obj);
            int objInt = [obj intValue];
            [intArray addObject: [NSNumber numberWithInt:objInt]];
        }
    }
    
    if (intArray.count == 0 ) {
        count = 0;
        [self  setLabelDataCount:count];
        return;
    }
    
    UGGameplayModel *model = [self.gameDataArray objectAtIndex:self.typeIndexPath.row];
    UGGameplaySectionModel *group = [model.list objectAtIndex:0];
    self.qsView.segmentedControl.selectedSegmentIndex = 0;
    self.qsView.selectedSegmentIndex = 0;
    UGGameBetModel *betM = [group.list objectAtIndex:self.segmentIndex];
    
    NSMutableArray *array = [NSMutableArray array];
    
    
    for (int i = 0; i < intArray.count; i++) {
        UGGameBetModel *bet = [[UGGameBetModel alloc] init];
        [bet setValuesForKeysWithDictionary:betM.mj_keyValues];
        bet.name = [NSString stringWithFormat:@"%@",[intArray objectAtIndex:i]];
        bet.betInfo = bet.name;
        bet.title = bet.alias;
        bet.betMultiple = [self getMultipleStr];
        bet.money = [NSString stringWithFormat:@"%d",self.defaultGold] ;
        [array addObject:bet];
        
    }
    
    if (intArray.count == 0 ) {
        count = 0;
        [self  setLabelDataCount:count];
        
    } else {
        count = array.count;
        NSLog(@"count = %ld",(long)count);
        [self  setLabelDataCount:count];
    }
}

-(void)inputBetActionModel:(NSArray  *)arr   array :(NSMutableArray *__strong *) marray {
    
    if ([CMCommon isRepeatArray:arr] ) {
        [self  setLabelDataCount:0];
        return;
    }
    if ([CMCommon isNullArray:arr] ) {
        [self  setLabelDataCount:0];
        return;
    }
    if ([self isbigArray:arr ] ) {
        [self  setLabelDataCount:0];
        return;
    }
    if ([self  isLengthArray:arr ] ) {
        [self  setLabelDataCount:0];
        return;
    }
    
    
    int count;
    NSMutableArray* intArray = [NSMutableArray new];
    if (arr.count) {
        for (NSString *obj in arr) {
            NSLog(@"obj = %@",obj);
            int objInt = [obj intValue];
            [intArray addObject: [NSNumber numberWithInt:objInt]];
        }
    }
    
    if (intArray.count == 0 ) {
        [SVProgressHUD showInfoWithStatus:@"下注内容不正确，请重新下注"];
        return;
    }
    
  
    
    UGGameplayModel *model = [self.gameDataArray objectAtIndex:self.typeIndexPath.row];
    UGGameplaySectionModel *group = [model.list objectAtIndex:0];
    self.qsView.segmentedControl.selectedSegmentIndex = 0;
    self.qsView.selectedSegmentIndex = 0;
    UGGameBetModel *betM = [group.list objectAtIndex:self.segmentIndex];
    
    
    for (int i = 0; i < intArray.count; i++) {
        
        UGGameBetModel *bet = [[UGGameBetModel alloc] init];
        [bet setValuesForKeysWithDictionary:betM.mj_keyValues];
        bet.name = [NSString stringWithFormat:@"%@",[intArray objectAtIndex:i]];
        bet.betInfo = bet.name;
        bet.title = bet.alias;
        bet.betMultiple = [self getMultipleStr];
        bet.money = [NSString stringWithFormat:@"%d",self.defaultGold] ;
        
        [*marray addObject:bet];
        
       
    }

}

//特殊玩法 偏斜
-(void)pxSpecialInputActionModel:(NSArray  *)arr  {
    
    if ([CMCommon isRepeatArray:arr] ) {
        _px2count = 0;
        _px3count = 0;
        _px4count = 0;
        [self  setLabelDataCount:0];
        return;
    }
    if ([CMCommon isNullArray:arr] ) {
        _px2count = 0;
        _px3count = 0;
        _px4count = 0;
        [self  setLabelDataCount:0];
        return;
    }
    if ([self isbigArray:arr  ] ) {
        _px2count = 0;
        _px3count = 0;
        _px4count = 0;
        [self  setLabelDataCount:0];
        return;
    }
    int count = 0;
    
    NSString * selcode =  [self.lmgmentCodeArray objectAtIndex:self.segmentIndex];
    if (arr.count) {
        {
            //如果是偏斜2 长度只能为2  是1注
            if ([selcode isEqualToString:@"PIANXIE2"]){
                
                if (arr.count != 2) {
                    _px2count = 0;
                    return;
                    
                } else {
                    
                    if (![CMCommon stringIsNull:[arr objectAtIndex:0]] && ![CMCommon stringIsNull:[arr objectAtIndex:1]]
                        && [[arr objectAtIndex:0] intValue] < 100 && [[arr objectAtIndex:1] intValue] < 100) {
                        
                        
                        _px2count++;
                        
                        [self  setLabelDataCount:_px2count];
                    }
                    else{
                        _px2count = 0;
                        [self  setLabelDataCount:_px2count];
                        return;
                    }
                }
            }
            //如果是偏斜3 长度只能为3  是1注
            if ([selcode isEqualToString:@"PIANXIE3"]){
                
                if (arr.count != 3) {
                    _px3count = 0;
                    [self  setLabelDataCount:_px3count];
                    return;
                    
                } else {
                    
                    if (![CMCommon stringIsNull:[arr objectAtIndex:0]] && ![CMCommon stringIsNull:[arr objectAtIndex:1]]
                        && ![CMCommon stringIsNull:[arr objectAtIndex:2]]
                        && [[arr objectAtIndex:0] intValue] < 100 && [[arr objectAtIndex:1] intValue] < 100
                        && [[arr objectAtIndex:2] intValue] < 100){
                        count  = 1;
                        _px3count = _px3count + count;
                        [self  setLabelDataCount:_px3count];
                    }
                    else{
                        _px3count = 0;
                        [self  setLabelDataCount:_px3count];
                        return;
                    }
                }
            }
            //如果是偏斜4 串烧4 长度只能为4  是1注
            if ([selcode isEqualToString:@"PIANXIE4"]){
                
                if (arr.count != 4) {
                    _px4count = 0;
                    [self  setLabelDataCount:_px4count];
                    return;
                    
                } else {
                    
                    if (![CMCommon stringIsNull:[arr objectAtIndex:0]] && ![CMCommon stringIsNull:[arr objectAtIndex:1]]
                        && ![CMCommon stringIsNull:[arr objectAtIndex:2]]&& ![CMCommon stringIsNull:[arr objectAtIndex:3]]
                        && [[arr objectAtIndex:0] intValue] < 100 && [[arr objectAtIndex:1] intValue] < 100
                        && [[arr objectAtIndex:2] intValue] < 100 && [[arr objectAtIndex:3] intValue] < 100){
                        
                        count  = 1;
                        _px4count = _px4count + count;
                        [self  setLabelDataCount:_px4count];
                    }
                    else{
                        _px4count = 0;
                        [self  setLabelDataCount:_px4count];
                        return;
                    }
                }
            }
            
        }
        
    }
}

//特殊玩法 偏斜
-(void)pxSpecialInputBetActionModel:(NSArray  *)arr   array :(NSMutableArray *__strong *) marray{
    
    if ([CMCommon isRepeatArray:arr] ) {
        [self  setLabelDataCount:0];
        return;
    }
    if ([CMCommon isNullArray:arr] ) {
        [self  setLabelDataCount:0];
        return;
    }
    if ([self isbigArray:arr ] ) {
        [self  setLabelDataCount:0];
        return;
    }
    if ([self  isLengthArray:arr ] ) {
        [self  setLabelDataCount:0];
        return;
    }
    
    
    NSMutableArray* intArray = [NSMutableArray new];
    if (arr.count) {
        for (NSString *obj in arr) {
            NSLog(@"obj = %@",obj);
            int objInt = [obj intValue];
            [intArray addObject: [NSNumber numberWithInt:objInt]];
        }
    }
    
    if (intArray.count == 0 ) {
        [SVProgressHUD showInfoWithStatus:@"下注内容不正确，请重新下注"];
        return;
    }
    NSString * selcode =  [self.lmgmentCodeArray objectAtIndex:self.segmentIndex];
    UGGameplayModel *model = [self.gameDataArray objectAtIndex:self.typeIndexPath.row];
    UGGameplaySectionModel *group = [model.list objectAtIndex:0];
    self.qsView.segmentedControl.selectedSegmentIndex = 0;
    self.qsView.selectedSegmentIndex = 0;
    UGGameBetModel *betM = [group.list objectAtIndex:self.segmentIndex];
    
    if ([selcode isEqualToString:@"PIANXIE2"]){
        
        if (intArray.count != 2 ) {
            [SVProgressHUD showInfoWithStatus:@"下注内容不正确，请重新下注"];
            return;
        }
        UGGameBetModel *bet = [[UGGameBetModel alloc] init];
        [bet setValuesForKeysWithDictionary:betM.mj_keyValues];
        NSMutableString *name = [[NSMutableString alloc] init];
        [name appendString:[NSString stringWithFormat:@"%@",[intArray objectAtIndex:0]]];
        [name appendString:@"|"];
        [name appendString:[NSString stringWithFormat:@"%@",[intArray objectAtIndex:1]]];
        
        bet.name = name;
        bet.betInfo = name;
        bet.title = bet.alias;
        bet.betMultiple = [self getMultipleStr];
        bet.money = [NSString stringWithFormat:@"%d",self.defaultGold] ;
        
        [*marray addObject:bet];
    }
    
    if ([selcode isEqualToString:@"PIANXIE3"]){
        
        if (intArray.count != 3 ) {
            [SVProgressHUD showInfoWithStatus:@"下注内容不正确，请重新下注"];
            return;
        }
        UGGameBetModel *bet = [[UGGameBetModel alloc] init];
        [bet setValuesForKeysWithDictionary:betM.mj_keyValues];
        NSMutableString *name = [[NSMutableString alloc] init];
        [name appendString:[NSString stringWithFormat:@"%@",[intArray objectAtIndex:0]]];
        [name appendString:@"|"];
        [name appendString:[NSString stringWithFormat:@"%@",[intArray objectAtIndex:1]]];
        [name appendString:@"|"];
        [name appendString:[NSString stringWithFormat:@"%@",[intArray objectAtIndex:2]]];
        
        bet.name = name;
        bet.betInfo = name;
        bet.title = bet.alias;
        bet.betMultiple = [self getMultipleStr];
        bet.money = [NSString stringWithFormat:@"%d",self.defaultGold] ;
        
        [*marray addObject:bet];
        
    }
    
    if ([selcode isEqualToString:@"PIANXIE4"] ){
        if (intArray.count != 4 ) {
            [SVProgressHUD showInfoWithStatus:@"下注内容不正确，请重新下注"];
            return;
        }
        UGGameBetModel *bet = [[UGGameBetModel alloc] init];
        [bet setValuesForKeysWithDictionary:betM.mj_keyValues];
        NSMutableString *name = [[NSMutableString alloc] init];
        [name appendString:[NSString stringWithFormat:@"%@",[intArray objectAtIndex:0]]];
        [name appendString:@"|"];
        [name appendString:[NSString stringWithFormat:@"%@",[intArray objectAtIndex:1]]];
        [name appendString:@"|"];
        [name appendString:[NSString stringWithFormat:@"%@",[intArray objectAtIndex:2]]];
        [name appendString:@"|"];
        [name appendString:[NSString stringWithFormat:@"%@",[intArray objectAtIndex:3]]];
        
        bet.name = name;
        bet.betInfo = name;
        bet.title = bet.alias;
        bet.betMultiple = [self getMultipleStr];
        bet.money = [NSString stringWithFormat:@"%d",self.defaultGold] ;
        
        [*marray addObject:bet];
        
    }
    
}
//特殊玩法    //如果是偏斜2 长度只能为2  是1注
-(void)specialInputActionModel:(NSArray  *)arr   {
    
    if ([CMCommon isRepeatArray:arr] ) {
        return;
    }
    if ([CMCommon isNullArray:arr] ) {
        [self  setLabelDataCount:0];
        return;
    }
    if ([self isbigArray:arr ] ) {
        [self  setLabelDataCount:0];
        return;
    }
    if ([self  isLengthArray:arr ] ) {
        [self  setLabelDataCount:0];
        return;
    }
    
    
    NSMutableArray* intArray = [NSMutableArray new];
    NSString * selcode =  [self.lmgmentCodeArray objectAtIndex:self.segmentIndex];
    if (arr.count) {
        {
            //如果是 串烧8 长度只能为8  是1注
            if ([selcode isEqualToString:@"CHUANSHAO4"] ){
                
                if (arr.count != 4) {
                    [self  setLabelDataCount:0];
                    return;
                    
                } else {
                    
                    if (![CMCommon stringIsNull:[arr objectAtIndex:0]] && ![CMCommon stringIsNull:[arr objectAtIndex:1]]
                        && ![CMCommon stringIsNull:[arr objectAtIndex:2]]&& ![CMCommon stringIsNull:[arr objectAtIndex:3]]) {
                        
                        [self  setLabelDataCount:1];
                    }
                    else{
                        [self  setLabelDataCount:0];
                        return;
                    }
                }
            }
            //如果是 串烧8 长度只能为8  是1注
            if ([selcode isEqualToString:@"CHUANSHAO8"] ){
                
                if (arr.count != 8) {
                    [self  setLabelDataCount:0];
                    return;
                    
                } else {
                    
                    if (![CMCommon stringIsNull:[arr objectAtIndex:0]] && ![CMCommon stringIsNull:[arr objectAtIndex:1]]
                        && ![CMCommon stringIsNull:[arr objectAtIndex:2]]&& ![CMCommon stringIsNull:[arr objectAtIndex:3]]
                        && ![CMCommon stringIsNull:[arr objectAtIndex:4]]&& ![CMCommon stringIsNull:[arr objectAtIndex:5]]
                        && ![CMCommon stringIsNull:[arr objectAtIndex:6]]&& ![CMCommon stringIsNull:[arr objectAtIndex:7]]) {
                        
                        [self  setLabelDataCount:1];
                    }
                    else{
                        [self  setLabelDataCount:0];
                        return;
                    }
                }
            }
            //如果是 串烧10 长度只能为10  是1注
            if ([selcode isEqualToString:@"CHUANSHAO10"] ){
                
                if (arr.count != 10) {
                    [self  setLabelDataCount:0];
                    return;
                    
                } else {
                    
                    if (![CMCommon stringIsNull:[arr objectAtIndex:0]] && ![CMCommon stringIsNull:[arr objectAtIndex:1]]
                        && ![CMCommon stringIsNull:[arr objectAtIndex:2]]&& ![CMCommon stringIsNull:[arr objectAtIndex:3]]
                        && ![CMCommon stringIsNull:[arr objectAtIndex:4]]&& ![CMCommon stringIsNull:[arr objectAtIndex:5]]
                        && ![CMCommon stringIsNull:[arr objectAtIndex:6]]&& ![CMCommon stringIsNull:[arr objectAtIndex:7]]
                        && ![CMCommon stringIsNull:[arr objectAtIndex:8]]&& ![CMCommon stringIsNull:[arr objectAtIndex:9]]) {
                        
                        [self  setLabelDataCount:1];
                    }
                    else{
                        [self  setLabelDataCount:0];
                        return;
                    }
                }
            }
        }
    }
    
}

-(void)specialInputBetActionModel:(NSArray  *)arr   array :(NSMutableArray *__strong *) marray {
    
    if ([CMCommon isRepeatArray:arr] ) {
        return;
    }
    if ([CMCommon isNullArray:arr] ) {
        return;
    }
    if ([self isbigArray:arr ] ) {
        return;
    }
    if ([self  isLengthArray:arr ] ) {
        return;
    }
    
    
    int count;
    NSMutableArray* intArray = [NSMutableArray new];
    NSString * selcode =  [self.lmgmentCodeArray objectAtIndex:self.segmentIndex];
    if (arr.count) {
        
        {
            
            
            //如果是 串烧8 长度只能为8  是1注
            if ([selcode isEqualToString:@"CHUANSHAO8"] ){
                
                if (arr.count != 8) {
                    [self  setLabelDataCount:0];
                    return;
                    
                } else {
                    
                    if (![CMCommon stringIsNull:[arr objectAtIndex:0]] && ![CMCommon stringIsNull:[arr objectAtIndex:1]]
                        && ![CMCommon stringIsNull:[arr objectAtIndex:2]]&& ![CMCommon stringIsNull:[arr objectAtIndex:3]]
                        && ![CMCommon stringIsNull:[arr objectAtIndex:4]]&& ![CMCommon stringIsNull:[arr objectAtIndex:5]]
                        && ![CMCommon stringIsNull:[arr objectAtIndex:6]]&& ![CMCommon stringIsNull:[arr objectAtIndex:7]]) {
                        
                        [self  setLabelDataCount:1];
                    }
                    else{
                        [self  setLabelDataCount:0];
                        return;
                    }
                }
            }
            //如果是 串烧10 长度只能为10  是1注
            if ([selcode isEqualToString:@"CHUANSHAO10"] ){
                
                if (arr.count != 10) {
                    [self  setLabelDataCount:0];
                    return;
                    
                } else {
                    
                    if (![CMCommon stringIsNull:[arr objectAtIndex:0]] && ![CMCommon stringIsNull:[arr objectAtIndex:1]]
                        && ![CMCommon stringIsNull:[arr objectAtIndex:2]]&& ![CMCommon stringIsNull:[arr objectAtIndex:3]]
                        && ![CMCommon stringIsNull:[arr objectAtIndex:4]]&& ![CMCommon stringIsNull:[arr objectAtIndex:5]]
                        && ![CMCommon stringIsNull:[arr objectAtIndex:6]]&& ![CMCommon stringIsNull:[arr objectAtIndex:7]]
                        && ![CMCommon stringIsNull:[arr objectAtIndex:8]]&& ![CMCommon stringIsNull:[arr objectAtIndex:9]]) {
                        
                        [self  setLabelDataCount:1];
                    }
                    else{
                        [self  setLabelDataCount:0];
                        return;
                    }
                }
            }
        }
        
        for (NSString *obj in arr) {
            NSLog(@"obj = %@",obj);
            int objInt = [obj intValue];
            [intArray addObject: [NSNumber numberWithInt:objInt]];
        }
    }

    
    UGGameplayModel *model = [self.gameDataArray objectAtIndex:self.typeIndexPath.row];
    UGGameplaySectionModel *group = [model.list objectAtIndex:0];
    self.qsView.segmentedControl.selectedSegmentIndex = 0;
    self.qsView.selectedSegmentIndex = 0;
    UGGameBetModel *betM = [group.list objectAtIndex:self.segmentIndex];
    
    {
        if ([selcode isEqualToString:@"CHUANSHAO4"] ){
            UGGameBetModel *bet = [[UGGameBetModel alloc] init];
            [bet setValuesForKeysWithDictionary:betM.mj_keyValues];
            NSMutableString *name = [[NSMutableString alloc] init];
            [name appendString:[NSString stringWithFormat:@"%@",[intArray objectAtIndex:0]]];
            [name appendString:@"|"];
            [name appendString:[NSString stringWithFormat:@"%@",[intArray objectAtIndex:1]]];
            [name appendString:@"|"];
            [name appendString:[NSString stringWithFormat:@"%@",[intArray objectAtIndex:2]]];
            [name appendString:@"|"];
            [name appendString:[NSString stringWithFormat:@"%@",[intArray objectAtIndex:3]]];
            
            bet.name = name;
            bet.betInfo = name;
            bet.title = bet.alias;
            bet.betMultiple = [self getMultipleStr];
            bet.money = [NSString stringWithFormat:@"%d",self.defaultGold] ;
            
            [*marray addObject:bet];
            
           
        }
        
        if ([selcode isEqualToString:@"CHUANSHAO8"]){
            UGGameBetModel *bet = [[UGGameBetModel alloc] init];
            [bet setValuesForKeysWithDictionary:betM.mj_keyValues];
            NSMutableString *name = [[NSMutableString alloc] init];
            [name appendString:[NSString stringWithFormat:@"%@",[intArray objectAtIndex:0]]];
            [name appendString:@"|"];
            [name appendString:[NSString stringWithFormat:@"%@",[intArray objectAtIndex:1]]];
            [name appendString:@"|"];
            [name appendString:[NSString stringWithFormat:@"%@",[intArray objectAtIndex:2]]];
            [name appendString:@"|"];
            [name appendString:[NSString stringWithFormat:@"%@",[intArray objectAtIndex:3]]];
            [name appendString:@"|"];
            [name appendString:[NSString stringWithFormat:@"%@",[intArray objectAtIndex:4]]];
            [name appendString:@"|"];
            [name appendString:[NSString stringWithFormat:@"%@",[intArray objectAtIndex:5]]];
            [name appendString:@"|"];
            [name appendString:[NSString stringWithFormat:@"%@",[intArray objectAtIndex:6]]];
            [name appendString:@"|"];
            [name appendString:[NSString stringWithFormat:@"%@",[intArray objectAtIndex:7]]];
            
            
            bet.name = name;
            bet.betInfo = name;
            bet.title = bet.alias;
            bet.betMultiple = [self getMultipleStr];
            bet.money = [NSString stringWithFormat:@"%d",self.defaultGold] ;
            
            [*marray addObject:bet];
            
           
        }
        
        if ([selcode isEqualToString:@"CHUANSHAO10"]){
            UGGameBetModel *bet = [[UGGameBetModel alloc] init];
            [bet setValuesForKeysWithDictionary:betM.mj_keyValues];
            NSMutableString *name = [[NSMutableString alloc] init];
            [name appendString:[NSString stringWithFormat:@"%@",[intArray objectAtIndex:0]]];
            [name appendString:@"|"];
            [name appendString:[NSString stringWithFormat:@"%@",[intArray objectAtIndex:1]]];
            [name appendString:@"|"];
            [name appendString:[NSString stringWithFormat:@"%@",[intArray objectAtIndex:2]]];
            [name appendString:@"|"];
            [name appendString:[NSString stringWithFormat:@"%@",[intArray objectAtIndex:3]]];
            [name appendString:@"|"];
            [name appendString:[NSString stringWithFormat:@"%@",[intArray objectAtIndex:4]]];
            [name appendString:@"|"];
            [name appendString:[NSString stringWithFormat:@"%@",[intArray objectAtIndex:5]]];
            [name appendString:@"|"];
            [name appendString:[NSString stringWithFormat:@"%@",[intArray objectAtIndex:6]]];
            [name appendString:@"|"];
            [name appendString:[NSString stringWithFormat:@"%@",[intArray objectAtIndex:7]]];
            [name appendString:@"|"];
            [name appendString:[NSString stringWithFormat:@"%@",[intArray objectAtIndex:8]]];
            [name appendString:@"|"];
            [name appendString:[NSString stringWithFormat:@"%@",[intArray objectAtIndex:9]]];
            
            bet.name = name;
            bet.betInfo = name;
            bet.title = bet.alias;
            bet.betMultiple = [self getMultipleStr];
            bet.money = [NSString stringWithFormat:@"%d",self.defaultGold] ;
            
            [*marray addObject:bet];
            
       
            
        }
    }
    
  
}

//设置下注为空  默认为1
-(NSString *)getMultipleStr{
    NSString *intMultiple = @"1";
    
    if (![CMCommon stringIsNull:self.amountTextF.text]) {
        
        int intStr = [self.amountTextF.text intValue];
        if (intStr > 0) {
            intMultiple = self.amountTextF.text;
        }
    }
    return intMultiple;
}

#pragma mark - textField delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [self.amountTextF resignFirstResponder];
        return NO;
    }
    return YES;
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
    
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:self.tableView]) {
        self.typeIndexPath = indexPath;
        
        UGGameplayModel *model = self.gameDataArray[indexPath.row];
        UGGameplaySectionModel *obj = model.list[0];
        //设置segmentView标题 和 code 数据
        self.segmentIndex = 0;
        [self segmentViewTitleAndCode:model];

        NSString * code =  [self.lmgmentCodeArray objectAtIndex:self.segmentIndex];
        
        [self setDefaultData:code];
        //判断ynsegmentView 标题 和 隐藏
        [self determineYnsegmentViewTitle:model.code];
        
        UGGameBetModel *betModel = obj.list[self.segmentIndex];
        NSString * odds =  betModel.odds;
        NSLog(@"code = %@",betModel.code);
        [[Global getInstanse] setSelCode:betModel.code];
        [self setDefaultOddsData:odds];
        
        [self resetClick:nil];
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
        self.ynSelectStr = @"选择号码";
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
            self.ynSelectStr = @"选择号码";
            self.inputView.code = Tip_千;
        }
        else if([code isEqualToString:@"BL"]||[code isEqualToString:@"LBXC"]
                ||[code isEqualToString:@"3GD"]){
            [self.ynsegmentView.segment setSectionTitles:@[@"选择号码",@"输入号码",@"快速选择"]];
            [self resetClick:nil];
            [self.yncontentView bringSubviewToFront:self.betCollectionView];
            self.ynSelectStr = @"选择号码";
            if ([code isEqualToString:@"3GD"]) {
                self.inputView.code = Tip_百;
            }
            else{
                self.inputView.code = Tip_十;
            }
        }
        else if([code isEqualToString:@"DDQX"]||[code isEqualToString:@"CQ"]){
            [self.ynsegmentView.segment setSectionTitles:@[@"输入号码",@"快速选择"]];
            [self.yncontentView bringSubviewToFront:self.inputView];
            self.ynSelectStr = @"输入号码";
            if ([code isEqualToString:@"DDQX"]) {
                self.inputView.code = Tip_偏斜2;
            }
            else{
                self.inputView.code = Tip_串烧4;
            }
            [self resetClick:nil];
            
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
                //批号2 地段21K号 标题 专题 标题尾巴  Lot2第一个号码 主张7 一等奖// 加 十 个
                if ([bet.code isEqualToString:@"PIHAO2"]||[bet.code isEqualToString:@"DIDUAN2"]
                    ||[bet.code isEqualToString:@"BIAOTI"]||[bet.code isEqualToString:@"ZHUANTI"]
                    ||[bet.code isEqualToString:@"TEBIEBIAOTI"]
                    ||[bet.code isEqualToString:@"BIAOTIWB"]||[bet.code isEqualToString:@"LOT2FIRST"]
                    ||[bet.code isEqualToString:@"ZHUZHANG7"]||[bet.code isEqualToString:@"YIDENGJIANG"]){
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
            [footerView.removeButton removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
            [footerView.bigButton removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
            [footerView.allButton removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
            
            [footerView.smallButton removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
            [footerView.pButton removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
            [footerView.accidButton removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
            
            
            [footerView.allButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
                
                [weakSelf operationAllCellsAtIndexPath:indexPath parameter:@""];
                [weakSelf operationAllCellsAtIndexPath:indexPath parameter:@"所有"];
                
            }];//所有
            
            [footerView.bigButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
                
                [weakSelf operationAllCellsAtIndexPath:indexPath parameter:@""];
                [weakSelf operationAllCellsAtIndexPath:indexPath parameter:@"大数"];
            }];//大数
            
            [footerView.smallButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
                
                [weakSelf operationAllCellsAtIndexPath:indexPath parameter:@""];
                [weakSelf operationAllCellsAtIndexPath:indexPath parameter:@"小数"];
                
            }];//小数
            
            [footerView.pButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
                
                [weakSelf operationAllCellsAtIndexPath:indexPath parameter:@""];
                [weakSelf operationAllCellsAtIndexPath:indexPath parameter:@"奇数"];
            }];//奇数
            
            [footerView.accidButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
                
                [weakSelf operationAllCellsAtIndexPath:indexPath parameter:@""];
                [weakSelf operationAllCellsAtIndexPath:indexPath parameter:@"偶数"];
                
            }];//偶数
            
            [footerView.removeButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
                
                [weakSelf operationAllCellsAtIndexPath:indexPath parameter:@""];
                
            }];//移除
            
            
            return footerView;
        }else {
            
            return nil;
            
        }
        
    }
    return nil;
    
}


-(void)operationAllCellsAtIndexPath:(NSIndexPath *)indexPath parameter:(NSString *)para{
    
    
    // UI更新代码
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
        
        [self calculate:bet];
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
        //批号2 地段21K号 标题 专题 标题尾巴 Lot2第一个号码 主张7 一等奖// 加 十 个
        if ([bet.code isEqualToString:@"PIHAO2"]||[bet.code isEqualToString:@"DIDUAN2"]
            ||[bet.code isEqualToString:@"BIAOTI"]||[bet.code isEqualToString:@"ZHUANTI"]
            ||[bet.code isEqualToString:@"TEBIEBIAOTI"]
            ||[bet.code isEqualToString:@"BIAOTIWB"]||[bet.code isEqualToString:@"LOT2FIRST"]
            ||[bet.code isEqualToString:@"ZHUZHANG7"]||[bet.code isEqualToString:@"YIDENGJIANG"]) {
            
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
        
        model.selectedCount = number;
        [self.tableView reloadData];
        [self.tableView selectRowAtIndexPath:self.typeIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        
        [self calculate:bet];
    }
    
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
    
    return UIEdgeInsetsMake(1, 1, 1, 1);
}

#pragma mark - UI数据更新
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

    
    
    [self.headerCollectionView reloadData];
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


#pragma mark - 设置默认
//
- (void)setDefaultData :(NSString *)code {
    self.defaultGold = [self setDefaultGoldDataForCode:code];
}

- (void)setDefaultOddsData :(NSString *)odds {
    self.defaultAdds = odds;
    dispatch_async(dispatch_get_main_queue(), ^{
        // UI更新代码
        [self setOuntoddsLabelLable ];
    });
}

-(int )setMoneyGameTypeForCode :(NSString *)code {
    
    int defaultGoldInt = 0;
    
    if ([code isEqualToString:@"PIHAO2"]) {//批号2
        if ([self.nextIssueModel.gameType isEqualToString:@"ofclvn_hochiminhvip"]) {//越南
            defaultGoldInt = 18;
        } else {
            defaultGoldInt = 27;
        }
        
    }
    else  if ([code isEqualToString:@"LOT2FIRST"]) {//Lot2第一个号码  ==  河内
        if ([self.nextIssueModel.gameType isEqualToString:@"ofclvn_haboivip"]) {//
            defaultGoldInt = 23;
        }
    }
    else  if ([code isEqualToString:@"ZHUZHANG7"]) {//主张7   ==  河内
        if ([self.nextIssueModel.gameType isEqualToString:@"ofclvn_haboivip"]) {//
            defaultGoldInt = 4;
        }
    }
    else  if ([code isEqualToString:@"YIDENGJIANG"]) {//一等奖  ==  河内
        if ([self.nextIssueModel.gameType isEqualToString:@"ofclvn_haboivip"]) {//
            defaultGoldInt = 1;
        }
    }
    else  if ([code isEqualToString:@"TEBIEBIAOTI"]) {//特别标题  ==  河内
        if ([self.nextIssueModel.gameType isEqualToString:@"ofclvn_haboivip"]) {//
            defaultGoldInt = 1;
        }
    }
    else  if ([code isEqualToString:@"DIDUAN2"]) {//地段21k号
        if ([self.nextIssueModel.gameType isEqualToString:@"ofclvn_hochiminhvip"]) {//越南
            defaultGoldInt = 1;
        } else {
            defaultGoldInt = 1;
        }
    }
    else  if ([code isEqualToString:@"PIHAO3"]) {//批号3
        if ([self.nextIssueModel.gameType isEqualToString:@"ofclvn_hochiminhvip"]) {//越南
            defaultGoldInt = 17;
        } else {
            defaultGoldInt = 23;
        }
    }
    else  if ([code isEqualToString:@"PIHAO4"]) {//批号4
        if ([self.nextIssueModel.gameType isEqualToString:@"ofclvn_hochiminhvip"]) {//越南
            defaultGoldInt = 16;
        } else {
            defaultGoldInt = 20;
        }
    }
    else  if ([code isEqualToString:@"PIANXIE2"]) {//偏斜2
        if ([self.nextIssueModel.gameType isEqualToString:@"ofclvn_hochiminhvip"]) {//越南
            defaultGoldInt = 1;
        } else {
            defaultGoldInt = 1;
        }
    }
    else  if ([code isEqualToString:@"PIANXIE3"]) {//偏斜3
        if ([self.nextIssueModel.gameType isEqualToString:@"ofclvn_hochiminhvip"]) {//越南
            defaultGoldInt = 1;
        } else {
            defaultGoldInt = 1;
        }
    }
    else  if ([code isEqualToString:@"PIANXIE4"]) {//偏斜4
        if ([self.nextIssueModel.gameType isEqualToString:@"ofclvn_hochiminhvip"]) {//越南
            defaultGoldInt = 1;
        } else {
            defaultGoldInt = 1;
        }
    }
    else  if ([code isEqualToString:@"BIAOTI"]) {//标题
        if ([self.nextIssueModel.gameType isEqualToString:@"ofclvn_hochiminhvip"]) {//越南
            defaultGoldInt = 1;
        } else {
            defaultGoldInt = 1;
        }
    }
    else  if ([code isEqualToString:@"ZHUANTI"]) {//专题
        if ([self.nextIssueModel.gameType isEqualToString:@"ofclvn_hochiminhvip"]) {//越南
            defaultGoldInt = 1;
        } else {
            defaultGoldInt = 1;
        }
    }
    else  if ([code isEqualToString:@"BIAOTIWB"]) {//标题尾巴
        if ([self.nextIssueModel.gameType isEqualToString:@"ofclvn_hochiminhvip"]) {//越南
            defaultGoldInt = 2;
        } else {
            defaultGoldInt= 1;
        }
    }
    else  if ([code isEqualToString:@"TOU"]) {//头
        if ([self.nextIssueModel.gameType isEqualToString:@"ofclvn_hochiminhvip"]) {//越南
            defaultGoldInt = 1;
        } else {
            defaultGoldInt = 1;
        }
    }
    else  if ([code isEqualToString:@"WEI"]) {//尾
        if ([self.nextIssueModel.gameType isEqualToString:@"ofclvn_hochiminhvip"]) {//越南
            defaultGoldInt = 1;
        } else {
            defaultGoldInt = 1;
        }
    }
    else  if ([code isEqualToString:@"3YINJIE"]) {//3个音阶
        if ([self.nextIssueModel.gameType isEqualToString:@"ofclvn_hochiminhvip"]) {//越南
            defaultGoldInt = 1;
        } else {
            defaultGoldInt = 1;
        }
    }
    else  if ([code isEqualToString:@"3GTEBIE"]) {//3更特别
        if ([self.nextIssueModel.gameType isEqualToString:@"ofclvn_hochiminhvip"]) {//越南
            defaultGoldInt = 1;
        } else {
            defaultGoldInt = 1;
        }
    }
    else  if ([code isEqualToString:@"3WBDJT"]) {//3尾巴
        if ([self.nextIssueModel.gameType isEqualToString:@"ofclvn_hochiminhvip"]) {//越南
            defaultGoldInt = 2;
        } else {
            defaultGoldInt = 1;
        }
    }
    else  if ([code isEqualToString:@"4GTEBIE"]) {//4更特别
        if ([self.nextIssueModel.gameType isEqualToString:@"ofclvn_hochiminhvip"]) {//越南
            defaultGoldInt = 1;
        } else {
            defaultGoldInt = 1;
        }
    }
    else  if ([code isEqualToString:@"CHUANSHAO4"]) {//串烧4
        if ([self.nextIssueModel.gameType isEqualToString:@"ofclvn_hochiminhvip"]) {//越南
            defaultGoldInt = 1;
        } else {
            defaultGoldInt = 1;
        }
    }
    else  if ([code isEqualToString:@"CHUANSHAO8"]) {//串烧8
        if ([self.nextIssueModel.gameType isEqualToString:@"ofclvn_hochiminhvip"]) {//越南
            defaultGoldInt = 1;
        } else {
            defaultGoldInt = 1;
        }
    }
    else  if ([code isEqualToString:@"CHUANSHAO10"]) {//串烧10
        if ([self.nextIssueModel.gameType isEqualToString:@"ofclvn_hochiminhvip"]) {//越南
            defaultGoldInt = 1;
        } else {
            defaultGoldInt = 1;
        }
    }
    
    return defaultGoldInt;
}

- (int)setDefaultGoldDataForCode :(NSString *)code {
    
    int defaultGoldInt  = 0;
    
    int moeny = [self setMoneyGameTypeForCode:code ];
    
    if ([UGSystemConfigModel.currentConfig.currency isEqualToString:@"VND"]) {
        
        defaultGoldInt =  moeny*1000;
    } else {
        defaultGoldInt = moeny;
    }
    return defaultGoldInt;
    
}

#pragma mark - 显示金额

//显示金额
-(void)setAmountLableCount:(int)count{
    int multiple = [[self getMultipleStr] intValue];
    int amount = count * self.defaultGold ;
    NSString *amountStr;
    if ([UGSystemConfigModel.currentConfig.currency isEqualToString:@"VND"]) {
        amountStr = [NSString stringWithFormat:@"金额:%d 越南盾",amount * multiple];
    }
    else {
        amountStr = [NSString stringWithFormat:@"金额:%d 元",amount * multiple];
    }
    self.amount = amount;
    self.amountLabel.text = amountStr;
    [CMLabelCommon setRichNumberWithLabel:self.amountLabel Color:RGBA(247, 211, 72, 1) FontSize:16];
}

-(void)setLabelDataCount:(int  )count{
    dispatch_async(dispatch_get_main_queue(), ^{
        // UI更新代码
        self.count = count ;
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

#pragma mark -textfield添加事件，只要值改变就调用此函数
-(void)changedTextField:(UITextField *)textField
{
    int multip = textField.text.intValue;
    if (multip >= 0  ) {
        int multiple = [[self getMultipleStr] intValue];
        int count =   self.amount * multiple;
        NSString *amountStr;
        if ([UGSystemConfigModel.currentConfig.currency isEqualToString:@"VND"]) {
            amountStr = [NSString stringWithFormat:@"金额:%d 越南盾",count];
        }
        else {
            amountStr = [NSString stringWithFormat:@"金额:%d 元",count];
        }
        
        self.amountLabel.text = amountStr;
        [CMLabelCommon setRichNumberWithLabel:self.amountLabel Color:RGBA(247, 211, 72, 1) FontSize:16];
    }
}

@end

