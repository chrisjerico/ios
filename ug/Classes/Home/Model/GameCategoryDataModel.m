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

- (NSString *)logo {
    return _logo.length ? _logo : _icon;
}
- (NSString *)icon {
    return _logo.length ? _logo : _icon;
}
@end


@implementation GameCategoryModel
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"iid"}];
}
@end


@implementation GameCategoryDataModel

@end
