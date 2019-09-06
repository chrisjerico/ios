//
//  UGSignInModel.h
//  ug
//
//  Created by ug on 2019/9/5.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UGcheckinBonusModel <NSObject>

@end
@interface UGcheckinBonusModel : UGModel<UGcheckinBonusModel>
@property (nonatomic, strong) NSString *BonusInt;//20趣味豆
@property (nonatomic, strong) NSString *BonusSwitch;//"1"
@property (nonatomic, assign) BOOL isComplete;//false:当天没签到，true:当天签到了
//checkinBonus 第一个是5天签到奖励，第二个是7天签到奖励，switch 奖励是否开启领奖，isComplete 是否可以领奖
//Switch只有0 和 1；字符串
@end


@protocol UGCheckinListModel <NSObject>

@end
@interface UGCheckinListModel : UGModel<UGCheckinListModel>
@property (nonatomic, strong) NSString *week;//星期一
@property (nonatomic, strong) NSString *whichDay;//2019-09-02
@property (nonatomic, strong) NSNumber *integral;//10 金币
@property (nonatomic, assign) BOOL isCheckin;//false:当天没签到，true:当天签到了
@property (nonatomic, assign) BOOL isMakeup;//true(当天可以补签)，false(当天不可以补签)
//2：3种状态2个场景
//1：显示已签到灰色按钮；
//isCheckin：true；当天签到了
//isMakeup：false：当天不能补签；
//
//2：显示补签的红色按钮；==》可以点击补签事件
//isCheckin：false；当天没签到了
//isMakeup：true：当天可以补签；
//3：显示签到的蓝色按钮；==》可以点击签到事件
//isCheckin：false；当天没签到了
//isMakeup：false：当天不能补签；
@end


@protocol UGSignInModel <NSObject>

@end
@interface UGSignInModel : UGModel<UGSignInModel>
@property (nonatomic, strong) NSString *serverTime;//服务器时间
@property (nonatomic, strong) NSNumber *checkinTimes;//连续签到多少天
@property (nonatomic, strong) NSArray<UGCheckinListModel> *checkinList;
@property (nonatomic, strong) NSArray<UGcheckinBonusModel> *checkinBonus;


@end

NS_ASSUME_NONNULL_END
