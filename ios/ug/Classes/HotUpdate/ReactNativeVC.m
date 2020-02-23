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
    rpm.vcName = @"UpdateVersionVC";
    rpm.fd_prefersNavigationBarHidden = true;
    rpm.允许游客访问 = true;
    rpm.允许未登录访问 = true;
    return rpm;
}
@end


@interface ReactNativeVC ()
@property (nonatomic, strong) RnPageModel *rpm;
@property (nonatomic, strong) NSDictionary<NSString *,id> *params;
@end

@implementation ReactNativeVC

- (BOOL)允许游客访问 { return _rpm.允许游客访问; }
- (BOOL)允许未登录访问 { return _rpm.允许未登录访问; }

static RCTRootView *_rnView;

- (void)dealloc {
    RnPageModel *rpm = _rpm;
    [ReactNativeHelper waitLaunchFinish:^(BOOL waited) {
        [ReactNativeHelper removeVC:rpm.vcName];
    }];
}

+ (instancetype)reactNativeWithRPM:(RnPageModel *)rpm params:(NSDictionary<NSString *,id> *)params {
    if (!rpm.vcName.stringByTrim.length) {
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!_rnView) {
        NSURL *bundleURL = [CodePush bundleURL];
#ifdef DEBUG
        bundleURL = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:nil];
#endif
        //    NSLog(@"当前rn版本：%@", APP.)
        _rnView = [[RCTRootView alloc] initWithBundleURL:bundleURL moduleName:@"Main" initialProperties:nil launchOptions:nil];
        _rnView.frame = APP.Bounds;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    {
        [self.view addSubview:_rnView];
        
        __weakSelf_(__self);
        [ReactNativeHelper waitLaunchFinish:^(BOOL waited) {
            [ReactNativeHelper selectVC:__self.rpm.vcName params:__self.params];
        }];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_rpm.fd_prefersNavigationBarHidden) {
        [self setStateViewHidden:true];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self setStateViewHidden:false];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _rnView.frame = self.view.bounds;
}

- (void)setStateViewHidden:(BOOL)hidden {
    for (UIView *stateView in TabBarController1.view.subviews) {
        if ([stateView.tagString isEqualToString:@"状态栏背景View"]) {
            stateView.hidden = hidden;
            break;
        }
    }
}

@end
