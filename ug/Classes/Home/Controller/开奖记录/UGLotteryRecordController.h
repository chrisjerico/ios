//
//  UGLotteryRecordController.h
//  ug
//
//  Created by ug on 2019/6/2.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGAllNextIssueListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGLotteryRecordController :UGViewController
@property (nonatomic, strong) NSArray<UGAllNextIssueListModel *> *lotteryGamesArray;
@property (nonatomic, strong) NSString *gameId;

@end

NS_ASSUME_NONNULL_END
