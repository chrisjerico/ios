//
//  UGlevelsModel.m
//  ug
//
//  Created by ug on 2019/9/7.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGlevelsModel.h"

@implementation UGlevelsModel

+ (JSONKeyMapper *)keyMapper {
    
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"levelsId"
                                                       }];
}

@end
