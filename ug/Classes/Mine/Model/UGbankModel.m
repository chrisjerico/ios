//
//  UGbankModel.m
//  ug
//
//  Created by ug on 2019/6/21.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGbankModel.h"

@implementation UGbankModel
+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"bankId"}];
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"bankId":@"id"};
}
@end
