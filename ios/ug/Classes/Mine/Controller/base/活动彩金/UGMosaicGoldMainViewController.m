//
//  UGMosaicGoldMainViewController.m
//  UGBWApp
//
//  Created by ug on 2020/3/7.
//  Copyright © 2020 ug. All rights reserved.
//

#import "UGMosaicGoldMainViewController.h"
#import "XYYSegmentControl.h"
#import "UGMosaicGoldController.h"
#import "UGMosaicGoldModel.h"
@interface UGMosaicGoldMainViewController ()<XYYSegmentControlDelegate>
@property (nonatomic, strong)XYYSegmentControl *slideSwitchView;
@property (nonatomic,strong)  NSMutableArray <NSString *> *itemArray;
@property (nonatomic,strong)  NSMutableArray <UGMosaicGoldController *> *viewsArray;

@property (nonatomic,strong)  NSMutableArray <NSMutableDictionary *> *disArray;

@end

@implementation UGMosaicGoldMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
      self.view.backgroundColor = Skin1.bgColor;

    [self dataArryInit];
    [self getSystemConfig];
     
}

-(void)dataArryInit{
    _itemArray =[NSMutableArray new];
    _viewsArray = [NSMutableArray new];
    _disArray = [NSMutableArray new];
}

- (void)rootLoadData {

    NSLog(@"switchShowActivityCategory =%d",SysConf.switchShowActivityCategory);
    if (SysConf.switchShowActivityCategory) {
             [self getCenterData];
         }
         else{
             UGMosaicGoldController * realView  = [[UGMosaicGoldController alloc] initWithStyle:UITableViewStyleGrouped];
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

// 获取系统配置
- (void)getSystemConfig {
    [CMNetwork getSystemConfigWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            NSLog(@"model = %@",model);
            
            UGSystemConfigModel *config = model.data;
            UGSystemConfigModel.currentConfig = config;
            [self rootLoadData];
            
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }];
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
               @"category":@"0",//0 那就是 筛选除了未分类的其他所有数据
               
    };
    
    
    [SVProgressHUD showWithStatus:nil];
    WeakSelf;
    [CMNetwork activityWinApplyListWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            [self.itemArray removeAllObjects];
            [self.viewsArray removeAllObjects];
            [self.disArray removeAllObjects];
            
            [SVProgressHUD dismiss];
            NSDictionary *data =  model.data;
            NSArray *list = [data objectForKey:@"list"];
            NSLog(@"list = %@",list);
            
            NSMutableArray * dataArray = [UGMosaicGoldModel arrayOfModelsFromDictionaries:list error:nil];
            
            
            NSMutableArray *typeArray = [NSMutableArray new];
            
            //去除数组中重复category数据，得到多少任务类型
            NSMutableArray *sortArray = [NSMutableArray new];
            for (UGMosaicGoldModel *object in dataArray) {
                
                if (![sortArray containsObject:object.category]) {
                    [sortArray addObject:object.category];
                }
            }
            
            for (NSString *sortStr in sortArray) {
                NSMutableDictionary *dic = [NSMutableDictionary new];
                [dic setValue:sortStr forKey:@"category"];
                NSMutableArray *typeDataArray = [NSMutableArray new];
                if (![dic objectForKey:@"typeData"]) {
                    [dic setValue:typeDataArray forKey:@"typeData"];
                }
                [typeArray addObject:dic];
            }
            
            //全部数据组装
            for (UGMosaicGoldModel *object in dataArray) {
                
                for (NSMutableDictionary *dic in typeArray) {
                    if ([dic[@"category"] isEqualToString:object.category]) {
                        [dic setValue:object.categoryName forKey:@"categoryName"];
                        NSMutableArray *typeDataArray = dic[@"typeData"];
                        [typeDataArray addObject:object];
                    }
                }
            }
            
            for (NSMutableDictionary *dd in typeArray) {
                NSLog(@"categoryName = %@",[dd objectForKey:@"categoryName"]);
                NSLog(@"typeData = %@",[dd objectForKey:@"typeData"]);
                if (![CMCommon arryIsNull:[dd objectForKey:@"typeData"]]) {
                    [weakSelf.disArray addObject:dd];
                }
            }
            
            if (![CMCommon arryIsNull:weakSelf.disArray]) {
                 [weakSelf.itemArray addObject:@"全部"];
                UGMosaicGoldController * realView  = [[UGMosaicGoldController alloc] initWithStyle:UITableViewStyleGrouped]; ;
                realView.typeid = @"";
                [weakSelf.viewsArray addObject:realView];
                

                for (NSMutableDictionary *dd in weakSelf.disArray) {
                    if (dd[@"categoryName"]) {
                        [weakSelf.itemArray addObject:dd[@"categoryName"] ];
                    } else {
                        [weakSelf.itemArray addObject:dd[@"category"] ];
                    }
                    UGMosaicGoldController * realView  = [[UGMosaicGoldController alloc] initWithStyle:UITableViewStyleGrouped]; ;
                    realView.typeid = dd[@"category"];
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
    self.slideSwitchView.tabItemNormalBackgroundColor = Skin1.isBlack||Skin1.is23 ? Skin1.textColor4:[UIColor whiteColor];
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
    
    UGMosaicGoldController * realView  = [_viewsArray objectAtIndex:number];
    return realView;
    
}

- (void)slideSwitchView:(XYYSegmentControl *)view didselectTab:(NSUInteger)number {
    
    UGMosaicGoldController * realView  = [_viewsArray objectAtIndex:number];
    [realView rootLoadData];
    
}
@end

