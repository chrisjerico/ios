//
//  UGLotteryRecordTableViewCell.h
//  ug
//
//  Created by ug on 2019/6/2.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UGLotteryHistoryModel;
NS_ASSUME_NONNULL_BEGIN

@interface UGLotteryRecordTableViewCell : UITableViewCell
@property (nonatomic) BOOL isOneRow;
@property (nonatomic, strong) UGLotteryHistoryModel *item;

@end

NS_ASSUME_NONNULL_END
