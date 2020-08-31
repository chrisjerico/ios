//
//  ScratchDataModel.m
//  UGBWApp
//
//  Created by xionghx on 2020/8/30.
//  Copyright © 2020 ug. All rights reserved.
//

#import "ScratchDataModel.h"
#import "JSONModel.h"
#import "JSONKeyMapper.h"
@implementation ScratchWinModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"scratchId"}];
}
@end
@implementation ScratchModel

//+ (NSDictionary *)mj_replacedKeyFromPropertyName {
//    return @{@"gameID":@"id"};
//}

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"gameID"}];
}

@end

@implementation ScratchDataModel



@end
