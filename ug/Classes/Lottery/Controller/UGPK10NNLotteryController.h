//
//  UGPK10LotteryController.h
//  ug
//
//  Created by ug on 2019/6/17.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGCommonLotteryController.h"

@class UGNextIssueModel;
NS_ASSUME_NONNULL_BEGIN
typedef void(^PK10NNLotteryBlock)(void);

//<<<<<<< HEAD
@interface UGPK10NNLotteryController :UGViewController
//=======
//@interface UGPK10NNLotteryController : UGCommonLotteryController
//>>>>>>> dev_andrew
@property (nonatomic, strong) NSArray *lotteryGamesArray;
@property (nonatomic, strong) UGNextIssueModel *nextIssueModel;
@property (nonatomic, strong) NSString *gameId;

@property (nonatomic,copy)PK10NNLotteryBlock gotoTabBlock;

@end

NS_ASSUME_NONNULL_END
