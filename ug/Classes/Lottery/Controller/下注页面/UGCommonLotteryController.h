//
//  UGCommonLotteryController.h
//  ug
//
//  Created by xionghx on 2019/10/1.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGAllNextIssueListModel.h"
#import "CountDown.h"
#import "MGSlider.h"
NS_ASSUME_NONNULL_BEGIN

@protocol hiddeHeader <NSObject>

-(void)hideHeader;

@end

// 彩种下注页面的基类
@interface UGCommonLotteryController : UGViewController<hiddeHeader>

@property (nonatomic, assign) BOOL shoulHideHeader;
@property (nonatomic, strong) UGNextIssueModel *nextIssueModel;
@property (nonatomic, strong) NSString *gameId;

@property (nonatomic, strong) CountDown *nextIssueCountDown;    /**<   下期倒数器 */
@property (nonatomic, strong) NSTimer *timer;    /**<   开奖文本倒数器 */
@property (nonatomic, copy) void(^gotoTabBlock)(void);
@property (nonatomic,strong) NSString * path;   /**<   开奖声音文件路径 */


//拖动条=======================================================
@property (strong, nonatomic)  MGSlider *slider;/**<拖动条*/
@property (strong, nonatomic)  UILabel *sliderLB;/**<拖动条 刻度显示*/
@property (strong, nonatomic)  UIButton *reductionBtn;/**<拖动条 -按钮*/
@property (strong, nonatomic)  UIButton *addBtn;/**<拖动条 +按钮*/
@property ( nonatomic) float proportion;/**<拖动条 显示的最大值    来自网络数据*/
@property ( nonatomic) float lattice;/**<拖动条 一格的值  */



- (void)getGameDatas;
- (void)getNextIssueData;
-(void)playerLotterySound;


- (void)getLotteryHistory;

@end

NS_ASSUME_NONNULL_END
