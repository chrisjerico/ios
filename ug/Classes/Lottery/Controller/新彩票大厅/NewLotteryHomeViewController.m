//
//  NewLotteryHomeViewController.m
//  UGBWApp
//
//  Created by fish on 2020/9/21.
//  Copyright © 2020 ug. All rights reserved.
//


#import "NewLotteryHomeViewController.h"
#import "UGNoticePopView.h"
#import "UGFundsViewController.h"
#import "XYYSegmentControl.h"
#import "NewLotteryListController.h"
#import "UUMarqueeView.h"
#import "UGNoticeTypeModel.h"
#import "UGYYRightMenuView.h"
#import "STBarButtonItem.h"
@interface NewLotteryHomeViewController ()<UUMarqueeViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,WSLWaterFlowLayoutDelegate,XYYSegmentControlDelegate>
@property (weak, nonatomic) IBOutlet UIView *headView;   /**<   头View */
@property (weak, nonatomic) IBOutlet UIButton *refreshFirstButton;    /**<    刷新按钮 */
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;/**<    昵称 */
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;   /**<    余额 */
@property (weak, nonatomic) IBOutlet UIButton *rechargeButton;    /**<    充值按钮 */
@property (weak, nonatomic) IBOutlet UIButton *withdrawButton;    /**<    提现按钮 */
//===================================================
@property (weak, nonatomic) IBOutlet UIView *rollingView; /**<   跑马灯父视图 */
@property (weak, nonatomic) IBOutlet UUMarqueeView *leftwardMarqueeView; /**<   跑马灯 */
@property (nonatomic, strong) NSMutableArray <NSString *> *leftwardMarqueeViewData; /**<   跑马灯数据 */
@property (nonatomic, strong) UGNoticeTypeModel *noticeTypeModel;  /**<   点击跑马灯弹出的数据 */
//===================================================
@property (nonatomic, strong)XYYSegmentControl *slideSwitchView;
@property (nonatomic,strong)  NSMutableArray <NSString *> *itemArray;
@property (nonatomic,strong)  NSMutableArray <NewLotteryListController *> *viewsArray;
@property (nonatomic, strong) NSArray<UGAllNextIssueListModel *> *lotteryGamesArray;
//===================================================
@property (nonatomic, strong) UGYYRightMenuView *yymenuView;    /**<   侧边栏 */
@end

@implementation NewLotteryHomeViewController

- (BOOL)允许未登录访问 { return false; }

- (BOOL)允许游客访问 { return true; }

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.leftwardMarqueeView start];

}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.leftwardMarqueeView pause];//fixbug  发热  掉电快
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"彩票大厅";
    
    [self.view setBackgroundColor:Skin1.bgColor];
    
    if (![Skin1.skitString isEqualToString:@"经典 1蓝色"]) {
        [self.headView setBackgroundColor:Skin1.navBarBgColor];
    }
    
    [self.rollingView setBackgroundColor:Skin1.bgColor];
    self.rollingView .clipsToBounds = false;
    self.rollingView .layer.shadowColor = [UIColor blackColor].CGColor;
    self.rollingView .layer.shadowOffset = CGSizeMake(0, 1);
    self.rollingView .layer.shadowRadius = 2;
    self.rollingView .layer.shadowOpacity = 0.1;
    [CMCommon setBorderWithView:_rollingView top:YES left:NO bottom:YES right:NO borderColor:[UIColor blackColor] borderWidth:0.5];
    self.withdrawButton.layer.borderWidth = 0.5f;
    self.withdrawButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.withdrawButton.layer.cornerRadius = 3;
    self.rechargeButton.layer.borderWidth = 0.5f;
    self.rechargeButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.rechargeButton.layer.cornerRadius = 3;

    self.leftwardMarqueeView.direction = UUMarqueeViewDirectionLeftward;
    self.leftwardMarqueeView.delegate = self;
    self.leftwardMarqueeView.timeIntervalPerScroll = 0.5f;
    self.leftwardMarqueeView.scrollSpeed = 60.0f;
    self.leftwardMarqueeView.itemSpacing = 20.0f;
    self.leftwardMarqueeView.touchEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showNoticeInfo)];
    [self.leftwardMarqueeView addGestureRecognizer:tap];
    
    self.navigationItem.rightBarButtonItem = [STBarButtonItem barButtonItemWithImageName:@"gengduo" target:self action:@selector(rightBarBtnClick)];
    
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"游客"];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    self.userNameLabel.attributedText = str;
    
    [self getNoticeList];   // 公告列表
    [self getUserInfo];
    
    SANotificationEventSubscribe(UGNotificationGetUserInfoComplete, self, ^(typeof (self) self, id obj) {
        [self setupUserInfo];
    });
    
    
    [self dataArryInit];
    [self getAllNextIssueData];
}

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

