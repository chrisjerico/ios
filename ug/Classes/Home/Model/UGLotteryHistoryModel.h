//
//  UGLotteryHistoryModel.h
//  ug
//
//  Created by ug on 2019/7/22.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UGLotteryHistoryModel <NSObject>

@end

// 彩票开奖历史
// {{LOCAL_HOST}}?c=game&a=lotteryHistory&id=3&rows=10
@interface UGLotteryHistoryModel : UGModel<UGLotteryHistoryModel>
@property (nonatomic, strong) NSString *issue;          /**<   期号 */
@property (nonatomic, strong) NSString *openTime;       /**<   开奖时间 */
@property (nonatomic, strong) NSString *num;            /**<   开奖号码 */
@property (nonatomic, strong) NSString *result;         /**<   开奖结果 */
@property (nonatomic, strong) NSString *gameType;       /**<   彩票分类 */
@property (nonatomic, strong) NSArray *winningPlayers;  /**<   闲家赢的数组（pK10牛牛） */

@end


@interface UGLotteryHistoryListModel : UGModel
@property (nonatomic, strong) NSArray <UGLotteryHistoryModel>*list;
@end
NS_ASSUME_NONNULL_END
