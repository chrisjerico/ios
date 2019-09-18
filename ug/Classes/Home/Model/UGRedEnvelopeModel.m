//
//  UGRedEnvelopeModel.m
//  ug
//
//  Created by ug on 2019/9/17.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGRedEnvelopeModel.h"

@implementation UGRedEnvelopeModel
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"rid"}];
}
@end
