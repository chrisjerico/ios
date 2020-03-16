//
//  UGYuebaoTransferLogsModel.h
//  ug
//
//  Created by ug on 2019/8/27.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UGYuebaoTransferLogsModel <NSObject>

@end

// 余额宝额度转换记录
// {{LOCAL_HOST}}?c=yuebao&a=transferLogs&token=W8o66Hh978HsqgGSw8ww898F&page=1&rows=20&startTime=2019-08-22 00:00:00&endTime=2019-09-22 23:00:00
@interface UGYuebaoTransferLogsModel : UGModel<UGYuebaoTransferLogsModel>
@property (nonatomic, strong) NSString *amount;     /**<   变动金额 */
@property (nonatomic, strong) NSString *oldBalance; /**<   变动前金额 */
@property (nonatomic, strong) NSString *balance;    /**<   变动后金额 */
@property (nonatomic, strong) NSString *changeTime; /**<   变动时间 */
@property (nonatomic, strong) NSString *category;   /**<   变动类型：charge=转入，withdraw=转出，settle=收益结算 */

@end


@interface UGYuebaoTransferLogsListModel : UGModel

@property (nonatomic, strong) NSArray<UGYuebaoTransferLogsModel> *list;
@property (nonatomic, assign) NSInteger total;
@end

NS_ASSUME_NONNULL_END
