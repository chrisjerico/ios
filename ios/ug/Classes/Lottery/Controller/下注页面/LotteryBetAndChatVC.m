//
//  LotteryBetAndChatVC.m
//  ug
//
//  Created by fish on 2020/1/4.
//  Copyright © 2020 ug. All rights reserved.
//

#import "LotteryBetAndChatVC.h"
#import "UGCommonLotteryController.h"
#import "UGChatViewController.h"
#import "UGLotterySelectController.h"

#import "SlideSegmentView1.h"
#import "STBarButtonItem.h"



@interface UGCommonLotteryController ()
@property (nonatomic, strong) UITableView *tableView;                   /**<   玩法列表TableView */
@property (nonatomic, strong) UICollectionView *betCollectionView;      /**<   下注号码CollectionView */
@end
@interface UGChatViewController ()
@property (nonatomic, strong) UIButton *closeBtn;
@end



@interface LotteryBetAndChatVC ()

@property (nonatomic) SlideSegmentView1 *ssv1;                  /**<    分页布局View */
@end


@implementation LotteryBetAndChatVC

- (BOOL)允许游客访问 { return true; }

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 每次‘彩票下注页’设置导航条按钮时，改为设置LotteryBetAndChatVC页的导航条按钮
    {
        __weak static UIViewController *__vc = nil;
        __vc = self;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [UGCommonLotteryController cc_hookSelector:@selector(navigationItem) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo>  _Nonnull ai) {
                [ai.originalInvocation invoke];
                if (__vc) {
                    UINavigationItem *ni = __vc.navigationItem;
                    [ai.originalInvocation setReturnValue:&ni];
                }
            } error:nil];
        });
    }
    
    // 设置导航条返回按钮
    {
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [backButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [backButton setImage:[UIImage imageNamed:@"c_navi_back"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"c_navi_back"] forState:UIControlStateHighlighted];
        [backButton sizeToFit];
        [backButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
            [NavController1 popViewControllerAnimated:true];
        }];
        UIView *containView = [[UIView alloc] initWithFrame:backButton.bounds];
        [containView addSubview:backButton];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:containView];
        // 设置返回按钮
        self.navigationItem.leftBarButtonItem = item;
    }
    
    // 彩票下注页VC
    UGNextIssueModel *model = _nim;
    UGCommonLotteryController *vc1 = ({
        NSDictionary *dict = @{@"cqssc" :@"UGSSCLotteryController",     // 重庆时时彩
                               @"pk10"  :@"UGBJPK10LotteryController",  // pk10
                               @"xyft"  :@"UGBJPK10LotteryController",  // 幸运飞艇
                               @"qxc"   :@"UGQXCLotteryController",     // 七星彩
                               @"lhc"   :@"UGHKLHCLotteryController",   // 六合彩
                               @"jsk3"  :@"UGJSK3LotteryController",    // 江苏快3
                               @"pcdd"  :@"UGPCDDLotteryController",    // pc蛋蛋
                               @"gd11x5":@"UGGD11X5LotteryController",  // 广东11选5
                               @"xync"  :@"UGXYNCLotteryController",    // 幸运农场
                               @"bjkl8" :@"UGBJKL8LotteryController",   // 北京快乐8
                               @"gdkl10":@"UGGDKL10LotteryController",  // 广东快乐10
                               @"fc3d"  :@"UGFC3DLotteryController",    // 福彩3D
                               @"pk10nn":@"UGPK10NNLotteryController",  // pk10牛牛
        };
        NSString *vcName = dict[model.gameType];
        UGCommonLotteryController *vc = _LoadVC_from_storyboard_(vcName);
        if ([@[@"7", @"11", @"9"] containsObject:model.gameId]) {
            vc.shoulHideHeader = true;
        }
        UGNextIssueModel *nextIssueModel = [UGNextIssueModel new];
        [nextIssueModel setValuesWithObject:model];
        vc.nextIssueModel = nextIssueModel;
        vc.gameId = model.gameId;
        vc.gotoTabBlock = ^{
            TabBarController1.selectedIndex = 0;
        };
        // 底部占位调大到100
        [vc cc_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo>  _Nonnull ai) {
            UGCommonLotteryController *vc = ai.instance;
            vc.tableView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0);
            vc.betCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0);
        } error:nil];
        vc;
    });
    
    // 聊天室VC
    UGChatViewController *vc2 = ({
        UGChatViewController *vc = [[UGChatViewController alloc] init];
        vc.gameId = model.gameId;
        // 隐藏H5的导航条
        [vc cc_hookSelector:@selector(setUrl:) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo>  _Nonnull ai) {
            NSString *url = ai.arguments.firstObject;
            url = _NSString(@"%@&hideHead=true", url);
            [ai.originalInvocation setArgument:&url atIndex:2];
        } error:nil];
        // 隐藏退出按钮
        [vc cc_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo>  _Nonnull ai) {
            ((UGChatViewController *)ai.instance).closeBtn.hidden = true;
        } error:nil];
        vc;
    });
    
    
    
    // SlideSegmentView1 分页布局View
    {
        
        [self addChildViewController:vc1];
        [self addChildViewController:vc2];
        
        NSArray *titles = @[@"投注区", @"聊天室"];
        SlideSegmentView1 *ssv1 = _ssv1 = _LoadView_from_nib_(@"SlideSegmentView1");
        ssv1.frame = CGRectMake(0, 0, APP.Width, APP.Height);
        ssv1.viewControllers = @[vc1, vc2];
        for (UIView *v in ssv1.contentViews) {
            [v mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(ssv1.width);
                make.height.mas_equalTo(APP.Height - NavController1.navigationBar.by - 40);
            }];
        }
        ssv1.titleBar.titleForItemAtIndex = ^NSString *(NSUInteger idx) {
            return titles[idx];
        };
        __weak_Obj_(ssv1, __ssv1);
        ssv1.titleBar.didSelectItemAtIndexPath = ^(UICollectionViewCell *cell, UILabel *label, NSUInteger idx, BOOL selected) {
            label.textColor = selected ? Skin1.textColor1 : Skin1.textColor2;
            if (!idx && !selected) {
                label.textColor = [UIColor whiteColor];
            }
            label.font = selected ? [UIFont boldSystemFontOfSize:16] : [UIFont systemFontOfSize:14];
            cell.backgroundColor = selected ? [[UIColor grayColor] colorWithAlphaComponent:0.1] : [UIColor clearColor];
            __ssv1.titleBar.backgroundColor = Skin1.isBlack || idx || !APP.betBgIsWhite ? Skin1.navBarBgColor : [UIColor whiteColor];


            
            
        };
        ssv1.titleBar.underlineView.hidden = true;
        [self.view insertSubview:ssv1 atIndex:0];
        [ssv1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_topMargin);
            make.left.right.bottom.equalTo(self.view);
        }];
        [self.view layoutIfNeeded];
        ssv1.selectedIndex = 0;
    }
}

@end
