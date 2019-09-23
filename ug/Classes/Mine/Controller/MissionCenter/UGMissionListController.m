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

@end

static NSString *missionCellid = @"UGMissionTableViewCell";
@implementation UGMissionListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [NSMutableArray new];
    
    [self getCenterData];
    
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self.tableView registerNib:[UINib nibWithNibName:@"UGMissionTableViewCell" bundle:nil] forCellReuseIdentifier:missionCellid];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 120, 0);
    self.tableView.rowHeight = 80;
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
    WeakSelf
    cell.receiveMissionBlock = ^{
        
        if ([model.status isEqualToString:@"3"]) {
            //领奖励
            [self taskRewardDataWithType:model.missionId];
            
        }else if ([model.status isEqualToString:@"1"]) {
//            [self.goButton setTitle:@"去完成" forState:UIControlStateNormal];
            [QDAlertView showWithTitle:@"温馨提示" message:@"尚未达到任务完成条件，先去做任务吧"];
            
        }else if ([model.status isEqualToString:@"0"]) {
            //领任务
            [self taskGetDataWithType:model.missionId];
            
        }else if ([model.status isEqualToString:@"2"]) {
            
//            [self.goButton setTitle:@"已完成" forState:UIControlStateNormal];
                //已完成
        }
//        if (model.status) {
//            [QDAlertView showWithTitle:@"温馨提示" message:@"尚未达到任务完成条件，先去做任务吧"];
//        }else {
//            [QDAlertView showWithTitle:@"温馨提示" message:@"领取成功"];
//            model.status = 1;
//            [weakSelf.tableView reloadData];
//        }
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
    
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"page":@"1",
                             @"rows":@"20",
                             
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
            self.dataArray = [UGMissionModel arrayOfModelsFromDictionaries:list error:nil];
            
            NSLog(@"self.dataArray = %@",self.dataArray);
            [self.tableView reloadData];
            
        } failure:^(id msg) {
            
            [SVProgressHUD showErrorWithStatus:msg];
            
        }];
    }];
}

//领取任务
- (void)taskGetDataWithType:(NSString *)mid {
    
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"mid":mid

                             };
    
    [SVProgressHUD showWithStatus:nil];
    //    WeakSelf;
    [CMNetwork taskGetWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
             [SVProgressHUD showSuccessWithStatus:@"领取成功"];
            
            [self getCenterData];
            
        } failure:^(id msg) {
            
            [SVProgressHUD showErrorWithStatus:msg];
            
        }];
    }];
}

//领取奖励
- (void)taskRewardDataWithType:(NSString *)mid {
    
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"mid":mid
                             
                             };
    
    [SVProgressHUD showWithStatus:nil];
    //    WeakSelf;
    [CMNetwork taskRewardWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            [SVProgressHUD showSuccessWithStatus:@"领取成功"];
            
            [self getCenterData];
            
             SANotificationEventPost(UGNotificationGetRewardsSuccessfully, nil);
            
        } failure:^(id msg) {
            
            [SVProgressHUD showErrorWithStatus:msg];
            
        }];
    }];
}

//- (NSMutableArray *)dataArray {
//    if (_dataArray == nil) {
//        _dataArray = [NSMutableArray array];
//        for (int i = 0; i < 15; i++) {
//            UGMissionModel *model = [[UGMissionModel alloc] init];
//            model.status = 0;
//            model.missionName = @"fsddfs423342fdsfdsfd";
//            model.overTime = @"2019-06-29";
//            model.integral = @"1.0000";
//            [_dataArray addObject:model];
//        }
//    }
//    return _dataArray;
//}

@end
