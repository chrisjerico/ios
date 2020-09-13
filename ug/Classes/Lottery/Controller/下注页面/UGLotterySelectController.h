//
//  UGLotterySelectController.h
//  ug
//
//  Created by xionghx on 2019/10/8.
//  Copyright © 2019 ug. All rights reserved.
// 5

#import <UIKit/UIKit.h>
#import "UGViewController.h"
#import "UGAllNextIssueListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UGLotterySelectController : UGViewController

@property (nonatomic, copy) void(^didSelectedItemBlock)(UGNextIssueModel * model);

@end

NS_ASSUME_NONNULL_END
