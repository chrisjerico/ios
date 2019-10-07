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

// 首页自定义游戏列表
// {{LOCAL_HOST}}?c=game&a=customGames
@interface GameModel: UGModel<GameModel>
@property(nonatomic, strong)NSString * game_id;     /**<   DOC ID */
@property(nonatomic, strong)NSString * icon;        /**<   DOC logo */
@property(nonatomic, strong)NSString * name;        /**<   DOC name */
@property(nonatomic, strong)NSString * url;         /**<   DOC链接 */
@property(nonatomic, strong)NSString * levelType;   /**<   分类层级：1 无子类 2 有子类一级分类 3 子类 */
@property(nonatomic, strong)NSString * sort;        /**<   排序 */
@property(nonatomic, strong)NSString * seriesId;    /**<   系列ID：1 普通彩票 2 真人视讯 3 捕鱼游戏 4 电子游戏 5 棋牌游戏 6 体育赛事 */
@property(nonatomic, strong)NSString * subId;       /**<   二级分类ID */
@property(nonatomic, strong)NSString * tipFlag;     /**<   标记：0 无 1 热门 */
@property(nonatomic, strong)NSString * openWay;     /**<   打开方式：0 本窗口 1 新窗口 */
@property(nonatomic, strong)NSString * title;       /**<   游戏名称 */
@property(nonatomic, strong)NSString * gameId;      /**<   游戏ID */
@property(nonatomic, strong)NSString * logo;        /**<   游戏LOGO */
@property(nonatomic, strong)NSString * docType;     /**<   是否是DOC。1=是；0=否 */
@property(nonatomic, strong)NSString * gameType;
@property(nonatomic, strong)NSString * type;        /**<   2019_09_26 彩票资料接口中的id accessRule */
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
