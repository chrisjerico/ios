//
//  UGHappyEightLotteryController.h
//  ug
//
//  Created by ug on 2019/6/16.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UGNextIssueModel;
NS_ASSUME_NONNULL_BEGIN
typedef void(^BJKL8LotteryBlock)(void);

@interface UGBJKL8LotteryController :UGViewController
@property (nonatomic, strong) NSArray *lotteryGamesArray;
@property (nonatomic, strong) UGNextIssueModel *nextIssueModel;
@property (nonatomic, strong) NSString *gameId;

@property (nonatomic,copy)BJKL8LotteryBlock gotoTabBlock;

@end

NS_ASSUME_NONNULL_END
