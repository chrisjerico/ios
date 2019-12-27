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
#import "UGAgentViewController.h"           // 申请代理
#import "UGYYLotterySecondHomeViewController.h"
#import "UGBMMemberCenterViewController.h"  //
#import "UGLHMineViewController.h"  //
#import "UGBMpreferentialViewController.h"
#import "UGBMLotteryHomeViewController.h"


#define filePath  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"UGSystemConfigModel"]

UGSystemConfigModel *currentConfig = nil;

@implementation LHPriceModel
@end

@interface LHStayTunedVC : UIViewController
@end
@implementation LHStayTunedVC
@end


@interface UGUserCenterItem ()
@property (nonatomic, readwrite) NSString *lhImgName;
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
            item(@"yinhangqia",             @"LH_menu-account",     @"yinhangqia",              UCI_银行卡管理,     @"银行卡管理"),
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
        ];
    });
    return _items;
}
- (NSString *)name {
    if (_code == UCI_推荐收益 && !UserI.isAgent) {
        return @"申请代理";
    }
    return _name;
}
- (void)setCode:(UserCenterItemType)code {
    _code = code;
    UGUserCenterItem *uci = [UGUserCenterItem.allItems objectWithValue:@(code) keyPath:@"code"];
    _lhImgName = uci.lhImgName;
    _bmImgName = uci.bmImgName;
    _defaultImgName = uci.defaultImgName;
}
@end


