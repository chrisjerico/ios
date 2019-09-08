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

@interface UGPromotionIncomeController ()<XYYSegmentControlDelegate>

@property (nonatomic, strong) XYYSegmentControl *slideSwitchView;
@property (nonatomic, strong) NSArray *itemArray;
@end

@implementation UGPromotionIncomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"推荐收益";
    self.view.backgroundColor = UGBackgroundColor;
    [self buildSegment];
    [self setupRightItem];
    
}

#pragma mark 设置右上角按钮
- (void)setupRightItem{
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
- (void)rightClicked{

    
}


#pragma mark - 配置segment
-(void)buildSegment
{
    self.itemArray = @[@"推荐信息",@"会员管理",@"投注报表",@"投注记录",@"域名绑定",@"存款报表",@"存款记录",@"提款报表",@"提款记录",@"真人报表",@"真人记录"];
    self.slideSwitchView = [[XYYSegmentControl alloc] initWithFrame:CGRectMake(0 , 0, self.view.width, self.view.height) channelName:self.itemArray source:self];
    [self.slideSwitchView setUserInteractionEnabled:YES];
    self.slideSwitchView.segmentControlDelegate = self;
    //设置tab 颜色(可选)
    self.slideSwitchView.tabItemNormalColor = [UIColor grayColor];
    self.slideSwitchView.tabItemNormalFont = 13;
    //设置tab 被选中的颜色(可选)
    self.slideSwitchView.tabItemSelectedColor = [UIColor colorWithRed:233/255.0 green:82/255.0 blue:129/255.0 alpha:1.0];
    //设置tab 背景颜色(可选)
    self.slideSwitchView.tabItemNormalBackgroundColor = [UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1.0];
    //设置tab 被选中的标识的颜色(可选)
    self.slideSwitchView.tabItemSelectionIndicatorColor = [UIColor colorWithRed:233/255.0 green:82/255.0 blue:129/255.0 alpha:1.0];
    [self.view addSubview:self.slideSwitchView];
    
}

#pragma mark - XYYSegmentControlDelegate
-(NSUInteger)numberOfTab:(XYYSegmentControl *)view
{
    return [self.itemArray count];//items决定

}

///待加载的控制器
-(UIViewController *)slideSwitchView:(XYYSegmentControl *)view viewOfTab:(NSUInteger)number
{
    if (number == 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGPromotionInfoController" bundle:nil];
        UGPromotionInfoController *infoVC = [storyboard instantiateInitialViewController];
        return infoVC;
    }else if (number == 1) {
        UGPromotionTableController *tableVC = [[UGPromotionTableController alloc] initWithTableType:PromotionTableTypeMember];
        return tableVC;
    }else if (number == 2) {
        UGPromotionTableController *tableVC = [[UGPromotionTableController alloc] initWithTableType:PromotionTableTypeBettingReport];
        return tableVC;
    }else if (number == 3) {
        UGPromotionTableController *tableVC = [[UGPromotionTableController alloc] initWithTableType:PromotionTableTypeBettingRecord];
        return tableVC;
    }else if (number == 4) {
        UGPromotionTableController *tableVC = [[UGPromotionTableController alloc] initWithTableType:PromotionTableTypeDomainBinding];
        return tableVC;
    }else if (number == 5) {
        UGPromotionTableController *tableVC = [[UGPromotionTableController alloc] initWithTableType:PromotionTableTypeDepositStatement];
        return tableVC;
    }else if (number == 6) {
        UGPromotionTableController *tableVC = [[UGPromotionTableController alloc] initWithTableType:PromotionTableTypeDepositRecord];
        return tableVC;
    }else if (number == 7) {
        UGPromotionTableController *tableVC = [[UGPromotionTableController alloc] initWithTableType:PromotionTableTypeWithdrawalReport];
        return tableVC;
    }else if (number == 8) {
        UGPromotionTableController *tableVC = [[UGPromotionTableController alloc] initWithTableType:PromotionTableTypeWithdrawalRcord];
        return tableVC;
        
    }else if (number == 9) {
        UGPromotionTableController *tableVC = [[UGPromotionTableController alloc] initWithTableType:PromotionTableTypeRealityReport];
        return tableVC;
        
    }else  {
        UGPromotionTableController *tableVC = [[UGPromotionTableController alloc] initWithTableType:PromotionTableTypeRealityRcord];
        return tableVC;
        
    }
    
}

- (void)slideSwitchView:(XYYSegmentControl *)view didselectTab:(NSUInteger)number
{
    //    UIViewController *root = view.viewArray[number];
    //    [root rootLoadData:number];
}




@end
