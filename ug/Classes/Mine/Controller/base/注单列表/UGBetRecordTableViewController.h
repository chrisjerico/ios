//
//  UGBetRecordTableViewController.h
//  ug
//
//  Created by ug on 2019/5/17.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGBetRecordTableViewController :UGViewController

@property (nonatomic, assign) BOOL showFooterView;

@property (nonatomic, strong) NSString *gameType;   /**<   游戏分类：lottery=彩票，real=真人，card=棋牌，game=电子游戏，sport=体育 */
@property (nonatomic, strong) NSString *status;     /**<   注单状态：1=待开奖，2=已中奖，3=未中奖，4=已撤单 */
@property (nonatomic, strong) NSString *startDate;
@property (nonatomic, assign) BOOL loadData;

@end

NS_ASSUME_NONNULL_END
