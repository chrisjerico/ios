//
//  UGMosaicGoldController.m
//  ug
//
//  Created by ug on 2019/9/18.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGMosaicGoldController.h"
#import "UGMosaicGoldModel.h"
#import "UGMosaicGoldTableViewCell.h"



@interface UGMosaicGoldController ()
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation UGMosaicGoldController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UGBackgroundColor;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self.tableView registerNib:[UINib nibWithNibName:@"UGMosaicGoldTableViewCell" bundle:nil] forCellReuseIdentifier:@"UGMosaicGoldTableViewCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getPromoteList];
    }];
    [self getPromoteList];
}


- (void)getPromoteList {
    
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid
                             };
    
    [CMNetwork activityWinApplyListWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [self.tableView.mj_header endRefreshing];
        [CMResult processWithResult:model success:^{
            NSDictionary *data =  model.data;
            NSArray *list = [data objectForKey:@"list"];
            
            //            //字典转模型
            //            UserMembersShareBean *membersShare = [[UserMembersShareBean alloc]initWithDictionary:dic[kMsg]
            
            //数组转模型数组
            self.dataArray = [UGMosaicGoldModel arrayOfModelsFromDictionaries:list error:nil];
            
            NSLog(@"self.dataArray = %@",self.dataArray);
            [self.tableView reloadData];
        } failure:^(id msg) {
            
            
        }];
    }];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGMosaicGoldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UGMosaicGoldTableViewCell" forIndexPath:indexPath];
    cell.item = self.dataArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 210.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UGMosaicGoldModel *model = self.dataArray[indexPath.row];
//    UGPromoteDetailController *detailVC = [[UGPromoteDetailController alloc] init];
//    detailVC.item = model;
//    [self.navigationController pushViewController:detailVC animated:YES];
    
}
@end
