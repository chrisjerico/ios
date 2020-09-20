//
//  UGMineSkinViewController.m
//  ug
//
//  Created by ug on 2019/10/2.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGMineSkinViewController.h"
#import "UGMineMenuCollectionViewCell.h"
#import "UGMineSkinCollectionViewCell.h"
#import "UGMineSkinFirstCollectionHeadView.h"
#import "UGSkinSeconCollectionHeadView.h"
#import "UGMineSkinModel.h"
#import "UGAvaterSelectView.h"
#import "UGMissionCenterViewController.h"
#import "UGSigInCodeViewController.h"

#import "UGFundsViewController.h"
#import "SLWebViewController.h"
#import "UGSystemConfigModel.h"
#import "UGBalanceConversionController.h"
#import "UGBankCardInfoController.h"
#import "UGPromotionIncomeController.h"
#import "UGBindCardViewController.h"
#import "UGSetupPayPwdController.h"
#import "UGYubaoViewController.h"
#import "UGSecurityCenterViewController.h"
#import "UGMailBoxTableViewController.h"
#import "UGBetRecordViewController.h"
#import "UGRealBetRecordViewController.h"
#import "UGFeedBackController.h"
#import "UGMosaicGoldViewController.h"
#import "UGagentApplyInfo.h"
#import "UGAgentViewController.h"
#import "UGAgentViewController.h"
#import "UGChangLongController.h"
#import "STBarButtonItem.h"
#import "UGYYRightMenuView.h"

#import "JYMineCollectionViewCell.h"
#import "UGSignInHistoryModel.h"
#import "UGSalaryListView.h"
@interface UGMineSkinViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSString *skitType;
    NSInteger unreadMsg;
}
@property (weak, nonatomic) IBOutlet UIView *userInfoView;
@property (weak, nonatomic) IBOutlet UIView *topupView;  /**<   头视图 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topupViewNSLayoutConstraintHight;
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
//===================================================
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userVipLabel;
@property (weak, nonatomic) IBOutlet UILabel *userMoneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *refreshFirstButton;
@property (weak, nonatomic) IBOutlet UILabel *moneyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *moenyNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *fristVipLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondVipLabel;
@property (weak, nonatomic) IBOutlet UIView *progressView;  /**<   进度条 */
@property (weak, nonatomic) IBOutlet UIButton *taskButton;  /**<   任务中心 | 转换额度*/
@property (weak, nonatomic) IBOutlet UIButton *signButton;   /**<   每日签到 | 退出登录*/
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) CAShapeLayer *containerLayer;
@property (weak, nonatomic) IBOutlet UILabel *uidLabel;
//===================================================
@property (weak, nonatomic) IBOutlet UIView *headerLabelView;

@property (weak, nonatomic) IBOutlet UIButton *topupButton;  /**<  视图按钮1 */
@property (weak, nonatomic) IBOutlet UIButton *withdrawalsButton;/**<  视图按钮2 */
@property (weak, nonatomic) IBOutlet UIButton *conversionButton;/**<  视图按钮3 */

@property (strong, nonatomic)UGYYRightMenuView *yymenuView;   /**<   侧边栏 */

//===================================================
@property (nonatomic, strong) NSMutableArray <UGUserCenterItem *>*menuNameArray;        /**<   行数据 */
@property (nonatomic, strong) NSMutableArray <UGMineSkinModel *> *menuSecondNameArray;  /**<   新年红模版时的数据 */
//===================================================
@property (weak, nonatomic) IBOutlet UIButton *salaryBtn; /**<   领取俸禄 */
@property (nonatomic, strong) NSMutableArray <UGSignInHistoryModel *> *historyDataArray;
@end

@implementation UGMineSkinViewController

