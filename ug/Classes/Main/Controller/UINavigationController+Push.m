//
//  UINavigationController+Push.m
//  ug
//
//  Created by xionghx on 2020/1/5.
//  Copyright © 2020 ug. All rights reserved.
//

#import "UINavigationController+Push.h"
#import "UGBMMemberCenterViewController.h"
#import "UGBMBrowseViewController.h"

// ViewController
#import "UGCommonLotteryController.h"
#import "UGChangLongController.h"
#import "UGFundsViewController.h"
#import "UGAgentViewController.h"
#import "UGPromotionIncomeController.h"
#import "UGBetRecordViewController.h"
#import "UGGameListViewController.h"
#import "UGDocumentVC.h"
#import "UGBMRegisterViewController.h"           // GPK版注册
#import "UGBMLoginViewController.h"              // GPK版登录
#import "UGLoginViewController.h"                // 模板登录
#import "UGRegisterViewController.h"             // 模板注册
#import "UGBMpreferentialViewController.h"       // GPK版优惠专区
#import "UGPromotionsController.h"               // 模板优惠专区
#import "UGBMLotteryHomeViewController.h"        // GPK版购彩大厅
#import "UGYYLotteryHomeViewController.h"        // 购彩大厅
#import "UGMailBoxTableViewController.h"         // 站内信
#import "UGSigInCodeViewController.h"            // 每日签到
#import "SLWebViewController.h"
#import "UGSecurityCenterViewController.h"  // 安全中心
#import "UGRealBetRecordViewController.h"   // 其他注单记录
#import "UGMosaicGoldViewController.h"    // 活动彩金
#import "UGLHMineViewController.h"    // 六合 我的
#import "UGMineSkinViewController.h"    //  我的
#import "LotteryBetAndChatVC.h"
#import "UGYYLotteryHomeViewController.h"     //  游戏大厅
#import "MyPromotionVC.h"
#import "UGLotteryRecordController.h"
#import "UGHomeViewController.h"
#import "RedEnvelopeVCViewController.h"
#import "UGLotteryRulesView.h"
// Tools
#import "UGAppVersionManager.h"
@implementation UINavigationController (Push)

static NSMutableArray <GameModel *> *__browsingHistoryArray = nil;

+ (NSMutableArray<GameModel *> *)browsingHistoryArray {
    return __browsingHistoryArray;
}
+ (instancetype)current {
	UIViewController * rootVC = UIApplication.sharedApplication.delegate.window.rootViewController;
	if ([rootVC isKindOfClass: [UITabBarController class]]) {
		return ((UINavigationController *)((UITabBarController *)rootVC).selectedViewController);
	} else if ([rootVC isKindOfClass:[UINavigationController class]]) {
		return (UINavigationController *)rootVC;
	}
	return nil;
	
}
+ (void)load {
    // 获取哪个类下的导航条,管理自己下导航条
//    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedIn:self, nil];
//
//    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self.topViewController preferredStatusBarStyle];
}

- (UIView *)topView {
    return NavController1.viewControllers.lastObject.view;
}
- (UIViewController *)firstVC {
    return NavController1.viewControllers.firstObject;
}

- (UIViewController *)lastVC{
    return NavController1.viewControllers.lastObject;
}




- (void)getGotoGameUrl:(GameModel *)game {
    if (!UGLoginIsAuthorized()) {
        [[NSNotificationCenter defaultCenter] postNotificationName:UGNotificationShowLoginView object:nil];
        return;
    }
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"id":[NSString stringWithFormat:@"%ld",(long)game.subId],
//                             @"game":game.gameCode
                             };
    [SVProgressHUD showWithStatus:nil];
    WeakSelf;
    [CMNetwork getGotoGameUrlWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            [SVProgressHUD dismiss];
            QDWebViewController *qdwebVC = [[QDWebViewController alloc] init];

            NSLog(@"网络链接：model.data = %@",model.data);
            qdwebVC.urlString = [CMNetwork encryptionCheckSignForURL:model.data];
            qdwebVC.enterGame = YES;
            [weakSelf.navigationController pushViewController:qdwebVC  animated:YES];
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }];
}
#pragma mark - 根据Model快捷跳转函数

