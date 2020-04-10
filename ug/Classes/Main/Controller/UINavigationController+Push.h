//
//  UINavigationController+Push.h
//  ug
//
//  Created by xionghx on 2020/1/5.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (Push)
+ (instancetype)current;
- (UIView *)topView;
- (UIViewController *)firstVC;
- (UIViewController *)lastVC;
@property (nonatomic, class, readonly) NSMutableArray <GameModel *> *browsingHistoryArray;

// —————— 跳转游戏页面 ————————
- (BOOL)pushViewControllerWithGameModel:(GameModel *)gm;                /**<   跳转到彩票下注页，或内部功能页，或第三方游戏页，或游戏资料页 */
- (BOOL)pushViewControllerWithNextIssueModel:(UGNextIssueModel *)nim;   /**<   跳转到彩票下注页 */
- (BOOL)pushViewControllerWithLinkCategory:(NSInteger)linkCategory linkPosition:(NSInteger)linkPosition;    /**<   跳转到彩票下注页，或内部功能页 */
- (BOOL)pushVCWithUserCenterItemType:(UserCenterItemType)uciType;       /**<   跳转到（我的页包含的）功能页 */
@end

NS_ASSUME_NONNULL_END