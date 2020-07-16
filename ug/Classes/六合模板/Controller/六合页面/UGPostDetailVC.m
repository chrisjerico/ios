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
#import "UGLHPrizeView.h"           //解码器
#import "LHHornView.h"              //喇叭
// Tools
#import "YYText.h"
#import "CMTimeCommon.h"

#define ContentWidth (APP.Width-40)


@interface UGPostDetailVC ()<UICollectionViewDelegateFlowLayout,WKUIDelegate, WKNavigationDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;/**<   图片列表 */
@property (weak, nonatomic) IBOutlet UICollectionView *animalCollectionView;/**<   生肖列表（可投票） */
@property (weak, nonatomic) IBOutlet UITableView *tableView;    /**<    评论TableView */
@property (weak, nonatomic) IBOutlet UIView *topView;           /**<   顶部作者信息 */
@property (weak, nonatomic) IBOutlet UIView *bottomBarView;     /**<    底部菜单栏（评论、点赞） */
@property (weak, nonatomic) IBOutlet UGLHPrizeView *lhPrizeView; /**<    解码器 */
@property (weak, nonatomic) IBOutlet LHHornView *lhHornView; /**<    喇叭 */
@property (nonatomic, copy) NSString *opCustomerId; /**<    被回复者ID */
@property (nonatomic, copy) NSString *opCommentId;  /**<    被回复的评论ID（有值表示回复评论，没值表示评论动态） */
@property (nonatomic, copy) NSMutableDictionary *textBuffer;
@property (nonatomic,strong)NSMutableArray <MediaModel *>*image_list;


@end

@implementation UGPostDetailVC

- (BOOL)允许游客访问   { return true; }
- (BOOL)允许未登录访问 { return true; }
- (void)dealloc {
    
    if (_lhPrizeView.timer) {
        if ([_lhPrizeView.timer isValid]) {
            [_lhPrizeView.timer invalidate];
            _lhPrizeView.timer = nil;
        }
    }
    [_lhPrizeView.countDownForLabel destoryTimer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_lhPrizeView.timer) {
        [_lhPrizeView.timer setFireDate:[NSDate date]];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_lhPrizeView.timer) {
        [_lhPrizeView.timer setFireDate:[NSDate distantFuture]];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _textBuffer = [@{} mutableCopy];
    self.view.clipsToBounds = true;
    self.title = self.title.mutableCopy;    // 让导航条的标题显示出来
    self.image_list = [NSMutableArray array];
    __weakSelf_(__self);
    _topView.hidden = true;
    _photoCollectionView.cc_constraints.width.constant = ContentWidth;
    // 自适应高度
    {
        [__self.tableView.tableHeaderView.subviews.firstObject xw_addObserverBlockForKeyPath:@"contentSize" block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
            __self.tableView.tableHeaderView.height = [newVal CGSizeValue].height;
            [__self.tableView reloadData];
        }];
        [_photoCollectionView xw_addObserverBlockForKeyPath:@"contentSize" block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
            ((UIScrollView *)obj).cc_constraints.height.constant = MAX([newVal CGSizeValue].height + 4, 20);
//            [__self.photoCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.height.mas_equalTo(600).offset(0);
//            }];
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
                NSString  *link = __self.pm.link;
                NSLog(@"data=%@",sm.responseObject[@"data"]);
                __self.pm = [UGLHPostModel mj_objectWithKeyValues:sm.responseObject[@"data"]];
                __self.pm.link = link;
                [__self setupSSV];
                [LoadingStateView showWithSuperview:__self.view state:ZJLoadingStateSucc];
            }
        };
    };
    lsv.didRefreshBtnClick();
    
    
    NSLog(@"link = %@",self.pm.link);
    FastSubViewCode(self.view);
    
    //fourUnlike  CvB3zABB rundog humorGuess
    //       subLabel(@"标题Label").hidden = [@"mystery,rule,sixpic,humorGuess,rundog,fourUnlike,sxbm,tjym,ptyx" containsString:pm.alias];
    
    
    //    [CMCommon showSystemTitle:self.pm.link];
}

