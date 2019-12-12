//
//  UGPostDetailVC.m
//  ug
//
//  Created by fish on 2019/10/27.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGPostDetailVC.h"
#import "LHPostCommentDetailVC.h"// 评论详情
#import "LHUserInfoVC.h"
#import "SLWebViewController.h"

// View
#import "MediaViewer.h"             // 图片浏览器
#import "LoadingStateView.h"        // 加载中view
#import "LHPostRewardView.h"        // 打赏弹框
#import "LHPostCommentInputView.h"  // 评论弹框
#import "LHPostVoteView.h"          // 投票弹框

// Tools
#import "YYText.h"

#define ContentWidth (APP.Width-40)


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
    _topView.hidden = true;
    
    // 自适应高度
    {
        [__self.tableView.tableHeaderView.subviews.firstObject xw_addObserverBlockForKeyPath:@"contentSize" block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
            __self.tableView.tableHeaderView.height = [newVal CGSizeValue].height;
        }];
        [_photoCollectionView xw_addObserverBlockForKeyPath:@"contentSize" block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
            ((UIScrollView *)obj).cc_constraints.height.constant = MAX([newVal CGSizeValue].height + 4, 20);
            [__self.tableView reloadData];
        }];
    }
    
    LoadingStateView *lsv = [LoadingStateView showWithSuperview:self.view state:ZJLoadingStateLoading];
    lsv.offsetY = !_topView.hidden ? NavController1.navigationBar.by : 0;
    lsv.didRefreshBtnClick = ^{
        // 获取帖子详情
        [NetworkManager1 lhdoc_contentDetail:__self.pm.cid].completionBlock = ^(CCSessionModel *sm) {
            if (sm.error) {
                [LoadingStateView showWithSuperview:__self.view state:ZJLoadingStateFail];
            } else {
                __self.pm = [UGLHPostModel mj_objectWithKeyValues:sm.responseObject[@"data"]];
                [__self setupSSV];
                [LoadingStateView showWithSuperview:__self.view state:ZJLoadingStateSucc];
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
        [subButton(@"头像Button") sd_setImageWithURL:[NSURL URLWithString:pm.headImg] forState:UIControlStateNormal];
        subLabel(@"昵称Label").text = pm.nickname;
        subLabel(@"时间Label").text = pm.createTime;
        subButton(@"关注Button").backgroundColor = Skin1.navBarBgColor;
        subButton(@"关注Button").selected = _pm.isFollow;
        [subButton(@"关注Button") setTitle:_pm.isFollow ? @"已关注" : @"关注楼主" forState:UIControlStateNormal];
        _topView.hidden = ![@"forum,gourmet" containsString:pm.alias];
    }
    
    // BottomView
    {
        FastSubViewCode(_bottomBarView);
        subLabel(@"点赞数Label").text = @(pm.likeNum).stringValue;
        subLabel(@"点赞数Label").hidden = !pm.likeNum;
        subLabel(@"评论数Label").text = @(pm.replyCount).stringValue;
        subLabel(@"评论数Label").hidden = !pm.replyCount;
        subButton(@"点赞Button").selected = pm.isLike;
        subButton(@"收藏Button").selected = pm.isFav;
    }
    
    // TableHeaderView
    {
        FastSubViewCode(_tableView.tableHeaderView);
        void (^setupAdButton)(NSString *, LHPostAdModel *) = ^(NSString *tagString, LHPostAdModel *ad) {
            subButton(tagString).hidden = [@"sixpic,humorGuess,rundog,fourUnlike" containsString:pm.alias] || !ad.isShow;
            [subButton(tagString) removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
            [subButton(tagString) addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
                if (ad.link.length) {
                    if (ad.targetType == 2) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ad.link]];
                    } else {
                        SLWebViewController *vc = [SLWebViewController new];
                        vc.urlStr = ad.link;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                }
            }];
            [subButton(tagString) sd_setImageWithURL:[NSURL URLWithString:ad.pic] forState:UIControlStateNormal completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (image) {
                    subButton(tagString).cc_constraints.height.constant = ContentWidth/image.width * image.height;
                }
            }];
        };
        setupAdButton(@"顶部广告Button", pm.topAdWap);
        setupAdButton(@"底部广告Button", pm.bottomAdWap);
        subLabel(@"标题Label").text = pm.title;
        subLabel(@"标题Label").hidden = [@"mystery,rule,sixpic,humorGuess,rundog,fourUnlike" containsString:pm.alias];
        subLabel(@"时间Label").text = _NSString(@"最后更新时间：%@", pm.createTime);
        subLabel(@"时间Label").hidden = [@"mystery,rule" containsString:pm.alias];
        UILabel *contentLabel = subLabel(@"内容Label");
        contentLabel.attributedText = ({
            UIFont *font = [UIFont systemFontOfSize:16];
            NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] initWithData:[pm.content dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,} documentAttributes:nil error:nil];
            [mas addAttributes:@{NSFontAttributeName:font} range:NSMakeRange(0, mas.length)];
            for (YYImage *image in UGLHPostModel.allEmoji) {
                NSString *key = [UGLHPostModel keyWithImage:image];
                if ([pm.content containsString:key]) {
                    NSRange range = NSMakeRange(0, mas.length);
                    NSRange r;
                    while ((r = [mas.string rangeOfString:key options:NSLiteralSearch range:range]).length) {
                        YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
                        NSAttributedString *attachText = [NSAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeCenter attachmentSize:imageView.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
                        [mas replaceCharactersInRange:r withAttributedString:attachText];
                        range.location = r.location + attachText.length;
                        range.length = mas.length - range.location;
                    }
                }
            }
            NSMutableParagraphStyle *ps = [NSMutableParagraphStyle new];
            ps.lineSpacing = 6;
            ps.lineBreakMode = NSLineBreakByCharWrapping;
            ps.alignment = NSTextAlignmentCenter;
            [mas addAttribute:NSParagraphStyleAttributeName value:ps range:NSMakeRange(0, mas.string.length)];
            mas;
        });
        contentLabel.cc_constraints.height.constant =  [YYTextLayout layoutWithContainerSize:CGSizeMake(ContentWidth, MAXFLOAT) text:contentLabel.attributedText].textBoundingSize.height;
        contentLabel.hidden = [@"sixpic,rundog,fourUnlike" containsString:pm.alias];
        
        _photoCollectionView.hidden = !pm.contentPic.count;
        [_photoCollectionView reloadData];
        _animalCollectionView.superview.hidden = true;
        if (pm.vote.count) {
            CGFloat h = 20;
            _animalCollectionView.superview.hidden = false;
            _animalCollectionView.cc_constraints.height.constant = (h+5) * (pm.vote.count/2 + pm.vote.count%2);
            ((UICollectionViewFlowLayout *)_animalCollectionView.collectionViewLayout).itemSize = CGSizeMake((APP.Width-45)/2-5, h);
            _animalCollectionView.collectionViewLayout = _animalCollectionView.collectionViewLayout;
            [_animalCollectionView reloadData];
        }
    }
    
    // TableView评论列表
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
                lb.text = @"还没有评论，你的机会来了";
                lb;
            })];
        }
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

