//
//  UGLaunchPageVC.m
//  ug
//
//  Created by xionghx on 2019/10/7.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGLaunchPageVC.h"

#import "FLAnimatedImageView.h"

#import <SafariServices/SafariServices.h>

#import "ReactNativeHelper.h"
#import "JSPatchHelper.h"


@interface LaunchPageModel : UGModel
@property (nonatomic) NSString *pic;
@end
@implementation LaunchPageModel
@end





@interface UGLaunchPageVC ()
@property (nonatomic, assign) BOOL waitPic;         /**<   ⌛️等静态启动图播放完 */
@property (nonatomic, assign) BOOL waitGif;         /**<   ⌛️等Git启动图播放完 */
@property (nonatomic, assign) BOOL waitLanguage;    /**<   ⌛️等语言包 */
@property (nonatomic, assign) BOOL waitReactNative; /**<   ⌛️等热更新 */
@property (nonatomic, assign) BOOL waitSysConf;     /**<   ⌛️等系统配置 */
@end


@implementation UGLaunchPageVC

- (void)viewDidLoad {
	[super viewDidLoad];
    [self initNetwork];
	self.view.backgroundColor = UIColor.whiteColor;
    

    // 加载初始配置
    {
        _waitLanguage = true;
        _waitGif = false;
        _waitPic = true;
        _waitReactNative = true;
        _waitSysConf = true;
        
        [self loadReactNative];
        [self loadSysConf];
        [self loadLaunchImage];
        [self loadLanguage];
    }
    
    // 显示超时提示
    __weakSelf_(__self);
    {
        int timeout = 7; // ⌛️超时时间
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeout * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            __self.waitSysConf = false;
            __self.waitReactNative = false;
            __self.waitLanguage = false;
        });
    }
    
    // 等待所有初始配置加载完毕才进入主页
    int minSecs = 3;   // ⌛️最少等待3秒
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(minSecs * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (1) {
            [NSThread sleepForTimeInterval:0.2];
            if (__self.waitReactNative) continue;
            if (__self.waitSysConf) continue;
            if (__self.waitPic) continue;
            if (__self.waitGif) continue;
            if (__self.waitLanguage) continue;
            break;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            APP.Window.rootViewController = [[UGTabbarController alloc] init];
        });
    });
}

- (void)initNetwork {
    // 这段话是为了加载<SafariServices/SafariServices.h>库，不然打包后会无法联网（DEBUG可以是因为LogVC里面加载了）
    SFSafariViewController *sf = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
    sf.view.backgroundColor = APP.BackgroundColor;
}


#pragma mark - 加载初始配置

- (void)loadSysConf {
    // 获取APP配置信息
    __weakSelf_(__self);
    void (^getSysConf)(void) = nil;
    void (^__block __getSysConf)(void) = getSysConf = ^{
        [CMNetwork getSystemConfigWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
            [CMResult processWithResult:model success:^{
                UGSystemConfigModel.currentConfig = model.data;
                [ReactNativeHelper waitLaunchFinish:^(BOOL waited) {
                    [ReactNativeHelper sendEvent:@"UGSystemConfigModel.currentConfig" params:[UGSystemConfigModel currentConfig]];
                }];
                SANotificationEventPost(UGNotificationGetSystemConfigComplete, nil);
                __self.waitSysConf = false;
            } failure:^(id msg) {
                if (__self.waitSysConf) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        __getSysConf();
                    });
                }
            }];
        }];
    };
    getSysConf();
}

