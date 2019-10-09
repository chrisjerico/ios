//
//  UGLaunchPageVC.m
//  ug
//
//  Created by xionghx on 2019/10/7.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGNavigationController.h"
#import "UGMineViewController.h"
#import "UGLotteryHomeController.h"
//#import "UGChatsViewController.h"
#import "UITabBarController+ShowViewController.h"
#import "UGChatViewController.h"
#import "UGAppVersionManager.h"
#import "UGHomeViewController.h"
#import "UGChangLongController.h"
#import "UGYYLotteryHomeViewController.h"
#import "UGPromotionsController.h"
#import "UGChatViewController.h"
#import "UGLotteryRecordController.h"
#import "UGMineSkinViewController.h"
#import "UGMissionCenterViewController.h"
#import "UGSecurityCenterViewController.h"
#import "UGFundsViewController.h"
#import "UGMailBoxTableViewController.h"
#import "UGBalanceConversionController.h"
#import "UGBankCardInfoController.h"
#import "UGYubaoViewController.h"
#import "UGSigInCodeViewController.h"
#import "UGPromotionIncomeController.h"
#import "UGLaunchPageVC.h"

@interface UGLaunchPageVC ()<UITabBarControllerDelegate>

@end

@implementation UGLaunchPageVC

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = UIColor.whiteColor;
	UIImageView * imageView = [UIImageView new];
	
	[CMNetwork.manager requestWithMethod:[[NSString stringWithFormat:@"%@/wjapp/api.php?c=system&a=launchImages", baseServerUrl] stringToRestfulUrlWithFlag:RESTFUL]
								  params:nil
								   model:CMResultArrayClassMake(LaunchPageModel.class)
									post:NO
							  completion:^(CMResult<id> *model, NSError *err) {
		
		NSArray<LaunchPageModel *> * launchPics = model.data;
		
		[[NSUserDefaults standardUserDefaults] setObject: launchPics.firstObject.pic forKey:@"launchImage"];
		
	}];
	
	[self.view addSubview:imageView];
	[imageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.view);
	}];
	NSString * picURL = [[NSUserDefaults standardUserDefaults]  valueForKey:@"launchImage"];
	[imageView sd_setImageWithURL: [NSURL URLWithString:picURL]];
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		UIWindow * window = UIApplication.sharedApplication.keyWindow;
		UGTabbarController * tabbar = [[UGTabbarController alloc] init];
	    tabbar.delegate = self;
		window.rootViewController = tabbar;

	});
	
}
 

#pragma mark - UITabBarControllerDelegate

/// 切换
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    CMMETHOD_BEGIN_O(viewController.restorationIdentifier);
    
    BOOL isLogin = UGLoginIsAuthorized();
 
    if (isLogin) {
         UGNavigationController *navi = (UGNavigationController *)viewController;
        if ([navi.viewControllers.firstObject isKindOfClass:[UGChatViewController class]]) {
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            NSString *colorStr = [[UGSkinManagers shareInstance] setChatNavbgStringColor];
            NSLog(@"url = %@",[NSString stringWithFormat:@"%@%@%@&loginsessid=%@&color=%@",baseServerUrl,newChatRoomUrl,[UGUserModel currentUser].token,[UGUserModel currentUser].sessid,colorStr]);
            appDelegate.tabbar.qdwebVC.url = [NSString stringWithFormat:@"%@%@%@&loginsessid=%@&color=%@",baseServerUrl,newChatRoomUrl,[UGUserModel currentUser].token,[UGUserModel currentUser].sessid,colorStr];
        }
        return YES;
    }else {
        
        UGNavigationController *navi = (UGNavigationController *)viewController;
        if ([navi.viewControllers.firstObject isKindOfClass:[UGMineSkinViewController class]] ||
            [navi.viewControllers.firstObject isKindOfClass:[UGLotteryHomeController class]] ||
            [navi.viewControllers.firstObject isKindOfClass:[UGChatViewController class]]
            ||[navi.viewControllers.firstObject isKindOfClass:[UGChangLongController class]]
            ||[navi.viewControllers.firstObject isKindOfClass:[UGYYLotteryHomeViewController class]]
            ||[navi.viewControllers.firstObject isKindOfClass:[UGPromotionsController class]]
            ||[navi.viewControllers.firstObject isKindOfClass:[UGLotteryRecordController class]]
            ||[navi.viewControllers.firstObject isKindOfClass:[UGMissionCenterViewController class]]
            ||[navi.viewControllers.firstObject isKindOfClass:[UGSecurityCenterViewController class]]
            ||[navi.viewControllers.firstObject isKindOfClass:[UGMailBoxTableViewController class]]
            ||[navi.viewControllers.firstObject isKindOfClass:[UGBalanceConversionController class]]
            ||[navi.viewControllers.firstObject isKindOfClass:[UGBankCardInfoController class]]
            ||[navi.viewControllers.firstObject isKindOfClass:[UGYubaoViewController class]]
            ||[navi.viewControllers.firstObject isKindOfClass:[UGSigInCodeViewController class]]
            ||[navi.viewControllers.firstObject isKindOfClass:[UGPromotionIncomeController class]]
      
            
            ) {
            [QDAlertView showWithTitle:@"温馨提示" message:@"您还未登录" cancelButtonTitle:@"取消" otherButtonTitle:@"马上登录" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex) {
                    
                    UGLoginAuthorize(^(BOOL isFinish) {
                        if (!isFinish) {
                            return ;
                        }
//                        if ([navi.viewControllers.firstObject isKindOfClass:[UGChatsViewController class]]) {
//                            QDWebViewController *webVC = [[QDWebViewController alloc] init];
//                             webVC.navigationItem.title = @"聊天室";
//                            webVC.urlString = [NSString stringWithFormat:@"%@/dist/index.html#/chatRoomList",baseServerUrl];
//                           [tabBarController showViewControllerInSelected:webVC animated:YES];
//                            return;
//                        }else {
                        
                            [tabBarController setSelectedViewController:viewController];
//                        }
                        
                    });
                }
            }];
            
            return NO;
        }
        
    }
    return YES;
}


@end
@implementation LaunchPageModel



@end
