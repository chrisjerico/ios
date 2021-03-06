//
//  UGBMHeaderView.m
//  ug
//
//  Created by ug on 2019/10/30.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGBMHeaderView.h"
#import "PromotePopView.h"

#import "UGBMMemberCenterViewController.h"
#import "UGBMLoginViewController.h"
#import "UGBMRegisterViewController.h"
#import "UGBMBrowseViewController.h"
#import "UGFundsViewController.h"

@interface UGBMHeaderView ()<UUMarqueeViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *hornBgView;

@end
@implementation UGBMHeaderView

- (instancetype)UGBMHeaderView {
    NSBundle *bundle=[NSBundle mainBundle];
    NSArray *objs=[bundle loadNibNamed:@"UGBMHeaderView" owner:nil options:nil];
    return [objs firstObject];
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (!self.subviews.count) {
        UGBMHeaderView *v = [[UGBMHeaderView alloc] initView];
        v.backgroundColor = Skin1.navBarBgColor;
        [self addSubview:v];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (void)setNeedsLayout{
    [super setNeedsLayout];
//    if (OBJOnceToken(self)) {
//         NSLog(@"setNeedsLayout");
//    }
}
- (void)drawRect:(CGRect)rect;{
    [super drawRect :rect];
//    NSLog(@"drawRect");
}

- (instancetype)initView {
    if (self = [super init]) {
        self = [self UGBMHeaderView];
        [self refreshUI];
        __weakSelf_(__self);
        [self xw_addNotificationForName:UGNotificationLoginComplete block:^(NSNotification *notification) {
            NSLog(@"收到登录通知1：%@", notification.userInfo);
            [__self refreshUI];
        }];
        [self xw_addNotificationForName:UGNotificationUserLogout block:^(NSNotification *notification) {
            NSLog(@"收到退出通知1：%@", notification.userInfo);
            [__self refreshUI];
        }];
        FastSubViewCode(self);
        [self setBackgroundColor:Skin1.navBarBgColor];
        [self.hornBgView setBackgroundColor:Skin1.CLBgColor];
        [self.leftwardMarqueeView setBackgroundColor:Skin1.CLBgColor];
        [subView(@"上线View") setBackgroundColor:Skin1.bgColor];
        [subView(@"下线View") setBackgroundColor:Skin1.bgColor];
        self.leftwardMarqueeView.direction = UUMarqueeViewDirectionLeftward;
        self.leftwardMarqueeView.delegate = self;
        self.leftwardMarqueeView.timeIntervalPerScroll = 0.5f;
        self.leftwardMarqueeView.scrollSpeed = 60.0f;
        self.leftwardMarqueeView.itemSpacing = 20.0f;
        self.leftwardMarqueeView.touchEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showNoticeInfo)];
        [self.leftwardMarqueeView addGestureRecognizer:tap];

        [subImageView(@"Logo图片") sd_setImageWithURL:[NSURL URLWithString:SysConf.mobile_logo] placeholderImage:nil];
        subLabel(@"网址").text = SysConf.easyRememberDomain;
        [self xw_addNotificationForName:UGNotificationGetSystemConfigComplete block:^(NSNotification * _Nonnull noti) {
            [subImageView(@"Logo图片") sd_setImageWithURL:[NSURL URLWithString:SysConf.mobile_logo] placeholderImage:nil];
            subLabel(@"网址").text = SysConf.easyRememberDomain;
        }];
        [self getNoticeList];   // 公告列表
        if (Skin1.isGPK) {
            [self.leftwardMarqueeView start];
        }
        [self xw_addNotificationForName:UGNotificationWithSkinSuccess block:^(NSNotification * _Nonnull noti) {
            if (Skin1.isGPK) {
                [__self.leftwardMarqueeView start];
            } else {
                [__self.leftwardMarqueeView pause];
            }
        }];
    }
    return self;
}

