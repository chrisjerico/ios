//
//  UGSystemConfigModel.h
//  ug
//
//  Created by ug on 2019/7/23.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGSystemConfigModel : UGModel
// 0隐藏，1选填，2必填
@property (nonatomic, assign) NSInteger hide_reco;//代理人
@property (nonatomic, assign) NSInteger reg_name;//真实姓名
@property (nonatomic, assign) NSInteger reg_fundpwd;//取款密码
@property (nonatomic, assign) NSInteger reg_qq;//QQ
@property (nonatomic, assign) NSInteger reg_wx;//微信
@property (nonatomic, assign) NSInteger reg_phone;//手机
@property (nonatomic, assign) NSInteger reg_email; //邮箱
@property (nonatomic, assign) BOOL smsVerify;//手机短信验证
@property (nonatomic, assign) NSInteger reg_vcode;//0无验证码，1图形验证码 3点击显示图形验证码 2滑块验证码
@property (nonatomic, strong) NSString *zxkfUrl;//在线客服
@property (nonatomic, assign) NSInteger pass_limit;//注册密码强度，0、不限制；1、数字字母；2、数字字母符合
@property (nonatomic, assign) NSInteger pass_length_min;//注册密码最小长度
@property (nonatomic, assign) NSInteger pass_length_max;//注册密码最大长度
@property (nonatomic, strong) NSString *minWithdrawMoney;//最低提款金额
@property (nonatomic, strong) NSString *maxWithdrawMoney;//最高提款金额
@property (nonatomic, assign) BOOL allowreg;//是否开启注册功能。
@property (nonatomic, strong) NSString *closeregreason;//关闭注册功能提示内容
@property (nonatomic, strong) NSString *missionName;//哇咔豆
@property (nonatomic, strong) NSString *missionBili;
@property (nonatomic, strong) NSString *isIntToMoney;

@property (nonatomic, assign) BOOL checkinSwitch;//签到开关
@property (nonatomic, assign) BOOL mkCheckinSwitch;//补签开关：
@property (nonatomic, assign) BOOL agent_m_apply;//允许会员中心申请代理

@property (nonatomic, assign) BOOL recharge;//上级充值开关

+ (instancetype)currentConfig;

+ (void)setCurrentConfig:(UGSystemConfigModel *)config;

@end

NS_ASSUME_NONNULL_END
