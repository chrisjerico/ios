//
//  UGGameplayModel.h
//  ug
//
//  Created by ug on 2019/6/10.
//  Copyright © 2019 ug. All rights reserved.
//

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

@end

@protocol UGGameBetModel <NSObject>

@end
@interface UGGameBetModel : UGModel<UGGameBetModel>

@property (nonatomic, strong) NSString *playId;
@property (nonatomic, strong) NSString *playIds;
@property (nonatomic, strong) NSString *betInfo;
@property (nonatomic, strong) NSString *name;           /**<   玩法名称 */
@property (nonatomic, strong) NSString *alias;          /**<   玩法别名 */
@property (nonatomic, strong) NSString *typeName;
@property (nonatomic, strong) NSString *code;           /**<   玩法标识 */
@property (nonatomic, strong) NSString *gameId;         /**<   玩法ID */
@property (nonatomic, strong) NSString *groupId;        /**<   玩法分组ID */
@property (nonatomic, strong) NSString *odds;           /**<   赔率 */
@property (nonatomic, strong) NSString *offlineOdds;    /**<   线下赔率 */
@property (nonatomic, strong) NSString *minMoney;       /**<   单注最低投注金额 */
@property (nonatomic, strong) NSString *maxMoney;       /**<   单注最高投注金额 */
@property (nonatomic, strong) NSString *maxTurnMoney;   /**<   单期最高投注金额 */
@property (nonatomic, assign) BOOL isBan;               /**<   是否禁用：0=否，1=是 */


@property (nonatomic, strong) NSString *rebate;
@property (nonatomic, assign) BOOL enable;
@property (nonatomic, strong) NSString *groupNum;
@property (nonatomic, strong) NSString *groupColor;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *money;

@property (nonatomic, assign) BOOL select;

@end

@protocol UGGameplaySectionModel <NSObject>

@end
@interface UGGameplaySectionModel : UGModel<UGGameplaySectionModel>
@property (nonatomic, strong) NSString *groupId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *typeName;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, assign) BOOL isBan;
@property (nonatomic, strong) NSString *alias;
@property (nonatomic, strong) NSArray *lhcOddsArray;//六合彩合肖玩法赔率
@property (nonatomic, strong) NSArray<UGGameBetModel> *list;

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
