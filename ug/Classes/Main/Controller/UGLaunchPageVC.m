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
@property (nonatomic, assign) int waitCheckUpdate;  /**<   ⌛️等检查更新 */
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
        [self getSystemConfig];
    }
}

// 获取系统配置
- (void)getSystemConfig {
    [CMNetwork getSystemConfigWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{

            UGSystemConfigModel *config = model.data;
            UGSystemConfigModel.currentConfig = config;
            
            NSLog(@"chatShareBetMinAmount = %@",config.chatShareBetMinAmount);

            if (config.easyRememberDomain.length) {
                //是否是正确的域名
                //和本地保存的进行比对，是否一样，不一样往下走
                //保存到本地
                //App.host
                
                if (!config.easyRememberDomain.isURL) {
                   
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // UI更新代码
                        [self initMyLaunchPageVC];
                    });
                    return;
                }
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                NSString *localStr = [userDefault stringForKey:@"easyRememberDomain" ];
                
                if ([localStr isEqualToString:config.easyRememberDomain]) {
                    //不保存
                    [APP setHost:UGSystemConfigModel.currentConfig.easyRememberDomain];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // UI更新代码
                        [self initMyLaunchPageVC];
                    });
                         
                    return;
                }
                
               
                NSURL *result = [NSURL URLWithString:config.easyRememberDomain];
                
                if (result) {
                   NSString *url =  [NSString stringWithFormat:@"%@/%@",[result absoluteString],@"wjapp/api.php?c=system&a=onlineCount"];
                    
                    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
                    [request setHTTPMethod:@"HEAD"];
                    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                        NSLog(@"error %@",error);
                        if (error) {
                            NSLog(@"不可用");
                            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                            NSString *localStr = [userDefault stringForKey:@"easyRememberDomain" ];
                             
                            if (localStr.length) {
                                  [APP setHost:localStr];
                            } else {
                                  APP.Host = [APP.allSites objectWithValue:APP.SiteId.lowercaseString keyPath:@"siteId"].host;
                            }
      
                            dispatch_async(dispatch_get_main_queue(), ^{
                                // UI更新代码
                                [self initMyLaunchPageVC];
                            });
                                 
                        }else{
                            NSLog(@"可用");
                            
                            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                            [userDefault setObject:UGSystemConfigModel.currentConfig.easyRememberDomain forKey:@"easyRememberDomain"];
                            [userDefault synchronize];
                            [APP setHost:UGSystemConfigModel.currentConfig.easyRememberDomain];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                // UI更新代码
                                [self initMyLaunchPageVC];
                            });
                                 
                                        
                        }
                    }];
                    [task resume];
                }
                
                
                
            }
            else{
                //删除本地的数据
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                [userDefault setObject:nil forKey:@"easyRememberDomain"];
                [userDefault synchronize];
                APP.Host = [APP.allSites objectWithValue:APP.SiteId.lowercaseString keyPath:@"siteId"].host;
                dispatch_async(dispatch_get_main_queue(), ^{
                   // UI更新代码
                  [self initMyLaunchPageVC];
                });
                
            }
            
            SANotificationEventPost(UGNotificationGetSystemConfigComplete, nil);
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
            dispatch_async(dispatch_get_main_queue(), ^{
               // UI更新代码
              [self initMyLaunchPageVC];
            });
        }];
    }];
}


- (void)getLotteryGroupGamesData {

    [CMNetwork getLotteryGroupGamesWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        NSLog(@"model = %@",model);
       
        [CMResult processWithResult:model success:^{
            NSArray * lotteryGamesArray =  model.data;
            
            int count = (int)lotteryGamesArray.count;
            UGAllNextIssueListModel *obj = [lotteryGamesArray objectAtIndex:0];
            
            if ((count == 1) && [obj.gameId isEqualToString:@"0"] ) {
                APP.isNewLotteryView = NO;
            } else {
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
            
            [self loadLaunchImage];
            [self loadReactNative];
            [self loadSysConf];
            [self getLotteryGroupGamesData];
//            [self loadLanguage];
        }
        
        // 超时处理
        __weakSelf_(__self);
        {
            int timeout = 4; // ⌛️超时时间
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeout * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                __self.waitSysConf = false;
                __self.waitPic = false;
                __self.waitLanguage = false;
                __self.waitCheckUpdate = __self.waitCheckUpdate > 0;
#ifndef APP_TEST
                __self.waitReactNative = false;
#endif
            });
        }
        
    // 等待所有初始配置加载完毕才进入主页
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (1) {
            [NSThread sleepForTimeInterval:0.1];
            if (__self.waitReactNative) continue;
            if (__self.waitSysConf) continue;
            if (__self.waitPic) continue;
            if (__self.waitLanguage) continue;
            if (__self.waitCheckUpdate) continue;
            break;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"进入首页");
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
        [NetworkManager1 language_getLanguagePackage:zhLanCode].completionBlock = ^(CCSessionModel *sm) {
            sm.noShowErrorHUD = true;
            if (!sm.error) {
                NSString *ver = sm.responseObject[@"data"][@"version"];
                NSDictionary *package = sm.responseObject[@"data"][@"package"];
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
        [NetworkManager1 language_getLanguagePackage:lanCode].completionBlock = ^(CCSessionModel *sm) {
            sm.noShowErrorHUD = true;
            if (!sm.error) {
                NSString *ver = sm.responseObject[@"data"][@"version"];
                NSDictionary *package = sm.responseObject[@"data"][@"package"];
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
        [NetworkManager1 language_getConfigs].completionBlock = ^(CCSessionModel *sm) {
            sm.noShowErrorHUD = true;
            if (!sm.error) {
                LanguageModel *lm = [LanguageModel mj_objectWithKeyValues:sm.responseObject[@"data"]];
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
    [ReactNativeHelper waitLaunchFinish:^(BOOL waited) {
        NSLog(@"RN初始化完毕");
        __self.waitReactNative = false;
    }];
    
    ReactNativeVC *vc = [ReactNativeVC reactNativeWithRPM:[RnPageModel updateVersionPage] params:nil];
    [__self addChildViewController:vc];
    [__self.view insertSubview:vc.view atIndex:0];
#ifdef APP_TEST
    [__self.view addSubview:vc.view];
#endif
}

@end


