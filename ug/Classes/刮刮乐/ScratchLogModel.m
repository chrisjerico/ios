//
//  ScratchLogModel.m
//  UGBWApp
//
//  Created by xionghx on 2020/8/30.
//  Copyright © 2020 ug. All rights reserved.
//

#import "ScratchLogModel.h"
#import "JSONModel.h"
#import "JSONKeyMapper.h"
@implementation ScratchLogModel
//+ (JSONKeyMapper *)keyMapper {
//    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"logID"}];
//}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"logID":@"id"};
}
@end
