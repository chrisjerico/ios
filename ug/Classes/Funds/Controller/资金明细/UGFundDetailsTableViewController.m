//
//  UGFundDetailsTableViewController.m
//  ug
//
//  Created by ug on 2019/5/3.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGFundDetailsTableViewController.h"
#import "UGFundDetailsCell.h"
#import "UGFundLogsModel.h"
#import "BetDetailViewController.h"
#import "YBPopupMenu.h"

@interface UGFundDetailsTableViewController ()<YBPopupMenuDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray <UGFundLogsModel *> *dataArray;
@property (nonatomic, strong) NSString *startTime;

@property(nonatomic, assign) int pageSize;
@property(nonatomic, assign) int pageNumber;
@property (nonatomic, strong) UIImageView *arrowImageView;//按钮的切换图片
@property (nonatomic, strong) UIButton *levelButton;//按钮
@property (nonatomic, strong) NSMutableArray <NSString *> *levelArray;//点击后显示的内容
@property (nonatomic, strong) NSMutableArray <UGFundLogsModel *> *groupsArray;//点击后显示的内容model
@property(nonatomic, strong) UGFundLogsModel *selModel;//选中
@end


//分页初始值
static int page = 1;
static int size = 20;
static NSString *fundDetailsCellid = @"UGFundDetailsCell";


@implementation UGFundDetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"资金明细";
    self.groupsArray = [NSMutableArray new];
    self.levelArray = [NSMutableArray new];
     [self.view setBackgroundColor: Skin1.bgColor];
    self.pageSize = size;
    self.pageNumber = page;
    self.tableView.rowHeight = 50;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 120, 0);
    [self.tableView registerNib:[UINib nibWithNibName:@"UGFundDetailsCell" bundle:nil] forCellReuseIdentifier:fundDetailsCellid];
    self.tableView.separatorColor = Skin1.isBlack ? [UIColor lightTextColor] : APP.LineColor;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSDate *currentDate = [NSDate date];
    NSTimeInterval oneDay = 24 * 60 * 60;
    NSDate *startDay = [currentDate initWithTimeIntervalSinceNow:-(oneDay * 10)];
    self.startTime = [formatter stringFromDate:startDay];
    [self setupRefreshView];
    [self getFundLogs];
    self.tableView.backgroundColor = Skin1.textColor4;

}


//添加上下拉刷新
- (void)setupRefreshView
{
    WeakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageNumber = 1;
        [weakSelf getFundLogs];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getFundLogs];
    }];
    self.tableView.mj_footer.hidden = YES;
    
}

- (void)getFundLogs {
    if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
        return;
    }
    if ([UGUserModel currentUser].isTest) {
        return;
    }
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"page":@(self.pageNumber),
                             @"rows":@(self.pageSize),
                             @"startTime":self.startTime,
                             @"group":self.selModel.fid,
                             @"endTime":@""
                             };
    WeakSelf;
    [CMNetwork fundLogsWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            UGFundLogsListModel *listModel = model.data;
            NSArray *array = listModel.list;
            [weakSelf.levelArray removeAllObjects];
            [weakSelf.groupsArray removeAllObjects];
 
            NSArray *tempArray = listModel.groups  ;
            [weakSelf.groupsArray addObject: [[UGFundLogsModel alloc] initWithFid:@"0" Name:@"全部类型"]];
            
            if(![CMCommon arryIsNull:tempArray]){
                for (UGFundLogsModel *obj in tempArray) {
                    [weakSelf.groupsArray addObject:obj];
                }
            }
            
            if(![CMCommon arryIsNull:weakSelf.groupsArray ]){
                for (UGFundLogsModel *obj in weakSelf.groupsArray) {
                    [weakSelf.levelArray addObject:obj.name];
                }
            }
            
            if (weakSelf.pageNumber == 1 ) {
                
                [weakSelf.dataArray removeAllObjects];
            }
            
            [weakSelf.dataArray addObjectsFromArray:array];
            [weakSelf.tableView reloadData];
            if (array.count < weakSelf.pageSize) {
                [weakSelf.tableView.mj_footer setState:MJRefreshStateNoMoreData];
                [weakSelf.tableView.mj_footer setHidden:YES];
            }else{
                weakSelf.pageNumber ++;
                [weakSelf.tableView.mj_footer setState:MJRefreshStateIdle];
                [weakSelf.tableView.mj_footer setHidden:NO];
            }
        } failure:^(id msg) {

        }];
        
        if ([weakSelf.tableView.mj_header isRefreshing]) {
            [weakSelf.tableView.mj_header endRefreshing];
        }
        
        if ([weakSelf.tableView.mj_footer isRefreshing]) {
            [weakSelf.tableView.mj_footer endRefreshing];
        }
    }];

}


