//
//  UGMosaicGoldViewController.m
//  ug
//
//  Created by ug on 2019/9/18.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGMosaicGoldViewController.h"
#import "XYYSegmentControl.h"
#import "UGActivityGoldTableViewController.h"
#import "UGMosaicGoldController.h"

@interface UGMosaicGoldViewController ()<XYYSegmentControlDelegate>
@property (nonatomic, strong) XYYSegmentControl *slideSwitchView;
@property (nonatomic,strong)  NSArray *itemArray;

@end

@implementation UGMosaicGoldViewController
-(void)skin{
    [self.view setBackgroundColor: [[UGSkinManagers shareInstance] setbgColor]];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"活动彩金";
    [self.view setBackgroundColor: [[UGSkinManagers shareInstance] setbgColor]];
    SANotificationEventSubscribe(UGNotificationWithSkinSuccess, self, ^(typeof (self) self, id obj) {
        
        [self skin];
    });
    [self buildSegment];
}

- (void)viewDidLayoutSubviews {
    
    [self.slideSwitchView changeSlideAtSegmentIndex:self.selectIndex];
}

#pragma mark - 配置segment
-(void)buildSegment
{
    self.itemArray = @[@"申请彩金",@"申请反馈"];
    self.slideSwitchView = [[XYYSegmentControl alloc] initWithFrame:CGRectMake(0 , 0, self.view.width, self.view.height) channelName:self.itemArray source:self];
    [self.slideSwitchView setUserInteractionEnabled:YES];
    self.slideSwitchView.segmentControlDelegate = self;
    //设置tab 颜色(可选)
    self.slideSwitchView.tabItemNormalColor = [UIColor grayColor];
    self.slideSwitchView.tabItemNormalFont = 13;
    //设置tab 被选中的颜色(可选)
    self.slideSwitchView.tabItemSelectedColor = [[UGSkinManagers shareInstance] setNavbgColor];
    //设置tab 背景颜色(可选)
    self.slideSwitchView.tabItemNormalBackgroundColor = [UIColor whiteColor];
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
    if (number == 0) {
       
        UGMosaicGoldController *vc = [[UGMosaicGoldController alloc] init];
        return  vc;
        
    }
    else {
        
        UGActivityGoldTableViewController *vc = [[UGActivityGoldTableViewController alloc] init];
        return  vc;
        
        
    }
    
}

-(void)slideSwitchView:(XYYSegmentControl *)view didselectTab:(NSUInteger)number
{
    
    if (number == 0) {
        UGMosaicGoldController *vc  = (UGMosaicGoldController *) view.viewArray[number];
        [vc rootLoadData];
     
    }
    else {
        UGActivityGoldTableViewController *vc  = (UGActivityGoldTableViewController *) view.viewArray[number];
        [vc rootLoadData];
        
    }
}
@end
