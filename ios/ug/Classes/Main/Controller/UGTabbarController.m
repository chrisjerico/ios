//
//  UGTabbarController.m
//  ug
//
//  Created by ug on 2019/4/30.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGTabbarController.h"
#import "UGLotteryHomeController.h"         // 彩票大厅
#import "UGFundsViewController.h"           // 资金管理
#import "UGHomeViewController.h"            // 首页
#import "UGYYLotteryHomeViewController.h"   // 购彩大厅
#import "UGMineSkinViewController.h"        // 我的
#import "UGPromotionsController.h"          // 优惠活动
#import "UGChangLongController.h"           // 长龙助手
#import "UGLotteryRecordController.h"       // 开奖记录
#import "UGMissionCenterViewController.h"   // 任务中心
#import "UGSecurityCenterViewController.h"  // 安全中心
#import "UGMailBoxTableViewController.h"    // 站内信
#import "UGBankCardInfoController.h"        // 我的银行卡
#import "UGBindCardViewController.h"        // 银行卡管理
#import "UGYubaoViewController.h"           // 利息宝
#import "UGSigInCodeViewController.h"       // 每日签到
#import "UGPromotionIncomeController.h"     // 推广收益
#import "UGBalanceConversionController.h"   // 额度转换
#import "UGAgentViewController.h"           // 申请代理
#import "UGBMMemberCenterViewController.h"  // 黑色模板会员中心
#import "UGBMpreferentialViewController.h"  // 黑色模板优惠专区
#import "UGBMLotteryHomeViewController.h"   // 黑色模板购彩大厅
#import "UGYYLotteryHomeViewController.h"   // 购彩大厅
#import "UGBMLoginViewController.h"         // 黑色模板登录页
//======================================================
#import "UGLHMineViewController.h"         // 六合模板我的
#import "UGSystemConfigModel.h"
#import "UGAppVersionManager.h"

#import "cc_runtime_property.h"
#import "UGMessageModel.h"




@implementation UIViewController (CanPush)

_CCRuntimeProperty_Assign(BOOL, 允许未登录访问, set允许未登录访问)
_CCRuntimeProperty_Assign(BOOL, 允许游客访问, set允许游客访问)
@end





@interface UGTabbarController ()<UITabBarControllerDelegate>

@property (nonatomic, copy) NSArray<UGMobileMenu *> *mms;
@end

@implementation UGTabbarController

static UGTabbarController *_tabBarVC = nil;

+ (instancetype)shared {
	return _tabBarVC;
}

