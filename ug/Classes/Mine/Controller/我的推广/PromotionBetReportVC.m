//
//  PromotionBetReportVC.m
//  ug
//
//  Created by xionghx on 2020/1/10.
//  Copyright © 2020 ug. All rights reserved.
//

#import "PromotionBetReportVC.h"
#import "PromotionRecordCell1.h"
#import "PromotionRecordCell2.h"

#import "UGbetStatModel.h"
#import "UGrealBetStatModel.h"
#import "YBPopupMenu.h"

#import "BRPickerView.h"
#import "CMTimeCommon.h"
#import "PromotionBetRecordVC.h"
#import "PromotionOtherBetRecordVC.h"
@interface PromotionBetReportVC ()<UITableViewDelegate, UITableViewDataSource, YBPopupMenuDelegate>
{
    NSInteger _levelindex;
    NSArray * _levelArray;
}
@property(nonatomic, strong)UISegmentedControl * titleSegment;


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign)NSInteger pageSize;
@property (nonatomic, assign)NSInteger pageNumber;
@property (nonatomic, strong)NSMutableArray* items;

//其他投注
@property (nonatomic, assign)NSInteger pageSizeOther;
@property (nonatomic, assign)NSInteger pageNumberOther;
@property (nonatomic, strong)NSMutableArray* itemsOther;


@property (nonatomic, assign)NSInteger typeIndex;

@property (weak, nonatomic) IBOutlet UIView *levelSelectView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;
@property (weak, nonatomic) IBOutlet UIButton *levelSelectButton;
@property (weak, nonatomic) IBOutlet UIButton *beiginTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *endTimeButton;

@property (nonatomic, strong) NSDate *beginTimeSelectDate;
@property (nonatomic, strong) NSDate *endTimeSelectDate;
@property (nonatomic, strong) NSString *beginTimeStr;
@property (nonatomic, strong) NSString *endTimeStr;
@end

@implementation PromotionBetReportVC
-(UISegmentedControl *)titleSegment {
    if (!_titleSegment) {
        _titleSegment = [[UISegmentedControl alloc] initWithItems:@[@"彩票报表", @"其它报表"]];
        [_titleSegment setTitleTextAttributes:@{NSForegroundColorAttributeName:Skin1.navBarBgColor} forState:UIControlStateSelected];
        [_titleSegment setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColor.whiteColor} forState:UIControlStateNormal];
        _titleSegment.layer.borderWidth = 0.5;
        _titleSegment.layer.borderColor = [UIColor.whiteColor CGColor];
        [_titleSegment setSelectedSegmentIndex:0];
        [_titleSegment addTarget:self action:@selector(titleSegmentValueChanged:) forControlEvents:UIControlEventValueChanged];
        
    }
    return _titleSegment;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = self.titleSegment;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib: [UINib nibWithNibName:@"PromotionRecordCell1" bundle:nil] forCellReuseIdentifier:@"PromotionRecordCell1"];
    [self.tableView registerNib: [UINib nibWithNibName:@"PromotionRecordCell2" bundle:nil] forCellReuseIdentifier:@"PromotionRecordCell2"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.beginTimeStr = APP.beginTime;
    self.endTimeStr = [CMTimeCommon currentDateStringWithFormat:@"yyyy-MM-dd"];
    self.beginTimeSelectDate = [CMTimeCommon dateForStr:APP.beginTime format:@"yyyy-MM-dd"];
    self.endTimeSelectDate = [CMTimeCommon dateForStr:self.endTimeStr format:@"yyyy-MM-dd"];
    [self.beiginTimeButton setTitle:APP.beginTime forState:(0)];
    [self.endTimeButton setTitle:self.endTimeStr forState:(0)];
    
    
    
    self.pageSize = APP.PageCount;
    self.pageNumber = 1;
    self.items = [NSMutableArray array];
    
    self.pageSizeOther = APP.PageCount;
    self.pageNumberOther = 1;
    self.itemsOther = [NSMutableArray array];
    
    self.typeIndex = 0;
    _levelArray = @[@"全部下线",@"一级下线",@"二级下线",@"三级下线",@"四级下线",@"五级下线",@"六级下线",@"七级下线",@"八级下线",@"九级下线",@"十级下线"];
    _levelindex = 0;
    WeakSelf;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageNumber = 1;
        [weakSelf loadData];
        
        
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pageNumber =weakSelf.pageNumber+1;
        [weakSelf loadData];
        
    }];
    [weakSelf loadData];
    
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
        
        
        [subView(@"输赢View") setBackgroundColor:Skin1.textColor4];
        [subLabel(@"输赢Label") setTextColor:Skin1.textColor1];
        
        
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