@interface UGMobileMenu ()
@property (nonatomic, readwrite) MobileMenuType type;
@property (nonatomic, readwrite) NSString *defaultImgName;
@property (nonatomic, readwrite) Class cls;
@end
@implementation UGMobileMenu
+ (NSArray <UGMobileMenu *>*)allMenus {
    static NSArray *_items = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UGMobileMenu *(^item)(NSString *, NSString *, Class, MobileMenuType, NSString *) = ^UGMobileMenu *(NSString *path, NSString *defaultImgName, Class cls, MobileMenuType type, NSString *name) {
            UGMobileMenu *mm = [UGMobileMenu new];
            [mm setValue:path forKey:@"_path"];
            mm.name = name;
            mm.defaultImgName = defaultImgName;
            mm.cls = cls;
            mm.type = type;
            return mm;
        };
        _items =@[
            item(@"/home",              @"shouye",                      UGHomeViewController.class,                 MM_首页,           @"首页"),
            item(@"/changLong",         @"changlong",                   UGChangLongController.class,                MM_长龙助手,        @"长龙助手"),
            item(@"/lotteryList",       @"dating",                      UGYYLotteryHomeViewController.class,        MM_购彩大厅_默认,    @"购彩大厅"),
            item(@"/lotteryRecord",     @"zdgl",                        UGLotteryRecordController.class,            MM_开奖记录,        @"开奖记录"),
            item(@"/zrsx",              @"real_video1",                 UGYYLotterySecondHomeViewController.class,  MM_真人视讯,        @"真人视讯"),
            item(@"/qpdz",              @"chess_electronic1",           UGYYLotterySecondHomeViewController.class,  MM_棋牌电子,        @"棋牌电子"),
            item(@"/gameHall",          @"gcdt",                        UGLotteryHomeController.class,              MM_彩票大厅,        @"彩票大厅"),
            item(@"/user",              @"wode",                        UGMineSkinViewController.class,             MM_我的_默认,       @"我的"),
            item(@"/task",              @"renwu",                       UGMissionCenterViewController.class,        MM_任务中心,        @"任务中心"),
            item(@"/Sign",              @"qiandao",                     UGSigInCodeViewController.class,            MM_签到,           @"签到"),
            item(@"/message",           @"zhanneixin",                  UGMailBoxTableViewController.class,         MM_站内信,          @"站内信"),
            item(@"/activity",          @"youhui1",                     UGPromotionsController.class,               MM_优惠活动_默认,    @"优惠活动"),
            item(@"/chatRoomList",      @"liaotian",                    UGChatViewController.class,                 MM_聊天室,         @"聊天室"),
            item(@"/referrer",          @"shouyi1",                     UGPromotionIncomeController.class,          MM_推广收益,        @"推广收益"),
            item(@"/securityCenter",    @"ziyuan",                      UGSecurityCenterViewController.class,       MM_安全中心,        @"安全中心"),
            item(@"/funds",             @"jinlingyingcaiwangtubiao",    UGFundsViewController.class,                MM_资金管理,        @"资金管理"),
            item(@"/conversion",        @"change",                      UGBalanceConversionController.class,        MM_额度转换,        @"额度转换"),
            item(@"/banks",             @"yinhangqia",                  UGBindCardViewController.class,             MM_银行卡,         @"银行卡"),
            item(@"/yuebao",            @"lixibao",                     UGYubaoViewController.class,                MM_利息宝,         @"利息宝"),
        ];
    });
    return _items;
}
- (void)setPath:(NSString *)path {
    _path = path;
    UGMobileMenu *mm = [UGMobileMenu.allMenus objectWithValue:path keyPath:@"path"];
    _type = [[mm valueForKey:@"_type"] intValue];
    _cls = [mm valueForKey:@"_cls"];
    _defaultImgName = mm.defaultImgName;
}
- (MobileMenuType)type {
    if (_type == MM_我的_默认) {
        if (Skin1.isBlack)
            return MM_我的_亮黑;
        if ([Skin1.skitType containsString:@"六合"])
            return MM_我的_六合;
    }
    if (_type == MM_推广收益 && UGLoginIsAuthorized() && !UserI.isAgent) {
        return MM_申请代理;
    }
    if (_type == MM_优惠活动_默认 && Skin1.isBlack) {
        return MM_优惠活动_亮黑;
    }
    if (_type == MM_购彩大厅_默认 && Skin1.isBlack) {
        return MM_购彩大厅_亮黑;
    }
    return _type;
}
- (Class)cls {
    if (_status) {
        return NSClassFromString(@"LHStayTunedVC");
    }
    if (self.type == MM_我的_亮黑) {
        return UGBMMemberCenterViewController.class;
    }
    if (self.type == MM_我的_六合) {
        return UGLHMineViewController.class;
    }
    if (self.type == MM_申请代理) {
        return UGAgentViewController.class;
    }
    if (self.type == MM_优惠活动_亮黑) {
        return UGBMpreferentialViewController.class;
    }
    if (self.type == MM_购彩大厅_亮黑) {
        return UGBMLotteryHomeViewController.class;
    }
    return _cls;
}
- (void)createViewController:(void (^)(__kindof UIViewController * _Nonnull))completion {
    if (!completion)
        return;
    
    if (_status) {
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
                    if (![SysConf.agent_m_apply isEqualToString:@"1"]) {
                        [HUDHelper showMsg:@"在线注册代理已关闭"];
                        return ;
                    }
                    UGAgentViewController *vc = [UGAgentViewController new];
                    vc.item = obj;
                    completion(vc);
                }
            } failure:^(id msg) {
                [SVProgressHUD showErrorWithStatus:msg];
            }];
        }];
    }
    else if (self.type == MM_真人视讯 || self.type == MM_棋牌电子) {
        [SVProgressHUD showWithStatus:nil];
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
                UGYYLotterySecondHomeViewController *vc = [[UGYYLotterySecondHomeViewController alloc] init];
                vc.title = self.name;
                if (self.type == MM_真人视讯) {
                    vc.dataArray = [UGYYGames arrayOfModelsFromDictionaries:[lotterydataArray objectWithValue:@"real" keyPath:@"category"].games error:nil];    // 真人
                } else if (self.type == MM_棋牌电子) {
                    NSMutableArray *temp = @[].mutableCopy;
                    [temp addObjectsFromArray:[UGYYGames arrayOfModelsFromDictionaries:[lotterydataArray objectWithValue:@"card" keyPath:@"category"].games error:nil]];    // 棋牌
                    [temp addObjectsFromArray:[UGYYGames arrayOfModelsFromDictionaries:[lotterydataArray objectWithValue:@"game" keyPath:@"category"].games error:nil]];    // 电子
                    [temp addObjectsFromArray:[UGYYGames arrayOfModelsFromDictionaries:[lotterydataArray objectWithValue:@"esport" keyPath:@"category"].games error:nil]];  // 电竞
                    vc.dataArray = temp;;
                }
                completion(vc);;
            } failure:^(id msg) {
                [SVProgressHUD showErrorWithStatus:msg];
            }];
        }];
    } else {
        UIViewController *vc = _LoadVC_from_storyboard_(NSStringFromClass(self.cls));
        if (!vc) {
            vc = [self.cls new];
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
    if (!UserI.hasActLottery) {
        NSMutableArray *temp = _userCenter.mutableCopy;
        [temp removeObject:[temp objectWithValue:@(UCI_活动彩金) keyPath:@"code"]];
        return temp.copy;
    }
    return _userCenter;
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

