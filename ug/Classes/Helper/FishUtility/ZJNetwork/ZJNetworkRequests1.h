//
//  ZJNetworkRequests1.h
//  Consult
//
//  Created by fish on 2017/10/26.
//  Copyright © 2017年 fish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZJSessionModel.h"

#define NetworkManager1 [ZJNetworkRequests1 sharedManager]



@interface ZJNetworkRequests1 : NSObject<ZJRequestDelegate>

+ (instancetype)sharedManager;

- (ZJSessionModel *)req:(NSString *)pathComponent :(NSDictionary *)params :(BOOL)isPOST;

@end
