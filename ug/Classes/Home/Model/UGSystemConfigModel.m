//
//  UGSystemConfigModel.m
//  ug
//
//  Created by ug on 2019/7/23.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGSystemConfigModel.h"

#define filePath  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"UGSystemConfigModel"]

UGSystemConfigModel *currentConfig = nil;

@implementation UGUserCenterItem



+ (NSArray <UGUserCenterItem *>*)allItems {
    static NSArray *_items = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UGUserCenterItem *(^item)(UserCenterItemType, NSString *) = ^UGUserCenterItem *(UserCenterItemType type, NSString *name) {
            UGUserCenterItem *uci = [UGUserCenterItem new];
            uci.name = name;
            uci.code = type;
            return uci;
        };
        _items = @[
            item(UCI_存款, @"存款"),
            item(UCI_取款, @"取款"),
            item(UCI_银行卡管理, @"银行卡管理"),
            item(UCI_利息宝, @"利息宝"),
            item(UCI_推荐收益, @"推荐收益"),
            item(UCI_彩票注单记录, @"彩票注单记录"),
            item(UCI_其他注单记录, @"其他注单记录"),
            item(UCI_额度转换, @"额度转换"),
            item(UCI_站内信, @"站内信"),
            item(UCI_安全中心, @"安全中心"),
            item(UCI_任务中心, @"任务中心"),
            item(UCI_个人信息, @"个人信息"),
            item(UCI_建议反馈, @"建议反馈"),
            item(UCI_在线客服, @"在线客服"),
            item(UCI_活动彩金, @"活动彩金"),
            item(UCI_长龙助手, @"长龙助手"),
            item(UCI_全民竞猜, @"全民竞猜"),
            item(UCI_开奖走势, @"开奖走势"),
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

- (NSString *)bmImgName {
    NSDictionary *dict = @{
        @(UCI_存款):@"chongzhi",
        @(UCI_取款):@"chongzhi",
        @(UCI_银行卡管理):@"yinhangqia",
        @(UCI_利息宝):@"lixibao",
        @(UCI_推荐收益):@"shouyi1sel",
        @(UCI_彩票注单记录):@"zdgl",
        @(UCI_其他注单记录):@"zdgl",
        @(UCI_额度转换):@"change",
        @(UCI_站内信):@"zhanneixin",
        @(UCI_安全中心):@"ziyuan",
        @(UCI_任务中心):@"BMrenwu",
        @(UCI_个人信息):@"gerenzhongxinxuanzhong",
        @(UCI_建议反馈):@"yijian",
        @(UCI_在线客服):@"zaixiankefu",
        @(UCI_活动彩金):@"zdgl",
        @(UCI_长龙助手):@"changlong",
        @(UCI_全民竞猜):@"menu-activity",
        @(UCI_开奖走势):@"kj_trend",
    };
    return dict[@(_code)];
}

- (NSString *)lhImgName {
    NSDictionary *dict = @{
        @(UCI_存款):@"LH_menu-cz",
        @(UCI_取款):@"LH_menu-qk",
        @(UCI_银行卡管理):@"LH_menu-account",
        @(UCI_利息宝):@"LH_syb3",
        @(UCI_推荐收益):@"LH_task",
        @(UCI_彩票注单记录):@"LH_menu-rule",
        @(UCI_其他注单记录):@"LH_menu-rule",
        @(UCI_额度转换):@"LH_menu-transfer",
        @(UCI_站内信):@"LH_menu-notice",
        @(UCI_安全中心):@"LH_menu-password",
        @(UCI_任务中心):@"LH_menu-edzh",
        @(UCI_个人信息):@"LH_task",
        @(UCI_建议反馈):@"LH_menu-feedback",
        @(UCI_在线客服):@"LH_menu-message",
        @(UCI_活动彩金):@"LH_money",
        @(UCI_长龙助手):@"changlong",
        @(UCI_全民竞猜):@"menu-activity",
        @(UCI_开奖走势):@"kj_trend",
    };
    return dict[@(_code)];
}

- (NSString *)defaultImgName {
    NSDictionary *dict = @{
        @(UCI_存款):@"chongzhi",
        @(UCI_取款):@"tixian",
        @(UCI_银行卡管理):@"yinhangqia",
        @(UCI_利息宝):@"lixibao",
        @(UCI_推荐收益):@"shouyi1sel",
        @(UCI_彩票注单记录):@"zdgl",
        @(UCI_其他注单记录):@"zdgl",
        @(UCI_额度转换):@"change",
        @(UCI_站内信):@"zhanneixin",
        @(UCI_安全中心):@"ziyuan",
        @(UCI_任务中心):@"BMrenwu",
        @(UCI_个人信息):@"gerenzhongxinxuanzhong",
        @(UCI_建议反馈):@"yijian",
        @(UCI_在线客服):@"zaixiankefu",
        @(UCI_活动彩金):@"zdgl",
        @(UCI_长龙助手):@"changlong",
        @(UCI_全民竞猜):@"menu-activity",
        @(UCI_开奖走势):@"kj_trend",
    };
    return dict[@(_code)];
}

@end

@implementation UGmobileMenu
+ (instancetype)menu:(NSString *)path :(NSString *)name :(NSString *)icon :(NSString *)selectedIcon :(Class)cls {
    UGmobileMenu *gm = [UGmobileMenu new];
    gm.path = path;
    gm.name = name;
    gm.icon = icon;
    gm.selectedIcon = selectedIcon;
    gm.cls = cls;
    return gm;
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
    return _serviceQQ1.length ? _serviceQQ1 : _serviceQQ2;
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

@end

