//
//  CustomGameModel.m
//  ug
//
//  Created by xionghx on 2019/9/19.
//  Copyright © 2019 ug. All rights reserved.
//

#import "GameCategoryDataModel.h"

@implementation GameSubModel
@end


@implementation GameModel
+ (JSONKeyMapper *)keyMapper {
	
	return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"gameId",@"gameId":@"game_id"}];
}
@end


@implementation GameCategoryModel
@end


@implementation GameCategoryDataModel

@end
