//
//  UGFundLogsModel.m
//  ug
//
//  Created by ug on 2019/8/27.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGFundLogsModel.h"

@implementation UGFundLogsModel
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"fid"}];
}

-(instancetype)initWithFid:(NSString *)fid Name:(NSString *)name{
    if (self = [super init]) {
        self.fid = fid;
        self.name = name;
    }
    return self;
}
@end

@implementation UGFundLogsListModel

@end
