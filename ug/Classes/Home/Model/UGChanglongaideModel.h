//
//  UGChanglongaideModel.h
//  ug
//
//  Created by ug on 2019/5/20.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"
#import "UGBetItemModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UGChanglongaideModel : UGModel

@property (nonatomic, strong) NSString *count;
@property (nonatomic, strong) NSString *endtime;
@property (nonatomic, strong) NSString *fengpanCountdown;
@property (nonatomic, strong) NSString *gameId;
@property (nonatomic, strong) NSString *issue;
@property (nonatomic, assign) BOOL isSeal;
@property (nonatomic, strong) NSString *logo;
@property (nonatomic, strong) NSString *lotteryCountdown;
@property (nonatomic, strong) NSString *closeCountdown;
@property (nonatomic, strong) NSString *lotteryTime;
@property (nonatomic, strong) NSString *playCateId;
@property (nonatomic, strong) NSString *playCateName;
@property (nonatomic, strong) NSString *playName;
@property (nonatomic, assign) BOOL preIsOpen;
@property (nonatomic, strong) NSString *serverTime;
@property (nonatomic, strong) NSString *closeTime;
@property (nonatomic, strong) NSString *openTime;
@property (nonatomic, strong) NSString *sort;
@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *displayNumber;//开奖期数  自营优先使用

@property (nonatomic, strong) NSArray<UGBetItemModel> *betList;
















@end

NS_ASSUME_NONNULL_END
