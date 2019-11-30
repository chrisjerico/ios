//
//  UGPostDetailVC.m
//  ug
//
//  Created by fish on 2019/10/27.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGPostDetailVC.h"
#import "LHPostCommentDetailVC.h"// 评论详情

#import "MediaViewer.h"
#import "UGPostCell1.h"
#import "LoadingStateView.h"

@interface UGPostDetailVC ()
@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;/**<   图片列表 */
@property (weak, nonatomic) IBOutlet UICollectionView *animalCollectionView;/**<   生肖列表（可投票） */
@property (weak, nonatomic) IBOutlet UITableView *tableView;    /**<    评论TableView */
@property (weak, nonatomic) IBOutlet UIView *topView;           /**<   顶部作者信息 */
@property (weak, nonatomic) IBOutlet UIView *bottomBarView;     /**<    底部菜单栏（评论、点赞） */

@property (nonatomic, copy) NSString *opCustomerId; /**<    被回复者ID */
@property (nonatomic, copy) NSString *opCommentId;  /**<    被回复的评论ID（有值表示回复评论，没值表示评论动态） */
@property (nonatomic, copy) NSMutableDictionary *textBuffer;
@end

@implementation UGPostDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _textBuffer = [@{} mutableCopy];
    self.view.clipsToBounds = true;
    self.title = @"帖子详情";
    
    __weakSelf_(__self);
    // 自适应高度
    {
        [__self.tableView.tableHeaderView.subviews.firstObject xw_addObserverBlockForKeyPath:@"contentSize" block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
            __self.tableView.tableHeaderView.height = [newVal CGSizeValue].height;
        }];
        [_photoCollectionView xw_addObserverBlockForKeyPath:@"contentSize" block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
            ((UIScrollView *)obj).cc_constraints.height.constant = [newVal CGSizeValue].height + 4;
            [__self.tableView reloadData];
        }];
    }
    
    LoadingStateView *lsv = [LoadingStateView showWithSuperview:self.view state:ZJLoadingStateLoading];
    lsv.offsetY = NavController1.navigationBar.by;
    lsv.didRefreshBtnClick = ^{
        // 获取帖子详情
        [NetworkManager1 lhdoc_contentDetail:__self.pm.cid].completionBlock = ^(CCSessionModel *sm) {
            if (sm.error) {
                [LoadingStateView showWithSuperview:__self.view state:ZJLoadingStateFail];
            } else {
                [LoadingStateView showWithSuperview:__self.view state:ZJLoadingStateSucc];
                [__self setupSSV];
            }
        };
    };
    lsv.didRefreshBtnClick();
    
    
    // 获取生肖列表
    // 。。。
}

