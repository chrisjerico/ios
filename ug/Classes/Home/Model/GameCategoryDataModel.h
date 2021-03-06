//
//  CustomGameModel.h
//  ug
//
//  Created by xionghx on 2019/9/19.
//  Copyright © 2019 ug. All rights reserved.
//
//seriesId：11=注单信息
//subId列表数据：
//'1' => '彩票注单',
//'2' => '真人注单',
//'3' => '棋牌注单',
//'4' => '电子注单',
//'5' => '体育注单',
//'6' => '捕鱼注单',
//'7' => '电竞注单',


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
@property (nonatomic, strong) NSString * game_id;     /**<   DOC ID */
@property (nonatomic, strong) NSString * icon;        /**<   DOC logo */
@property (nonatomic, strong) NSString * name;        /**<   DOC name   栏目名称*/
@property (nonatomic, strong) NSString * subtitle;    /**<   2级标题 */
@property (nonatomic, strong) NSString * url;         /**<   DOC链接 */
@property (nonatomic, strong) NSString * levelType;   /**<   分类层级：1 无子类 2 有子类一级分类 3 子类 */
@property (nonatomic, strong) NSString * category;    /**<   分类的id */
@property (nonatomic, strong) NSString * sort;        /**<   排序 */
@property (nonatomic, assign) NSInteger  seriesId;    /**<   系列ID：1 普通彩票 2 真人视讯 3 捕鱼游戏 4 电子游戏 5 棋牌游戏 6 体育赛事 7导航链接  11=注单信息 */
@property (nonatomic, assign) NSInteger  subId;       /**<   1存取款 2APP下载 3聊天室 4在线客服 5长龙助手 6推广收益 7开奖网 8利息宝 9优惠活动 10游戏记录 11QQ客服 13任务大厅 14站内信 15站内信 16投诉中心 */
@property (nonatomic, assign) NSInteger  tipFlag;     /**<   标记：0 无 1 热门 2 活动 3 大奖 4 中大奖*/
@property (nonatomic, strong) NSString * openWay;     /**<   打开方式：0 本窗口 1 新窗口 */
@property (nonatomic, strong) NSString * title;       /**<   游戏名称 */
@property (nonatomic, strong) NSString * gameId;      /**<   游戏ID */
@property (nonatomic, strong) NSString * logo;        /**<   游戏LOGO */
@property (nonatomic, strong) NSString * docType;     /**<   是否是DOC。1=是；0=否 */
@property (nonatomic, strong) NSString * gameType;    /**<   彩种类型，例：gd11x5（广东11选5） */
@property (nonatomic, strong) NSString * type;        /**<   2019_09_26 彩票资料接口中的id accessRule */
@property (nonatomic, strong) NSString * accessRule;
@property (nonatomic, strong) NSString * hotIcon;     /**<   热门图标url */
@property (nonatomic, strong) NSString * hot_icon;    /**<   热门图标url */
@property (nonatomic, assign) BOOL isPopup;           /**<   是否存在二级游戏列表 */
@property (nonatomic, strong) NSString * gameCode;    /**<  第三级l */

@property(nonatomic, strong) NSArray<GameSubModel> * subType;

@property(nonatomic, strong) GameModel * list;/**<  手机资料栏目l */

//==================六合类型=============================
@property (copy, nonatomic) NSString *site_tags_id;/**<   判断是否为空，有表示是六合栏目，空为不是" */
@property (copy, nonatomic) NSString *alias;/**<   栏目别名" */
@property (copy, nonatomic) NSString *cid;/**<   栏目ID" */
@property (copy, nonatomic) NSString *isHot;/**<   是否热门 1是 0否" */
@property (copy, nonatomic) NSString *link;     /**<   客服链接地址（app用不上） */
@property (copy, nonatomic) NSString *appLink;  /**<   跳转链接地址，有值，则跳转至设置的地址" */
@property (copy, nonatomic) NSString *desc;/**<  栏目简介" */
@property (copy, nonatomic) NSString *contentId;/**<  帖子ID" */
@property (nonatomic, assign) NSInteger appLinkCode;/**<   1存取款 2APP下载 3聊天室 4在线客服 5长龙助手 6推广收益 7开奖网 8利息宝 9优惠活动 10游戏记录 11QQ客服 13任务大厅 14站内信 15站内信 16投诉中心 */

@property (copy, nonatomic) NSString *thread_type;/**<  thread_type =2 为多期" */
@property (copy, nonatomic) NSString *baomaType;/**<  报码器类型 amlhc 澳门六合彩  lhc香港六合彩 */
@property (copy, nonatomic) NSString *read_pri; /**<   可浏览会员类型：0是全部  1是正式会员 */
// 自定义参数
@property (nonatomic, readonly) NSString *categoryType; /**<   类型 */

@property (nonatomic, strong) NSString * realGameId;      /**<   自定义参数   游戏ID */

+ (instancetype)modelWithSeriesId:(NSInteger)seriesId subId:(NSInteger)subId;

- (NSComparisonResult)compareParkInfo:(GameModel *)gameModel;
@end


@interface GameCategoryModel: UGModel
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * iid;
@property (nonatomic, strong) NSString * logo;
@property (nonatomic, strong) NSString * style;
@property (nonatomic, strong) NSArray<GameModel> * list;
@property (nonatomic, strong) NSArray<GameCategoryModel> * subType;/**<   二级分类数据 */
@end



@interface GameCategoryDataModel: UGModel

@property (nonatomic, strong) NSArray<GameCategoryModel> *icons;    /**<   游戏列表 */
@property (nonatomic, strong) NSArray<GameModel> *navs;             /**<   导航按钮 */

@property (nonatomic, class) GameCategoryDataModel *gameCategoryData; /**<   首页导航按钮、游戏列表数据（升级为类方法全局使用） */
@end



@interface GameSubModel: GameModel<GameSubModel>
@property(nonatomic, strong)NSString * parentId;
@property(nonatomic, strong)NSString * isDelete;
@property(nonatomic, strong)NSString * isClose;
@property(nonatomic) BOOL isInstant;    /**<   是否是即开彩：1=是，0=否 */
@property(nonatomic) BOOL isSeal;       /**<   是否封盘:1=是，0=否 */
@end



NS_ASSUME_NONNULL_END
