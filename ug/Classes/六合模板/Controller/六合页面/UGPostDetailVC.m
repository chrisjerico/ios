//
//  UGPostDetailVC.m
//  ug
//
//  Created by fish on 2019/10/27.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGPostDetailVC.h"
#import "LHPostCommentDetailVC.h"// 评论详情

#import "UGPostCell1.h"

#import "UGLHPostCommentModel.h"

@interface UGPostDetailVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableViewHeader;  /**<    顶部TableView */
@property (weak, nonatomic) IBOutlet UITableView *tableView;       /**<    评论TableView */
@property (weak, nonatomic) IBOutlet UIView *bottomBarView;         /**<    底部菜单栏（评论、点赞） */

@property (nonatomic, copy) NSString *opCustomerId; /**<    被回复者ID */
@property (nonatomic, copy) NSString *opCommentId;  /**<    被回复的评论ID（有值表示回复评论，没值表示评论动态） */
@property (nonatomic, copy) NSMutableDictionary *textBuffer;
@end

@implementation UGPostDetailVC


- (void)viewDidLoad {
    [super viewDidLoad];
    _textBuffer = [@{} mutableCopy];
    self.view.clipsToBounds = true;
    
    [self setupSSV];
}

- (void)setupSSV {
    UGLHPostModel *pm = _pm;
    
    __weakSelf_(__self);
    FastSubViewCode(self.view);
    
    // headerViewHeight
    CGFloat headerViewHeight = [UGPostCell1 heightWithModel:pm];
    
    
    // 评论
    {
        UITableView *tv = _tableView;
        tv.tableHeaderView.height = headerViewHeight + 44;
        tv.noDataTipsLabel.text = @"还没有人评论此帖子";
        [tv setupHeaderRefreshRequest:^CCSessionModel *(UITableView *tv) {
            return [NetworkManager1 lhdoc_contentReplyList:pm.cid replyPid:nil page:1];
        } completion:^NSArray *(UITableView *tv, CCSessionModel *sm) {
            NSArray *array = sm.responseObject[@"data"];
            for (NSDictionary *dict in array)
                [tv.dataArray addObject:[UGLHPostCommentModel mj_objectWithKeyValues:dict]];
            return array;
        }];
        [tv setupFooterRefreshRequest:^CCSessionModel *(UITableView *tv) {
            return [NetworkManager1 lhdoc_contentReplyList:pm.cid replyPid:nil page:tv.pageIndex];
        } completion:^NSArray *(UITableView *tv, CCSessionModel *sm) {
            NSArray *array = sm.responseObject[@"data"];
            for (NSDictionary *dict in array)
                [tv.dataArray addObject:[UGLHPostCommentModel mj_objectWithKeyValues:dict]];
            return array;
        }];
        [(MJRefreshAutoNormalFooter *)tv.mj_footer setTitle:@"" forState:MJRefreshStateNoMoreData];
        [tv.mj_footer beginRefreshing];
    }
    
    
    // SlideSegmentView2 布局
    {
        // 菜单栏
        UIButton *bottomLikeBtn = [_bottomBarView viewWithTagString:@"点赞图标Button"];
        UILabel *bottomLikeLabel = [_bottomBarView viewWithTagString:@"点赞Label"];
        bottomLikeBtn.selected = __self.pm.isLike;
        bottomLikeLabel.text = __self.pm.isLike ? @"已点赞" : @"点赞";
        bottomLikeLabel.textColor = __self.pm.isLike ? APP.ThemeColor1 : [UIColor blackColor];
    }
}


#pragma mark - IBAction

// 评论
- (IBAction)onCommentBtnClick:(UIButton *)sender {
    if (!UGLoginIsAuthorized()) {
        SANotificationEventPost(UGNotificationShowLoginView, nil);
        return;
    }
    
//    __weakSelf_(__self);
//    [ActionCommentInputView show1:_pm].didComment = ^(NSString * _Nonnull text) {
//        __self.tableView1.willClearDataArray = true;
//        if (__self.tableView1.mj_footer.refreshingBlock) {
//            __self.tableView1.mj_footer.refreshingBlock();
//        }
//        __self.pm.commentCnt += 1;
//
//        [__self.ssv2.titleBar reloadData];
//        if (__self.didCommentOrLike)
//            __self.didCommentOrLike(__self.pm);
//
//        [__self.ssv2.titleBar reloadData];
//    };
}