- (void)skin {
    
    [self.userInfoView setBackgroundColor:  Skin1.is23 ? RGBA(111, 111, 111, 1) : Skin1.navBarBgColor];
    
    
    [self.view setBackgroundColor: Skin1.is23 ? RGBA(135 , 135 ,135, 1) : Skin1.bgColor];
    
    [self.myCollectionView setBackgroundColor: Skin1.bgColor];
    _progressLayer.strokeColor = Skin1.progressBgColor.CGColor;
    [self.progressView.layer addSublayer:self.progressLayer];
    
    
    skitType = Skin1.skitType;
    if ([skitType isEqualToString:@"经典"] || [skitType isEqualToString:@"六合资料"]|| Skin1.isJY) {
        self.topupView.hidden = YES;
        self.topupViewNSLayoutConstraintHight.constant = 0.1;
    }
    else if(Skin1.isTKL) {
        self.topupView.hidden = NO;
        self.topupViewNSLayoutConstraintHight.constant = 80;
    }
    else {
        self.topupView.hidden = NO;
        self.topupViewNSLayoutConstraintHight.constant = 63;
        [CMCommon setBorderWithView:self.topupView top:NO left:NO bottom:YES right:NO borderColor: UGRGBColor(236, 235, 235) borderWidth:1];
    }
    FastSubViewCode(self.topupView);
    //    subLabel(@"二维码Label").textColor = Skin1.textColor1;
    if (Skin1.isTKL) {
        subView(@"视图4View").hidden = NO;
        subImageView(@"视图1imag").image = [UIImage imageNamed:@"mine_zjmx"] ;
        subImageView(@"视图2imag").image = [UIImage imageNamed:@"mine_xzjl"] ;
        subImageView(@"视图3imag").image = [UIImage imageNamed:@"mine_wdxx"] ;
        subLabel(@"存款Label").text = @"资金明细";
        subLabel(@"提现Label").text = @"下注记录";
        subLabel(@"转换Label").text = @"在线客服";
        [subButton(@"视图4button") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
            [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGPromotionsController") animated:YES];
        }];
        
    } else {
        subView(@"视图4View").hidden = YES;
        subImageView(@"视图1imag").image = [UIImage imageNamed:@"huoqicunkuan"] ;
        subImageView(@"视图2imag").image = [UIImage imageNamed:@"qukuan"] ;
        subImageView(@"视图3imag").image = [UIImage imageNamed:@"Artboard"] ;
        subLabel(@"存款Label").text = @"存款";
        subLabel(@"提现Label").text = @"提现";
        subLabel(@"转换Label").text = @"转换";
    }
    [self.myCollectionView reloadData];
}

- (BOOL)允许游客访问 { return true; }

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view layoutSubviews];
    self.navigationController.navigationBarHidden = false;
    if (!self.menuSecondNameArray.count || !self.menuNameArray.count) {
        [self refreshBalance:nil];
    }
    //    SANotificationEventPost(UGNotificationGetUserInfo, nil);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.refreshFirstButton.layer removeAllAnimations];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.refreshFirstButton.selected)
        [self startAnimation];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self setupUserInfo:true];
}

