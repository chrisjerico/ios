//
//  UGRechargeTypeCell.h
//  ug
//
//  Created by ug on 2019/5/3.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UGpaymentModel;
NS_ASSUME_NONNULL_BEGIN

@interface UGRechargeTypeCell : UITableViewCell

@property (nonatomic, strong) NSString *nameStr;
@property (nonatomic, strong) NSString *tipStr;
@property (nonatomic, strong) NSString *headerImageStr;
@property (weak, nonatomic) IBOutlet UIButton *mBtn;//充值按钮


@property (nonatomic, strong) UGpaymentModel *item;

@end

NS_ASSUME_NONNULL_END
