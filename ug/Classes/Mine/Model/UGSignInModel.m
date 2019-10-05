//
//  UGSignInModel.m
//  ug
//
//  Created by ug on 2019/9/5.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGSignInModel.h"

@implementation UGcheckinBonusModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"int":@"BonusInt"
                                                       ,@"switch":@"BonusSwitch"
                                                       }];
}

@end

@implementation UGCheckinListModel

@end

@implementation UGSignInModel

@end