// 点击头像
- (IBAction)onAvatarBtnClick:(UIButton *)sender {
    FastSubViewCode(_topView);
    LHUserInfoVC *vc = _LoadVC_from_storyboard_(@"LHUserInfoVC");
    vc.uid = _pm.uid;
    vc.didFollow = ^(BOOL follow) {
        subButton(@"关注Button").selected = follow;
        [subButton(@"关注Button") setTitle:follow ? @"已关注" : @"关注楼主" forState:UIControlStateNormal];
    };
    [NavController1 pushViewController:vc animated:true];
}

// 打赏
- (IBAction)onRewardBtnClick:(UIButton *)sender {
    LHPostRewardView *prv = _LoadView_from_nib_(@"LHPostRewardView");
    prv.pm = _pm;
    __weakSelf_(__self);
    prv.didConfirmBtnClick = ^(LHPostRewardView * _Nonnull prv, double price) {
        [NetworkManager1 lhcdoc_tipContent:__self.pm.cid amount:price].successBlock = ^(id responseObject) {
            [prv hide:nil];
            [SVProgressHUD showSuccessWithStatus:@"打赏成功！"];
        };
    };
    [prv show];
}

// 关注
- (IBAction)onFollowBtnClick:(UIButton *)sender {
    if (!UGLoginIsAuthorized()) {
        SANotificationEventPost(UGNotificationShowLoginView, nil);
        return;
    }
    BOOL follow = !sender.selected;
    __weakSelf_(__self);
    [NetworkManager1 lhcdoc_followPoster:_pm.uid followFlag:follow].successBlock = ^(id responseObject) {
        __self.pm.isFollow = follow;
        sender.selected = follow;
        [sender setTitle:follow ? @"已关注" : @"关注楼主" forState:UIControlStateNormal];
    };
}

