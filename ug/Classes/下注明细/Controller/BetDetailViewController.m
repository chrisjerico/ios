//
//  BetDetailViewController.m
//  UGBWApp
//
//  Created by ug on 2020/6/30.
//  Copyright © 2020 ug. All rights reserved.
//

#import "BetDetailViewController.h"
#import "UITableView+LSEmpty.h"
#import "UGBetsRecordListModel.h"
#import "BetDetailTableViewCell.h"

@interface BetDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *itemViews;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *itemLabels;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray* items;
@end

@implementation BetDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView registerNib: [UINib nibWithNibName:@"BetDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"BetDetailTableViewCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.layer.borderWidth = 0.5;
    self.tableView.layer.borderColor = RGBA(228, 231, 235, 1).CGColor;
    self.items = [NSMutableArray array];
    self.tableView.tableFooterView = [UIView new];
    self.title = @"下注明细";
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
    
    BetDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"BetDetailTableViewCell" forIndexPath:indexPath];
    [cell bindBetDetail:self.items[indexPath.row] row:indexPath.row];
    return cell;
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)setDate:(NSString *)date{
    _date = date;
    
    if (![CMCommon stringIsNull:_date]) {
        [self loadData];
    }
    
}

- (void)loadData {
    if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
        return;
    }
    if ([UGUserModel currentUser].isTest) {
        return;
    }
    
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"date":_date,
                             
                             
    };
    //        [CMCommon showSystemTitle:[NSString stringWithFormat:@"参数：%@",params]];
    [SVProgressHUD showWithStatus:nil];
    WeakSelf;
    //投注记录信息
    [CMNetwork userLotteryDayStatWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        
        
        
        [CMResult processWithResult:model success:^{
            [SVProgressHUD dismiss];
            
            
            weakSelf.items = [NSMutableArray new];
            NSLog(@"model=%@",model);
            NSDictionary *dicData =  model.data;
            
            for (NSArray *value in [dicData allValues]) {
                
                NSLog(@"value: %@", value);
                NSArray *array  = [UGBetsRecordModel arrayOfModelsFromDictionaries:value error:nil];
                
                UGBetsRecordModel *obj = [array objectAtIndex:0];
                
                NSLog(@"obj.title= %@",obj.title);
                
                [weakSelf.items addObject:obj];
            }
            [weakSelf.tableView reloadData];
            
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
        
    }];
}

@end
