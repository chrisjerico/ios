//
//  UGMessageModel.m
//  ug
//
//  Created by ug on 2019/5/22.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGMessageModel.h"

@implementation UGMessageModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"messageId"}];
}
@end

@implementation UGMessageListModel


@end
