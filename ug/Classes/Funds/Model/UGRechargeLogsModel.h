//
//  UGRechargeLogsModel.h
//  ug
//
//  Created by ug on 2019/8/27.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UGRechargeLogsModel <NSObject>

@end
// 充值记录
// {{LOCAL_HOST}}?c=recharge&a=logs&token=oALLC07Hc5Rba9ipchIFiBuc&startDate=2018-09-09&endDate=2019-09-26&page=1&rows=20
@interface UGRechargeLogsModel : UGModel<UGRechargeLogsModel>
@property (nonatomic, strong) NSString *orderNo;    /**<   提款单号 */
@property (nonatomic, strong) NSString *amount;     /**<   存款金额 */
@property (nonatomic, strong) NSString *applyTime;  /**<   申请提款时间 */
@property (nonatomic, strong) NSString *arriveTime; /**<   到账时间 */
@property (nonatomic, strong) NSString *status;     /**<   状态 */
@property (nonatomic, strong) NSString *category;   /**<   分类 */
@property (nonatomic, strong) NSString *remark;     /**<   备注 */
@property (nonatomic, strong) NSString *bankCard;
@property (nonatomic, strong) NSString *bankAccount;


@end

@interface UGRechargeLogsListModel : UGModel
@property (nonatomic, strong) NSArray<UGRechargeLogsModel> *list;
@property (nonatomic, assign) NSInteger total;

@end

NS_ASSUME_NONNULL_END
