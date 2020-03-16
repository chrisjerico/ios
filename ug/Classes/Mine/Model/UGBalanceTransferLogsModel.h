//
//  UGBalanceTransferLogsModel.h
//  ug
//
//  Created by ug on 2019/8/29.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UGBalanceTransferLogsModel <NSObject>

@end
// 真人额度转换记录
// {{LOCAL_HOST}}?c=real&a=transferLogs&token=CPf1hrQvOEOf351cqKICcKoZ&page=1&rows=20&startTime=2019-08-22 00:00:00&endTime=2019-09-22 23:00:00
@interface UGBalanceTransferLogsModel : UGModel<UGBalanceTransferLogsModel>
@property (nonatomic, strong) NSString *logId;      /**<   记录ID */
@property (nonatomic, strong) NSString *username;   /**<   用户名 */
@property (nonatomic, strong) NSString *gameName;   /**<   真人名称 */
@property (nonatomic, strong) NSString *amount;     /**<   转换金额 */
@property (nonatomic, strong) NSString *actionTime; /**<   转换时间 */
@property (nonatomic, strong) NSString *status;     /**<   状态。1=成功；0=失败 */
@property (nonatomic, assign) BOOL isAuto;          /**<   是否自动。1=自动；0=手动 */

@end

@interface UGBalanceTransferLogsListModel : UGModel
@property (nonatomic, strong) NSArray<UGBalanceTransferLogsModel> *list;
@property (nonatomic, assign) NSInteger total;

@end

NS_ASSUME_NONNULL_END
