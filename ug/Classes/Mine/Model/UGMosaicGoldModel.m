//
//  UGMosaicGoldModel.m
//  ug
//
//  Created by ug on 2019/9/18.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGMosaicGoldModel.h"

@implementation UGMosaicGoldParamModel

@end

@implementation UGMosaicGoldModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"mid"}];
}
@end
