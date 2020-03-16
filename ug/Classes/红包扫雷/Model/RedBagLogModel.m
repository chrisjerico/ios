//
//  RedBagLogModel.m
//  ug
//
//  Created by ug on 2020/2/15.
//  Copyright © 2020 ug. All rights reserved.
//

#import "RedBagLogModel.h"

@implementation RedBagLogModel

+ (JSONKeyMapper *)keyMapper {
    
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"rid"}];
}
@end
