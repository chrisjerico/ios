//
//  UGPlatformGameModel.h
//  ug
//
//  Created by ug on 2019/6/14.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UGSubGameModel <NSObject>

@end
@interface UGSubGameModel : UGModel<UGSubGameModel>
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *pic;
@property (nonatomic, strong) NSString *type;


@end

@protocol UGPlatformGameModel <NSObject>

@end
// 真人列表
// {{LOCAL_HOST}}?c=game&a=realGames
@interface UGPlatformGameModel : UGModel<UGPlatformGameModel>
@property (nonatomic, strong) NSString *gameId;         /**<   真人ID */
@property (nonatomic, strong) NSString *category;       /**<   真人分类 */
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *short_name;
@property (nonatomic, strong) NSString *gameType;       /**<   游戏类型 */
@property (nonatomic, strong) NSString *gameTypeName;
@property (nonatomic, strong) NSString *gameCat;        /**<   游戏分类 */
@property (nonatomic, strong) NSString *gameSymbol;     /**<   游戏标识 */
@property (nonatomic, assign) BOOL isPopup;             /**<   是否弹窗。1=是；0=否（1表示有下级菜单） */
@property (nonatomic, strong) NSString *sort;
@property (nonatomic, strong) NSString *title;          /**<   真人名称 */
@property (nonatomic, strong) NSString *customise;
@property (nonatomic, strong) NSString *pic;            /**<   图片 */
@property (nonatomic, strong) NSString *imgName;
@property (nonatomic, assign) BOOL isHot;               /**<   是否热门。1=是；0=否 */
@property (nonatomic, strong) NSString *balance;        /**<   额度转换列表 真人余额 */
@property (nonatomic, assign) BOOL refreshing;


//@property (nonatomic, strong) NSArray<UGSubGameModel> *gameList;

@end

@protocol UGPlatformModel <NSObject>

@end
@interface UGPlatformModel : UGModel<UGPlatformModel>

@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, strong) NSArray<UGPlatformGameModel> *games;
@end

NS_ASSUME_NONNULL_END
