//
//  UGFundLogsModel.h
//  ug
//
//  Created by ug on 2019/8/27.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UGFundLogsModel <NSObject>

@end
// 资金明细
// {{LOCAL_HOST}}?c=user&a=fundLogs&group=1&startDate=2018-08-01&endDate=2019-08-03&page=1&rows=20&token=OOQI4q4orQ41uIdmP65NZqe1
@interface UGFundLogsModel : UGModel
@property (nonatomic, strong) NSString *time;       /**<   时间 */
@property (nonatomic, strong) NSString *changeMoney;/**<   变动金额 */
@property (nonatomic, strong) NSString *balance;    /**<   会员余额 */
@property (nonatomic, strong) NSString *category;   /**<   资金明细分类 */
@end

@interface UGFundLogsListModel : UGModel
@property (nonatomic, strong) NSArray<UGFundLogsModel> *list;
@property (nonatomic, assign) NSInteger total;      /**<   数据总数 */

@end
NS_ASSUME_NONNULL_END
