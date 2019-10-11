//
//  UITableView+Refresh.m
//  C
//
//  Created by fish on 2018/3/15.
//  Copyright © 2018年 fish. All rights reserved.
//

#import "UITableView+Refresh.h"
#import "cc_runtime_property.h"
#import "MJRefresh.h"

@implementation UITableView (RefreshRequest)

_CCRuntimeProperty_Assign(NSInteger, willClearDataArray, setWillClearDataArray)
_CCRuntimeProperty_Retain(UIView *, footerView, setFooterView)
_CCRuntimeProperty_Readonly(NSMutableArray *, dataArray, [NSMutableArray array])
_CCRuntimeProperty_Readonly(UILabel *, noDataTipsLabel, {
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 100)];
    lb.textAlignment = NSTextAlignmentCenter;
    lb.text = @"暂无记录";
    lb.font = [UIFont systemFontOfSize:14];
    lb.textColor = APP.TextColor3;
    lb.numberOfLines = 0;
    lb;
})

- (NSInteger)pageIndex {
    return (self.willClearDataArray > 0 ? 0 : self.dataArray.count/APP.PageCount) + 1;
}

- (void)setupHeaderRefreshRequest:(CCSessionModel *(^)(UITableView *))request completion:(NSArray *(^)(UITableView *, CCSessionModel *))completion {
    __weakSelf_(__self);
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        CCSessionModel *sm = self.cc_userInfo[@"HeaderReuqest"] = request(__self);
        sm.completionBlock = ^(CCSessionModel *sm) {
            if (sm != __self.cc_userInfo[@"HeaderReuqest"]) {
                sm.noShowErrorHUD = true;
                return ;
            }
            UITableView *tv = __self;
            [tv.mj_header endRefreshing];
            
            if (!sm.error) {
                [tv.dataArray removeAllObjects];
                tv.mj_footer.state = MJRefreshStateIdle;
            }
            if (completion) {
                if (completion(tv, sm).count < APP.PageCount && !sm.error)
                    tv.mj_footer.state = MJRefreshStateNoMoreData;
            }
            if (!sm.error) {
                tv.tableFooterView = tv.dataArray.count ? (tv.footerView ? : [UIView new]) : tv.noDataTipsLabel;
                [(MJRefreshAutoNormalFooter *)tv.mj_footer setTitle:(tv.dataArray.count ? @"已经全部加载完毕" : @"") forState:MJRefreshStateNoMoreData];
                [tv reloadData];
            }
        };
    }];
}

- (void)setupFooterRefreshRequest:(CCSessionModel *(^)(UITableView *))request completion:(NSArray *(^)(UITableView *, CCSessionModel *))completion {
    __weakSelf_(__self);
    self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        CCSessionModel *sm = self.cc_userInfo[@"FooterReuqest"] = request(__self);
        sm.completionBlock = ^(CCSessionModel *sm) {
            if (sm != __self.cc_userInfo[@"FooterReuqest"]) {
                sm.noShowErrorHUD = true;
                return ;
            }
            UITableView *tv = __self;
            tv.mj_footer.state = MJRefreshStateIdle;
            
            if (tv.willClearDataArray > 0) {
                tv.willClearDataArray -= 1;
                [tv.dataArray removeAllObjects];
            }
            if (completion) {
                if (completion(tv, sm).count < APP.PageCount && !sm.error)
                    tv.mj_footer.state = MJRefreshStateNoMoreData;
            }
            if (!sm.error) {
                tv.tableFooterView = tv.dataArray.count ? (tv.footerView ? : [UIView new]) : tv.noDataTipsLabel;
                [(MJRefreshAutoNormalFooter *)tv.mj_footer setTitle:(tv.dataArray.count ? @"已经全部加载完毕" : @"") forState:MJRefreshStateNoMoreData];
                [tv reloadData];
            }
        };
    }];
    ((MJRefreshAutoNormalFooter *)self.mj_footer).stateLabel.textColor = APP.TextColor2;
}

@end