- (void)setupSSV {
    UGLHPostModel *pm = _pm;
    
    __weakSelf_(__self);
    FastSubViewCode(self.view);
    
    
    // TopView
    {
        FastSubViewCode(_topView);
        [subImageView(@"头像ImageView") sd_setImageWithURL:[NSURL URLWithString:pm.headImg]];
        subLabel(@"昵称Label").text = pm.nickname;
        subLabel(@"时间Label").text = pm.createTime;
    }
    
    // TableHeaderView
    {
        FastSubViewCode(_tableView.tableHeaderView);
        subImageView(@"顶部广告ImageView").hidden = !pm.topAdWap.length;
        subImageView(@"底部广告ImageView").hidden = !pm.bottomAdWap.length;
        [subImageView(@"顶部广告ImageView") sd_setImageWithURL:[NSURL URLWithString:pm.topAdWap]];
        [subImageView(@"底部广告ImageView") sd_setImageWithURL:[NSURL URLWithString:pm.bottomAdWap]];
        subLabel(@"标题Label").text = pm.title;
        subLabel(@"内容Label").text = pm.content;
        subLabel(@"时间Label").text = _NSString(@"最后更新时间：%@", pm.createTime);
//        _animalCollectionView.hidden = pm.
//        subLabel(@"").text = pm.;
//        subLabel(@"").text = pm.;
    }
    
    // 评论
    {
        UITableView *tv = _tableView;
        tv.noDataTipsLabel.text = @"还没有人评论此帖子";
        [tv setupHeaderRefreshRequest:^CCSessionModel *(UITableView *tv) {
            return [NetworkManager1 lhdoc_contentReplyList:pm.cid replyPid:nil page:1];
        } completion:^NSArray *(UITableView *tv, CCSessionModel *sm) {
            NSArray *array = sm.responseObject[@"data"][@"list"];
            for (NSDictionary *dict in array) {
                UGLHPostCommentModel *pcm = [UGLHPostCommentModel mj_objectWithKeyValues:dict];
                pcm.cid = __self.pm.cid;
                [tv.dataArray addObject:pcm];
            }
            return array;
        }];
        [tv setupFooterRefreshRequest:^CCSessionModel *(UITableView *tv) {
            return [NetworkManager1 lhdoc_contentReplyList:pm.cid replyPid:nil page:tv.pageIndex];
        } completion:^NSArray *(UITableView *tv, CCSessionModel *sm) {
            NSArray *array = sm.responseObject[@"data"][@"list"];
            for (NSDictionary *dict in array) {
                UGLHPostCommentModel *pcm = [UGLHPostCommentModel mj_objectWithKeyValues:dict];
                pcm.cid = __self.pm.cid;
                [tv.dataArray addObject:pcm];
            }
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

// 关注
- (IBAction)onFollowBtnClick:(UIButton *)sender {
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

// 评论
- (IBAction)onCommentBtnClick:(UIButton *)sender {
    if (!UGLoginIsAuthorized()) {
        SANotificationEventPost(UGNotificationShowLoginView, nil);
        return;
    }
    
//    __weakSelf_(__self);
//    [LHPostCommentInputView show1:_pm].didComment = ^(NSString * _Nonnull text) {
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

// 喜欢
- (IBAction)onFavBtnClick:(UIButton *)sender {
}


#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
        [subButton(@"昵称Button") setTitle:pcm.nickname forState:UIControlStateNormal];
        subButton(@"点赞图标Button").selected = pcm.isLike;
        subLabel(@"点赞次数Label").text = @(pcm.likeNum).stringValue;
        subLabel(@"点赞次数Label").textColor = pcm.isLike ? Skin1.navBarBgColor : APP.TextColor3;
        subLabel(@"评论内容Label").text = pcm.content;
        subLabel(@"评论时间Label").text = pcm.actionTime;
        [subButton(@"回复评论Button") setTitle:_NSString(@"%d 回复", (int)pcm.replyCount) forState:UIControlStateNormal];
    }
    
    // Action
    {
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
            LHPostCommentDetailVC *vc = _LoadVC_from_storyboard_(@"LHPostCommentDetailVC");
            vc.pcm = pcm;
            [NavController1 pushViewController:vc animated:true];
        }];
    }
    return cell;
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == _photoCollectionView) {
        return _pm.contentPic.count;
    }
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _photoCollectionView) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        UIImageView *imgView = [cell viewWithTagString:@"图片ImageView"];
        CGFloat collectionViewW = APP.Width-40;
        imgView.cc_constraints.width.constant = collectionViewW;
        NSURL *url = [NSURL URLWithString:_pm.contentPic[indexPath.item]];
        UIImage *image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:[[SDWebImageManager sharedManager] cacheKeyForURL:url]];
        if (image) {
            imgView.cc_constraints.height.constant = collectionViewW/image.width * image.height;
            [imgView sd_setImageWithURL:url];   // 由于要支持gif动图，还是用sd加载
        } else {
            [imgView sd_setImageWithURL:url completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                imgView.cc_constraints.height.constant = collectionViewW/image.width * image.height;
            }];
        }
        return cell;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UIImageView *imgView = [[collectionView cellForItemAtIndexPath:indexPath] viewWithTagString:@"图片ImageView"];
    UGLHPostModel *pm = _pm;
    
    void (^showMediaViewer)(NSArray <MediaModel *>*) = ^(NSArray *models) {
        MediaViewer *vpView = _LoadView_from_nib_(@"MediaViewer");
        vpView.frame = APP.Bounds;
        vpView.models = models;
        vpView.index = indexPath.item;
        [TabBarController1.view addSubview:vpView];
        
        {
            // 入场动画
            CGRect rect = [imgView convertRect:imgView.bounds toView:APP.Window];
            [vpView showEnterAnimations:rect image:imgView.image];
            
            // 退场动画
            vpView.exitAnimationsBlock = ^CGRect (MediaViewer *mv) {
                UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:mv.index inSection:0]];
                UIImageView *imgV = [cell viewWithTagString:@"图片ImageView"];
                return [imgV convertRect:imgV.bounds toView:APP.Window];
            };
        }
    };
    
    // 初始化 MediaModel
    showMediaViewer(({
        NSMutableArray <MediaModel *>*models = @[].mutableCopy;
        for (NSString *pic in pm.contentPic) {
            MediaModel *mm = [MediaModel new];
            mm.imgUrl = [NSURL URLWithString:pic];
            [models addObject:mm];
        }
        models;
    }));
}

@end
