//
//  UGDocumentListVC.m
//  ug
//
//  Created by fish on 2019/10/27.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGDocumentListVC.h"
#import "UGPostDetailVC.h"

#import "LHPostPayView.h"

#import "UGLHPostModel.h"

@interface UGDocumentListVC ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic)UGPostDetailVC *postvc;

@end

@implementation UGDocumentListVC

- (BOOL)允许游客访问 { return true; }
- (BOOL)允许未登录访问 { return true; }

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _clm.name;
    
    // TableView
    UGLHCategoryListModel *clm = _clm;
    {
        UITableView *tv = _tableView;
        [tv setupFooterRefreshRequest:^CCSessionModel *(UITableView *tv) {
            return [NetworkManager1 lhdoc_contentList:clm.alias uid:nil sort:nil page:tv.pageIndex];
        } completion:^NSArray *(UITableView *tv, CCSessionModel *sm) {
            NSArray *array = sm.responseObject[@"data"][@"list"];
            for (NSDictionary *dict in array) {
                [tv.dataArray addObject:[UGLHPostModel mj_objectWithKeyValues:dict]];
            }
            return array;
        }];
        [tv.mj_footer beginRefreshing];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_tableView reloadData];
}


#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableView.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    FastSubViewCode(cell);
    UGLHPostModel *pm = tableView.dataArray[indexPath.row];
    ((UILabel *)[cell viewWithTagString:@"标题Label"]).text = _NSString(@"%@期:%@", pm.periods, pm.title);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UGLHPostModel *pm = _tableView.dataArray[indexPath.row];
    
    __weakSelf_(__self);
    void (^push)(void) = ^{
        __self.postvc =  _LoadVC_from_storyboard_(@"UGPostDetailVC");

        __self.postvc .pm = pm;
        __self.postvc .title = pm.title;
        __self.postvc .didCommentOrLike = ^(UGLHPostModel *pm) {
            [__self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
        };
        [NavController1 pushViewController:__self.postvc  animated:true];
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
            [NetworkManager1 lhcdoc_buyContent:pm.cid].completionBlock = ^(CCSessionModel *sm) {
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

@end