#pragma mark -- 分栏
-(void)dataArryInit{
    _itemArray =[NSMutableArray new];
    _viewsArray = [NSMutableArray new];
    _lotteryGamesArray = [NSMutableArray new];
    _leftwardMarqueeViewData = [NSMutableArray new];
}

- (void)getAllNextIssueData {
    WeakSelf;
    [CMNetwork getLotteryGroupGamesWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        NSLog(@"model = %@",model);
       
        [CMResult processWithResult:model success:^{
            weakSelf.lotteryGamesArray =  model.data;

            for (UGAllNextIssueListModel *obj in weakSelf.lotteryGamesArray) {
                NewLotteryListController *realView = [NewLotteryListController new];
                realView.list = obj.lotteries;
                [weakSelf.viewsArray addObject:realView];

                [weakSelf.itemArray addObject:obj.name];
            }
            [weakSelf buildSegment];

        } failure:^(id msg) {
            [SVProgressHUD dismiss];
        }];
    }];
}

- (void)buildSegment
{

    self.slideSwitchView = [[XYYSegmentControl alloc] initWithFrame:CGRectMake(0 , 0, self.view.width, self.view.height) channelName:self.itemArray source:self];
    [self.view addSubview:self.slideSwitchView];
    
    [self.slideSwitchView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view).with.offset(0);
        make.top.equalTo(self.rollingView.mas_bottom).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
    }];
    [self.slideSwitchView setUserInteractionEnabled:YES];
    self.slideSwitchView.segmentControlDelegate = self;
    //设置tab 颜色(可选)
    self.slideSwitchView.tabItemNormalColor = Skin1.textColor3;
    self.slideSwitchView.tabItemNormalFont = 13;

    
    //设置tab 背景颜色(可选)
    UIColor *bg;
    if (Skin1.isGPK) {
        bg = Skin1.textColor4;
        //设置tab 被选中的颜色(可选)
        self.slideSwitchView.tabItemSelectedColor = RGBA(203, 43, 37, 1.0) ;
        self.slideSwitchView.tabItemSelectionIndicatorColor = RGBA(203, 43, 37, 1.0) ;
    }
    else if(Skin1.isBlack){
         bg = RGBA(135 , 135 ,135, 1);
         self.slideSwitchView.tabItemSelectedColor = RGBA(203, 43, 37, 1.0) ;
        self.slideSwitchView.tabItemSelectionIndicatorColor = RGBA(203, 43, 37, 1.0) ;
    }
    else {
        bg = Skin1.bgColor;
        if (![Skin1.skitString isEqualToString:@"经典 1蓝色"]) {
            self.slideSwitchView.tabItemSelectedColor = Skin1.textColor1 ;
            self.slideSwitchView.tabItemSelectionIndicatorColor = Skin1.textColor3 ;
        }
        else{
        
            self.slideSwitchView.tabItemSelectedColor = [UIColor whiteColor] ;
            self.slideSwitchView.tabItemNormalColor = [UIColor blackColor];
            self.slideSwitchView.tabItemSelectionIndicatorColor = Skin1.textColor3 ;
            self.slideSwitchView.tabItemNormalFont = 13;
        }
       
    }

    self.slideSwitchView.tabItemNormalBackgroundColor = bg;
//    //设置tab 被选中的标识的颜色(可选)
//
//    //设置tab 被选中标识的风格
//    self.slideSwitchView.tabSelectionStyle = XYYSegmentedControlSelectionStyleBox;
    
}

#pragma mark - XYYSegmentControlDelegate

- (NSUInteger)numberOfTab:(XYYSegmentControl *)view {
    return [self.itemArray count];//items决定
}

///待加载的控制器
- (UIViewController *)slideSwitchView:(XYYSegmentControl *)view viewOfTab:(NSUInteger)number {
    
    NewLotteryListController * realView  = [_viewsArray objectAtIndex:number];
    return realView;
    
}

