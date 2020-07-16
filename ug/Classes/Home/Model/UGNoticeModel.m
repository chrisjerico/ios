//
//  UGNoticeModel.m
//  ug
//
//  Created by ug on 2019/6/23.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGNoticeModel.h"

@implementation UGNoticeModel
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"noticeId"}];
}
@end
//
//@implementation UGNoticeTypeModel
//
//@end
