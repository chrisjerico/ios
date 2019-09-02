//
//  UGMissionModel.h
//  ug
//
//  Created by ug on 2019/5/22.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGMissionModel : UGModel

@property (nonatomic, strong) NSString *missionId;
@property (nonatomic, strong) NSString *addTime;
@property (nonatomic, strong) NSString *completed;
@property (nonatomic, strong) NSString *integral;
@property (nonatomic, assign) BOOL isDelete;
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, strong) NSString *levelId;
@property (nonatomic, strong) NSString *maxMoney;
@property (nonatomic, strong) NSString *missionDesc;
@property (nonatomic, strong) NSString *missionGame;
@property (nonatomic, strong) NSString *missionName;
@property (nonatomic, strong) NSString *missionPlayed;
@property (nonatomic, strong) NSString *missionReal;
@property (nonatomic, assign) NSInteger missionType;
@property (nonatomic, strong) NSString *money;
@property (nonatomic, strong) NSString *nums;
@property (nonatomic, strong) NSString *odds;
@property (nonatomic, strong) NSString *overTime;
@property (nonatomic, strong) NSString *rechargeId;
@property (nonatomic, strong) NSString *sortId;
@property (nonatomic, strong) NSString *sorts;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger type;



@end

NS_ASSUME_NONNULL_END
