//
//  UGChangLongController.m
//  ug
//
//  Created by ug on 2019/5/18.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGChangLongController.h"
#import "XYYSegmentControl.h"
#import "UGLotteryAssistantController.h"
#import "UGBetRecordTableViewController.h"
#import "STBarButtonItem.h"
#import "UGLotteryRulesView.h"
#import "UGChanglongBetRecordController.h"

@interface UGChangLongController ()<XYYSegmentControlDelegate>
@property (nonatomic, strong) XYYSegmentControl *slideSwitchView;
@property (nonatomic,strong)  NSArray<NSString *> *itemArray;

@property (nonatomic, strong) STBarButtonItem *rightItem1;
@end

@implementation UGChangLongController

- (void)skin {
    self.view.backgroundColor = Skin1.bgColor;
    [self buildSegment];
    [self getAllNextIssueData];
}

- (BOOL)允许游客访问 { return true; }

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"长龙助手";
    self.view.backgroundColor = Skin1.bgColor;
    
    SANotificationEventSubscribe(UGNotificationGetUserInfoComplete, self, ^(typeof (self) self, id obj) {
        STButton *button = (STButton *)self.rightItem1.customView;
        [button.imageView.layer removeAllAnimations];
        
        UGUserModel *user = [UGUserModel currentUser];
        STBarButtonItem *item0 = [STBarButtonItem barButtonItemLeftWithImageName:@"shuaxin" title:[user.balance removeFloatAllZero] target:self action:@selector(refreshBalance)];
        self.rightItem1 = item0;
        STBarButtonItem *item1 = [STBarButtonItem barButtonItemWithImageName:@"baiguize" target:self action:@selector(showRightMenueView)];
        self.navigationItem.rightBarButtonItems = @[item1,item0];
        
    });
    SANotificationEventSubscribe(UGNotificationWithSkinSuccess, self, ^(typeof (self) self, id obj) {
        [self skin];
    });
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (OBJOnceToken(self))
        [self buildSegment];
}


#pragma mark - 配置segment

- (void)buildSegment {
    UGUserModel *user = [UGUserModel currentUser];
    self.itemArray = @[@"最新长龙", @"我的投注"];
    STBarButtonItem *item0 = [STBarButtonItem barButtonItemLeftWithImageName:@"shuaxin" title:[user.balance removeFloatAllZero] target:self action:@selector(refreshBalance)];
    self.rightItem1 = item0;
    STBarButtonItem *item1 = [STBarButtonItem barButtonItemWithImageName:@"baiguize" target:self action:@selector(showRightMenueView)];
    self.navigationItem.rightBarButtonItems = @[item1,item0];
    
    self.slideSwitchView = [[XYYSegmentControl alloc] initWithFrame:CGRectMake(0 , 0, self.view.width, self.view.height) channelName:self.itemArray source:self];
    [self.slideSwitchView setUserInteractionEnabled:YES];
    self.slideSwitchView.segmentControlDelegate = self;
    //设置tab 颜色(可选)
    self.slideSwitchView.tabItemNormalColor = [UIColor grayColor];
    self.slideSwitchView.tabItemNormalFont = 13;
    //设置tab 被选中的颜色(可选)
    self.slideSwitchView.tabItemSelectedColor = Skin1.navBarBgColor;
    //设置tab 背景颜色(可选)
    self.slideSwitchView.tabItemNormalBackgroundColor = [UIColor whiteColor];
    //设置tab 被选中的标识的颜色(可选)
    self.slideSwitchView.tabItemSelectionIndicatorColor = Skin1.navBarBgColor;
    [self.view addSubview:self.slideSwitchView];
}

- (void)showRightMenueView {
    UGLotteryRulesView *rulesView = [[UGLotteryRulesView alloc] initWithFrame:CGRectMake(30, 120, UGScreenW - 60, UGScerrnH - 230)];
    rulesView.title = @"游戏规则";
    rulesView.content = @"   长龙助手是对快3、时时彩、PK10、六合彩、幸运飞艇、北京赛车等特定玩法的“大小单双” 开奖结果进行跟踪统计，并可进行快捷投注的助手工具；\n    每期出现大、小、单、双的概率为50%，如果连续3期及以上的开奖结果相同，称之为“长龙”，通常会采用倍投的方式进行“砍龙”或“顺龙”。\n\n  1、什么是砍龙？\n  如连续开5期“单”，可以选择“双”进行投注，这种投注方案称之为“砍龙”；\n\n  2、什么是顺龙？\n  如连续开5期“单”，继续选择“单”进行投注，这种投注方案称之为“顺龙”；\n\n  3、什么是倍投？\n  倍投是一种翻倍投注方式，是为了保障能够在“砍龙”或“顺龙”的过程中持续盈利的一种投注方式。";
    [rulesView show];
}

- (void)refreshBalance {
    [self startAnimation];
    SANotificationEventPost(UGNotificationGetUserInfo, nil);
}

//刷新余额动画
-(void)startAnimation {
    CABasicAnimation *ReFreshAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    ReFreshAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
    ReFreshAnimation.duration = 1;
    ReFreshAnimation.repeatCount = HUGE_VALF;
    STButton *button = (STButton *)self.rightItem1.customView;
    [button.imageView.layer addAnimation:ReFreshAnimation forKey:@"rotationAnimation"];
}


#pragma mark - XYYSegmentControlDelegate

- (NSUInteger)numberOfTab:(XYYSegmentControl *)view {
    return [self.itemArray count];//items决定
}

///待加载的控制器
- (UIViewController *)slideSwitchView:(XYYSegmentControl *)view viewOfTab:(NSUInteger)number {
    if (number == 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGLotteryAssistantController" bundle:nil];
        UGLotteryAssistantController *assistantView = [storyboard instantiateViewControllerWithIdentifier:@"UGLotteryAssistantController"];
        return assistantView;
    } else {
        UGChanglongBetRecordController *betRecordVC = [[UGChanglongBetRecordController alloc] initWithStyle:UITableViewStyleGrouped];
        if ([CMCommon arryIsNull:self.lotteryGamesArray]) {
            return betRecordVC;
        }
        else {
            betRecordVC.lotteryGamesArray = self.lotteryGamesArray;
            return betRecordVC;
        }
    }
}

- (void)slideSwitchView:(XYYSegmentControl *)view didselectTab:(NSUInteger)number {
    if (number) {
        SANotificationEventPost(UGNotificationGetChanglongBetRecrod, nil);
    }
}

- (void )getAllNextIssueData {
    [CMNetwork getAllNextIssueWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            self.lotteryGamesArray = model.data;
        } failure:^(id msg) {
            [SVProgressHUD dismiss];
        }];
    }];
}

@end
