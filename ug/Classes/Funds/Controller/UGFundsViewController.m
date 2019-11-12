//
//  UGFoundsViewController.m
//  ug
//
//  Created by ug on 2019/5/3.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGFundsViewController.h"
#import "XYYSegmentControl.h"
#import "UGRechargeTypeTableViewController.h"
#import "UGWithdrawalViewController.h"
#import "UGRechargeRecordTableViewController.h"
#import "UGFundDetailsTableViewController.h"
#import "UGBMHeaderView.h"
@interface UGFundsViewController ()<XYYSegmentControlDelegate>{
         UGBMHeaderView *headView;                /**<   黑色模板导航头 */
}

@property (nonatomic, strong)UGRechargeRecordTableViewController *rechargeRecordVC;
@property (nonatomic, strong)XYYSegmentControl *slideSwitchView;
@property (nonatomic,strong)  NSArray <NSString *> *itemArray;

@end

@implementation UGFundsViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)skin {
     [self buildSegment];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"资金管理";
    self.fd_prefersNavigationBarHidden = [Skin1.skitType isEqualToString:@"黑色模板"];
    SANotificationEventSubscribe(UGNotificationWithSkinSuccess, self, ^(typeof (self) self, id obj) {
        [self skin];
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([Skin1.skitType isEqualToString:@"黑色模板"]) {
        [self.navigationController setNavigationBarHidden:YES];//强制隐藏NavBar
        [headView.leftwardMarqueeView start];
        [self.view setBackgroundColor:Skin1.navBarBgColor];
    } else {
        [self.navigationController setNavigationBarHidden:NO];//不NavBar
    }
    
    if (OBJOnceToken(self)) {
        [self buildSegment];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [headView.leftwardMarqueeView pause];//fixbug  发热  掉电快
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.slideSwitchView changeSlideAtSegmentIndex:self.selectIndex];
}


#pragma mark - 配置segment
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
- (void)buildSegment
{
    SANotificationEventSubscribe(UGNotificationDepositSuccessfully, self, ^(typeof (self) self, id obj) {
        [self.slideSwitchView changeSlideAtSegmentIndex:2];
    });
    

    
    self.itemArray = @[@"存款",@"取款",@"存款记录",@"取款记录",@"资金明细"];
    if ([Skin1.skitType isEqualToString:@"黑色模板"]) {
         [self creatView];
         self.slideSwitchView = [[XYYSegmentControl alloc] initWithFrame:CGRectMake(0 , headView.frame.size.height+headView.frame.origin.y, self.view.width, self.view.height) channelName:self.itemArray source:self];
        [self.view addSubview:self.slideSwitchView];
        [self.slideSwitchView mas_makeConstraints:^(MASConstraintMaker *make) {
                  make.top.equalTo(headView.mas_bottom);
                  make.left.equalTo(self.view.mas_left).offset(0);
                  make.width.equalTo([NSNumber numberWithFloat:UGScreenW]);
                  make.bottom.equalTo(self.view.mas_bottom);
        }];
    } else {
        self.slideSwitchView = [[XYYSegmentControl alloc] initWithFrame:CGRectMake(0 , 0, self.view.width, self.view.height) channelName:self.itemArray source:self];
        [self.view addSubview:self.slideSwitchView];
    }
  
    [self.slideSwitchView setUserInteractionEnabled:YES];
    self.slideSwitchView.segmentControlDelegate = self;
    //设置tab 颜色(可选)
    self.slideSwitchView.tabItemNormalColor = Skin1.textColor2;
    self.slideSwitchView.tabItemNormalFont = 13;
    //设置tab 被选中的颜色(可选)
    self.slideSwitchView.tabItemSelectedColor = Skin1.textColor1;
    //设置tab 背景颜色(可选)
    self.slideSwitchView.tabItemNormalBackgroundColor = Skin1.textColor4;
    //设置tab 被选中的标识的颜色(可选)
    self.slideSwitchView.tabItemSelectionIndicatorColor = Skin1.textColor1;
 
}


#pragma mark - XYYSegmentControlDelegate

- (NSUInteger)numberOfTab:(XYYSegmentControl *)view {
    return [self.itemArray count];//items决定
}

///待加载的控制器
- (UIViewController *)slideSwitchView:(XYYSegmentControl *)view viewOfTab:(NSUInteger)number {
    // 存款
    if (number == 0) {
        UGRechargeTypeTableViewController *rechargeVC = [[UGRechargeTypeTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        return rechargeVC;
    }
    // 取款
    else if (number == 1) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGWithdrawalViewController" bundle:nil];
        UGWithdrawalViewController *withdrawalVC = [storyboard instantiateInitialViewController];
        WeakSelf
        withdrawalVC.withdrawSuccessBlock = ^{
            weakSelf.selectIndex = 3;
            [weakSelf.slideSwitchView changeSlideAtSegmentIndex:weakSelf.selectIndex];
        };
        return withdrawalVC;
    }
    // 存款记录
    else if (number == 2) {
        if (! self.rechargeRecordVC) {
            self.rechargeRecordVC = [[UGRechargeRecordTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            self.rechargeRecordVC.recordType = RecordTypeRecharge;
        }
        return self.rechargeRecordVC;
    }
    // 取款记录
    else if (number == 3) {
        UGRechargeRecordTableViewController *rechargeRecordVC = [[UGRechargeRecordTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        rechargeRecordVC.recordType = RecordTypeWithdraw;
        return rechargeRecordVC;
    }
    // 资金明细
    else {
        UGFundDetailsTableViewController *detailsVC = [[UGFundDetailsTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        return detailsVC;
    }
}

- (void)slideSwitchView:(XYYSegmentControl *)view didselectTab:(NSUInteger)number {
    if (number != 1)
        SANotificationEventPost(UGNotificationFundTitlesTap, nil);
    
    if (number == 2) {
        SANotificationEventPost(UGNotificationWithRecordOfDeposit, nil);
    }
    
}

@end
