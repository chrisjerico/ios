//
//  InviteCodeConfigModel.m
//  UGBWApp
//
//  Created by xionghx on 2020/11/4.
//  Copyright © 2020 ug. All rights reserved.
//

#import "InviteCodeConfigModel.h"

@implementation InviteCodeConfigModel
+ (JSONKeyMapper *)keyMapper {
	
	return [[JSONKeyMapper alloc] initWithDictionary:@{@"switch":@"codeSwith"}];
}

@end
