//
//  UGSignInHistoryView.m
//  ug
//
//  Created by ug on 2019/9/6.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGSignInHistoryView.h"
#import "UGSingInHistoryTableViewCell.h"
#import "UGSignInHistoryModel.h"

@interface UGSignInHistoryView ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UILabel *title1Label;
@property (weak, nonatomic) IBOutlet UILabel *title2Label;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (nonatomic, assign) NSInteger selectSection;

@end

//static NSString *historyHeaderViewid = @"UGSingInHistoryHeaderViewid";
@implementation UGSignInHistoryView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"UGSignInHistoryView" owner:self options:0].firstObject;
        self.frame = frame;
        self.selectSection = 0;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        [self.tableView registerNib:[UINib nibWithNibName:@"UGSingInHistoryTableViewCell" bundle:nil] forCellReuseIdentifier:@"UGSingInHistoryTableViewCell"];
//         [self.tableView registerNib:[UINib nibWithNibName:@"UGSingInHistoryTableViewCell" bundle:nil] forHeaderFooterViewReuseIdentifier:historyHeaderViewid];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.layer.cornerRadius = 5;
        [self setBackgroundColor: Skin1.bgColor];

    }
    return self;
    
}

- (IBAction)close:(id)sender {
    [self hiddenSelf];
}

- (void)setDataArray:(NSArray<UGSignInHistoryModel *> *)dataArray {
    _dataArray = dataArray;
    [self.tableView reloadData];
    
}

- (void)setCheckinTimes:(NSString *)checkinTimes {
    _checkinTimes = checkinTimes;
    self.title1Label.text = [NSString stringWithFormat:@"已经连续签到%@天",checkinTimes];
}

- (void)setCheckinMoney:(NSString *)checkinMoney {
    _checkinMoney = checkinMoney;
    self.title2Label.text = [NSString stringWithFormat:@"累计积分%@分",checkinMoney];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGSingInHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UGSingInHistoryTableViewCell" forIndexPath:indexPath];
    cell.item = self.dataArray[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UGSingInHistoryTableViewCell *headerView = (UGSingInHistoryTableViewCell*)[[NSBundle mainBundle] loadNibNamed:@"UGSingInHistoryTableViewCell" owner:self options:0].firstObject;
    UGSignInHistoryModel *model = [UGSignInHistoryModel new];
    model.checkinDate = @"签到日期";
    model.integral = @"奖励";
    model.remark = @"说明";

    headerView.item = model;

    return headerView;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView=(UITableViewHeaderFooterView *)view;
    [headerView.backgroundView setBackgroundColor:[UIColor whiteColor]];
}

- (void)show {
    
    UIWindow* window = UIApplication.sharedApplication.keyWindow;
    UIView* maskView = [[UIView alloc] initWithFrame:window.bounds];
    UIView* view = self;
    view.hidden = NO;
    
    maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    maskView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    if ([Skin1.skitType isEqualToString:@"黑色模板"]) {
        [_title1Label setTextColor:[UIColor whiteColor]];
    } else {
        [_title1Label setTextColor:[UIColor blackColor]];
    }
    
    [maskView addSubview:view];
    [window addSubview:maskView];
    
}

- (void)hiddenSelf {
    
    UIView* view = self;
    self.superview.backgroundColor = [UIColor clearColor];
    [view.superview removeFromSuperview];
    [view removeFromSuperview];
    
}

@end
