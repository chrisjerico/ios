//
//  UGSystemConfigModel.m
//  ug
//
//  Created by ug on 2019/7/23.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGSystemConfigModel.h"

#import "UGLotteryHomeController.h"         // 购彩大厅
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
#import "TKLMainViewController.h"           // 额度转换天空蓝
#import "UGAgentViewController.h"           // 申请代理
#import "LineConversionHeaderVC.h"          // 额度转换 1
#import "LotteryBetAndChatVC.h"             // 聊天室
#import "OnlineServiceViewController.h"     // 在线客服
#import "UGBetRecordViewController.h"       // 未结算
#import "UGMosaicGoldViewController.h"      // 活动彩金
#import "NewLotteryHomeViewController.h"    // 新彩票大厅
#import "TKLMoneyViewController.h"          // 天空蓝 资金管理
#import "ChatMainViewController.h"          // 聊天室列表
#import "UGYYLotterySecondHomeViewController.h"
#import "UGBMMemberCenterViewController.h"  //
#import "UGLHMineViewController.h"  //
#import "UGBMpreferentialViewController.h"
#import "UGBMLotteryHomeViewController.h"
#import "JS_MineVC.h"
#import "HSC_MineVC.h"

//#import "XBJ_HomeVC.h"


#define filePath  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"UGSystemConfigModel"]

UGSystemConfigModel *currentConfig = nil;

@implementation LHPriceModel
@end

@implementation loginNoticeModel
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"switch":@"loginNotice_switch",@"text":@"loginNotice_text"}];
}
@end

@interface LHStayTunedVC : UIViewController
@end
@implementation LHStayTunedVC
@end





@interface UGUserCenterItem ()
//@property (nonatomic) NSString *lhImgName;    /**<   六合模版使用的本地图标 */
@property (nonatomic, readwrite) NSString *bmImgName;
@property (nonatomic, readwrite) NSString *defaultImgName;
@end
@implementation UGUserCenterItem

