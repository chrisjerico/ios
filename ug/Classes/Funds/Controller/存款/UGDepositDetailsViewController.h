//
//  UGDepositDetailsViewController.h
//  ug
//
//  Created by ug on 2019/9/10.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UGpaymentModel;

NS_ASSUME_NONNULL_BEGIN

@interface UGDepositDetailsViewController :UGViewController
@property (nonatomic, strong) UGpaymentModel *item;
@end

NS_ASSUME_NONNULL_END
