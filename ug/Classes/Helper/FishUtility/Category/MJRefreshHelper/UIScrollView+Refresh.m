//
//  UITableView+Refresh.m
//  C
//
//  Created by fish on 2018/3/15.
//  Copyright © 2018年 fish. All rights reserved.
//

#import "UIScrollView+Refresh.h"
#import "cc_runtime_property.h"
#import "MJRefresh.h"

@implementation UIScrollView (RefreshRequest)

_CCRuntimeProperty_Assign(NSInteger, willClearDataArray, setWillClearDataArray)
_CCRuntimeProperty_Readonly(NSMutableArray *, dataArray, [NSMutableArray array])
_CCRuntimeProperty_Readonly(UILabel *, noDataTipsLabel, {
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 100)];
    lb.textAlignment = NSTextAlignmentCenter;
    lb.text = @"暂无记录";
    lb.font = [UIFont systemFontOfSize:14];
    lb.textColor = APP.TextColor3;
    lb.numberOfLines = 0;
    lb.hidden = true;
    [self addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.centerX.equalTo(self);
        make.top.equalTo(self).priorityLow();
        make.height.mas_greaterThanOrEqualTo(100);
    }];
    lb;
})

- (NSInteger)pageIndex {
    return (self.willClearDataArray > 0 ? 0 : self.dataArray.count/APP.PageCount) + 1;
}

- (void)setupHeaderRefreshRequest:(CCSessionModel *(^)(__kindof UIScrollView *tv))request completion:(NSArray *(^)(__kindof UIScrollView *tv, CCSessionModel *sm))completion {
    __weakSelf_(__self);
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        CCSessionModel *sm = self.cc_userInfo[@"HeaderReuqest"] = request(__self);
        sm.completionBlock = ^(CCSessionModel *sm, id resObject, NSError *err) {
            if (sm != __self.cc_userInfo[@"HeaderReuqest"]) {
                sm.noShowErrorHUD = true;
                return ;
            }
            UIScrollView *sv = __self;
            [sv.mj_header endRefreshing];
            
            if (!sm.error) {
                [sv.dataArray removeAllObjects];
                sv.mj_footer.state = MJRefreshStateIdle;
            }
            if (completion) {
                if (completion(sv, sm).count < APP.PageCount && !sm.error)
                    sv.mj_footer.state = MJRefreshStateNoMoreData;
            }
            if (!sm.error) {
                if ([sv isKindOfClass:[UITableView class]]) {
                    UITableView *tv = (id)sv;
                    tv.tableFooterView = tv.tableFooterView ? : [UIView new];
                    tv.tableFooterView.userInteractionEnabled = sv.dataArray.count;
                    tv.tableFooterView.alpha = !!sv.dataArray.count;
                    [sv.noDataTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(tv.tableFooterView);
                    }];
                }
                sv.noDataTipsLabel.hidden = sv.dataArray.count;
                [(MJRefreshAutoNormalFooter *)sv.mj_footer setTitle:(sv.dataArray.count ? @"已经全部加载完毕" : @"") forState:MJRefreshStateNoMoreData];
                if ([sv respondsToSelector:@selector(reloadData)]) {
                    [(UITableView *)sv reloadData];
                }
            }
        };
    }];
}

- (void)setupFooterRefreshRequest:(CCSessionModel *(^)(__kindof UIScrollView *tv))request completion:(NSArray *(^)(__kindof UIScrollView *tv, CCSessionModel *sm))completion {
    __weakSelf_(__self);
    self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        CCSessionModel *sm = self.cc_userInfo[@"FooterReuqest"] = request(__self);
        sm.completionBlock = ^(CCSessionModel *sm, id resObject, NSError *err) {
            if (sm != __self.cc_userInfo[@"FooterReuqest"]) {
                sm.noShowErrorHUD = true;
                return ;
            }
            UIScrollView *sv = __self;
            sv.mj_footer.state = MJRefreshStateIdle;
            
            if (sv.willClearDataArray > 0) {
                sv.willClearDataArray -= 1;
                [sv.dataArray removeAllObjects];
            }
            if (completion) {
                if (completion(sv, sm).count < APP.PageCount && !sm.error)
                    sv.mj_footer.state = MJRefreshStateNoMoreData;
            }
            if (!sm.error) {
                if ([sv isKindOfClass:[UITableView class]]) {
                    UITableView *tv = (id)sv;
                    tv.tableFooterView = tv.tableFooterView ? : [UIView new];
                    tv.tableFooterView.userInteractionEnabled = sv.dataArray.count;
                    tv.tableFooterView.alpha = !!sv.dataArray.count;
                    [sv.noDataTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(tv.tableFooterView);
                    }];
                }
                sv.noDataTipsLabel.hidden = sv.dataArray.count;
                [(MJRefreshAutoNormalFooter *)sv.mj_footer setTitle:(sv.dataArray.count ? @"已经全部加载完毕" : @"") forState:MJRefreshStateNoMoreData];
                if ([sv respondsToSelector:@selector(reloadData)]) {
                    [(UITableView *)sv reloadData];
                }
            }
        };
    }];
    ((MJRefreshAutoNormalFooter *)self.mj_footer).stateLabel.textColor = APP.TextColor2;
}

@end