// 投票
- (IBAction)onVoteBtnClick:(UIButton *)sender {
    LHPostVoteView *pvv = _LoadView_from_nib_(@"LHPostVoteView");
    pvv.pm = _pm;
    __weakSelf_(__self);
    pvv.didConfirmBtnClick = ^(LHPostVoteView * _Nonnull pvv, LHVoteModel * _Nonnull vm) {
        [NetworkManager1 lhdoc_vote:pvv.pm.cid animalId:vm.animalFlag].successBlock = ^(id responseObject) {
            vm.num += 1;
            CGFloat totalNum = 0;
            for (LHVoteModel *vm in __self.pm.vote) {
                totalNum += vm.num;
            }
            for (LHVoteModel *vm in __self.pm.vote) {
                vm.percent = vm.num/totalNum * 100;
            }
            [__self.animalCollectionView reloadData];
            [pvv hide:nil];
        };
    };
    [pvv show];
}

// 点赞
- (IBAction)onLikeBtnClick:(UIButton *)sender {
    if (!UGLoginIsAuthorized()) {
        SANotificationEventPost(UGNotificationShowLoginView, nil);
        return;
    }
    UIButton *bottomLikeBtn = sender;
    UILabel *bottomLikeLabel = [sender.superview viewWithTagString:@"点赞数Label"];
    BOOL like = !bottomLikeBtn.selected;
    
    __weakSelf_(__self);
    [NetworkManager1 lhcdoc_likePost:_pm.cid type:1 likeFlag:like].successBlock = ^(id responseObject) {
        __self.pm.isLike = like;
        __self.pm.likeNum += like ? 1 : -1;
        bottomLikeBtn.selected = like;
        bottomLikeLabel.hidden = !__self.pm.likeNum;
        bottomLikeLabel.text = @(__self.pm.likeNum).stringValue;
        bottomLikeLabel.textColor = like ? Skin1.navBarBgColor : Skin1.textColor2;
        
        if (__self.didCommentOrLike)
            __self.didCommentOrLike(__self.pm);
    };
}

// 评论
- (IBAction)onCommentBtnClick:(UIButton *)sender {
    if (!UGLoginIsAuthorized()) {
        SANotificationEventPost(UGNotificationShowLoginView, nil);
        return;
    }
    [LHPostCommentInputView show1:_pm];
}

// 收藏
- (IBAction)onFavBtnClick:(UIButton *)sender {
    if (!UGLoginIsAuthorized()) {
        SANotificationEventPost(UGNotificationShowLoginView, nil);
        return;
    }
    BOOL fav = !sender.selected;
    __weakSelf_(__self);
    [NetworkManager1 lhcdoc_doFavorites:_pm.cid type:2 favFlag:fav].successBlock = ^(id responseObject) {
        __self.pm.isFav = fav;
        sender.selected = fav;
    };
}


