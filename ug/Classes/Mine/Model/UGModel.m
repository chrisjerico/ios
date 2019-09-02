//
//  UGModel.m
//  ug
//
//  Created by ug on 2019/5/4.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

@implementation UGModel

/// 允许所有字段为空
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return true;
}

@end
