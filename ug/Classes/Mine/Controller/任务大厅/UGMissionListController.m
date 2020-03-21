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

@property (nonatomic, strong) NSMutableArray <UGMissionModel *> *dataArray;
//@property(nonatomic, assign) int pageSize;
//@property(nonatomic, assign) int pageNumber;

@property (nonatomic, strong)UGMissionTableViewCell *selcell;

@end

static NSString *missionCellid = @"UGMissionTableViewCell";
@implementation UGMissionListController

-(void)dataReLoad{
    [self getCenterData];
}


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
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    //1:组织数据
    //    2：UI
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    UGMissionModel*obj = [self.dataArray objectAtIndex:section];
    
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
    UGMissionModel*obj = [self.dataArray objectAtIndex:indexPath.section];
    
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
    return cell;
}

#pragma mark - headerView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UGMissionModel*obj = [self.dataArray objectAtIndex:section];
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
        
//        if (Skin1.isBlack||Skin1.is23) {
//              [line setBackgroundColor:[UIColor whiteColor]];
//        } else {
            [line setBackgroundColor:Skin1.textColor3];
//        }
      
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
    
    UGMissionModel*obj = [self.dataArray objectAtIndex:[string intValue]];
    
    obj.isShowCell = !obj.isShowCell;
    
    [self.tableView reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    UGMissionModel*obj = [self.dataArray objectAtIndex:section];
    if ([CMCommon arryIsNull:obj.sortName2Array]) {
        return 80.0;
    } else {
        return 55.0;
    }
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


//得到列表数据
- (void)getCenterData {
    if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
        return;
    }
    NSDictionary *params = [NSDictionary new];
    if (![CMCommon stringIsNull:_typeid]) {
        
        params = @{@"token":[UGUserModel currentUser].sessid,
                   @"page":@"1",
                   @"rows":@"1000",
                   @"category":_typeid
        };
    }
    else{
        params = @{@"token":[UGUserModel currentUser].sessid,
                   @"page":@"1",
                   @"rows":@"1000",
                   
        };
    }
    
    [SVProgressHUD showWithStatus:nil];
    WeakSelf;
    [CMNetwork centerWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            [SVProgressHUD dismiss];
            NSDictionary *data =  model.data;
            NSArray *list = [data objectForKey:@"list"];
            if (weakSelf.typeid) {
                [self.dataArray removeAllObjects];
            }
            
            NSMutableArray <UGMissionModel *> *tempdataArray = [NSMutableArray new];
            tempdataArray = [UGMissionModel arrayOfModelsFromDictionaries:list error:nil];
            
            //            1:得到有2级名称的 放到一个数组
            NSMutableArray <NSString *> *sortName2Array = [NSMutableArray new];
            for (UGMissionModel*obj in tempdataArray) {
                if (![CMCommon stringIsNull:obj.sortName2]) {
                    
                    if (![sortName2Array containsObject:obj.sortName2]) {
                        [sortName2Array addObject:obj.sortName2];
                    }
                    
                }
            }
            
//            //查看数据
//            for (NSString *s in sortName2Array) {
//                NSLog(@"s = %@",s);
//            }
            
            //            2:重新组织
            for (NSString *s in sortName2Array) {
                UGMissionModel *model = [UGMissionModel new];
                model.sortName2 = s;
                
                NSArray<UGMissionModel *> *temps = [tempdataArray objectsWithValue:s keyPath:@"sortName2"];
                
                model.sortName2Array = temps;
                
                for (UGMissionModel *mod in temps) {
                    [tempdataArray removeObject:mod];
                }
                [tempdataArray addObject:model];
            }
            
            //查看数据
//            for (UGMissionModel *mod in tempdataArray) {
//                NSLog(@"mod = %@",mod);
//            }
            
            self.dataArray = tempdataArray;
            //            self.dataArray = [UGMissionModel arrayOfModelsFromDictionaries:list error:nil];
            [self.tableView reloadData];
            
        } failure:^(id msg) {
            
            [SVProgressHUD showErrorWithStatus:msg];
            
        }];
        
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