- (BOOL)pushViewControllerWithGameModel:(GameModel *)model {
    
    NSLog(@"model.gameCode= %@",model.gameCode);
    
    if (![CMCommon stringIsNull:model.gameCode]) {
        if (![model.gameCode isEqualToString:@"-1"]) {
            NSLog(@"model.gameCode========== %@",model.gameCode);
            [self getGotoGameUrl:model];
        }
    }
    
    if (model.game_id) {
        model.gameId = model.game_id;
    }
    
    // 去资料页
    if ([model.docType intValue] == 1) {
        [NavController1 pushViewController:[[UGDocumentVC alloc] initWithModel:model] animated:true];
        return true;
    }
    // 去二级游戏列表
    if (model.isPopup) {
        UGGameListViewController *gameListVC = [[UGGameListViewController alloc] init];
        gameListVC.game = model;
        [NavController1 pushViewController:gameListVC animated:YES];
        return true;
    }
    // 去聊天室
    if (model.seriesId == 9) {
        // 去聊天室页
        UGChatViewController *vc = [[UGChatViewController alloc] init];
        vc.roomId = @(model.subId).stringValue;
        vc.showChangeRoomTitle = true;
        vc.hideHead = true;
        vc.title = model.title.length ? model.title : model.name;
        [NavController1 pushViewController:vc animated:true];
        return true;
    }
    

    // 去彩票下注页、或第三方游戏页、或功能页
    BOOL ret = [NavController1 pushViewControllerWithLinkCategory:model.seriesId linkPosition:model.subId gameCode:model.gameCode gameModel:model];
    
    if (!ret) {
        // 去外部链接
        if (model.url.length) {
//            SLWebViewController *vc = [SLWebViewController new];
//            vc.urlStr = model.url;
//            [NavController1 pushViewController:vc animated:true];
//            model.url = @"https://dsjh888.com/";
            NSLog(@"model.url= %@",model.url);
            [CMCommon goTGWebUrl:model.url title:@""];
            return true;
        }
    } else {
        return true;
    }
    return false;
}

- (BOOL)pushViewControllerWithNextIssueModel:(UGNextIssueModel *)model isChatRoom:(BOOL) isChatRoom{
    
    
    if (!model) {
        model = [CMCommon getBetAndChatModel:model];
    }
    
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
                           @"dlt"   :@"UGBJPK10LotteryController",  // 大乐透
                           @"ofclvn_hochiminhvip"   :@"UGYNLotteryController",  // 越南
                           @"ofclvn_haboivip"   :@"UGYNLotteryController",  // 河内
    };
    
    NSString *vcName = dict[model.gameType];
    if (!vcName.length) {
        return false;
    }
    
   //聊天室数据有
//    [NSThread sleepForTimeInterval:1.0];
//    NSLog(@"SysChatRoom.chatRoomAry = %@",SysChatRoom.chatRoomAry);

    
    
    if ([CMCommon getRoomMode:model.gameId] ) {
        return [self goLotteryBetAndChatVC:model isChatRoom:isChatRoom];
    } else {
        return [self goUGCommonLotteryController:model vcName:vcName];
    }
   
}

 // 去（彩票下注+聊天室）集合页
-(BOOL)goLotteryBetAndChatVC:(UGNextIssueModel *)model isChatRoom:(BOOL) isChatRoom {
     // 去（彩票下注+聊天室）集合页
        {
            LotteryBetAndChatVC *vc = [LotteryBetAndChatVC new];

            vc.selectChat = isChatRoom;
            vc.nim = model;
                      // 隐藏底部条
            vc.hidesBottomBarWhenPushed = YES;

            // Push
            if ([UGTabbarController canPushToViewController:vc]) {
                [NavController1 setViewControllers:({
                    NSMutableArray *vcs = NavController1.viewControllers.mutableCopy;
                    for (UIViewController *vc in NavController1.viewControllers) {
                        if ([vc isKindOfClass:[UGCommonLotteryController class]] || [vc isKindOfClass:[LotteryBetAndChatVC class]]) {
                            [vcs removeObject:vc];
                        }
                    }
                    [vcs addObject:vc];
                    vcs;
                }) animated:YES];
            }
            return true;
        }
}

 // 去（彩票下注页