+ (BOOL)canPushToViewController:(UIViewController *)vc {
	UGUserModel *user = [UGUserModel currentUser];
	BOOL isLogin = UGLoginIsAuthorized();
	
	// 未登录禁止访问
	if (!isLogin && !vc.允许未登录访问) {
		NSLog(@"未登录禁止访问：%@", vc);
		[NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGLoginViewController") animated:true];
		return false;
	}
	
	// 游客禁止访问
	if (user.isTest && !vc.允许游客访问) {
		NSLog(@"游客禁止访问：%@", vc);
		UIAlertController *ac = [AlertHelper showAlertView:@"温馨提示" msg:@"请先登录您的正式账号" btnTitles:@[@"取消", @"马上登录"]];
		[ac setActionAtTitle:@"马上登录" handler:^(UIAlertAction *aa) {
			SANotificationEventPost(UGNotificationShowLoginView, nil);
		}];
		return false;
	}
	
	if (user) {
		// 聊天室
		if ([vc isKindOfClass:[UGChatViewController class]] && !user.chatRoomSwitch) {
			[AlertHelper showAlertView:@"温馨提示" msg:@"聊天室已关闭" btnTitles:@[@"确定"]];
			return false;
		}
		
		// 任务中心
		else if ([vc isKindOfClass:[UGMissionCenterViewController class]] && [SysConf.missionSwitch isEqualToString:@"1"]) {
			[AlertHelper showAlertView:@"温馨提示" msg:@"任务中心已关闭" btnTitles:@[@"确定"]];
			return false;
		}
		// 利息宝
		else if ([vc isKindOfClass:[UGYubaoViewController class]] && !user.yuebaoSwitch) {
			[AlertHelper showAlertView:@"温馨提示" msg:@"利息宝已关闭" btnTitles:@[@"确定"]];
			return false;
		}
		// 每日签到
		else if ([vc isKindOfClass:[UGSigInCodeViewController class]] && [SysConf.checkinSwitch isEqualToString:@"0"]) {
			[AlertHelper showAlertView:@"温馨提示" msg:@"每日签到已关闭" btnTitles:@[@"确定"]];
			return false;
		}
	}
	
	return true;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	_tabBarVC = self;
	[self beginMessageRequest];
	self.delegate = self;
	
	
	[[UGSkinManagers skinWithSysConf] useSkin];
	
	{
		NSArray<UGMobileMenu *> *menus = [[UGMobileMenu arrayOfModelsFromDictionaries:SysConf.mobileMenu error:nil] sortedArrayUsingComparator:^NSComparisonResult(UGMobileMenu *obj1, UGMobileMenu *obj2) {
			return obj1.sort > obj2.sort;
		}];
		NSArray<UGMobileMenu *> *smallmenus;
		if (menus.count > 5) {
			smallmenus =  [menus subarrayWithRange:NSMakeRange(0, 5)];
		}
		else{
			smallmenus = menus;
		}
		NSLog(@"menus = %@",smallmenus);
		if (smallmenus.count > 3) {
			// 后台配置的页面
			[self resetUpChildViewController:smallmenus];
		} else {
			// 默认加载的页面
			NSMutableArray *temp = @[].mutableCopy;
			for (UGMobileMenu *mm in UGMobileMenu.allMenus) {
				if ([@"/home,/lotteryList,/chatRoomList,/activity,/user" containsString:mm.path]) {
					[temp addObject:mm];
				}
			}
			[self resetUpChildViewController:temp];
		}
	}
	
	SANotificationEventSubscribe(UGNotificationGetSystemConfigComplete, self, ^(typeof (self) self, id obj) {
		if (OBJOnceToken(TabBarController1)) {
			NSArray<UGMobileMenu *> *menus = [[UGMobileMenu arrayOfModelsFromDictionaries:SysConf.mobileMenu error:nil] sortedArrayUsingComparator:^NSComparisonResult(UGMobileMenu *obj1, UGMobileMenu *obj2) {
				return obj1.sort > obj2.sort;
			}];
			NSArray<UGMobileMenu *> *smallmenus;
			if (menus.count > 5) {
				smallmenus =  [menus subarrayWithRange:NSMakeRange(0, 5)];
			}
			else{
				smallmenus = menus;
			}
			NSLog(@"menus = %@",smallmenus);
			if (smallmenus.count > 3) {
				// 后台配置的页面
				[TabBarController1 resetUpChildViewController:smallmenus];
			} else {
				// 默认加载的页面
				NSMutableArray *temp = @[].mutableCopy;
				for (UGMobileMenu *mm in UGMobileMenu.allMenus) {
					if ([@"/home,/lotteryList,/chatRoomList,/activity,/user" containsString:mm.path]) {
						[temp addObject:mm];
					}
				}
				[TabBarController1 resetUpChildViewController:temp];
			}
			[[UGSkinManagers skinWithSysConf] useSkin];
		}
	});
	
	//    版本更新
	[[UGAppVersionManager shareInstance] updateVersionApi:false];
	[self setTabbarStyle];
	
	
	// 更新黑色模板状态栏
	{
		UIStackView *sv = [TabBarController1.tabBar viewWithTagString:@"描边StackView"];
		if (!sv) {
			sv = [[UIStackView alloc] initWithFrame:CGRectMake(0, 0, APP.Width, 65)];
			sv.axis = UILayoutConstraintAxisHorizontal;
			sv.distribution = UIStackViewDistributionFillEqually;
			sv.spacing = -0.75;
			sv.tagString = @"描边StackView";
			for (int i=0; i<5; i++) {
				UIView *v = [UIView new];
				v.layer.borderWidth = 0.7;
				v.layer.borderColor = APP.TextColor2.CGColor;
				v.backgroundColor = [UIColor clearColor];
				v.hidden = true;
				[sv addArrangedSubview:v];
			}
			sv.hidden = true;
			sv.userInteractionEnabled = false;
			[TabBarController1.tabBar addSubview:sv];
		}
		[self cc_hookSelector:@selector(setViewControllers:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> ai) {
			for (UIView *v in sv.arrangedSubviews) {
				v.hidden = !([sv.arrangedSubviews indexOfObject:v] < TabBarController1.tabBar.items.count);
			}
		} error:nil];
		[self xw_addNotificationForName:UGNotificationWithSkinSuccess block:^(NSNotification * _Nonnull noti) {
			for (UIView *v in sv.arrangedSubviews) {
				v.hidden = !([sv.arrangedSubviews indexOfObject:v] < TabBarController1.tabBar.items.count);
			}
			BOOL black = Skin1.isBlack;
			sv.hidden = !black;
			[TabBarController1 setTabbarHeight:black ? 53 : 50];
		}];
	}
}

- (void)setTabbarStyle {
	void (^block1)(NSNotification *) = ^(NSNotification *noti) {
		[TabBarController1.tabBar setBackgroundImage:[UIImage imageWithColor:Skin1.tabBarBgColor]];
		[[UITabBar appearance] setBackgroundImage:[UIImage imageWithColor:Skin1.tabBarBgColor]];
		[[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:Skin1.navBarBgColor size:APP.Size] forBarMetrics:UIBarMetricsDefault];
		
		for (UGNavigationController *nav in TabBarController1.viewControllers) {
			[nav.navigationBar setBackgroundImage:[UIImage imageWithColor:Skin1.navBarBgColor size:APP.Size] forBarMetrics:UIBarMetricsDefault];
		}
	};
	if (OBJOnceToken(self)) {
		[self xw_addNotificationForName:UGNotificationWithSkinSuccess block:block1];
	}
	block1(nil);
	
	[self.tabBar setSelectedImageTintColor: Skin1.tabSelectedColor];
	[self.tabBar setUnselectedItemTintColor:Skin1.tabNoSelectColor];
	[[UITabBar appearance] setSelectedImageTintColor: Skin1.tabSelectedColor];
	[[UITabBar appearance] setUnselectedItemTintColor:Skin1.tabNoSelectColor];
	[[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:Skin1.tabNoSelectColor} forState:UIControlStateNormal];
	[[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:Skin1.tabSelectedColor} forState:UIControlStateSelected];
	for (UIBarItem *item in self.tabBar.items) {
		[item setTitleTextAttributes:@{NSForegroundColorAttributeName:Skin1.tabNoSelectColor} forState:UIControlStateNormal];
		[item setTitleTextAttributes:@{NSForegroundColorAttributeName:Skin1.tabSelectedColor} forState:UIControlStateSelected];
	}
	
	{
		static UIView *__stateView = nil;
		static dispatch_once_t onceToken;
		dispatch_once(&onceToken, ^{
			__stateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP.Width, APP.StatusBarHeight)];
			__stateView.backgroundColor = Skin1.navBarBgColor;
			[self.view addSubview:__stateView];
			for (Class cls in @[QDWebViewController.class, UGBMLoginViewController.class]) {
				[cls cc_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> ai) {
					__stateView.hidden = true;
				} error:nil];
				[cls cc_hookSelector:@selector(viewWillDisappear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> ai) {
					__stateView.hidden = false;
				} error:nil];
			}
		});
	}
}

