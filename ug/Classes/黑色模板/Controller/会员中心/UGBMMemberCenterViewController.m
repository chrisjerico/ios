//
//  UGBMMemberCenterViewController.m
//  ug
//
//  Created by ug on 2019/11/4.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGBMMemberCenterViewController.h"
#import "UGBMHeaderView.h"
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

#import "UGBMUnderMenuView.h"

@interface UGBMMemberCenterViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
     UGBMHeaderView *headView;                /**<   导航头 */
     NSInteger unreadMsg;
}
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *userMoneyLabel;    /**<  显示余额 */
@property (weak, nonatomic) IBOutlet UIButton *refreshFirstButton; /**<  刷新按钮 */

@property (weak, nonatomic) IBOutlet UIView *titleView;                 /**<   会员View*/
@property (weak, nonatomic) IBOutlet UIView *titleLineView;              /**<   会员下面的线 */
@property (weak, nonatomic) IBOutlet UIView *titleUpLineView;              /**<  会员上面的线 */
@property (weak, nonatomic) IBOutlet UIView *title2View;                 /**<   账户余额View*/
@property (weak, nonatomic) IBOutlet UIView *title2LineView;              /**<   账户余额下面的线 */
//===================================================
@property (nonatomic, strong) NSMutableArray <UGUserCenterItem *> *menuNameArray;

@property (nonatomic, strong)UGBMUnderMenuView *underMenu;

@property (nonatomic, copy) NSArray<UGUserCenterItem *> *gms; /**<   行数据 */

@end

@implementation UGBMMemberCenterViewController

- (BOOL)允许未登录访问 { return false; }
- (BOOL)允许游客访问 { return false; }

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];//强制隐藏NavBar
    [headView.leftwardMarqueeView start];
//    [self.view layoutSubviews];
    if (!self.menuNameArray.count) {
       [self refreshBalance:nil];
    }
    // 强制显示tabbar
        self.tabBarController.tabBar.hidden = NO;


}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [headView.leftwardMarqueeView pause];//fixbug  发热  掉电快
    [self.refreshFirstButton.layer removeAllAnimations];
    
//    // 强制隐藏tabbar
//    NSArray *views = self.tabBarController.view.subviews;
//    UIView *contentView = [views objectAtIndex:0];
//    contentView.height += k_Height_TabBar;
//    self.tabBarController.tabBar.hidden = YES;

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.refreshFirstButton.selected)
        [self startAnimation];
    self.fd_interactivePopDisabled = true;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self setupUserInfo:true];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    SANotificationEventSubscribe(UGNotificationGetUserInfoComplete, self, ^(typeof (self) self, id obj) {
        [self.refreshFirstButton.layer removeAllAnimations];
        [self setupUserInfo:NO];
        [self.myCollectionView reloadData];
    });
    self.navigationItem.title = @"会员中心";
    self.fd_prefersNavigationBarHidden = YES;
    [self.view setBackgroundColor: Skin1.bgColor];
    
    
    if ([Skin1.skitString isEqualToString:@"GPK版香槟金"]) {
        _titleLineView.backgroundColor = Skin1.bgColor;
        _titleUpLineView.backgroundColor = Skin1.bgColor;
        _title2LineView.backgroundColor = Skin1.bgColor;
    }
    _title2View.backgroundColor = Skin1.bgColor;
    NSMutableArray <UIColor *> *colors = @[].mutableCopy;
    [colors addObject:Skin1.navBarBgColor];
    [colors addObject:Skin1.bgColor];
    self.titleView.backgroundColor =  [UIColor colorWithPatternImage:[UIImage gradientImageWithBounds:self.titleView.bounds andColors:colors andGradientType:GradientDirectionTopToBottom]];
    [self creatView];

    //初始化
    [self initCollectionView];
    
    __weakSelf_(__self);
    __self.menuNameArray = @[].mutableCopy;
    [__self.menuNameArray setArray:SysConf.userCenter];
    [__self.myCollectionView reloadData];
    SANotificationEventSubscribe(UGNotificationGetSystemConfigComplete, self, ^(typeof (self) self, id obj) {
        [__self.menuNameArray setArray:SysConf.userCenter];
        [__self.myCollectionView reloadData];
    });

    
    