-(BOOL )goUGCommonLotteryController:(UGNextIssueModel *)model vcName :(NSString *)vcName{
    // 去彩票下注页
       {
           UGCommonLotteryController *vc = _LoadVC_from_storyboard_(vcName);
           //         UGCommonLotteryController *vc = _LoadVC_from_storyboard_(@"UGHKLHCLotteryController");
           if (model.isInstant) {
               vc.shoulHideHeader = true;
           }
           vc.nextIssueModel = model;
           vc.gameId = model.gameId;
           vc.gotoTabBlock = ^{
               TabBarController1.selectedIndex = 0;
           };
  
           vc.hidesBottomBarWhenPushed = YES;

           
           // Push
           if ([UGTabbarController canPushToViewController:vc]) {
               [NavController1 setViewControllers:({
                   NSMutableArray *vcs = NavController1.viewControllers.mutableCopy;
                   for (UIViewController *vc in NavController1.viewControllers) {
                       if ([vc isKindOfClass:[UGCommonLotteryController class]]) {
                           [vcs removeObject:vc];
                       }
                   }
                   [vcs addObject:vc];
                   vcs;
               }) animated:YES];
           }
           
           dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC));

//           dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//               [[Global getInstanse] setHideTabBar:NO];
//           });
//           
           return true;
       }
}

- (BOOL)pushViewControllerWithLinkCategory:(NSInteger)linkCategory linkPosition:(NSInteger)linkPosition {
    return [self pushViewControllerWithLinkCategory:linkCategory linkPosition:linkPosition gameCode:nil gameModel:nil];
}

