//
//  NewLotteryHomeViewController.m
//  UGBWApp
//
//  Created by fish on 2020/9/21.
//  Copyright © 2020 ug. All rights reserved.
//

#import "UUMarqueeView.h"
#import "UGNoticeTypeModel.h"
#import "NewLotteryHomeViewController.h"
#import "UGNoticePopView.h"
#import "UGFundsViewController.h"
@interface NewLotteryHomeViewController ()<UUMarqueeViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,WSLWaterFlowLayoutDelegate>
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

@end

@implementation NewLotteryHomeViewController

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
    
    [self.view setBackgroundColor:Skin1.bgColor];
    [self.headView setBackgroundColor:Skin1.navBarBgColor];
    [self.rollingView setBackgroundColor:Skin1.bgColor];
    [CMCommon setBorderWithView:_rollingView top:YES left:NO bottom:YES right:NO borderColor:RGBA(241, 241, 241, 1) borderWidth:1];
    self.withdrawButton.layer.borderWidth = 1;
    self.withdrawButton.layer.borderColor = [Skin1.textColor1 CGColor];
    self.withdrawButton.layer.cornerRadius = 3;
    [self.withdrawButton setTitleColor:Skin1.textColor1 forState:(UIControlStateNormal)];
    self.rechargeButton.layer.borderWidth = 1;
    self.rechargeButton.layer.borderColor = [Skin1.textColor1 CGColor];
    self.rechargeButton.layer.cornerRadius = 3;
    [self.rechargeButton setTitleColor:Skin1.textColor1 forState:(UIControlStateNormal)];
    [self.userNameLabel setTextColor:Skin1.textColor1];
    [self.moneyLabel setTextColor:Skin1.textColor1];
    
    self.leftwardMarqueeView.direction = UUMarqueeViewDirectionLeftward;
    self.leftwardMarqueeView.delegate = self;
    self.leftwardMarqueeView.timeIntervalPerScroll = 0.5f;
    self.leftwardMarqueeView.scrollSpeed = 60.0f;
    self.leftwardMarqueeView.itemSpacing = 20.0f;
    self.leftwardMarqueeView.touchEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showNoticeInfo)];
    [self.leftwardMarqueeView addGestureRecognizer:tap];
    

    
    [self getNoticeList];   // 公告列表
    [self getUserInfo];
    
    SANotificationEventSubscribe(UGNotificationGetUserInfoComplete, self, ^(typeof (self) self, id obj) {
        [self setupUserInfo];
    });
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
    self.userNameLabel.text = user.username;
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
