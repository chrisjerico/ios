//
//  UGSecurityCenterViewController.m
//  ug
//
//  Created by ug on 2019/5/7.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGSecurityCenterViewController.h"
#import "XYYSegmentControl.h"
#import "UGModifyPayPwdController.h"
#import "UGModifyLoginPwdController.h"
#import "UGModifyLoginPlaceController.h"

@interface UGSecurityCenterViewController ()<XYYSegmentControlDelegate>
@property (nonatomic, strong) XYYSegmentControl *slideSwitchView;
@property (nonatomic,strong)  NSArray *itemArray;
@end

@implementation UGSecurityCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"安全中心";
    self.view.backgroundColor = UGBackgroundColor;
    
    [self buildSegment];
}

#pragma mark - 配置segment
-(void)buildSegment
{
    self.itemArray = @[@"登录密码",@"取款密码",@"常用登录地"];
    self.slideSwitchView = [[XYYSegmentControl alloc] initWithFrame:CGRectMake(0 , 0, self.view.width, self.view.height) channelName:self.itemArray source:self];
    [self.slideSwitchView setUserInteractionEnabled:YES];
    self.slideSwitchView.segmentControlDelegate = self;
    //设置tab 颜色(可选)
    self.slideSwitchView.tabItemNormalColor = [UIColor grayColor];
    self.slideSwitchView.tabItemNormalFont = 13;
    //设置tab 被选中的颜色(可选)
    self.slideSwitchView.tabItemSelectedColor = UGNavColor;
    //设置tab 背景颜色(可选)
    self.slideSwitchView.tabItemNormalBackgroundColor = [UIColor clearColor];
    //设置tab 被选中的标识的颜色(可选)
    self.slideSwitchView.tabItemSelectionIndicatorColor = UGNavColor;
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
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGSafety" bundle:nil];
    if (number == 0) {
        UGModifyLoginPwdController *PwdVC = [storyboard instantiateViewControllerWithIdentifier:@"UGModifyLoginPwdController"];
        return PwdVC;
    }else if (number == 1) {
        
        UGModifyPayPwdController *payVC = [storyboard instantiateViewControllerWithIdentifier:@"UGModifyPayPwdController"];
        return payVC;
    }else {
        
        UGModifyLoginPlaceController *loginPlaceVC = [storyboard instantiateViewControllerWithIdentifier:@"UGModifyLoginPlaceController"];
        return loginPlaceVC;
    }
    
}

- (void)slideSwitchView:(XYYSegmentControl *)view didselectTab:(NSUInteger)number
{
  
    
}


@end
