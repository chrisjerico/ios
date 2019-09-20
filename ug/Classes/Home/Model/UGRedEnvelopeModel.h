//
//  UGRedEnvelopeModel.h
//  ug
//
//  Created by ug on 2019/9/17.
//  Copyright © 2019 ug. All rights reserved.
//
//id: 红包活动ID
//intro：活动介绍
//isTest：是否带玩用户
//hasLogin：是否已登录
//username：用户名
//isHideAmount：是否隐藏红包金额
//isHideCount：是否隐藏剩余红包数量
//leftAmount：剩余红包金额
//leftCount：剩余红包数量
//attendedTimes：用户已领取次数
//attendTimeLimit：活动限制领取次数
#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol UGRedEnvelopeModel <NSObject>

@end
@interface UGRedEnvelopeModel : UGModel<UGRedEnvelopeModel>
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *start;
@property (nonatomic, strong) NSString *end;
@property (nonatomic, strong) NSString *show_time;
@property (nonatomic, assign) BOOL isTest;
@property (nonatomic, assign) BOOL hasLogin;

@property (nonatomic, assign) BOOL canGet;//是否可以抢 的字段

@property (nonatomic, strong) NSString *username;//账号
@property (nonatomic, strong) NSString *intro;//备注
@property (nonatomic, strong) NSString *leftCount;//数量
@property (nonatomic, strong) NSString *leftAmount;//钱
@property (nonatomic, strong) NSString *redBagLogo;//图片
@property (nonatomic, strong) NSString *rid;//


@end

NS_ASSUME_NONNULL_END
