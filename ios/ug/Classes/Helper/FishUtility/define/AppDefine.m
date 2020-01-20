//
//  AppDefine.m
//  Consult
//
//  Created by fish on 2017/10/25.
//  Copyright © 2017年 fish. All rights reserved.
//

#import "AppDefine.h"



#define __SiteID__ @"l001"


@interface UIStoryboard ()
- (BOOL)containsNibNamed:(NSString *)nibName;
@end



@implementation AppDefine

#pragma mark - ClassMethod

+ (instancetype)shared {
    static id obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [self new];
    });
    return obj;
}

+ (__kindof UIViewController *)viewControllerWithStoryboardID:(NSString *)sid {
    static NSArray <UIStoryboard *>*sbs = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIStoryboard *(^sb)(NSString *) = ^UIStoryboard *(NSString *sbName) {
            return [UIStoryboard storyboardWithName:sbName bundle:[NSBundle mainBundle]];
        };
        sbs = @[sb(@"UGWithdrawalViewController"),
                sb(@"UGMissionCenterViewController"),
                sb(@"UGHKLHCLotteryController"),
                sb(@"UGFeedBackController"),
                sb(@"UGYubaoViewController"),
                sb(@"UGPromotionInfoController"),
                sb(@"UGUserInfoViewController"),
                sb(@"UGGD11X5LotteryController"),
                sb(@"UGXYNCLotteryController"),
                sb(@"UGBJKL8LotteryController"),
                sb(@"UGGDKL10LotteryController"),
                sb(@"UGIntegralConvertRecordController"),
                sb(@"UGBetRecordDetailViewController"),
                sb(@"UGJSK3LotteryController"),
                sb(@"UGIntegralConvertController"),
                sb(@"UGBetRecordTableViewController"),
                sb(@"UGSafety"),
                sb(@"UGRealBetRecordViewController"),
                sb(@"UGHomeViewController"),
                sb(@"UGBindCardViewController"),
                sb(@"UGPK10NNLotteryController"),
                sb(@"UGQXCLotteryController"),
                sb(@"UGPCDDLotteryController"),
                sb(@"UGLotteryRecordController"),
                sb(@"UGLotteryAssistantController"),
                sb(@"UGSSCLotteryController"),
                sb(@"UGBJPK10LotteryController"),
                sb(@"Mine"),
                sb(@"UGFC3DLotteryController"),
                sb(@"Promote"),
                sb(@"UGLHC"),
                sb(@"UGLHH"),
                sb(@"BMpreferential"),
                sb(@"BlackTemplate"),
                sb(@"BMMine"),
                sb(@"LHTemplate"),
                sb(@"LHTemplate"),
                sb(@"UGYubaoViewController"),
                sb(@"JS_Mine"),
                sb(@"HSC_Mine"),

                ];
    });
    
    const char *sel = [@"contains11111NibNamed:" stringByReplacingOccurrencesOfString:@"1" withString:@""].UTF8String;
    for (UIStoryboard *sb in sbs) {
        if ([sb performSelector:sel, sid])
            return [sb instantiateViewControllerWithIdentifier:sid];
    }
    NSLog(@"ERROR：未找到 ViewController，storyboard id is = \"%@\"", sid);
    return nil;
}

+ (UIViewController *)viewControllerWithNibName:(NSString *)nibName {
    return [[NSClassFromString(nibName) alloc] initWithNibName:nibName bundle:nil];
}

+ (__kindof UIView *)viewWithNibName:(NSString *)nibName {
    return [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil].firstObject;
}

+ (NSString *)stringWithFloat:(double)f decimal:(unsigned short)d {
    NSString *format = _NSString(@"%%.%df", d);
    NSString *s = _NSString(format, f);
    while ([s hasSuffix:@"0"])
        s = [s substringToIndex:s.length-1];
    if ([s hasSuffix:@"."])
        s = [s substringToIndex:s.length-1];
    return s;
}


#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    if (self) {
        _allSites = [SiteModel allSites];
        _SiteId = __SiteID__;
        _jspVersion = [[NSUserDefaults standardUserDefaults] stringForKey:@"jspVersion"];
        NSLog(@"_SiteId = %@",_SiteId);
#ifdef DEBUG
        _SiteId = [[NSUserDefaults standardUserDefaults] stringForKey:@"当前站点Key"];
        if (!_SiteId.length) {
            _SiteId = @"l001";
        }
        
#endif
        NSLog(@"%@",[_allSites objectWithValue:_SiteId.lowercaseString keyPath:@"siteId"]);
        _Host = [_allSites objectWithValue:_SiteId.lowercaseString keyPath:@"siteId"].host;
        if (!_Host.length) {
            #ifdef DEBUG
                 @throw [NSException exceptionWithName:@"缺少域名" reason:_NSString(@"（%@）该站点没有配置接口域名", _SiteId) userInfo:nil];
            #endif
        }
        
        _PhotoMaxLength = 60 * 1024;    // 约等于1M大小
        _PageCount = 20;
        
        [self setupSystem];
        [self setupColor];
    }
    return self;
}


#pragma mark - Getter & Setter

- (CGRect)Bounds                    { return _Window.bounds; }
- (CGSize)Size                      { return _Window.bounds.size; }
- (CGFloat)Width                    { return _Window.bounds.size.width; }
- (CGFloat)Height                   { return _Window.bounds.size.height; }
- (UIFont *)cellBigFont             { return [UIFont boldSystemFontOfSize:17]; }
- (UIFont *)cellNormalFont          { return [UIFont systemFontOfSize:14]; }
- (float )cellNormalFontSize        { return 14.0; }

- (float )borderWidthTimes          {
    if ([@"a002" containsString:_SiteId]) {
        return  2.0;
    } else {
        return 1;
    }
}


