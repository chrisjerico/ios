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
@property (nonatomic, strong) NSString *BonusInt;       /**<   20趣味豆 */
@property (nonatomic, strong) NSString *BonusSwitch;    /**<   签到开关 */
@property (nonatomic, assign) BOOL isComplete;          /**<   是否已经领取  true   是，   false  否 */
@property (nonatomic, assign) BOOL isChenkin;           /**<   是否可以领取  true   是，   false  否 */


@end


@protocol UGCheckinListModel <NSObject>

@end
@interface UGCheckinListModel : UGModel<UGCheckinListModel>
@property (nonatomic, strong) NSString *week;       /**<   星期一 */
@property (nonatomic, strong) NSString *whichDay;   /**<   日期 //2019-09-02 */
@property (nonatomic, strong) NSNumber *integral;   /**<   10 金币 */
@property (nonatomic, assign) BOOL isCheckin;       /**<   是否已经签到  true 已经签到   false 还没有签到 */
@property (nonatomic, assign) BOOL isMakeup;        /**<   是否可以补签   true 可以   false 不可以 */
@property (nonatomic, strong) NSString *serverTime; /**<   服务器时间==>本地 */

@property (nonatomic, assign) BOOL mkCheckinSwitch; /**<   补签总开关  true  开，   false  关 */

//如果日期大于今天，显示签到
//如果日期小于今天，是显示补签

@end


@protocol UGSignInModel <NSObject>

@end

// 签到记录
// {{LOCAL_HOST}}?c=task&a=checkinList&token=sJ6GRng6fVFUFu16Gss01g2g
@interface UGSignInModel : UGModel<UGSignInModel>
@property (nonatomic, strong) NSString *serverTime;     /**<   服务器时间 */
@property (nonatomic, strong) NSNumber *checkinTimes;   /**<   连续签到多少天 */
@property (nonatomic, strong) NSString *checkinMoney;   /**<   积分 */
@property (nonatomic, assign) BOOL checkinSwitch;       /**<   签到总开关  true   开，   false  关 */
@property (nonatomic, assign) BOOL mkCheckinSwitch;     /**<   补签总开关  true  开，   false  关 */
@property (nonatomic, strong) NSArray<UGCheckinListModel> *checkinList;
@property (nonatomic, strong) NSArray<UGcheckinBonusModel> *checkinBonus;


@end

NS_ASSUME_NONNULL_END
