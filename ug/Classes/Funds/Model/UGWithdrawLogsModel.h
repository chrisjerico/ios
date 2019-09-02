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
@interface UGWithdrawLogsModel : UGModel<UGWithdrawLogsModel>
@property (nonatomic, strong) NSString *orderNo;
@property (nonatomic, strong) NSString *bankName;
@property (nonatomic, strong) NSString *bankCard;
@property (nonatomic, strong) NSString *bankAccount;
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *applyTime;
@property (nonatomic, strong) NSString *arriveTime;
@property (nonatomic, strong) NSString *remark;

@end

@interface UGWithdrawLogsListModel : UGModel

@end

NS_ASSUME_NONNULL_END
