//
//  CMNetwork+LH.h
//  ug
//
//  Created by ug on 2019/11/26.
//  Copyright © 2019 ug. All rights reserved.
//


#import "CMNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMNetwork (LH)

//老黄历
+ (void)lhlDetailWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

@end

NS_ASSUME_NONNULL_END
