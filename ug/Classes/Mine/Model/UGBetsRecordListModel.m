//
//  UGBetsRecordListModel.m
//  ug
//
//  Created by ug on 2019/7/17.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGBetsRecordListModel.h"

@implementation UGBetsRecordModel
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"betId"}];
}

@end

@implementation UGBetsRecordListModel

@end
