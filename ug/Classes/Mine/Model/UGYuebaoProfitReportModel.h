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
@interface UGYuebaoProfitReportModel : UGModel<UGYuebaoProfitReportModel>
@property (nonatomic, strong) NSString *balance;//钱包余额
@property (nonatomic, strong) NSString *settleBalance;//结算后余额
@property (nonatomic, strong) NSString *profitAmount;//收益金额
@property (nonatomic, strong) NSString *settleTime;//结算时间

@end

@interface UGYuebaoProfitReportListModel : UGModel
@property (nonatomic, strong) NSArray<UGYuebaoProfitReportModel> *list;
@property (nonatomic, assign) NSInteger total;

@end

NS_ASSUME_NONNULL_END
