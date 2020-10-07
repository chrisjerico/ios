//
//  UGWithdrawalVC.h
//  UGBWApp
//
//  Created by fish on 2020/10/7.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGWithdrawalVC : UIViewController
@property (nonatomic, copy) void (^withdrawSuccessBlock)(void);
@end

NS_ASSUME_NONNULL_END
