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
@interface UGMineSkinViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSString *skitType;
    NSInteger unreadMsg;
}
@property (weak, nonatomic) IBOutlet UIView *userInfoView;
@property (weak, nonatomic) IBOutlet UIView *topupView;
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
@property (weak, nonatomic) IBOutlet UIButton *taskButton;
@property (weak, nonatomic) IBOutlet UIButton *signButton;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) CAShapeLayer *containerLayer;
//===================================================

@property (weak, nonatomic) IBOutlet UIButton *topupButton;
@property (weak, nonatomic) IBOutlet UIButton *withdrawalsButton;
@property (weak, nonatomic) IBOutlet UIButton *conversionButton;

@property (strong, nonatomic)UGYYRightMenuView *yymenuView;   /**<   侧边栏 */

//===================================================
@property (nonatomic, strong) NSMutableArray *menuNameArray;
@property (nonatomic, strong) NSMutableArray<UGMineSkinModel *> *menuSecondNameArray;

@property (nonatomic, copy) NSArray<UGUserCenter *> *gms; /**<   行数据 */

@end

@implementation UGMineSkinViewController

- (void)skin {
    [self.userInfoView setBackgroundColor: Skin1.navBarBgColor];
    
    [self.view setBackgroundColor: Skin1.bgColor];
    
    [self.myCollectionView setBackgroundColor: Skin1.bgColor];
    _progressLayer.strokeColor = Skin1.progressBgColor.CGColor;
    [self.progressView.layer addSublayer:self.progressLayer];
    
    
    skitType = Skin1.skitType;
    if ([skitType isEqualToString:@"经典"]) {
        self.topupView.hidden = YES;
        self.topupViewNSLayoutConstraintHight.constant = 0.1;
    }
    else if ([skitType isEqualToString:@"六合资料"]) {//六合资料
        self.topupView.hidden = YES;
        self.topupViewNSLayoutConstraintHight.constant = 0.1;
    }
    else {
        self.topupView.hidden = NO;
        self.topupViewNSLayoutConstraintHight.constant = 63;
    }
    [self.myCollectionView reloadData];
}

- (BOOL)允许游客访问 { return true; }

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view layoutSubviews];
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

- (void)showAvaterSelectView {
    if (UserI.isTest) {
        return;
    }
    UGAvaterSelectView *avaterView = [[UGAvaterSelectView alloc] initWithFrame:CGRectMake(0, UGScerrnH, UGScreenW, UGScreenW)];
    [avaterView show];
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    self.navigationItem.title = @"我的";
    self.headImageView.layer.cornerRadius = self.headImageView.height / 2 ;
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAvaterSelectView)];
    [self.headImageView addGestureRecognizer:tap];
    [self.progressView.layer addSublayer:self.progressLayer];
    self.progressView.layer.cornerRadius = self.progressView.height / 2;
    self.progressView.layer.masksToBounds = YES;
    self.progressView.backgroundColor = UGRGBColor(213, 224, 237);
//    self.topupView.backgroundColor = Skin1.navBarBgColor;
//    FastSubViewCode(self.topupView);
//    subLabel(@"存款Label").textColor = Skin1.textColor1;
//    subLabel(@"提现Label").textColor = Skin1.textColor1;
//    subLabel(@"转换Label").textColor = Skin1.textColor1;
    
    
    //设置皮肤
    [self.view setBackgroundColor:Skin1.bgColor];
    [self.userInfoView setBackgroundColor: Skin1.navBarBgColor];
    
    
    skitType = Skin1.skitType;
    
    if ([skitType isEqualToString:@"经典"] || [skitType isEqualToString:@"六合资料"]) {
        self.topupView.hidden = YES;
        self.topupViewNSLayoutConstraintHight.constant = 0.1;
    }
    else {
        self.topupView.hidden = NO;
        self.topupViewNSLayoutConstraintHight.constant = 63;
        [CMCommon setBorderWithView:self.topupView top:NO left:NO bottom:YES right:NO borderColor: UGRGBColor(236, 235, 235) borderWidth:1];
    }
    
    self.navigationItem.rightBarButtonItem = [STBarButtonItem barButtonItemWithImageName:@"gengduo" target:self action:@selector(rightBarBtnClick)];
    
