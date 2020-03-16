//
//  UGNextIssueModel.h
//  ug
//
//  Created by ug on 2019/5/15.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol UGNextIssueModel <NSObject>

@end

// 彩票游戏大厅
// {{LOCAL_HOST}}?c=game&a=lotteryGames
@interface UGNextIssueModel : UGModel<UGNextIssueModel>

@property (nonatomic, strong) NSString *gameId;         /**<   游戏ID */
@property (nonatomic, strong) NSString *gameType;       /**<   游戏分类 */
@property (nonatomic, assign) NSInteger fromType;       /**<   游戏分类ID */
@property (nonatomic, strong) NSString *title;          /**<   游戏名称 */
@property (nonatomic, strong) NSString *name;           /**<   游戏标识 */
@property (nonatomic, strong) NSString *serverTime;     /**<   服务器时间 */
@property (nonatomic, assign) BOOL isSeal;              /**<   是否封盘:1=是，0=否 */
@property (nonatomic, assign) BOOL enable;              /**<   是否可用：1=是，0=否 */
@property (nonatomic, assign) bool isInstant;           /**<   是否是即开彩：1=是，0=否 */
@property (nonatomic, strong) NSString *customise;      /**<   是否自营彩：1=是，0=否 */
@property (nonatomic, strong) NSString *pic;            /**<   游戏图片 */
@property (nonatomic, strong) NSString *openCycle;      /**<   开奖周期 */

@property (nonatomic, strong) NSString *curIssue;       /**<   当前期期号 */
@property (nonatomic, strong) NSString *curCloseTime;   /**<   当期期封盘时间 */
@property (nonatomic, strong) NSString *curOpenTime;    /**<   当前期开奖时间 */
@property (nonatomic, strong) NSString *nums;
@property (nonatomic, strong) NSString *preIssue;       /**<   上期期号 */
@property (nonatomic, strong) NSString *preOpenTime;    /**<   上次开奖时间 */
@property (nonatomic, strong) NSString *preNum;         /**<   上期开奖号码 */
@property (nonatomic, strong) NSString *preNumColor;
@property (nonatomic, strong) NSString *preNumSx;       /**<   上期开奖结果 */
@property (nonatomic, strong) NSArray *winningPlayers;  /**<   闲家输赢情况：当彩种是是pk10牛牛时有效 */
@property (nonatomic, strong) NSString *preNumStringWin;
@property (nonatomic, assign) BOOL preIsOpen;           /**<   上期是否开奖:1=是，0=否 */
@property (nonatomic, strong) NSString *dataNum;
@property (nonatomic, strong) NSString *totalNum;
@property (nonatomic, strong) NSString *lowFreq;         /**<   1 是低频 0 高频  */

//弹窗广告
@property (nonatomic, strong) NSString *adPic;          /**<   彩票广告图片 */
@property (nonatomic, strong) NSString *adLink;         /**<   彩票广告链接：-2=任务大厅，-1=利息宝，其他=彩票 */
@property (nonatomic, assign) BOOL adEnable;            /**<   彩票广告是否开启：1=开启，0=关闭 */

+ (instancetype)modelWithGameId:(NSString *)gameId;
@end

@protocol UGAllNextIssueListModel <NSObject>

@end

@interface UGAllNextIssueListModel : UGModel<UGAllNextIssueListModel>

@property (nonatomic, strong) NSString *gameType;       /**<   游戏分类标识 */
@property (nonatomic, strong) NSString *gameTypeName;   /**<   游戏分类名称 */
@property (nonatomic, strong) NSArray<UGNextIssueModel> *list;


@property (nonatomic, class) NSArray<UGAllNextIssueListModel *> *lotteryGamesArray; /**<   彩票大厅数据（升级为类方法全局使用） */
@end

NS_ASSUME_NONNULL_END
