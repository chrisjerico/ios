//
//  UGTimeLotteryLeftTitleCell.h
//  ug
//
//  Created by ug on 2019/5/11.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UGGameplayModel;
NS_ASSUME_NONNULL_BEGIN

@interface UGTimeLotteryLeftTitleCell : UITableViewCell

@property (nonatomic, strong) UGGameplayModel *item;

@property (nonatomic, strong) NSString *title;

@end

NS_ASSUME_NONNULL_END
