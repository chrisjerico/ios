//
//  UGCommonLotteryController.h
//  ug
//
//  Created by xionghx on 2019/10/1.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGAllNextIssueListModel.h"
#import "CountDown.h"
NS_ASSUME_NONNULL_BEGIN

@protocol hiddeHeader <NSObject>

-(void)hideHeader;

@end

// 彩种下注页面的基类
@interface UGCommonLotteryController : UGViewController<hiddeHeader>

@property (nonatomic, assign) BOOL shoulHideHeader;
@property (nonatomic, strong) UGNextIssueModel *nextIssueModel;
@property (nonatomic, strong) NSString *gameId;

@property (nonatomic, strong) CountDown *nextIssueCountDown;    /**<   下期倒数器 */
@property (nonatomic, strong) NSTimer *timer;    /**<   开奖文本倒数器 */
@property (nonatomic, copy) void(^gotoTabBlock)(void);
@property (nonatomic)  BOOL hormIsOpen;                                                /**<  喇叭是否开启*/
- (void)getGameDatas;
- (void)getNextIssueData;

@end

NS_ASSUME_NONNULL_END
