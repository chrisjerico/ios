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
@interface UGBalanceTransferLogsModel : UGModel<UGBalanceTransferLogsModel>
@property (nonatomic, strong) NSString *logId;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *gameName;
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *actionTime;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, assign) BOOL isAuto;

@end

@interface UGBalanceTransferLogsListModel : UGModel
@property (nonatomic, strong) NSArray<UGBalanceTransferLogsModel> *list;
@property (nonatomic, assign) NSInteger total;

@end

NS_ASSUME_NONNULL_END
