//
//  UGrealBetListModel.h
//  ug
//
//  Created by ug on 2019/9/9.
//  Copyright © 2019 ug. All rights reserved.
//
//"username": "ceshi2",
//"level": 1,
//"platform": "天豪棋牌",
//"date": "2019-08-29",
//"betAmount": "4.00",
//"validBetAmount": "4.00",
//"netAmount": "4.00",
//"comNetAmount": "4.00"
#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGrealBetListModel : UGModel
@property (nonatomic, strong) NSNumber *level;          /**<   等级 */
@property (nonatomic, strong) NSString *date;           /**<   日期 */
@property (nonatomic, strong) NSString *username;       /**<   游戏 */
@property (nonatomic, strong) NSString *validBetAmount;//有效投注
@property (nonatomic, strong) NSString *betAmount;//
@property (nonatomic, strong) NSString *netAmount;//会员输赢
@property (nonatomic, strong) NSString *comNetAmount;//
@property (nonatomic, strong) NSString *platform;//游戏名
@property (nonatomic, strong) NSString *bet_sum;//投注金额
@property (nonatomic, strong) NSString *win_amount;//会员输赢
@end

NS_ASSUME_NONNULL_END