- (IBAction)showAvaterSelectView {
    if (UserI.isTest) {
        return;
    }
    UGAvaterSelectView *avaterView = [[UGAvaterSelectView alloc] initWithFrame:CGRectMake(0, UGScerrnH, UGScreenW, UGScreenW)];
    [avaterView show];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self skin];
    //注册通知
    SANotificationEventSubscribe(UGNotificationWithSkinSuccess, self, ^(typeof (self) self, id obj) {
        [self skin];
    });
    SANotificationEventSubscribe(UGNotificationUserLogout, self, ^(typeof (self) self, id obj) {
        [self getSystemConfig];
    });
    SANotificationEventSubscribe(UGNotificationGetUserInfoComplete, self, ^(typeof (self) self, id obj) {
        [self getSystemConfig];
        [self.refreshFirstButton.layer removeAllAnimations];
        [self setupUserInfo:NO];
        [self.myCollectionView reloadData];
    });
    SANotificationEventSubscribe(UGNotificationUserAvatarChanged, self, ^(typeof (self) self, id obj) {
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[UGUserModel currentUser].avatar] placeholderImage:[UIImage imageNamed:@"touxiang-1"]];
    });
    
    if (!self.title) {
        self.title = @"我的";
    }
    self.headImageView.layer.cornerRadius = self.headImageView.height / 2 ;
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.userInteractionEnabled = YES;
    //    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAvaterSelectView)];
    //    [self.headImageView addGestureRecognizer:tap];
    
    if ([@"c134" containsString:APP.SiteId]) {
        [_headerLabelView setHidden:NO];
    }
    
    
    [self.progressView.layer addSublayer:self.progressLayer];
    self.progressView.layer.cornerRadius = self.progressView.height / 2;
    self.progressView.layer.masksToBounds = YES;
    self.progressView.backgroundColor = UGRGBColor(213, 224, 237);
    //    self.topupView.backgroundColor = Skin1.navBarBgColor;
    FastSubViewCode(self.topupView);
    subLabel(@"存款Label").textColor = Skin1.textColor1;
    subLabel(@"提现Label").textColor = Skin1.textColor1;
    subLabel(@"转换Label").textColor = Skin1.textColor1;
    
    
    //设置皮肤
    [self.view setBackgroundColor: Skin1.is23 ? RGBA(135 , 135 ,135, 1) : Skin1.bgColor];
    [self.userInfoView setBackgroundColor: Skin1.is23 ? RGBA(111, 111, 111, 1) : Skin1.navBarBgColor];
    [self.topupView setBackgroundColor:Skin1.bgColor];
    
    skitType = Skin1.skitType;
    
    
    
    self.navigationItem.rightBarButtonItem = [STBarButtonItem barButtonItemWithImageName:@"gengduo" target:self action:@selector(rightBarBtnClick)];
    
    
    __weakSelf_(__self);
    self.menuNameArray = @[].mutableCopy;
    [self.menuNameArray setArray:SysConf.userCenter];

    [self skinSeconddataSource];
    [self.myCollectionView reloadData];
    SANotificationEventSubscribe(UGNotificationGetSystemConfigComplete, self, ^(typeof (self) self, id obj) {
        [__self.menuNameArray setArray:SysConf.userCenter];
        [__self skinSeconddataSource];
        [__self.myCollectionView reloadData];
    });
    
    [self.salaryBtn setHidden:!APP.isShowSalary];
    //初始化
    [self initCollectionView];
    
    
    if (Skin1.isTKL) {
        [self.taskButton setImage:[UIImage imageNamed:@"tkl_edzh"] forState:(UIControlStateNormal)];
        [self.signButton setImage:[UIImage imageNamed:@"tkl_tcdl"] forState:(UIControlStateNormal)];
    }
    else{
        if (APP.isC217RWDT) {
            [self.taskButton setImage:[UIImage imageNamed:@"missionhallc217"] forState:(UIControlStateNormal)];
        } else {
            [self.taskButton setImage:[UIImage imageNamed:@"missionhall"] forState:(UIControlStateNormal)];
        }
    }
    
    
}

- (void)addRightBtn {
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(onClickedOKbtn)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}


#pragma mark --其他方法

- (void)rightBarBtnClick {
    self.yymenuView = [[UGYYRightMenuView alloc] initWithFrame:CGRectMake(UGScreenW /2 , 0, UGScreenW / 2, UGScerrnH)];
    self.yymenuView.titleType = @"1";
    //此处为重点
    WeakSelf;
    self.yymenuView.backToHomeBlock = ^{
        weakSelf.navigationController.tabBarController.selectedIndex = 0;
    };
    [self.yymenuView show];
}


BOOL isOk = NO;
- (void)onClickedOKbtn {
    NSLog(@"onClickedOKbtn");
    
    if (isOk) {
        self.topupView.hidden = YES;
        self.topupViewNSLayoutConstraintHight.constant = 0.1;
        skitType = @"新年红";
    }
    else{
        self.topupView.hidden = NO;
        self.topupViewNSLayoutConstraintHight.constant = 63;
        skitType = @"石榴红";
    }
    [self.myCollectionView reloadData];
    isOk = !isOk;
}


- (UIImage *)retureRandomThemeColorImage:(NSString *)imageName {
    UIColor *tintColor = Skin1.isBlack ? [UIColor whiteColor] : [UGSkinManagers randomThemeColor];
    return [[UIImage imageNamed:imageName] qmui_imageWithTintColor:tintColor];
}

