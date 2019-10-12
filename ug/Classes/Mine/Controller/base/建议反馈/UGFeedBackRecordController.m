//
//  UGFeedBackRecordController.m
//  ug
//
//  Created by ug on 2019/6/8.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGFeedBackRecordController.h"
#import "UGFeedbackDetailController.h"
#import "YBPopupMenu.h"
#import "UGFeedbackTableViewCell.h"
#import "UGMessageModel.h"
@interface UGFeedBackRecordController ()<UITableViewDelegate,UITableViewDataSource,YBPopupMenuDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *dateArrow;
@property (weak, nonatomic) IBOutlet UIImageView *stateArrow;
@property (weak, nonatomic) IBOutlet UIImageView *typeArrow;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIButton *typeButton;
@property (weak, nonatomic) IBOutlet UIButton *dateButton;
@property (weak, nonatomic) IBOutlet UIButton *stateButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) YBPopupMenu *datePopView;
@property (nonatomic, strong) YBPopupMenu *statePopView;
@property (nonatomic, strong) YBPopupMenu *typePopView;

@property (nonatomic, strong) NSMutableArray *dateArray;
@property (nonatomic, strong) NSMutableArray *stateArray;
@property (nonatomic, strong) NSMutableArray *typeArray;

@property (nonatomic, assign) NSInteger selectType;
@property (nonatomic, assign) NSInteger selectStatus;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, assign) int pageSize;
@property(nonatomic, assign) int pageNumber;
@end

//分页初始值
static int page = 1;
static int size = 20;
@implementation UGFeedBackRecordController
-(void)skin{
  
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    SANotificationEventSubscribe(UGNotificationWithSkinSuccess, self, ^(typeof (self) self, id obj) {
        
        [self skin];
    });
    self.navigationItem.title = @"反馈记录";
    self.pageSize = size;
    self.pageNumber = page;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 60;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.stateArray = @[@"全部",@"已回复",@"待回复"].mutableCopy;
    self.typeArray = @[@"全部",@"建议反馈",@"投诉建议"].mutableCopy;
    self.dateLabel.text = self.dateArray.firstObject;
    self.stateLabel.text = self.stateArray.firstObject;
    self.typeLabel.text = self.typeArray.firstObject;
    self.selectType = 0;
    self.selectStatus = 0;
    [self setupRefreshView];
    [self getFeedbackListData];
}

- (void)setupRefreshView
{
    WeakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageNumber = 1;
        [weakSelf getFeedbackListData];
    
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getFeedbackListData];
    }];
    self.tableView.mj_footer.hidden = YES;
    
}

- (IBAction)showDatePopView:(id)sender {
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI);
    self.dateArrow.transform = transform;
    YBPopupMenu *popView = [[YBPopupMenu alloc] initWithTitles:self.dateArray icons:nil menuWidth:CGSizeMake(self.dateButton.width + 15, 280) delegate:self];
    popView.fontSize = 14;
    popView.type = YBPopupMenuTypeDefault;
    [popView showRelyOnView:self.dateButton];
    self.datePopView = popView;

}

- (IBAction)showTypePopView:(id)sender {
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI);
    self.typeArrow.transform = transform;
    YBPopupMenu *popView = [[YBPopupMenu alloc] initWithTitles:self.typeArray icons:nil menuWidth:CGSizeMake(self.typeButton.width + 15, 130) delegate:self];
    popView.fontSize = 14;
    popView.type = YBPopupMenuTypeDefault;
    [popView showRelyOnView:self.typeButton];
    self.typePopView = popView;
    
}

- (IBAction)showStatePopView:(id)sender {
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI);
    self.stateArrow.transform = transform;
    YBPopupMenu *popView = [[YBPopupMenu alloc] initWithTitles:self.stateArray icons:nil menuWidth:CGSizeMake(self.stateButton.width + 20, 130) delegate:self];
    popView.fontSize = 14;
    popView.type = YBPopupMenuTypeDefault;
    [popView showRelyOnView:self.stateButton];
    self.statePopView = popView;
    
}

- (void)getFeedbackListData {
    if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
        return;
    }
    NSDictionary *params = @{@"page":@(self.pageNumber),
                             @"rows":@(self.pageSize),
                             @"token":[UGUserModel currentUser].sessid,
                             @"type":self.selectType > 0 ? @(self.selectType - 1) : @"",
                             @"date":self.dateLabel.text,
                             @"isReply":@(self.selectStatus)
                             };
    
    [CMNetwork getFeedbackListWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            if (!model.data) {
                [self.dataArray removeAllObjects];
                [self.tableView reloadData];
                return ;
            }
            UGMessageListModel *message = model.data;
            NSArray *array = message.list;
            if (self.pageNumber == 1 ) {
                
                [self.dataArray removeAllObjects];
            }
            
            [self.dataArray addObjectsFromArray:array];
            [self.tableView reloadData];
            if (array.count < self.pageSize) {
                [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
                [self.tableView.mj_footer setHidden:YES];
            }else{
                self.pageNumber ++;
                [self.tableView.mj_footer setState:MJRefreshStateIdle];
                [self.tableView.mj_footer setHidden:NO];
            }
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
        
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
        }
        
        if ([self.tableView.mj_footer isRefreshing]) {
            [self.tableView.mj_footer endRefreshing];
        }
    }];
    
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGFeedbackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UGFeedbackTableViewCell" forIndexPath:indexPath];
    cell.item = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UGFeedbackDetailController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UGFeedbackDetailController"];
    detailVC.item = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - YBPopupMenuDelegate

- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu {
    if (index >= 0) {
        if (ybPopupMenu == self.datePopView) {
            if ([self.dateLabel.text isEqualToString:self.dateArray[index]]) {
                return;
            }
            self.dateLabel.text = self.dateArray[index];
            
        }else if(ybPopupMenu == self.statePopView){
            self.stateLabel.text = self.stateArray[index];
            if (self.selectStatus == index) {
                return;
            }
            self.selectStatus = index;
            
        }else {
            self.typeLabel.text = self.typeArray[index];
            if (self.selectType == index) {
                return;
            }
            self.selectType = index;
            
        }
        [self getFeedbackListData];
    }
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI * 2);
    self.dateArrow.transform = transform;
    self.stateArrow.transform = transform;
    self.typeArrow.transform = transform;
}

- (NSMutableArray *)dateArray {
    if (_dateArray == nil) {
        _dateArray = [NSMutableArray array];
        for (int i = 0; i < 30; i++) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *currentDate = [NSDate date];
            NSTimeInterval oneDay = 24 * 60 * 60;
            NSDate *startDay = [currentDate initWithTimeIntervalSinceNow:-(oneDay * i)];
            NSString *startDateStr = [formatter stringFromDate:startDay];
            [_dateArray addObject:startDateStr];
        }
    }
    return _dateArray;
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)stateArray {
    if (_stateArray == nil) {
        _stateArray = [NSMutableArray array];
    }
    
    return _stateArray;
}

@end
