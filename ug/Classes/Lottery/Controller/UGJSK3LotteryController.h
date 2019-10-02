//
//  UGFastThreeLotteryController.h
//  ug
//
//  Created by ug on 2019/5/17.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGCommonLotteryController.h"

@class UGNextIssueModel;
NS_ASSUME_NONNULL_BEGIN
typedef void(^JSK3LotteryBlock)(void);

//<<<<<<< HEAD
@interface UGJSK3LotteryController :UGViewController
//=======
//@interface UGJSK3LotteryController : UGCommonLotteryController
//>>>>>>> dev_andrew
@property (nonatomic, strong) NSArray *lotteryGamesArray;
@property (nonatomic, strong) UGNextIssueModel *nextIssueModel;
@property (nonatomic, strong) NSString *gameId;

@property (nonatomic,copy)JSK3LotteryBlock gotoTabBlock;

@end

NS_ASSUME_NONNULL_END
