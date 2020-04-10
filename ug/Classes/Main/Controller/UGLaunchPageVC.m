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

#ifdef isYSAPP  // 原生APP时才引用热更新文件
#import "ReactNativeHelper.h"
#import "JSPatchHelper.h"
#endif


@interface LaunchPageModel : UGModel
@property (nonatomic) NSString *pic;
@end
@implementation LaunchPageModel
@end




@implementation UGLaunchPageVC

- (void)viewDidLoad {
	[super viewDidLoad];
    [self initNetwork];
	self.view.backgroundColor = UIColor.whiteColor;
    
#ifdef isYSAPP // 原生APP时才使用热更新
//    if (APP.isFish) {
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.backgroundColor = APP.NavigationBarColor;
//        btn.frame = CGRectMake(100, 200, 200, 200);
//        [btn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
//            RnPageModel *rpm = [RnPageModel new];
//            rpm.vcName = @"UGPromotionsController";
//            [self presentViewController:[ReactNativeVC reactNativeWithRPM:rpm params:nil] animated:true completion:nil];
//        }];
//        [self.view addSubview:btn];
//        return;
//    }
    
    
    {
        // 初始化jsp
        [JSPatchHelper install];
        // 初始化rn
        ReactNativeVC *vc = [ReactNativeVC reactNativeWithRPM:[RnPageModel updateVersionPage] params:nil];
        [self addChildViewController:vc];
        [self.view addSubview:vc.view];
    }
#endif
    
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
//    各组根据行政提供的面试者实际要求的薪资情况，重新调整下台湾初中高级薪资标准
    // 加载旧的启动图
    CGFloat maxSecs = 7;    // ⌛️获取系统配置超时的等待时间
    CGFloat minSecs = 3;    // ⌛️最少等3秒
    __block BOOL __waitGif = false; // ⌛️等待gif播放完
    __block CGFloat __waitSecs = maxSecs;
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
        void (^showPics)(void) = nil;
        void (^__block __nextPic)(void) = showPics = ^{
            NSString *pic = pics.firstObject;
            [pics removeObject:pic];
            [__imageView sd_setImageWithURL:[NSURL URLWithString:pic] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                __waitSecs = MAX(__waitSecs, pics.count ? 2 : 1);// 图片加载成功后最少显示1秒
                __waitGif = image.sd_isAnimated;    // 等待gif播放完
                
                if (pics.count && !__waitGif) {
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
                __waitGif = false;
                if (pics.count) {
                    __nextPic();
                }
            }
        }];
        showPics();
    }
    
    // 检查是否强制更新
    __block HotVersionModel *__forceUpdateVersion = nil; // 强制更新的版本
    [JSPatchHelper checkUpdate:@"9999" completion:^(NSError *err, HotVersionModel *hvm) {
        if (hvm.is_force_update) {
            __forceUpdateVersion = hvm;
        }
        // 获取APP配置信息
        [CMNetwork getSystemConfigWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
            [CMResult processWithResult:model success:^{
                UGSystemConfigModel.currentConfig = model.data;
                [ReactNativeHelper waitLaunchFinish:^(BOOL waited) {
                    [ReactNativeHelper sendEvent:@"UGSystemConfigModel.currentConfig" params:[UGSystemConfigModel currentConfig]];
                }];
                SANotificationEventPost(UGNotificationGetSystemConfigComplete, nil);
            } failure:nil];
           
            // 如果很快拿到数据，就等足3秒就再去主页
            __waitSecs -= MAX(maxSecs-minSecs, 0);
        }];
    }];
    
    // 等Gif启动图显示完毕，获取系统配置完毕后才进入主页
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (1) {
            [NSThread sleepForTimeInterval:0.2];
            __waitSecs -= 0.2;
            if (__waitGif || __waitSecs > 0) {
                continue;
            }
            break;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            // 若强制更新则去rn更新页面
            if (__forceUpdateVersion) {
                APP.Window.rootViewController = [ReactNativeVC reactNativeWithRPM:[RnPageModel updateVersionPage] params:@{@"hvm":__forceUpdateVersion}];
            } else {
                APP.Window.rootViewController = [[UGTabbarController alloc] init];
            }
        });
    });
}

- (void)initNetwork {
    // 这段话是为了加载<SafariServices/SafariServices.h>库，不然打包后会无法联网（DEBUG可以是因为LogVC里面加载了）
    SFSafariViewController *sf = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
    sf.view.backgroundColor = APP.BackgroundColor;
    
}

@end

