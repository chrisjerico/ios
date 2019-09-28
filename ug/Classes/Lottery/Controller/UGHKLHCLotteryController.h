//
//  UGHKMarkSixLotteryController.h
//  ug
//
//  Created by ug on 2019/5/23.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UGNextIssueModel;
NS_ASSUME_NONNULL_BEGIN
typedef void(^HKLHCLotteryBlock)(void);

@interface UGHKLHCLotteryController : UIViewController
@property (nonatomic, strong) NSArray *lotteryGamesArray;
@property (nonatomic, strong) UGNextIssueModel *nextIssueModel;
@property (nonatomic, strong) NSString *gameId;

@property (nonatomic,copy)HKLHCLotteryBlock gotoTabBlock;

@end

NS_ASSUME_NONNULL_END
