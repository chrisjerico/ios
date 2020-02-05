//
//  PromotionWithdrawalsRecordVC.m
//  ug
//
//  Created by ug on 2020/1/29.
//  Copyright © 2020 ug. All rights reserved.
//

#import "PromotionWithdrawalsRecordVC.h"
#import "PromotionRecordCell1.h"

#import "UGwithdrawListModel.h"
#import "UGrealBetListModel.h"
#import "YBPopupMenu.h"
#import <BRPickerView.h>
#import "CMTimeCommon.h"
#import "UITableView+LSEmpty.h"
@interface PromotionWithdrawalsRecordVC ()<UITableViewDelegate, UITableViewDataSource, YBPopupMenuDelegate>
{
    NSInteger _levelindex;
    NSArray * _levelArray;
}

@property (weak, nonatomic) IBOutlet UIStackView *headerStack;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *headerLabels;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign)NSInteger pageSize;
@property (nonatomic, assign)NSInteger pageNumber;
@property (nonatomic, strong)NSMutableArray* items;

@property (weak, nonatomic) IBOutlet UIView *levelSelectView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;
@property (weak, nonatomic) IBOutlet UIButton *levelSelectButton;

@property (weak, nonatomic) IBOutlet UIButton *beiginTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *endTimeButton;

@property (nonatomic, strong) NSDate *beginTimeSelectDate;
@property (nonatomic, strong) NSDate *endTimeSelectDate;
@property (nonatomic, strong) NSString *beginTimeStr;
@property (nonatomic, strong) NSString *endTimeStr;

@property (nonatomic, strong)BRDatePickerView *beigindatePickerView;
@property (nonatomic, strong)BRDatePickerView *enddatePickerView;
@end

@implementation PromotionWithdrawalsRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib: [UINib nibWithNibName:@"PromotionRecordCell1" bundle:nil] forCellReuseIdentifier:@"PromotionRecordCell1"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.pageSize = 20;
    self.pageNumber = 1;
    self.items = [NSMutableArray array];
    _levelArray = @[@"全部下线",@"1级下线",@"2级下线",@"3级下线",@"4级下线",@"5级下线",@"6级下线",@"7级下线",@"8级下线",@"9级下线",@"10级下线"];
    _levelindex = 0;
    
    self.beginTimeStr = APP.beginTime;
    self.endTimeStr = [CMTimeCommon currentDateStringWithFormat:@"yyyy-MM-dd"];
    self.beginTimeSelectDate = [CMTimeCommon dateForStr:APP.beginTime format:@"yyyy-MM-dd"];
    self.endTimeSelectDate = [CMTimeCommon dateForStr:self.endTimeStr format:@"yyyy-MM-dd"];
    [self.beiginTimeButton setTitle:APP.beginTime forState:(0)];
    [self.endTimeButton setTitle:self.endTimeStr forState:(0)];
    
    if (![CMCommon stringIsNull:self.dateStr]) {
        self.beginTimeStr = self.dateStr;
        self.endTimeStr = self.dateStr;
        self.beginTimeSelectDate = [CMTimeCommon dateForStr:self.dateStr format:@"yyyy-MM-dd"];
        self.endTimeSelectDate = [CMTimeCommon dateForStr:self.dateStr format:@"yyyy-MM-dd"];
        self.dateStr = @"";
    }
    
    _beigindatePickerView = ({
        [self.beiginTimeButton setTitle:self.beginTimeStr forState:(0)];
        BRDatePickerView *datePickerView = [[BRDatePickerView alloc]init];
        datePickerView.pickerMode = BRDatePickerModeDate;
        datePickerView.title = @"开始时间";
        datePickerView.selectDate = self.beginTimeSelectDate;
        datePickerView.isAutoSelect = NO;
        datePickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
            
            if (self.endTimeSelectDate) {
                int re = [CMTimeCommon compareOneDay:selectDate withAnotherDay:self.endTimeSelectDate];
                if (re == 1 ) {
                    [CMCommon showToastTitle:@"开始时间大于结束时间，请重新选择"];
                    return;
                }
            }
            self.beginTimeSelectDate = selectDate;
            [self.beiginTimeButton setTitle:selectValue forState:(0)];
            self.beginTimeStr = selectValue;
            self.pageNumber = 1;
            [self loadData];
        };
        // 自定义弹框样式
        BRPickerStyle *customStyle = [BRPickerStyle pickerStyleWithThemeColor:[UIColor darkGrayColor]];
        datePickerView.pickerStyle = customStyle;
        datePickerView;
    });
    
    _enddatePickerView = ({
        [self.endTimeButton setTitle:self.beginTimeStr forState:(0)];
        BRDatePickerView *datePickerView = [[BRDatePickerView alloc]init];
        datePickerView.pickerMode = BRDatePickerModeDate;
        datePickerView.title = @"结束时间";
        datePickerView.selectDate = self.endTimeSelectDate;
        datePickerView.isAutoSelect = NO;
        datePickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
            
            if (self.beginTimeSelectDate) {
                int re = [CMTimeCommon compareOneDay:selectDate withAnotherDay:self.beginTimeSelectDate];
                if (re == -1 ) {
                    [CMCommon showToastTitle:@"开始时间大于结束时间，请重新选择"];
                    return;
                }
            }
            
            self.endTimeSelectDate = selectDate;
            [self.endTimeButton setTitle:selectValue forState:(0)];
            self.endTimeStr = selectValue;
            self.pageNumber = 1;
            [self loadData];
        };
        // 自定义弹框样式
        BRPickerStyle *customStyle = [BRPickerStyle pickerStyleWithThemeColor:[UIColor darkGrayColor]];
        datePickerView.pickerStyle = customStyle;
        datePickerView;
    });
    
    WeakSelf;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageNumber = 1;
        [weakSelf loadData];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pageNumber =weakSelf.pageNumber+1;
        [weakSelf loadData];
        
    }];
    self.tableView.tableFooterView = [UIView new];
    [weakSelf loadData];
    self.navigationItem.title = @"取款记录";
    self.tableView.startTip = YES;
    self.tableView.tipTitle = @"暂无更多数据";
    
    FastSubViewCode(self.view);
    if (Skin1.isBlack) {
        [self.view setBackgroundColor:Skin1.CLBgColor];
        [subView(@"上View") setBackgroundColor:Skin1.textColor4];
        [_levelSelectView setBackgroundColor:Skin1.textColor4];
        [self.levelSelectButton setTitleColor:Skin1.textColor1 forState:0];
        [self.arrowImage setImage: [[UIImage imageNamed:@"arrow_down"] qmui_imageWithTintColor:Skin1.textColor1] ];
        
        [subView(@"开始View") setBackgroundColor:Skin1.textColor4];
        [self.beiginTimeButton setTitleColor:Skin1.textColor1 forState:0];
        [subImageView(@"下Img") setImage: [[UIImage imageNamed:@"arrow_down"] qmui_imageWithTintColor:Skin1.textColor1] ];
        
        [subLabel(@"至Label") setTextColor:Skin1.textColor1];
        
        [subView(@"结束View") setBackgroundColor:Skin1.textColor4];
        [self.endTimeButton setTitleColor:Skin1.textColor1 forState:0];
        [subImageView(@"下img2") setImage: [[UIImage imageNamed:@"arrow_down"] qmui_imageWithTintColor:Skin1.textColor1] ];
        
        [subView(@"分级View") setBackgroundColor:Skin1.textColor4];
        [subLabel(@"分级Label") setTextColor:Skin1.textColor1];
        
        [subView(@"日期View") setBackgroundColor:Skin1.textColor4];
        [subLabel(@"日期Label") setTextColor:Skin1.textColor1];
        
        [subView(@"投注金额View") setBackgroundColor:Skin1.textColor4];
        [subLabel(@"投注金额Label") setTextColor:Skin1.textColor1];
        
        [subView(@"佣金View") setBackgroundColor:Skin1.textColor4];
        [subLabel(@"佣金Label") setTextColor:Skin1.textColor1];
        
        
    }
}

