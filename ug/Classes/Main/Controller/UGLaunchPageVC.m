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
#import "UIView+AutoLocalizable.h"
#import "UGAppVersionManager.h"
#import <CodePush/CodePush.h>


@interface CodePush () {
    long long _latestExpectedContentLength;
    long long _latestReceivedConentLength;
}
- (void)dispatchDownloadProgressEvent;
@end


@interface LaunchPageModel : UGModel
@property (nonatomic) NSString *pic;
@end
@implementation LaunchPageModel
@end





@interface UGLaunchPageVC ()
@property (nonatomic, assign) BOOL waitPic;         /**<   ⌛️等启动图播放完 */
@property (nonatomic, assign) BOOL waitLanguage;    /**<   ⌛️等语言包 */
@property (nonatomic, assign) BOOL waitReactNative; /**<   ⌛️等热更新 */
@property (nonatomic, assign) BOOL waitSysConf;     /**<   ⌛️等系统配置 */
@property (nonatomic, assign) int waitCheckUpdate;  /**<   ⌛️等检查APP更新（非RN） */
@property (nonatomic, assign) BOOL waitDomainValid; /**<   ⌛️等更换域名，若所有域名都无效则无法进入首页 */
@property (nonatomic, assign) BOOL waitRnPageInfos; /**<   ⌛️等RN页面配置完毕（iPhone6机型性能差，可能进首页了配置还没好）*/
@end


@implementation UGLaunchPageVC

- (void)viewDidLoad {
	[super viewDidLoad];
    [self initNetwork];
	self.view.backgroundColor = UIColor.whiteColor;

    // 检查版本更新
    {
        _waitCheckUpdate = -1;
        __weakSelf_(__self);
        __block BOOL __isForce = false;
        [[UGAppVersionManager shareInstance] updateVersionApi:false completion:^(BOOL showUpdated, BOOL isForce) {
            __self.waitCheckUpdate = showUpdated;
            __isForce = isForce;
        }];
        [self xw_addNotificationForName:kDidAlertButtonClick block:^(NSNotification * _Nonnull noti) {
            if (!__isForce)
                __self.waitCheckUpdate = false;
        }];
    }
    
    // 加载初始配置域名
    {
        // UI更新代码
        [self initMyLaunchPageVC];
    }
}

- (void)getLotteryGroupGamesData {

    [CMNetwork getLotteryGroupGamesWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        NSLog(@"model = %@",model);
       
        [CMResult processWithResult:model success:^{
            NSArray * lotteryGamesArray =  model.data;
            
            int count = (int)lotteryGamesArray.count;
            UGAllNextIssueListModel *obj = [lotteryGamesArray objectAtIndex:0];
            
            if ((count == 1) && [obj.gameId isEqualToString:@"0"] ) {} else {
                APP.isNewLotteryView = YES;
            }
          

        } failure:^(id msg) {
            [SVProgressHUD dismiss];
        }];
    }];
}


