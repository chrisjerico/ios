//
//  UGTabbarController.h
//  ug
//
//  Created by ug on 2019/4/30.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGChatViewController.h"
#import "UGNavigationController.h"
#import "UGBalanceConversionController.h"
NS_ASSUME_NONNULL_BEGIN

@interface UGTabbarController : UITabBarController

@property (strong, nonatomic)UGBalanceConversionController *balanceConversionVC;
@property (strong, nonatomic) UGChatViewController *qdwebVC;

@property (strong, nonatomic) NSMutableArray *vcs;

@property (strong, nonatomic) UGNavigationController *nvcHome;              /**<   首页 */

@property (strong, nonatomic) UGNavigationController *nvcChangLong;         /**<   长龙助手 */

@property (strong, nonatomic) UGNavigationController *nvcLotteryList;       /**<   彩票大厅 */

@property (strong, nonatomic) UGNavigationController *nvcActivity;          /**<   优惠活动 */

@property (strong, nonatomic) UGNavigationController *nvcChatRoomList;      /**<   聊天室 */

@property (strong, nonatomic) UGNavigationController *nvcLotteryRecord;     /**<   开奖记录 */

@property (strong, nonatomic) UGNavigationController *nvcUser;              /**<   我的 */

@property (strong, nonatomic) UGNavigationController *nvcTask;              /**<   任务中心 */

@property (strong, nonatomic) UGNavigationController *nvcSecurityCenter;    /**<   安全中心 */

@property (strong, nonatomic) UGNavigationController *nvcFunds;             /**<   资金管理 */

@property (strong, nonatomic) UGNavigationController *nvcMessage;           /**<   站内信 */

@property (strong, nonatomic) UGNavigationController *nvcConversion;        /**<   额度转换 */

@property (strong, nonatomic) UGNavigationController *nvcBanks;             /**<   银行卡 */

@property (strong, nonatomic) UGNavigationController *nvcYuebao;            /**<   利息宝 */

@property (strong, nonatomic) UGNavigationController *nvcSign;              /**<   每日签到 */

@property (strong, nonatomic) UGNavigationController *nvcReferrer;          /**<   推广收益 */



@end

NS_ASSUME_NONNULL_END
