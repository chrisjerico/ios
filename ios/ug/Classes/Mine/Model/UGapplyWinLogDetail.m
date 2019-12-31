//
//  UGapplyWinLogDetail.m
//  ug
//
//  Created by ug on 2019/9/19.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGapplyWinLogDetail.h"

@implementation UGapplyWinLogDetail

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"mid":@"id",
                                                       @"moperator":@"operator"
                                        
                                                       }];
}

@end

