//
//  LotteryView.h
//  UGBWApp
//
//  Created by andrew on 2020/11/22.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^LotteryViewZHClickBlcok)(void);//追号
typedef void(^LotteryViewJXClickBlcok)(void);//机选
typedef void(^LotteryViewCZClickBlcok)(void);//重置
typedef void(^LotteryViewXZClickBlcok)(void);//下注

@interface LotteryView : UIView
@property (nonatomic, copy) LotteryViewZHClickBlcok zhllock;
@property (nonatomic, copy) LotteryViewJXClickBlcok jxllock;
@property (nonatomic, copy) LotteryViewCZClickBlcok czllock;
@property (nonatomic, copy) LotteryViewXZClickBlcok xzllock;

@property (nonatomic, strong) NSString *gameId;

- (void)reloadData:(void (^)(BOOL succ))completion;
@end

NS_ASSUME_NONNULL_END
