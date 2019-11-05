//
//  UGNavigationController.h
//  ug
//
//  Created by ug on 2019/5/3.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGAllNextIssueListModel.h"
#import "GameCategoryDataModel.h"


NS_ASSUME_NONNULL_BEGIN

#define NavController1 ((UGNavigationController *)TabBarController1.selectedViewController)

@interface UGNavigationController : UINavigationController

- (UIView *)topView;
- (UIViewController *)firstVC;
- (UIViewController *)lastVC;


// —————— 跳转游戏页面 ————————
- (void)pushViewControllerWithGameModel:(GameModel *)gm;                /**<   跳转到彩票下注页，或内部功能页，或第三方游戏页，或游戏资料页 */
- (BOOL)pushViewControllerWithNextIssueModel:(UGNextIssueModel *)nim;   /**<   跳转到彩票下注页 */
- (BOOL)pushViewControllerWithLinkCategory:(NSInteger)linkCategory linkPosition:(NSInteger)linkPosition;    /**<   跳转到彩票下注页，或内部功能页 */
@end

NS_ASSUME_NONNULL_END

