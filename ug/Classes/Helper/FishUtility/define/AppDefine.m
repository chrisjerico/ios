//
//  AppDefine.m
//  Consult
//
//  Created by fish on 2017/10/25.
//  Copyright © 2017年 fish. All rights reserved.
//

#import "AppDefine.h"



#define __SiteID__ @"test61f"


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
                sb(@"HSC_Mine"),
                sb(@"MyPromotion"),
                sb(@"ContractedTemplate"),
                sb(@"RedEnvelope"),
                sb(@"LineConversion"),
                
                
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

+ (NSString *)stringWithFileSize:(double)size {
    if (size < 0)
        return @"0B";
    if (size < 1024)
        return _NSString(@"%.fB", size);
    if (size < 1024 * 1024)
        return _NSString(@"%.fK", size/1024);
    if (size < 1024 * 1024 * 1024)
        return _NSString(@"%.1fM", size/1024/1024);
    return _NSString(@"%.1fG", size/1024/1024/1024);
}


#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    if (self) {
        _allSites = [SiteModel allSites];
        _SiteId = __SiteID__;
        _jspVersion = [[NSUserDefaults standardUserDefaults] stringForKey:@"jspVersion"];
#ifdef APP_TEST
        _Test = true;
        _SiteId = [[NSUserDefaults standardUserDefaults] stringForKey:@"当前站点Key"];
        if (!_SiteId.length) {
            _SiteId = @"test61f";
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
        _beginTime =  @"2020-01-01";
        
        [self setupSystem];
        [self setupColor];
        
        if (!_jspVersion.length) {
            _jspVersion = _Version;
        }
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

#pragma mark - 定制样式



- (BOOL)isSectionWhite {
     return [@"a002" containsString:_SiteId];
}

- (BOOL)isTitleWhite {
     return [@"a002" containsString:_SiteId];
}
 
- (BOOL)isGPKDeposit {
     return [@"c105b" containsString:_SiteId];
}

- (BOOL)isHideFoot {
    if (Skin1.isBlack) {
         return [@"c105b" containsString:_SiteId];
    }
    return false;
}

- (BOOL)isTextWhite {
     return [@"a002" containsString:_SiteId];
}

- (BOOL)isTabMassageBadge {
    return YES;
}


- (BOOL)isTabHot {
    return [@"c208" containsString:_SiteId];
}

- (BOOL)isFireworks {
    return [@"c193" containsString:_SiteId];
}

- (BOOL)isParagraphSpacing {
    return [@"c134,c200,c213,a002" containsString:_SiteId];
}

- (BOOL)oldConversion {
    return [@"c200,a002" containsString:_SiteId];
}


- (BOOL)isRedWhite {
    if ( [@"新年红0" containsString:Skin1.skitType]) {
        return [@"c184" containsString:_SiteId];
    }
    else{
        return NO;
    }
}

- (BOOL)isShow4 {
    return [@"c200,c213,a002" containsString:_SiteId];
}

- (BOOL)isNoBorder {
    return [@"c200,c208,c213,a002" containsString:_SiteId];
}

- (BOOL)isYHShowTitle {
    return [@"c217" containsString:_SiteId];
}

- (float )borderWidthTimes          {
    if ([@"a002,c085" containsString:_SiteId]) {
        return  2.0;
    } else {
        return 1;
    }
}

- (BOOL)isChatWhite {
    if (!APP.betBgIsWhite) {
        return YES ;
    } else {
        return NO;
    }
}

- (BOOL)isHideChat {
    return [@"c212,c208" containsString:_SiteId];
}

- (BOOL)isLight {
    return [@"c134" containsString:_SiteId];
}

- (BOOL)isBall6 {
    if (Skin1.isSLH) {
        return YES;
    } else {
        return [@"c134,c200,c208,c213,a002" containsString:_SiteId];
    }
}

- (BOOL)isYellow {
    
    return [@"c085,c134,c200,c208,c213,c212,a002" containsString:_SiteId];
}

- (BOOL)isSelectStyle {
    return [@"c212,c208,c134,c200,c213,a002" containsString:_SiteId];
}


- (BOOL)isShowBorder {
    
    return [@"c212,c208,c134,c200,c213,a002" containsString:_SiteId];
    
}

- (BOOL)isShowHornView {
    return [@"l001,l002" containsString:_SiteId];
}

- (BOOL)isGrey {
    return [@"c212,c208,c134,c200,c213,a002" containsString:_SiteId];
}

- (BOOL)isBorderNavBarBgColor {
    if (Skin1.isBlack) {
        return NO;
    }
    else {
        return [@"c085,c212,c208,c134" containsString:_SiteId]||[@"石榴红" containsString:Skin1.skitType];
    }
}

- (BOOL)isBall {
    if (Skin1.isSLH) {
        return YES;
    } else {
        return [@"c212,c085,c208,c134,c200,c208,c213,a002" containsString:_SiteId];
    }
    
}

- (BOOL)isWhite {
    if (Skin1.isBlack) {
        return NO;
    } else {
        return [@"c213" containsString:_SiteId];
    }
}

- (BOOL)isHideText {
    return [@"c200" containsString:_SiteId];
}

- (BOOL)isShowJinbei {
    return [@"c085,c208,c212,c200,c213,a002" containsString:_SiteId];
}

- (BOOL)isShowWZ {
    return [@"c085" containsString:_SiteId];
}

- (BOOL)isShowLogo {
    if ([@"黑色模板" containsString:Skin1.skitType]) {
        return NO;
    } else {
        if (Skin1.isJY) {
            return YES;
        } else {
            return [@"c190" containsString:_SiteId];
        }
        
    }
}

- (BOOL)isShowArrow {
    if ([@"黑色模板" containsString:Skin1.skitType]||Skin1.isJY) {
        return NO;
    } else {
        return [@"c190" containsString:_SiteId];
    }
}


- (BOOL)isCornerRadius {
    return YES;
//    return [@"c193" containsString:_SiteId];
}

- (BOOL)isFontSystemSize {
    if (Skin1.isJY) {
        return NO;
    } else {
        return NO;
    }
    
}



- (BOOL)isBA {
    return [@"c001,c085,c208,a002,c054,c212,c200,c213" containsString:_SiteId];
}

- (BOOL)addIcons {
    return [@"c190,c134,a002" containsString:_SiteId];
}

- (BOOL)lotteryHallCustomImgS {
    return [@"c190" containsString:_SiteId];
}

- (BOOL)betOddsIsRed {
    return [@"c194,c005" containsString:_SiteId];
}

- (BOOL)betBgIsWhite {
    
    return ![@"c175,c085,c073,c169,a002,c190,c048,c200,c001,c208,c202,c212,c134,t032,c213" containsString:_SiteId] || [@"新年红,石榴红" containsString:Skin1.skitType]||Skin1.isJY;
    
}

- (BOOL)betSizeIsBig {
    return [@"c169" containsString:_SiteId];
}


#pragma mark - 热更新

- (NSString *)jspPath {
    return _NSString(@"%@/jsp%@/main.js", APP.DocumentDirectory, [_jspVersion stringByReplacingOccurrencesOfString:@"\n" withString:@""]);
}

- (void)setJspVersion:(NSString *)jspVersion {
    _jspVersion = jspVersion;
    [[NSUserDefaults standardUserDefaults] setObject:jspVersion forKey:@"jspVersion"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setRnPageInfos:(NSArray<RnPageModel *> *)rnPageInfos {
    if ([rnPageInfos.firstObject isKindOfClass:[NSDictionary class]]) {
        NSMutableArray *temp = @[].mutableCopy;
        for (NSDictionary *dict in rnPageInfos) {
            [temp addObject:[RnPageModel mj_objectWithKeyValues:dict]];
        }
        _rnPageInfos = temp.copy;
    } else {
        _rnPageInfos = rnPageInfos;
    }
}


#pragma mark - H5 url

- (NSString *)htmlStyleString:(NSString *)content {
    return _NSString(@"<head><style>img{width:auto !important;max-width:100%%;height:auto !important}</style></head>%@", content);
}

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
    _Version = _jspVersion ? : info[@"CFBundleShortVersionString"];
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