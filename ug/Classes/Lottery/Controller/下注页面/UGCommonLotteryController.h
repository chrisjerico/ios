//
//  UGCommonLotteryController.h
//  ug
//
//  Created by xionghx on 2019/10/1.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGAllNextIssueListModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol hiddeHeader <NSObject>

-(void)hideHeader;

@end

// 彩种下注页面的基类
@interface UGCommonLotteryController : UGViewController<hiddeHeader>

@property (nonatomic, assign) BOOL shoulHideHeader;
@property (nonatomic, strong) UGNextIssueModel *nextIssueModel;
@property (nonatomic, strong) NSString *gameId;
@property (nonatomic, copy) void(^gotoTabBlock)(void);

- (void)getGameDatas;
- (void)getNextIssueData;

+ (BOOL)pushWithModel:(UGNextIssueModel *)nim;

@end

NS_ASSUME_NONNULL_END
