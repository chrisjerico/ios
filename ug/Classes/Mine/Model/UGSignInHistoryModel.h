//
//  UGSignInHistoryModel.h
//  ug
//
//  Created by ug on 2019/9/6.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol UGSignInHistoryModel <NSObject>

@end

// 签到历史（只取30天记录）
// {{LOCAL_HOST}}?c=task&a=checkinHistory&token=9mW9k1idd6tZNDOeq5N55W81
@interface UGSignInHistoryModel : UGModel<UGSignInHistoryModel>
@property (nonatomic, strong) NSString *checkinDate;    /**<   签到日期 // 2019-09-04 */
@property (nonatomic, strong) NSString *integral;       /**<   积分 // "10.00" */
@property (nonatomic, strong) NSString *remark;         /**<   备注 // "签到送积分" */

//得到俸禄
@property (nonatomic, strong) NSString *bonsId;         /**<  */
@property (nonatomic, strong) NSString *levelName;       /**<   等级名称*/
@property (nonatomic, strong) NSString *weekBons;         /**<    周俸禄*/
@property (nonatomic, strong) NSString *MonthBons;         /**<   月俸禄 */
@end

NS_ASSUME_NONNULL_END