//    if (self.tabBarController.tabBar.isHidden) {
//         self.underMenu = [[UGBMUnderMenuView alloc] initView];
//    } else {
         self.underMenu = [[UGBMUnderMenuView alloc] initViewWithStatusBar];
//    }
   
    [self.view addSubview:self.underMenu];
}

-(void)creatView{
    //===============导航头布局=================
       headView = [[UGBMHeaderView alloc] initView];
       [self.view addSubview:headView];
       [headView mas_makeConstraints:^(MASConstraintMaker *make) { //数组额你不必须都是view
           make.top.equalTo(self.view.mas_top).with.offset(k_Height_StatusBar);
           make.left.equalTo(self.view.mas_left).offset(0);
           make.height.equalTo([NSNumber numberWithFloat:110]);
           make.width.equalTo([NSNumber numberWithFloat:UGScreenW]);
       }];
}

- (void)initCollectionView {

        self.myCollectionView.backgroundColor = Skin1.bgColor;
        self.myCollectionView.dataSource = self;
        self.myCollectionView.delegate = self;
        [self.myCollectionView registerNib:[UINib nibWithNibName:@"UGMineMenuCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"UGMineMenuCollectionViewCell"];
        [self.myCollectionView registerNib:[UINib nibWithNibName:@"UGMineSkinCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"UGMineSkinCollectionViewCell"];
    [self.myCollectionView setShowsHorizontalScrollIndicator:NO];
    
//    //初始化数据
//    [self getDateSource];
}

#pragma mark UICollectionView datasource
//collectionView有几个section
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    int sections = 1;
    return sections;
}
//每个section有几个item
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger rows = self.menuNameArray.count;
    return rows;
}

//每个cell的具体内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UGMineMenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UGMineMenuCollectionViewCell" forIndexPath:indexPath];
    UGUserCenterItem *uci = self.menuNameArray[indexPath.row];
    cell.menuName = uci.name;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:uci.logo] placeholderImage:[UIImage imageNamed:uci.lhImgName]];
    cell.badgeNum = uci.code==UCI_站内信 ? [UGUserModel currentUser].unreadMsg : 0;
    [cell setBackgroundColor: [UIColor clearColor]];
    return cell;
}

//cell size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    float itemW = (APP.Width - 0.0 )/ 3.0;
    CGSize size = {itemW, itemW};
    return size;
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
    
    UGUserCenterItem *uci =  self.menuNameArray[indexPath.row];
    [NavController1 pushVCWithUserCenterItemType:uci.code];
}


#pragma mark 数据 datasource

- (UIImage *)retureWhiteColorImage:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    UIImage *afterImage = [image qmui_imageWithTintColor:[UIColor whiteColor]];
    return afterImage;
}

#pragma mark - UIS
- (void)setupUserInfo:(BOOL)flag  {
    UGUserModel *user = [UGUserModel currentUser];
    unreadMsg = user.unreadMsg;

    self.userMoneyLabel.text =  [NSString stringWithFormat:@"账户余额 ￥ %@",user.balance];
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
            [weakSelf setupUserInfo:YES];
            [weakSelf stopAnimation];
            [weakSelf getSystemConfig];
        } failure:^(id msg) {
            [weakSelf stopAnimation];
        }];
    }];
}

- (void)getSystemConfig {
    
    [CMNetwork getSystemConfigWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            UGSystemConfigModel *config = model.data;
            UGSystemConfigModel.currentConfig = config;
            NSLog(@"签到==%@",[UGSystemConfigModel  currentConfig].checkinSwitch);
            SANotificationEventPost(UGNotificationGetSystemConfigComplete, nil);
        } failure:^(id msg) {
            [SVProgressHUD dismiss];
        }];
    }];
}
#pragma mark - 其他方法
// 刷新余额
- (IBAction)refreshBalance:(id)sender {
    [self getUserInfo];
    
    if (sender) {
        __weakSelf_(__self);
        [CMNetwork needToTransferOutWithParams:@{@"token":UserI.token} completion:^(CMResult<id> *model, NSError *err) {
            BOOL needToTransferOut = [model.data[@"needToTransferOut"] boolValue];
            if (needToTransferOut && !APP.isNoAlert) {
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
@end
