//
//  UGLaunchPageVC.m
//  ug
//
//  Created by xionghx on 2019/10/7.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGLaunchPageVC.h"

@interface LaunchPageModel : UGModel
@property (nonatomic) NSString *pic;
@end
@implementation LaunchPageModel
@end


@interface UGLaunchPageVC ()

@end

@implementation UGLaunchPageVC

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = UIColor.whiteColor;
    
    // 加载启动图
    {
        __block UIImageView *__imageView = [UIImageView new];
        [CMNetwork.manager requestWithMethod:[[NSString stringWithFormat:@"%@/wjapp/api.php?c=system&a=launchImages", baseServerUrl] stringToRestfulUrlWithFlag:RESTFUL] params:nil model:CMResultArrayClassMake(LaunchPageModel.class) post:NO completion:^(CMResult<id> *model, NSError *err) {
            if (!err) {
                NSArray<LaunchPageModel *> * launchPics = model.data;
                [[NSUserDefaults standardUserDefaults] setObject:launchPics.firstObject.pic forKey:@"launchImage"];
                [__imageView sd_setImageWithURL:[NSURL URLWithString:launchPics.firstObject.pic] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    __imageView.backgroundColor = [UIColor clearColor];
                    NSLog(@"启动图加载%@！", error ? @"失败" : @"成功");
                }];
            }
        }];
        
        [self.view addSubview:__imageView];
        [__imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        NSString *picURL = [[NSUserDefaults standardUserDefaults] valueForKey:@"launchImage"];
        [__imageView sd_setImageWithURL:[NSURL URLWithString:picURL] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            __imageView.backgroundColor = [UIColor clearColor];
            NSLog(@"启动图加载%@！", error ? @"失败" : @"成功");
        }];
    }
    
    // 获取系统配置
    NSDate *date = [NSDate date];
    [CMNetwork getSystemConfigWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            UGSystemConfigModel.currentConfig = model.data;
            [[UGSkinManagers skinWithSysConf] useSkin];
            SANotificationEventPost(UGNotificationGetSystemConfigComplete, nil);
        } failure:nil];
       
        // 进入首页
        CGFloat sec = [date timeIntervalSinceDate:[NSDate date]] + 2;
        sec = MAX(sec, 0.1);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            APP.Window.rootViewController = [[UGTabbarController alloc] init];
        });
    }];
}

@end