+ (NSArray <UGUserCenterItem *>*)allItems {
    static NSArray *_items = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UGUserCenterItem *(^item)(NSString *, NSString *, NSString *, UserCenterItemType, NSString *) = ^UGUserCenterItem *(NSString *bmImgName, NSString *lhImgName, NSString *defaultImgName, UserCenterItemType type, NSString *name) {
            UGUserCenterItem *uci = [UGUserCenterItem new];
            uci.name = name;
            [uci setValue:@(type) forKey:@"_code"];
            uci.lhImgName = lhImgName;
            uci.bmImgName = bmImgName;
            uci.defaultImgName = defaultImgName;
            return uci;
        };
        _items =@[
            item(@"chongzhi",               @"LH_menu-cz",          @"chongzhi",                UCI_存款,         @"存款"),
            item(@"chongzhi",               @"LH_menu-qk",          @"tixian",                  UCI_取款,         @"取款"),
            item(@"yinhangqia",             @"LH_menu-account",     @"yinhangqia",              UCI_银行卡管理,     @"提款账户"),
            item(@"lixibao",                @"LH_syb3",             @"lixibao",                 UCI_利息宝,        @"利息宝"),
            item(@"shouyi1sel",             @"LH_task",             @"shouyi1sel",              UCI_推荐收益,      @"推荐收益"),
            item(@"zdgl",                   @"LH_menu-rule",        @"zdgl",                    UCI_彩票注单记录,   @"彩票注单记录"),
            item(@"zdgl",                   @"LH_menu-rule",        @"zdgl",                    UCI_其他注单记录,   @"其他注单记录"),
            item(@"change",                 @"LH_menu-transfer",    @"change",                  UCI_额度转换,      @"额度转换"),
            item(@"zhanneixin",             @"LH_menu-notice",      @"zhanneixin",              UCI_站内信,        @"站内信"),
            item(@"ziyuan",                 @"LH_menu-password",    @"ziyuan",                  UCI_安全中心,      @"安全中心"),
            item(@"BMrenwu",                @"LH_menu-edzh",        @"BMrenwu",                 UCI_任务中心,      @"任务中心"),
            item(@"gerenzhongxinxuanzhong", @"LH_task",             @"gerenzhongxinxuanzhong",  UCI_个人信息,      @"个人信息"),
            item(@"yijian",                 @"LH_menu-feedback",    @"yijian",                  UCI_建议反馈,      @"建议反馈"),
            item(@"zaixiankefu",            @"LH_menu-message",     @"zaixiankefu",             UCI_在线客服,      @"在线客服"),
            item(@"zdgl",                   @"LH_money",            @"zdgl",                    UCI_活动彩金,      @"活动彩金"),
            item(@"changlong",              @"changlong",           @"changlong",               UCI_长龙助手,      @"长龙助手"),
            item(@"menu-activity",          @"menu-activity",       @"menu-activity",           UCI_全民竞猜,      @"全民竞猜"),
            item(@"kj_trend",               @"kj_trend",            @"kj_trend",                UCI_开奖走势,      @"开奖走势"),
            item(@"usrCenter_qq",           @"usrCenter_qq",        @"usrCenter_qq",            UCI_QQ客服,        @"QQ客服"),
            item(@"center_kaijiang",        @"center_kaijiang",     @"center_kaijiang",         UCI_开奖网,        @"开奖网"),
            item(@"zdgl",                   @"LH_menu-rule",        @"zdgl",                    UCI_已结注单,      @"UCI_已结注单"),
            item(@"zdgl",                   @"LH_menu-rule",        @"zdgl",                    UCI_未结注单,      @"UCI_未结注单"),
            item(@"zdgl",                   @"LH_menu-rule",        @"zdgl",                    UCI_电子注单,      @"UCI_电子注单"),
            item(@"zdgl",                   @"LH_menu-rule",        @"zdgl",                    UCI_真人注单,      @"UCI_真人注单"),
            item(@"zdgl",                   @"LH_menu-rule",        @"zdgl",                    UCI_棋牌注单,      @"UCI_棋牌注单"),
            item(@"zdgl",                   @"LH_menu-rule",        @"zdgl",                    UCI_捕鱼注单,      @"UCI_捕鱼注单"),
            item(@"zdgl",                   @"LH_menu-rule",        @"zdgl",                    UCI_电竞注单,      @"UCI_电竞注单"),
            item(@"zdgl",                   @"LH_menu-rule",        @"zdgl",                    UCI_体育注单,      @"UCI_体育注单"),
            item(@"zdgl",                   @"LH_menu-rule",        @"zdgl",                    UCI_UG注单,       @"UCI_UG注单"),
            item(@"chongzhi",               @"LH_menu-cz",          @"chongzhi",                UCI_充值纪录,      @"充值纪录"),
            item(@"chongzhi",               @"LH_menu-qk",          @"tixian",                  UCI_提现纪录,      @"提现纪录"),
            item(@"chongzhi",               @"LH_menu-qk",          @"tixian",                  UCI_提现纪录,      @"提现纪录"),
            item(@"chongzhi",               @"LH_menu-qk",          @"tixian",                  UCI_资金明细,      @"资金明细"),
            item(@"zdgl",                   @"LH_money",            @"zdgl",                    UCI_活动大厅,      @"活动大厅"),
            item(@"LH_invi",                @"LH_invi",             @"LH_invi",                 UCI_我的关注,      @"我的关注"),
            item(@"LH_friend",              @"LH_friend",           @"LH_friend",               UCI_我的动态,      @"我的动态"),
            item(@"LH_fans",                @"LH_fans",             @"LH_fans",                 UCI_我的粉丝,      @"活动大厅"),
            
            
        ];

        
    });
    return _items;
}
- (NSString *)name {
    if (_code == UCI_推荐收益 && !UserI.isAgent) {
        return @"申请代理";
    }
    RnPageModel *rpm = [APP.rnPageInfos objectWithValue:@(_code) keyPath:@"userCenterItemCode"];
    return rpm.userCenterItemTitle.length ? rpm.userCenterItemTitle : _name;
}

- (void)setCode:(UserCenterItemType)code {
    _code = code;
    UGUserCenterItem *uci = [UGUserCenterItem.allItems objectWithValue:@(code) keyPath:@"code"];
    _lhImgName = uci.lhImgName;
    _bmImgName = uci.bmImgName;
    _defaultImgName = uci.defaultImgName;
}

- (NSString *)logo {
    RnPageModel *rpm = [APP.rnPageInfos objectWithValue:@(_code) keyPath:@"userCenterItemCode"];
    return rpm.userCenterItemIcon.length ? rpm.userCenterItemIcon : _logo;
}

@end


