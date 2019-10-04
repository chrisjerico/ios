//
//  UGYYPlatformGames.h
//  ug
//
//  Created by ug on 2019/9/30.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UGYYGames <NSObject>

@end
// 首页推荐游戏
// {{LOCAL_HOST}}?c=game&a=homeRecommend
@interface UGYYGames :UGModel<UGYYGames>
@property (nonatomic , copy) NSString              * isSeal;
@property (nonatomic , copy) NSString              * isClose;
@property (nonatomic , copy) NSString              * isInstant;
@property (nonatomic , copy) NSString              * gameId;        /**<   真人ID */
@property (nonatomic , copy) NSString              * isHot;         /**<   是否热门。1=是；0=否 */
@property (nonatomic , copy) NSString              * title;         /**<   真人名称 */
@property (nonatomic , copy) NSString              * gameTypeName;  /**<   游戏分类标识名称 */
@property (nonatomic , copy) NSString              * pic;           /**<   图片 */
@property (nonatomic , copy) NSString              * gameType;      /**<   游戏类型 */
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSNumber              * isPopup;       /**<   是否弹窗。1=是；0=否（1表示有下级菜单） */
@property (nonatomic , copy) NSString              * category;      /**<   真人分类 */
@property (nonatomic , copy) NSString              * gameCat;       /**<   游戏分类 */
@property (nonatomic , copy) NSString              * gameSymbol;    /**<   游戏标识 */
@property (nonatomic , copy) NSNumber              * supportTrial;  /**<   是否支持试玩。1=是；0=否 */
@end
@protocol UGYYPlatformGames <NSObject>

@end
@interface UGYYPlatformGames : UGModel<UGYYPlatformGames>
@property (nonatomic , copy) NSArray<UGYYGames *>  * games;         /**<   游戏列表 */
@property (nonatomic , copy) NSString              * category;      /**<   分类标识 */
@property (nonatomic , copy) NSString              * categoryName;  /**<   分类名称 */
@end

NS_ASSUME_NONNULL_END
