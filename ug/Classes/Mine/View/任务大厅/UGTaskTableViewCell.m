//
//  UGTaskTableViewCell.m
//  UGBWApp
//
//  Created by andrew on 2020/7/22.
//  Copyright © 2020 ug. All rights reserved.
//

#import "UGTaskTableViewCell.h"
#import "UGMissionTableViewCell.h"
@interface UGTaskTableViewCell ()
<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *nestTableView;


@end
static NSString *missionCellid = @"UGMissionTableViewCell";
@implementation UGTaskTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.nestTableView.estimatedRowHeight = 0;
    self.nestTableView.estimatedSectionHeaderHeight = 0;
    self.nestTableView.estimatedSectionFooterHeight = 0;
    [self.nestTableView registerNib:[UINib nibWithNibName:@"UGMissionTableViewCell" bundle:nil] forCellReuseIdentifier:missionCellid];
    self.nestTableView.contentInset = UIEdgeInsetsMake(0, 0, 120, 0);
    self.nestTableView.delegate = self;
    self.nestTableView.dataSource = self;
}

#pragma mark - Public
- (void)setTypeArray:(NSArray<UGMissionModel *> *)typeArray
{
    _typeArray = typeArray;
    
    // 3.GCD
    dispatch_async(dispatch_get_main_queue(), ^{
       // UI更新代码
       [self.nestTableView reloadData];
        
        self.tableHeightConstraint.constant = self.nestTableView.contentSize.height;
        NSLog(@"tableHeight = %f",self.nestTableView.contentSize.height);
    });
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.typeArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    UGMissionModel*obj = [self.typeArray objectAtIndex:section];

    if ([CMCommon arryIsNull:obj.sortName2Array]) {
        return 0;
    } else {
        if (obj.isShowCell) {
            return obj.sortName2Array.count;
        } else {
            return 0;
        }
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UGMissionModel*obj = [self.typeArray objectAtIndex:indexPath.section];

    UGMissionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:missionCellid forIndexPath:indexPath];
    UGMissionModel *model = obj.sortName2Array[indexPath.row];
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

    cell.receiveBlock = ^(UGMissionTableViewCell *sender){

              UGMissionModel *model = sender.item;

              [LEEAlert alert].config
              .LeeTitle(@"任务详情")
              .LeeContent(model.missionDesc)
              .LeeAction(@"确认", ^{

                  // 确认点击事件Block
              })
              .LeeShow(); // 设置完成后 别忘记调用Show来显示
          };
    return cell;
}

#pragma mark - headerView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UGMissionModel*obj = [self.typeArray objectAtIndex:section];
    if ([CMCommon arryIsNull:obj.sortName2Array]) {
        UIView *view = [[UIView alloc] init];
        UGMissionTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"UGMissionTableViewCell" owner:self options:nil] firstObject];
        UGMissionModel *model = obj;
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

        cell.receiveBlock = ^(UGMissionTableViewCell *sender){

            UGMissionModel *model = sender.item;

            [LEEAlert alert].config
            .LeeTitle(@"任务详情")
            .LeeContent(model.missionDesc)
            .LeeAction(@"确认", ^{

                // 确认点击事件Block
            })
            .LeeShow(); // 设置完成后 别忘记调用Show来显示
        };
        [view addSubview:cell];
        [cell setFrame:CGRectMake(0, 0, APP.Width, 80)];
        return view;

    } else {
        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor: [Skin1.navBarBgColor colorWithAlphaComponent:0.2]];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5,APP.Width-32, 55)];

        titleLabel.text = obj.sortName2;
        [view addSubview:titleLabel];

        // 添加一个button用来监听展开的分组,实现分组的展开关闭
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, APP.Width, 40);
        button.tag = 200 + section;
        [button addTarget:self action:@selector(btnOpenList:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        ;
        UIImageView *imgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jiantou2"]];
        [view addSubview:imgv];

        UIView *line = [[UIView alloc] init];


        [line setBackgroundColor:Skin1.textColor3];


         [view addSubview:line];

        [titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(20);
            make.right.equalTo(view).offset(-50);
            make.top.equalTo(view).offset(0);
            make.bottom.equalTo(view).offset(0);
        }];

        [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(view).offset(-10);
            make.centerY.equalTo(view).offset(0);
            make.height.mas_equalTo(32);
            make.width.mas_equalTo(32);
        }];

        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(view).offset(0);
            make.bottom.equalTo(view).offset(0);
            make.height.mas_equalTo(1);
            make.width.mas_equalTo(APP.Width);
        }];
        return view;
    }

}

#pragma mark - 按钮的点击事件,将字符串添加到数组
- (void)btnOpenList:(UIButton *) sender {
    NSString *string = [NSString stringWithFormat:@"%ld", sender.tag - 200];
    
    UGMissionModel*obj = [self.typeArray objectAtIndex:[string intValue]];
    
    obj.isShowCell = !obj.isShowCell;
    
    [self.nestTableView reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    UGMissionModel*obj = [self.typeArray objectAtIndex:section];
    if ([CMCommon arryIsNull:obj.sortName2Array]) {
        return 80.0;
    } else {
        return 55.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
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

    [CMNetwork taskGetWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            [QDAlertView showWithTitle:@"温馨提示" message:@"领取任务成功"];
            SANotificationEventPost(UGNotificationGetRewardsSuccessfully, nil);
            SANotificationEventPost(@"UGNotificationGetCenterData", nil);
            
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

    [CMNetwork taskRewardWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            [QDAlertView showWithTitle:@"温馨提示" message:@"领取奖励成功"];
            SANotificationEventPost(UGNotificationGetRewardsSuccessfully, nil);
            SANotificationEventPost(@"UGNotificationGetCenterData", nil);
            
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }];
}

@end
