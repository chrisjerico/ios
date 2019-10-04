//
//  UGYuebaoInfoModel.h
//  ug
//
//  Created by ug on 2019/8/27.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

// 统计数据
// {{LOCAL_HOST}}?c=yuebao&a=stat&token=W8o66Hh978HsqgGSw8ww898F
@interface UGYuebaoInfoModel : UGModel
@property (nonatomic, strong) NSString *balance;            /**<   账户余额 */
@property (nonatomic, strong) NSString *giftBalance;        /**<   体验金 */
@property (nonatomic, strong) NSString *lastSettleTime;     /**<   上次结算时间 */
@property (nonatomic, strong) NSString *annualizedRate;     /**<   年化率 */
@property (nonatomic, strong) NSString *yuebaoName;         /**<   余额宝名称 */
@property (nonatomic, strong) NSString *todayProfit;        /**<   今日收益 */
@property (nonatomic, strong) NSString *weekProfit;         /**<   本周收益 */
@property (nonatomic, strong) NSString *monthProfit;        /**<   本月收益 */
@property (nonatomic, strong) NSString *totalProfit;        /**<   总收益 */
@property (nonatomic, strong) NSString *minTransferInMoney; /**<   最低转入金额 */
@property (nonatomic, strong) NSString *maxTransferOutMoney;/**<   最高转出金额 */
@property (nonatomic, strong) NSString *intro;              /**<   说明 */

@end

NS_ASSUME_NONNULL_END
