//
//  UINavigationController+Push.h
//  ug
//
//  Created by xionghx on 2020/1/5.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, UGLinkPositionType) {
    UGLinkPosition_资金管理 = 1,
    UGLinkPosition_APP下载 = 2,
    UGLinkPosition_聊天室 = 3,
    UGLinkPosition_在线客服 = 4,
    UGLinkPosition_长龙助手 = 5,
    UGLinkPosition_推广收益 = 6,
    UGLinkPosition_开奖网 = 7,
    UGLinkPosition_利息宝 = 8,
    UGLinkPosition_优惠活动 = 9,
    UGLinkPosition_注单记录 = 10,
    UGLinkPosition_QQ客服 = 11,
    UGLinkPosition_微信客服 = 12,
    UGLinkPosition_任务大厅 = 13,
    UGLinkPosition_站内信 = 14,
    UGLinkPosition_签到 = 15,
    UGLinkPosition_投诉中心 = 16,
    UGLinkPosition_全民竞猜 = 17,
    UGLinkPosition_活动彩金 = 18,
    UGLinkPosition_游戏大厅 = 19,
    UGLinkPosition_会员中心 = 20,
    UGLinkPosition_充值 = 21,
    UGLinkPosition_提现 = 22,
    UGLinkPosition_额度转换 = 23,
    UGLinkPosition_即时注单 = 24,
    UGLinkPosition_今日输赢 = 25,
    UGLinkPosition_开奖记录 = 26,
    UGLinkPosition_当前版本号 = 27,
    UGLinkPosition_资金明细 = 28,
    UGLinkPosition_回到电脑版 = 29,
    UGLinkPosition_返回首页 = 30,
    UGLinkPosition_退出登录 = 31,
    UGLinkPosition_投注记录 = 32,
    UGLinkPosition_彩种规则 = 33,
    UGLinkPosition_红包记录 = 36,
    UGLinkPosition_扫雷记录 = 37,
    UGLinkPosition_修改密码 = 38,
    UGLinkPosition_修改提款密码 = 39,
    UGLinkPosition_红包活动 = 40,
    UGLinkPosition_试玩 = 41,
    UGLinkPosition_真人大厅 = 42,
    UGLinkPosition_棋牌大厅 = 43,
    UGLinkPosition_电子大厅 = 44,
    UGLinkPosition_体育大厅 = 45,
    UGLinkPosition_电竞大厅 = 46,
    UGLinkPosition_彩票大厅 = 47,
    UGLinkPosition_捕鱼大厅= 48,
    UGLinkPosition_开奖走势 = 54,
    UGLinkPosition_路珠 = 55,
    UGLinkPosition_我的关注 = 56,
    UGLinkPosition_我的动态 = 57,
    UGLinkPosition_我的粉丝 = 58,
};



@interface UINavigationController (Push)
+ (instancetype)current;
- (UIView *)topView;
- (UIViewController *)firstVC;
- (UIViewController *)lastVC;
@property (nonatomic, class, readonly) NSMutableArray <GameModel *> *browsingHistoryArray;

// —————— 跳转游戏页面 ————————
- (BOOL)pushViewControllerWithGameModel:(GameModel *)gm;                /**<   跳转到彩票下注页，或内部功能页，或第三方游戏页，或游戏资料页 */
- (BOOL)pushViewControllerWithNextIssueModel:(UGNextIssueModel *)nim isChatRoom:(BOOL) isChatRoom;   /**<   跳转到彩票下注页  isChatRoom是否选择聊天室房间 */
- (BOOL)pushViewControllerWithLinkCategory:(NSInteger)linkCategory linkPosition:(UGLinkPositionType)linkPosition;    /**<   跳转到彩票下注页，或内部功能页 */
- (BOOL)pushViewControllerWithLinkCategory:(NSInteger)linkCategory linkPosition:(UGLinkPositionType)linkPosition gameCode:(nullable NSString *)gameCode gameModel:(GameModel *)model;
- (BOOL)pushVCWithUserCenterItemType:(UserCenterItemType)uciType;       /**<   跳转到（我的页包含的）功能页 */

- (void)getGotoGameUrl:(GameModel *)game ;
@end

NS_ASSUME_NONNULL_END