- (void)skinSeconddataSource {
    //新年红
    self.menuSecondNameArray = [NSMutableArray array];
    [self.menuSecondNameArray addObject:({
        UGMineSkinModel *msm = [UGMineSkinModel new];
        msm.name = @"我的";
        msm.dataArray = @[].mutableCopy;
        for (NSNumber *uciType in @[@(UCI_推荐收益), @(UCI_活动彩金), @(UCI_利息宝), @(UCI_在线客服), @(UCI_全民竞猜), @(UCI_开奖走势)]) {
            [msm.dataArray addObject:[_menuNameArray objectWithValue:uciType keyPath:@"code"]];
        }
        msm;
    })];
    [self.menuSecondNameArray addObject:({
        UGMineSkinModel *msm = [UGMineSkinModel new];
        msm.name = @"注单详情";
        msm.dataArray = @[].mutableCopy;
        for (NSNumber *uciType in @[@(UCI_彩票注单记录), @(UCI_其他注单记录),]) {
            [msm.dataArray addObject:[_menuNameArray objectWithValue:uciType keyPath:@"code"]];
        }
        msm;
    })];
    [self.menuSecondNameArray addObject:({
        UGMineSkinModel *msm = [UGMineSkinModel new];
        msm.name = @"设置";
        msm.dataArray = @[].mutableCopy;
        for (NSNumber *uciType in @[@(UCI_银行卡管理), @(UCI_安全中心), @(UCI_个人信息),]) {
            [msm.dataArray addObject:[_menuNameArray objectWithValue:uciType keyPath:@"code"]];
        }
        msm;
    })];
    [self.menuSecondNameArray addObject:({
        UGMineSkinModel *msm = [UGMineSkinModel new];
        msm.name = @"网站资料";
        msm.dataArray = @[].mutableCopy;
        for (NSNumber *uciType in @[@(UCI_长龙助手), @(UCI_站内信), @(UCI_建议反馈),]) {
            [msm.dataArray addObject:[_menuNameArray objectWithValue:uciType keyPath:@"code"]];
        }
        msm;
    })];
}

- (void)initCollectionView {
    
    skitType = Skin1.skitType;
    
    //    float itemW = (UGScreenW - 8) / 3;
    UICollectionViewFlowLayout *layout = ({
        
        layout = [[UICollectionViewFlowLayout alloc] init];
        //        layout.itemSize = CGSizeMake(itemW, itemW );
        //        layout.minimumInteritemSpacing = 1;
        //        layout.minimumLineSpacing = 1;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        if ([skitType isEqualToString:@"新年红"]) {
            layout.headerReferenceSize = CGSizeMake(UGScreenW, 35);
        }
        else  if([skitType isEqualToString:@"石榴红"]){
            layout.headerReferenceSize = CGSizeMake(UGScreenW, 80);
        }
        else  if([skitType isEqualToString:@"经典"]|| Skin1.isJY){
            layout.headerReferenceSize = CGSizeMake(UGScreenW, 0.1);
        }
        else  if ([skitType isEqualToString:@"六合资料"]) {//六合资料
            layout.headerReferenceSize = CGSizeMake(UGScreenW, 0.1);
        }
        
        layout;
        
    });
    
    self.myCollectionView.backgroundColor =    Skin1.is23 ? RGBA(135, 135, 135, 1) : Skin1.bgColor;
    self.myCollectionView.dataSource = self;
    self.myCollectionView.delegate = self;
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"UGMineMenuCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"UGMineMenuCollectionViewCell"];
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"UGMineSkinCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"UGMineSkinCollectionViewCell"];
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"JYMineCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"JYMineCollectionViewCell"];
    
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"UGMineSkinFirstCollectionHeadView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UGMineSkinFirstCollectionHeadView"];
    
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"UGSkinSeconCollectionHeadView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UGSkinSeconCollectionHeadView"];
    
    [self.myCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView"];
    
    [self.myCollectionView setShowsHorizontalScrollIndicator:NO];
}




