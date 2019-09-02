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
        if (model.status) {
            [QDAlertView showWithTitle:@"温馨提示" message:@"尚未达到任务完成条件，先去做任务吧"];
        }else {
            [QDAlertView showWithTitle:@"温馨提示" message:@"领取成功"];
            model.status = 1;
            [weakSelf.tableView reloadData];
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
    
    
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
        for (int i = 0; i < 15; i++) {
            UGMissionModel *model = [[UGMissionModel alloc] init];
            model.status = 0;
            model.missionName = @"fsddfs423342fdsfdsfd";
            model.overTime = @"2019-06-29";
            model.integral = @"1.0000";
            [_dataArray addObject:model];
        }
    }
    return _dataArray;
}

@end