//    //test用
//    [self addRightBtn];
    
    
    _gms = @[
        [UGUserCenter menu:@"存款"                     :@"chongzhi"],
        [UGUserCenter menu:@"取款"                      :@"tixian"],
        [UGUserCenter menu:@"在线客服"                    :@"zaixiankefu"],
        [UGUserCenter menu:@"银行卡管理"                   :@"yinhangqia"],
        [UGUserCenter menu:@"利息宝"                     :@"lixibao"],
        [UGUserCenter menu:@"额度转换"                   :@"change"],
        [UGUserCenter menu:@"推荐收益"                    :@"shouyi1sel"],
        [UGUserCenter menu:@"收益推荐"                    :@"shouyi1sel"],
        [UGUserCenter menu:@"长龙助手"                    :@"changlong"],
        [UGUserCenter menu:@"安全中心"                    :@"ziyuan"],
        [UGUserCenter menu:@"站内信"                    :@"zhanneixin"],
        [UGUserCenter menu:@"彩票注单记录"                  :@"zdgl"],
        [UGUserCenter menu:@"其他注单记录"                  :@"zdgl"],
        [UGUserCenter menu:@"个人信息"                        :@"gerenzhongxinxuanzhong"],
        [UGUserCenter menu:@"建议反馈"                    :@"yijian"],
        [UGUserCenter menu:@"活动彩金"                    :@"zdgl"],
        [UGUserCenter menu:@"代理申请"                   :@"shouyi1sel"],
        [UGUserCenter menu:@"任务中心"                   :@"BMrenwu"],

    ];
    
    {
         NSArray<UGmobileMenu *> *menus = [[UGUserCenter arrayOfModelsFromDictionaries:SysConf.userCenter error:nil] sortedArrayUsingComparator:^NSComparisonResult(UGUserCenter *obj1, UGUserCenter *obj2) {
             return obj1.sort > obj2.sort;
         }];
         if (menus.count > 0) {
             // 后台配置的页面
             [self resetUpTabCellData:menus];
         }
     }
     SANotificationEventSubscribe(UGNotificationGetSystemConfigComplete, self, ^(typeof (self) self, id obj) {
         NSArray<UGmobileMenu *> *menus = [[UGUserCenter arrayOfModelsFromDictionaries:SysConf.userCenter error:nil] sortedArrayUsingComparator:^NSComparisonResult(UGUserCenter *obj1, UGUserCenter *obj2) {
             return obj1.sort > obj2.sort;
         }];
         if (menus.count > 0) {
             // 后台配置的页面
             [self resetUpTabCellData:menus];
         }
     });

    //初始化
    [self initCollectionView];
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

//- (void)getDateSource{
//    [self skinSeconddataSource];
//    [self skinFirstdataSource];
//
//    [self.myCollectionView reloadData];
//}


