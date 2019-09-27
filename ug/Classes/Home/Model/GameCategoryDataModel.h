//
//  CustomGameModel.h
//  ug
//
//  Created by xionghx on 2019/9/19.
//  Copyright © 2019 ug. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@protocol GameModel<NSObject>

@end


@protocol GameSubModel<NSObject>

@end

@interface GameModel: UGModel<GameModel>
@property(nonatomic, strong)NSString * game_id;
@property(nonatomic, strong)NSString * icon;
@property(nonatomic, strong)NSString * name;
@property(nonatomic, strong)NSString * url;
@property(nonatomic, strong)NSString * levelType;
@property(nonatomic, strong)NSString * sort;
@property(nonatomic, strong)NSString * seriesId;
@property(nonatomic, strong)NSString * subId;
@property(nonatomic, strong)NSString * tipFlag;
@property(nonatomic, strong)NSString * openWay;
@property(nonatomic, strong)NSString * title;
@property(nonatomic, strong)NSString * gameId;
@property(nonatomic, strong)NSString * logo;
@property(nonatomic, strong)NSString * docType;
@property(nonatomic, strong)NSString * gameType;
@property(nonatomic, strong)NSString * type; // 2019_09_26 彩票资料接口中的id accessRule
@property(nonatomic, strong)NSString * accessRule; 

@property(nonatomic, strong)NSArray<GameSubModel> * subType;

@end

@interface GameCategoryModel: UGModel
@property(nonatomic, strong)NSString * title;
@property(nonatomic, strong)NSString * alias;
@property(nonatomic, strong)NSArray<GameModel> * list;



@end

@interface GameCategoryDataModel: UGModel

@property(nonatomic, strong)GameCategoryModel * lottery;
@property(nonatomic, strong)GameCategoryModel * navigation;
@property(nonatomic, strong)GameCategoryModel * sport;
@property(nonatomic, strong)GameCategoryModel * card;
@property(nonatomic, strong)GameCategoryModel * game;
@property(nonatomic, strong)GameCategoryModel * fish;
@property(nonatomic, strong)GameCategoryModel * real;


@end



@interface GameSubModel: GameModel<GameSubModel>
@property(nonatomic, strong)NSString * parentId;
@property(nonatomic, strong)NSString * isDelete;
@property(nonatomic, strong)NSString * isInstant;
@property(nonatomic, strong)NSString * isSeal;
@property(nonatomic, strong)NSString * isClose;

@end



NS_ASSUME_NONNULL_END
