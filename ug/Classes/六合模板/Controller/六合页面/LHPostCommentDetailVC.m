//
//  LHPostCommentDetailVC.m
//  ug
//
//  Created by fish on 2019/11/29.
//  Copyright © 2019 ug. All rights reserved.
//

#import "LHPostCommentDetailVC.h"

#import "LHPostCommentInputView.h"


@interface LHPostCommentDetailVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LHPostCommentDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weakSelf_(__self);
    // 初始化UI
    {
        UGLHPostCommentModel *pcm = _pcm;
        UITableView *tv = _tableView;
        
        // TableHeaderView
        {
            tv.tableHeaderView.height = ({
                CGFloat textH = ({
                    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:pcm.content ? : @" " attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]}];
                    string.lineSpacing = 4;
                    [string boundingRectWithSize:CGSizeMake(APP.Width-10-40-11-11, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.height;
                });
                10 + 40 + textH + 39;
            });

            FastSubViewCode(tv.tableHeaderView);
            [subButton(@"头像Button") sd_setImageWithURL:[NSURL URLWithString:pcm.headImg] forState:UIControlStateNormal];
            [subButton(@"昵称Button") setTitle:pcm.nickname forState:UIControlStateNormal];
            subButton(@"点赞图标Button").selected = pcm.isLike;
            subLabel(@"点赞次数Label").text = pcm.likeNum ? @(pcm.likeNum).stringValue : @"";
            subLabel(@"评价内容Label").text = pcm.content;
            subLabel(@"评论时间Label").text = pcm.actionTime;
        }
        
        // 初始化TableView 及下拉刷新事件
        {
            tv.footerView = ({
                UIView *v = [UIView new];
                v.backgroundColor = [UIColor clearColor];
                v.height = APP.BottomSafeHeight;
                v;
            });
            [_tableView setupFooterRefreshRequest:^CCSessionModel *(UITableView *tv) {
                return [NetworkManager1 lhdoc_contentReplyList:__self.pcm.cid replyPid:__self.pcm.pid page:tv.pageIndex];
            } completion:^NSArray *(UITableView *tv, CCSessionModel *sm) {
                NSArray *array = sm.responseObject[@"data"][@"list"];
                for (NSDictionary *dict in array)
                    [tv.dataArray addObject:[UGLHPostCommentModel mj_objectWithKeyValues:dict]];
                
                tv.noDataTipsLabel.text = @"此动态还没有评论";
                return array;
            }];
            [_tableView.mj_footer beginRefreshing];
        }
    }
}


#pragma mark - IBAction

// 点赞评论
- (IBAction)onLikeBtnClick:(UIButton *)sender {
    if (!UGLoginIsAuthorized()) {
        [NavController1 pushViewController:_LoadVC_from_storyboard_(@"LoginVC") animated:true];
        return ;
    }
    __weakSelf_(__self);
    UGLHPostCommentModel *pcm = _pcm;
    FastSubViewCode(_tableView.tableHeaderView);
    BOOL like = !subButton(@"点赞图标Button").selected;
    [NetworkManager1 lhcdoc_likePost:pcm.pid type:2 likeFlag:like].completionBlock = ^(CCSessionModel *sm) {
        if (!sm.error) {
            pcm.likeNum += like ? 1 : -1;
            pcm.isLike = like;
            subButton(@"点赞图标Button").selected = like;
            subLabel(@"点赞次数Label").text = pcm.likeNum ? @(pcm.likeNum).stringValue : @"";
            subLabel(@"点赞次数Label").textColor = like ? Skin1.navBarBgColor : Skin1.textColor2;
            if (__self.didLike)
                __self.didLike(pcm);
        }
    };
}

// 切换为回复评论模式
- (IBAction)onHeaderViewBtnClick:(UIButton *)sender {
    [LHPostCommentInputView show2:_pcm];
}


#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGLHPostCommentModel *pcrm = tableView.dataArray[indexPath.row];
    CGFloat textH = [pcrm.content heightForFont:[UIFont systemFontOfSize:14] width:APP.Width - 70];
    return 43 + textH + 37;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableView.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"回复Cell" forIndexPath:indexPath];
    UGLHPostCommentModel *pcrm = tableView.dataArray[indexPath.row];
    FastSubViewCode(cell);
    [subButton(@"头像Button") sd_setImageWithURL:[NSURL URLWithString:pcrm.headImg] forState:UIControlStateNormal];
    [subButton(@"昵称Button") setTitle:pcrm.nickname forState:UIControlStateNormal];
    subButton(@"点赞图标Button").selected = pcrm.isLike;
    subLabel(@"点赞次数Label").text = @(pcrm.likeNum).stringValue;
    subLabel(@"点赞次数Label").textColor = pcrm.isLike ? APP.ThemeColor1 : APP.TextColor3;
    subLabel(@"时间Label").text = pcrm.actionTime;
    subLabel(@"内容Label").text = pcrm.content;
    return cell;
}

@end