@interface UGMobileMenu ()
@property (nonatomic, readwrite) MobileMenuType type;
//@property (nonatomic, copy) NSString *defaultImgName;
@property (nonatomic, readwrite) NSString *clsName;
@end
@implementation UGMobileMenu
+ (NSArray <UGMobileMenu *>*)allMenus {
    static NSMutableArray *_items = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UGMobileMenu *(^item)(NSString *, NSString *, NSString *, MobileMenuType, NSString *) = ^UGMobileMenu *(NSString *path, NSString *defaultImgName, NSString *clsName, MobileMenuType type, NSString *name) {
            UGMobileMenu *mm = [UGMobileMenu new];
            [mm setValue:path forKey:@"_path"];
            mm.name = name;
            mm.defaultImgName = defaultImgName;
            mm.clsName = clsName;
            mm.type = type;
            
            if ([@"c245" containsString:APP.SiteId]) {
                if (type == MM_在线客服)
                    mm.defaultImgName = @"JY_kf";
                if (type == MM_首页)
                    mm.defaultImgName = @"home2";
            }
            return mm;
        };
        _items =@[
            item(@"/home",              @"shouye",                      UGHomeViewController.className,                 MM_首页,            @"首页"),
            item(@"/chess",              @"tabbar_pipai",                UGYYLotterySecondHomeViewController.className,  MM_棋牌,            @"棋牌"),
            item(@"/changLong",         @"changlong",                   UGChangLongController.className,                MM_长龙助手,         @"长龙助手"),
            item(@"/lotteryList",       @"dating",                      UGYYLotteryHomeViewController.className,        MM_购彩大厅_默认,     @"购彩大厅"),
            item(@"/lotteryRecord",     @"zdgl",                        UGLotteryRecordController.className,            MM_开奖记录,         @"开奖记录"),
            item(@"/zrsx",              @"real_video1",                 UGYYLotterySecondHomeViewController.className,  MM_真人视讯,         @"真人视讯"),
            item(@"/qpdz",              @"chess_electronic1",           UGYYLotterySecondHomeViewController.className,  MM_棋牌电子,         @"棋牌电子"),
            item(@"/catchFish",         @"tabbar_buyu",                 UGYYLotterySecondHomeViewController.className,  MM_捕鱼,            @"捕鱼"),
            item(@"/eGame",             @"tabbar_dianzhi",              UGYYLotterySecondHomeViewController.className,  MM_电子,            @"电子"),
            item(@"/eSport",            @"tabbar_dianjin",              UGYYLotterySecondHomeViewController.className,   MM_电竞,            @"电竞"),
            item(@"/user",              @"wode",                        UGMineSkinViewController.className,              MM_我的_默认,        @"我的"),
            item(@"/task",              @"renwu",                       UGMissionCenterViewController.className,        MM_任务中心,         @"任务中心"),
            item(@"/Sign",              @"qiandao",                     UGSigInCodeViewController.className,            MM_签到,            @"签到"),
            item(@"/message",           @"zhanneixin",                  UGMailBoxTableViewController.className,         MM_站内信,           @"站内信"),
            item(@"/activity",          @"youhui1",                     UGPromotionsController.className,               MM_优惠活动_默认,     @"优惠活动"),
            item(@"/chatRoomList",      @"liaotian",                    LotteryBetAndChatVC.className,                  MM_聊天室,           @"聊天室"),
            item(@"/referrer",          @"shouyi1",                     UGPromotionIncomeController.className,          MM_推广收益,         @"推广收益"),
            item(@"/securityCenter",    @"ziyuan",                      UGSecurityCenterViewController.className,       MM_安全中心,         @"安全中心"),
            item(@"/banks",             @"yinhangqia",                  UGBindCardViewController.className,             MM_银行卡,           @"银行卡"),
            item(@"/yuebao",            @"lixibao",                     UGYubaoViewController.className,                MM_利息宝,           @"利息宝"),
            item(@"/customerService",   @"zaixiankefu",                 OnlineServiceViewController.className,          MM_在线客服,          @"在线客服"),
            item(@"/notSettle",         @"tzjl",                        UGBetRecordViewController.className,            MM_未结算,            @"未结算"),
            item(@"/winApply",         @"shenqing",                     UGMosaicGoldViewController.className,            MM_优惠申请,          @"优惠申请"),
            item(@"/gameHall",         @"dating",                       UGLotteryHomeController.className,              MM_彩票大厅,          @"彩票大厅"),
            item(@"/funds",             @"jinlingyingcaiwangtubiao",    UGFundsViewController.className,                MM_资金管理,          @"资金管理"),
            item(@"/conversion",        @"change",                      UGBalanceConversionController.className,        MM_额度转换,          @"额度转换"),
        ].mutableCopy;
        
        // 彩票大厅
        [AppDefine addYsReplacePage:UGLotteryHomeController.class toPage:^Class{
            return APP.isNewLotteryView ? NewLotteryHomeViewController.class : nil;
        }];
        // 资金管理
        [AppDefine addYsReplacePage:UGFundsViewController.class toPage:^Class{
            return Skin1.isTKL ? TKLMoneyViewController.class : nil;
        }];
        // 额度转换
        [AppDefine addYsReplacePage:UGBalanceConversionController.class toPage:^Class{
            if (Skin1.isTKL|| [APP.SiteId isEqualToString:@"c085"])
                return TKLMainViewController.class;
            if (APP.isNewConversion)
                return LineConversionHeaderVC.class;
            return nil;
        }];
    });
    return _items;
}
- (void)setPath:(NSString *)path {
    _path = path;
    UGMobileMenu *mm = [UGMobileMenu.allMenus objectWithValue:path keyPath:@"path"];
    _type = [[mm valueForKey:@"_type"] intValue];
    _clsName = [mm valueForKey:@"_clsName"];
    _defaultImgName = mm.defaultImgName;
}
- (NSString *)icon {
    RnPageModel *rpm = [APP.rnPageInfos objectWithValue:_path keyPath:@"tabbarItemPath"];
    return rpm.tabbarItemIcon.length ? rpm.tabbarItemIcon : _icon;
}
- (NSString *)roles {
    return _roles.stringByTrim.length ? _roles : @"all";
}
- (NSString *)name {
    RnPageModel *rpm = [APP.rnPageInfos objectWithValue:_path keyPath:@"tabbarItemPath"];
    return rpm.tabbarItemTitle.length ? rpm.tabbarItemTitle : _name;
}
- (MobileMenuType)type {
    if (_type == MM_我的_默认) {
		if (Skin1.isGPK) {
            return MM_我的_亮黑;

		} else if ([Skin1.skitType containsString:@"六合"]) {
            return MM_我的_六合;

		} else if ([Skin1.skitType isEqualToString:@"金沙主题"]) {
            return MM_我的_金沙;

		} else if ([Skin1.skitType isEqualToString:@"火山橙"]) {
            return MM_我的_火山橙;

		}
    }
    if (_type == MM_推广收益 && UGLoginIsAuthorized() && !UserI.isAgent) {
        return MM_申请代理;
    }
    if (_type == MM_优惠活动_默认 && Skin1.isGPK) {
        return MM_优惠活动_亮黑;
    }
    if (_type == MM_购彩大厅_默认 && Skin1.isGPK) {
        return MM_购彩大厅_亮黑;
    }

    return _type;
}
- (NSString *)clsName {
    RnPageModel *rpm = [APP.rnPageInfos objectWithValue:_path keyPath:@"tabbarItemPath"];
    if (rpm) {
        return rpm.vcName2.length ? NSClassFromString(rpm.vcName2) : ReactNativeVC.className;
    }
    if (_status) {
        return @"LHStayTunedVC";
    }
    if (self.type == MM_我的_亮黑) {
        return UGBMMemberCenterViewController.className;
    }
    if (self.type == MM_我的_六合) {
        return UGLHMineViewController.className;
    }
	if (self.type == MM_我的_金沙) {
		return JS_MineVC.className;
	}
	if (self.type == MM_我的_火山橙) {
		return HSC_MineVC.className;
	}
    if (self.type == MM_申请代理) {
        return UGAgentViewController.className;
    }
    if (self.type == MM_优惠活动_亮黑) {
        return UGBMpreferentialViewController.className;
    }
    if (self.type == MM_购彩大厅_亮黑) {
        return UGBMLotteryHomeViewController.className;
    }
    if (self.type == MM_聊天室 && [@"h005" containsString:APP.SiteId]) {
        return UGChatViewController.className;
    }
    if (self.type == MM_聊天室 && APP.isNewChat) {
        return ChatMainViewController.className;
    }
   
    return _clsName;
}
- (void)createViewController:(void (^)(__kindof UIViewController * _Nonnull))completion {
    if (!completion)
        return;
    
    RnPageModel *rpm = [APP.rnPageInfos objectWithValue:_path keyPath:@"tabbarItemPath"];
    if (rpm) {
        completion([ReactNativeVC reactNativeWithRPM:rpm params:nil]);
    }
    else if (_status) {
        completion(_LoadVC_from_storyboard_(@"LHStayTunedVC"));
    }
    else if (UGLoginIsAuthorized() && (self.type == MM_申请代理 || self.type == MM_推广收益) && !UserI.isTest) {
        [SVProgressHUD showWithStatus:nil];
        [CMNetwork teamAgentApplyInfoWithParams:@{@"token":[UGUserModel currentUser].sessid} completion:^(CMResult<id> *model, NSError *err) {
            [CMResult processWithResult:model success:^{
                [SVProgressHUD dismiss];
                UGagentApplyInfo *obj  = (UGagentApplyInfo *)model.data;
                int intStatus = obj.reviewStatus.intValue;

                //0 未提交  1 待审核  2 审核通过 3 审核拒绝
                if (intStatus == 2) {
                    completion([UGPromotionIncomeController new]);
                } else {
//                    if (![SysConf.agent_m_apply isEqualToString:@"1"]) {
//                        [HUDHelper showMsg:@"在线注册代理已关闭"];
//                        return ;
//                    }
                    UGAgentViewController *vc = [UGAgentViewController new];
                    vc.item = obj;
                    completion(vc);
                }
            } failure:^(id msg) {
                [SVProgressHUD showErrorWithStatus:msg];
            }];
        }];
    }
    else if (self.type == MM_真人视讯 || self.type == MM_棋牌电子
             ||self.type == MM_电竞 || self.type == MM_电子
             ||self.type == MM_棋牌 || self.type == MM_捕鱼) {
        [SVProgressHUD showWithStatus:nil];
        WeakSelf;
        [CMNetwork getPlatformGamesWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
            [CMResult processWithResult:model success:^{
                [SVProgressHUD dismiss];
                 NSMutableArray <UGYYPlatformGames *>*lotterydataArray = ({
                    NSMutableArray *temp = @[].mutableCopy;
                    NSArray *dataArray = model.data;
                    for (int i=0; i<dataArray.count; i++) {
                        [temp addObject:dataArray[i]];
                    }
                    temp;
                });
                
                [Global getInstanse].lotterydataArray   = lotterydataArray;
                UGYYLotterySecondHomeViewController *vc = [[UGYYLotterySecondHomeViewController alloc] init];
                vc.title = weakSelf.name;
                if (weakSelf.type == MM_真人视讯) {
                    vc.dataArray = [UGYYGames arrayOfModelsFromDictionaries:[lotterydataArray objectWithValue:@"real" keyPath:@"category"].games error:nil];    // 真人
                }
                else if (weakSelf.type == MM_棋牌电子) {
                    NSMutableArray *temp = @[].mutableCopy;
                    [temp addObjectsFromArray:[UGYYGames arrayOfModelsFromDictionaries:[lotterydataArray objectWithValue:@"card" keyPath:@"category"].games error:nil]];    // 棋牌
                    [temp addObjectsFromArray:[UGYYGames arrayOfModelsFromDictionaries:[lotterydataArray objectWithValue:@"game" keyPath:@"category"].games error:nil]];    // 电子
                    [temp addObjectsFromArray:[UGYYGames arrayOfModelsFromDictionaries:[lotterydataArray objectWithValue:@"esport" keyPath:@"category"].games error:nil]];  // 电竞
                    vc.dataArray = temp;;
                }
                else if (weakSelf.type == MM_棋牌){
                      vc.dataArray = [UGYYGames arrayOfModelsFromDictionaries:[lotterydataArray objectWithValue:@"card" keyPath:@"category"].games error:nil];    // 棋牌
                }
                else if (weakSelf.type == MM_电子){
                    vc.dataArray = [UGYYGames arrayOfModelsFromDictionaries:[lotterydataArray objectWithValue:@"game" keyPath:@"category"].games error:nil];    // 电子
                }
                else if (weakSelf.type == MM_电竞){
                    vc.dataArray = [UGYYGames arrayOfModelsFromDictionaries:[lotterydataArray objectWithValue:@"esport" keyPath:@"category"].games error:nil];    // 电竞
                }
                else if (weakSelf.type == MM_捕鱼){
                    vc.dataArray = [UGYYGames arrayOfModelsFromDictionaries:[lotterydataArray objectWithValue:@"fish" keyPath:@"category"].games error:nil];    // 捕鱼
                }
                completion(vc);;
            } failure:^(id msg) {
                [SVProgressHUD showErrorWithStatus:msg];
            }];
        }];
	} else if (self.type == MM_我的_金沙) {
		JS_MineVC * vc = [[UIStoryboard storyboardWithName:@"JS_Mine" bundle:nil] instantiateInitialViewController];
        completion(vc);

	}else if (self.type == MM_我的_火山橙) {
		HSC_MineVC * vc = [[UIStoryboard storyboardWithName:@"HSC_Mine" bundle:nil] instantiateInitialViewController];
        completion(vc);

    }
    else {
        if (!self.clsName.stringByTrim.length) {
            self.clsName = @"LHStayTunedVC";
        }
        UIViewController *vc = _LoadVC_from_storyboard_(self.clsName);
        if (!vc) {
            vc = [NSClassFromString(self.clsName) new];
        }
        
        if ([self.clsName isEqualToString:@"LotteryBetAndChatVC"]) {
            LotteryBetAndChatVC * chat = (LotteryBetAndChatVC *)vc  ;
            chat.selectChat = YES;
            chat.isHeightLess50 = YES;
        }
        completion(vc);
    }
}
@end

