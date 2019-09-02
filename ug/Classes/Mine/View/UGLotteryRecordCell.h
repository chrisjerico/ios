//
//  UGLotteryRecordCell.h
//  ug
//
//  Created by ug on 2019/7/24.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UGBetsRecordModel;
NS_ASSUME_NONNULL_BEGIN
typedef void(^LotteryBetRecordCancelBlock)(void);
@interface UGLotteryRecordCell : UITableViewCell
@property (nonatomic, strong) UGBetsRecordModel *item;
@property (nonatomic, copy) LotteryBetRecordCancelBlock cancelBlock;
@end

NS_ASSUME_NONNULL_END
