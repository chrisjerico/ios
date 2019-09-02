//
//  UGMissionLevelController.m
//  ug
//
//  Created by ug on 2019/5/16.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGMissionLevelController.h"
#import "UGMissionLevelTableViewCell.h"
#import "UGMissionLevelModel.h"

@interface UGMissionLevelController ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

static NSString *levelCellid = @"UGMissionLevelTableViewCell";
@implementation UGMissionLevelController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 44;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self.tableView registerNib:[UINib nibWithNibName:@"UGMissionLevelTableViewCell" bundle:nil] forCellReuseIdentifier:levelCellid];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGMissionLevelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:levelCellid forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.backgroundColor = [UIColor clearColor];
        cell.showVIPView = NO;
    }else {
        cell.backgroundColor = [UIColor whiteColor];
        cell.showVIPView = YES;
    }
    UGMissionLevelModel *item = self.dataArray[indexPath.row];
    item.level = indexPath.row;
    cell.item = item;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 50;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
        for (int i = 0; i < 7; i++) {
            if (i == 0) {
                UGMissionLevelModel *model = [[UGMissionLevelModel alloc] init];
                model.amount = @"可领工资";
                model.integral = @"成长积分";
                model.levelTitle = @"积分头衔";
                model.levelName = @"等级";
                [_dataArray addObject:model];
            }else {
                
                UGMissionLevelModel *model = [[UGMissionLevelModel alloc] init];
                model.amount = @"9";
                model.integral = @"900";
                model.levelTitle = @"黄金会员";
                model.levelName = @"VIP3";
                [_dataArray addObject:model];
            }
        }
        
    }
    return _dataArray;
}
@end
