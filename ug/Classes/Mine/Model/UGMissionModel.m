
//
//  UGMissionModel.m
//  ug
//
//  Created by ug on 2019/5/22.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGMissionModel.h"

@implementation UGMissionModel

+ (JSONKeyMapper *)keyMapper {
    
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"missionId":@"id"}];
}
@end
