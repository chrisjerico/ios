//
//  UGGameplayModel.m
//  ug
//
//  Created by ug on 2019/6/10.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGGameplayModel.h"

@implementation UGBetModel

@end


@implementation UGGameBetModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id":@"playId",
                                                       @"played_groupid":@"groupId"
                                                       }];
}

@end

@implementation UGGameplaySectionModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id":@"groupId",
                                                       @"plays":@"list"
                                                       }];
}

@end

@implementation UGGameplayModel
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"playGroups":@"list"
                                                       }];
}

@end

@implementation UGPlayOddsModel


@end
