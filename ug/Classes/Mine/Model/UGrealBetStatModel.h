//
//  UGrealBetStatModel.h
//  ug
//
//  Created by ug on 2019/9/9.
//  Copyright © 2019 ug. All rights reserved.
//
//"date": "2019-09-09",
//"level": 0,
//"bet_count": 0,
//"validBetAmount": "0.00",
//"bet_sum": "0.00",
//"netAmount": "0.00",
//"bet_member": 0
#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGrealBetStatModel : UGModel
@property (nonatomic, strong) NSNumber *level;          /**<   等级 */
@property (nonatomic, strong) NSString *date;           /**<   日期 */
@property (nonatomic, strong) NSString *validBetAmount;//
@property (nonatomic, strong) NSString *bet_sum;//
@property (nonatomic, strong) NSString *netAmount;//
@end

NS_ASSUME_NONNULL_END
