//
//  NavigationControllerProtocol.h
//  ug
//
//  Created by xionghx on 2020/1/4.
//  Copyright © 2020 ug. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@protocol NavigationControllerProtocol <NSObject>
// —————— 跳转游戏页面 ————————
- (BOOL)pushViewControllerWithGameModel:(GameModel *)gm;                /**<   跳转到彩票下注页，或内部功能页，或第三方游戏页，或游戏资料页 */
- (BOOL)pushViewControllerWithNextIssueModel:(UGNextIssueModel *)nim;   /**<   跳转到彩票下注页 */
- (BOOL)pushViewControllerWithLinkCategory:(NSInteger)linkCategory linkPosition:(NSInteger)linkPosition;    /**<   跳转到彩票下注页，或内部功能页 */
- (BOOL)pushVCWithUserCenterItemType:(UserCenterItemType)uciType;

@end

void pushViewControllerWithGameModel(id<NavigationControllerProtocol> instanse, GameModel * pm ) {
//	[instanse pushViewControllerWithGameModel: pm];
};
void pushViewControllerWithNextIssueModel(id<NavigationControllerProtocol> instanse, UGNextIssueModel * nim ) {
//	[instanse pushViewControllerWithGameModel: pm];
};
void pushViewControllerWithLinkCategory(id<NavigationControllerProtocol> instanse, NSInteger linkCategory, NSInteger linkPosition) {
//	[instanse pushViewControllerWithGameModel: pm];
};
void pushVCWithUserCenterItemType(id<NavigationControllerProtocol> instanse, UserCenterItemType uciType ) {
//	[instanse pushViewControllerWithGameModel: pm];
};


NS_ASSUME_NONNULL_END