@implementation UGSystemConfigModel {
    NSArray<UGUserCenterItem *> *_userCenter;
}

MJExtensionCodingImplementation

+ (instancetype)currentConfig {
    if (!currentConfig)
        currentConfig = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    return currentConfig;
}

+ (void)setCurrentConfig:(UGSystemConfigModel *)user {
    currentConfig = user;
    [NSKeyedArchiver archiveRootObject:user toFile:filePath];
}

- (NSString *)serviceQQ1 {
    return _serviceQQ1.length ? _serviceQQ1 : _serviceQQ2;
}
//isTwoOnline
- (NSString *)zxkfUrl {
    return _zxkfUrl.length ? _zxkfUrl : _zxkfUrl2;
}


- (NSString *)serviceQQ2 {
    return _serviceQQ2.length ? _serviceQQ2 : _serviceQQ1;
}
- (NSMutableArray <NSString *>*)qqs {
    NSMutableArray *qqArray = [NSMutableArray new];
    if (![CMCommon stringIsNull:_appPopupQqNum]) {
        [qqArray addObject:_appPopupQqNum];
    }
    if (![CMCommon stringIsNull:_serviceQQ1]) {
        [qqArray addObject:_serviceQQ1];
    }
    if (![CMCommon stringIsNull:_serviceQQ2]) {
        [qqArray addObject:_serviceQQ2];
    }
    return qqArray;
}


