//
//  UGonlineCount.h
//  ug
//
//  Created by ug on 2019/9/27.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGonlineCount : UGModel
@property (nonatomic, strong) NSNumber *onlineSwitch;
@property (nonatomic, strong) NSNumber *onlineUserCount;
@end

NS_ASSUME_NONNULL_END
