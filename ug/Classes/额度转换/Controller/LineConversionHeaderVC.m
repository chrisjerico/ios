//
//  LineConversionHeaderVC.m
//  ug
//
//  Created by ug on 2020/2/18.
//  Copyright © 2020 ug. All rights reserved.
//

#import "LineConversionHeaderVC.h"
#import "SlideSegmentView1.h"    /**<    分页布局View  fish */
#import "XYYSegmentControl.h"    /**<    分页布局View  */
#import "LineMainViewController.h"   //额度转换界面
#import "UGBalanceConversionRecordController.h"   //转换记录界面
@interface LineConversionHeaderVC ()<XYYSegmentControlDelegate>
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (nonatomic) SlideSegmentView1 *segmentView;                  /**<    分页布局View */
@property (nonatomic, strong)XYYSegmentControl *slideSwitchView;       /**<    分页布局View */
@property (nonatomic,strong)  NSArray <NSString *> *itemArray;
//===================================================
@property (weak, nonatomic) IBOutlet UIButton *refreshFirstButton;    /**<    刷新按钮 */
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;/**<    昵称 */
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;   /**<    余额 */
@property (weak, nonatomic) IBOutlet UILabel *realNameLabel;/**<    真实名 */

@end

@implementation LineConversionHeaderVC

- (void)fishSegmentView {
    NSArray *titles = @[@"额度转换", @"转换记录"];
    _segmentView = _LoadView_from_nib_(@"SlideSegmentView1");
    _segmentView.frame = CGRectMake(0, 0, APP.Width, APP.Height);
    UIViewController *vc1 = [UIViewController new];
    [vc1.view setBackgroundColor:[UIColor greenColor]];
    UIViewController *vc2 = [UIViewController new];
    [vc2.view setBackgroundColor:[UIColor yellowColor]];
    _segmentView.viewControllers = @[vc1, vc2];
    for (UIView *v in _segmentView.contentViews) {
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(APP.Width);
            make.height.mas_equalTo(self.view.height - NavController1.navigationBar.by - 40);
        }];
    }
    
 
    __weakSelf_(__self);
    _segmentView.titleBar.updateCellForItemAtIndex = ^(UICollectionViewCell *cell, UILabel *label, NSUInteger idx) {
        label.text = titles[idx];
        label.textColor = Skin1.textColor2;
        label.font =  [UIFont systemFontOfSize:14];
      
    };

    _segmentView.titleBar.didSelectItemAtIndexPath = ^(UICollectionViewCell *cell, UILabel *label, NSUInteger idx, BOOL selected) {
        
        label.textColor = selected ? [UIColor redColor] : Skin1.textColor2;
        label.font = selected ? [UIFont boldSystemFontOfSize:16] : [UIFont systemFontOfSize:14];
       
        
        if (selected) {
            // 下划线的默认动画
            [UIView animateWithDuration:0.25 animations:^{
                __self.segmentView.titleBar.underlineView.frame = CGRectMake(cell.left, cell.height-2, label.width +20, 2);
//                [__self.segmentView.titleBar.underlineView mas_updateConstraints:^(MASConstraintMaker *make) {
//                    make.centerX.equalTo(cell.mas_centerX);
//                }];
            }];
        }

    };
    self.segmentView.titleBar.backgroundColor = [Skin1.navBarBgColor colorWithAlphaComponent:0.35];
    [CMCommon setBorderWithView:self.segmentView.titleBar top:YES left:NO bottom:YES right:NO borderColor:[UIColor whiteColor] borderWidth:1];
    [self.view addSubview:_segmentView];
    [_segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    _segmentView.selectedIndex = 0;
}

- (void)xyySegmentView {
    self.itemArray = @[@"额度转换", @"转换记录"];
    self.slideSwitchView = [[XYYSegmentControl alloc] initWithFrame:CGRectMake(0 , 0, self.view.width, self.view.height) channelName:self.itemArray source:self];
    [self.view addSubview:self.slideSwitchView];
    
    [self.slideSwitchView setUserInteractionEnabled:YES];
    self.slideSwitchView.segmentControlDelegate = self;
    //设置tab 颜色(可选)
    self.slideSwitchView.tabItemNormalColor = Skin1.textColor1;
    self.slideSwitchView.tabItemNormalFont = 14;
    //设置tab 被选中的颜色(可选)
    self.slideSwitchView.tabItemSelectedColor = RGBA(203, 43, 37, 1.0) ;
    //设置tab 背景颜色(可选)
    self.slideSwitchView.tabItemNormalBackgroundColor = Skin1.homeContentSubColor ;
    //设置tab 被选中的标识的颜色(可选)
    self.slideSwitchView.tabItemSelectionIndicatorColor = RGBA(203, 43, 37, 1.0) ;
    
    [_slideSwitchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"额度转换";
    [self.view setBackgroundColor:Skin1.navBarBgColor];
    [_headView setBackgroundColor:Skin1.navBarBgColor];
    self.headImageView.layer.cornerRadius = self.headImageView.height / 2 ;
    self.headImageView.layer.masksToBounds = YES;
//    [self fishSegmentView];
    [self xyySegmentView];
    
     [self getUserInfo];
}

#pragma mark - XYYSegmentControlDelegate

- (NSUInteger)numberOfTab:(XYYSegmentControl *)view {
    return [self.itemArray count];//items决定
}

///待加载的控制器
- (UIViewController *)slideSwitchView:(XYYSegmentControl *)view viewOfTab:(NSUInteger)number {
    // 额度转换
    if (number == 0) {
        LineMainViewController *vc1 = [[LineMainViewController alloc] init];
        return vc1;
    }
    // 转换记录
    else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
        UGBalanceConversionRecordController *recordVC = [storyboard instantiateViewControllerWithIdentifier:@"UGBalanceConversionRecordController"];
        return recordVC;
    }
}

- (void)slideSwitchView:(XYYSegmentControl *)view didselectTab:(NSUInteger)number {

}


#pragma mark -- 网络请求
// 刷新余额
- (IBAction)refreshBalance:(id)sender {
    [self getUserInfo];
}
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
            [self stopAnimation];
            [self setupUserInfo];
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
    NSLog(@"user.avatar = %@",user.avatar);

    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"touxiang-1"]];
    self.userNameLabel.text = user.username;

    double floatString = [user.balance doubleValue];
    self.moneyLabel.text =  [NSString stringWithFormat:@"￥%.2f",floatString];
    if (![CMCommon stringIsNull:user.fullName]) {
        self.realNameLabel.text = user.fullName;
    }
    else{
        self.realNameLabel.text = @"";
    }
    

}


@end
