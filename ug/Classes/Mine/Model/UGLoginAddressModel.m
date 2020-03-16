//
//  UGLoginAddressModel.m
//  ug
//
//  Created by ug on 2019/7/12.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGLoginAddressModel.h"

@implementation UGLoginAddressModel

+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"addressId"}];
}
@end
