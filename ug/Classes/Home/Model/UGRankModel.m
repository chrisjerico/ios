//
//  UGRankModel.m
//  ug
//
//  Created by ug on 2019/6/23.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGRankModel.h"

@implementation UGRankModel

@end

@implementation UGRankListModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"switch":@"show"}];
}
@end
