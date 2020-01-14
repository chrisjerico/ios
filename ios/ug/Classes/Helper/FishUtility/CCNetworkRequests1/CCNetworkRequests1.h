//
//  CCNetworkRequests1.h
//  Consult
//
//  Created by fish on 2017/10/26.
//  Copyright © 2017年 fish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCSessionModel.h"

#define NetworkManager1 [CCNetworkRequests1 sharedManager]



@interface CCNetworkRequests1 : NSObject<CCRequestDelegate>

+ (instancetype)sharedManager;

- (CCSessionModel *)req:(NSString *)pathComponent :(NSDictionary *)params :(BOOL)isPOST;


- (CCSessionModel *)getHotUpdateVersionList:(NSInteger)page;   /**<   获取热更新版本列表 */
- (CCSessionModel *)downloadFile:(NSString *)url;
@end
