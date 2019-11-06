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
#import "UGMailBoxTableViewController.h"
#import "UGBetRecordViewController.h"
#import "UGRealBetRecordViewController.h"
#import "UGUserInfoViewController.h"
#import "UGUserInfoViewController.h"
#import "UGUserInfoViewController.h"
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
     NSString *unreadMsg;
}
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *userMoneyLabel;    /**<  显示余额 */
@property (weak, nonatomic) IBOutlet UIButton *refreshFirstButton; /**<  刷新按钮 */
//===================================================
@property (nonatomic, strong) NSMutableArray *menuNameArray;

@property (nonatomic, strong)UGBMUnderMenuView *underMenu;

@end

@implementation UGBMMemberCenterViewController

- (BOOL)允许未登录访问 { return true; }
- (BOOL)允许游客访问 { return true; }

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];//强制隐藏NavBar
    [headView.leftwardMarqueeView start];
    [self.view layoutSubviews];
    if (!self.menuNameArray.count) {
       [self refreshBalance:nil];
    }
    // 强制显示tabbar
//       NSArray *views = self.tabBarController.view.subviews;
//       UIView *contentView = [views objectAtIndex:0];
//       contentView.height -= k_Height_TabBar;
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
    [self creatView];

    //初始化
    [self initCollectionView];
    
    
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
    
    //初始化数据
    [self getDateSource];
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
        NSDictionary *dic = [self.menuNameArray objectAtIndex:indexPath.row];
        [cell setMenuName: [dic objectForKey:@"title"]];
        cell.imageView.image = [dic objectForKey:@"imgName"];
        if ([[dic objectForKey:@"title"] isEqualToString:@"站内信"]) {
            if (![CMCommon stringIsNull:unreadMsg])
                [cell setBadgeNum:[unreadMsg intValue]];
        }
        else{
            [cell setBadgeNum:0];
        }
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
    NSString *title;
    title =  self.menuNameArray[indexPath.row][@"title"];
    if ([title isEqualToString:@"存款"]) {
        UGFundsViewController *fundsVC = [[UGFundsViewController alloc] init];
        fundsVC.selectIndex = 0;
        [self.navigationController pushViewController:fundsVC animated:YES];
    }
    else if ([title isEqualToString:@"取款"]) {
        UGFundsViewController *fundsVC = [[UGFundsViewController alloc] init];
        fundsVC.selectIndex = 1;
        [self.navigationController pushViewController:fundsVC animated:YES];
    }
    else if ([title isEqualToString:@"在线客服"]) {
        SLWebViewController *webViewVC = [[SLWebViewController alloc] init];
        webViewVC.urlStr = SysConf.zxkfUrl;
        [self.navigationController pushViewController:webViewVC animated:YES];
    }
    else if ([title isEqualToString:@"银行卡管理"]) {
        [self.navigationController pushViewController:({
            UIViewController *vc = nil;
            UGUserModel *user = [UGUserModel currentUser];
            if (user.hasBankCard) {
                vc = _LoadVC_from_storyboard_(@"UGBankCardInfoController");
            } else if (user.hasFundPwd) {
                vc = _LoadVC_from_storyboard_(@"UGBindCardViewController");
            } else {
                vc = _LoadVC_from_storyboard_(@"UGSetupPayPwdController");
            }
            vc;
        }) animated:YES];
    }
    else if ([title isEqualToString:@"利息宝"]) {
        [self.navigationController pushViewController:_LoadVC_from_storyboard_(@"UGYubaoViewController")  animated:YES];
    }
    else if ([title isEqualToString:@"额度转换"]) {
        [self.navigationController pushViewController:_LoadVC_from_storyboard_(@"UGBalanceConversionController")  animated:YES];
    }
    else if ([title isEqualToString:@"申请代理"] || [title isEqualToString:@"推荐收益"]) {
        if (UserI.isTest) {
            [self.navigationController pushViewController:[UGPromotionIncomeController new] animated:YES];
        } else {
            [SVProgressHUD showWithStatus:nil];
            [CMNetwork teamAgentApplyInfoWithParams:@{@"token":[UGUserModel currentUser].sessid} completion:^(CMResult<id> *model, NSError *err) {
                [CMResult processWithResult:model success:^{
                    [SVProgressHUD dismiss];
                    UGagentApplyInfo *obj  = (UGagentApplyInfo *)model.data;
                    int intStatus = obj.reviewStatus.intValue;
                    
                    //0 未提交  1 待审核  2 审核通过 3 审核拒绝
                    if (intStatus == 2) {
                        [self.navigationController pushViewController:[UGPromotionIncomeController new] animated:YES];
                    } else {
                        if (![SysConf.agent_m_apply isEqualToString:@"1"]) {
                            [HUDHelper showMsg:@"在线注册代理已关闭"];
                            return ;
                        }
                        UGAgentViewController *vc = [[UGAgentViewController alloc] init];
                        vc.item = obj;
                        [NavController1 pushViewController:vc animated:YES];
                    }
                } failure:^(id msg) {
                    [SVProgressHUD showErrorWithStatus:msg];
                }];
            }];
        }
    }
    else if ([title isEqualToString:@"安全中心"]) {
        [self.navigationController pushViewController:[UGSecurityCenterViewController new] animated:YES];
    } else if ([title isEqualToString:@"站内信"]) {
        [self.navigationController pushViewController:[[UGMailBoxTableViewController alloc] initWithStyle:UITableViewStyleGrouped] animated:YES];
    } else if([title isEqualToString:@"彩票注单记录"]) {
        [self.navigationController pushViewController:[UGBetRecordViewController new] animated:YES];
    } else if ([title isEqualToString:@"其他注单记录"]) {
        UGRealBetRecordViewController *betRecordVC = _LoadVC_from_storyboard_(@"UGRealBetRecordViewController");
        betRecordVC.gameType = @"real";
        [self.navigationController pushViewController:betRecordVC animated:YES];
    } else if ([title isEqualToString:@"个人信息"]) {
        [self.navigationController pushViewController:_LoadVC_from_storyboard_(@"UGUserInfoViewController") animated:YES];
    }
    else if ([title isEqualToString:@"建议反馈"]) {
        [self.navigationController pushViewController:_LoadVC_from_storyboard_(@"UGFeedBackController") animated:YES];
    }
    else if ([title isEqualToString:@"活动彩金"]) {
        [self.navigationController pushViewController:[UGMosaicGoldViewController new] animated:YES];
    }
    else if ([title isEqualToString:@"长龙助手"]) {
        [self.navigationController pushViewController:[UGChangLongController new] animated:YES];
    }
}