- (UIStatusBarStyle)preferredStatusBarStyle {
	return UIStatusBarStyleDefault;
	//UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
	//   return UIStatusBarStyleLightContent = 1 //白色文字，深色背景时使用
}

- (void)setTabbarHeight:(CGFloat)height {
	if (@available(iOS 11.0, *) && ![UIDevice currentDevice].isSimulator) {
		static dispatch_once_t onceToken;
		dispatch_once(&onceToken, ^{
			[UITabBar cc_hookSelector:@selector(sizeThatFits:) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> ai) {
				CGSize size = CGSizeZero;
				[ai.originalInvocation invoke];
				[ai.originalInvocation getReturnValue:&size];
				size.height = 50 + APP.BottomSafeHeight;
				[ai.originalInvocation setReturnValue:&size];
			} error:nil];
		});
		[self.view layoutSubviews];
		[self.selectedViewController.view layoutSubviews];
	}
}

/**
 *  添加子控制器
 */
- (void)resetUpChildViewController:(NSArray<UGMobileMenu *> *)menus {
	NSMutableArray <UIViewController *>*vcs = [NSMutableArray new];
	NSMutableArray *mms = @[].mutableCopy;
	for (UGMobileMenu *mm in menus) {
		if (![[UGMobileMenu allMenus] objectWithValue:mm.path keyPath:@"path"]) {
			continue;
		}
		
		// 判断优惠活动展示在首页还是内页（c001显示在内页）
		if (mm.cls == [UGPromotionsController class] && SysConf.m_promote_pos && ![APP.SiteId isEqualToString:@"c001"] && !Skin1.isBlack)
			continue;
		
		// 已存在的控制器不需要重新初始化
		BOOL existed = false;
		for (UINavigationController *nav in self.viewControllers) {
			if ([nav.viewControllers.firstObject isKindOfClass:mm.cls]) {
				[vcs addObject:nav];
				[mms addObject:mm];
				existed = true;
				break;
			}
		}
		if (existed)
			continue;
		
		// 初始化控制器
		// （这里加载了一个假的控制器，在 tabBarController:shouldSelectViewController: 函数才会加载真正的控制器）
		UIViewController *vc = [UIViewController new];
		UGNavigationController *nav = [[UGNavigationController alloc] initWithRootViewController:vc];
        nav.view.backgroundColor = Skin1.bgColor;
        nav.tabBarItem.title = mm.name;
        nav.tabBarItem.image = [UIImage imageNamed:mm.defaultImgName];
        nav.tabBarItem.selectedImage = [[UIImage imageNamed:mm.defaultImgName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        NSLog(@"mm.defaultImgName = %@",mm.defaultImgName);
        [[SDWebImageManager sharedManager] diskImageExistsForURL:[NSURL URLWithString:mm.icon] completion:^(BOOL isInCache) {
            if (isInCache) {
                UIImage *image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:[[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:mm.icon]]];
                nav.tabBarItem.image = image;
                NSLog(@"mm.icon = %@",mm.icon);
                nav.tabBarItem.selectedImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            }
        }];
		[vcs addObject:nav];
		[mms addObject:mm];
	}
	if (vcs.count > 2) {
		self.viewControllers = vcs;
		self.mms = mms;
		[self setTabbarStyle];
		[self tabBarController:self shouldSelectViewController:vcs.firstObject];
	}
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
	if (selectedIndex < self.viewControllers.count) {
		if ([self tabBarController:self shouldSelectViewController:self.viewControllers[selectedIndex]]) {
			[super setSelectedIndex:selectedIndex];
		}
	}
}


#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
	NSLog(@"viewController = %@",viewController);
	NSLog(@"_mms = %@",_mms);
	UGMobileMenu *mm = _mms[[tabBarController.viewControllers indexOfObject:viewController]];
	NSLog(@"mm = %@",mm);
	// 由 UGMobileMenu控制显示的ViewController
	UIViewController *vc = ((UINavigationController *)viewController).viewControllers.firstObject;
	NSLog(@"vc = %@",vc);
    
	// 控制器需要重新加载
	if (vc.class != mm.cls) {
		[mm createViewController:^(__kindof UIViewController * _Nonnull vc) {
			if (![UGTabbarController canPushToViewController:vc]) {
				return ;
			}
            UINavigationController *nav = (UINavigationController *)viewController;
			nav.title = mm.name;
			nav.tabBarItem.title = mm.name;
			nav.tabBarItem.image = [UIImage imageNamed:mm.defaultImgName];
            NSLog(@"mm.defaultImgName = %@",mm.defaultImgName);
			nav.tabBarItem.selectedImage = [[UIImage imageNamed:mm.defaultImgName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
			[[SDWebImageManager sharedManager] diskImageExistsForURL:[NSURL URLWithString:mm.icon] completion:^(BOOL isInCache) {
				if (isInCache) {
                    NSLog(@"mm.icon = %@",mm.icon);
					UIImage *image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:[[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:mm.icon]]];
					nav.tabBarItem.image = image;
					nav.tabBarItem.selectedImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
				}
			}];
			nav.viewControllers = @[vc];
			tabBarController.selectedViewController = nav;
		}];
		return false;
	}
	
	// push权限判断
	return [UGTabbarController canPushToViewController:vc];
}

- (void)loadMessageList {
	if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
		return;
	}
	NSDictionary *params = @{@"page":@(1),
							 @"rows":@(20),
							 @"token":[UGUserModel currentUser].sessid,
							 @"type":@""
	};
    
    void (^readMessage)(UGMessageModel *) = ^(UGMessageModel *mm) {
        NSDictionary *params = @{@"id":mm.messageId,
                                 @"token":[UGUserModel currentUser].sessid,
                                 };
        [CMNetwork modifyMessageStateWithParams:params completion:^(CMResult<id> *model, NSError *err) {
            [CMResult processWithResult:model success:^{
                mm.isRead = YES;
            } failure:^(id msg) {}];
        }];
    };
	dispatch_suspend(APP.messageRequestTimer);
	[CMNetwork getMessageListWithParams:params completion:^(CMResult<id> *model, NSError *err) {
		[CMResult processWithResult:model success:^{
            NSDate *lastDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"最新站内信的创建时间"];
			UGMessageListModel *mlm = model.data;
			NSArray <UGMessageModel *>*unreadArray = [mlm.list filteredArrayUsingPredicate: [NSPredicate predicateWithBlock:^BOOL(UGMessageModel *mm, NSDictionary<NSString *,id> * _Nullable bindings) {
                NSDate *date = [mm.updateTime dateWithFormat:@"yyyy-MM-dd HH:mm:ss"];
                if ([date isLaterThan:lastDate]) {
                    [[NSUserDefaults standardUserDefaults] setObject:date forKey:@"最新站内信的创建时间"];
                    return !mm.isRead;
                }
                return false;
            }]];
            
			if (unreadArray.count > 0) {
				for (UGMessageModel *model in [unreadArray reverseObjectEnumerator]) {
                    if (Skin1.isBlack) {
                        [LEEAlert alert].config
                        .LeeAddTitle(^(UILabel *label) {
                            label.text = model.title;
                            label.textColor = [UIColor whiteColor];
                        })
                        .LeeAddContent(^(UILabel *label) {
                            NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] initWithData:[model.content dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
                            NSMutableParagraphStyle *ps = [NSMutableParagraphStyle new];
                            ps.lineSpacing = 5;
                            [mas addAttributes:@{NSParagraphStyleAttributeName:ps,} range:NSMakeRange(0, mas.length)];
                            
                            // 替换文字颜色
                            NSAttributedString *as = [mas copy];
                            for (int i=0; i<as.length; i++) {
                                NSRange r = NSMakeRange(0, as.length);
                                NSMutableDictionary *dict = [as attributesAtIndex:i effectiveRange:&r].mutableCopy;
                                UIColor *c = dict[NSForegroundColorAttributeName];
                                if (fabs(c.red - c.green) < 0.05 && fabs(c.green - c.blue) < 0.05) {
                                    dict[NSForegroundColorAttributeName] = Skin1.textColor2;
                                    [mas addAttributes:dict range:NSMakeRange(i, 1)];
                                }
                            }
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                label.attributedText = mas;
                            });
                        })
                        .LeeHeaderColor(Skin1.bgColor)
                        .LeeAction(@"确定", ^{
                            readMessage(model);
                            dispatch_resume(APP.messageRequestTimer);
                        })
                        .LeeShow(); // 设置完成后 别忘记调用Show来显示
                    } else {
                        [LEEAlert alert].config
                        .LeeTitle(model.title)
                        .LeeAddContent(^(UILabel *label) {
                            label.attributedText = [[NSAttributedString alloc] initWithData:[model.content dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
                        })
                        .LeeAction(@"确定", ^{
                            readMessage(model);
                            dispatch_resume(APP.messageRequestTimer);
                        })
                        .LeeShow(); // 设置完成后 别忘记调用Show来显示
                    }
                }
			} else {
				dispatch_resume(APP.messageRequestTimer);
			}
			
		} failure:^(id msg) {
			dispatch_resume(APP.messageRequestTimer);
		}];
	}];
}
- (void)beginMessageRequest {
	WeakSelf;
	dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0));
	dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 180 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
	dispatch_source_set_event_handler(timer, ^{
		[weakSelf loadMessageList];
	});
	dispatch_resume(timer);
	APP.messageRequestTimer = timer;
	
}
@end
