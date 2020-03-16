//
//  UGWithdrawLogsListModel.h
//  ug
//
//  Created by ug on 2019/8/28.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UGWithdrawLogsModel <NSObject>

@end
// 提款记录
// {{LOCAL_HOST}}?c=withdraw&a=logs&token=P4m85BZpMn8SXpBxpxT0UzXN&startDate=2018-09-09&endDate=2019-09-09&page=1&rows=20
@interface UGWithdrawLogsModel : UGModel<UGWithdrawLogsModel>
@property (nonatomic, strong) NSString *orderNo;    /**<   提款单号 */
@property (nonatomic, strong) NSString *bankName;   /**<   银行名称 */
@property (nonatomic, strong) NSString *bankCard;   /**<   银行卡号 */
@property (nonatomic, strong) NSString *bankAccount;/**<   银行账户 */
@property (nonatomic, strong) NSString *amount;     /**<   提款金额 */
@property (nonatomic, strong) NSString *status;     /**<   状态 */
@property (nonatomic, strong) NSString *applyTime;  /**<   申请提款时间 */
@property (nonatomic, strong) NSString *arriveTime; /**<   到账时间 */
@property (nonatomic, strong) NSString *remark;     /**<   备注 */

@end

@interface UGWithdrawLogsListModel : UGModel

@end

NS_ASSUME_NONNULL_END