#pragma mark 数据 datasource

- (UIImage *)retureWhiteColorImage:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    UIImage *afterImage = [image qmui_imageWithTintColor:[UIColor whiteColor]];
    return afterImage;
}

- (void)skinFirstdataSource {

    self.menuNameArray = [NSMutableArray array];
    UGUserModel *user = [UGUserModel currentUser];
    NSLog(@"isAgent= %d",user.isAgent);
    
    if (user.isAgent) {
        [self.menuNameArray addObject:@{@"title" : @"存款" , @"imgName" : [self retureWhiteColorImage:@"chongzhi"] }];
        [self.menuNameArray addObject:@{@"title" : @"取款" , @"imgName" :  [self retureWhiteColorImage:@"tixian"]}];
        [self.menuNameArray addObject:@{@"title" : @"利息宝" , @"imgName" : [self retureWhiteColorImage:@"lixibao"]}];
        
        [self.menuNameArray addObject:@{@"title" : @"在线客服" , @"imgName" : [self retureWhiteColorImage:@"zaixiankefu"]}];
        [self.menuNameArray addObject:@{@"title" : @"银行卡管理" , @"imgName" : [self retureWhiteColorImage:@"yinhangqia"]}];
        [self.menuNameArray addObject:@{@"title" : @"彩票注单记录" , @"imgName" :[self retureWhiteColorImage:@"zdgl"]}];
        
         [self.menuNameArray addObject:@{@"title" : @"其他注单记录" , @"imgName" :[self retureWhiteColorImage:@"zdgl"]}];
         [self.menuNameArray addObject:@{@"title" : @"额度转换" , @"imgName" : [self retureWhiteColorImage:@"change"]}];
         [self.menuNameArray addObject:@{@"title" : @"长龙助手" , @"imgName" : [self retureWhiteColorImage:@"changlong"]}];
        
        [self.menuNameArray addObject:@{@"title" : @"推荐收益" , @"imgName" : [self retureWhiteColorImage:@"shouyi1sel"]}];
        [self.menuNameArray addObject:@{@"title" : @"安全中心" , @"imgName" : [self retureWhiteColorImage:@"ziyuan"]}];
        [self.menuNameArray addObject:@{@"title" : @"站内信" , @"imgName" :[self retureWhiteColorImage:@"zhanneixin"]}];
     
        [self.menuNameArray addObject:@{@"title" : @"个人信息" , @"imgName" : [self retureWhiteColorImage:@"gerenzhongxinxuanzhong"]}];
        [self.menuNameArray addObject:@{@"title" : @"建议反馈" , @"imgName" :[self retureWhiteColorImage:@"yijian"]}];
        
        if (user.hasActLottery) {
            [self.menuNameArray addObject:@{@"title" : @"活动彩金" , @"imgName" : [self retureWhiteColorImage:@"zdgl"]}];
        }
        
    } else {
        [self.menuNameArray addObject:@{@"title" : @"存款" , @"imgName" : [self retureWhiteColorImage:@"chongzhi"] }];
        [self.menuNameArray addObject:@{@"title" : @"取款" , @"imgName" :  [self retureWhiteColorImage:@"tixian"]}];
        [self.menuNameArray addObject:@{@"title" : @"利息宝" , @"imgName" : [self retureWhiteColorImage:@"lixibao"]}];
        
        [self.menuNameArray addObject:@{@"title" : @"在线客服" , @"imgName" : [self retureWhiteColorImage:@"zaixiankefu"]}];
        [self.menuNameArray addObject:@{@"title" : @"银行卡管理" , @"imgName" : [self retureWhiteColorImage:@"yinhangqia"]}];
        [self.menuNameArray addObject:@{@"title" : @"彩票注单记录" , @"imgName" :[self retureWhiteColorImage:@"zdgl"]}];

        [self.menuNameArray addObject:@{@"title" : @"其他注单记录" , @"imgName" :[self retureWhiteColorImage:@"zdgl"]}];
        [self.menuNameArray addObject:@{@"title" : @"额度转换" , @"imgName" : [self retureWhiteColorImage:@"change"]}];
        [self.menuNameArray addObject:@{@"title" : @"长龙助手" , @"imgName" : [self retureWhiteColorImage:@"changlong"]}];
        
        [self.menuNameArray addObject:@{@"title" : @"申请代理" , @"imgName" : [self retureWhiteColorImage:@"shouyi1sel"]}];
        [self.menuNameArray addObject:@{@"title" : @"安全中心" , @"imgName" : [self retureWhiteColorImage:@"ziyuan"]}];
        [self.menuNameArray addObject:@{@"title" : @"站内信" , @"imgName" :[self retureWhiteColorImage:@"zhanneixin"]}];
        
        [self.menuNameArray addObject:@{@"title" : @"个人信息" , @"imgName" : [self retureWhiteColorImage:@"gerenzhongxinxuanzhong"]}];
        [self.menuNameArray addObject:@{@"title" : @"建议反馈" , @"imgName" :[self retureWhiteColorImage:@"yijian"]}];
        if (user.hasActLottery) {
            [self.menuNameArray addObject:@{@"title" : @"活动彩金" , @"imgName" : [self retureWhiteColorImage:@"zdgl"]}];
        }
    }
}

- (void)getDateSource{
    [self skinFirstdataSource];
    [self.myCollectionView reloadData];
}
#pragma mark - UIS
- (void)setupUserInfo:(BOOL)flag  {
    UGUserModel *user = [UGUserModel currentUser];
    unreadMsg = user.unreadMsg;
    double floatString = [user.balance doubleValue];
    self.userMoneyLabel.text =  [NSString stringWithFormat:@"账户余额 ￥ %.2f",floatString];
}

#pragma mark -- 网络请求
- (void)getUserInfo {
    [self startAnimation];
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid};
    [CMNetwork getUserInfoWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            UGUserModel *user = model.data;
            UGUserModel *oldUser = [UGUserModel currentUser];
            user.sessid = oldUser.sessid;
            user.token = oldUser.token;
            UGUserModel.currentUser = user;
            [self setupUserInfo:YES];
            [self stopAnimation];
            //初始化数据
            [self getDateSource];
        } failure:^(id msg) {
            [self stopAnimation];
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
@end
