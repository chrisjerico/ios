//
//  InviteCodeModel.m
//  UGBWApp
//
//  Created by xionghx on 2020/11/2.
//  Copyright © 2020 ug. All rights reserved.
//

#import "InviteCodeModel.h"

@implementation InviteCodeModel
+ (JSONKeyMapper *)keyMapper {
	return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"codeId"}];
}

@end
