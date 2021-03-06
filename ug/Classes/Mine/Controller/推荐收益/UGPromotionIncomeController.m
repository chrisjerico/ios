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
#import "newPromotionInfoController.h"
#import "UGPormotionView.h"
#import "PromotionCodeListVC.h"


@interface UGPromotionIncomeController ()<XYYSegmentControlDelegate>

@property (nonatomic, strong) UGPormotionView *uGPormotionView;

@property (nonatomic, strong) XYYSegmentControl *slideSwitchView;
@property (nonatomic, strong) NSArray <NSString *> *itemArray;
@end

@implementation UGPromotionIncomeController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)skin {
    [self initView];
}

- (BOOL)允许游客访问 { return true; }

- (void)viewDidLoad {
    [super viewDidLoad];

    if (!self.title) {
        self.title =  @"推荐收益";
    }
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initView];
    SANotificationEventSubscribe(UGNotificationWithSkinSuccess, self, ^(typeof (self) self, id obj) {
        [self skin];
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_uGPormotionView refreshBalance:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // 在viewWillAppear:之后执行一次[self initView];
    {
        static BOOL __viewWillAppear = false;
        if (OBJOnceToken(self)) {
//            [self cc_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> ai) {
//                __viewWillAppear = true;
//            } error:nil];
        }
        if (__viewWillAppear) {
            [self initView];
            __viewWillAppear = false;
        }
    }
}

- (void)initView {
    //-签到按钮======================================
    {
        if (_uGPormotionView == nil) {
            _uGPormotionView = [[UGPormotionView alloc] initWithFrame:CGRectMake(0,0 , APP.Width, 128+k_Height_NavBar)];
            [_uGPormotionView setBackgroundColor: Skin1.navBarBgColor];
        }
        [self.view addSubview:_uGPormotionView];
        
        [self.uGPormotionView  mas_makeConstraints:^(MASConstraintMaker *make) {
             make.left.equalTo(self.view.mas_left).with.offset(0);
             make.right.equalTo(self.view.mas_right).with.offset(0);
             make.width.equalTo(self.view.mas_width);
             make.height.mas_equalTo(128.0);
        }];
    }
    
    // 若是游客则只显示占位图
    static UIImageView *placeholder = nil;  // 占位图
    if (UserI.isTest) {
        [self.view addSubview:({
            if (!placeholder) {
                placeholder = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"promotioninfo"]];
                placeholder.frame = CGRectMake(0, 130, APP.Width, APP.Width * (740/994.0));
            }
            placeholder;
        })];
        placeholder.hidden = false;
        self.slideSwitchView.hidden = true;
        return;
    }
    
    // 加载推荐收益信息
    placeholder.hidden = true;
    [self buildSegment];
    
    
    if (!APP.isHideYQM) {
        [self setupRightItem];
    }
   
}


#pragma mark 设置右上角按钮

- (void)setupRightItem {
	UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithTitle:UGSystemConfigModel.currentConfig.inviteCode.displayWord style:UIBarButtonItemStyleDone target:self action:@selector(rightClicked)];
	self.navigationItem.rightBarButtonItem = rightItem;
	[rightItem setTitleTextAttributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:14], NSForegroundColorAttributeName: UIColor.whiteColor} forState:UIControlStateNormal];
	[rightItem setTitleTextAttributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:14], NSForegroundColorAttributeName: UIColor.whiteColor} forState:UIControlStateHighlighted];

}


#pragma mark 右上角按钮的点击方法

- (void)rightClicked {
	PromotionCodeListVC * vc = [[PromotionCodeListVC alloc] init];
	[NavController1 pushViewController:vc animated:true];
    
}


#pragma mark - 配置segment

- (void)buildSegment {
    self.itemArray = @[@"推荐信息", @"会员管理", @"投注报表", @"投注记录", @"域名绑定", @"存款报表", @"存款记录", @"提款报表", @"提款记录", @"真人报表", @"真人记录"];
    [self.slideSwitchView removeFromSuperview];
//    self.slideSwitchView = [[XYYSegmentControl alloc] initWithFrame:CGRectMake(0 , 128.0, self.view.width, self.view.height-128.0) channelName:self.itemArray source:self];
//    [self.slideSwitchView setUserInteractionEnabled:YES];
//    self.slideSwitchView.segmentControlDelegate = self;
//    //设置tab 颜色(可选)
//    self.slideSwitchView.tabItemNormalColor = [UIColor grayColor];
//    self.slideSwitchView.tabItemNormalFont = 13;
//    //设置tab 被选中的颜色(可选)
//    self.slideSwitchView.tabItemSelectedColor = Skin1.navBarBgColor;
//    //设置tab 背景颜色(可选)
//    self.slideSwitchView.tabItemNormalBackgroundColor = [UIColor whiteColor];;
//    //设置tab 被选中的标识的颜色(可选)
//    self.slideSwitchView.tabItemSelectionIndicatorColor = Skin1.navBarBgColor;
//    [self.view addSubview:self.slideSwitchView];
    self.slideSwitchView = [[XYYSegmentControl alloc] initWithFrame:CGRectMake(0 , 0, self.view.width, self.view.height) channelName:self.itemArray source:self];
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
    [self.view addSubview:self.slideSwitchView];
}


#pragma mark - XYYSegmentControlDelegate

- (NSUInteger)numberOfTab:(XYYSegmentControl *)view {
    return [self.itemArray count];//items决定
}

///待加载的控制器
- (UIViewController *)slideSwitchView:(XYYSegmentControl *)view viewOfTab:(NSUInteger)number {
    if (number == 0) {
        newPromotionInfoController *infoVC = _LoadVC_from_storyboard_(@"newPromotionInfoController");
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
