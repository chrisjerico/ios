//
//  UGActivityGoldTableViewController.m
//  ug
//
//  Created by ug on 2019/9/18.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGActivityGoldTableViewController.h"
#import "UGActivityGoldModel.h"
#import "UGActivityGoldTableViewCell.h"
#import "UGapplyWinLogDetail.h"

@interface UGActivityGoldTableViewController ()
@property (nonatomic, strong) NSMutableArray <UGActivityGoldModel *> *dataArray;

@end

@implementation UGActivityGoldTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = Skin1.textColor4;
    self.tableView.rowHeight = 44;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 120, 0);
    [self.tableView registerNib:[UINib nibWithNibName:@"UGActivityGoldTableViewCell" bundle:nil] forCellReuseIdentifier:@"UGActivityGoldTableViewCell"];
    
    [self setupRefreshView];
    
    [self activityApplyWinLog];
}

- (void)rootLoadData {
    [self activityApplyWinLog];
}

//添加上下拉刷新
- (void)setupRefreshView {
    WeakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf activityApplyWinLog];
    }];
}

#pragma mark -- 网络请求
//得到日期列表数据
- (void)activityApplyWinLogDetail:(NSString *)mid {
    if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
        return;
    }
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"id":mid
                             
                             };
    
    [SVProgressHUD showWithStatus:nil];
    WeakSelf;
    [CMNetwork activityApplyWinLogDetailWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            [SVProgressHUD dismiss];
            UGapplyWinLogDetail *model1 =model.data;
            NSLog(@"model.username = %@",model1.username);

            NSString *str = [NSString stringWithFormat:@"活动名称：%@ \n申请日期：%@ \n申请金额：%@ \n申请原因：%@ \n审核结果：%@ \n审核说明：%@ ",
                             model1.winName,
                             model1.updateTime,
                             model1.amount,
                             model1.userComment,
                             model1.state,
                             model1.adminComment];
            
            if (Skin1.isBlack) {
                [LEEAlert alert].config
                .LeeAddTitle(^(UILabel *label) {
                    label.textColor = [UIColor whiteColor];
                    label.text = @"查看详情";
                })
                .LeeAddContent(^(UILabel *label) {
                    label.text = str;
                    label.lineSpacing1 = 5;
                    label.textAlignment = NSTextAlignmentLeft;
                    label.textColor = Skin1.textColor1;
                })
                .LeeAction(@"关闭", nil)
                .LeeHeaderColor(Skin1.bgColor)
                .LeeShow();
            } else {
                [LEEAlert alert].config
                .LeeAddTitle(^(UILabel *label) {
                    
                    label.text = @"查看详情";
                })
                .LeeAddContent(^(UILabel *label) {
                    
                    label.text = str;
                    label.lineSpacing1 = 5;
                    label.textAlignment = NSTextAlignmentLeft;
                })
                .LeeAction(@"关闭", nil)
                .LeeShow();
            }

            
        } failure:^(id msg) {
            
            [SVProgressHUD showErrorWithStatus:msg];
            
        }];
    }];
}
- (void)activityApplyWinLog {
    
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid
                             
                             };
    WeakSelf;
    [CMNetwork activityApplyWinLogWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            NSDictionary *data =  model.data;
            NSArray *list = [data objectForKey:@"list"];
            
            //            //字典转模型
            //            UserMembersShareBean *membersShare = [[UserMembersShareBean alloc]initWithDictionary:dic[kMsg]
            
            //数组转模型数组
            weakSelf.dataArray = [UGActivityGoldModel arrayOfModelsFromDictionaries:list error:nil];
            
            NSLog(@"self.dataArray = %@",weakSelf.dataArray);
            [weakSelf.tableView reloadData];
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
        
        if ([weakSelf.tableView.mj_header isRefreshing]) {
            [weakSelf.tableView.mj_header endRefreshing];
        }
        
      
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
    UGActivityGoldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UGActivityGoldTableViewCell" forIndexPath:indexPath];
    UGActivityGoldModel *model = self.dataArray[indexPath.row];
    cell.firstLabel.text = model.updateTime;
    cell.secondLabel.text = model.amount;
    cell.thirdLabel.text = model.state;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UGActivityGoldTableViewCell *headerView = (UGActivityGoldTableViewCell*)[[NSBundle mainBundle] loadNibNamed:@"UGActivityGoldTableViewCell" owner:self options:0].firstObject;
    headerView.frame = CGRectMake(0, 0, APP.Width, 44);
    headerView.firstLabel.text = @"申请日期";
    headerView.secondLabel.text = @"申请金额";
    headerView.thirdLabel.text = @"状态";
    
    [headerView.firstLabel setFont:[UIFont boldSystemFontOfSize:13]];
    [headerView.secondLabel setFont:[UIFont boldSystemFontOfSize:13]];
    [headerView.thirdLabel setFont:[UIFont boldSystemFontOfSize:13]];
    
    [CMCommon setBorderWithView:headerView top:NO left:NO bottom:YES right:NO borderColor:UGRGBColor(239, 239, 239) borderWidth:1];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UGActivityGoldModel *model = self.dataArray[indexPath.row];
    //    UGPromoteDetailController *detailVC = [[UGPromoteDetailController alloc] init];
    //    detailVC.item = model;
    //    [self.navigationController pushViewController:detailVC animated:YES];
    
    [self activityApplyWinLogDetail:model.mid];
}

@end
