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
@interface UGRechargeLogsModel : UGModel<UGRechargeLogsModel>
@property (nonatomic, strong) NSString *orderNo;
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *applyTime;
@property (nonatomic, strong) NSString *arriveTime;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *bankCard;
@property (nonatomic, strong) NSString *bankAccount;


@end

@interface UGRechargeLogsListModel : UGModel
@property (nonatomic, strong) NSArray<UGRechargeLogsModel> *list;
@property (nonatomic, assign) NSInteger total;

@end

NS_ASSUME_NONNULL_END