-(void)initMyLaunchPageVC{
    
    NSLog(@"App.host = %@",APP.Host);
        // 加载初始配置
        {
//            _waitLanguage = true;
            _waitPic = true;
            _waitReactNative = true;
            _waitSysConf = true;
            _waitRnPageInfos = true;
            _waitDomainValid = true;
            
            [self loadLaunchImage];
            [self loadReactNative];
            [self loadSysConf];
            [self getLotteryGroupGamesData];
//            [self loadLanguage];
        }
        
        // 超时处理
        __weakSelf_(__self);
        {
            int timeout = 5; // ⌛️超时时间
            __block BOOL __isTimeout = false;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeout * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                __isTimeout = true;
                __self.waitSysConf = false;
                __self.waitPic = false;
                __self.waitLanguage = false;
                __self.waitCheckUpdate = __self.waitCheckUpdate > 0;
                
                if (__self.waitDomainValid) {
                    [SVProgressHUD showWithStatus:@"正在更新远程配置，请稍等片刻..."];
                }
                
                if ([[NSUserDefaults standardUserDefaults] boolForKey:@"已更新过一次RN代码"]) {
#ifndef APP_TEST
                    __self.waitReactNative = false;
#endif
                } else if (!__self.waitCheckUpdate && __self.waitReactNative) {
                    [SVProgressHUD showWithStatus:@"正在获取资源文件，请稍等片刻..."];
                }
            });
            
            
            // 显示热更新下载进度
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                __block unsigned long long __lastReceived = 0;
                __block NSDate *__lastTime = nil;
                __block NSMutableArray <NSNumber *>*__lastDurs = @[].mutableCopy;
                
                [CodePushDownloadHandler cc_hookSelector:@selector(download:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo>  _Nonnull ai) {
                    __lastTime = [NSDate date];
                } error:nil];
                
                [CodePush cc_hookSelector:@selector(dispatchDownloadProgressEvent) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo>  _Nonnull ai) {
                    long long total = [[ai.instance valueForKey:@"_latestExpectedContentLength"] doubleValue] / 1024;
                    long long received = [[ai.instance valueForKey:@"_latestReceivedConentLength"] doubleValue] / 1024;
                    if (received == __lastReceived) return;
                    long long downloadSpeed = received - __lastReceived;
                    __lastReceived = received;
                    
                    NSString *progress = [NSString stringWithFormat:@"%lld/%lld", received, total];
                    NSDate *currentTime = [NSDate date];
                    [__lastDurs addObject:@(({
                        CGFloat dur = (total - received) / (CGFloat)downloadSpeed * [currentTime timeIntervalSinceDate:__lastTime];
                        __lastTime = currentTime;
                        dur = MAX(MIN(dur / 60, 60), 1);
                        dur;
                    }))];
                    CGFloat dur = __lastDurs.firstObject.doubleValue;
                    // 为了防止“预计剩余时间”波动太大，这里缓存多个值，只显示跟上次最接近的一个值
                    if (__lastDurs.count > 4) {
                        [__lastDurs removeFirstObject];
                        CGFloat offset = 100;
                        int idx = 0;
                        for (int i=0; i<__lastDurs.count; i++) {
                            CGFloat tmpOffset = fabs(dur - __lastDurs[i].doubleValue);
                            if (tmpOffset < offset) {
                                offset = tmpOffset;
                                idx = i;
                            }
                        }
                        dur = __lastDurs[idx].doubleValue;
                        __lastDurs = @[@(dur)].mutableCopy;
                    }
                    NSString *tips = @"正在下载资源文件，请稍等片刻...";
                    if (dur > 10) {
                        tips = @"正在下载资源文件，当前网络较慢，请耐心等候，或换一个网络再试...";
                    }
                    if (__isTimeout && __self.waitReactNative) {
                        [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"%@\n（预计剩余时间%d分钟）\n\n%@", progress, (int)dur, tips]];
                    }
                } error:nil];
            });
        }
        
    // 等待所有初始配置加载完毕才进入主页
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (1) {
            [NSThread sleepForTimeInterval:0.1];
            if (__self.waitReactNative) continue;
            if (__self.waitRnPageInfos) continue;
            if (__self.waitSysConf) continue;
            if (__self.waitPic) continue;
            if (__self.waitLanguage) continue;
            if (__self.waitCheckUpdate) continue;
            if (__self.waitDomainValid) continue;
            break;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"已更新过一次RN代码"];
            NSLog(@"进入首页");
            [SVProgressHUD dismiss];
//            APP.Window.rootViewController = [[UGTabbarController alloc] init];
            APP.Window.rootViewController = [ReactNativeVC reactNativeWithRPM:({
                RnPageModel *rpm = [RnPageModel new];
                rpm.rnName = @"DoyLaunchPage";
                rpm;
            }) params:nil];
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
                [[UGSkinManagers skinWithSysConf] useSkin];
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
    // 取出上一次的启动图并播放，以防上次没下载完，这里继续下载（会缓存到本地）
    NSMutableArray *lastPics = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"LaunchPics"]];
    for (NSString *pic in lastPics) {
        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:pic] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {}];
    }
    
    
    SDAnimatedImageView *imageView = [SDAnimatedImageView new];
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.shouldCustomLoopCount = true; // 是否自定义循环次数
    imageView.animationRepeatCount = 0;     // 不循环
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // 加载图片
    __weakSelf_(__self);
    __weak_Obj_(imageView, __imageView);
    __block UIImage *__image = nil;
    void (^showPics)(void) = nil;
    void (^__block __nextPic)(void) = showPics = ^{
        NSString *pic = lastPics.firstObject;
        [lastPics removeObject:pic];
        if (!pic) {
            __self.waitPic = false;
            return;
        }
        
        // 加载图片超两秒钟就不等了
        __image = nil;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (!__image) {
                __self.waitPic = false;
            }
        });
        [__imageView sd_setImageWithURL:[NSURL URLWithString:pic] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            __image = image;
            __self.waitPic = true;
            
            // 如果是静态图则1秒后显示下一张图片
            CGFloat showTime = MAX(image.images.count / 25.0, 0.9);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(showTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                __nextPic();
            });
        }];
    };
    showPics();
    
    // 下载新的启动图
    [CMNetwork.manager requestWithMethod:[[NSString stringWithFormat:@"%@/wjapp/api.php?c=system&a=launchImages", APP.Host] stringToRestfulUrlWithFlag:RESTFUL] params:nil model:CMResultArrayClassMake(LaunchPageModel.class) post:NO completion:^(CMResult<id> *model, NSError *err) {
        if (!err) {
            NSArray <LaunchPageModel *> *launchPics = model.data;
            NSArray *newPics = [launchPics valuesWithKeyPath:@"pic"];
            if (![[NSUserDefaults standardUserDefaults] arrayForKey:@"LaunchPics"].count) {
                [lastPics setArray:newPics];
                showPics();
            }
            [[NSUserDefaults standardUserDefaults] setObject:newPics forKey:@"LaunchPics"];
            for (NSString *pic in newPics) {
                [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:pic] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {}];
            }
        }
    }];
}