#pragma mark UICollectionView datasource
//collectionView有几个section
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    int sections = 1;
    skitType = Skin1.skitType;
    if ([skitType isEqualToString:@"新年红"]) {
        sections = (int) self.menuSecondNameArray.count;
    }
    else  if([skitType isEqualToString:@"石榴红"]){
        sections = 1;
    }
    else  if([skitType isEqualToString:@"经典"]||Skin1.isJY){
        sections = 1;
    }
    else  if ([skitType isEqualToString:@"六合资料"]) {//六合资料
        sections = 1;
    }
    return sections;
}
//每个section有几个item
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSInteger rows = self.menuNameArray.count;
    skitType = Skin1.skitType;
    if ([skitType isEqualToString:@"新年红"]) {
        rows = self.menuSecondNameArray[section].dataArray.count;
    }
    return rows;
}
//每个cell的具体内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //    NSString *skitType = Skin1.skitType;
    if ([skitType isEqualToString:@"新年红"]) {
        UGMineSkinCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UGMineSkinCollectionViewCell" forIndexPath:indexPath];
        UGUserCenterItem *uci = self.menuSecondNameArray[indexPath.section].dataArray[indexPath.row];
        cell.menuName = uci.name;
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:uci.logo] placeholderImage:[UIImage imageNamed:uci.lhImgName]];
        cell.badgeNum = uci.code==UCI_站内信 ? [UGUserModel currentUser].unreadMsg : 0;
        [cell setBackgroundColor: [UIColor clearColor]];
        cell.layer.borderWidth = 0.5;
        cell.layer.borderColor = UGRGBColor(231, 230, 230).CGColor;
        return cell;
    }
    else  if(Skin1.isJY) {
        JYMineCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JYMineCollectionViewCell" forIndexPath:indexPath];
        FastSubViewCode(cell);
        UGUserCenterItem *uci = self.menuNameArray[indexPath.row];
        cell.menuName = uci.name;
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:uci.logo] placeholderImage:[UIImage imageNamed:uci.lhImgName]];
        subLabel(@"红点Label").text = @([UGUserModel currentUser].unreadMsg).stringValue;
        subLabel(@"红点Label").hidden = !(uci.code==UCI_站内信 && [UGUserModel currentUser].unreadMsg);
        return cell;
    }
    else  {
        UGMineMenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UGMineMenuCollectionViewCell" forIndexPath:indexPath];
        UGUserCenterItem *uci = self.menuNameArray[indexPath.row];
        cell.menuName = uci.name;
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:uci.logo] placeholderImage:[UIImage imageNamed:uci.lhImgName]];
        cell.badgeNum = uci.code==UCI_站内信 ? [UGUserModel currentUser].unreadMsg : 0;
        [cell setBackgroundColor: [UIColor clearColor]];
        cell.layer.borderWidth = 0.5;
        
        if (Skin1.isTKL) {
            cell.layer.borderColor = UGRGBColor(231, 230, 230).CGColor;
        } else {
            cell.layer.borderColor = Skin1.isGPK ? [UIColor clearColor].CGColor : [[[UIColor whiteColor] colorWithAlphaComponent:0.9] CGColor];
        }
        
        return cell;
    }
    return nil;
}

//头尾视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"234234");
    
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        
        if ([skitType isEqualToString:@"新年红"]) {
            UGMineSkinFirstCollectionHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"UGMineSkinFirstCollectionHeadView" forIndexPath:indexPath];
            if(headerView == nil)
            {
                headerView = [[UGMineSkinFirstCollectionHeadView alloc] init];
            }
            
            UGMineSkinModel *model = [self.menuSecondNameArray objectAtIndex:indexPath.section];
            [headerView setMenuName :model.name];
            [headerView setBackgroundColor: [UIColor clearColor]];
            
            return headerView;
        }
        else  if([skitType isEqualToString:@"石榴红"]){
            UGSkinSeconCollectionHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"UGSkinSeconCollectionHeadView" forIndexPath:indexPath];
            if(headerView == nil)
            {
                headerView = [[UGSkinSeconCollectionHeadView alloc] init];
            }
            headerView.backgroundColor = [UIColor clearColor];
            
            return headerView;
        }
        else{
            
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
            if(headerView == nil)
            {
                headerView = [[UICollectionReusableView alloc] init];
            }
            headerView.backgroundColor = [UIColor clearColor];
            return headerView;
        }
        
        
        
    }
    
    
    
    return nil;
}


