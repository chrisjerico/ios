//
//  UGNextIssueModel.m
//  ug
//
//  Created by ug on 2019/5/15.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGAllNextIssueListModel.h"

@implementation UGNextIssueModel
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"gameId",
                                                       @"preResult":@"preNumSx"
                                                       }];
}
@end

@implementation UGAllNextIssueListModel

@end


