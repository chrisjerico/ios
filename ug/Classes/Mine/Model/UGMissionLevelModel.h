//
//  UGMissionLevelModel.h
//  ug
//
//  Created by ug on 2019/5/22.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

// 任务头衔(VIP详情)
// {{LOCAL_HOST}}?c=task&a=levels
@interface UGMissionLevelModel : UGModel

@property (nonatomic, strong) NSString *checkinCards;   /**<   等级月补签卡可领数 */
@property (nonatomic, strong) NSString *integral;       /**<   所需积分 */
@property (nonatomic, strong) NSString *levelDesc;      /**<   描述 */
@property (nonatomic, strong) NSString *levelName;      /**<   头衔 */
@property (nonatomic, strong) NSString *levelTitle;     /**<   名称 */
@property (nonatomic, strong) NSString *amount;

@property (nonatomic, assign) NSInteger level;

@end

NS_ASSUME_NONNULL_END