- (void)loadLanguage {
    if (DisableLanguage) return;
    
    // 开启自动本地化
    [UIView enableAutoLocalizable];
    
    NSString *zhLanCode = @"zh-cn";
    
    __weakSelf_(__self);
    // 下载中文语言包
    __block int __i = 1;
    void (^getZhPackage)(void) = nil;
    void (^__block __getZhPackage)(void) = getZhPackage = ^{
        [NetworkManager1 language_getLanguagePackage:zhLanCode].completionBlock = ^(CCSessionModel *sm, id resObject, NSError *err) {
            sm.noShowErrorHUD = true;
            if (!sm.error) {
                NSString *ver = sm.resObject[@"data"][@"version"];
                NSDictionary *package = sm.resObject[@"data"][@"package"];
                [LanguageHelper save:package lanCode:zhLanCode ver:ver];
            } else {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(__i++ * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    __getZhPackage();
                });
            }
        };
    };
    getZhPackage();
    
    // 下载语言包
    __block int __j = 1;
    void (^getLanguagePackage)(NSString *lanCode) = nil;
    void (^__block __getLanguagePackage)(NSString *lanCode) = getLanguagePackage = ^(NSString *lanCode) {
        [NetworkManager1 language_getLanguagePackage:lanCode].completionBlock = ^(CCSessionModel *sm, id resObject, NSError *err) {
            sm.noShowErrorHUD = true;
            if (!sm.error) {
                NSString *ver = sm.resObject[@"data"][@"version"];
                NSDictionary *package = sm.resObject[@"data"][@"package"];
                [LanguageHelper save:package lanCode:lanCode ver:ver];
                __self.waitLanguage = false;
            } else if (__self.waitLanguage) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(__j++ * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    __getLanguagePackage(lanCode);
                });
            }
        };
    };
    
    // 获取当前语言配置
    void (^getConfigs)(void) = nil;
    void (^__block __getConfigs)(void) = getConfigs = ^{
        [NetworkManager1 language_getConfigs].completionBlock = ^(CCSessionModel *sm, id resObject, NSError *err) {
            sm.noShowErrorHUD = true;
            if (!sm.error) {
                LanguageModel *lm = [LanguageModel mj_objectWithKeyValues:sm.resObject[@"data"]];
//#ifdef DEBUG
//                lm.currentLanguageCode = @"vi";
//#endif
                [LanguageHelper shared].supportLanguagesMap = lm.supportLanguagesMap;
                [[LanguageHelper shared] setLanCode:[lm getLanCode]];
                __self.waitLanguage = ![LanguageHelper shared].hasKeys;
                
                if (![lm.currentLanguageCode isEqualToString:@"zh-cn"]) {
                    getLanguagePackage([lm getLanCode]);
                }
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
    __weakSelf_(__self);
    SANotificationEventSubscribe(@"kRnVersionUpdateFinish", self, ^(typeof (self) self, id obj) {
        NSLog(@"RN版本更新完毕");
        __self.waitReactNative = false;
    });
    SANotificationEventSubscribe(@"UGDidSetRnPageInfos", self, ^(typeof (self) self, id obj) {
        NSLog(@"RN页面配置完毕");
        __self.waitRnPageInfos = false;
    });
    SANotificationEventSubscribe(@"UGDidDomainNameChange", self, ^(typeof (self) self, id obj) {
        NSLog(@"RN域名更换完毕");
        __self.waitDomainValid = false;
    });
    ReactNativeVC *vc = [ReactNativeVC reactNativeWithRPM:[RnPageModel updateVersionPage] params:nil];
    [__self addChildViewController:vc];
    [__self.view insertSubview:vc.view atIndex:0];
#ifdef APP_TEST
    [__self.view addSubview:vc.view];
#endif
}

@end


