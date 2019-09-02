//
//  UGBetDetailTableViewCell.h
//  ug
//
//  Created by ug on 2019/5/14.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UGBetModel;
NS_ASSUME_NONNULL_BEGIN

typedef void(^BetDetailCellDelBlock)(void);
@interface UGBetDetailTableViewCell : UITableViewCell

@property (nonatomic, strong) UGBetModel *item;
@property (nonatomic, copy) BetDetailCellDelBlock delectBlock;

@end

NS_ASSUME_NONNULL_END
