//
//  UGMissionLevelModel.m
//  ug
//
//  Created by ug on 2019/5/22.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGMissionLevelModel.h"

@implementation UGMissionLevelModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"amount":@"id"}];
}
@end
