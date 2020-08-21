//
//  UGMissionLevelController.m
//  ug
//
//  Created by ug on 2019/5/16.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGMissionLevelController.h"
#import "UGMissionLevelTableViewCell.h"
#import "UGlevelsModel.h"
#import "UGSystemConfigModel.h"

@interface UGMissionLevelController ()

@property (nonatomic, strong) NSMutableArray <UGlevelsModel *> *dataArray;

@end

static NSString *levelCellid = @"UGMissionLevelTableViewCell";
@implementation UGMissionLevelController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [NSMutableArray new];
    
    [self getLevelsData];
    
    if (Skin1.isBlack) {
        [self.view setBackgroundColor:Skin1.bgColor];
    } else {
        [self.view setBackgroundColor:[UIColor whiteColor]];
    }
    
    self.tableView.rowHeight = 44;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self.tableView registerNib:[UINib nibWithNibName:@"UGMissionLevelTableViewCell" bundle:nil] forCellReuseIdentifier:levelCellid];
    self.tableView.contentInset = UIEdgeInsetsMake(5, 0, 120, 0);
    self.tableView.separatorColor = Skin1.isBlack ? [UIColor lightTextColor] : APP.LineColor;
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
    UGlevelsModel *item = self.dataArray[indexPath.row];
    cell.item = item;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UGMissionLevelTableViewCell *headerView = (UGMissionLevelTableViewCell*)[[NSBundle mainBundle] loadNibNamed:@"UGMissionLevelTableViewCell" owner:self options:0].firstObject;
    
    UGSystemConfigModel *config = [UGSystemConfigModel currentConfig];
    NSString *str1 = [NSString stringWithFormat:@"成长%@", config.missionName];
    NSString *str2 = [NSString stringWithFormat:@"%@头衔", config.missionName];
    
    UGlevelsModel *model = [UGlevelsModel new];
    model.levelName = @"";
    model.integral = str1;
    model.levelTitle = str2;

    headerView.item = model;
    
    if (Skin1.isBlack) {
        [headerView setSectionBgColor:Skin1.bgColor levelsSectionStr:@"等级"];
    } else {
        [headerView setSectionBgColor:[UIColor whiteColor] levelsSectionStr:@"等级"];
    }

    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}


#pragma mark -- 网络请求
//得到等级列表数据
- (void)getLevelsData {
//     NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid};
    [SVProgressHUD showWithStatus:nil];
    WeakSelf;
    [CMNetwork taskLevelsWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            [SVProgressHUD dismiss];
            weakSelf.dataArray = model.data;
            [weakSelf.tableView reloadData];
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }];
}

@end
