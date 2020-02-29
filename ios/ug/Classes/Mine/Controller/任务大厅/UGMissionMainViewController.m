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
#import "UGMissionModel.h"
@interface UGMissionMainViewController ()<XYYSegmentControlDelegate>
@property (nonatomic, strong)XYYSegmentControl *slideSwitchView;
@property (nonatomic,strong)  NSMutableArray <NSString *> *itemArray;
@property (nonatomic,strong)  NSMutableArray <UGMissionListController *> *viewsArray;

@property (nonatomic,strong)  NSMutableArray <NSMutableDictionary *> *disArray;
@end

@implementation UGMissionMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = Skin1.bgColor;
    _itemArray =[NSMutableArray new];
    _viewsArray = [NSMutableArray new];
    _disArray = [NSMutableArray new];
    
  
    if (1) {
        [self getCenterData];
    }
    else{
        UGMissionListController * realView  = [[UGMissionListController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.view addSubview:realView.view];
        [realView.view  mas_remakeConstraints:^(MASConstraintMaker *make)
         {
            make.left.equalTo(self.view.mas_left).with.offset(0);
            make.right.equalTo(self.view.mas_right).with.offset(0);
            make.top.equalTo(self.view.mas_top).offset(0);
            make.bottom.equalTo(self.view.mas_bottom).offset(0);
        }];
    }
    
}

//得到列表数据
- (void)getCenterData {
    if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
        return;
    }
    NSDictionary *params = [NSDictionary new];
    
    params = @{@"token":[UGUserModel currentUser].sessid,
               @"page":@"1",
               @"rows":@"1000",
               
    };
    
    
    [SVProgressHUD showWithStatus:nil];
    WeakSelf;
    [CMNetwork centerWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            [SVProgressHUD dismiss];
            NSDictionary *data =  model.data;
            NSArray *list = [data objectForKey:@"list"];
            NSLog(@"list = %@",list);
            
            NSMutableArray * dataArray = [UGMissionModel arrayOfModelsFromDictionaries:list error:nil];
            
            
            NSMutableArray *typeArray = [NSMutableArray new];
            
            //去除数组中重复sortId数据，得到多少任务类型
            NSMutableArray *sortArray = [NSMutableArray new];
            for (UGMissionModel *object in dataArray) {
                
                if (![sortArray containsObject:object.sortId]) {
                    [sortArray addObject:object.sortId];
                }
            }
            
            for (NSString *sortStr in sortArray) {
                NSMutableDictionary *dic = [NSMutableDictionary new];
                [dic setValue:sortStr forKey:@"sortId"];
                NSMutableArray *typeDataArray = [NSMutableArray new];
                if (![dic objectForKey:@"typeData"]) {
                    [dic setValue:typeDataArray forKey:@"typeData"];
                }
                [typeArray addObject:dic];
            }
            
            //全部数据组装
            for (UGMissionModel *object in dataArray) {
                
                for (NSMutableDictionary *dic in typeArray) {
                    if ([dic[@"sortId"] isEqualToString:object.sortId]) {
                        [dic setValue:object.sortName forKey:@"sortName"];
                        NSMutableArray *typeDataArray = dic[@"typeData"];
                        [typeDataArray addObject:object];
                    }
                }
            }
            
            for (NSMutableDictionary *dd in typeArray) {
                NSLog(@"sortName = %@",[dd objectForKey:@"sortName"]);
                NSLog(@"typeData = %@",[dd objectForKey:@"typeData"]);
                if (![CMCommon arryIsNull:[dd objectForKey:@"typeData"]]) {
                    [weakSelf.disArray addObject:dd];
                }
            }
            
            if (![CMCommon arryIsNull:weakSelf.disArray]) {
                for (NSMutableDictionary *dd in weakSelf.disArray) {
                    if (dd[@"sortName"]) {
                        [weakSelf.itemArray addObject:dd[@"sortName"] ];
                    } else {
                        [weakSelf.itemArray addObject:dd[@"sortId"] ];
                    }
                    UGMissionListController * realView  = [[UGMissionListController alloc] initWithStyle:UITableViewStyleGrouped]; ;
                    realView.typeid = dd[@"sortId"];
                    [weakSelf.viewsArray addObject:realView];
                }
                [weakSelf buildSegment];
            }
            
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
    self.slideSwitchView.tabItemNormalBackgroundColor = [UIColor whiteColor];
    //设置tab 被选中的标识的颜色(可选)
    self.slideSwitchView.tabItemSelectionIndicatorColor = RGBA(203, 43, 37, 1.0) ;
    //设置tab 被选中标识的风格
    self.slideSwitchView.tabSelectionStyle = XYYSegmentedControlSelectionStyleBox;
    
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
