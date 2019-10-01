//
//  UGSelFiveLotteryController.h
//  ug
//
//  Created by ug on 2019/6/15.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGCommonLotteryController.h"

@class UGNextIssueModel;
NS_ASSUME_NONNULL_BEGIN
typedef void(^GD11X5LotteryBlock)(void);

@interface UGGD11X5LotteryController : UGCommonLotteryController
@property (nonatomic, strong) NSArray *lotteryGamesArray;
@property (nonatomic, strong) UGNextIssueModel *nextIssueModel;
@property (nonatomic, strong) NSString *gameId;

@property (nonatomic,copy)GD11X5LotteryBlock gotoTabBlock;

@end

NS_ASSUME_NONNULL_END
