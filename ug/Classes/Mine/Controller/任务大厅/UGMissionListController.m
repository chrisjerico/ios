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
#import "UGTaskTableViewCell.h"
#import "UGTaskSectionTableViewCell.h"

@interface UGMissionListController ()

@property (nonatomic, strong) NSMutableArray <UGMissionModel *> *dataArray;


@property (nonatomic, strong)UGMissionTableViewCell *selcell;
@property (strong, nonatomic) UGTaskTableViewCell *nestCell;
@end

static NSString *missionCellid = @"UGMissionTableViewCell";
static NSString *taskCellid = @"UGTaskTableViewCell";
@implementation UGMissionListController

- (UGTaskTableViewCell *)nestCell
{
    if (!_nestCell) {
        _nestCell = [[NSBundle mainBundle] loadNibNamed:taskCellid owner:self options:nil].firstObject;
    }
    return _nestCell;
}


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
    [self.tableView registerNib:[UINib nibWithNibName:@"UGTaskTableViewCell" bundle:nil] forCellReuseIdentifier:taskCellid];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 120, 0);
    self.tableView.rowHeight = 80;
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    //1:组织数据
    //    2：UI
    [self xw_addNotificationForName:UGNotificationWithSkinSuccess block:^(NSNotification * _Nonnull noti) {
        [self getCenterData];
    }];
    
    
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
    
    UGMissionModel*obj = [self.dataArray objectAtIndex:section];
    
    if (obj.celltype == cellTypeTitle) {
        UIView *view = [[UIView alloc] init];
        UGTaskSectionTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"UGTaskSectionTableViewCell" owner:self options:nil] firstObject];
        cell.titleLabel.text = obj.sectionTitle;
        //        [cell.titleLabel setTextColor:];
        //        [cell.contentView setBackgroundColor:Skin1.bgColor];
        [view addSubview:cell];
        [cell setFrame:CGRectMake(0, 0, APP.Width, 55)];
        return view;
    }
    else  if (obj.celltype == cellTypeOne) {
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
//        [view setBackgroundColor: [Skin1.navBarBgColor colorWithAlphaComponent:0.2]];
        [view setBackgroundColor: RGBA(196, 194, 200, 1)];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5,APP.Width-32, 55)];
        
        titleLabel.text = obj.sortName2;
        titleLabel.textColor = [UIColor whiteColor];
        [view addSubview:titleLabel];
        
        // 添加一个button用来监听展开的分组,实现分组的展开关闭
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, APP.Width, 40);
        button.tag = 200 + section;
        [button addTarget:self action:@selector(btnOpenList:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        UIImage *afterImage;
        afterImage = [[UIImage imageNamed:@"jiantou2"] qmui_imageWithTintColor:[UIColor whiteColor]];
        UIImageView *imgv = [[UIImageView alloc] initWithImage:afterImage];;
        [view addSubview:imgv];
        
        UIView *line = [[UIView alloc] init];
        [line setBackgroundColor:[UIColor whiteColor]];
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
    if (obj.celltype == cellTypeTitle) {
        return 55.0;
    }
    else if (obj.celltype == cellTypeOne)
    {
        return 80.0;
    } else {
        return 55.0;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}


#pragma mark -- 网络请求
//根据type 0，1，2 最高1级
//之后再分

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
            
            NSMutableArray <UGMissionModel *> *tempTypedataArray = [NSMutableArray new];//最终的数据Type
            
            //1 .根据type不同分给不同的数组。（最多3个）
            NSMutableArray <NSString *> *typeNameArray = [NSMutableArray new];
            for (UGMissionModel*obj in tempdataArray) {
                if (obj.type) {
                    
                    if (![typeNameArray containsObject:obj.type]) {
                        [typeNameArray addObject:obj.type];
                    }
                }
            }
            //            2:重新组织
            for (NSString *s in typeNameArray) {
                
                {
                    UGMissionModel *model = [UGMissionModel new];
                    model.type = s;
                    NSMutableArray <UGMissionModel *> *datas =  [NSMutableArray new];//最终的数据
                    NSMutableArray <UGMissionModel *> *temps = [[NSMutableArray alloc] initWithArray: [tempdataArray objectsWithValue:s keyPath:@"type"]];//待修改的数据
                    datas = temps;
                    // 3 对每个type数据再处理
                    {
                        //            1:得到有2级名称的 放到一个数组 more
                        NSMutableArray <NSString *> *sortName2Array = [NSMutableArray new];
                        for (UGMissionModel*obj in temps) {
                            if (![CMCommon stringIsNull:obj.sortName2]) {
                                
                                if (![sortName2Array containsObject:obj.sortName2]) {
                                    [sortName2Array addObject:obj.sortName2];
                                }
                                
                            }
                        }
                        //            2:重新组织 2级名称数据 more
                        for (int i = 0; i<  sortName2Array.count; i++) {
                            NSString *s = [sortName2Array objectAtIndex:i];
                            UGMissionModel *md = [UGMissionModel new];
                            md.sortName2 = s;
                            NSArray<UGMissionModel *> *temp = [temps objectsWithValue:s keyPath:@"sortName2"];
                            md.sortName2Array = temp;
                            
                            //
                            for (UGMissionModel *mod in temp) {
                                [datas removeObject:mod];
                            }
                            [datas addObject:md];
                        }
                        
                        model.typeArray = datas;
                    }
                    [tempTypedataArray addObject:model];
                    
                }
            }
            
            NSMutableArray <UGMissionModel *> *enddataArray = [NSMutableArray new];
            //            2:重新组织
            for (UGMissionModel *mod in tempTypedataArray) {
                
                {//标题数据
                    UGMissionModel *model = [UGMissionModel new];
                    model.type = mod.type;
                    NSString *titleStr = @"";
                    if ([model.type isEqualToString:@"0"]) {//一次性
                        titleStr = @"一次性任务";
                    }
                    else if ([model.type isEqualToString:@"1"])//日常
                    {
                        titleStr = @"日常任务";
                    }
                    else if ([model.type isEqualToString:@"5"])//限时
                    {
                        titleStr = @"限时任务";
                    }
                    model.sectionTitle = titleStr;
                    model.celltype = cellTypeTitle;
                    [enddataArray addObject:model];
                }
                
                {
                    for (UGMissionModel *modl in mod.typeArray) {
                        if ([CMCommon stringIsNull:modl.sortName2]) {//单行数据
                            modl.celltype = cellTypeOne;
                            [enddataArray addObject:modl];
                        }
                        else{//多行数据
                            modl.celltype = cellTypeMore;
                            [enddataArray addObject:modl];
                        }
                    }
                    
                }
                
            }
            
            self.dataArray = enddataArray;
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