- (NSArray<UGUserCenterItem *> *)userCenter {
    if (!_userCenter) {
        _userCenter = [UGUserCenterItem allItems];
    }
    NSMutableArray *temp = _userCenter.mutableCopy;
#ifndef DEBUG
    if (!UserI.hasActLottery) {
        [temp removeObject:[temp objectWithValue:@(UCI_活动彩金) keyPath:@"code"]];
    }
    if (!UserI.yuebaoSwitch) {
        [temp removeObject:[temp objectWithValue:@(UCI_利息宝) keyPath:@"code"]];
    }
#endif
    return temp.copy;
}

- (void)setUserCenter:(NSArray<UGUserCenterItem *> *)userCenter {
    if ([userCenter isKindOfClass:[NSArray class]]) {
        if ([userCenter.firstObject isKindOfClass:NSDictionary.class]) {
            _userCenter = [UGUserCenterItem arrayOfModelsFromDictionaries:userCenter error:nil];
        } else {
            _userCenter = userCenter;
        }
    }
}

- (void)setLhcPriceList:(NSArray<LHPriceModel *> *)lhcPriceList {
    if ([lhcPriceList isKindOfClass:[NSArray class]]) {
        if ([lhcPriceList.firstObject isKindOfClass:NSDictionary.class]) {
            _lhcPriceList = [LHPriceModel mj_objectArrayWithKeyValuesArray:lhcPriceList];
        } else {
            _lhcPriceList = lhcPriceList;
        }
    }
}

@end





@implementation platformModel 

@end

//第3方登录Model
@implementation OauthModel
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"switch":@"mSwith"}];
}
@end
