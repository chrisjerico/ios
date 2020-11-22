//
//  UGLotteryRightMenuView.h
//  UGBWApp
//
//  Created by fish on 2020/9/25.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGAllNextIssueListModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^LotteryRightMenuBlock)(void);
@interface UGLotteryRightMenuView : UIView
@property (nonatomic, copy) void(^didSelectedItemBlock)(UGNextIssueModel * model);
@property (nonatomic, copy) NSString * selectTitle;     /**<   选中的标题 */
@property (nonatomic, strong) NSString *gameType;       /**<   游戏分类标识 */
- (void)show ;
@end

NS_ASSUME_NONNULL_END
