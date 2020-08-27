//
//  GoldEggLogModel.h
//  UGBWApp
//
//  Created by xionghx on 2020/8/27.
//  Copyright © 2020 ug. All rights reserved.
//

#import "UGModel.h"


NS_ASSUME_NONNULL_BEGIN

@protocol LogParam <NSObject>

@end

@interface LogParam : UGModel<LogParam>
@property (nonatomic, strong) NSString *prizeProbability;
@property (nonatomic, strong) NSNumber *update_time;
@property (nonatomic, strong) NSString *prizeAmount;
@property (nonatomic, strong) NSNumber *integralOld;
@property (nonatomic, strong) NSString *prizeType;
@property (nonatomic, strong) NSString *prizeIcon;
@property (nonatomic, strong) NSNumber *prizeId;
@property (nonatomic, strong) NSNumber *integral;
@property (nonatomic, strong) NSString *prizeMsg;
@property (nonatomic, strong) NSString *prizeName;
@property (nonatomic, strong) NSString *prizeflag;
@property (nonatomic, strong) NSString *prizeIconName;

@end

@protocol GoldEggLogModel <NSObject>

@end

//{
//	"uid" : "1141",
//	"id" : "33",
//	"prize_param" : [
//	  {
//		"prizeProbability" : "7",
//		"update_time" : 1598497613,
//		"prizeAmount" : "10000",
//		"integralOld" : 33700,
//		"prizeType" : "2",
//		"prizeIcon" : "https:\/\/cdn01.bingchonghai.com.cn\/upload\/t061\/customise\/images\/158951391920prizeIconNew.jpg?v=1589513919",
//		"prizeId" : 1,
//		"integral" : 43700,
//		"prizeMsg" : "中奖",
//		"prizeName" : "10000积分",
//		"prizeflag" : 1,
//		"prizeIconName" : "158951391920prizeIconNew"
//	  }
//	],
//	"times" : "1",
//	"aid" : "60",
//	"username" : "bob001",
//	"update_date" : "2020-08-27"
//  },

@interface GoldEggLogModel : UGModel<GoldEggLogModel>
@property (nonatomic, strong) NSString *uid;
//@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSArray<LogParam> *prize_param;
@property (nonatomic, strong) NSString *times;
@property (nonatomic, strong) NSString *aid;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *update_date;

@end


NS_ASSUME_NONNULL_END
