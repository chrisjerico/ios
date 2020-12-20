//
//  UGTaskNoticeView.m
//  UGBWApp
//
//  Created by ug on 2020/12/15.
//  Copyright © 2020 ug. All rights reserved.
//

#import "UGTaskNoticeView.h"
#import "HMSegmentedControl.h"
#import "UGMissionTableViewCell.h"
#import "UGMissionModel.h"
@interface UGTaskNoticeView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)HMSegmentedControl *slideSwitchView;
@property (weak, nonatomic) IBOutlet UIView *bgView;//背景视图
@property (weak, nonatomic) IBOutlet UIView *contentView; //内容视图
@property (weak, nonatomic) IBOutlet UITableView *mTabView;//数据表视图
@property (nonatomic,strong)  NSMutableArray <NSString *> *itemArray;//slideSwitchView 的分栏标题
@property (nonatomic,strong)  NSMutableArray <NSString *> *idsArray;//slideSwitchView 的分栏id 数据
@property (nonatomic,strong)  NSMutableArray <NSMutableDictionary *> *disArray;

@property (nonatomic, strong) NSMutableArray <UGMissionModel *> *dataArray;//表数据


@end
static NSString *missionCellid = @"UGMissionTableViewCell";
@implementation UGTaskNoticeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        self = [[NSBundle mainBundle] loadNibNamed:@"UGTaskNoticeView" owner:self options:0].firstObject;
        self.frame = frame;
        self.bgView.backgroundColor = [UIColor whiteColor];
        
        self.mTabView.estimatedRowHeight = 0;
        self.mTabView.estimatedSectionHeaderHeight = 0;
        self.mTabView.estimatedSectionFooterHeight = 0;
        [self.mTabView registerNib:[UINib nibWithNibName:@"UGMissionTableViewCell" bundle:nil] forCellReuseIdentifier:missionCellid];
        self.mTabView.contentInset = UIEdgeInsetsMake(0, 0, 120, 0);
        self.mTabView.rowHeight = 80;
        self.mTabView.delegate = self;
        self.mTabView.dataSource = self;
        self.mTabView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        _itemArray =[NSMutableArray new];
        _idsArray = [NSMutableArray new];
        _disArray = [NSMutableArray new];
        
        
        self.bgView.layer.cornerRadius = 10;
        self.bgView.layer.masksToBounds = YES;
  
        [self getCenterData];
        self.slideSwitchView.selectedSegmentIndex = 1;
        
    }
    return self;
    
}

- (IBAction)close:(id)sender {
    [self hiddenSelf];
}

- (void)show {

    UIWindow* window = UIApplication.sharedApplication.keyWindow;
    UIView* maskView = [[UIView alloc] initWithFrame:window.bounds];
    UIView* view = self;
    view.hidden = NO;
    
    maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    maskView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    [maskView addSubview:view];
    [window addSubview:maskView];
}

- (void)hiddenSelf {
    UIView *view = self;
    self.superview.backgroundColor = [UIColor clearColor];
    [view.superview removeFromSuperview];
    [view removeFromSuperview];
}

//============================================================
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
            
            sortArray = [sortArray sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
            
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
                    
                    [weakSelf.idsArray addObject:dd[@"sortId"] ];
                }
                [weakSelf buildSegment];
                
                NSString * typeId = [weakSelf.idsArray objectAtIndex:0];
                
                [weakSelf getListData:typeId];
            }
            
        } failure:^(id msg) {
            
            [SVProgressHUD showErrorWithStatus:msg];
            
        }];
        
    }];
}



//得到列表数据 任务类型
- (void)getListData:(NSString *) typeid{
    
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"page":@"1",
                             @"rows":@"1000",
                             @"category":typeid
                             };
    
    [SVProgressHUD showWithStatus:nil];
    WeakSelf;
    [CMNetwork centerWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            [SVProgressHUD dismiss];
          
            NSDictionary *data =  model.data;
            NSArray *list = [data objectForKey:@"list"];

//            //字典转模型
//            UserMembersShareBean *membersShare = [[UserMembersShareBean alloc]initWithDictionary:dic[kMsg]
            //数组转模型数组
            weakSelf.dataArray = [UGMissionModel arrayOfModelsFromDictionaries:list error:nil];
            
            NSLog(@"self.dataArray = %@",weakSelf.dataArray);
            [weakSelf.mTabView reloadData];
            
        } failure:^(id msg) {
            
            [SVProgressHUD showErrorWithStatus:msg];
            
        }];
    }];
}