- (IBAction)levelButtonTaped:(id)sender {
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI);
    self.arrowImage.transform = transform;
    
    YBPopupMenu *popView = [[YBPopupMenu alloc] initWithTitles:_levelArray icons:nil menuWidth:CGSizeMake(UGScreenW / _levelArray.count + 70, 180) delegate:self];
    popView.type = YBPopupMenuTypeDefault;
    popView.fontSize = 12;
    popView.textColor = [UIColor colorWithHex:0x484D52];
    [popView showRelyOnView:self.levelSelectView];
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    PromotionRecordCell1 * cell = [tableView dequeueReusableCellWithIdentifier:@"PromotionRecordCell1" forIndexPath:indexPath];
    [cell bindWithdrawalRecord:self.items[indexPath.row]];
    return cell;
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    
}
- (void)loadData {
    if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
        return;
    }
    if ([UGUserModel currentUser].isTest) {
        return;
    }
    
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"level":[NSString stringWithFormat:@"%ld",(long)_levelindex],
                             @"page":@(self.pageNumber),
                             @"rows":@(self.pageSize),
                             @"startDate":self.beginTimeStr,
                             @"endDate":self.endTimeStr,
    };
    [CMCommon showSystemTitle:[NSString stringWithFormat:@"参数：%@",params]];
    [SVProgressHUD showWithStatus:nil];
    WeakSelf;
    //投注记录信息
    [CMNetwork teamWithdrawListWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            [SVProgressHUD dismiss];
            NSDictionary *data =  model.data;
            NSArray *list = [data objectForKey:@"list"];
            if ([CMCommon stringIsNull:self.dateStr]) {
                [self setDateStr:@""];
            }
            if (weakSelf.pageNumber == 1 ) {
                [weakSelf.items removeAllObjects];
            }
            NSArray *array  = [UGwithdrawListModel arrayOfModelsFromDictionaries:list error:nil];
            [weakSelf.items addObjectsFromArray:array];
            [weakSelf.tableView reloadData];
            if (array.count < self.pageSize) {
                [weakSelf.tableView.mj_footer setState:MJRefreshStateNoMoreData];
                [weakSelf.tableView.mj_footer setHidden:YES];
            }else{
                
                [weakSelf.tableView.mj_footer setState:MJRefreshStateIdle];
                [weakSelf.tableView.mj_footer setHidden:NO];
            }
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
        if ([weakSelf.tableView.mj_header isRefreshing]) {
            [weakSelf.tableView.mj_header endRefreshing];
        }
        if ([weakSelf.tableView.mj_footer isRefreshing]) {
            [weakSelf.tableView.mj_footer endRefreshing];
        }
    }];
}



#pragma mark YBPopupMenuDelegate

- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu {
    if (index >= 0) {
        _levelindex = index;
        [self.levelSelectButton setTitle:_levelArray[index] forState:UIControlStateNormal];
        [self loadData];
    }
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI * 2);
    self.arrowImage.transform = transform;
}

//开始时间
- (IBAction)dateBtnAction:(id)sender {
    [_beigindatePickerView show];
}
//结束时间
- (IBAction)date2BtnAcion:(id)sender {
    [_enddatePickerView show];
}

@end
