//
//  UGWithdrawalViewController.h
//  ug
//
//  Created by ug on 2019/5/3.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^WithdrawSuccessBlock)(void);
@interface UGWithdrawalViewController : UIViewController
@property (nonatomic, copy) WithdrawSuccessBlock withdrawSuccessBlock;
@end

NS_ASSUME_NONNULL_END