- (void)levelClick {
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI);
    self.arrowImageView.transform = transform;
    
    YBPopupMenu *popView = [[YBPopupMenu alloc] initWithTitles:self.levelArray icons:nil menuWidth:CGSizeMake(UGScreenW / 4 + 70, 180) delegate:self];
    popView.type = YBPopupMenuTypeDefault;
    popView.fontSize = 15;
    [popView showRelyOnView:self.levelButton];
}
#pragma mark YBPopupMenuDelegate

- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu {
    if (index >= 0) {
        
       NSString *selName = [self.levelArray objectAtIndex:index];
        self.selModel = [self selFundLogbyName : selName];
        
       [self getFundLogs];
    }
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI * 2);
    self.arrowImageView.transform = transform;
}

-(UGFundLogsModel *)selFundLogbyName:(NSString *)name{
    
    UGFundLogsModel *model = [[UGFundLogsModel alloc] initWithFid:@"0" Name:@"全部类型"];
    for (UGFundLogsModel *object in self.groupsArray) {
        if ([object.name isEqualToString:name]) {
            model = object;
            break;
        }
    }
    
    return model;
}

#pragma mark tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGFundDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:fundDetailsCellid forIndexPath:indexPath];
    cell.item = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UGScreenW, 44)];
    headerView.backgroundColor = Skin1.textColor4;
    
    UILabel *timeLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, UGScreenW / 4, 44)];
    timeLable.text = @"日期";
    timeLable.textColor = Skin1.textColor1;
    timeLable.font = [UIFont systemFontOfSize:14 weight:UIFontWeightHeavy];
    timeLable.textAlignment = NSTextAlignmentCenter;
    
    UILabel *amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(timeLable.frame), 0,UGScreenW / 4, 44)];
    amountLabel.text = @"金额";
    amountLabel.textColor = Skin1.textColor1;
    amountLabel.textAlignment = NSTextAlignmentCenter;
    amountLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightHeavy];
    
    UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(amountLabel.frame), 0, UGScreenW / 4, 44)];
    stateLabel.text = @"类型";
    stateLabel.textAlignment = NSTextAlignmentCenter;
    stateLabel.textColor = Skin1.textColor1;
    stateLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightHeavy];
    //按钮
    UIButton *button = [[UIButton alloc] initWithFrame:stateLabel.frame];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(levelClick)];
    self.levelButton = button;
    [headerView addSubview:button];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(stateLabel.width - 18, (stateLabel.height - 18) / 2, 18, 18)];
    [stateLabel addSubview:imgView];
    self.arrowImageView = imgView;
    if (Skin1.isBlack) {
        imgView.image = [UIImage imageNamed:@"baijiantou"];
    } else {
        imgView.image = [UIImage imageNamed:@"jiantou1"];
    }
    
    
    UILabel *balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(stateLabel.frame), 0, UGScreenW / 4, 44)];
    balanceLabel.text = @"余额";
    balanceLabel.textAlignment = NSTextAlignmentCenter;
    balanceLabel.textColor = Skin1.textColor1;
    balanceLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightHeavy];
    
//    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(15, 43, UGScreenW, 0.5)];
//    line.backgroundColor = Skin1.bgColor;
//
    [headerView addSubview:timeLable];
    [headerView addSubview:amountLabel];
    [headerView addSubview:stateLabel];
    [headerView addSubview:balanceLabel];
//    [headerView addSubview:line];
    
    return headerView;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
       
 
       
    

}




- (NSMutableArray<UGFundLogsModel *> *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
