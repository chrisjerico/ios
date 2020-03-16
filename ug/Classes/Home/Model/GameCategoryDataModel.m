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

+ (instancetype)modelWithSeriesId:(NSInteger)seriesId subId:(NSInteger)subId {
    for (GameCategoryModel *gcm in GameCategoryDataModel.gameCategoryData.icons) {
        for (GameModel *gm in gcm.list) {
            if (gm.seriesId == seriesId && gm.subId == subId) {
                return gm;
            }
        }
    }
    
    for (GameModel *gm in GameCategoryDataModel.gameCategoryData.navs) {
        if (gm.seriesId == seriesId && gm.subId == subId) {
            return gm;
        }
    }
    return nil;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err {
    GameModel *gm = [super initWithDictionary:dict error:err];
    for (GameSubModel *gsm in gm.subType) {
        gsm.logo = gsm.icon = gm.icon;
        gsm.hot_icon = gsm.hotIcon = gm.hotIcon;
        gsm.tipFlag = gm.tipFlag;
    }
    return gm;
}

- (NSString *)title { return _title.length ? _title : _name; }
- (NSString *)logo { return _icon.length ? _icon : _logo; }
- (NSString *)icon { return _icon.length ? _icon : _logo; }
- (NSString *)hotIcon  { return _hotIcon.length ? _hotIcon : _hot_icon; }
- (NSString *)hot_icon { return _hotIcon.length ? _hotIcon : _hot_icon; }

@end


@implementation GameCategoryModel
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"iid"}];
}
@end


@implementation GameCategoryDataModel

static GameCategoryDataModel *__gameCategoryData = nil;

+ (GameCategoryDataModel *)gameCategoryData {
    return __gameCategoryData;
}

+ (void)setGameCategoryData:(GameCategoryDataModel *)gameCategoryData {
    __gameCategoryData = gameCategoryData;
}

@end
