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
#import "UGSubmitPostVC.h"  // 发帖

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
    if (_request) {
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
                UGSubmitPostVC *vc = _LoadVC_from_storyboard_(@"UGSubmitPostVC");
                vc.clm = __self.clm;
                [NavController1 pushViewController:vc animated:true];
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
            if (__self.request) {
                CCSessionModel *sm = __self.request(1);
                if (!sm) {
                    [__self.tableView.mj_header endRefreshing];
                }
                return sm;
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
            if (__self.request) {
                CCSessionModel *sm = __self.request(tv.pageIndex);
                if (!sm) {
                    [__self.tableView.mj_header endRefreshing];
                }
                return sm;
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
    [self refreshData];
}

// 重新拉取第一页的数据
- (void)refreshData {
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

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [UGPostCell1 heightWithModel:tableView.dataArray[indexPath.row]];
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableView.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGPostCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.pm = tableView.dataArray[indexPath.row];
    // 去评论
    __weakSelf_(__self);
    cell.didCommentBtnClick = ^(UGLHPostModel *pm) {
        [__self goToPostDetailVC:indexPath willComment:true];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self goToPostDetailVC:indexPath willComment:false];
}

@end
