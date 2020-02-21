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

// ReactNativeHelper
#import "ReactNativeHelper.h"

#import "CodePush.h"

@implementation RnPageModel
+ (instancetype)updateVersionPage {
    RnPageModel *rpm = [RnPageModel new];
    rpm.clsName = @"UpdateVersionVC";
    rpm.fd_prefersNavigationBarHidden = true;
    rpm.允许游客访问 = true;
    rpm.允许未登录访问 = true;
    return rpm;
}
@end


@interface ReactNativeVC ()
@property (nonatomic, strong) RnPageModel *rpm;
@end

@implementation ReactNativeVC

- (BOOL)允许游客访问 { return _rpm.允许游客访问; }
- (BOOL)允许未登录访问 { return _rpm.允许未登录访问; }

+ (instancetype)shared:(RnPageModel *)rpm params:(NSDictionary<NSString *,id> * _Nullable)params {
    static ReactNativeVC *vc = nil;
    static NSMutableDictionary *blocks = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        vc = [self new];
        blocks = @{}.mutableCopy;
        NSLog(@"初始化rn");
    });
    if (rpm) {
        vc.rpm = rpm;
        vc.fd_prefersNavigationBarHidden = rpm.fd_prefersNavigationBarHidden;
        params = [ReactNativeHelper addOnceBlocks:params key:rpm.clsName];
        [ReactNativeHelper waitLaunchFinish:^(BOOL waited) {
            /*
             支持的类型
             string (NSString)
             number (NSInteger, float, double, CGFloat, NSNumber)
             boolean (BOOL, NSNumber)
             array (NSArray) 包含本列表中任意类型
             object (NSDictionary) 包含string类型的键和本列表中任意类型的值
             function (RCTResponseSenderBlock)
             */
            [ReactNativeHelper selectViewController:rpm.clsName params:params];
        }];
    }
    return vc;
}

- (void)loadView {
    NSURL *bundleURL = [CodePush bundleURL];
#ifdef DEBUG
    bundleURL = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:nil];
#endif
//    NSLog(@"当前rn版本：%@", APP.)
    self.view = [[RCTRootView alloc] initWithBundleURL:bundleURL moduleName:@"Main" initialProperties:nil launchOptions:nil];
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

- (void)setStateViewHidden:(BOOL)hidden {
    for (UIView *stateView in TabBarController1.view.subviews) {
        if ([stateView.tagString isEqualToString:@"状态栏背景View"]) {
            stateView.hidden = hidden;
            break;
        }
    }
}

@end
