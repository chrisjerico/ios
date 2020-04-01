//
//  CCNetworkRequests1+UG.m
//  ug
//
//  Created by ug on 2020/1/7.
//  Copyright © 2020 ug. All rights reserved.
//

#import "CCNetworkRequests1+UG.h"
#import "CMTimeCommon.h"

@implementation CCNetworkRequests1 (UG)

//得到线上配置的聊天室
- (CCSessionModel *)chat_getToken{
    return [self req:@"wjapp/api.php?c=chat&a=getToken"
                    :@{@"t":[NSString stringWithFormat:@"%ld",(long)[CMTimeCommon getNowTimestamp]]}
                    :true];
}
@end
