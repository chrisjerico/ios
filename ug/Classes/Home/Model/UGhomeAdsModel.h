//
//  UGhomeAdsModel.h
//  ug
//
//  Created by ug on 2019/12/19.
//  Copyright © 2019 ug. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol UGhomeAdsModel <NSObject>

@end
@interface UGhomeAdsModel : UGModel
@property (nonatomic , strong) NSString *linkCategory;        /**<   跳转分类。1=彩票游戏；2=真人视讯；3=捕鱼游戏；4=电子游戏；5=棋牌游戏；6=体育赛事；7=导航链接 */
@property (nonatomic , strong) NSString *linkPosition;         /**<   跳转位置。linkCategory=1-6代表游戏ID，linkCategory=7, 导航链接明细：1=存取款；2=APP下载；3=聊天室；4=在线客服；5=长龙助手；6=推荐收益；7=开奖网；8=利息宝；9=优惠活动；10=游戏记录；11=QQ客服;12=微信客服;13=任务大厅;14=站内信;15=签到;16=投诉中心;17=全民竞猜;18=活动彩金（详细请看后台-系统设置-内容管理-手机端浮窗） */
@property (nonatomic , strong) NSString *image;  /**<    图片 */
@property (nonatomic , strong) NSString *lotteryGameType;           /**<   如果是彩票，彩票类型 */
@property (nonatomic ) int realIsPopup;  /**<    如果是真人，是否弹出 */
@property (nonatomic ) int realSupportTrial;  /**<    如果是真人，是否支持试玩*/
@end

NS_ASSUME_NONNULL_END