#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableView.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    FastSubViewCode(cell);
    UGLHPostCommentModel *pcm = tableView.dataArray[indexPath.row];
    
    // RefreshUI
    {
        [subButton(@"头像Button") sd_setImageWithURL:[NSURL URLWithString:pcm.headImg] forState:UIControlStateNormal];
        [subButton(@"昵称Button") setTitle:pcm.nickname forState:UIControlStateNormal];
        subButton(@"点赞图标Button").selected = pcm.isLike;
        subLabel(@"点赞次数Label").text = @(pcm.likeNum).stringValue;
        subLabel(@"点赞次数Label").textColor = pcm.isLike ? Skin1.navBarBgColor : APP.TextColor3;
        subLabel(@"评论内容Label").text = pcm.content;
        subLabel(@"评论时间Label").text = pcm.actionTime;
        [subButton(@"回复评论Button") setTitle:_NSString(@"%@回复", (pcm.replyCount ? [NSString stringWithFormat:@"%@ ", @(pcm.replyCount)] : @"")) forState:UIControlStateNormal];
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
            [NetworkManager1 lhcdoc_likePost:pcm.pid type:2 likeFlag:like].completionBlock = ^(CCSessionModel *sm) {
                if (!sm.error) {
                    pcm.likeNum += like ? 1 : -1;
                    pcm.isLike = like;
                    subButton(@"点赞图标Button").selected = like;
                    subLabel(@"点赞次数Label").text = @(pcm.likeNum).stringValue;
                    subLabel(@"点赞次数Label").textColor = like ? Skin1.navBarBgColor : Skin1.textColor2;
                } else if (sm.error.code == -2) { // 已点赞
                    sm.noShowErrorHUD = true;
                    pcm.isLike = like;
                    subButton(@"点赞图标Button").selected = like;
                    subLabel(@"点赞次数Label").textColor = like ? Skin1.navBarBgColor : Skin1.textColor2;
                }
            };
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
    return _pm.vote.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _photoCollectionView) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        UIImageView *imgView = [cell viewWithTagString:@"图片ImageView"];
        CGFloat collectionViewW = ContentWidth;
        imgView.cc_constraints.width.constant = collectionViewW;
        NSURL *url = [NSURL URLWithString:_pm.contentPic[indexPath.item]];
        UIImage *image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:[[SDWebImageManager sharedManager] cacheKeyForURL:url]];
        if (image) {
            imgView.hidden = false;
            imgView.cc_constraints.height.constant = collectionViewW/image.width * image.height;
            [imgView sd_setImageWithURL:url];   // 由于要支持gif动图，还是用sd加载
        } else {
            __weakSelf_(__self);
            imgView.hidden = true;
            image = [UIImage imageNamed:@"err"];
            imgView.cc_constraints.height.constant = collectionViewW/image.width * image.height;
            __weak_Obj_(imgView, __imgView);
            [imgView sd_setImageWithURL:url placeholderImage:image completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (image) {
                    __imgView.cc_constraints.height.constant = collectionViewW/image.width * image.height;
                    [__self.photoCollectionView reloadItemsAtIndexPaths:@[indexPath]];
                } else {
                    __imgView.hidden = false;
                }
            }];
        }
        return cell;
    }
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    LHVoteModel *vm = _pm.vote[indexPath.item];
    FastSubViewCode(cell);
    subLabel(@"生肖Label").text = vm.animal;
    subLabel(@"票数Label1").text = _NSString(@"%d票（%.2f%%）", (int)vm.num, vm.percent/100.0);
    subLabel(@"票数Label2").text = _NSString(@"%d票（%.2f%%）", (int)vm.num, vm.percent/100.0);
    subLabel(@"进度条View").cc_constraints.right.constant = (cell.width-30) * (1-vm.percent/100.0);
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView != _photoCollectionView) {
        return;
    }
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
