//
//  UGYuebaoTransferLogsModel.m
//  ug
//
//  Created by ug on 2019/8/27.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGYuebaoTransferLogsModel.h"

@implementation UGYuebaoTransferLogsModel
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"newBalance":@"balance"}];
}
@end

@implementation UGYuebaoTransferLogsListModel


@end
