//
//  UGPromotionsController.m
//  ug
//
//  Created by ug on 2019/5/10.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGPromotionsController.h"
#import "UGPromoteModel.h"
#import "UGPromoteDetailController.h"

@interface UGPromotionsController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation UGPromotionsController

- (BOOL)允许未登录访问 { return true; }
- (BOOL)允许游客访问 { return true; }

- (void)skin {
    self.view.backgroundColor = UGBackgroundColor;
    self.tableView.backgroundColor = UGBackgroundColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    SANotificationEventSubscribe(UGNotificationWithSkinSuccess, self, ^(typeof (self) self, id obj) {
        [self skin];
    });
    self.navigationItem.title = @"优惠活动";
    self.view.backgroundColor = UGBackgroundColor;

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getPromoteList];
        self.view.backgroundColor = UGBackgroundColor;
        self.tableView.backgroundColor = UGBackgroundColor;
        
    }];
    [self getPromoteList];
}

- (void)getPromoteList {
    __weakSelf_(__self);
    [SVProgressHUD show];
    [CMNetwork getPromoteListWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [__self.tableView.mj_header endRefreshing];
        [SVProgressHUD dismiss];
        [CMResult processWithResult:model success:^{
            UGPromoteListModel *listModel = model.data;
            [__self.tableView.dataArray setArray:listModel.list];
            [__self.tableView reloadData];
        } failure:nil];
    }];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableView.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [[UGSkinManagers shareInstance] setCellbgColor];
    UGPromoteModel *pm = tableView.dataArray[indexPath.row];
    FastSubViewCode(cell);
    NSLog(@"pm.title = %@", pm.title);
    subLabel(@"标题Label").text = pm.title;
    [subImageView(@"图片ImageView") sd_setImageWithURL:[NSURL URLWithString:pm.pic] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            subImageView(@"图片ImageView").cc_constraints.height.constant = image.height/image.width * (APP.Width - 48);
        }
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UGPromoteModel *model = tableView.dataArray[indexPath.row];
    UGPromoteDetailController *detailVC = [[UGPromoteDetailController alloc] init];
    detailVC.item = model;
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