- (void)loadLaunchImage {
    // 下载新的启动图
    [CMNetwork.manager requestWithMethod:[[NSString stringWithFormat:@"%@/wjapp/api.php?c=system&a=launchImages", APP.Host] stringToRestfulUrlWithFlag:RESTFUL] params:nil model:CMResultArrayClassMake(LaunchPageModel.class) post:NO completion:^(CMResult<id> *model, NSError *err) {
        if (!err) {
            NSArray <LaunchPageModel *> *launchPics = model.data;
            NSArray *pics = [launchPics valuesWithKeyPath:@"pic"];
            [[NSUserDefaults standardUserDefaults] setObject:pics forKey:@"LaunchPics"];
            for (NSString *pic in pics) {
                [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:pic] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {}];
            }
        }
    }];
    
    __weakSelf_(__self);
    {
        SDAnimatedImageView *imageView = [SDAnimatedImageView new];
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.shouldCustomLoopCount = true; // 是否自定义循环次数
        imageView.animationRepeatCount = 0;     // 不循环
        [self.view addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        
        NSMutableArray *pics = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"LaunchPics"]];
        // 以防上次没下载完，这里继续下载（会缓存到本地）
        for (NSString *pic in pics) {
            [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:pic] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {}];
        }
        
        // 加载图片
        __weak_Obj_(imageView, __imageView);
        __block UIImage *__image = nil;
        void (^showPics)(void) = nil;
        void (^__block __nextPic)(void) = showPics = ^{
            NSString *pic = pics.firstObject;
            [pics removeObject:pic];
            [__imageView sd_setImageWithURL:[NSURL URLWithString:pic] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                __image = image;
                __self.waitPic = true;
                __self.waitGif = image.sd_isAnimated;    // 等待gif播放完
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(pics.count ? 2 : 1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (__image == image) __self.waitPic = false;
                });
                
                if (pics.count && !__self.waitGif) {
                    // 如果是静态图则1秒后显示下一张图片
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        __nextPic();
                    });
                }
            }];
        };
        
        // 如果是gif图则播放完后显示下一张图片
        [__imageView xw_addObserverBlockForKeyPath:@"currentLoopCount" block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
            if ([newVal intValue] >= 1) {
                __self.waitGif = false;
                if (pics.count) {
                    __nextPic();
                }
            }
        }];
        showPics();
    }
}

- (void)loadLanguage {
    // 下载语言包
    __weakSelf_(__self);
    void (^getLanguagePackage)(NSString *lanCode) = nil;
    void (^__block __getLanguagePackage)(NSString *lanCode) = getLanguagePackage = ^(NSString *lanCode) {
        [NetworkManager1 language_getLanguagePackage:lanCode].completionBlock = ^(CCSessionModel *sm) {
            sm.noShowErrorHUD = true;
            if (!sm.error) {
                NSArray <NSDictionary *>*package = sm.responseObject[@"data"][@"package"];
                NSMutableDictionary *kvs = @{}.mutableCopy;
                for (NSDictionary *dict in package) {
                    kvs[dict[@"key"]] = dict[@"value"];
                }
                [[LanguageHelper shared] save:kvs lanCode:lanCode];
                __self.waitLanguage = false;
            } else if (__self.waitLanguage) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    __getLanguagePackage(lanCode);
                });
            }
        };
    };
    
    // 获取当前语言配置
    void (^getConfigs)(void) = nil;
    void (^__block __getConfigs)(void) = getConfigs = ^{
        [NetworkManager1 language_getConfigs].completionBlock = ^(CCSessionModel *sm) {
            sm.noShowErrorHUD = true;
            if (!sm.error) {
                NSString *lanCode = [[LanguageModel mj_objectWithKeyValues:sm.responseObject[@"data"]] getLanCode];
                [[LanguageHelper shared] setLanCode:lanCode];
                __self.waitLanguage = ![LanguageHelper shared].kvs.count;
                
                getLanguagePackage(lanCode);
            } else if (__self.waitLanguage) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    __getConfigs();
                });
            }
        };
    };
    getConfigs();
}

- (void)loadReactNative {
    // 初始化jsp
    [JSPatchHelper install];
    // 初始化rn
    ReactNativeVC *vc = [ReactNativeVC reactNativeWithRPM:[RnPageModel updateVersionPage] params:nil];
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    
    __weakSelf_(__self);
    [ReactNativeHelper waitLaunchFinish:^(BOOL waited) {
        [JSPatchHelper waitUpdateFinish:^{
            __self.waitReactNative = false;
        }];
    }];
    
    // 检查是否强制更新
//    __weakSelf_(__self);
//    __block HotVersionModel *__forceUpdateVersion = nil; // 强制更新的版本
//    [JSPatchHelper checkUpdate:@"9999" completion:^(NSError *err, HotVersionModel *hvm) {
//        if (hvm.is_force_update) {
//            __forceUpdateVersion = hvm;
//        }
//    }];
}

@end


