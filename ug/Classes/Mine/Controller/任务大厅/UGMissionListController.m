//
//  UGMissionListController.m
//  ug
//
//  Created by ug on 2019/5/10.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGMissionListController.h"
#import "UGMissionTableViewCell.h"
#import "UGMissionModel.h"

@interface UGMissionListController ()

@property (nonatomic, strong) NSMutableArray *dataArray;
//@property(nonatomic, assign) int pageSize;
//@property(nonatomic, assign) int pageNumber;

@property (nonatomic, strong)UGMissionTableViewCell *selcell;

@end

static NSString *missionCellid = @"UGMissionTableViewCell";
@implementation UGMissionListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [NSMutableArray new];
//    self.pageNumber = 1;
    [self getCenterData];
    
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self.tableView registerNib:[UINib nibWithNibName:@"UGMissionTableViewCell" bundle:nil] forCellReuseIdentifier:missionCellid];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 120, 0);
    self.tableView.rowHeight = 80;
//    _pageSize = 20;
//    _pageNumber = 1;
    
//     WeakSelf
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        weakSelf.pageNumber = 1;
//        [weakSelf getCenterData];
//        
//    }];
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        weakSelf.pageNumber =weakSelf.pageNumber+1;
//        [weakSelf getCenterData];
//    }];
    
  
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
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

#pragma mark -- 网络请求
//得到日期列表数据
- (void)getCenterData {
    if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
        return;
    }
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
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
//            if (self.pageNumber == 1 ) {
//
//                [self.dataArray removeAllObjects];
//            }
            
//            //字典转模型
//            UserMembersShareBean *membersShare = [[UserMembersShareBean alloc]initWithDictionary:dic[kMsg]
            //数组转模型数组
//            NSArray *array = [UGMissionModel arrayOfModelsFromDictionaries:list error:nil];
//            [self.dataArray addObjectsFromArray:array];
             self.dataArray = [UGMissionModel arrayOfModelsFromDictionaries:list error:nil];
            [self.tableView reloadData];

            
        } failure:^(id msg) {
            
            [SVProgressHUD showErrorWithStatus:msg];
            
        }];
        
//        if ([self.tableView.mj_header isRefreshing]) {
//            [self.tableView.mj_header endRefreshing];
//        }
//
//        if ([self.tableView.mj_footer isRefreshing]) {
//            [self.tableView.mj_footer endRefreshing];
//        }
    }];
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
    //    WeakSelf;
    [CMNetwork taskGetWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            [QDAlertView showWithTitle:@"温馨提示" message:@"领取任务成功"];
            SANotificationEventPost(UGNotificationGetRewardsSuccessfully, nil);
            [self getCenterData];
            
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
    //    WeakSelf;
    [CMNetwork taskRewardWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            [QDAlertView showWithTitle:@"温馨提示" message:@"领取奖励成功"];
            SANotificationEventPost(UGNotificationGetRewardsSuccessfully, nil);
            [self getCenterData];
            
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }];
}

@end