- (BOOL)isShowJinbei {
    return [@"c085" containsString:_SiteId];
}

- (BOOL)isShowWZ {
    return [@"c085" containsString:_SiteId];
}

- (BOOL)isShowLogo {
    if ([@"黑色模板" containsString:Skin1.skitType]) {
        return NO;
    } else {
        return [@"c190" containsString:_SiteId];
    }
}

- (BOOL)isBA {
    return [@"c001" containsString:_SiteId];
}

- (BOOL)addIcons {
    return [@"c190" containsString:_SiteId];
}

- (BOOL)lotteryHallCustomImgS {
    return [@"c190" containsString:_SiteId];
}

- (BOOL)betOddsIsRed {
    return [@"c194,c005" containsString:_SiteId];
}

- (BOOL)betBgIsWhite {

    if ([Skin1.skitString isEqualToString:@"新年红 1蓝色风格"]) {
        return NO;
    } else {
         return ![@"c175,c085,c073,c169,a002,c190,c048,c200,c001" containsString:_SiteId] || [@"新年红,石榴红" containsString:Skin1.skitType];
    }
}

- (BOOL)betSizeIsBig {
    return [@"c169" containsString:_SiteId];
}

- (NSString *)jspPath {
    return _NSString(@"%@/jsp%@/main.js", APP.DocumentDirectory, _jspVersion);
}

- (void)setJspVersion:(NSString *)jspVersion {
    _jspVersion = jspVersion;
    [[NSUserDefaults standardUserDefaults] setObject:jspVersion forKey:@"jspVersion"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - H5 url

- (NSString *)chatShareUrl {
    NSString *url = _NSString(@"%@/dist/index.html#/home", _Host);
    return [url stringByAppendingURLParams:@{
        // 公共参数
        @"from":@"app",
        @"color":Skin1.navBarBgColor.cc_userInfo[@"color"],
        @"endColor":Skin1.navBarBgColor.cc_userInfo[@"endColor"],
        @"back":@"hide",
        @"loginsessid":[UGUserModel currentUser].sessid,
        @"logintoken":[UGUserModel currentUser].token,
        // 定制参数
        @"roomId":@"0",
        @"roomName":[CMCommon urlformat:SysConf.chatRoomName] ,
        @"tag":@"3",
    }];
}

- (NSString *)chatHomeUrl {
//        SysConf.chatLink = @"/chat";
//    SysConf.chatLink = @"/chat/index.php";
    NSString *url = _NSString(@"%@%@", _Host, SysConf.chatLink);
    return [url stringByAppendingURLParams:@{
        @"from":@"app",
        @"color":Skin1.navBarBgColor.cc_userInfo[@"color"],
        @"endColor":Skin1.navBarBgColor.cc_userInfo[@"endColor"],
        @"back":@"hide",
        @"loginsessid":[UGUserModel currentUser].sessid,
        @"logintoken":[UGUserModel currentUser].token,
    }];
}


- (NSString *)chatGameUrl:(NSString *)roomId hide:(BOOL )hideHead {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:roomId forKey:@"roomId"];
    if (hideHead) {
        NSNumber * boolNum = [NSNumber numberWithBool:hideHead];
        [dic setValue:boolNum forKey:@"hideHead"];
    }

    NSString *s = [self.chatHomeUrl stringByAppendingURLParams:dic];
    NSLog(@"s= %@",s);
    return s;
}



- (NSString *)chatMainGameUr {
    return [self.chatHomeUrl stringByAppendingURLParams:@{@"roomId":@"0"}];
}


#pragma mark - Setup

- (void)setupSystem {
    NSDictionary *info = [NSBundle mainBundle].infoDictionary;
    _Name = info[@"CFBundleName"];
    _BundleId = info[@"CFBundleIdentifier"];
    _Version = info[@"CFBundleShortVersionString"];
    _Build = info[@"CFBundleVersion"];
#ifdef DEBUG
    _DevUser = info[@"Dev1"];
    _isFish = [_DevUser isEqualToString:@"fish"];
#endif
    
    _Window = [UIApplication sharedApplication].windows.firstObject;
    
    // 获取沙盒目录
    _DocumentDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    _LibraryDirectory = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
    _CachesDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    
    _StatusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    _BottomSafeHeight = _Window.height - [UITabBarController new].tabBar.by;
    
    [UIViewController cc_hookSelector:@selector(viewDidLayoutSubviews) withOptions:AspectOptionAutomaticRemoval usingBlock:^(id<AspectInfo> ai) {
        if (@available(iOS 11.0, *)) {
            APP.BottomSafeHeight = ((UIViewController *)ai.instance).view.safeAreaInsets.bottom;
        }
    } error:nil];
}


- (void)setupColor {
    // Color
    _ThemeColor1 = UIColorRGB(29, 161, 242);
    _ThemeColor2 = UIColorRGB(82, 204, 204);
    _ThemeColor3 = UIColorRGB(245, 210, 37);
    _AuxiliaryColor1 = UIColorRGB(77, 191, 76);
    _AuxiliaryColor2 = UIColorRGB(250, 75, 75);
    _AuxiliaryColor3 = UIColorRGB(245, 113, 69);
    _TextColor1 = UIColorRGB(51, 51, 51);
    _TextColor2 = UIColorRGB(102, 102, 102);
    _TextColor3 = UIColorRGB(153, 153, 153);
    _TextColor4 = UIColorRGB(170, 170, 170);
    _LineColor = UIColorRGB(204, 204, 204);
    _LoadingColor = UIColorRGB(238, 238, 238);
    _NavigationBarColor = UIColorRGB(243, 243, 243);
    _BackgroundColor = UIColorRGB(247, 247, 247);
}

@end
