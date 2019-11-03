//
//  UGLuckyFarmViewController.h
//  ug
//
//  Created by ug on 2019/6/16.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGCommonLotteryController.h"

@class UGNextIssueModel;
NS_ASSUME_NONNULL_BEGIN

//<<<<<<< HEAD
//@interface UGXYNCLotteryController:UGViewController
//=======
@interface UGXYNCLotteryController: UGCommonLotteryController
//>>>>>>> dev_andrew
@property (nonatomic, strong) NSArray<UGAllNextIssueListModel *> *lotteryGamesArray;
@property (nonatomic, strong) UGNextIssueModel *nextIssueModel;
@property (nonatomic, strong) NSString *gameId;
@end

NS_ASSUME_NONNULL_END