- (UIImage *)retureRandomThemeColorImage:(NSString *)imageName {
    UIColor *tintColor = Skin1.isBlack ? [UIColor whiteColor] : [UGSkinManagers randomThemeColor];
    return [[UIImage imageNamed:imageName] qmui_imageWithTintColor:tintColor];
}
//- (void)skinFirstdataSource {
//    //经典+石榴红
//    self.menuNameArray = [NSMutableArray array];
//    UGUserModel *user = [UGUserModel currentUser];
//    NSLog(@"isAgent= %d",user.isAgent);
//    
//    if (user.isAgent) {
//        [self.menuNameArray addObject:@{@"title" : @"存款" , @"imgName" : [self retureRandomThemeColorImage:@"chongzhi"] }];
//        [self.menuNameArray addObject:@{@"title" : @"取款" , @"imgName" :  [self retureRandomThemeColorImage:@"tixian"]}];
//        [self.menuNameArray addObject:@{@"title" : @"利息宝" , @"imgName" : [self retureRandomThemeColorImage:@"lixibao"]}];
//        
//        [self.menuNameArray addObject:@{@"title" : @"在线客服" , @"imgName" : [self retureRandomThemeColorImage:@"zaixiankefu"]}];
//        [self.menuNameArray addObject:@{@"title" : @"银行卡管理" , @"imgName" : [self retureRandomThemeColorImage:@"yinhangqia"]}];
//        [self.menuNameArray addObject:@{@"title" : @"彩票注单记录" , @"imgName" :[self retureRandomThemeColorImage:@"zdgl"]}];
//        
//         [self.menuNameArray addObject:@{@"title" : @"其他注单记录" , @"imgName" :[self retureRandomThemeColorImage:@"zdgl"]}];
//         [self.menuNameArray addObject:@{@"title" : @"额度转换" , @"imgName" : [self retureRandomThemeColorImage:@"change"]}];
//         [self.menuNameArray addObject:@{@"title" : @"长龙助手" , @"imgName" : [self retureRandomThemeColorImage:@"changlong"]}];
//        
//        [self.menuNameArray addObject:@{@"title" : @"推荐收益" , @"imgName" : [self retureRandomThemeColorImage:@"shouyi1sel"]}];
//        [self.menuNameArray addObject:@{@"title" : @"安全中心" , @"imgName" : [self retureRandomThemeColorImage:@"ziyuan"]}];
//        [self.menuNameArray addObject:@{@"title" : @"站内信" , @"imgName" :[self retureRandomThemeColorImage:@"zhanneixin"]}];
//     
//        [self.menuNameArray addObject:@{@"title" : @"个人信息" , @"imgName" : [self retureRandomThemeColorImage:@"gerenzhongxinxuanzhong"]}];
//        [self.menuNameArray addObject:@{@"title" : @"建议反馈" , @"imgName" :[self retureRandomThemeColorImage:@"yijian"]}];
//        
//        if (user.hasActLottery) {
//            [self.menuNameArray addObject:@{@"title" : @"活动彩金" , @"imgName" : [self retureRandomThemeColorImage:@"zdgl"]}];
//        }
//        
//    } else {
//        [self.menuNameArray addObject:@{@"title" : @"存款" , @"imgName" : [self retureRandomThemeColorImage:@"chongzhi"] }];
//        [self.menuNameArray addObject:@{@"title" : @"取款" , @"imgName" :  [self retureRandomThemeColorImage:@"tixian"]}];
//        [self.menuNameArray addObject:@{@"title" : @"利息宝" , @"imgName" : [self retureRandomThemeColorImage:@"lixibao"]}];
//        
//        [self.menuNameArray addObject:@{@"title" : @"在线客服" , @"imgName" : [self retureRandomThemeColorImage:@"zaixiankefu"]}];
//        [self.menuNameArray addObject:@{@"title" : @"银行卡管理" , @"imgName" : [self retureRandomThemeColorImage:@"yinhangqia"]}];
//        [self.menuNameArray addObject:@{@"title" : @"彩票注单记录" , @"imgName" :[self retureRandomThemeColorImage:@"zdgl"]}];
//
//        [self.menuNameArray addObject:@{@"title" : @"其他注单记录" , @"imgName" :[self retureRandomThemeColorImage:@"zdgl"]}];
//        [self.menuNameArray addObject:@{@"title" : @"额度转换" , @"imgName" : [self retureRandomThemeColorImage:@"change"]}];
//        [self.menuNameArray addObject:@{@"title" : @"长龙助手" , @"imgName" : [self retureRandomThemeColorImage:@"changlong"]}];
//        
//        [self.menuNameArray addObject:@{@"title" : @"申请代理" , @"imgName" : [self retureRandomThemeColorImage:@"shouyi1sel"]}];
//        [self.menuNameArray addObject:@{@"title" : @"安全中心" , @"imgName" : [self retureRandomThemeColorImage:@"ziyuan"]}];
//        [self.menuNameArray addObject:@{@"title" : @"站内信" , @"imgName" :[self retureRandomThemeColorImage:@"zhanneixin"]}];
//        
//        [self.menuNameArray addObject:@{@"title" : @"个人信息" , @"imgName" : [self retureRandomThemeColorImage:@"gerenzhongxinxuanzhong"]}];
//        [self.menuNameArray addObject:@{@"title" : @"建议反馈" , @"imgName" :[self retureRandomThemeColorImage:@"yijian"]}];
//        if (user.hasActLottery) {
//            [self.menuNameArray addObject:@{@"title" : @"活动彩金" , @"imgName" : [self retureRandomThemeColorImage:@"zdgl"]}];
//        }
//    }
//}

