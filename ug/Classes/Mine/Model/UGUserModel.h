//
//  UGUserModel.h
//  ug
//
//  Created by ug on 2019/5/4.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"
#import "MJExtension.h"

NS_ASSUME_NONNULL_BEGIN

#define UserI [UGUserModel currentUser]


//data =     {
//
//    curLevelTitle = "新手",
//    nextLevelTitle = "初行者",
//    curLevelGrade = "VIP1",
//    nextLevelInt = "0.0000",
//    taskRewardTitle = "积分",
//    taskRewardTotal = "0.0000",
//    curLevelInt = "0",
//    nextLevelGrade = "无",
//},

@interface UGUserModel : UGModel
//guest
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, assign) BOOL isTest;
@property (nonatomic, strong) NSString *serverTime;
@property (nonatomic, strong) NSString *lastLoginTime;
@property (nonatomic, strong) NSString *loginTime;
@property (nonatomic, strong) NSString *money;
//user
@property (nonatomic, strong) NSString *sessid;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, assign) BOOL autoLogin;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *balance;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, assign) BOOL enable;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, assign) BOOL hasFundPwd;/**<   是否置取款密码的账号 */
@property (nonatomic, assign) BOOL hasBankCard;
@property (nonatomic, assign) NSInteger unreadFaq;
@property (nonatomic, strong) NSString *unreadMsg;
@property (nonatomic, assign) BOOL googleVerifier;  /**<   是否显示活动彩金 */
@property (nonatomic, assign) BOOL hasActLottery;   /**<   是否显示活动彩金 */
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *qq;
@property (nonatomic, strong) NSString *result;
@property (nonatomic, assign) BOOL showEdu;
@property (nonatomic, assign) BOOL showReal;
@property (nonatomic, assign) BOOL testFlag;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSString* usr;

@property (nonatomic, assign) BOOL yuebaoSwitch;    /**<   是否是开启利息宝 */
@property (nonatomic, assign) BOOL chatRoomSwitch;  /**<   是否是开启聊天室 */
@property (nonatomic, assign) BOOL isAgent;         /**<   是否是代理 */
@property (nonatomic, assign) BOOL checkinSwitch;   /**<   是否签到开关： */

@property (nonatomic, assign) NSInteger ggCheck;    /**<   1 要google验证 */

//积分
@property (nonatomic, strong) NSString *curLevelTitle;
@property (nonatomic, strong) NSString *nextLevelTitle;
@property (nonatomic, strong) NSString *curLevelGrade;//"VIP1",
@property (nonatomic, strong) NSString *nextLevelInt;
@property (nonatomic, strong) NSString *taskRewardTitle;//"咔咔咔",
@property (nonatomic, strong) NSString *taskRewardTotal;//653.0000",
@property (nonatomic, strong) NSString *curLevelInt;
@property (nonatomic, strong) NSString *nextLevelGrade;

@property (nonatomic, strong) NSString *taskReward;

@property (nonatomic, strong) NSString *todayWinAmount;
@property (nonatomic, strong) NSString *unsettleAmount;
+ (instancetype)currentUser;

+ (void)setCurrentUser:(UGUserModel *)user;

@end

NS_ASSUME_NONNULL_END
