//
//  DZPModel.m
//  UGBWApp
//
//  Created by ug on 2020/5/2.
//  Copyright © 2020 ug. All rights reserved.
//

#import "DZPModel.h"

@implementation DZPprizeModel

@end


@implementation DZPparamModel

@end


@implementation DZPModel
//+ (JSONKeyMapper *)keyMapper {
//    return [[JSONKeyMapper alloc] initWithDictionary:@{@"DZPid":@"id",
//                                                       }];
//}
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"DZPid":@"id"};
}
@end
