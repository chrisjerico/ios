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
@property (nonatomic,strong)  NSMutableArray <NSString *> *itemArray;//slideSwitchView 的分栏标题
@property (nonatomic,strong)  NSMutableArray <UGMissionListController *> *viewsArray;//slideSwitchView 的分栏视图
@property (nonatomic,strong)  NSMutableArray <UGMissionlistModel *> *disArray;
@end

@implementation UGMissionMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = Skin1.is23 ? RGBA(135 , 135 ,135, 1) : Skin1.bgColor;
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
            NSArray *list = [data isKindOfClass:[NSDictionary class]] ? [data objectForKey:@"list"] : ([data isKindOfClass:[NSArray class]] ? data : nil);
//            NSLog(@"list = %@",list);
            
            NSMutableArray * dataArray = [UGMissionModel arrayOfModelsFromDictionaries:list error:nil];
            

            NSMutableArray *typeArray = [NSMutableArray new];
            
            //去除数组中重复sortId数据，得到多少任务类型
            NSMutableArray *sortArray = [NSMutableArray new];
            NSMutableArray *sortObjArray = [NSMutableArray new];
            for (UGMissionModel *object in dataArray) {
                
                if (![sortArray containsObject:object.sortId]) {
                    [sortArray addObject:object.sortId];
                    [sortObjArray addObject:object];
                }
            }
 
            for (int i = 0; i<  sortObjArray.count; i++) {
                UGMissionModel *obj = [sortObjArray objectAtIndex:i];
                UGMissionlistModel *dic = [UGMissionlistModel new];
                [dic setSordId:obj.sortId];
                [dic setTypeSort:obj.typeSort];
                if ([CMCommon arryIsNull:dic.typeData]) {
                    dic.typeData = [NSMutableArray new];
                }
                [typeArray addObject:dic];

            }

            //全部数据组装
            for (UGMissionModel *object in dataArray) {
                
                for (UGMissionlistModel *dic in typeArray) {
                    if ([dic.sordId isEqualToString:object.sortId]) {
                        [dic setSortName:object.sortName];
                        [dic.typeData addObject:object];
                    }
                }
            }
            
            for (UGMissionlistModel *dd in typeArray) {
                if (![CMCommon arryIsNull:dd.typeData]) {
                    [weakSelf.disArray addObject:dd];
                }
            }
            
            if (!weakSelf.disArray.count) {
                return;
            }

            // 排序key, 某个对象的属性名称，是否升序, YES-升序, NO-降序
            NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"typeSort" ascending:YES];
            // 排序结果
            NSArray <UGMissionlistModel *> * tempArr =  [NSArray new];
            tempArr = [self.disArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
            
//            NSLog(@"weakSelf.tempArr=====%@",tempArr);
            if (![CMCommon arryIsNull:tempArr]) {
                for (UGMissionlistModel *dd in tempArr) {
                    if (dd.sortName) {
                        [weakSelf.itemArray addObject:dd.sortName ];
                    } else {
                        [weakSelf.itemArray addObject:dd.sordId ];
                    }
                    UGMissionListController * realView  = [[UGMissionListController alloc] initWithStyle:UITableViewStyleGrouped]; ;
                    realView.typeid = dd.sordId;
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
    self.slideSwitchView.tabItemNormalColor = [UIColor blackColor];
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
