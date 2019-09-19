//
//  UGapplyWinLogDetail.h
//  ug
//
//  Created by ug on 2019/9/19.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGapplyWinLogDetail : UGModel
@property (nonatomic, strong) NSString *mid;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *winId;
@property (nonatomic, strong) NSString *winName;//活动名称
@property (nonatomic, strong) NSString *amount;//申请金额
@property (nonatomic, strong) NSString *userComment;//申请原因
@property (nonatomic, strong) NSString *adminComment;
@property (nonatomic, strong) NSString *moperator;//审核说明
@property (nonatomic, strong) NSString *state;//审核结果
@property (nonatomic, strong) NSString *updateTime;//申请日期
@property (nonatomic, strong) NSString *checkTime;

@end

NS_ASSUME_NONNULL_END
