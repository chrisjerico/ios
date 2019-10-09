//
//  UGLaunchPageVC.h
//  ug
//
//  Created by xionghx on 2019/10/7.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGLaunchPageVC : UIViewController
@property (strong, nonatomic) UGTabbarController *tabbar;
@end


@interface LaunchPageModel : UGModel
@property (nonatomic, strong)NSString * pic;
@end

NS_ASSUME_NONNULL_END
