//
//  UGBMLoginViewController.h
//  ug
//
//  Created by ug on 2019/11/3.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGBMLoginViewController : UIViewController
@property (nonatomic ,assign) BOOL isfromFB;//来自Fb 登录
@property (nonatomic ,assign) BOOL isNOfboauthLogin;//不需要Fb无密码登录，已经登录
@end

NS_ASSUME_NONNULL_END