#pragma mark - UICollectionViewDelegate
//头视图尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if ([skitType isEqualToString:@"新年红"]) {
        CGSize size = {UGScreenW, 35};
        return size;
    }
    else  if([skitType isEqualToString:@"石榴红"]) {
        CGSize size = {UGScreenW, 80};
        return size;
    }
    else  if([skitType isEqualToString:@"经典"]||Skin1.isJY) {
        CGSize size = {UGScreenW, 0.1};
        return size;
    }
    else{
        CGSize size = {UGScreenW, 0.1};
        return size;
    }
}

//cell size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    float itemW = (APP.Width - 0.0 )/ 3.0;
    if ([skitType isEqualToString:@"新年红"]) {
        CGSize size = {itemW, 100};
        return size;
    }
    else if(Skin1.isJY){
        CGSize size = {APP.Width, 50};
        return size;
    }
    else {
        CGSize size = {itemW, itemW};
        return size;
    }
}

//item偏移
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
}

//行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if ([skitType isEqualToString:@"新年红"]) {
        UGUserCenterItem *uci = self.menuSecondNameArray[indexPath.section].dataArray[indexPath.row];
        [NavController1 pushVCWithUserCenterItemType:uci.code];
    } else  {
        UGUserCenterItem *uci = self.menuNameArray[indexPath.row];
        
        if (uci.code ==  UCI_在线客服) {
            if (APP.isSecondUrl) {
                NSString *urlStr = [SysConf.zxkfUrl2 stringByTrim];
                if (!urlStr.length) {
                    [CMCommon showTitle:@"请在后台配置在线客服链接->客服链接2"];
                    return;
                }
                SLWebViewController *webViewVC = [SLWebViewController new];
                NSURL *url = [NSURL URLWithString:urlStr];
                if (!url.host.length) {
                    urlStr = _NSString(@"%@%@", APP.Host, SysConf.zxkfUrl2);
                }
                else if (!url.scheme.length) {
                    urlStr = _NSString(@"http://%@", SysConf.zxkfUrl2);
                }
                webViewVC.isCustomerService = YES;
                webViewVC.urlStr = urlStr;
                [NavController1 pushViewController:webViewVC animated:YES];
            } else {
                [NavController1 pushVCWithUserCenterItemType:uci.code];
            }
        } else {
            [NavController1 pushVCWithUserCenterItemType:uci.code];
        }
    }
}


#pragma mark - 其他方法

// 任务中心
- (IBAction)showMissionVC:(id)sender {
    
    if (Skin1.isTKL) {
        //额度转换
        [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGBalanceConversionController")  animated:YES];
        
    } else {
        // 任务中心
        UIViewController *vc = [NavController1.viewControllers objectWithValue:UGMissionCenterViewController.class keyPath:@"class"];
        if (vc) {
            [NavController1 popToViewController:vc animated:false];
        } else {
            [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGMissionCenterViewController") animated:false];
        }
    }
    
}

// 每日签到
- (IBAction)showSign:(id)sender {
    
    if (Skin1.isTKL) {
        [QDAlertView showWithTitle:@"温馨提示" message:@"确定退出账号" cancelButtonTitle:@"取消" otherButtonTitle:@"确定" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [CMNetwork userLogoutWithParams:@{@"token":[UGUserModel currentUser].sessid} completion:nil];
                    UGUserModel.currentUser = nil;
                    SANotificationEventPost(UGNotificationUserLogout, nil);
                });
            }
        }];
    } else {
        [self.navigationController pushViewController:[UGSigInCodeViewController new] animated:YES];
    }
    
}

// 刷新余额
- (IBAction)refreshBalance:(id)sender {
    [self getUserInfo];
    
    if (sender) {
        __weakSelf_(__self);
        [CMNetwork needToTransferOutWithParams:@{@"token":UserI.token} completion:^(CMResult<id> *model, NSError *err) {
            BOOL needToTransferOut = [model.data[@"needToTransferOut"] boolValue];
            if (needToTransferOut) {
                UIAlertController *ac = [AlertHelper showAlertView:@"温馨提示" msg:@"真人游戏正在进行或有余额未成功转出，请确认是否需要转出游戏余额" btnTitles:@[@"取消", @"确认"]];
                [ac setActionAtTitle:@"确认" handler:^(UIAlertAction *aa) {
                    [CMNetwork autoTransferOutWithParams:@{@"token":[UGUserModel currentUser].sessid} completion:^(CMResult<id> *model, NSError *err) {
                        if (!err) {
                            [SVProgressHUD showSuccessWithStatus:@"转出成功"];
                            [__self getUserInfo];
                        }
                    }];
                }];
            }
        }];
    }
}

