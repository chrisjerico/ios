//
//  UGLHlotteryNumberModel.m
//  ug
//
//  Created by ug on 2019/11/28.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGLHlotteryNumberModel.h"

@implementation UGLHlotteryNumberModel
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"auto":@"autoBL"}];
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"autoBL" : @"auto"//前边的是你想用的key，后边的是返回的key
             };
}
@end
