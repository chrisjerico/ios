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
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, strong)   UGPostDetailVC *postvc;                                   /**<   帖子 */
                                     /**<   拖动的View */
@end

@implementation UGPostListVC

- (BOOL)允许游客访问   {
    if ([self.clm.read_pri isEqualToString:@"1"]) {//0是全部  1是正式会员
        return false;
    } else {
        return true;
    }
}
- (BOOL)允许未登录访问 {
    if ([self.clm.read_pri isEqualToString:@"1"]) {
        return false;
    } else {
        return true;
    }
}

//- (BOOL)允许游客访问 { return true; }
//- (BOOL)允许未登录访问 { return true; }

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weakSelf_(__self);
    // 顶部UI
    if (_request) {
        _segmentedControl.superview.hidden = true;
        _submitBtn.hidden = true;
    } else {
        self.title = _clm.name;
        self.navigationItem.rightBarButtonItems = @[
            [STBarButtonItem barButtonItemWithImageName:@"search" block:^(UIButton *sender) {
                UGSearchPostVC *vc = _LoadVC_from_storyboard_(@"UGSearchPostVC");
                vc.clm = __self.clm;
                [NavController1 pushViewController:vc animated:true];
            }],
            [STBarButtonItem barButtonItemWithImageName:@"yijian" block:^(UIButton *sender) {
                [__self onSubmitBtnClick:nil];
            }],
        ];
        
        _submitBtn.layer.shadowColor = UIColorHex(7B6EF3).CGColor;
        _submitBtn.layer.shadowOffset = CGSizeMake(0, 1);
        _submitBtn.layer.shadowRadius = 3;
        _submitBtn.layer.shadowOpacity = 1;
    }
    
    // TableView
    {
        UITableView *tv = _tableView;
        {
            tv.noDataTipsLabel.text = @"";
            tv.noDataTipsLabel.height = 270;
            [tv.noDataTipsLabel addSubview:({
                UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pl"]];
                imgView.center = CGPointMake(APP.Width/2, 140);
                imgView;
            })];
            [tv.noDataTipsLabel addSubview:({
                UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 250, APP.Width, 20)];
                lb.textAlignment = NSTextAlignmentCenter;
                lb.font = [UIFont systemFontOfSize:14];
                lb.textColor = APP.TextColor2;
                lb.text = @"暂无数据！";
                lb;
            })];
        }
        NSString *(^sortString)(void) = ^NSString *{
            if (__self.segmentedControl.selectedSegmentIndex == 1) {
                return @"hot";  // 热门（精华贴）
            } else if (__self.segmentedControl.selectedSegmentIndex == 2) {
                return @"new";  // 最新
            }
            return nil; // 综合
        };
        [tv setupHeaderRefreshRequest:^CCSessionModel *(UITableView *tv) {
            if (__self.request) {
                CCSessionModel *sm = __self.request(1);
                if (!sm) {
                    [tv.mj_header endRefreshing];
                    tv.tableFooterView = tv.noDataTipsLabel;
                    tv.mj_footer.state = MJRefreshStateNoMoreData;
                    [(MJRefreshAutoNormalFooter *)tv.mj_footer setTitle:@"" forState:MJRefreshStateNoMoreData];
                }
                return sm;
            } else {
                return [NetworkManager1 lhdoc_contentList:__self.clm.alias uid:nil sort:sortString() page:1];
            }
        } completion:^NSArray *(UITableView *tv, CCSessionModel *sm) {
            
            NSArray *array = sm.resObject[@"data"][@"list"];
            NSString *baomaId = sm.resObject[@"data"][@"baomaId"];
            NSString *baomaType = sm.resObject[@"data"][@"baomaType"];
            
            for (NSDictionary *dict in array){
                UGLHPostModel *obj = [UGLHPostModel mj_objectWithKeyValues:dict];
                obj.baomaId = baomaId;
                obj.baomaType = baomaType;
                [tv.dataArray addObject:obj];
            }
            return array;
        }];
        [tv setupFooterRefreshRequest:^CCSessionModel *(UITableView *tv) {
            if (__self.request) {
                CCSessionModel *sm = __self.request(tv.pageIndex);
                if (!sm) {
                    tv.tableFooterView = tv.noDataTipsLabel;
                    tv.mj_footer.state = MJRefreshStateNoMoreData;
                    [(MJRefreshAutoNormalFooter *)tv.mj_footer setTitle:@"" forState:MJRefreshStateNoMoreData];
                }
                return sm;
            } else {
                return [NetworkManager1 lhdoc_contentList:__self.clm.alias uid:nil sort:sortString() page:tv.pageIndex];
            }
        } completion:^NSArray *(UITableView *tv, CCSessionModel *sm) {
            NSArray *array = sm.resObject[@"data"][@"list"];
            NSString *baomaId = sm.resObject[@"data"][@"baomaId"];
            NSString *baomaType = sm.resObject[@"data"][@"baomaType"];
            
            for (NSDictionary *dict in array){
                UGLHPostModel *obj = [UGLHPostModel mj_objectWithKeyValues:dict];
                obj.baomaId = baomaId;
                obj.baomaType = baomaType;
                [tv.dataArray addObject:obj];
            }
            return array;
        }];
        [tv.mj_footer beginRefreshing];
    }
    

}

- (IBAction)onSegmentedControlValueChanged:(UISegmentedControl *)sender {
    [self refreshData];
}

- (IBAction)onSubmitBtnClick:(UIButton *)sender {
    UGSubmitPostVC *vc = _LoadVC_from_storyboard_(@"UGSubmitPostVC");
    vc.clm = _clm;
    [NavController1 pushViewController:vc animated:true];
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
    pm.link = _clm.link;
    pm.baomaType = _clm.baomaType;
    pm.read_pri = _clm.read_pri;
    __weakSelf_(__self);
    void (^push)(void) = ^{
        self.postvc = _LoadVC_from_storyboard_(@"UGPostDetailVC");

        self.postvc.pm = pm;
        self.postvc.willComment = willComment;
        self.postvc.didCommentOrLike = ^(UGLHPostModel *pm) {
            [__self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
        };
        [NavController1 pushViewController:self.postvc animated:true];
    };
    
    if (!pm.hasPay && pm.price > 0.000001) {
        LHPostPayView *ppv = _LoadView_from_nib_(@"LHPostPayView");
        ppv.pm = pm;
        ppv.didConfirmBtnClick = ^(LHPostPayView * _Nonnull ppv) {
            if (!UGLoginIsAuthorized()) {
                [ppv hide:nil];
                SANotificationEventPost(UGNotificationShowLoginView, nil);
                return;
            }
            [NetworkManager1 lhcdoc_buyContent:pm.cid].completionBlock = ^(CCSessionModel *sm, id resObject, NSError *err) {
                if (!sm.error) {
                    pm.hasPay = true;
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
