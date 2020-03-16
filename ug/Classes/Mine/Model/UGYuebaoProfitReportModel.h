//
//  UGYuebaoProfitReportModel.h
//  ug
//
//  Created by ug on 2019/8/27.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UGYuebaoProfitReportModel <NSObject>

@end

// 收益报表
// {{LOCAL_HOST}}?c=yuebao&a=profitReport&token=W8o66Hh978HsqgGSw8ww898F&page=1&rows=20&startTime=2019-08-22 15:00:00&endTime=2019-08-28 16:00:00
@interface UGYuebaoProfitReportModel : UGModel<UGYuebaoProfitReportModel>
@property (nonatomic, strong) NSString *balance;        /**<   钱包余额 */
@property (nonatomic, strong) NSString *settleBalance;  /**<   结算后余额 */
@property (nonatomic, strong) NSString *profitAmount;   /**<   收益金额 */
@property (nonatomic, strong) NSString *settleTime;     /**<   结算时间 */

@end

@interface UGYuebaoProfitReportListModel : UGModel
@property (nonatomic, strong) NSArray<UGYuebaoProfitReportModel> *list;
@property (nonatomic, assign) NSInteger total;

@end

NS_ASSUME_NONNULL_END
