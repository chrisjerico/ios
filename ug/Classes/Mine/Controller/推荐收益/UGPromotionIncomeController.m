//
//  UGPromotionIncomeController.m
//  ug
//
//  Created by ug on 2019/5/8.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGPromotionIncomeController.h"
#import "XYYSegmentControl.h"
#import "UGPromotionTableController.h"
#import "UGPromotionInfoController.h"
#import "UGPormotionView.h"


@interface UGPromotionIncomeController ()<XYYSegmentControlDelegate>

@property (nonatomic, strong) UGPormotionView *uGPormotionView;

@property (nonatomic, strong) XYYSegmentControl *slideSwitchView;
@property (nonatomic, strong) NSArray *itemArray;
@end

@implementation UGPromotionIncomeController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)skin {
    [self initView];
}

- (BOOL)未登录禁止访问 {
    return true;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"推荐收益";
    self.view.backgroundColor =[UIColor whiteColor];
    
    [self initView];
    SANotificationEventSubscribe(UGNotificationWithSkinSuccess, self, ^(typeof (self) self, id obj) {
        [self skin];
    });
}

-(void)initView{
    [self buildSegment];
    [self setupRightItem];
    
    //-签到按钮======================================
    if (_uGPormotionView == nil) {
        _uGPormotionView = [[UGPormotionView alloc] initWithFrame:CGRectMake(0,0 ,UGScreenW, 128+k_Height_NavBar)];
        [_uGPormotionView setBackgroundColor: [[UGSkinManagers shareInstance] setNavbgColor]];
    }
    [self.view addSubview:_uGPormotionView];
    
    [self.uGPormotionView  mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.equalTo(self.view.mas_left).with.offset(0);
         make.right.equalTo(self.view.mas_right).with.offset(0);
         make.width.equalTo(self.view.mas_width);
         make.height.mas_equalTo(128.0);
    }];
}


#pragma mark 设置右上角按钮

- (void)setupRightItem {
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(UGScreenW - 50,100, 50, 50)];
    UGUserModel *user = [UGUserModel currentUser];
    [rightButton setTitle:user.fullName forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightButton addTarget:self action:@selector(rightClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark 右上角按钮的点击方法

- (void)rightClicked {

    
}


#pragma mark - 配置segment

- (void)buildSegment
{
    self.itemArray = @[@"推荐信息",@"会员管理",@"投注报表",@"投注记录",@"域名绑定",@"存款报表",@"存款记录",@"提款报表",@"提款记录",@"真人报表",@"真人记录"];
    self.slideSwitchView = [[XYYSegmentControl alloc] initWithFrame:CGRectMake(0 , 128.0, self.view.width, self.view.height-128.0) channelName:self.itemArray source:self];
    [self.slideSwitchView setUserInteractionEnabled:YES];
    self.slideSwitchView.segmentControlDelegate = self;
    //设置tab 颜色(可选)
    self.slideSwitchView.tabItemNormalColor = [UIColor grayColor];
    self.slideSwitchView.tabItemNormalFont = 13;
    //设置tab 被选中的颜色(可选)
    self.slideSwitchView.tabItemSelectedColor = UGNavColor;
    //设置tab 背景颜色(可选)
    self.slideSwitchView.tabItemNormalBackgroundColor = [UIColor whiteColor];;
    //设置tab 被选中的标识的颜色(可选)
    self.slideSwitchView.tabItemSelectionIndicatorColor = UGNavColor;
    [self.view addSubview:self.slideSwitchView];
    
}

#pragma mark - XYYSegmentControlDelegate

- (NSUInteger)numberOfTab:(XYYSegmentControl *)view {
    return [self.itemArray count];//items决定
}

///待加载的控制器
- (UIViewController *)slideSwitchView:(XYYSegmentControl *)view viewOfTab:(NSUInteger)number {
    if (number == 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGPromotionInfoController" bundle:nil];
        UGPromotionInfoController *infoVC = [storyboard instantiateInitialViewController];
        return infoVC;
    } else if (number == 1) {
        return [[UGPromotionTableController alloc] initWithTableType:PromotionTableTypeMember];
    } else if (number == 2) {
        return [[UGPromotionTableController alloc] initWithTableType:PromotionTableTypeBettingReport];
    } else if (number == 3) {
        return [[UGPromotionTableController alloc] initWithTableType:PromotionTableTypeBettingRecord];
    } else if (number == 4) {
        return [[UGPromotionTableController alloc] initWithTableType:PromotionTableTypeDomainBinding];
    } else if (number == 5) {
        return [[UGPromotionTableController alloc] initWithTableType:PromotionTableTypeDepositStatement];
    } else if (number == 6) {
        return [[UGPromotionTableController alloc] initWithTableType:PromotionTableTypeDepositRecord];
    } else if (number == 7) {
        return [[UGPromotionTableController alloc] initWithTableType:PromotionTableTypeWithdrawalReport];
    } else if (number == 8) {
        return [[UGPromotionTableController alloc] initWithTableType:PromotionTableTypeWithdrawalRcord];
    } else if (number == 9) {
        return [[UGPromotionTableController alloc] initWithTableType:PromotionTableTypeRealityReport];
    } else  {
        return [[UGPromotionTableController alloc] initWithTableType:PromotionTableTypeRealityRcord];
    }
}

- (void)slideSwitchView:(XYYSegmentControl *)view didselectTab:(NSUInteger)number {
    //    UIViewController *root = view.viewArray[number];
    //    [root rootLoadData:number];
}

@end
