//
//  UGMissionMainViewController.m
//  ug
//
//  Created by ug on 2020/2/26.
//  Copyright © 2020 ug. All rights reserved.
//

#import "UGMissionMainViewController.h"
#import "XYYSegmentControl.h"
#import "UGMissionListController.h"
@interface UGMissionMainViewController ()<XYYSegmentControlDelegate>
@property (nonatomic, strong)XYYSegmentControl *slideSwitchView;
@property (nonatomic,strong)  NSMutableArray <NSString *> *itemArray;
@property (nonatomic,strong)  NSMutableArray <UGMissionListController *> *viewsArray;
@end

@implementation UGMissionMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = Skin1.bgColor;
    _itemArray =[NSMutableArray new];
    _viewsArray = [NSMutableArray new];
        [self getCategoriesData];
}

//任务大厅分类数据
- (void)getCategoriesData {
    if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
        return;
    }
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
    };
    
    [SVProgressHUD showWithStatus:nil];
    WeakSelf;
    [CMNetwork categoriesWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            [SVProgressHUD dismiss];
            NSArray *data =  model.data;
            for (NSDictionary *dataDic in data) {
                NSLog(@"dataDic = %@",dataDic);
                [weakSelf.itemArray addObject:dataDic[@"sortName"] ];
                UGMissionListController * realView  = [[UGMissionListController alloc] initWithStyle:UITableViewStyleGrouped]; ;
                realView.typeid = dataDic[@"id"];
                [weakSelf.viewsArray addObject:realView];
            }
            [weakSelf buildSegment];
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
        
    }];
}


- (void)buildSegment
{
    
    self.slideSwitchView = [[XYYSegmentControl alloc] initWithFrame:CGRectMake(0 , 0, self.view.width, self.view.height) channelName:self.itemArray source:self];
    [self.view addSubview:self.slideSwitchView];
    
    
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
    
    UGMissionListController * realView  = [_viewsArray objectAtIndex:number];
    return realView;
    
}

- (void)slideSwitchView:(XYYSegmentControl *)view didselectTab:(NSUInteger)number {
    
    UGMissionListController * realView  = [_viewsArray objectAtIndex:number];
    [realView dataReLoad];
    
}
@end