- (void)titleSegmentValueChanged: (UISegmentedControl*)sender {
    self.pageNumber = 1;
    self.typeIndex = sender.selectedSegmentIndex;

    
    [self loadData];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (self.typeIndex == 0) {
        PromotionRecordCell2 * cell = [tableView dequeueReusableCellWithIdentifier:@"PromotionRecordCell2" forIndexPath:indexPath];
        [cell bindBetReport:self.items[indexPath.row] row:indexPath.row];
        return cell;
    } else  {
        PromotionRecordCell1 * cell = [tableView dequeueReusableCellWithIdentifier:@"PromotionRecordCell1" forIndexPath:indexPath];
        [cell bindOtherReport:self.itemsOther[indexPath.row] row:indexPath.row];
        return cell;
    }
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.typeIndex == 0) {
        return self.items.count;
    } else {
        return self.itemsOther.count;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.typeIndex == 0) {
        UGbetStatModel *ob = (UGbetStatModel *)self.items[indexPath.row];
        PromotionBetRecordVC * vc = [[UIStoryboard storyboardWithName:@"MyPromotion" bundle:nil] instantiateViewControllerWithIdentifier:@"PromotionBetRecordVC"];
        vc.dateStr = ob.date;
        [self.navigationController pushViewController:vc animated:YES];
        
        NSLog(@"ob.date = %@",ob.date);
        
    } else {
        UGrealBetStatModel *ob = (UGrealBetStatModel *)self.itemsOther[indexPath.row];
        PromotionOtherBetRecordVC * vc = [[UIStoryboard storyboardWithName:@"MyPromotion" bundle:nil] instantiateViewControllerWithIdentifier:@"PromotionOtherBetRecordVC"];
        vc.dateStr = ob.date;
        NSLog(@"ob.date = %@",ob.date);
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)loadData {
    
    
    if (self.typeIndex == 0) {
        [self loadBetReport];
    } else if (self.typeIndex == 1) {
        [self loadOtherReport];
    }
}
- (void)resetSegmentView {
    FastSubViewCode(self.view);
    if (self.typeIndex == 0) {
        subLabel(@"佣金Label").text = @"佣金";
        [subView(@"输赢View") setHidden:NO];
    } else if (self.typeIndex == 1) {
        subLabel(@"佣金Label").text = @"会员输赢";
        [subView(@"输赢View") setHidden:YES];
    }
}

- (void)loadBetReport  {
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
    NSLog(@"请求参数：%@",params);
    [SVProgressHUD showWithStatus:nil];
    WeakSelf;
    [CMNetwork teamBetStatWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            [SVProgressHUD dismiss];
            NSDictionary *data =  model.data;
            NSArray *list = [data isKindOfClass:[NSDictionary class]] ? [data objectForKey:@"list"] : ([data isKindOfClass:[NSArray class]] ? data : nil);
            if (weakSelf.pageNumber == 1 ) {
                [weakSelf.items removeAllObjects];
            }
            NSArray *array  = [UGbetStatModel arrayOfModelsFromDictionaries:list error:nil];
            [weakSelf.items addObjectsFromArray:array];
            [weakSelf.tableView reloadData];
            
            [weakSelf resetSegmentView];
            
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
- (void)loadOtherReport  {
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
    
    NSLog(@"请求参数：%@",params);
    
    [SVProgressHUD showWithStatus:nil];
    WeakSelf;
    [CMNetwork teamRealBetStatWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            [SVProgressHUD dismiss];
            NSDictionary *data =  model.data;
            NSArray *list = [data isKindOfClass:[NSDictionary class]] ? [data objectForKey:@"list"] : ([data isKindOfClass:[NSArray class]] ? data : nil);
            if (weakSelf.pageNumber == 1 ) {
                [weakSelf.itemsOther removeAllObjects];
            }
            //数组转模型数组
            NSArray *array  = [UGrealBetStatModel arrayOfModelsFromDictionaries:list error:nil];
            [weakSelf.itemsOther addObjectsFromArray:array];
            [weakSelf.tableView reloadData];
            [weakSelf resetSegmentView];
            if (array.count < weakSelf.pageSize) {
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
    // 开始时间
    BRDatePickerView *datePickerView = [[BRDatePickerView alloc]init];
    datePickerView.pickerMode = BRDatePickerModeDate;
    datePickerView.title = @"开始时间";
    datePickerView.selectDate = self.beginTimeSelectDate;
    datePickerView.isAutoSelect = NO;
    datePickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
        //         int   1  晚， -1 早  0 相同
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
    [datePickerView show];
}
//结束时间
- (IBAction)date2BtnAcion:(id)sender {
    
    // 结束时间
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
    [datePickerView show];
}

@end