- (void)skinSeconddataSource{
    //新年红
    self.menuSecondNameArray = [NSMutableArray array];
    {
         NSMutableArray *dataArrayOne = [NSMutableArray array];
        UGUserModel *user = [UGUserModel currentUser];
        NSLog(@"isAgent= %d",user.isAgent);
        NSLog(@"hasActLottery= %d",user.hasActLottery);
        if (user.isAgent) {
            [dataArrayOne addObject:@{@"title" : @"推荐收益" , @"imgName" :  [self retureRandomThemeColorImage:@"shouyi1sel"]}];
            
            if (user.hasActLottery) {
                 [dataArrayOne addObject:@{@"title" : @"活动彩金" , @"imgName" : [self retureRandomThemeColorImage:@"zdgl"]}];
            }
           
            [dataArrayOne addObject:@{@"title" : @"利息宝" , @"imgName" : [self retureRandomThemeColorImage:@"lixibao"]}];
            [dataArrayOne addObject:@{@"title" : @"在线客服" , @"imgName" : [self retureRandomThemeColorImage:@"zaixiankefu"]}];
        }
        else{
            [dataArrayOne addObject:@{@"title" : @"申请代理" , @"imgName" :  [self retureRandomThemeColorImage:@"shouyi1sel"]}];
            if (user.hasActLottery) {
                [dataArrayOne addObject:@{@"title" : @"活动彩金" , @"imgName" : [self retureRandomThemeColorImage:@"zdgl"]}];
            }
            [dataArrayOne addObject:@{@"title" : @"利息宝" , @"imgName" : [self retureRandomThemeColorImage:@"lixibao"]}];
            [dataArrayOne addObject:@{@"title" : @"在线客服" , @"imgName" : [self retureRandomThemeColorImage:@"zaixiankefu"]}];
        }
        UGMineSkinModel *dic1 = [UGMineSkinModel new];
        
        [dic1 setName:@"我的"];
        [dic1 setDataArray:dataArrayOne];
        
        [self.menuSecondNameArray addObject:dic1];
    }
    
    //=======================================
    {
        NSMutableArray *dataArrayOne = [NSMutableArray array];
        [dataArrayOne addObject:@{@"title" : @"彩票注单记录" , @"imgName" :[self retureRandomThemeColorImage:@"zdgl"]}];
        [dataArrayOne addObject:@{@"title" : @"其他注单记录" , @"imgName" :[self retureRandomThemeColorImage:@"zdgl"]}];
        
        UGMineSkinModel *dic1 = [UGMineSkinModel new];
        
        [dic1 setName:@"注单详情"];
        [dic1 setDataArray:dataArrayOne];
        
        [self.menuSecondNameArray addObject:dic1];
        
    }
    
    //=======================================
    {
        NSMutableArray *dataArrayOne = [NSMutableArray array];
        
        
        [dataArrayOne addObject:@{@"title" : @"银行卡管理" , @"imgName" :[self retureRandomThemeColorImage:@"yinhangqia"]}];
        [dataArrayOne addObject:@{@"title" : @"安全中心" , @"imgName" : [self retureRandomThemeColorImage:@"ziyuan"]}];
        [dataArrayOne addObject:@{@"title" : @"个人信息" , @"imgName" : [self retureRandomThemeColorImage:@"gerenzhongxinxuanzhong"]}];
        

        
        UGMineSkinModel *dic1 = [UGMineSkinModel new];
        
        [dic1 setName:@"设置"];
        [dic1 setDataArray:dataArrayOne];
        
        [self.menuSecondNameArray addObject:dic1];
        
    }
    
    //=======================================
    {
        NSMutableArray *dataArrayOne = [NSMutableArray array];
        
        
        [dataArrayOne addObject:@{@"title" : @"长龙助手" , @"imgName" : [self retureRandomThemeColorImage:@"changlong"]}];
        [dataArrayOne addObject:@{@"title" : @"站内信" , @"imgName" : [self retureRandomThemeColorImage:@"zhanneixin"]}];
        [dataArrayOne addObject:@{@"title" : @"建议反馈" , @"imgName" : [self retureRandomThemeColorImage:@"yijian"]}];

        UGMineSkinModel *dic1 = [UGMineSkinModel new];
        
        [dic1 setName:@"网站资料"];
        [dic1 setDataArray:dataArrayOne];
        
        [self.menuSecondNameArray addObject:dic1];
        
    }
  
    
}

/**
 *  添加tabCell 数据
 */