// 点赞
- (IBAction)onLikeBtnClick:(UIButton *)sender {
    if (!UGLoginIsAuthorized()) {
        SANotificationEventPost(UGNotificationShowLoginView, nil);
        return;
    }
    UIButton *bottomLikeBtn = [sender.superview viewWithTagString:@"点赞图标Button"];
    UILabel *bottomLikeLabel = [sender.superview viewWithTagString:@"点赞Label"];
    BOOL like = !bottomLikeBtn.selected;
    
//    __weakSelf_(__self);
//    [NetworkManager1 isLikeAction:__self.pm.actionId like:like].successBlock = ^(id responseObject) {
//        __self.pm.isLike = like;
//        __self.pm.likeNum += like ? 1 : -1;
//        bottomLikeBtn.selected = like;
//        bottomLikeLabel.text = like ? @"已点赞" : @"点赞";
//        bottomLikeLabel.textColor = like ? APP.ThemeColor1 : APP.BlackColor;
//        [__self.ssv2.titleBar reloadData];
//
//        if (__self.didCommentOrLike)
//            __self.didCommentOrLike(__self.pm);
//
//        __self.tableView2.willClearDataArray = true;
//        [__self.tableView2.mj_footer beginRefreshing];
//
//        [__self.ssv2.titleBar reloadData];
//    };
}


#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGLHPostCommentModel *pcm = tableView.dataArray[indexPath.row];
    CGFloat textH = ({
        textH = 0;
        if (pcm.content.length) {
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:pcm.content attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
            string.lineSpacing = 6;
            textH = [string boundingRectWithSize:CGSizeMake(APP.Width-50-10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.height;
        }
        textH;
    });
    CGFloat h = 15 + 30 + textH + 44;
    return h;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _tableViewHeader)
        return 1;
    return tableView.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    FastSubViewCode(cell);
    UGLHPostCommentModel *pcm = tableView.dataArray[indexPath.row];
    __weakSelf_(__self);
    
    // RefreshUI
    {
        [subButton(@"头像Button") sd_setImageWithURL:[NSURL URLWithString:pcm.headImg] forState:UIControlStateNormal];
//        [subButton(@"昵称Button") setTitle:pcm.nickname forState:UIControlStateNormal];
        subButton(@"点赞图标Button").selected = pcm.isLike;
        subLabel(@"点赞次数Label").text = @(pcm.likeNum).stringValue;
        subLabel(@"点赞次数Label").textColor = pcm.isLike ? APP.ThemeColor1 : APP.TextColor3;
        subLabel(@"评论内容Label").text = pcm.content;
        subLabel(@"评论时间Label").text = pcm.actionTime;
    }
    
    // Action
    {
        [subButton(@"头像Button") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
        [subButton(@"头像Button") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
//            UserInfoVC *vc = _LoadVC_from_storyboard_(@"UserInfoVC");
//            vc.customerId = pcm.customerId;
//            [NavController1 pushViewController:vc animated:true];
        }];
        [subButton(@"点赞事件Button") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
        [subButton(@"点赞事件Button") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
            if (!UGLoginIsAuthorized()) {
                SANotificationEventPost(UGNotificationShowLoginView, nil);
                return ;
            }
            BOOL like = !subButton(@"点赞图标Button").selected;
//            [NetworkManager1 isLikeActionComment:pcm.commentId like:like].completionBlock = ^(CCSessionModel *sm) {
//                if (!sm.error) {
//                    pcm.likeNum += like ? 1 : -1;
//                    pcm.isLike = like;
//                    subButton(@"点赞图标Button").selected = like;
//                    subLabel(@"点赞次数Label").text = @(pcm.likeNum).stringValue;
//                    subLabel(@"点赞次数Label").textColor = like ? APP.ThemeColor1 : APP.TextColor3;
//                } else if (sm.error.code == -2) { // 已点赞
//                    sm.noShowErrorHUD = true;
//                    pcm.isLike = like;
//                    subButton(@"点赞图标Button").selected = like;
//                    subLabel(@"点赞次数Label").textColor = like ? APP.ThemeColor1 : APP.TextColor3;
//                }
//            };
        }];
        [subButton(@"回复评论Button") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
        [subButton(@"回复评论Button") addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
            
        }];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
