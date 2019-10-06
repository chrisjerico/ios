//
//  UGBetRecordTableViewCell.h
//  ug
//
//  Created by ug on 2019/5/17.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UGBetsRecordModel;
NS_ASSUME_NONNULL_BEGIN
typedef void(^BetsOrderCancelBlock)(void);
@interface UGBetRecordTableViewCell : UITableViewCell
@property (nonatomic, strong) UGBetsRecordModel *item;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, copy) BetsOrderCancelBlock cancelBlock;
@end

NS_ASSUME_NONNULL_END
