//
//  UGLHPrizeView.h
//  ug
//
//  Created by ug on 2020/1/9.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountDown.h"
NS_ASSUME_NONNULL_BEGIN

@interface UGLHPrizeView : UIView
-(instancetype)initView;
@property (strong, nonatomic)  CountDown *countDownForLabel;                            /**<   倒计时工具*/
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSString *gid; /**<   游戏id*/
////六合开奖  当前开奖信息
- (void)getLotteryNumberList;
@end

NS_ASSUME_NONNULL_END
