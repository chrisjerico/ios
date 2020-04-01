//
//  UGLHlotteryNumberModel.h
//  ug
//
//  Created by ug on 2019/11/28.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UGLHlotteryNumberModel <NSObject>

@end

// 
@interface UGLHlotteryNumberModel : UGModel
@property (copy, nonatomic) NSString *gameId;/**<   " */
@property (copy, nonatomic) NSString *numSx;/**<   生肖，逗号分割" */
@property (copy, nonatomic) NSString *serverTime;/**<   服务器时间" */
@property (copy, nonatomic) NSString *numbers;/**<   开奖号码，逗号分割" */
@property (assign, nonatomic) int isFinish;/**< "  1  开奖结束，0 还在继续*/
@property (copy, nonatomic) NSString *lotteryTime;/**<  开奖时间" */
@property (copy, nonatomic) NSString *endtime;/**<   " */
@property (copy, nonatomic) NSString *numColor;/**<  波色，逗号分割" */
@property (copy, nonatomic) NSString *issue;/**<   期数" */
//@property (nonatomic) BOOL autoBL;          /**<   是否是自动开奖， false手动开奖, true 自动开奖*/
@property (assign, nonatomic) int autoBL;/**< "  1  自动开奖*，0 动开奖*/

@property (copy, nonatomic) NSArray *numSxArrary;/**<   生肖， */
@property (copy, nonatomic) NSArray *numColorArrary;/**<  颜色*/
@property (copy, nonatomic) NSArray *numbersArrary;/**<   开奖号码" */
@property (nonatomic) BOOL isOpen;          /**<  六合界面swich开关*/
@property (copy, nonatomic) NSString *lotteryStr;/**<   自定义开奖信息 */
@property (nonatomic) int count;          /**< 测试用*/

@property (copy, nonatomic) NSString *lhcdocLotteryNo;/**<   预备开奖期数，不为空则使用，为空则按原来的处理方式
" */
@end

NS_ASSUME_NONNULL_END
