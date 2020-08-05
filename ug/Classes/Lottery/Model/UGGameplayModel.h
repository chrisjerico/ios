//
//  UGGameplayModel.h
//  ug
//
//  Created by ug on 2019/6/10.
//  Copyright © 2019 ug. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UGModel.h"
@class UGLotterySettingModel;
NS_ASSUME_NONNULL_BEGIN

@interface UGBetModel : UGModel
@property (nonatomic, strong) NSString *money;
@property (nonatomic, strong) NSString *playId;
@property (nonatomic, strong) NSString *odds;
@property (nonatomic, strong) NSString *betInfo;
@property (nonatomic, strong) NSString *displayInfo;
@property (nonatomic, strong) NSString *playIds;
@property (nonatomic, strong) NSString *alias;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *typeName;
@property (nonatomic, strong) NSString *from_id;

// 自定义参数
@property (nonatomic, strong) NSString *playName1;
@end

@protocol UGGameBetModel <NSObject>

@end

// 号码Model
@interface UGGameBetModel : UGModel<UGGameBetModel>

@property (nonatomic, strong) NSString *money;
@property (nonatomic, strong) NSString *playId;
@property (nonatomic, strong) NSString *odds;           /**<   赔率 */
@property (nonatomic, strong) NSString *betInfo;
@property (nonatomic, strong) NSString *displayInfo;
@property (nonatomic, strong) NSString *playIds;
@property (nonatomic, strong) NSString *alias;          /**<   玩法别名 */

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *name;           /**<   玩法名称 */
@property (nonatomic, strong) NSString *typeName;
@property (nonatomic, strong) NSString *from_id;

@property (nonatomic, strong) NSString *code;           /**<   玩法标识 */
@property (nonatomic, strong) NSString *gameId;         /**<   玩法ID */
@property (nonatomic, strong) NSString *groupId;        /**<   玩法分组ID */

@property (nonatomic, strong) NSString *offlineOdds;    /**<   线下赔率 */
@property (nonatomic, strong) NSString *minMoney;       /**<   单注最低投注金额 */
@property (nonatomic, strong) NSString *maxMoney;       /**<   单注最高投注金额 */
@property (nonatomic, strong) NSString *maxTurnMoney;   /**<   单期最高投注金额 */
@property (nonatomic, assign) BOOL isBan;



@property (nonatomic, strong) NSString *rebate;
@property (nonatomic, assign) BOOL enable;              /**<   是否启用：0=否，1=是 */
@property (nonatomic, assign) BOOL gameEnable;             /**<   是否启用：0=否，1=是   自己加的  == UGGameplaySectionModel 的enable*/
@property (nonatomic, strong) NSString *groupNum;
@property (nonatomic, strong) NSString *groupColor;



// 自定义参数
@property (nonatomic, assign) BOOL select;
@property (nonatomic, strong) NSString *typeName2;
@end

@protocol UGGameplaySectionModel <NSObject>

@end
@interface UGGameplaySectionModel : UGModel<UGGameplaySectionModel>
@property (nonatomic, strong) NSString *groupId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *playRule;/**<   玩法规则 本地 */
@property (nonatomic, strong) NSString *rule; /**<   玩法规则 网 */
@property (nonatomic, strong) NSString *typeName;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, assign) BOOL isBan;               
@property (nonatomic, assign) BOOL enable;                      /**<   是否启用，0否，1是 */
@property (nonatomic, strong) NSString *alias;                  /**<   玩法名 */
@property (nonatomic, strong) NSArray<UGGameBetModel> *lhcOddsArray;            /**<   六合彩合肖玩法赔率 */
@property (nonatomic, strong) NSArray<UGGameBetModel> *list;    /**<   号码ModelList */
@property (nonatomic, strong) NSArray<UGGameBetModel> *zxbzlist;            /**<  自选不中下注的数组 */
@property (nonatomic, strong) NSMutableArray <UGGameplaySectionModel *>*ezdwlist;            /**<  时时彩二字定位 三字定位下注的数组  福彩3D 定位胆*/
@end

@protocol UGGameplayModel <NSObject>

@end
@interface UGGameplayModel : UGModel<UGGameplayModel>
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray<UGGameplaySectionModel> *list;
@property (nonatomic, assign) BOOL select;

@end

@interface UGPlayOddsModel : UGModel

@property (nonatomic, strong) NSArray<UGGameplayModel> *playOdds;
@property (nonatomic, strong) UGLotterySettingModel *setting;

@end

NS_ASSUME_NONNULL_END
