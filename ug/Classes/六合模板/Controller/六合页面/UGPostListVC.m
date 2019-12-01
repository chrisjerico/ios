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

#import "UGPostCell1.h"     // 帖子Cell
#import "STBarButtonItem.h"
#import "LHPostPayView.h"   // 购买帖子弹框

@interface UGPostListVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@end

@implementation UGPostListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weakSelf_(__self);
    // 顶部UI
    if (_isHistory) {
        self.title = @"历史记录";
        _segmentedControl.superview.hidden = true;
    } else {
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
            if (__self.isHistory) {
                return [NetworkManager1 lhdoc_historyContent:__self.clm.cid page:1];
            } else {
                return [NetworkManager1 lhdoc_contentList:__self.clm.alias uid:nil sort:sortString() page:1];
            }
        } completion:^NSArray *(UITableView *tv, CCSessionModel *sm) {
            NSArray *array = sm.responseObject[@"data"][@"list"];
            for (NSDictionary *dict in array)
                [tv.dataArray addObject:[UGLHPostModel mj_objectWithKeyValues:dict]];
            return array;
        }];
        [_tableView setupFooterRefreshRequest:^CCSessionModel *(UITableView *tv) {
            if (__self.isHistory) {
                return [NetworkManager1 lhdoc_historyContent:__self.clm.cid page:tv.pageIndex];
            } else {
                return [NetworkManager1 lhdoc_contentList:__self.clm.alias uid:nil sort:sortString() page:tv.pageIndex];
            }
        } completion:^NSArray *(UITableView *tv, CCSessionModel *sm) {
            NSArray *array = sm.responseObject[@"data"][@"list"];
            for (NSDictionary *dict in array)
                [tv.dataArray addObject:[UGLHPostModel mj_objectWithKeyValues:dict]];
            return array;
        }];
        [_tableView.mj_footer beginRefreshing];
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

- (void)goToPostDetailVC:(NSIndexPath *)indexPath willComment:(BOOL)willComment {
    UGLHPostModel *pm = _tableView.dataArray[indexPath.row];
    
    __weakSelf_(__self);
    void (^push)(void) = ^{
        UGPostDetailVC *vc = _LoadVC_from_storyboard_(@"UGPostDetailVC");
        vc.pm = pm;
        vc.willComment = willComment;
        vc.didCommentOrLike = ^(UGLHPostModel *pm) {
            [__self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
        };
        [NavController1 pushViewController:vc animated:true];
    };
    
    if (!pm.hasPay && pm.price > 0.000001) {
        LHPostPayView *ppv = _LoadView_from_nib_(@"LHPostPayView");
        ppv.pm = pm;
        ppv.didConfirmBtnClick = ^(LHPostPayView * _Nonnull ppv) {
            [NetworkManager1 lhcdoc_buyContent:pm.cid].completionBlock = ^(CCSessionModel *sm) {
                if (!sm.error) {
                    [ppv hide:nil];
                    UIAlertController *ac = [AlertHelper showAlertView:@"支付成功" msg:nil btnTitles:@[@"确定"]];
                    [ac setActionAtTitle:@"确定" handler:^(UIAlertAction *aa) {
                        push();
                    }];
                }
            };
        };
        [ppv show];
    } else {
        push();
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
        [__self goToPostDetailVC:indexPath willComment:true];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self goToPostDetailVC:indexPath willComment:false];
}

@end
