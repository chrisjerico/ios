//
//  UGPostListVC.m
//  ug
//
//  Created by fish on 2019/10/27.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGPostListVC.h"
#import "UGPostDetailVC.h"  // 帖子详情
#import "UGSearchPostVC.h"  // 搜索帖子

#import "UGPostCell1.h"
#import "STBarButtonItem.h"

@interface UGPostListVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@end

@implementation UGPostListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weakSelf_(__self);
    // 导航条
    {
        self.title = _clm.name;
        self.navigationItem.rightBarButtonItems = @[
            [STBarButtonItem barButtonItemWithImageName:@"search" block:^(UIButton *sender) {
                UGSearchPostVC *vc = _LoadVC_from_storyboard_(@"UGSearchPostVC");
                vc.clm = __self.clm;
                [NavController1 pushViewController:vc animated:true];
            }],
            [STBarButtonItem barButtonItemWithImageName:@"yijian" block:^(UIButton *sender) {
                [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGSubmitPostVC") animated:true];
            }],
        ];
    }
    
    // TableView
    {
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
            NSArray *array = sm.responseObject[@"data"][@"list"];
            for (NSDictionary *dict in array)
                [tv.dataArray addObject:[UGLHPostModel mj_objectWithKeyValues:dict]];
            return array;
        }];
        [_tableView setupFooterRefreshRequest:^CCSessionModel *(UITableView *tv) {
            return [NetworkManager1 lhdoc_contentList:__self.clm.alias uid:nil sort:sortString() page:tv.pageIndex];
        } completion:^NSArray *(UITableView *tv, CCSessionModel *sm) {
            NSArray *array = sm.responseObject[@"data"][@"list"];
            for (NSDictionary *dict in array)
                [tv.dataArray addObject:[UGLHPostModel mj_objectWithKeyValues:dict]];
            return array;
        }];
        [_tableView.mj_header beginRefreshing];
    }
}

- (IBAction)onSegmentedControlValueChanged:(UISegmentedControl *)sender {
    if (_tableView.mj_header.state == MJRefreshStateRefreshing) {
        _tableView.willClearDataArray = true;
        if (_tableView.mj_header.refreshingBlock) {
            _tableView.mj_header.refreshingBlock();
        }
    } else {
        [_tableView.mj_header beginRefreshing];
    }
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UGPostCell1 heightWithModel:tableView.dataArray[indexPath.row]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableView.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGPostCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.pm = tableView.dataArray[indexPath.row];
    __weak_Obj_(cell, __cell);
    __weak_Obj_(tableView, __tableView);
    __weakSelf_(__self);
    
    // 全文/收起
    cell.didShowAllBtnClick = ^(UGLHPostModel *pm) {
        CGFloat offsetY = -[__cell convertRect:__cell.bounds toView:tableView.superview].origin.y;
        if (offsetY > 0)
            offsetY = 0;
        for (int i=0; i<indexPath.row; i++) {
            offsetY += [__self tableView:__tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        [__tableView reloadData];
        __tableView.contentOffset = CGPointMake(0, offsetY);
    };
    
    // 去评论
    cell.didCommentBtnClick = ^(UGLHPostModel *pm) {
        UGPostDetailVC *vc = _LoadVC_from_storyboard_(@"UGPostDetailVC");
        vc.pm = pm;
        vc.willComment = true;
        vc.didCommentOrLike = ^(UGLHPostModel *pm) {
            [__tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
        };
        vc.didDelete = ^{
            [__tableView.dataArray removeObject:pm];
            [__tableView deleteRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
        };
        [NavController1 pushViewController:vc animated:true];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UGPostDetailVC *vc = _LoadVC_from_storyboard_(@"UGPostDetailVC");
    vc.pm = tableView.dataArray[indexPath.row];
    __weak_Obj_(vc, __vc);
    vc.didCommentOrLike = ^(UGLHPostModel *pm) {
        [tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
    };
    vc.didDelete = ^{
        [tableView.dataArray removeObject:__vc.pm];
        [tableView deleteRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
    };
    [NavController1 pushViewController:vc animated:true];
}

@end
