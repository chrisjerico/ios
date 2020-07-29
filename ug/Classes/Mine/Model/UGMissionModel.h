//
//  UGMissionModel.h
//  ug
//
//  Created by ug on 2019/5/22.
//  Copyright © 2019 ug. All rights reserved.
//
//id 任务 sortld 分类id missionName 任务标题 missionDesc 任务描叙 integral 奖励积分 missionType 任务类型 status 0 待领任务 1 待完成 3 待领取奖励 2 已完成 overTime 截止时间 type 类型 0 一次性 1 日常任务
#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGMissionModel : UGModel

@property (nonatomic, strong) NSString *missionId;      /**<   任务id */
@property (nonatomic, strong) NSString *addTime;
@property (nonatomic, strong) NSString *completed;
@property (nonatomic, strong) NSString *integral;       /**<   完成任务后奖励的积分值 */
@property (nonatomic, assign) BOOL isDelete;
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, strong) NSString *levelId;
@property (nonatomic, strong) NSString *maxMoney;
@property (nonatomic, strong) NSString *missionDesc;    /**<   任务描叙 */
@property (nonatomic, strong) NSString *missionGame;
@property (nonatomic, strong) NSString *missionName;    /**<   任务标题 */
@property (nonatomic, strong) NSString *missionPlayed;
@property (nonatomic, strong) NSString *missionReal;
@property (nonatomic, assign) NSInteger missionType;        /**<   任务类型 */

@property (nonatomic, strong) NSString *money;
@property (nonatomic, strong) NSString *nums;
@property (nonatomic, strong) NSString *odds;
@property (nonatomic, strong) NSString *overTime;       /**<   截止时间 */
@property (nonatomic, strong) NSString *rechargeId;
@property (nonatomic, strong) NSString *sortId;         /**<   分类id */
@property (nonatomic, strong) NSString *sortName;         /**<   分类Name */
@property (nonatomic, strong) NSString *sorts;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString* status;         /**<   0 待领任务 1 待完成 3 待领取奖励 2 已完成 */
@property (nonatomic, strong) NSString* type;           /**<   类型 0一次性任务 1日常任务  5 限时任务*/


@property (nonatomic, strong) NSString *sortName2;         /**<   二级分类"Name */
//自定义参数
@property (nonatomic, strong) NSArray<UGMissionModel *> *typeArray;    /**<   type分类数据数组 */
@property (nonatomic, strong) NSArray<UGMissionModel *> *sortName2Array;    /**<   二级分类数据数组 */
@property (nonatomic, assign) BOOL isShowCell;                               /**<   二级分类数据是否展示*/
//定义枚举类型
typedef enum _CellType {
    cellTypeTitle  = 0,
    cellTypeOne,
    cellTypeMore
} CellType;
@property (nonatomic,assign) CellType celltype;           /**<   类型 0 标题  1 单行数据  2 有子数据*/
@property (nonatomic, strong) NSString *sectionTitle;                        /**<   section"Name */
@end

NS_ASSUME_NONNULL_END