- (void)refreshUI {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [TabBarController1 cc_hookSelector:@selector(setSelectedViewController:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> ai) {
            [NavController1 popToRootViewControllerAnimated:false];
        } error:nil];
    });
    FastSubViewCode(self);
    if (UGLoginIsAuthorized()) {//已经登录
        [subButton(@"按钮1") setTitle:@"会员中心" forState:(UIControlStateNormal)];
        if (APP.isGPKDeposit) {
             [subButton(@"按钮2") setTitle:@"存取款" forState:(UIControlStateNormal)];
        } else {
             [subButton(@"按钮2") setTitle:@"最近浏览" forState:(UIControlStateNormal)];
        }
        [subButton(@"按钮1") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
        [subButton(@"按钮1") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
            // 会员中心
            UIViewController *vc = [NavController1.viewControllers objectWithValue:UGBMMemberCenterViewController.class keyPath:@"class"];
            if (vc) {
                [NavController1 popToViewController:vc animated:false];
            } else {
                [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGBMMemberCenterViewController") animated:false];
            }
        }];
        [subButton(@"按钮2") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
        [subButton(@"按钮2") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {

            if (APP.isGPKDeposit) {
                //资金管理
                UIViewController *vc = [NavController1.viewControllers objectWithValue:UGFundsViewController.class keyPath:@"class"];
                if (vc) {
                    [NavController1 popToViewController:vc animated:false];
                } else {
                    [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGFundsViewController") animated:false];
                }
            } else {
                //最近浏览
                UIViewController *vc = [NavController1.viewControllers objectWithValue:UGBMBrowseViewController.class keyPath:@"class"];
                if (vc) {
                    [NavController1 popToViewController:vc animated:false];
                } else {
                    [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGBMBrowseViewController") animated:false];
                }
            }
           
        }];
    }
    else{
        [subButton(@"按钮1") setTitle:@"登入" forState:(UIControlStateNormal)];
        [subButton(@"按钮2") setTitle:@"免费开户" forState:(UIControlStateNormal)];
        [subButton(@"按钮1") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
        [subButton(@"按钮1") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
            //登录
            if (![NavController1.lastVC isKindOfClass:UGBMLoginViewController.class]) {
                [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGBMLoginViewController") animated:true];
            }
                           
        }];
        [subButton(@"按钮2") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
        [subButton(@"按钮2") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
            //注册
            if (![NavController1.lastVC isKindOfClass:UGBMRegisterViewController.class]) {
                [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGBMRegisterViewController") animated:true];
            }
        }];
    }
}

- (void)showNoticeInfo {
    NSMutableString *str = [[NSMutableString alloc] init];
    for (UGNoticeModel *notice in self.noticeTypeModel.scroll) {
        [str appendString:notice.content];
    }
    if (str.length) {
        float y;
        if ([CMCommon isPhoneX]) {
            y = 160;
        } else {
            y = 100;
        }
        PromotePopView *popView = [[PromotePopView alloc] initWithFrame:CGRectMake(40, y, UGScreenW - 80, UGScerrnH - y * 2)];
        [popView setContent:str title:@"公告详情"];
        [popView show];
    }
}

- (NSMutableArray<NSString *> *)leftwardMarqueeViewData {
    if (_leftwardMarqueeViewData == nil) {
        _leftwardMarqueeViewData = [NSMutableArray array];
    }
    return _leftwardMarqueeViewData;
}


// 公告列表
- (void)getNoticeList {
    WeakSelf;
    [CMNetwork getNoticeListWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                UGNoticeTypeModel *type = model.data;
                weakSelf.noticeTypeModel = model.data;
                for (UGNoticeModel *notice in type.scroll) {
                    [weakSelf.leftwardMarqueeViewData addObject:notice.title];
                }
                [weakSelf.leftwardMarqueeView reloadData];
            });
        } failure:nil];
    }];
}


#pragma mark - UUMarqueeViewDelegate

- (NSUInteger)numberOfVisibleItemsForMarqueeView:(UUMarqueeView *)marqueeView {
    return 1;
}

- (NSUInteger)numberOfDataForMarqueeView:(UUMarqueeView *)marqueeView {
    return self.leftwardMarqueeViewData ? self.leftwardMarqueeViewData.count : 0;
}

- (void)createItemView:(UIView *)itemView forMarqueeView:(UUMarqueeView *)marqueeView {
    itemView.backgroundColor = [UIColor clearColor];
    UILabel *content = [[UILabel alloc] initWithFrame:itemView.bounds];
    content.font = [UIFont systemFontOfSize:14.0f];
    content.tag = 1001;
    [itemView addSubview:content];
}

- (void)updateItemView:(UIView *)itemView atIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView *)marqueeView {
    UILabel *content = [itemView viewWithTag:1001];
    content.textColor = Skin1.textColor1;
    content.text = self.leftwardMarqueeViewData[index];
}
- (CGFloat)itemViewWidthAtIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView*)marqueeView {
    UILabel *content = [[UILabel alloc] init];
    content.text = self.leftwardMarqueeViewData[index];
    return content.intrinsicContentSize.width;
}

- (IBAction)btnClicked:(id)sender {
    self.yymenuView = [[UGYYRightMenuView alloc] initWithFrame:CGRectMake(UGScreenW /2 , 0, UGScreenW / 2, UGScerrnH)];
    self.yymenuView.titleType = @"1";
    [self.yymenuView show];
}

@end
