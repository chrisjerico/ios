//
//  UGSevenStarsLotteryController.h
//  ug
//
//  Created by ug on 2019/6/1.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGCommonLotteryController.h"

@class UGNextIssueModel;
NS_ASSUME_NONNULL_BEGIN
typedef void(^QXCLotteryBlock)(void);

//<<<<<<< HEAD
@interface UGQXCLotteryController :UGViewController
//=======
//@interface UGQXCLotteryController : UGCommonLotteryController
//>>>>>>> dev_andrew
@property (nonatomic, strong) NSArray *lotteryGamesArray;
@property (nonatomic, strong) UGNextIssueModel *nextIssueModel;
@property (nonatomic, strong) NSString *gameId;

@property (nonatomic,copy)QXCLotteryBlock gotoTabBlock;
@end

NS_ASSUME_NONNULL_END