- (void)buildSegment
{
    self.slideSwitchView = [[HMSegmentedControl alloc]initWithSectionTitles:_itemArray];
    [self.contentView  addSubview:self.slideSwitchView];
    [self.slideSwitchView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView).with.offset(0);
        make.height.width.mas_equalTo(40);
    }];
    [self.slideSwitchView addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    WeakSelf
    [self.slideSwitchView setTitleFormatter:^NSAttributedString *(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected) {
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{
            NSForegroundColorAttributeName : [weakSelf getYNSegmentViewColor:selected],
            NSFontAttributeName : [UIFont systemFontOfSize:15]
            
        }];
        return attString;
    }];
//    self.slideSwitchView.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    self.slideSwitchView.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationBottom;
    
    self.contentView.backgroundColor = Skin1.is23 ? RGBA(135 , 135 ,135, 1) : Skin1.bgColor;
}

-(UIColor *)getYNSegmentViewColor:(BOOL)selected{
    UIColor *returnColor;
    {
        UIColor *selectedColor = [UIColor colorWithRed:52.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
        returnColor = selected ? selectedColor : [UIColor blackColor];
    }
    
    return  returnColor;
}

#pragma mark - HMSegmentedControlDelegate
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    
    NSLog(@"index = %lu",(unsigned long)segmentedControl.selectedSegmentIndex);
    
    NSString * typeId = [self.idsArray objectAtIndex:segmentedControl.selectedSegmentIndex];
    
    [self getListData:typeId];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UGMissionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:missionCellid forIndexPath:indexPath];
    UGMissionModel *model = self.dataArray[indexPath.row];
    cell.item = model;
    __weakSelf_(__self);
    cell.receiveMissionBlock = ^(UGMissionTableViewCell *sender){
        
        
        if ([model.status isEqualToString:@"3"]) {
            //领奖励
            [__self taskRewardDataWithType:model.missionId];
        }
        else if ([model.status isEqualToString:@"1"]) {
            [QDAlertView showWithTitle:@"温馨提示" message:@"尚未达到任务完成条件，先去做任务吧"];
        }
        else if ([model.status isEqualToString:@"0"]) {
            //领任务
            [__self taskGetDataWithType:model.missionId cell:sender];
            
        } else if ([model.status isEqualToString:@"2"]) {
            //已完成
            //            [self.goButton setTitle:@"已完成" forState:UIControlStateNormal];
        }
    };
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UGMissionModel *model = self.dataArray[indexPath.row];
    
    [LEEAlert alert].config
    .LeeTitle(@"任务详情")
    .LeeContent(model.missionDesc)
    .LeeAction(@"确认", ^{
        
        // 确认点击事件Block
    })
    .LeeShow(); // 设置完成后 别忘记调用Show来显示
}

//领取任务
- (void)taskGetDataWithType:(NSString *)mid  cell:(UGMissionTableViewCell *)sender{
    if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
        return;
    }
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"mid":mid
    };
    
    [SVProgressHUD showWithStatus:nil];
        WeakSelf;
    [CMNetwork taskGetWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            [QDAlertView showWithTitle:@"温馨提示" message:@"领取任务成功"];
            SANotificationEventPost(UGNotificationGetRewardsSuccessfully, nil);
            [weakSelf getCenterData];
            
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }];
}

// 领取奖励
- (void)taskRewardDataWithType:(NSString *)mid {
    if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
        return;
    }
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"mid":mid
    };
    
    [SVProgressHUD showWithStatus:nil];
        WeakSelf;
    [CMNetwork taskRewardWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            [QDAlertView showWithTitle:@"温馨提示" message:@"领取奖励成功"];
            SANotificationEventPost(UGNotificationGetRewardsSuccessfully, nil);
            [weakSelf getCenterData];
            
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }];
}

@end