-(BOOL)hasShow{
    // 公式规律 rule
    // 精华帖子 mystery
    // 高手论坛 forum
    // 平特专区 gourmet
    /**<  论坛详情是否显示解码器  */
    BOOL isShow = NO;
    if ([self.pm.link containsString: @"mystery/"]) {
        isShow = YES;
    } else {
        isShow = [@"rule,mystery,forum,gourmet,E9biHXEx,n0v3azC0,fourUnlike,mT303M99,rundog,humorGuess" containsString:self.pm.alias];
    }
    return isShow;
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
        //subLabel(@"时间Label").text = pm.createTime;
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
            NSLog(@"hidden = %d",subButton(tagString).hidden);
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
        BOOL isHidden = NO;
        NSLog(@"alias = %@",self.pm.alias);
        if([@"mystery,rule,sixpic,humorGuess,rundog,fourUnlike,sxbm,tjym,ptyx,CvB3zABB,E9biHXEx,n0v3azC0,mT303M99" containsString:pm.alias]) {
            isHidden = YES;
        }
        else{
            if ([self.pm.link containsString: @"mystery/"]) {
                isHidden = YES;
            }
            else{
                isHidden = NO;
            }
        }
        
        //        subLabel(@"标题Label").hidden = [@"mystery,rule,sixpic,humorGuess,rundog,fourUnlike,sxbm,tjym,ptyx,CvB3zABB," containsString:pm.alias];
        
        [subLabel(@"标题Label") setHidden:isHidden];
        
        NSLog(@"pm.link =%@",pm.link);
        

        [_lhPrizeView setHidden:NO];

        if (APP.isShowHornView) {
            [_lhHornView setHidden:NO];
        }
        
        if ([@"l001" isEqualToString:APP.SiteId]) {
            subLabel(@"时间Label").text = @"本站备用网址一:www.889777.com";
            subLabel(@"时间Label2").text = @"本站备用网址二:www.668000.com";
        }
        else if([@"l002" isEqualToString:APP.SiteId]) {
            subLabel(@"时间Label").text = @"本站备用网址一:www.300777.com";
            subLabel(@"时间Label2").text = @"本站备用网址二:www.400777.com";
        }
        else{
            
        }
        //        subLabel(@"时间Label").text = _NSString(@"最后更新时间：%@", pm.createTime);
        
        //        subLabel(@"时间Label").hidden = [@"mystery,rule" containsString:pm.alias];
        
        UIView *cView = subView(@"内容View");
        WKWebView *wv = [cView viewWithTagString:@"内容WebView"];
        if (!wv) {
            wv = [WKWebView new];
            wv.UIDelegate = self;
            wv.clipsToBounds = false;
            wv.tagString = @"内容WebView";
            wv.scrollView.bounces = false;
            wv.UIDelegate = self;
            wv.navigationDelegate = self;
            [subView(@"内容View") addSubview:wv];
            [wv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(cView);
                make.width.mas_equalTo(APP.Width-30);
                make.top.equalTo(cView);
            }];
            [wv xw_addObserverBlockForKeyPath:@"scrollView.contentSize" block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
                cView.cc_constraints.height.constant = [newVal CGSizeValue].height;
            }];
        }
        NSString *content = pm.content;
        for (NSString *s1 in [pm.content componentsSeparatedByString:@"[em_"]) {
            NSString *gifName = [s1 componentsSeparatedByString:@"]"].firstObject;
            if (gifName.isInteger) {
                content = [content stringByReplacingOccurrencesOfString:_NSString(@"[em_%@]", gifName) withString:_NSString(@"<img src=\"http://admintest10.6yc.com/images/arclist/%@.gif\"/>", gifName)];
            }
        }
        

        NSString *head = @"<head><meta name='viewport' content='initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'><style>img{width:100%!important;max-width:100%;height:auto !important}</style><style>body{width:100%;word-break: break-all;word-wrap: break-word;vertical-align: middle;overflow: hidden;}</style></head>";

        
        [wv loadHTMLString:[head stringByAppendingString:content] baseURL:nil];
        wv.superview.hidden = !pm.content.length || [@"sixpic" containsString:pm.alias];
        
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

            if (![CMCommon stringIsNull:pm.link]) {
                  NSMutableDictionary*dic = [CMCommon yyUrlConversionParameter:pm.link];
                   NSLog(@"id ============= %@",[dic objectForKey:@"id"]);
                    NSString * gid = [dic objectForKey:@"id"];
                   [__self.lhPrizeView setGid:gid];
                   
               }
               
            
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
        [tv.mj_header beginRefreshing];
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
    CheckLogin(false, false,);
    
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
    CheckLogin(false, false,);
    
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
    CheckLogin(false, false,);
    
    LHPostVoteView *pvv = _LoadView_from_nib_(@"LHPostVoteView");
    pvv.pm = _pm;
    __weakSelf_(__self);
    pvv.didConfirmBtnClick = ^(LHPostVoteView * _Nonnull pvv, LHVoteModel * _Nonnull vm) {
        [NetworkManager1 lhdoc_vote:pvv.pm.cid animalId:vm.animalFlag].successBlock = ^(id responseObject) {
            
            
            [CMCommon showToastTitle:@"投票成功！"];
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
    CheckLogin(false, false,);
    
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
    CheckLogin(false, false,);
    
    [LHPostCommentInputView show1:_pm];
}

// 收藏
- (IBAction)onFavBtnClick:(UIButton *)sender {
    CheckLogin(false, false,);
    
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

- (void)setHiden:(UIButton *(^)(NSString *))subButton subView:(UIView *(^)(NSString *))subView {
    [subView(@"回复View") setHidden:YES];
    [subView(@"回复StackView") setHidden:YES];
    UIStackView *sv = (id)subView(@"回复StackView");
    for (int i = 0; i< 3; i++) {
        FastSubViewCode(sv.arrangedSubviews[i]);
        sv.arrangedSubviews[i].hidden = YES;
    }
    [subButton(@"回复内容btn") setHidden:YES];
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
        subLabel(@"点赞次数Label").text = pcm.likeNum ? @(pcm.likeNum).stringValue : @"";
        subLabel(@"点赞次数Label").textColor = pcm.isLike ? Skin1.navBarBgColor : APP.TextColor3;
        subLabel(@"评论内容Label").text = pcm.content;
        
        subLabel(@"评论时间Label").text =  [CMTimeCommon formatTimeStr:pcm.actionTime];;
        [subButton(@"回复评论Button") setTitle:_NSString(@"%@回复", (pcm.replyCount ? [NSString stringWithFormat:@"%@ ", @(pcm.replyCount)] : @"")) forState:UIControlStateNormal];
        
        
        {
            // 回复UI
            if (pcm.secReplyList.count) {
                [subView(@"回复View") setHidden:NO];
                [subView(@"回复StackView") setHidden:NO];
                [subButton(@"回复内容btn") setHidden:NO];
                
                int count  = (int)MIN(pcm.secReplyList.count, 3);
                
                UIStackView *sv = (id)subView(@"回复StackView");
                for (int i = 0; i< 3; i++) {
                    FastSubViewCode(sv.arrangedSubviews[i]);
                    sv.arrangedSubviews[i].hidden = i >= count;
                    if (i < pcm.secReplyList.count) {
                        UGLHPostModel* obj = [UGLHPostModel mj_objectWithKeyValues:pcm.secReplyList[i]];
                        [subView(@"内容View") setHidden:NO];
                        [subButton(@"头像Btn") sd_setImageWithURL:[NSURL URLWithString:obj.headImg] forState:UIControlStateNormal];
                        subLabel(@"昵称Label").text =  obj.nickname ? [NSString stringWithFormat:@"%@:",obj.nickname]: @"";
                        subLabel(@"内容Label").text = obj.content ? obj.content : @"";
                    }
                }
                
                if (pcm.secReplyList.count > 3) {
                    [subButton(@"回复内容btn") setTitle:[NSString stringWithFormat:@"查看全部回复%lu条 >",(unsigned long)pcm.secReplyList.count] forState:(UIControlStateNormal)];
                    [subButton(@"回复内容btn") setHidden:NO];
                }
                else{
                    [subButton(@"回复内容btn") setHidden:YES];
                }
                
            } else {
                [self setHiden:subButton subView:subView];
            }
            
            
        }
    }
    
    // Action
    {
        [subButton(@"点赞事件Button") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
        [subButton(@"点赞事件Button") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
            CheckLogin(false, false,);
            
            BOOL like = !subButton(@"点赞图标Button").selected;
            [NetworkManager1 lhcdoc_likePost:pcm.pid type:2 likeFlag:like].completionBlock = ^(CCSessionModel *sm) {
                if (!sm.error) {
                    pcm.likeNum += like ? 1 : -1;
                    pcm.isLike = like;
                    subButton(@"点赞图标Button").selected = like;
                    subLabel(@"点赞次数Label").text = pcm.likeNum ? @(pcm.likeNum).stringValue : @"";
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
        [subButton(@"回复内容btn") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
        [subButton(@"回复内容btn") addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
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
        //        imgView.frame = cell.bounds;
        NSURL *url = [NSURL URLWithString:_pm.contentPic[indexPath.item]];
        UIImage *image = [[SDImageCache sharedImageCache] imageFromCacheForKey:[[SDWebImageManager sharedManager] cacheKeyForURL:url]];
        if (image) {
            imgView.hidden = false;
            [imgView sd_setImageWithURL:url];   // 由于要支持gif动图，还是用sd加载
        } else {
            __weakSelf_(__self);
            imgView.hidden = true;
            __weak_Obj_(imgView, __imgView);
            [imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"err"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (image) {
                    [__self.photoCollectionView reloadItemsAtIndexPaths:@[indexPath]];
                } else {
                    __imgView.hidden = false;
                }
            }];
        }
        return cell;
    }
    
    // 投票
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    LHVoteModel *vm = _pm.vote[indexPath.item];
    FastSubViewCode(cell);
    subLabel(@"生肖Label").text = vm.animal;
    subLabel(@"票数Label1").text = _NSString(@"（%d%%）",  (int)vm.percent);
    subLabel(@"票数Label2").text = _NSString(@"（%d%%）",  (int)vm.percent);
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

-(void)showMediaView:(NSArray <MediaModel *>*)models   index:(NSUInteger )index{
    MediaViewer *vpView = _LoadView_from_nib_(@"MediaViewer");
    vpView.frame = APP.Bounds;
    vpView.models = models;
    vpView.index = index;
    [TabBarController1.view addSubview:vpView];
    {
        // 入场动画
        CGRect rect = CGRectMake(0, APP.Height - APP.Width, APP.Width, APP.Width);
        [vpView showEnterAnimations:rect image:nil];
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _photoCollectionView) {
        UIImage *image = [[SDImageCache sharedImageCache] imageFromCacheForKey:[[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:_pm.contentPic[indexPath.item]]]];
        if (!image) {
            image = [UIImage imageNamed:@"err"];
        }
        return CGSizeMake(ContentWidth, (NSInteger)(ContentWidth/image.width * image.height));
    } else {
        return CGSizeMake((ContentWidth-6)/2, 20);
    }
}


#pragma mark - WKUIDelegate



- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    //如果是跳转一个新页面
    if (navigationAction.targetFrame.request != nil) {
        NSString *selectedImgURL = navigationAction.request.URL.absoluteString;
        NSLog(@"selectedImgURL = %@",selectedImgURL);
        NSMutableArray <NSString *>* urlArray = @[].mutableCopy;
        for (MediaModel *mm in self.image_list) {
            [urlArray addObject:[mm.imgUrl absoluteString]];
        }
        if ([urlArray containsObject:selectedImgURL]) {
            NSUInteger index = [urlArray indexOfObject:selectedImgURL];
            [self showMediaView:self.image_list index:index];
        }
        else{
            if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
                //跳转别的应用如系统浏览器
                // 对于跨域，需要手动跳转
                SLWebViewController *vc = [SLWebViewController new];
                vc.urlStr = navigationAction.request.URL.absoluteString;
                [NavController1 pushViewController:vc animated:true];
                // 不允许web内跳转
                decisionHandler(WKNavigationActionPolicyCancel);
                
            } else {
                //应用的web内跳转
                decisionHandler (WKNavigationActionPolicyAllow);
                
            }
        }
        
        decisionHandler(WKNavigationActionPolicyCancel);
    }else{
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    
    return ;//不添加会崩溃
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    static  NSString * const imagesJS =
    @"function getImages(){\
    var objs = document.getElementsByTagName(\"img\");\
    var imgScr = '';\
    for(var i=0;i<objs.length;i++){\
    imgScr = imgScr + objs[i].src + '+';\
    };\
    return imgScr;\
    };";
    
    [webView evaluateJavaScript:imagesJS completionHandler:nil];
    [webView evaluateJavaScript:@"getImages()" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSArray *urlArray = [NSMutableArray arrayWithArray:[result componentsSeparatedByString:@"+"]];
        //里面如果有空的需要过滤掉
        if(self.image_list.count==0){
            for (NSString *tempURL in urlArray) {
                if(![CMCommon stringIsNull:tempURL]){
                    NSLog(@"tempURL =%@",tempURL);
                    
                    MediaModel *mm = [MediaModel new];
                    mm.imgUrl = [NSURL URLWithString:tempURL];
                    [self.image_list addObject:mm];
                }
            }
        }
    }];
    
    [webView evaluateJavaScript:@"function registerImageClickAction(){\
     var imgs = document.getElementsByTagName('img');\
     for(var i=0;i<imgs.length;i++){\
     imgs[i].customIndex = i;\
     imgs[i].onclick=function(){\
     window.location.href=''+this.src;\
     }\
     }\
     }" completionHandler:nil];
    
    [webView evaluateJavaScript:@"registerImageClickAction();"completionHandler:nil];
}


@end
