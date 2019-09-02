//
//  UGBetDetailModel.h
//  ug
//
//  Created by ug on 2019/5/15.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGBetDetailModel : UGModel

@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *odds;
@property (nonatomic, assign) float amount;


@end

NS_ASSUME_NONNULL_END
