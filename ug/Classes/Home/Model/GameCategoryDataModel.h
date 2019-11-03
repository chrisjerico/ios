//
//  CustomGameModel.h
//  ug
//
//  Created by xionghx on 2019/9/19.
//  Copyright © 2019 ug. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GameCategoryModel<NSObject>
@end


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
@property(nonatomic, strong)NSString * category;    /**<   图标分类 */
@property(nonatomic, strong)NSString * sort;        /**<   排序 */
@property(nonatomic, strong)NSString * seriesId;    /**<   系列ID：1 普通彩票 2 真人视讯 3 捕鱼游戏 4 电子游戏 5 棋牌游戏 6 体育赛事 7导航图标 */
@property(nonatomic, assign)NSInteger  subId;       /**<   1存取款 2APP下载 3聊天室 4在线客服 5长龙助手 6推广收益 7开奖网 8利息宝 9优惠活动 10游戏记录 11QQ客服 */
@property(nonatomic, strong)NSString * tipFlag;     /**<   标记：0 无 1 热门 */
@property(nonatomic, strong)NSString * openWay;     /**<   打开方式：0 本窗口 1 新窗口 */
@property(nonatomic, strong)NSString * title;       /**<   游戏名称 */
@property(nonatomic, strong)NSString * gameId;      /**<   游戏ID */
@property(nonatomic, strong)NSString * logo;        /**<   游戏LOGO */
@property(nonatomic, strong)NSString * docType;     /**<   是否是DOC。1=是；0=否 */
@property(nonatomic, strong)NSString * gameType;    /**<   彩种类型，例：gd11x5（广东11选5） */
@property(nonatomic, strong)NSString * type;        /**<   2019_09_26 彩票资料接口中的id accessRule */
@property(nonatomic, strong)NSString * accessRule; 

@property(nonatomic, strong)NSArray<GameSubModel> * subType;

@end


@interface GameCategoryModel: UGModel
@property(nonatomic, strong)NSString * name;
@property(nonatomic, strong)NSString * iid;
@property(nonatomic, strong)NSArray<GameModel> * list;
@end



@interface GameCategoryDataModel: UGModel

@property (nonatomic) NSArray<GameCategoryModel> *icons;    /**<   游戏列表 */
@property (nonatomic) NSArray<GameModel> *navs;             /**<   导航按钮 */
@end



@interface GameSubModel: GameModel<GameSubModel>
@property(nonatomic, strong)NSString * parentId;
@property(nonatomic, strong)NSString * isDelete;
@property(nonatomic, strong)NSString * isInstant;
@property(nonatomic, strong)NSString * isSeal;
@property(nonatomic, strong)NSString * isClose;

@end



NS_ASSUME_NONNULL_END