- (void)slideSwitchView:(XYYSegmentControl *)view didselectTab:(NSUInteger)number {
    
//    NewLotteryListController * realView  = [_viewsArray objectAtIndex:number];
//    [realView rootLoadData];
    
}
#pragma mark -- 头View
// 刷新余额
- (IBAction)refreshBalance:(id)sender {
    [self getUserInfo];
}
// 充值
- (IBAction)rechargeAction:(id)sender {
    UGFundsViewController *fundsVC = _LoadVC_from_storyboard_(@"UGFundsViewController");
    fundsVC.selectIndex = 0;
    [NavController1 pushViewController:fundsVC animated:true];
}
// 提现
- (IBAction)withdrawAction:(id)sender {
    UGFundsViewController *fundsVC = _LoadVC_from_storyboard_(@"UGFundsViewController");
    fundsVC.selectIndex = 1;
    [NavController1 pushViewController:fundsVC animated:true];
}

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
            [weakSelf stopAnimation];
            [weakSelf setupUserInfo];
        } failure:^(id msg) {
            [self stopAnimation];
        }];
    }];
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

#pragma mark - UIS
- (void)setupUserInfo {
    UGUserModel *user = [UGUserModel currentUser];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:user.username];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    self.userNameLabel.attributedText = str;
    double floatString = [user.balance doubleValue];
    self.moneyLabel.text =  [NSString stringWithFormat:@"￥%.2f",floatString];
}


#pragma mark -- 公告
// 公告
- (void)getNoticeList {
    WeakSelf;
    [CMNetwork getNoticeListWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                UGNoticeTypeModel *type = model.data;
                weakSelf.noticeTypeModel = model.data;
//                weakSelf.popNoticeArray = type.popup.mutableCopy;
                for (UGNoticeModel *notice in type.scroll) {
                    [weakSelf.leftwardMarqueeViewData addObject:notice.title];
                }
                [weakSelf.leftwardMarqueeView reloadData];
   
//                [weakSelf showPlatformNoticeView];
            });
        } failure:nil];
    }];
}
// 弹窗
- (void)showNoticeInfo {
    NSMutableString *str = [[NSMutableString alloc] init];
    for (UGNoticeModel *notice in self.noticeTypeModel.scroll) {
        [str appendString:notice.content];
    }
    if (str.length) {
        float y;
        if ([CMCommon isPhoneX]) {
            y = 160;
        } else {
            y = 100;
        }
        UGNoticePopView *popView = [[UGNoticePopView alloc] initWithFrame:CGRectMake(40, y, UGScreenW - 80, UGScerrnH - y * 2)];
        popView.content = str;
        [popView show];
    }
}


#pragma mark - UUMarqueeViewDelegate

- (NSUInteger)numberOfVisibleItemsForMarqueeView:(UUMarqueeView *)marqueeView {
    if (marqueeView == self.leftwardMarqueeView) {
        return 1;
    }
    return 0;
}

- (NSUInteger)numberOfDataForMarqueeView:(UUMarqueeView *)marqueeView {
    if (marqueeView == self.leftwardMarqueeView) {
        return self.leftwardMarqueeViewData ? self.leftwardMarqueeViewData.count : 0;
    }
    return 0;
}

- (void)createItemView:(UIView *)itemView forMarqueeView:(UUMarqueeView *)marqueeView {
    
    if (marqueeView == self.leftwardMarqueeView) {
        
        itemView.backgroundColor = [UIColor clearColor];
        
        UILabel *content = [[UILabel alloc] initWithFrame:itemView.bounds];
        content.font = [UIFont systemFontOfSize:14.0f];
        content.tag = 1001;
        [itemView addSubview:content];
    }
}
- (void)updateItemView:(UIView *)itemView atIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView *)marqueeView {
    if (marqueeView == self.leftwardMarqueeView) {
        UILabel *content = [itemView viewWithTag:1001];
        content.textColor = Skin1.textColor1;
        content.text = self.leftwardMarqueeViewData[index];
    }
}

//- (CGFloat)itemViewHeightAtIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView*)marqueeView {

//}

- (CGFloat)itemViewWidthAtIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView*)marqueeView {
    // for leftwardMarqueeView
    UILabel *content = [[UILabel alloc] init];
    content.text = self.leftwardMarqueeViewData[index];
    return content.intrinsicContentSize.width;  // icon width + label width (it's perfect to cache them all)
}

- (void)didTouchItemViewAtIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView*)marqueeView {
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
