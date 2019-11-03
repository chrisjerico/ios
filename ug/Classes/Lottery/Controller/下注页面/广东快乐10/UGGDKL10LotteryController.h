//
//  UGHappyTenLotteryController.h
//  ug
//
//  Created by ug on 2019/6/16.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGCommonLotteryController.h"

@class UGNextIssueModel;
NS_ASSUME_NONNULL_BEGIN
typedef void(^GDKL10LotteryBlock)(void);

//<<<<<<< HEAD
//@interface UGGDKL10LotteryController :UGViewController
//=======
@interface UGGDKL10LotteryController : UGCommonLotteryController
//>>>>>>> dev_andrew
@property (nonatomic, strong) NSArray<UGAllNextIssueListModel *> *lotteryGamesArray;
@property (nonatomic, strong) UGNextIssueModel *nextIssueModel;
@property (nonatomic, strong) NSString *gameId;

@property (nonatomic,copy)GDKL10LotteryBlock gotoTabBlock;

@end

NS_ASSUME_NONNULL_END
