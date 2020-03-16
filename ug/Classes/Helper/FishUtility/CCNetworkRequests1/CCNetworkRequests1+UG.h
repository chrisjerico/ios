//
//  CCNetworkRequests1+UG.h
//  ug
//
//  Created by ug on 2020/1/7.
//  Copyright © 2020 ug. All rights reserved.
//



#import "CCNetworkRequests1.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCNetworkRequests1 (UG)

//得到线上配置的聊天室
- (CCSessionModel *)chat_getToken;

@end

NS_ASSUME_NONNULL_END
