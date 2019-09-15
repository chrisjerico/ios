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
@property (nonatomic, assign) BOOL isMakeup;//true(已经补签当天不可以补签)，false(未补签，当天可以补签)
@property (nonatomic, strong) NSString *serverTime;//服务器时间==>本地
//isCheckin：true；当天签到了  ==》是显示已签到
//isCheckin：false；当天没签到了 isMakeup：true：当天能补签；==》是显示补签到
//isCheckin：false；当天没签到了 isMakeup：false：当天不能补签；==》
//
//如果日期大于今天，显示签到
//如果日期小于今天，是显示补签

@end


@protocol UGSignInModel <NSObject>

@end
@interface UGSignInModel : UGModel<UGSignInModel>
@property (nonatomic, strong) NSString *serverTime;//服务器时间
@property (nonatomic, strong) NSNumber *checkinTimes;//连续签到多少天
@property (nonatomic, strong) NSString *checkinMoney;//积分
@property (nonatomic, strong) NSArray<UGCheckinListModel> *checkinList;
@property (nonatomic, strong) NSArray<UGcheckinBonusModel> *checkinBonus;


@end

NS_ASSUME_NONNULL_END
