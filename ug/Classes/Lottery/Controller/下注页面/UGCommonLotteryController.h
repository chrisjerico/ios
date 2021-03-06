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
#import "UGBargainingView.h"// 筹码View
#import "TKLFPView.h"// 天空蓝封盘View
#import "LotteryView.h"// 下注分View
#import "LotterySliderView.h"// 拉条分View
NS_ASSUME_NONNULL_BEGIN

// 秒秒彩隐藏头部
@protocol HiddeHeader <NSObject>
-(void)hideHeader;
@end
// 机选计数规则
@protocol BetRadomProtocal <NSObject>
- (NSUInteger)minSectionsCountForBet;
- (NSUInteger)minItemsCountForBetIn:(NSUInteger)section ;

@end

// 彩种下注页面的基类
@interface UGCommonLotteryController : UGViewController<HiddeHeader, BetRadomProtocal>

@property (nonatomic, assign) BOOL shoulHideHeader;
@property (nonatomic, strong) UGNextIssueModel *nextIssueModel;
@property (nonatomic, strong) NSString *gameId;

@property (nonatomic, strong) CountDown *nextIssueCountDown;    /**<   下期倒数器 */
@property (nonatomic, strong) NSTimer *timer;    /**<   开奖文本倒数器 */
@property (nonatomic,strong) NSString * path;   /**<   开奖声音文件路径 */

//追号=======================================================
@property (nonatomic, strong) UGNextIssueModel*zuiHaoIssueModel;/**<莫彩种的最近一期下注*/
//切换=======================================================
@property (strong, nonatomic)  NSString *selectTitle;/**<选中的标题*/
//筹码=======================================================
@property (nonatomic, strong) UGBargainingView  *bargainingView;//筹码
@property (nonatomic, strong) NSArray <NSString *> *chipArray;               /**<   筹码数组 */
//封盘=======================================================
@property (nonatomic, strong) TKLFPView * mTKLFPView;/**<天空蓝封盘View*/
//下注分控件=======================================================
@property (nonatomic, strong) LotteryView *lotteryView;             /**<   下注View*/
@property (nonatomic, strong) LotterySliderView *lotterySliderView;  /**<   拉条View*/


- (void)getGameDatas;
- (void)getNextIssueData;
-(void)playerLotterySound;

- (void)updateCloseLabel;
- (void)getLotteryHistory;

- (void)updateSelectLabelWithCount:(NSInteger)count;

//连码玩法数据处理
- (void)handleData;
- (void)updateCloseLabelText;
// 重置
- (IBAction)resetClick:(id)sender ;
- (IBAction)betClick:(id)sender ;//下注

//调用下注界面   objArray:模型数组  dicArray 字典数组
-(void)goUGBetDetailViewObjArray:(NSArray *)objArray   dicArray:(NSArray *)dicArray issueModel:(UGNextIssueModel *)issueModel gameType:(NSString  *)gameId selCode:(NSString *)selCode;
//调用越南彩下注界面
-(void)goYNBetDetailViewObjArray:(NSArray *)objArray   dicArray:(NSArray *)dicArray issueModel:(UGNextIssueModel *)issueModel gameType:(NSString  *)gameId selCode:(NSString *)selCode  isHide:(BOOL )isHide;
@end

NS_ASSUME_NONNULL_END
