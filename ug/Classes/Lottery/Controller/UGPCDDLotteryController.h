//
//  UGPCeggLotteryController.h
//  ug
//
//  Created by ug on 2019/6/1.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UGNextIssueModel;
NS_ASSUME_NONNULL_BEGIN
typedef void(^PCDDLotteryBlock)(void);

@interface UGPCDDLotteryController :UGViewController
@property (nonatomic, strong) NSArray *lotteryGamesArray;
@property (nonatomic, strong) UGNextIssueModel *nextIssueModel;
@property (nonatomic, strong) NSString *gameId;

@property (nonatomic,copy)PCDDLotteryBlock gotoTabBlock;

@end

NS_ASSUME_NONNULL_END
