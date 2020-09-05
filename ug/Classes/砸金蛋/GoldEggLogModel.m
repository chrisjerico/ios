//
//  GoldEggLogModel.m
//  UGBWApp
//
//  Created by xionghx on 2020/8/27.
//  Copyright © 2020 ug. All rights reserved.
//

#import "GoldEggLogModel.h"

@implementation GoldEggLogModel
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"logID"}];
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"logID":@"id"};
}
@end
