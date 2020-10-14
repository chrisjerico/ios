//
//  LHUserInfoVC.m
//  ug
//
//  Created by fish on 2019/12/1.
//  Copyright © 2019 ug. All rights reserved.
//

#import "LHUserInfoVC.h"
#import "UGPostListVC.h"    // 帖子列表
#import "UGLHMyAttentionViewController.h"   // 我的关注
#import "UGMyFansViewController.h"      // 我的粉丝

#import "UIImage+YYgradientImage.h"
#import "LHUserModel.h"

@interface LHUserInfoVC ()
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UGPostListVC *listVC;
@property (weak, nonatomic) IBOutlet UIImageView *imgbg;

@property (nonatomic, strong) LHUserModel *user;

@end

@implementation LHUserInfoVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIImage *image = [UIImage imageNamed:@"bc"];
    [self.imgbg setImage:[image qmui_imageWithTintColor :Skin1.navBarBgColor]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weakSelf_(__self);
    LoadingStateView *lsv = [LoadingStateView showWithSuperview:self.view state:ZJLoadingStateLoading];
    lsv.offsetY = NavController1.navigationBar.by;
    lsv.didRefreshBtnClick = ^{
        // 获取帖子详情
        [NetworkManager1 lhcdoc_getUserInfo:__self.uid].completionBlock = ^(CCSessionModel *sm, id resObject, NSError *err) {
            if (sm.error) {
                [LoadingStateView showWithSuperview:__self.view state:ZJLoadingStateFail];
            } else {
                [LoadingStateView showWithSuperview:__self.view state:ZJLoadingStateSucc];
                __self.user = [LHUserModel mj_objectWithKeyValues:sm.resObject[@"data"]];
                [__self setupUI];
            }
        };
    };
    UIImage *image = [UIImage imageNamed:@"bc"];
    [self.imgbg setImage:[image qmui_imageWithTintColor :Skin1.navBarBgColor]];
    
    lsv.didRefreshBtnClick();
}

- (void)setupUI {
    LHUserModel *user = _user;
    
    FastSubViewCode(self.view);
    [subImageView(@"头像ImageView") sd_setImageWithURL:[NSURL URLWithString:user.face]];
    subLabel(@"昵称Label").text = user.nickname;
    subLabel(@"级别Label").text = user.levelName;
    subLabel(@"关注数Label").text = @(user.followNum).stringValue;
    subLabel(@"粉丝数Label").text = @(user.fansNum).stringValue;
    subLabel(@"关帖数Label").text = @(user.favContentNum).stringValue;
    subLabel(@"发贴数Label").text = @(user.contentNum).stringValue;
    subLabel(@"获赞数Label").text = _NSString(@"获赞数：%ld", (long)user.likeNum);
    subButton(@"关注Button").selected = user.isFollow;
    [subButton(@"关注Button") setTitle:user.isFollow ? @"取消关注" : @"+关注" forState:UIControlStateNormal];
    
    if (OBJOnceToken(self)) {
        __weakSelf_(__self);
        UGPostListVC *vc = _LoadVC_from_storyboard_(@"UGPostListVC");
        vc.request = ^CCSessionModel * _Nonnull(NSInteger page) {
            NSString *alias = __self.segmentedControl.selectedSegmentIndex ? @"gourmet" : @"forum";
            return [NetworkManager1 lhdoc_contentList:alias uid:__self.uid sort:nil page:page];
        };
        [self.view addSubview:vc.view];
        [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headView.mas_bottom);
            make.left.right.bottom.equalTo(self.view);
        }];
        _listVC = vc;
    }
}

// 关注/取消关注
- (IBAction)onFollowBtnClick:(UIButton *)sender {
    if (!UGLoginIsAuthorized()) {
        SANotificationEventPost(UGNotificationShowLoginView, nil);
        return;
    }
    BOOL follow = !sender.selected;
    __weakSelf_(__self);
    [NetworkManager1 lhcdoc_followPoster:_uid followFlag:follow].successBlock = ^(CCSessionModel *sm, id responseObject) {
        sender.selected = follow;
        [sender setTitle:follow ? @"取消关注" : @"+关注" forState:UIControlStateNormal];
        if (__self.didFollow) {
            __self.didFollow(follow);
        }
    };
}

// 高手论坛、极品专贴
- (IBAction)onSegmentedControlValueChanged:(UISegmentedControl *)sender {
    [_listVC refreshData];
}

// 关注列表
- (IBAction)onFollowListBtnClick:(UIButton *)sender {
    UGLHMyAttentionViewController *vc = _LoadVC_from_storyboard_(@"UGLHMyAttentionViewController");
    vc.uid = _uid;
    [NavController1 pushViewController:vc animated:true];
}

// 粉丝列表
- (IBAction)onFansListBtnClick:(UIButton *)sender {
    UGMyFansViewController *vc = _LoadVC_from_storyboard_(@"UGMyFansViewController");
    vc.uid = _uid;
    [NavController1 pushViewController:vc animated:true];
}

// 关贴列表
- (IBAction)onFavPostListBtnClick:(UIButton *)sender {
    UGLHMyAttentionViewController *vc = _LoadVC_from_storyboard_(@"UGLHMyAttentionViewController");
    vc.uid = _uid;
    vc.selectIndex = 1;
    [NavController1 pushViewController:vc animated:true];
}

// 发贴列表
- (IBAction)onMyPostListBtnClick:(UIButton *)sender {
    
}

@end
