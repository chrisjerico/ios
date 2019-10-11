//
//  CCNetworkRequests1+HTTPS.h
//  C
//
//  Created by fish on 2018/5/11.
//  Copyright © 2018年 fish. All rights reserved.
//

#import "CCNetworkRequests1.h"

@interface CCNetworkRequests1 (HTTPS)

+ (AFHTTPSessionManager *)authSessionManager:(NSString *)urlString;

+ (NSString *)titleWithSessionModel:(CCSessionModel *)sm;
@end
