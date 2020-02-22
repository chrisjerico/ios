//
//  PromoteViewController.m
//  ug
//
//  Created by ug on 2020/2/22.
//  Copyright © 2020 ug. All rights reserved.
//

#import "PromoteMainViewController.h"
#import "XYYSegmentControl.h"
#import "UGPromotionsController.h"
#import "UGBMHeaderView.h"
@interface PromoteMainViewController ()<XYYSegmentControlDelegate>{
    UGBMHeaderView *headView;                /**<   黑色模板导航头 */
}
@property (nonatomic, strong)XYYSegmentControl *slideSwitchView;
@property (nonatomic,strong)  NSMutableArray <NSString *> *itemArray;
@property (nonatomic,strong)  NSMutableArray <UGPromotionsController *> *viewsArray;
@end

@implementation PromoteMainViewController

- (BOOL)允许未登录访问 { return ![@"c049,c008" containsString:APP.SiteId]; }
- (BOOL)允许游客访问 { return true; }

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"优惠活动";
    self.view.backgroundColor = Skin1.bgColor;
    _itemArray =[NSMutableArray new];
    _viewsArray = [NSMutableArray new];
    
    if (SysConf.typeIsShow == 1) {
        [SysConf.typyArr enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSLog(@"key = %@ and obj = %@", key, obj);
            [_itemArray addObject:obj ];
            
            UGPromotionsController * realView  = _LoadVC_from_storyboard_(@"UGPromotionsController") ;
            realView.typeid = key;
            
            [_viewsArray addObject:realView];
        }];
        
        [self buildSegment];
    }
    
    
    
    
    
}
#pragma mark - UI

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
    if (Skin1.isBlack) {
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
    self.slideSwitchView.tabItemNormalColor = Skin1.textColor1;
    self.slideSwitchView.tabItemNormalFont = 13;
    //设置tab 被选中的颜色(可选)
    self.slideSwitchView.tabItemSelectedColor = RGBA(203, 43, 37, 1.0) ;
    //设置tab 背景颜色(可选)
    self.slideSwitchView.tabItemNormalBackgroundColor = Skin1.bgColor;
    //设置tab 被选中的标识的颜色(可选)
    self.slideSwitchView.tabItemSelectionIndicatorColor = RGBA(203, 43, 37, 1.0) ;
    
}

#pragma mark - XYYSegmentControlDelegate

- (NSUInteger)numberOfTab:(XYYSegmentControl *)view {
    return [self.itemArray count];//items决定
}

///待加载的控制器
- (UIViewController *)slideSwitchView:(XYYSegmentControl *)view viewOfTab:(NSUInteger)number {
    
    UGPromotionsController * realView  = [_viewsArray objectAtIndex:number];
    return realView;
    
}

- (void)slideSwitchView:(XYYSegmentControl *)view didselectTab:(NSUInteger)number {
    
    UGPromotionsController * realView  = [_viewsArray objectAtIndex:number];
    [realView dataReLoad];
    
}

@end
