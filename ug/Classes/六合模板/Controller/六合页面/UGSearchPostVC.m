//
//  UGSearchPostVC.m
//  ug
//
//  Created by fish on 2019/10/27.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGSearchPostVC.h"
#import "UGPostDetailVC.h"

#import "UGPostCell1.h"


@interface UGSearchPostVC ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSString *searchKey;
@end

@implementation UGSearchPostVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // TableView
    {
        __weakSelf_(__self);
        UITableView *tv = _tableView;
        [tv setupHeaderRefreshRequest:^CCSessionModel *(UITableView *tv) {
            if (!__self.searchKey.length) {
                [__self.tableView.mj_header endRefreshing];
                return nil;
            }
            return [NetworkManager1 lhcdoc_searchContent:__self.clm.alias content:__self.searchKey page:1];
        } completion:^NSArray *(UITableView *tv, CCSessionModel *sm) {
            NSArray *array = sm.responseObject[@"data"][@"list"];
            for (NSDictionary *dict in array)
                [tv.dataArray addObject:[UGLHPostModel mj_objectWithKeyValues:dict]];
            
            if (OBJOnceToken(__self)) {
                [tv setupFooterRefreshRequest:^CCSessionModel *(UITableView *tv) {
                    return [NetworkManager1 lhcdoc_searchContent:__self.clm.alias content:__self.searchKey page:tv.pageIndex];
                } completion:^NSArray *(UITableView *tv, CCSessionModel *sm) {
                    NSArray *array = sm.responseObject[@"data"][@"list"];
                    for (NSDictionary *dict in array)
                        [tv.dataArray addObject:[UGLHPostModel mj_objectWithKeyValues:dict]];
                    return array;
                }];
            }
            return array;
        }];
    }
}

- (IBAction)onSearchBtnClick:(UIButton *)sender {
    if (![_textField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length) {
        [HUDHelper showMsg:@"搜索内容不能为空"];
        return;
    }
    [_textField resignFirstResponder];
    _searchKey = _textField.text;
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
