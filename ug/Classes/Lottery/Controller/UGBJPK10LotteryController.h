//
//  UGBeijingRacingController.h
//  ug
//
//  Created by ug on 2019/5/27.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGCommonLotteryController.h"

@class UGNextIssueModel;
NS_ASSUME_NONNULL_BEGIN
typedef void(^BJPK10LotteryBlock)(void);
//<<<<<<< HEAD
@interface UGBJPK10LotteryController :UGViewController
//=======
//@interface UGBJPK10LotteryController : UGCommonLotteryController
//>>>>>>> dev_andrew
@property (nonatomic, strong) NSArray *lotteryGamesArray;
@property (nonatomic, strong) UGNextIssueModel *nextIssueModel;
@property (nonatomic, strong) NSString *gameId;

@property (nonatomic,copy)BJPK10LotteryBlock gotoTabBlock;
@end

NS_ASSUME_NONNULL_END
