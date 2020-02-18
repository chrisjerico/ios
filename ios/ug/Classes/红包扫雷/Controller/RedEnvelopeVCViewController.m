//
//  RedEnvelopeVCViewController.m
//  ug
//
//  Created by ug on 2020/2/9.
//  Copyright © 2020 ug. All rights reserved.
//

#import "RedEnvelopeVCViewController.h"
#import "RedBagLogModel.h"
#import "CMTimeCommon.h"
#import "UITableView+LSEmpty.h"
#import "RedBagLogCell1.h"

@interface RedEnvelopeVCViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *itemViews;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *itemLabels;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign)NSInteger pageSize;
@property (nonatomic, assign)NSInteger pageNumber;
@property (nonatomic, strong)NSMutableArray* items;
@end

@implementation RedEnvelopeVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView registerNib: [UINib nibWithNibName:@"RedBagLogCell1" bundle:nil] forCellReuseIdentifier:@"RedBagLogCell1"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.layer.borderWidth = 0.5;
    self.tableView.layer.borderColor = RGBA(228, 231, 235, 1).CGColor;
    
    self.pageSize = 20;
    self.pageNumber = 1;
    self.items = [NSMutableArray array];
    
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
    if (self.type == 1) {//红包类型 1-普通红包 2-扫雷红包 |
        self.title = @"红包记录";
    } else {
        self.title = @"扫雷记录";
    }
    self.tableView.startTip = YES;
    self.tableView.tipTitle = @"暂无更多数据";
    
    [self.view setBackgroundColor:RGBA(241, 242, 245, 1)];
    if (Skin1.isBlack) {
        [self.view setBackgroundColor:Skin1.CLBgColor];
        
        for (UIView *v in _itemViews) {
            [v setBackgroundColor:Skin1.textColor4];
        }
        
        for (UILabel *lab in _itemLabels) {
            [lab setTextColor:Skin1.textColor1];
        }
    }
}



- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    RedBagLogCell1 * cell = [tableView dequeueReusableCellWithIdentifier:@"RedBagLogCell1" forIndexPath:indexPath];
    [cell bindRedBagLog:self.items[indexPath.row] row:indexPath.row];
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
                             @"type":@(self.type),
                             @"page":@(self.pageNumber),
                             @"rows":@(self.pageSize),
                             
    };
        [CMCommon showSystemTitle:[NSString stringWithFormat:@"参数：%@",params]];
    [SVProgressHUD showWithStatus:nil];
    WeakSelf;
    //投注记录信息
    [CMNetwork chatRedBagLogPageWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            [SVProgressHUD dismiss];
            NSDictionary *data =  model.data;
            NSArray *list = [data objectForKey:@"list"];
            
            if (weakSelf.pageNumber == 1 ) {
                [weakSelf.items removeAllObjects];
            }
            NSArray *array  = [RedBagLogModel arrayOfModelsFromDictionaries:list error:nil];
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

@end
