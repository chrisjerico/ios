//
//  UGCreditsLogModel.m
//  ug
//
//  Created by ug on 2019/9/7.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGCreditsLogModel.h"

@implementation UGCreditsLogModel

+ (JSONKeyMapper *)keyMapper {
    
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"greditsLogId"
                                                       ,@"newInt":@"gnewInt"
                                                       }];
}

@end
