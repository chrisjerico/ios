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

@end

@implementation UGDocumentListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // TableView
    UGLHCategoryListModel *clm = _clm;
    {
        UITableView *tv = _tableView;
        tv.noDataTipsLabel.text = @"还没有人评论此帖子";
        [tv setupHeaderRefreshRequest:^CCSessionModel *(UITableView *tv) {
            return [NetworkManager1 lhdoc_contentList:clm.alias uid:nil sort:nil page:1];
        } completion:^NSArray *(UITableView *tv, CCSessionModel *sm) {
            NSArray *array = sm.responseObject[@"data"][@"list"];
            for (NSDictionary *dict in array) {
                [tv.dataArray addObject:[UGLHPostModel mj_objectWithKeyValues:dict]];
            }
            return array;
        }];
        [tv.mj_header beginRefreshing];
    }
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
        UGPostDetailVC *vc = _LoadVC_from_storyboard_(@"UGPostDetailVC");
        vc.pm = pm;
        vc.title = pm.title;
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