//刷新余额动画
- (void)startAnimation {
    CABasicAnimation *ReFreshAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    ReFreshAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
    ReFreshAnimation.duration = 1;
    ReFreshAnimation.repeatCount = HUGE_VALF;
    [self.refreshFirstButton.layer addAnimation:ReFreshAnimation forKey:@"rotationAnimation"];
}

//刷新余额动画
- (void)stopAnimation {
    [self.refreshFirstButton.layer removeAllAnimations];
}

- (CAShapeLayer *)containerLayer {
    if (!_containerLayer) {
        _containerLayer = [self defaultLayer];
        CGRect rect = (CGRect){(self.progressView.bounds.size.width-self.progressView.bounds.size.height)/2, 0, self.progressView.bounds.size.height, self.progressView.bounds.size.height};
        _containerLayer.path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:5].CGPath;
    }
    return _containerLayer;
}

- (UIBezierPath *)progressPathWithProgress:(CGFloat)progress {
    if (progress < 0.0001) { return nil; }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint startPoint = (CGPoint){-5, CGRectGetHeight(self.progressView.frame)/2};
    CGPoint endPoint = (CGPoint){CGRectGetWidth(self.progressView.frame)*progress, startPoint.y};
    [path moveToPoint:startPoint];
    [path addLineToPoint:endPoint];
    [path closePath];
    return path;
}

- (CAShapeLayer *)defaultLayer {
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = [UIColor grayColor].CGColor;
    layer.strokeColor = [UIColor grayColor].CGColor;
    layer.lineCap = kCALineCapRound;
    layer.lineJoin = kCALineJoinRound;
    layer.frame = self.progressView.bounds;
    return layer;
}

- (CAShapeLayer *)progressLayer {
    if (!_progressLayer) {
        _progressLayer = [self defaultLayer];
        _progressLayer.lineWidth = self.progressView.height;
        _progressLayer.strokeColor = Skin1.progressBgColor.CGColor;
    }
    return _progressLayer;
}

#pragma mark - UIS
- (void)setupUserInfo:(BOOL)flag  {
    UGUserModel *user = [UGUserModel currentUser];
    UGSystemConfigModel *config = [UGSystemConfigModel currentConfig];
    
    
    if (!Skin1.isTKL) {
        if ([config.missionSwitch isEqualToString:@"0"]) {
            [self.taskButton setHidden:NO];
            if ([config.checkinSwitch isEqualToString:@"0"]) {
                [self.signButton setHidden:YES];
            } else {
                [self.signButton setHidden:NO];
            }
        } else {
            [self.taskButton setHidden:YES];
            [self.signButton setHidden:YES];
        }
    }
    
    if (flag) {
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"touxiang-1"]];
    }
    
    self.userNameLabel.text = user.username;
    self.userVipLabel.text = user.curLevelGrade;
    self.fristVipLabel.text = user.curLevelGrade;
    NSString *imagerStr = [user.curLevelGrade lowercaseString];
    NSLog(@"imagerStr = %@",imagerStr);
    unreadMsg = user.unreadMsg;
    NSLog(@"unreadMsg = %d", (int)unreadMsg);
    
    self.secondVipLabel.text = user.nextLevelGrade;
    
    self.valueLabel.text = _NSString(@"成长值（%@-%@）", _FloatString4(user.taskRewardTotal.doubleValue), _FloatString4(user.nextLevelInt.doubleValue));
    
    if (![CMCommon stringIsNull:user.taskRewardTitle]) {
        self.moneyNameLabel.text = user.taskRewardTitle;
    }
    if (![CMCommon stringIsNull:user.taskRewardTotal]) {
        self.moenyNumberLabel.text = _FloatString4(user.taskReward.doubleValue);
    }
    
    double floatString = [user.balance doubleValue];
    self.userMoneyLabel.text =  [NSString stringWithFormat:@"￥%.2f",floatString];
    //进度条
    double progress = user.taskRewardTotal.doubleValue/user.nextLevelInt.doubleValue;
    self.progressLayer.path = [self progressPathWithProgress:progress].CGPath;
    
    if (![CMCommon stringIsNull:user.uid]) {
        self.uidLabel.text = [NSString stringWithFormat:@"UID:%@",user.uid];
    }
    else{
        self.uidLabel.text = @"";
    }
    
}


