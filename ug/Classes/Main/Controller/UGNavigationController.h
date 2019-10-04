//
//  UGNavigationController.h
//  ug
//
//  Created by ug on 2019/5/3.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define NavController1 [UGNavigationController shared]


@interface UGNavigationController : UINavigationController
+ (instancetype)shared;
- (UIView *)topView;
@end

NS_ASSUME_NONNULL_END