- (BOOL)pushViewControllerWithLinkCategory:(NSInteger)linkCategory linkPosition:(NSInteger)linkPosition gameCode:(nullable NSString *)gameCode gameModel:(GameModel *)model{
    if (!linkCategory) {
        return false;
    }
    
    // 去rn页面
    RnPageModel *rpm = [[APP.rnPageInfos objectsWithValue:@(linkCategory) keyPath:@"linkCategory"] objectWithValue:@(linkPosition) keyPath:@"linkPosition"];
    if (rpm) {
        [NavController1 pushViewController:[ReactNativeVC reactNativeWithRPM:rpm params:nil] animated:true];
        return true;
    }
    
    // linkCategory ： 1=彩票游戏；2=真人视讯；3=捕鱼游戏；4=电子游戏；5=棋牌游戏；6=体育赛事；7=导航链接；8=电竞游戏；9=聊天室；10=手机资料栏目
    if (linkCategory == 9) {
        // 去聊天室页
        UGChatViewController *vc = [[UGChatViewController alloc] init];
        vc.roomId = @(linkPosition).stringValue;
        vc.showChangeRoomTitle = true;
        vc.hideHead = true;
        vc.title = @"聊天室";
        [NavController1 pushViewController:vc animated:true];
        return true;
    }
    
    if (linkCategory == 1) {
        // 去彩票下注页
        return [NavController1 pushViewControllerWithNextIssueModel:[UGNextIssueModel modelWithGameId:@(linkPosition).stringValue] isChatRoom:NO];
    }
    
    if (linkCategory == 10) {
        // 去手机资料栏目
        NSLog(@"model = %@",model);
        if (model.list) {
     
           [NavController1 pushViewController:[[UGDocumentVC alloc] initWithModel:model.list] animated:true];
            
            return true;
            
        }
       
    }
    if (linkCategory == 11) {
        // 去注单信息
        switch (linkPosition) {
            case 1: {
                // 彩票注单
                [NavController1 pushViewController:[UGBetRecordViewController new] animated:YES];
                break;
            }
            case 2: {
                // 真人注单
                UGRealBetRecordViewController *betRecordVC = _LoadVC_from_storyboard_(@"UGRealBetRecordViewController");
                betRecordVC.gameType = @"real";
                [NavController1 pushViewController:betRecordVC animated:YES];
                break;
            }
            case 3: {
                // 棋牌注单
                UGRealBetRecordViewController *betRecordVC = _LoadVC_from_storyboard_(@"UGRealBetRecordViewController");
                betRecordVC.gameType = @"card";
                [NavController1 pushViewController:betRecordVC animated:YES];
                break;
            }
            case 4: {
                // 电子注单
                UGRealBetRecordViewController *betRecordVC = _LoadVC_from_storyboard_(@"UGRealBetRecordViewController");
                betRecordVC.gameType = @"game";
                [NavController1 pushViewController:betRecordVC animated:YES];
                
                break;
            }
            case 5: {
                // 体育注单
                UGRealBetRecordViewController *betRecordVC = _LoadVC_from_storyboard_(@"UGRealBetRecordViewController");
                betRecordVC.gameType = @"sport";
                [NavController1 pushViewController:betRecordVC animated:YES];
                break;
            }
            case 6: {
                // 体育注单
                UGRealBetRecordViewController *betRecordVC = _LoadVC_from_storyboard_(@"UGRealBetRecordViewController");
                betRecordVC.gameType = @"fish";
                [NavController1 pushViewController:betRecordVC animated:YES];
                break;
            }
            case 7: {
                // 电竞注单
                UGRealBetRecordViewController *betRecordVC = _LoadVC_from_storyboard_(@"UGRealBetRecordViewController");
                betRecordVC.gameType = @"esport";
                [NavController1 pushViewController:betRecordVC animated:YES];
                break;
            }
            default: {
                return false;
            }
        }
        return true;
    }

    
    if (linkCategory != 7  ) {
        // 去第三方游戏页面
        if (!UGLoginIsAuthorized()) {
            [[NSNotificationCenter defaultCenter] postNotificationName:UGNotificationShowLoginView object:nil];
            return true;
        }
        NSDictionary *params = @{@"token":UserI.sessid,
                                 @"id":@(linkPosition).stringValue,
//                                 @"game":gameCode,
        };
        [SVProgressHUD showWithStatus:nil];
      
        [CMNetwork getGotoGameUrlWithParams:params completion:^(CMResult<id> *model, NSError *err) {
            [CMResult processWithResult:model success:^{
                [SVProgressHUD dismiss];
                dispatch_async(dispatch_get_main_queue(), ^{
                    QDWebViewController *qdwebVC = [[QDWebViewController alloc] init];
                    NSLog(@"网络链接：model.data = %@", model.data);
                    qdwebVC.urlString = [CMNetwork encryptionCheckSignForURL:model.data];
                    
                   
//                    qdwebVC.urlString = [qdwebVC.urlString stringByReplacingOccurrencesOfString:@"http://2044953.com" withString:@"https://2044953.com:8888"];
                    NSLog(@"网络链接：model.data = %@", qdwebVC.urlString);
    
                    qdwebVC.enterGame = YES;
                    [NavController1 pushViewController:qdwebVC animated:YES];
                });
            } failure:^(id msg) {
                [SVProgressHUD showErrorWithStatus:msg];
            }];
        }];
        return true;
    }
    
    // 去功能页面
    switch (linkPosition) {
        case 1: {
            // 资金管理
            [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGFundsViewController") animated:true];
            break;
        }
        case 2: {
            // APP下载
            [[UGAppVersionManager shareInstance] updateVersionApi:true];
            break;
        }
        case 3: {
            // 聊天室
            UGChatViewController *vc = [[UGChatViewController alloc] init];
            vc.showChangeRoomTitle = true;
            vc.title = @"聊天室";
            [NavController1 pushViewController:vc animated:YES];
            break;
        }
        case 4: {
            // 在线客服

            [NavController1 pushVCWithUserCenterItemType:UCI_在线客服];

            break;
        }
        case 5: {
            // 长龙助手
            [NavController1 pushViewController:[UGChangLongController new] animated:YES];
            break;
        }
        case 6: {
            // 推广收益
            if (UserI.isTest) {
                [NavController1 pushViewController:[UGPromotionIncomeController new] animated:YES];
            } else {
                if (!UGLoginIsAuthorized()) {
                    SANotificationEventPost(UGNotificationShowLoginView, nil);
                    return true;
                }
                [SVProgressHUD showWithStatus:nil];
            
                [CMNetwork teamAgentApplyInfoWithParams:@{@"token":[UGUserModel currentUser].sessid} completion:^(CMResult<id> *model, NSError *err) {
                    [CMResult processWithResult:model success:^{
                        [SVProgressHUD dismiss];
                        UGagentApplyInfo *obj  = (UGagentApplyInfo *)model.data;
                        int intStatus = obj.reviewStatus.intValue;
                        
                        //0 未提交  1 待审核  2 审核通过 3 审核拒绝
                        if (intStatus == 2) {
                            [NavController1 pushViewController:[UGPromotionIncomeController new] animated:YES];
                        } else {
                            if (![SysConf.agent_m_apply isEqualToString:@"1"]) {
                                [HUDHelper showMsg:@"在线注册代理已关闭"];
                                return ;
                            }
                            UGAgentViewController *vc = [[UGAgentViewController alloc] init];
                            vc.item = obj;
                            [NavController1 pushViewController:vc animated:YES];
                        }
                    } failure:^(id msg) {
                        [SVProgressHUD showErrorWithStatus:msg];
                    }];
                }];
            }
            break;
        }
        case 7: {
            // 开奖网
//            TGWebViewController *sf = [[TGWebViewController alloc] initWithURL:[NSURL URLWithString:_NSString(@"%@/Open_prize/index.php", APP.Host)]];

            TGWebViewController *webViewVC = [[TGWebViewController alloc] init];
            webViewVC.允许未登录访问 = true;
            webViewVC.允许游客访问 = true;
            webViewVC.url = _NSString(@"%@/Open_prize/index.php", APP.Host);
            webViewVC.webTitle = @"开奖网";
            [NavController1 pushViewController:webViewVC animated:YES];
            
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_NSString(@"%@/Open_prize/index.php", APP.Host)]];
            break;
        }
        case 8: {
            // 利息宝
            [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGYubaoViewController")  animated:YES];
            break;
        }
        case 9: {
            // 优惠活动
            [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGPromotionsController") animated:YES];
            break;
        }
        case 10: {
            // 注单记录
            UGBetRecordViewController *vc = [[UGBetRecordViewController alloc] init];
            [NavController1 pushViewController:vc animated:true];
            break;
        }
        case 11: {
            // QQ客服
            if (SysConf.appPopupQqImg.length) {
                __block UIView *__v = _LoadView_from_nib_(@"客服AlertView");
                __v.frame = APP.Bounds;
                FastSubViewCode(__v);
                subLabel(@"微信号Label").text = @"QQ客服";
                if (SysConf.appPopupQqNum.length) {
                    subLabel(@"微信号Label").text = _NSString(@"QQ客服(%@)", SysConf.appPopupQqNum);
                }
                [subImageView(@"二维码ImageView") sd_setImageWithURL:[NSURL URLWithString:SysConf.appPopupQqImg] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    if (image) {
                        subImageView(@"二维码ImageView").cc_constraints.height.constant = image.height/image.width * 280;
                    }
                }];
                [subButton(@"确定Button") addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
                    [__v removeFromSuperview];
                    __v = nil;
                }];
                [APP.Window addSubview:__v];
            }
            else {
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_NSString(@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web", SysConf.serviceQQ1)]];
                [CMCommon goQQ: SysConf.serviceQQ1];
            }
            break;
        }
        case 12: {
            // 微信客服
            __block UIView *__v = _LoadView_from_nib_(@"客服AlertView");
            __v.frame = APP.Bounds;
            FastSubViewCode(__v);
            subLabel(@"微信号Label").text = @"微信客服";
            if (SysConf.appPopupWechatNum.length) {
                subLabel(@"微信号Label").text = _NSString(@"微信客服(%@)", SysConf.appPopupWechatNum);
            }
            [subImageView(@"二维码ImageView") sd_setImageWithURL:[NSURL URLWithString:SysConf.appPopupWechatImg] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (image) {
                    subImageView(@"二维码ImageView").cc_constraints.height.constant = image.height/image.width * 280;
                }
            }];
            [subButton(@"确定Button") addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
                [__v removeFromSuperview];
                __v = nil;
            }];
            [APP.Window addSubview:__v];
            break;
        }
        case 13: {
            // 任务大厅
            [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGMissionCenterViewController") animated:true];
            break;
        }
        case 14: {
            // 站内信
            [NavController1 pushViewController:[[UGMailBoxTableViewController alloc] init] animated:true];
            break;
        }
        case 15: {
            // 签到
            [NavController1 pushViewController:[UGSigInCodeViewController new] animated:YES];
            break;
        }
        case 16: {
            // 投诉中心
            [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGFeedBackController") animated:YES];
            break;
        }
        case 17: {
            // 全民竞猜
            [SVProgressHUD showInfoWithStatus:@"敬请期待"];
            break;
        }
        case 18: {
            // 活动彩金
            [NavController1 pushViewController:[UGMosaicGoldViewController new] animated:YES];
            break;
        }
        case 19: {
            // 游戏大厅
            UGYYLotteryHomeViewController*vc = [[UGYYLotteryHomeViewController alloc] init];
            [NavController1 pushViewController:vc animated:YES];
            break;
        }
        case 20: {
            //会员中心
            UGMineSkinViewController *vc = [UGMineSkinViewController new];
            [NavController1 pushViewController:vc animated:true];
            break;
        }
        case 21: {
            //21' => '充值',
            UGFundsViewController *fundsVC = _LoadVC_from_storyboard_(@"UGFundsViewController");
            fundsVC.selectIndex = 0;
            [NavController1 pushViewController:fundsVC animated:true];
            break;
        }
        case 22: {
            //22' => '提现',
            UGFundsViewController *fundsVC = _LoadVC_from_storyboard_(@"UGFundsViewController");
            fundsVC.selectIndex = 1;
            [NavController1 pushViewController:fundsVC animated:true];
            break;
        }
        case 23: {
            //23' => '额度转换',
            [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGBalanceConversionController")  animated:YES];
            break;
        }
        case 24: {
            //24' => '即时注单',
            UGBetRecordViewController *betRecordVC = [[UGBetRecordViewController alloc] init];
            betRecordVC.selectIndex = 2;
            [NavController1 pushViewController:betRecordVC animated:true];
            break;
        }
        case 25: {
            //25' => '今日输赢',
            UGBetRecordViewController *betRecordVC = [[UGBetRecordViewController alloc] init];
            [NavController1 pushViewController:betRecordVC animated:true];

            break;
        }
        case 26: {
            //26' => '开奖结果',

            UGLotteryRecordController *recordVC = _LoadVC_from_storyboard_(@"UGLotteryRecordController");
            if ([CMCommon stringIsNull:model.realGameId]) {
                recordVC.gameId = model.realGameId;
            }
            [NavController1 pushViewController:recordVC animated:true];
    
          
    
            break;
        }
        case 27: {
            //27' => '当前版本号',
            [[UGAppVersionManager shareInstance] updateVersionApi:true];
            break;
        }
        case 28: {
            //21' => '资金明细',
//            [SVProgressHUD showInfoWithStatus:@"敬请期待"];
            UGFundsViewController *fundsVC = _LoadVC_from_storyboard_(@"UGFundsViewController");
            fundsVC.selectIndex = 4;
            [NavController1 pushViewController:fundsVC animated:YES];
            return true;
            
            break;
        }
        case 29: {
            //29' => '回到电脑版',
            TGWebViewController *qdwebVC = [[TGWebViewController alloc] init];
            qdwebVC.url = pcUrl;
            qdwebVC.webTitle = UGSystemConfigModel.currentConfig.webName;
            [NavController1 pushViewController:qdwebVC animated:YES];
            break;
        }
        case 30: {
            //30' => '返回首页',
            
            break;
        }
        case 31: {
            //31' => '退出登录',
            [QDAlertView showWithTitle:@"温馨提示" message:@"确定退出账号" cancelButtonTitle:@"取消" otherButtonTitle:@"确定" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [CMNetwork userLogoutWithParams:@{@"token":[UGUserModel currentUser].sessid} completion:nil];
                        UGUserModel.currentUser = nil;
                        SANotificationEventPost(UGNotificationUserLogout, nil);
                    });
                }
            }];
            break;
        }
        case 32: {
            //32' => '投注记录',
            [NavController1 pushViewController:[UGBetRecordViewController new] animated:true];
            break;
        }
        case 33: {
            //33' => '彩种规则',
            if (![CMCommon stringIsNull:model.realGameId]) {
                UGLotteryRulesView *rulesView = [[UGLotteryRulesView alloc] initWithFrame:CGRectMake(30, 120, UGScreenW - 60, UGScerrnH - 230)];
                rulesView.gameId = model.realGameId;
                [rulesView show];
            } else {
                 [SVProgressHUD showInfoWithStatus:@"请到彩种里面查看"];
            }
  
            break;
        }
        case 36: {
            //34' => '红包记录',
            RedEnvelopeVCViewController *recordVC = _LoadVC_from_storyboard_(@"RedEnvelopeVCViewController");
            recordVC.type = 1;
            [NavController1 pushViewController:recordVC animated:true];
            break;
        }
        case 37: {
            //37' => '扫雷记录',
            RedEnvelopeVCViewController *recordVC = _LoadVC_from_storyboard_(@"RedEnvelopeVCViewController");
            recordVC.type = 2;
            [NavController1 pushViewController:recordVC animated:true];
            break;
        }
        default: {
            return false;
        }
    }
    return true;
}

