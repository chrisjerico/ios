//
//  UGBetsRecordListModel.h
//  ug
//
//  Created by ug on 2019/7/17.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UGBetsRecordModel <NSObject>

@end
@interface UGBetsRecordModel : UGModel
@property (nonatomic, strong) NSString *betId;
@property (nonatomic, assign) NSInteger gameType;
@property (nonatomic, strong) NSString *gameName;
@property (nonatomic, strong) NSString *playGroupName;
@property (nonatomic, strong) NSString *playName;
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *betAmount;
@property (nonatomic, strong) NSString *betTime;
@property (nonatomic, strong) NSString *validBetAmount;
@property (nonatomic, strong) NSString *winAmount;
@property (nonatomic, strong) NSString *settleAmount;
@property (nonatomic, strong) NSString *lotteryNo;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString *playCateId;
@property (nonatomic, strong) NSString *statusName;
@property (nonatomic, strong) NSString *odds;
@property (nonatomic, strong) NSString *issue;

@end

@interface UGBetsRecordListModel : UGModel
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, strong) NSString *totalBetAmount;
@property (nonatomic, strong) NSString *totalWinAmount;
@property (nonatomic, strong) NSArray<UGBetsRecordModel> *list;

@end

NS_ASSUME_NONNULL_END
