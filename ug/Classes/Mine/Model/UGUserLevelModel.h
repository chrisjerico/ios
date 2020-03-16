//
//  UGUserLevelModel.h
//  ug
//
//  Created by ug on 2019/6/4.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"
#import "MJExtension.h"
NS_ASSUME_NONNULL_BEGIN

@interface UGUserLevelModel : UGModel

@property (nonatomic, strong) NSString *balance;
@property (nonatomic, strong) NSString *face;
@property (nonatomic, assign) BOOL footerEdu;
@property (nonatomic, assign) BOOL googleVerifier;
@property (nonatomic, strong) NSString *hasInt;
@property (nonatomic, strong) NSString *integral;
@property (nonatomic, strong) NSString *levelName;
@property (nonatomic, strong) NSString *missionLevel;
@property (nonatomic, strong) NSString *missionTitle;
@property (nonatomic, strong) NSString *my_uid;
@property (nonatomic, strong) NSString *nextLevel;
@property (nonatomic, strong) NSString *nextLevelNum;
@property (nonatomic, strong) NSString *pushMessage;
@property (nonatomic, strong) NSString *totalTotalMoney;
@property (nonatomic, strong) NSString *unbalancedMoney;
@property (nonatomic, strong) NSString *unreadFaq;
@property (nonatomic, assign) NSInteger unreadMsg;
@property (nonatomic, strong) NSString *userBetNew;
@property (nonatomic, strong) NSString *userNoticeMsg;
@property (nonatomic, strong) NSString *yuebaoBalance;



+ (instancetype)currentLevel;

+ (void)setCurrentLevel:(UGUserLevelModel *)level;
@end

NS_ASSUME_NONNULL_END
