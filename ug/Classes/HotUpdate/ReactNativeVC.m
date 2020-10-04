//
//  ReactNativeVC.m
//  ug
//
//  Created by fish on 2020/2/13.
//  Copyright © 2020 ug. All rights reserved.
//

#import "ReactNativeVC.h"

// RCTRootView
#import <React/RCTRootView.h>
#import <React/RCTBundleURLProvider.h>

#import "CodePush.h"

@implementation RnPageModel
+ (instancetype)updateVersionPage {
    RnPageModel *rpm = [RnPageModel new];
    rpm.vcName = @"UpdateVersionPage";
    rpm.fd_prefersNavigationBarHidden = true;
    rpm.允许游客访问 = true;
    rpm.允许未登录访问 = true;
    return rpm;
}
- (NSString *)rnName { return _rnName.length ? _rnName : _vcName; }
@end


@interface ReactNativeVC ()
@property (nonatomic, strong) RnPageModel *rpm;
@property (nonatomic, strong) NSDictionary<NSString *,id> *params;
@property (nonatomic, assign) BOOL navigationBarHidden;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@end

@implementation ReactNativeVC

- (BOOL)允许游客访问 { return _rpm.允许游客访问; }
- (BOOL)允许未登录访问 { return _rpm.允许未登录访问; }

static RCTRootView *_rnView;

+ (instancetype)reactNativeWithRPM:(RnPageModel *)rpm params:(NSDictionary<NSString *,id> *)params {
    if (rpm.vcName2.length) {
        UIViewController *vc = _LoadVC_from_storyboard_(rpm.vcName2);
        if (!vc) {
            vc = [NSClassFromString(rpm.vcName2) new];
        }
        vc.允许游客访问 = rpm.允许游客访问;
        vc.允许未登录访问 = rpm.允许未登录访问;
        [vc setValuesWithDictionary:params];
        return (id)vc;
    }
    if (!rpm.rnName.stringByTrim.length) {
        return nil;
    }
    ReactNativeVC *vc = [ReactNativeVC new];
    vc.rpm = rpm;
    vc.fd_prefersNavigationBarHidden = rpm.fd_prefersNavigationBarHidden;
    /*
    支持的类型
    string (NSString)
    number (NSInteger, float, double, CGFloat, NSNumber)
    boolean (BOOL, NSNumber)
    array (NSArray) 包含本列表中任意类型
    object (NSDictionary) 包含string类型的键和本列表中任意类型的值
    function (RCTResponseSenderBlock)
    */
    vc.params = [ReactNativeHelper addOnceBlocks:params key:rpm.vcName];
    return vc;
}

+ (void)setTabbarHidden:(BOOL)hidden animated:(BOOL)animated {
    if (![NavController1.firstVC isKindOfClass:[ReactNativeVC class]]) return;
//    if (TabBarController1.tabBar.hidden == hidden) return;
    static BOOL _hidden = false;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [UGNavigationController cc_hookSelector:@selector(popViewControllerAnimated:) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo>  _Nonnull ai) {
            UGNavigationController *nav = ai.instance;
            if (nav == NavController1 &&
                nav.viewControllers.count == 2 &&
                [nav.viewControllers.firstObject isKindOfClass:[ReactNativeVC class]] &&
                _rnView.superview == nav.viewControllers.firstObject.view &&
                _hidden) {
                TabBarController1.tabBar.alpha = 0;
            }
        } error:nil];
    });
    _hidden = hidden;
    
    TabBarController1.tabBar.alpha = 1;
    if (!animated) {
        TabBarController1.tabBar.hidden = hidden;
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            TabBarController1.tabBar.by = hidden ? APP.Height+84 : APP.Height;
        } completion:^(BOOL finished) {
            NavController1.topView.frame = APP.Bounds;
        }];
    }
}

static NSString *__lastRnPage = nil;
+ (void)showLastRnPage {
    if (__lastRnPage)
        [ReactNativeHelper selectVC:__lastRnPage params:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // backgroundImageView
    [self.view addSubview:_backgroundImageView = [UIImageView new]];
    [_backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // RnView
    if (!_rnView) {
        NSURL *bundleURL = [CodePush bundleURL];
#ifdef DEBUG

//        if (TARGET_IPHONE_SIMULATOR) {
//            bundleURL = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:nil];
//        } else if (APP.isFish) {
//            bundleURL = [NSURL URLWithString:@"http://192.168.2.1:8081/index.bundle?platform=ios"];
//        }

#endif
        //    NSLog(@"当前rn版本：%@", APP.)
        _rnView = [[RCTRootView alloc] initWithBundleURL:bundleURL moduleName:@"Main" initialProperties:nil launchOptions:nil];
        _rnView.frame = APP.Bounds;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _navigationBarHidden = self.navigationController.navigationBarHidden;
    self.navigationController.navigationBarHidden = _rpm.fd_prefersNavigationBarHidden;
    
    if (_rnView.superview != self.view) {
        [self.view addSubview:_rnView];
        __weakSelf_(__self);
        [ReactNativeHelper waitLaunchFinish:^(BOOL waited) {
            __lastRnPage = __self.rpm.rnName;
            [ReactNativeHelper selectVC:__self.rpm.rnName params:__self.params];
        }];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.fd_interactivePopDisabled = _rpm.fd_interactivePopDisabled;
    if (_rpm.fd_prefersNavigationBarHidden) {
        [self setStateViewHidden:true];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (![NavController1.topViewController isKindOfClass:[ReactNativeVC class]]) {
        [ReactNativeHelper waitLaunchFinish:^(BOOL waited) {
            [ReactNativeHelper selectVC:@"TransitionPage" params:nil];
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _backgroundImageView.image = _rnView.snapshotImage;
    [self setStateViewHidden:false];
    self.navigationController.navigationBarHidden = _navigationBarHidden;
}

- (void)push:(RnPageModel *)rpm params:(NSDictionary<NSString *,id> *)params {
    [ReactNativeHelper waitLaunchFinish:^(BOOL waited) {
        __lastRnPage = rpm.rnName;
        [ReactNativeHelper selectVC:rpm.rnName params:params];
    }];
}

- (void)setStateViewHidden:(BOOL)hidden {
    for (UIView *stateView in TabBarController1.view.subviews) {
        if ([stateView.tagString isEqualToString:@"状态栏背景View"]) {
            stateView.hidden = hidden;
            break;
        }
    }
}

- (BOOL)isEqualRPM:(RnPageModel *)rpm {
    return [_rpm.rnName isEqualToString:rpm.rnName];
}

@end