- (void)resetUpTabCellData:(NSArray<UGUserCenter *> *)paths {
    self.menuNameArray = [NSMutableArray array];
    
    UGUserModel *user = [UGUserModel currentUser];
    NSLog(@"isAgent= %d",user.isAgent);
    
    for (UGUserCenter *gm in paths) {
        
        if (user.isAgent) {
            if ([gm.name isEqualToString:@"代理申请"]) {
                [gm setName:@"收益推荐"];
            }
        } else {
            if ([gm.name isEqualToString:@"收益推荐"]) {
                [gm setName:@"代理申请"];
            }
        }
        if ([CMCommon stringIsNull:gm.logo]) {
            UGUserCenter *obj  =  [_gms objectWithValue:gm.name keyPath:@"name"];
            [self.menuNameArray addObject:@{@"title" : gm.name , @"imgName" : [self retureRandomThemeColorImage:obj.logo]  }];
        } else {
            [self.menuNameArray addObject:@{@"title" : gm.name , @"imgName" : gm.logo }];
        }

        if (!user.hasActLottery) {
            if ([gm.name isEqualToString:@"活动彩金"]) {
                [self.menuNameArray removeObject:[self.menuNameArray objectWithValue:@"活动彩金" keyPath:@"title"]];
            }
        }
    }
    
    //=============//新年红=======================================================================
    [self skinSeconddataSource];
//    NSMutableArray *menuName2Array = [NSMutableArray array];
//    for (UGUserCenter *gm in paths) {
//        
//        if (user.isAgent) {
//            if ([gm.name isEqualToString:@"代理申请"]) {
//                [gm setName:@"收益推荐"];
//            }
//        } else {
//            if ([gm.name isEqualToString:@"收益推荐"]) {
//                [gm setName:@"代理申请"];
//            }
//        }
//        if ([CMCommon stringIsNull:gm.logo]) {
//            UGUserCenter *obj  =  [_gms objectWithValue:gm.name keyPath:@"name"];
//            [menuName2Array addObject:@{@"title" : gm.name , @"imgName" : [self retureRandomThemeColorImage:obj.logo]  }];
//        } else {
//            [menuName2Array addObject:@{@"title" : gm.name , @"imgName" : gm.logo }];
//        }
//        
//        if (!user.hasActLottery) {
//            if ([gm.name isEqualToString:@"活动彩金"]) {
//                [menuName2Array removeObject:[self.menuNameArray objectWithValue:@"活动彩金" keyPath:@"title"]];
//            }
//        }
//    }
//    
//    NSMutableArray *dataArrayOne = [NSMutableArray array];
//    NSMutableArray *dataArrayTwo = [NSMutableArray array];
//    NSMutableArray *dataArrayThree = [NSMutableArray array];
//    NSMutableArray *dataArray4 = [NSMutableArray array];
//    for (NSDictionary *gm in menuName2Array) {
//        if ([[gm objectForKey:@"title"] isEqualToString:@"收益推荐"]) {
//            [dataArrayOne addObject:gm];
//        }
//        if ([[gm objectForKey:@"title"] isEqualToString:@"代理申请"]) {
//            [dataArrayOne addObject:gm];
//        }
//        if ([[gm objectForKey:@"title"] isEqualToString:@"活动彩金"]) {
//            [dataArrayOne addObject:gm];
//        }
//        if ([[gm objectForKey:@"title"] isEqualToString:@"利息宝"]) {
//            [dataArrayOne addObject:gm];
//        }
//        if ([[gm objectForKey:@"title"] isEqualToString:@"在线客服"]) {
//            [dataArrayOne addObject:gm];
//        }
//       // ===========================================================
//         if ([[gm objectForKey:@"title"] isEqualToString:@"彩票注单记录"]) {
//             [dataArrayTwo addObject:gm];
//         }
//         if ([[gm objectForKey:@"title"] isEqualToString:@"其他注单记录"]) {
//             [dataArrayTwo addObject:gm];
//         }
//
//        // ===========================================================
//        if ([[gm objectForKey:@"title"] isEqualToString:@"银行卡管理"]) {
//            [dataArrayThree addObject:gm];
//        }
//        if ([[gm objectForKey:@"title"] isEqualToString:@"安全中心"]) {
//            [dataArrayThree addObject:gm];
//        }
//        if ([[gm objectForKey:@"title"] isEqualToString:@"个人信息"]) {
//            [dataArrayThree addObject:gm];
//        }
//        // ===========================================================
//        if ([[gm objectForKey:@"title"] isEqualToString:@"长龙助手"]) {
//            [dataArray4 addObject:gm];
//        }
//        if ([[gm objectForKey:@"title"] isEqualToString:@"站内信"]) {
//            [dataArray4 addObject:gm];
//        }
//        if ([[gm objectForKey:@"title"] isEqualToString:@"建议反馈"]) {
//            [dataArray4 addObject:gm];
//        }
//         
//    }
//    
//            UGMineSkinModel *dic1 = [UGMineSkinModel new];
//            [dic1 setName:@"我的"];
//            [dic1 setDataArray:dataArrayOne];
//            [self.menuSecondNameArray addObject:dic1];
//    
//            UGMineSkinModel *dic2 = [UGMineSkinModel new];
//            [dic2 setName:@"注单详情"];
//            [dic2 setDataArray:dataArrayTwo];
//            [self.menuSecondNameArray addObject:dic2];
//    
//            UGMineSkinModel *dic3 = [UGMineSkinModel new];
//            [dic3 setName:@"设置"];
//            [dic3 setDataArray:dataArrayThree];
//            [self.menuSecondNameArray addObject:dic3];
//    
//            UGMineSkinModel *dic4 = [UGMineSkinModel new];
//            [dic4 setName:@"网站资料"];
//            [dic4 setDataArray:dataArray4];
//            [self.menuSecondNameArray addObject:dic4];
    
    
//     self.menuSecondNameArray = [NSMutableArray array];
//
//        {//==============1
//            NSMutableArray *dataArrayOne = [NSMutableArray array];
//            if (user.isAgent) {
////                NSLog(@"[paths valuesWithKeyPath:@name] = %@",[paths valuesWithKeyPath:@"name"]);
//                UGUserCenter *gm = [paths  objectWithValue:@"收益推荐" keyPath:@"title"];
//                if ([CMCommon stringIsNull:gm.logo]) {
//                    UGUserCenter *obj  =  [_gms objectWithValue:gm.name keyPath:@"name"];
//                    [dataArrayOne addObject:@{@"title" : gm.name , @"imgName" : [self retureRandomThemeColorImage:obj.logo] }];
//                } else {
//                    [dataArrayOne addObject:@{@"title" : gm.name , @"imgName" : gm.logo }];
//                }
//
//
//            } else {
//                UGUserCenter *gm = [paths objectWithValue:@"代理申请" keyPath:@"name"];
//                if ([CMCommon stringIsNull:gm.logo]) {
//                    UGUserCenter *obj  =  [_gms objectWithValue:gm.name keyPath:@"name"];
//                    [dataArrayOne addObject:@{@"title" : gm.name , @"imgName" : [self retureRandomThemeColorImage:obj.logo] }];
//                } else {
//                    [dataArrayOne addObject:@{@"title" : gm.name , @"imgName" : gm.logo }];
//                }
//            }
//            {
//                if (user.hasActLottery) {
//                    UGUserCenter *gm = [paths objectWithValue:@"活动彩金" keyPath:@"name"];
//                    if ([CMCommon stringIsNull:gm.logo]) {
//                        UGUserCenter *obj  =  [_gms objectWithValue:gm.name keyPath:@"name"];
//                        [dataArrayOne addObject:@{@"title" : gm.name , @"imgName" : [self retureRandomThemeColorImage:obj.logo] }];
//                    } else {
//                        [dataArrayOne addObject:@{@"title" : gm.name , @"imgName" : gm.logo }];
//                    }
//                }
//            }
//            {
//                UGUserCenter *gm = [paths objectWithValue:@"利息宝" keyPath:@"name"];
//                if ([CMCommon stringIsNull:gm.logo]) {
//                    UGUserCenter *obj  =  [_gms objectWithValue:gm.name keyPath:@"name"];
//                    [dataArrayOne addObject:@{@"title" : gm.name , @"imgName" : [self retureRandomThemeColorImage:obj.logo] }];
//                } else {
//                    [dataArrayOne addObject:@{@"title" : gm.name , @"imgName" : gm.logo }];
//                }
//            }
//            {
//                UGUserCenter *gm = [self.menuNameArray objectWithValue:@"在线客服" keyPath:@"name"];
//                if ([CMCommon stringIsNull:gm.logo]) {
//                    UGUserCenter *obj  =  [_gms objectWithValue:gm.name keyPath:@"name"];
//                    [dataArrayOne addObject:@{@"title" : gm.name , @"imgName" : [self retureRandomThemeColorImage:obj.logo] }];
//                } else {
//                    [dataArrayOne addObject:@{@"title" : gm.name , @"imgName" : gm.logo }];
//                }
//            }
//
//            UGMineSkinModel *dic1 = [UGMineSkinModel new];
//            [dic1 setName:@"我的"];
//            [dic1 setDataArray:dataArrayOne];
//            [self.menuSecondNameArray addObject:dic1];
//        }
//        //================2=======================
//        {
//            NSMutableArray *dataArrayOne = [NSMutableArray array];
//            {
//                UGUserCenter *gm = [self.menuNameArray objectWithValue:@"彩票注单记录" keyPath:@"name"];
//                if ([CMCommon stringIsNull:gm.logo]) {
//                    UGUserCenter *obj  =  [_gms objectWithValue:gm.name keyPath:@"name"];
//                    [dataArrayOne addObject:@{@"title" : gm.name , @"imgName" : [self retureRandomThemeColorImage:obj.logo] }];
//                } else {
//                    [dataArrayOne addObject:@{@"title" : gm.name , @"imgName" : gm.logo }];
//                }
//            }
//            {
//                UGUserCenter *gm = [self.menuNameArray objectWithValue:@"其他注单记录" keyPath:@"name"];
//                if ([CMCommon stringIsNull:gm.logo]) {
//                    UGUserCenter *obj  =  [_gms objectWithValue:gm.name keyPath:@"name"];
//                    [dataArrayOne addObject:@{@"title" : gm.name , @"imgName" : [self retureRandomThemeColorImage:obj.logo] }];
//                } else {
//                    [dataArrayOne addObject:@{@"title" : gm.name , @"imgName" : gm.logo }];
//                }
//            }
//
//            UGMineSkinModel *dic1 = [UGMineSkinModel new];
//            [dic1 setName:@"注单详情"];
//            [dic1 setDataArray:dataArrayOne];
//            [self.menuSecondNameArray addObject:dic1];
//
//        }
//        //================3=======================
//        {
//            NSMutableArray *dataArrayOne = [NSMutableArray array];
//            {
//                UGUserCenter *gm = [self.menuNameArray objectWithValue:@"银行卡管理" keyPath:@"name"];
//                if ([CMCommon stringIsNull:gm.logo]) {
//                    UGUserCenter *obj  =  [_gms objectWithValue:gm.name keyPath:@"name"];
//                    [dataArrayOne addObject:@{@"title" : gm.name , @"imgName" : [self retureRandomThemeColorImage:obj.logo] }];
//                } else {
//                    [dataArrayOne addObject:@{@"title" : gm.name , @"imgName" : gm.logo }];
//                }
//            }
//            {
//                UGUserCenter *gm = [self.menuNameArray objectWithValue:@"安全中心" keyPath:@"name"];
//                if ([CMCommon stringIsNull:gm.logo]) {
//                    UGUserCenter *obj  =  [_gms objectWithValue:gm.name keyPath:@"name"];
//                    [dataArrayOne addObject:@{@"title" : gm.name , @"imgName" : [self retureRandomThemeColorImage:obj.logo] }];
//                } else {
//                    [dataArrayOne addObject:@{@"title" : gm.name , @"imgName" : gm.logo }];
//                }
//            }
//            {
//                UGUserCenter *gm = [self.menuNameArray objectWithValue:@"个人信息" keyPath:@"name"];
//                if ([CMCommon stringIsNull:gm.logo]) {
//                    UGUserCenter *obj  =  [_gms objectWithValue:gm.name keyPath:@"name"];
//                    [dataArrayOne addObject:@{@"title" : gm.name , @"imgName" : [self retureRandomThemeColorImage:obj.logo] }];
//                } else {
//                    [dataArrayOne addObject:@{@"title" : gm.name , @"imgName" : gm.logo }];
//                }
//            }
//
//            UGMineSkinModel *dic1 = [UGMineSkinModel new];
//            [dic1 setName:@"设置"];
//            [dic1 setDataArray:dataArrayOne];
//            [self.menuSecondNameArray addObject:dic1];
//
//        }
//        //=================4======================
//        {
//            NSMutableArray *dataArrayOne = [NSMutableArray array];
//            {
//                UGUserCenter *gm = [self.menuNameArray objectWithValue:@"长龙助手" keyPath:@"name"];
//                if ([CMCommon stringIsNull:gm.logo]) {
//                    UGUserCenter *obj  =  [_gms objectWithValue:gm.name keyPath:@"name"];
//                    [dataArrayOne addObject:@{@"title" : gm.name , @"imgName" : [self retureRandomThemeColorImage:obj.logo] }];
//                } else {
//                    [dataArrayOne addObject:@{@"title" : gm.name , @"imgName" : gm.logo }];
//                }
//            }
//            {
//                UGUserCenter *gm = [self.menuNameArray objectWithValue:@"站内信" keyPath:@"name"];
//                if ([CMCommon stringIsNull:gm.logo]) {
//                    UGUserCenter *obj  =  [_gms objectWithValue:gm.name keyPath:@"name"];
//                    [dataArrayOne addObject:@{@"title" : gm.name , @"imgName" : [self retureRandomThemeColorImage:obj.logo] }];
//                } else {
//                    [dataArrayOne addObject:@{@"title" : gm.name , @"imgName" : gm.logo }];
//                }
//            }
//            {
//                UGUserCenter *gm = [self.menuNameArray objectWithValue:@"建议反馈" keyPath:@"name"];
//                if ([CMCommon stringIsNull:gm.logo]) {
//                    UGUserCenter *obj  =  [_gms objectWithValue:gm.name keyPath:@"name"];
//                    [dataArrayOne addObject:@{@"title" : gm.name , @"imgName" : [self retureRandomThemeColorImage:obj.logo] }];
//                } else {
//                    [dataArrayOne addObject:@{@"title" : gm.name , @"imgName" : gm.logo }];
//                }
//            }
//
//            UGMineSkinModel *dic1 = [UGMineSkinModel new];
//            [dic1 setName:@"网站资料"];
//            [dic1 setDataArray:dataArrayOne];
//            [self.menuSecondNameArray addObject:dic1];
//
//        }


    
    [self.myCollectionView reloadData];

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
        else  if([skitType isEqualToString:@"经典"]){
            layout.headerReferenceSize = CGSizeMake(UGScreenW, 0.1);
        }
        else  if ([skitType isEqualToString:@"六合资料"]) {//六合资料
             layout.headerReferenceSize = CGSizeMake(UGScreenW, 0.1);
        }
        
        layout;
        
    });

        self.myCollectionView.backgroundColor = Skin1.bgColor;
        self.myCollectionView.dataSource = self;
        self.myCollectionView.delegate = self;
        [self.myCollectionView registerNib:[UINib nibWithNibName:@"UGMineMenuCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"UGMineMenuCollectionViewCell"];
        [self.myCollectionView registerNib:[UINib nibWithNibName:@"UGMineSkinCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"UGMineSkinCollectionViewCell"];
    
    
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
    else  if([skitType isEqualToString:@"经典"]){
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
        NSDictionary *dic = self.menuSecondNameArray[indexPath.section].dataArray[indexPath.row];
        cell.menuName = dic[@"title"];
        
        //字条串开始包含有某字符串
        if ([dic[@"imgName"] isKindOfClass:UIImage.class] ) {
            cell.imageView.image = dic[@"imgName"];
        }
        else{
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:dic[@"imgName"]]];
        }

        [cell setBadgeNum:[dic[@"title"] isEqualToString:@"站内信"] ? unreadMsg : 0];
        [cell setBackgroundColor: [UIColor clearColor]];
        cell.layer.borderWidth = 0.5;
        cell.layer.borderColor = UGRGBColor(231, 230, 230).CGColor;
        return cell;
    }
    else  {
        UGMineMenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UGMineMenuCollectionViewCell" forIndexPath:indexPath];
        NSDictionary *dic = self.menuNameArray[indexPath.row];
        cell.menuName = dic[@"title"];
        //字条串开始包含有某字符串
        if ([dic[@"imgName"] isKindOfClass:UIImage.class] ) {
            cell.imageView.image = dic[@"imgName"];
        }
        else{
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:dic[@"imgName"]]];
        }
        [cell setBadgeNum:[dic[@"title"] isEqualToString:@"站内信"] ? unreadMsg : 0];
        [cell setBackgroundColor: [UIColor clearColor]];
        cell.layer.borderWidth = 0.5;
        cell.layer.borderColor = Skin1.isBlack ? [UIColor clearColor].CGColor : [[[UIColor whiteColor] colorWithAlphaComponent:0.9] CGColor];
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
    else  if([skitType isEqualToString:@"经典"]) {
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
    
    NSString *title;
    if ([skitType isEqualToString:@"新年红"]) {
        UGMineSkinModel *model = [self.menuSecondNameArray objectAtIndex:indexPath.section];
        NSDictionary *dic = [model.dataArray objectAtIndex:indexPath.row];
        title = [dic objectForKey:@"title"];
    }
    else  {
        title =  self.menuNameArray[indexPath.row][@"title"];
    }
    
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


#pragma mark - 其他方法

// 任务中心
- (IBAction)showMissionVC:(id)sender {
  // 任务中心
       UIViewController *vc = [NavController1.viewControllers objectWithValue:UGMissionCenterViewController.class keyPath:@"class"];
       if (vc) {
           [NavController1 popToViewController:vc animated:false];
       } else {
           [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGMissionCenterViewController") animated:false];
       }
}

// 每日签到
- (IBAction)showSign:(id)sender {
    [self.navigationController pushViewController:[UGSigInCodeViewController new] animated:YES];
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
            NSLog(@"签到==%d",[UGUserModel currentUser].checkinSwitch);
            
            [self getSystemConfig];
//            //初始化数据
//            [self getDateSource];
        } failure:^(id msg) {
            [self stopAnimation];
        }];
    }];
}

- (void)getSystemConfig {
    
    [CMNetwork getSystemConfigWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            UGSystemConfigModel *config = model.data;
            UGSystemConfigModel.currentConfig = config;
            NSLog(@"签到==%d",[UGSystemConfigModel  currentConfig].checkinSwitch);
            [self setupUserInfo:YES];
            [self stopAnimation];
            SANotificationEventPost(UGNotificationGetSystemConfigComplete, nil);
        } failure:^(id msg) {
            [SVProgressHUD dismiss];
        }];
    }];
}

- (IBAction)depositAction:(id)sender {
    //存款
    UGFundsViewController *fundsVC = [[UGFundsViewController alloc] init];
    fundsVC.selectIndex = 0;
    [self.navigationController pushViewController:fundsVC animated:YES];
}
- (IBAction)withdrawalActon:(id)sender {
    //提现
    UGFundsViewController *fundsVC = [[UGFundsViewController alloc] init];
    fundsVC.selectIndex = 1;
    [self.navigationController pushViewController:fundsVC animated:YES];
}
- (IBAction)conversionAction:(id)sender {
    //转换
    [self.navigationController pushViewController:_LoadVC_from_storyboard_(@"UGBalanceConversionController") animated:YES];
}

@end
