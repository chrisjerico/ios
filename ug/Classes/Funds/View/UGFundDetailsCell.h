//
//  UGFundDetailsCell.h
//  ug
//
//  Created by ug on 2019/5/3.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UGFundLogsModel;
@class UGRechargeLogsModel;
NS_ASSUME_NONNULL_BEGIN

@interface UGFundDetailsCell : UITableViewCell
@property (nonatomic, strong) UGFundLogsModel *item;

@property (nonatomic, strong) UGRechargeLogsModel *rechargeitem;
@end

NS_ASSUME_NONNULL_END

