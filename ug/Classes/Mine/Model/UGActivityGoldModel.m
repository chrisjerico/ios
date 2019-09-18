//
//  UGActivityGoldModel.m
//  ug
//
//  Created by ug on 2019/9/18.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGActivityGoldModel.h"

@implementation UGActivityGoldModel
+ (JSONKeyMapper *)keyMapper {
    
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"mid"
                                                       
                                                       }];
}
@end
