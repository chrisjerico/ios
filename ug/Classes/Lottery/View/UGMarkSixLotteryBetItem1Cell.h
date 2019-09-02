//
//  UGMarkSixLotteryBetItem1Cell.h
//  ug
//
//  Created by ug on 2019/5/24.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UGGameBetModel;
@class UGPlayOddsModel;
NS_ASSUME_NONNULL_BEGIN

@interface UGMarkSixLotteryBetItem1Cell : UICollectionViewCell

@property (nonatomic, strong) UGGameBetModel *item;
@property (nonatomic, strong) UGPlayOddsModel *playModel;
@property (nonatomic, assign) BOOL num4Hidden;
@end

NS_ASSUME_NONNULL_END
