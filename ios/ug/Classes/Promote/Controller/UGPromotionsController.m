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
        v.backgroundColor = [UIColor clearColor];
        v;
    });
    __weakSelf_(__self);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [__self getPromoteList];
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
    UITableViewCell *cell;
    if ([@"c190" containsString:APP.SiteId]) {
        cell  = [tableView dequeueReusableCellWithIdentifier:@"cell190" forIndexPath:indexPath];
    }
    else{
        cell  = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    }
    UGPromoteModel *pm = tableView.dataArray[indexPath.row];
    FastSubViewCode(cell);
    if ([@"c190" containsString:APP.SiteId]) {
        subView(@"StackView").cc_constraints.top.constant = pm.title.length ? 12 : 0;
        subView(@"StackView").cc_constraints.bottom.constant = 0;
    }
    if ([@"c199" containsString:APP.SiteId]) {
        subView(@"StackView").cc_constraints.top.constant = 0;
        subView(@"StackView").cc_constraints.left.constant = 0;
    }
    
    subView(@"cell背景View").backgroundColor = Skin1.isBlack ? Skin1.bgColor : Skin1.homeContentColor;
    subLabel(@"标题Label").textColor = Skin1.textColor1;
    subLabel(@"标题Label").text = pm.title;
    subLabel(@"标题Label").hidden = !pm.title.length;
    
    UIImageView *imgView = [cell viewWithTagString:@"图片ImageView"];
//    imgView.frame = cell.bounds;
    NSURL *url = [NSURL URLWithString:pm.pic];
    UIImage *image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:[[SDWebImageManager sharedManager] cacheKeyForURL:url]];
    if (image) {
        if ([@"c190" containsString:APP.SiteId]) {
            CGFloat w = APP.Width;
            CGFloat h = image.height/image.width * w;
            imgView.cc_constraints.height.constant = h;
        } else {
            CGFloat w = APP.Width - 48;
            CGFloat h = image.height/image.width * w;
            imgView.cc_constraints.height.constant = h;
            
        
        }
        [imgView sd_setImageWithURL:url];   // 由于要支持gif动图，还是用sd加载
    } else {
        __weakSelf_(__self);
        __weak_Obj_(imgView, __imgView);
        imgView.cc_constraints.height.constant = 60;
        [imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (image) {
                [__self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
            }
        }];
    }
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
