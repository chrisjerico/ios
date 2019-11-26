//
//  AppDefine.m
//  Consult
//
//  Created by fish on 2017/10/25.
//  Copyright © 2017年 fish. All rights reserved.
//

#import "AppDefine.h"

#define __SiteID__ @"c002"


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
        NSDictionary *dict = _allSiteIds =
        @{
            @"a002":@"https://5049uuu.com",
            @"a002a":@"",
            @"a002b":@"",
            @"a002c":@"",
            @"a002d":@"",
            @"a002e":@"",
            @"b001":@"",
            @"c001":@"https://c47c47webappqp.com",
            @"c002":@"https://154977.com",
            @"c005":@"",
            @"c006":@"https://xn--app-v85fh28j.com",
            @"c008":@"888123app.com",
            @"c011":@"https://www.hx627.com",
            @"c012":@"https://20180849.com",
            @"c015":@"",
            @"c018":@"https://031122.com",
            @"c018a":@"",
            @"c018b":@"",
            @"c021":@"",
            @"c022":@"",
            @"c028":@"",
            @"c035":@"https://5504707.com",
            @"c036":@"",
            @"c039":@"",
            @"c041":@"",
            @"c047":@"https://x22xxx.com",
            @"c048":@"https://dsjf43-43-f14-345-36-g54t-gfh54.com",
            @"c049":@"https://93922app.com",
            @"c052":@"",
            @"c053":@"https://988c53.com",
            @"c054":@"https://666mv.cc",
            @"c062":@"",
            @"c067":@"",
            @"c068":@"",
            @"c069":@"",
            @"c070":@"",
            @"c073":@"https://c73hbs.com/",
            @"c074":@"",
            @"c076":@"",
            @"c077":@"",
            @"c078":@"",
            @"c080":@"",
            @"c084":@"https://papghawshugposwaughwsoohu.com",
            @"c085":@"https://xn--20app-308h91u.com/",
            @"c085a":@"https://c10000ll.com",
            @"c087":@"",
            @"c089":@"",
            @"c090":@"",
            @"c091":@"https://83f9.com",
            @"c092":@"https://4681kkk.com",// 4681lll.com  4681mmm.com 三个都可以
            @"c105":@"",
            @"c106":@"",
            @"c108":@"https://361865.com",
            @"c112":@"",
            @"c114":@"",
            @"c115":@"",
            @"c116":@"https://13532007.com/https://88677.cc",
            @"c117":@"",
            @"c120":@"https://asafew435yrtgre.net",
            @"c125":@"",
            @"c126":@"",
            @"c129":@"https://7803000.com",
            @"c130":@"",
            @"c131":@"",
            @"c132":@"",
            @"c134":@"https://19972030.com",
            @"c136":@"",
            @"c137":@"https://7033005.com",
            @"c139":@"",
            @"c141":@"",
            @"c142":@"",
            @"c150":@"https://0187677.com",
            @"c151":@"https://xpj501501401401.vip",
            @"c153":@"https://yb247.cn",
            @"c154":@"",
            @"c155":@"",
            @"c156":@"",
            @"c157":@"",
            @"c158":@"https://9055188.com",
            @"c161":@"",
            @"c162":@"",
            @"c163":@"https://c91398.com",
            @"c164":@"",
            @"c165":@"https://1875006.com",
            @"c166":@"",
            @"c169":@"",
            @"c171":@"",
            @"c171":@"",
            @"c171a":@"",
            @"c171b":@"",
            @"c171c":@"",
            @"c171d":@"",
            @"c171e":@"",
            @"c172":@"",
            @"c173":@"https://www.dfjt1.com",
            @"c175":@"https://7053i.com",
            @"c177":@"https://lzcp11.com",
            @"c178":@"",
            @"c182":@"",
            @"c183":@"",
            @"c184":@"https://0fhcp.cn",
            @"c185":@"",
            @"c186":@"",
            @"c189":@"",
            @"c190":@"",
            @"c192":@"",
            @"c193":@"https://4906app.app",
            @"c194":@"https://hc16324app95712gj5168168app.com",
            @"c197":@"https://tycgw3.com",
            @"c198":@"https://2909tycjt.com/",
            @"c200":@"https://20191995.com",
            @"c225":@"",
            @"c601":@"",
            @"h002":@"",
            @"h003":@"",
            @"h003a":@"",
            // 测试站点
            @"test10":@"http://test10.6yc.com",
            @"c083":@"http://t111f.fhptcdn.com",
            @"test100":@"http://test100f.fhptcdn.com",
            @"老虎":@"http://t005f.fhptcdn.com",
            @"朗朗":@"http://test20.6yc.com",
            @"小东":@"http://test29f.fhptcdn.com",
            @"t032":@"http://t005f.fhptcdn.com",
        };
        _SiteId = __SiteID__;
#ifdef DEBUG
        _SiteId = [[NSUserDefaults standardUserDefaults] stringForKey:@"当前站点Key"];
        _SiteId = @"test10";
#endif
        _Host = dict[_SiteId.lowercaseString];
        if (!_Host.length) {
            #ifndef DEBUG
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


#pragma mark - Setup

- (void)setupSystem {
    _Name = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
    _BundleId = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
    _Version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    _Build = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    
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
