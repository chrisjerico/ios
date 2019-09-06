//
//  UGSignInHistoryModel.h
//  ug
//
//  Created by ug on 2019/9/6.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol UGSignInHistoryModel <NSObject>

@end
@interface UGSignInHistoryModel : UGModel<UGSignInHistoryModel>
@property (nonatomic, strong) NSString *checkinDate;//2019-09-04
@property (nonatomic, strong) NSString *integral;//"10.00"
@property (nonatomic, strong) NSString *remark;//"签到送积分"

@end

NS_ASSUME_NONNULL_END
