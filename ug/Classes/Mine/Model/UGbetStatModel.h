//
//  UGbetStatModel.h
//  ug
//
//  Created by ug on 2019/9/8.
//  Copyright © 2019 ug. All rights reserved.
//
//"date": "2019-09-08",
//"level": 0,
//"type": 0,
//"bet_sum": "0.00",
//"bet_count": 0,
//"bet_member": 0,
//"fandian_sum": "0.00",
//"zj_sum": "0.00"
#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGbetStatModel : UGModel
@property (nonatomic, strong) NSNumber *level;      /**<   等级 */
@property (nonatomic, strong) NSString *date;       /**<   日期 */
@property (nonatomic, strong) NSString *bet_sum;    /**<   投注金额 */
@property (nonatomic, strong) NSString *fandian_sum;/**<   佣金 */
@property (nonatomic, strong) NSString *win_amount;    /**<   会员输赢 */
@end

NS_ASSUME_NONNULL_END
