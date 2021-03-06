//
//  UGBetsRecordListModel.h
//  ug
//
//  Created by ug on 2019/7/17.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol UGBetDetailsModel <NSObject>

@end

@interface UGBetDetailsModel : UGModel
@property (nonatomic, assign) NSInteger status;              /**<   */
@property (nonatomic, strong) NSString *url;     /**<   请求url */

@end

@protocol UGBetsRecordModel <NSObject>

@end

// 注单列表
// {{LOCAL_HOST}}?c=ticket&a=history&status=3&category=lottery&token=j7DdnGnH0j34C4AzIM4NA3p0&page=1&rows=15
@interface UGBetsRecordModel : UGModel
@property (nonatomic, strong) NSString *betId;          /**<   注单ID */
@property (nonatomic, assign) NSInteger gameType;
@property (nonatomic, strong) NSString *gameTypeName;
@property (nonatomic, strong) NSString *gameName;       /**<   游戏名称（彩种） */
@property (nonatomic, strong) NSString *playGroupName;  /**<   游戏分类名称（彩票） */
@property (nonatomic, strong) NSString *playName;       /**<   游戏玩法（彩票） */
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *betAmount;      /**<   下注金额 */
@property (nonatomic, strong) NSString *betTime;        /**<   下注时间 */
@property (nonatomic, strong) NSString *validBetAmount; /**<   有效投注金额（真人） */
@property (nonatomic, strong) NSString *winAmount;      /**<   输赢金额 */
@property (nonatomic, strong) NSString *settleAmount;   /**<   结算金额 （彩票） */
@property (nonatomic, strong) NSString *lotteryNo;      /**<   开奖号（彩票） */
@property (nonatomic, assign) NSInteger status;         /**<   注单状态 1=待开奖，2=已中奖，3=未中奖，4=已撤单 */
@property (nonatomic, strong) NSString *playCateId;
@property (nonatomic, strong) NSString *statusName;
@property (nonatomic, strong) NSString *odds;           /**<   赔率（彩票） */
@property (nonatomic, strong) NSString *bet_detail;      /**<   详情跳转url */

@property (nonatomic, strong) NSString *betInfo;        /**<   下注号码 */
@property (nonatomic, strong) NSString *expectAmount;   /**<   可赢金额 */
@property (nonatomic, assign) BOOL isAllowCancel;       /**<   是否允许撤单 */

@property (nonatomic, strong) NSString *issue;          /**<   彩票期号（彩票） */
@property (nonatomic, copy) NSString *displayNumber;     //开奖期数  自营优先使用
//==========注单明细
@property (nonatomic, strong) NSString *date;           /**<  时间  */
@property (nonatomic, strong) NSString *dayOfWeek;          /**<   星期 */

@property (nonatomic, strong) NSString *winCount;   /**<   中奖笔数 */
//@property (nonatomic, strong) NSString *winAmount;   /**<   中奖金额 */
@property (nonatomic, strong) NSString *winLoseAmount;   /**<  输赢 */
//==========下注明细
@property (nonatomic, strong) NSString *title;           /**<  彩種  */
@property (nonatomic, strong) NSString *betCount;        /**<  笔数*/
@property (nonatomic, strong) NSString *betMoney;          /**<   下注金额*/
@property (nonatomic, strong) NSString *rewardRebate;        /**<  輸贏*/
@property (nonatomic, strong) UGBetDetailsModel *bet_details; /**<  请求url*/
@property (nonatomic, strong) NSString *token;              /**<    */
@property (nonatomic, strong) NSString *ticketNo;         /**<   笔数*/

@end

@interface UGBetsRecordListModel : UGModel
@property (nonatomic, assign) NSInteger total;              /**<   数据总数 */
@property (nonatomic, strong) NSString *totalBetAmount;     /**<   总下注金额 */
@property (nonatomic, strong) NSString *totalWinAmount;     /**<   输赢总金额 */
@property (nonatomic, strong) NSString *totalBetCount;     /**<   总下注笔数 */
@property (nonatomic, strong) NSString *token;              /**<    */
@property (nonatomic, strong) NSArray<UGBetsRecordModel> *list;

@property (nonatomic, strong) NSArray<UGBetsRecordModel> *tickets;
@end

NS_ASSUME_NONNULL_END