#pragma mark -- 网络请求

- (void)getUserInfo {
    [self startAnimation];
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid};
    WeakSelf;
    [CMNetwork getUserInfoWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            UGUserModel *user = model.data;
            UGUserModel *oldUser = [UGUserModel currentUser];
            user.sessid = oldUser.sessid;
            user.token = oldUser.token;
            UGUserModel.currentUser = user;
            NSLog(@"签到==%d",[UGUserModel currentUser].checkinSwitch);
            
            [weakSelf getSystemConfig];
            //            //初始化数据
            //            [self getDateSource];
        } failure:^(id msg) {
            [weakSelf stopAnimation];
        }];
    }];
}

- (void)getSystemConfig {
    WeakSelf;
    [CMNetwork getSystemConfigWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            UGSystemConfigModel *config = model.data;
            UGSystemConfigModel.currentConfig = config;
            NSLog(@"签到==%d",[UGSystemConfigModel  currentConfig].checkinSwitch);
            [weakSelf setupUserInfo:YES];
            [weakSelf stopAnimation];
            SANotificationEventPost(UGNotificationGetSystemConfigComplete, nil);
        } failure:^(id msg) {
            [SVProgressHUD dismiss];
        }];
    }];
}

- (IBAction)depositAction:(id)sender {
    
    //存款
    UGFundsViewController *fundsVC = _LoadVC_from_storyboard_(@"UGFundsViewController");
    fundsVC.selectIndex = 0;
    [self.navigationController pushViewController:fundsVC animated:YES];
    
    
}
- (IBAction)withdrawalActon:(id)sender {
    if (Skin1.isTKL) {
        //下注记录
        [NavController1 pushViewController:[UGBetRecordViewController new] animated:true];
    } else {
        //提现
        UGFundsViewController *fundsVC =  _LoadVC_from_storyboard_(@"UGFundsViewController");
        fundsVC.selectIndex = 1;
        [self.navigationController pushViewController:fundsVC animated:YES];
    }
}

- (IBAction)conversionAction:(id)sender {
    if (Skin1.isTKL) {
        //在线客服
        [NavController1 pushVCWithUserCenterItemType:UCI_在线客服];
    } else {
        //转换
        [self.navigationController pushViewController:_LoadVC_from_storyboard_(@"UGBalanceConversionController") animated:YES];
    }
    
}

// 领取俸禄
- (IBAction)goSalary:(id)sender {
    
    [self getMissionBonusList];
}
//获取俸禄列表数据
- (void)getMissionBonusList {
    
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid};
    
    [SVProgressHUD showWithStatus:nil];
    WeakSelf;
    [CMNetwork getMissionBonusListUrlWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            [SVProgressHUD dismiss];
            NSLog(@"model.data = %@",model.data);
            weakSelf.historyDataArray = model.data;
            NSLog(@"_historyDataArray = %@",self.historyDataArray);
            if (![CMCommon arryIsNull:self.historyDataArray]) {
                [weakSelf showUGSignInHistoryView];
            }
            
            
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }];
    
}

#pragma mark -- 其他方法

- (void)showUGSignInHistoryView {
    
    UGSalaryListView *notiveView = [[UGSalaryListView alloc] initWithFrame:CGRectMake(20, 120, UGScreenW - 40, UGScerrnH - 260)];
    notiveView.dataArray = self.historyDataArray;
    [notiveView.bgView setBackgroundColor: Skin1.navBarBgColor];
    
    [notiveView show];
    
}

@end
