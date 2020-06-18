//
//  UGChanglongBetRecordModel.h
//  ug
//
//  Created by ug on 2019/8/30.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UGChanglongBetRecordModel <NSObject>

@end


// 长龙助手投注记录
// c=report&a=getUserRecentBet
@interface UGChanglongBetRecordModel : UGModel<UGChanglongBetRecordModel>

@property (nonatomic, assign) BOOL isWin;
@property (nonatomic, strong) NSString *lotteryNo;
@property (nonatomic, assign) NSInteger status; 
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *playId;
@property (nonatomic, strong) NSString *money;
@property (nonatomic, strong) NSString *group_name;
@property (nonatomic, strong) NSString *multiple;
@property (nonatomic, strong) NSString *playCateId;
@property (nonatomic, strong) NSString *play_alias;
@property (nonatomic, strong) NSString *play_name;
@property (nonatomic, strong) NSString *gameId;
@property (nonatomic, strong) NSString *betInfo;
@property (nonatomic, strong) NSString *bonus;
@property (nonatomic, strong) NSString *odds;
@property (nonatomic, strong) NSString *orderNo;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *addTime;
@property (nonatomic, strong) NSString *rebateMoney;
@property (nonatomic, strong) NSString *openTime;
@property (nonatomic, strong) NSString *usr;
@property (nonatomic, assign) BOOL isTest;

@property (nonatomic, strong) NSString *rebate;
@property (nonatomic, strong) NSString *resultMoney;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, assign) BOOL isAllowCancel;

@property (nonatomic, strong) NSString *issue;
@property (nonatomic, copy) NSString *displayNumber;     //开奖期数  自营优先使用
// 自定义字段
@property (nonatomic, strong) NSString *pic;

@end

NS_ASSUME_NONNULL_END
