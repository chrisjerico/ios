//
//  UGWelfareLotteryController.h
//  ug
//
//  Created by ug on 2019/6/16.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGCommonLotteryController.h"

@class UGNextIssueModel;
NS_ASSUME_NONNULL_BEGIN
typedef void(^FC3DLotteryBlock)(void);

//<<<<<<< HEAD
@interface UGFC3DLotteryController :UGViewController
//=======
//@interface UGFC3DLotteryController : UGCommonLotteryController
//>>>>>>> dev_andrew
@property (nonatomic, strong) NSArray *lotteryGamesArray;
@property (nonatomic, strong) UGNextIssueModel *nextIssueModel;
@property (nonatomic, strong) NSString *gameId;

@property (nonatomic,copy)FC3DLotteryBlock gotoTabBlock;

@end

NS_ASSUME_NONNULL_END