- (BOOL)pushVCWithUserCenterItemType:(UserCenterItemType)uciType {
    RnPageModel *rpm = [APP.rnPageInfos objectWithValue:@(uciType) keyPath:@"userCenterItemCode"];
    if (rpm) {
        [NavController1 pushViewController:[ReactNativeVC reactNativeWithRPM:rpm params:nil] animated:true];
        return true;
    }
    
    switch (uciType) {
        case UCI_在线客服: {
            NSString *urlStr = [SysConf.zxkfUrl stringByTrim];
            if (!urlStr.length) {
                return true;
            }
            SLWebViewController *webViewVC = [SLWebViewController new];
            NSURL *url = [NSURL URLWithString:urlStr];
            if (!url.host.length) {
                urlStr = _NSString(@"%@%@", APP.Host, SysConf.zxkfUrl);
            }
            else if (!url.scheme.length) {
                urlStr = _NSString(@"http://%@", SysConf.zxkfUrl);
            }
            webViewVC.isCustomerService = YES;
            webViewVC.urlStr = urlStr;
            [NavController1 pushViewController:webViewVC animated:YES];
            return true;
        }
        case UCI_额度转换: {
            [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGBalanceConversionController")  animated:YES];
            return true;
        }
        case UCI_开奖走势: {
            [HUDHelper showMsg:@"敬请期待"];
            return true;
        }
        case UCI_开奖网: {
            [CMCommon goSLWebUrl:lotteryUrl];
            return true;
        }
        case UCI_全民竞猜: {
            [HUDHelper showMsg:@"敬请期待"];
            return true;
        }
        case UCI_存款: {
            UGFundsViewController *fundsVC = _LoadVC_from_storyboard_(@"UGFundsViewController");
            fundsVC.selectIndex = 0;
            [NavController1 pushViewController:fundsVC animated:YES];
            return true;
        }
        case UCI_取款: {
            UGFundsViewController *fundsVC = _LoadVC_from_storyboard_(@"UGFundsViewController");
            fundsVC.selectIndex = 1;
            [NavController1 pushViewController:fundsVC animated:YES];
            return true;
        }
        case UCI_银行卡管理: {
            if (UserI.hasFundPwd) {
                [NavController1 pushViewController:_LoadVC_from_storyboard_(@"WithdrawalAccountListVC") animated:true];
            } else {
                [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGSetupPayPwdController") animated:true];
            }
            return true;
        }
        case UCI_利息宝: {
            [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGYubaoViewController")  animated:YES];
            return true;
        }
        case UCI_推荐收益: {
			
# if DEBUG
			MyPromotionVC *vc = [[UIStoryboard storyboardWithName:@"MyPromotion" bundle:nil] instantiateInitialViewController];
			[[UINavigationController current] pushViewController:vc animated:true];
			return true;
# endif
            if (UserI.isTest) {
                [NavController1 pushViewController:[UGPromotionIncomeController new] animated:YES];
            } else {
                [SVProgressHUD showWithStatus:nil];
                [CMNetwork teamAgentApplyInfoWithParams:@{@"token":[UGUserModel currentUser].sessid} completion:^(CMResult<id> *model, NSError *err) {
                    [CMResult processWithResult:model success:^{
                        [SVProgressHUD dismiss];
                        UGagentApplyInfo *obj  = (UGagentApplyInfo *)model.data;
                        int intStatus = obj.reviewStatus.intValue;
                        
                        //0 未提交  1 待审核  2 审核通过 3 审核拒绝
                        if (intStatus == 2) {
                            [NavController1 pushViewController:[UGPromotionIncomeController new] animated:YES];
                        } else {
                            if (![SysConf.agent_m_apply isEqualToString:@"1"]) {
                                [HUDHelper showMsg:@"在线注册代理已关闭"];
                                return ;
                            }
                            UGAgentViewController *vc = [[UGAgentViewController alloc] init];
                            vc.item = obj;
                            [NavController1 pushViewController:vc animated:YES];
                        }
                    } failure:^(id msg) {
                        [SVProgressHUD showErrorWithStatus:msg];
                    }];
                }];
            }
            return true;
        }
        case UCI_安全中心: {
            [NavController1 pushViewController:[UGSecurityCenterViewController new] animated:YES];
            return true;
        }
        case UCI_站内信: {
            [NavController1 pushViewController:[[UGMailBoxTableViewController alloc] init] animated:YES];
            return true;
        }
        case UCI_彩票注单记录: {
            [NavController1 pushViewController:[UGBetRecordViewController new] animated:YES];
            return true;
        }
        case UCI_其他注单记录: {
            UGRealBetRecordViewController *betRecordVC = _LoadVC_from_storyboard_(@"UGRealBetRecordViewController");
            betRecordVC.gameType = @"real";
            [NavController1 pushViewController:betRecordVC animated:YES];
            return true;
        }
        case UCI_个人信息: {
            [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGUserInfoViewController") animated:YES];
            return true;
        }
        case UCI_建议反馈: {
            [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGFeedBackController") animated:YES];
            return true;
        }
        case UCI_活动彩金: {
            [NavController1 pushViewController:[UGMosaicGoldViewController new] animated:YES];
            return true;
        }
        case UCI_长龙助手: {
            [NavController1 pushViewController:[UGChangLongController new] animated:YES];
            return true;
        }
        case UCI_任务中心: {
            [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGMissionCenterViewController")  animated:YES];
            return true;
        }
        case UCI_QQ客服: {
            //从系统配置中获得QQ号，==》弹窗 ==》点击调起QQ
            if ([CMCommon arryIsNull:SysConf.qqs]) {
                [CMCommon showTitle:@"暂无QQ客服,敬请期待"];
                return true;
            }
            NSMutableArray *titles = @[].mutableCopy;
            for (int i = 0 ;i <SysConf.qqs.count ;i++) {
                NSString *ss = [SysConf.qqs objectAtIndex:i];
                [titles addObject:[NSString stringWithFormat:@"QQ客服%d: %@",i+1,ss]];
            }
            UIAlertController *ac = [AlertHelper showAlertView:nil msg:@"请选择QQ客服" btnTitles:[titles arrayByAddingObject:@"取消"]];
            for (int i = 0 ;i <SysConf.qqs.count ;i++) {
                 NSString *ss = [SysConf.qqs objectAtIndex:i];
                NSString *t = [NSString stringWithFormat:@"QQ客服%d: %@",i+1,ss];
                [ac setActionAtTitle:t handler:^(UIAlertAction *aa) {
                    NSLog(@"ss = %@",ss);
                    [CMCommon goQQ:ss];
                }];
            }
            return true;
        }
        case UCI_聊天室: {
            [NavController1 pushViewControllerWithNextIssueModel:nil isChatRoom:YES];
            return true;
        }
            
        default:
            return false;
    }
}

@end
