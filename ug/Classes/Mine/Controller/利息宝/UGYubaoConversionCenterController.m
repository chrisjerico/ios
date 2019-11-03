//
//  UGYubaoConversionCenterController.m
//  ug
//
//  Created by ug on 2019/5/25.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGYubaoConversionCenterController.h"
#import "XYYSegmentControl.h"
#import "UGYubaoConversionViewController.h"

@interface UGYubaoConversionCenterController ()<XYYSegmentControlDelegate>
@property (nonatomic, strong) XYYSegmentControl *slideSwitchView;
@property (nonatomic,strong)  NSArray <NSString *> *itemArray;
@end

@implementation UGYubaoConversionCenterController
-(void)skin{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    SANotificationEventSubscribe(UGNotificationWithSkinSuccess, self, ^(typeof (self) self, id obj) {
        
        [self skin];
    });
    self.navigationItem.title = @"转入利息宝";
    [self buildSegment];
}

#pragma mark - 配置segment
-(void)buildSegment
{
    self.itemArray = @[@"转入",@"转出"];
    self.slideSwitchView = [[XYYSegmentControl alloc] initWithFrame:CGRectMake(0 , 0, self.view.width, self.view.height) channelName:self.itemArray source:self];
    [self.slideSwitchView setUserInteractionEnabled:YES];
    self.slideSwitchView.segmentControlDelegate = self;
    //设置tab 颜色(可选)
    self.slideSwitchView.tabItemNormalColor = [UIColor grayColor];
    self.slideSwitchView.tabItemNormalFont = 13;
    //设置tab 被选中的颜色(可选)
    self.slideSwitchView.tabItemSelectedColor = Skin1.navBarBgColor;
    //设置tab 背景颜色(可选)
    self.slideSwitchView.tabItemNormalBackgroundColor = [UIColor whiteColor];;
    //设置tab 被选中的标识的颜色(可选)
    self.slideSwitchView.tabItemSelectionIndicatorColor = Skin1.navBarBgColor;
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
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGYubaoViewController" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"UGYubaoConversionViewController"];
    
}

- (void)slideSwitchView:(XYYSegmentControl *)view didselectTab:(NSUInteger)number
{
    //    UIViewController *root = view.viewArray[number];
    //    [root rootLoadData:number];
}



@end
