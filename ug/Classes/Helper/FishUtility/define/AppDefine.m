//
//  AppDefine.m
//  Consult
//
//  Created by fish on 2017/10/25.
//  Copyright © 2017年 fish. All rights reserved.
//

#import "AppDefine.h"
#import "UIResponder+InterfaceOrientation.h"

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

+ (void)createDirectoryAtPath:(NSString *)path {
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:true attributes:nil error:nil];
}

+ (void)setWindowInterfaceOrientation:(UIInterfaceOrientation)io {
    [UIResponder setWindowInterfaceOrientation:io];
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

+ (NSString *)stringWithInteger:(NSInteger)i {
    if (labs(i) > 9999)
        return _NSString(@"%.1fw", i/10000.0);
    return @(i).stringValue;
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

+ (double)folderSizeAtPath:(NSString *)folderPath {
    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath])
        return 0;
    NSEnumerator *childFilesEnumerator = [[[NSFileManager defaultManager] subpathsAtPath:folderPath] objectEnumerator];
    NSString *fileName;
    double folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil) {
        NSString *fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize;
}

+ (unsigned long long)fileSizeAtPath:(NSString *)filePath {
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
        return [[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil] fileSize];
    return 0;
}


#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    if (self) {
        _HOST = @"https://www.pptdaka.com:8443/";
        
        _StoreID = @"1469008808";
        
        _PhotoMaxLength = 60 * 1024;    // 约等于1M大小
        _PageCount = 20;
        _DefaultUserPhoto = @"common_default_userphoto.png";
        _DefaultUserPhotoURL = @"";
        
        _apiVersion = API_Version;
        
        _InviteCode = [[NSUserDefaults standardUserDefaults] stringForKey:@"InviteCode"];
        
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



- (void)setInviteCode:(NSString *)InviteCode {
    _InviteCode = InviteCode;
    if (InviteCode.length)
        [[NSUserDefaults standardUserDefaults] setObject:InviteCode forKey:@"InviteCode"];
}


#pragma mark - Setup

- (void)setupSystem {
    _Name = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
    _BundleId = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
    _Version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    _Build = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    
#ifdef DEBUG
    _Debug = true;
#endif
#ifdef APP_TEST
    _Test = true;
#endif
    
    _Window = [UIApplication sharedApplication].windows.firstObject;
    
    // 获取沙盒目录
    _DocumentDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    _LibraryDirectory = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
    _CachesDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    
    _StatusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    _BottomSafeHeight = _Window.height - [UITabBarController new].tabBar.by;
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
    _ShadeColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    _BlackColor = [UIColor blackColor];
    _WhiteColor = [UIColor whiteColor];
}

@end
