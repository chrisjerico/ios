//
//  UGPlatformGameModel.m
//  ug
//
//  Created by ug on 2019/6/14.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGPlatformGameModel.h"
@implementation UGSubGameModel


@end
@implementation UGPlatformGameModel
+ (JSONKeyMapper *)keyMapper {
    
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"gameId"}];
}

@end

@implementation UGPlatformModel


@end
