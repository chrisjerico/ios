//
//  UGBetListModel.h
//  ug
//
//  Created by ug on 2019/9/8.
//  Copyright © 2019 ug. All rights reserved.
//
//"username": "ceshi2",
//"level": 1,
//"type": "140",
//"lottery_name": "极速六合彩",
//"actionNo": "1909071315",
//"actionData": "红波",
//"Groupname": "色波",
//"odds": "2.7000",
//"lotteryNo": "17,28,13,12,26,36,03",
//"money": "10.00",
//"bonus": "0.0000",
//"date": "2019-09-07"
#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGBetListModel : UGModel
@property (nonatomic, strong) NSNumber *level;      /**<   等级 */
@property (nonatomic, strong) NSString *date;       /**<   日期 */
@property (nonatomic, strong) NSString *username;   /**<   用户名 */
@property (nonatomic, strong) NSString *money;      /**<   金额 */

@property (nonatomic, strong) NSString *lottery_name;   /**<   游戏名称 */
@property (nonatomic, strong) NSString *actionNo;       /**<   投注期数 */
@property (nonatomic, strong) NSString *actionData;     /**<   投注号码 */
@property (nonatomic, strong) NSString *Groupname;      /**<   玩法 */
@property (nonatomic, strong) NSString *lotteryNo;      /**<   开奖号码 */
@property (nonatomic, strong) NSString *odds;           /**<   赔率 */
@property (nonatomic, strong) NSString *bonus;          /**<   中奖金额 */

@end

NS_ASSUME_NONNULL_END
