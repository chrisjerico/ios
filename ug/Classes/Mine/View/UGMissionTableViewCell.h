//
//  UGMissionTableViewCell.h
//  ug
//
//  Created by ug on 2019/5/10.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UGMissionModel;

NS_ASSUME_NONNULL_BEGIN
typedef void(^ReceiveMissionBlock)(void);
@interface UGMissionTableViewCell : UITableViewCell



@property (nonatomic, strong) UGMissionModel *item;
@property (nonatomic, copy) ReceiveMissionBlock receiveMissionBlock;
@end

NS_ASSUME_NONNULL_END
