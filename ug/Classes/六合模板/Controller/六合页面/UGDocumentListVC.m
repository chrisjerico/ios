//
//  UGDocumentListVC.m
//  ug
//
//  Created by fish on 2019/10/27.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGDocumentListVC.h"

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
            return [NetworkManager1 lhdoc_lhcNoList:clm.cid type2:nil];
        } completion:^NSArray *(UITableView *tv, CCSessionModel *sm) {
            NSArray *array = sm.responseObject[@"data"];
//            for (NSDictionary *dict in array) {
//                UGLHPostCommentModel *pcm = [UGLHPostCommentModel mj_objectWithKeyValues:dict];
//                pcm.cid = __self.pm.cid;
//                [tv.dataArray addObject:pcm];
//            }
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
//    UGLHPostCommentModel *pcm = tableView.dataArray[indexPath.row];
//    __weakSelf_(__self);
//
//    // RefreshUI
//    {
//        [subButton(@"头像Button") sd_setImageWithURL:[NSURL URLWithString:pcm.headImg] forState:UIControlStateNormal];
//        [subButton(@"昵称Button") setTitle:pcm.nickname forState:UIControlStateNormal];
//        subButton(@"点赞图标Button").selected = pcm.isLike;
//        subLabel(@"点赞次数Label").text = @(pcm.likeNum).stringValue;
//        subLabel(@"点赞次数Label").textColor = pcm.isLike ? Skin1.navBarBgColor : APP.TextColor3;
//        subLabel(@"评论内容Label").text = pcm.content;
//        subLabel(@"评论时间Label").text = pcm.actionTime;
//        [subButton(@"回复评论Button") setTitle:_NSString(@"%d 回复", (int)pcm.replyCount) forState:UIControlStateNormal];
//    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
