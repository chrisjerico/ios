//
//  UGPromotionsController.m
//  ug
//
//  Created by ug on 2019/5/10.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGPromotionsController.h"
#import "UGPromoteDetailController.h"   // 优惠详情
#import "UGFundsViewController.h"       // 资金管理
#import "UGChangLongController.h"       // 长龙助手
#import "UGPromotionIncomeController.h" // 推广收益
#import "UGAgentViewController.h"       // 申请代理
#import "UGBetRecordViewController.h"   // 注单记录
#import "UGCommonLotteryController.h"   // 下注页基类

#import "UGAppVersionManager.h"         // 版本更新弹框

#import "UGPromoteModel.h"
#import "GameCategoryDataModel.h"


@interface UGPromotionsController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation UGPromotionsController

- (BOOL)允许未登录访问 { return ![@"c049,c008" containsString:APP.SiteId]; }
- (BOOL)允许游客访问 { return true; }

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"优惠活动";
    self.view.backgroundColor = Skin1.bgColor;
    self.tableView.backgroundColor = Skin1.bgColor;
    
    self.tableView.tableFooterView = ({
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP.Width, 15)];
        v.backgroundColor = Skin1.cellBgColor;
        v;
    });
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getPromoteList];
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
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableView.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = Skin1.cellBgColor;
    UGPromoteModel *pm = tableView.dataArray[indexPath.row];
    FastSubViewCode(cell);
    subLabel(@"标题Label").textColor = Skin1.textColor1;
    subLabel(@"标题Label").text = pm.title;
    __weakSelf_(__self);
    [subImageView(@"图片ImageView") sd_setImageWithURL:[NSURL URLWithString:pm.pic] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            subImageView(@"图片ImageView").cc_constraints.height.constant = image.height/image.width * (APP.Width - 48);
//            [__self.tableView beginUpdates];
//            [__self.tableView endUpdates];
        }
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UGPromoteModel *pm = tableView.dataArray[indexPath.row];
    BOOL ret = [NavController1 pushViewControllerWithLinkCategory:pm.linkCategory linkPosition:pm.linkPosition];
    if (!ret) {
        // 去优惠详情
        UGPromoteDetailController *detailVC = [[UGPromoteDetailController alloc] init];
        detailVC.item = pm;
        [NavController1 pushViewController:detailVC animated:YES];
    }
}

@end
