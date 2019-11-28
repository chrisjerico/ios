//
//  UGPostListVC.m
//  ug
//
//  Created by fish on 2019/10/27.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGPostListVC.h"

@interface UGPostListVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@end

@implementation UGPostListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weakSelf_(__self);
    NSString *(^sortString)(void) = ^NSString *{
        if (__self.segmentedControl.selectedSegmentIndex == 1) {
            return @"hot";  // 热门（精华贴）
        } else if (__self.segmentedControl.selectedSegmentIndex == 2) {
            return @"new";  // 最新
        }
        return nil; // 综合
    };
    [_tableView setupHeaderRefreshRequest:^CCSessionModel *(UITableView *tv) {
        return [NetworkManager1 lhdoc_contentList:__self.clm.alias uid:nil sort:sortString() page:1];
    } completion:^NSArray *(UITableView *tv, CCSessionModel *sm) {
        return nil;
    }];
    [_tableView setupFooterRefreshRequest:^CCSessionModel *(UITableView *tv) {
        return [NetworkManager1 lhdoc_contentList:__self.clm.alias uid:nil sort:sortString() page:tv.pageIndex];
    } completion:^NSArray *(UITableView *tv, CCSessionModel *sm) {
        return nil;
    }];
    [_tableView.mj_header beginRefreshing];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableView.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    UGPromoteModel *model = tableView.dataArray[indexPath.row];
//    UGPromoteDetailController *detailVC = [[UGPromoteDetailController alloc] init];
//    detailVC.item = model;
//    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
