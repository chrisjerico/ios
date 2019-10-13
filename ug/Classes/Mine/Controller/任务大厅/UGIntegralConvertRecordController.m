//
//  UGIntegralConvertRecordController.m
//  ug
//
//  Created by ug on 2019/5/17.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGIntegralConvertRecordController.h"
#import "UGIntegarlConvertRecordCell.h"
#import "YBPopupMenu.h"
#import "UGSystemConfigModel.h"
#import "UGCreditsLogModel.h"


@interface UGIntegralConvertRecordController ()<UITableViewDelegate,UITableViewDataSource,YBPopupMenuDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UIView *dateView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

@property (nonatomic, strong) NSArray *dateArray;
@property (nonatomic, strong) NSMutableArray *tableDataArray;

@end

static NSString *convertRecordCellid = @"UGIntegarlConvertRecordCell";
@implementation UGIntegralConvertRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 44;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 120, 0);
    self.dateArray = @[@"全部日期",@"最近一天",@"最近七天",@"最近一个月"];
    self.tableDataArray = [NSMutableArray new];
    //
    
    UGSystemConfigModel *config = [UGSystemConfigModel currentConfig];
    NSString *str1 = [NSString stringWithFormat:@"%@",config.missionName];
    NSString *str2 = [NSString stringWithFormat:@"%@余额",config.missionName];

    self.numberLabel.text = str1;
    self.balanceLabel.text = str2;
    
     [self checkinDataWithType:@"0"];
}

- (IBAction)datePicker:(id)sender {
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI);
    self.arrowImageView.transform = transform;
    YBPopupMenu *popView = [[YBPopupMenu alloc] initWithTitles:self.dateArray icons:nil menuWidth:CGSizeMake(self.dateView.width, 180) delegate:self];
    popView.fontSize = 14;
    popView.type = YBPopupMenuTypeDefault;
    [popView showRelyOnView:self.dateView];
}

- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu {
    NSLog(@"index = %ld",(long)index);
    if (index >= 0) {
 
                [self checkinDataWithType:[NSString stringWithFormat:@"%ld",(long)index]];
         
    }
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI * 2);
    self.arrowImageView.transform = transform;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGIntegarlConvertRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:convertRecordCellid forIndexPath:indexPath];
     UGCreditsLogModel *model = self.tableDataArray[indexPath.row];
    cell.item = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

#pragma mark -- 网络请求

//积分账变列表（time类型：其他的是全部，1是最近一天 2:最近七天  3:最近一个月）
- (void)checkinDataWithType:(NSString *)time{
    
    NSLog(@"time = %@",time);
    if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
        return;
    }
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"page":@"1",
                             @"rows":@"20",
                             @"time":time
                             };
    
    [SVProgressHUD showWithStatus:nil];
    //    WeakSelf;
    [CMNetwork taskCreditsLogWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            [SVProgressHUD dismiss];
            
            NSDictionary *data =  model.data;
            NSArray *list = [data objectForKey:@"list"];
            
            //            //字典转模型
            //            UserMembersShareBean *membersShare = [[UserMembersShareBean alloc]initWithDictionary:dic[kMsg]
            //数组转模型数组
            self.tableDataArray = [UGCreditsLogModel arrayOfModelsFromDictionaries:list error:nil];
            
            NSLog(@"tableDataArray = %@",self.tableDataArray);
            [self.tableView reloadData];
            
        } failure:^(id msg) {
            
            [SVProgressHUD showErrorWithStatus:msg];
            
        }];
    }];
}
@end
