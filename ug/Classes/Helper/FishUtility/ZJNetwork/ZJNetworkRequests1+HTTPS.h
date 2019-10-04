//
//  ZJNetworkRequests1+HTTPS.h
//  C
//
//  Created by fish on 2018/5/11.
//  Copyright © 2018年 fish. All rights reserved.
//

#import "ZJNetworkRequests1.h"

@interface ZJNetworkRequests1 (HTTPS)

+ (AFHTTPSessionManager *)authSessionManager:(NSString *)urlString;

+ (NSString *)titleWithSessionModel:(ZJSessionModel *)sm;
@end
