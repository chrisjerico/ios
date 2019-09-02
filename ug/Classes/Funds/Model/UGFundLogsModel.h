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
@interface UGFundLogsModel : UGModel
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *changeMoney;
@property (nonatomic, strong) NSString *balance;
@property (nonatomic, strong) NSString *category;
@end

@interface UGFundLogsListModel : UGModel
@property (nonatomic, strong) NSArray<UGFundLogsModel> *list;
@property (nonatomic, assign) NSInteger total;

@end
NS_ASSUME_NONNULL_END
