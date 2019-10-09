//
//  UGSystemConfigModel.h
//  ug
//
//  Created by ug on 2019/7/23.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol UGmobileMenu <NSObject>

@end
@interface UGmobileMenu :UGModel<UGmobileMenu>
@property (nonatomic, copy) NSString *path;//界面
@property (nonatomic, copy) NSString *icon;//图标
@property (nonatomic, copy) NSString *name;//名字
@property (nonatomic) NSInteger sort;//排列
@end
@protocol UGSystemConfigModel <NSObject>

@end

@interface UGSystemConfigModel : UGModel<UGSystemConfigModel>
// 0隐藏，1选填，2必填
//<<<<<<< HEAD
//@property (nonatomic) NSInteger hide_reco;          /**<   代理人 */
//@property (nonatomic) NSInteger reg_name;           /**<   真实姓名 */
//@property (nonatomic) NSInteger reg_fundpwd;        /**<   取款密码 */
//@property (nonatomic) NSInteger reg_qq;             /**<   QQ */
//@property (nonatomic) NSInteger reg_wx;             /**<   微信 */
//@property (nonatomic) NSInteger reg_phone;          /**<   手机 */
//@property (nonatomic) NSInteger reg_email;          /**<   邮箱 */
//@property (nonatomic) BOOL smsVerify;               /**<   手机短信验证 */
//@property (nonatomic) NSInteger reg_vcode;          /**<   0无验证码，1图形验证码 3点击显示图形验证码 2滑块验证码 */
//@property (nonatomic) NSString *zxkfUrl;            /**<   在线客服 */
//@property (nonatomic) NSInteger pass_limit;         /**<   注册密码强度，0、不限制；1、数字字母；2、数字字母符合 */
//@property (nonatomic) NSInteger pass_length_min;    /**<   注册密码最小长度 */
//@property (nonatomic) NSInteger pass_length_max;    /**<   注册密码最大长度 */
//@property (nonatomic) NSString *minWithdrawMoney;   /**<   最低提款金额 */
//@property (nonatomic) NSString *maxWithdrawMoney;   /**<   最高提款金额 */
//@property (nonatomic) BOOL allowreg;                /**<   是否开启注册功能。 */
//@property (nonatomic) NSString *closeregreason;     /**<   关闭注册功能提示内容 */
//@property (nonatomic) NSString *missionName;        /**<   哇咔豆 */
//@property (nonatomic) NSString *missionBili;
//@property (nonatomic) NSString *isIntToMoney;       /**<   积分开关0=关闭；1=开启； */
//@property (nonatomic) NSString *missionSwitch;      /**<   1=关闭；0=开启； */
//@property (nonatomic) NSString *myreco_img;         /**<   1=关闭；0=开启； */
//
//@property (nonatomic) BOOL checkinSwitch;                   /**<   签到开关 */
//@property (nonatomic) BOOL mkCheckinSwitch;                 /**<   补签开关： */
//@property (nonatomic) NSString *agent_m_apply;              /**<   允许会员中心申请代理 */
//@property (nonatomic) NSInteger googleVerifier;             /**<   是否开启google 验证 1为开启 */
//@property (nonatomic) NSString *mobile_logo;                /**<   首页navBar 图片 */
//
//@property (nonatomic) NSString *agentRegbutton;             /**<   0=关闭；1=开启；  手机端注册页面显示“代理注册” */
//
//@property (nonatomic) NSString *oftenLoginArea;             /**<   1=关闭；0=开启； 常用登录地 */
//
//@property (nonatomic) NSString *mobileTemplateBackground;   /**<   配色方案 */
//
//@property (nonatomic) NSString *mobileTemplateCategory;     /**<   模板号 */
//
//@property (nonatomic) BOOL recharge;                        /**<   上级充值开关 */
@property (nonatomic) BOOL allowMemberCancelBet;            /**<   是否允许会员撤单，1允许 0不允许 */
//
//@property (nonatomic, copy) NSArray <UGmobileMenu *>*mobileMenu;
//=======
@property (nonatomic, assign) NSInteger hide_reco;          /**<   代理人 */
@property (nonatomic, assign) NSInteger reg_name;           /**<   真实姓名 */
@property (nonatomic, assign) NSInteger reg_fundpwd;        /**<   取款密码 */
@property (nonatomic, assign) NSInteger reg_qq;             /**<   QQ */
@property (nonatomic, assign) NSInteger reg_wx;             /**<   微信 */
@property (nonatomic, assign) NSInteger reg_phone;          /**<   手机 */
@property (nonatomic, assign) NSInteger reg_email;          /**<   邮箱 */
@property (nonatomic, assign) BOOL smsVerify;               /**<   手机短信验证 */
@property (nonatomic, assign) NSInteger reg_vcode;          /**<   0无验证码，1图形验证码 3点击显示图形验证码 2滑块验证码 */
@property (nonatomic, strong) NSString *zxkfUrl;            /**<   在线客服 */
@property (nonatomic, assign) NSInteger pass_limit;         /**<   注册密码强度，0、不限制；1、数字字母；2、数字字母符合 */
@property (nonatomic, assign) NSInteger pass_length_min;    /**<   注册密码最小长度 */
@property (nonatomic, assign) NSInteger pass_length_max;    /**<   注册密码最大长度 */
@property (nonatomic, strong) NSString *minWithdrawMoney;   /**<   最低提款金额 */
@property (nonatomic, strong) NSString *maxWithdrawMoney;   /**<   最高提款金额 */
@property (nonatomic, assign) BOOL allowreg;                /**<   是否开启注册功能。 */
@property (nonatomic, strong) NSString *closeregreason;     /**<   关闭注册功能提示内容 */
@property (nonatomic, strong) NSString *missionName;        /**<   哇咔豆 */
@property (nonatomic, strong) NSString *missionBili;
@property (nonatomic, assign) NSString * isIntToMoney;      /**<   积分开关0=关闭；1=开启； */
@property (nonatomic, assign) NSString * missionSwitch;     /**<   1=关闭；0=开启； */
@property (nonatomic, assign) NSString * myreco_img;        /**<   1=关闭；0=开启； */

@property (nonatomic, assign) BOOL checkinSwitch;                   /**<   签到开关 */
@property (nonatomic, assign) BOOL mkCheckinSwitch;                 /**<   补签开关： */
@property (nonatomic, assign) NSString * agent_m_apply;             /**<   允许会员中心申请代理 */
@property (nonatomic, assign) NSInteger  googleVerifier;            /**<   是否开启google 验证 1为开启 */
@property (nonatomic, strong) NSString * mobile_logo;               /**<   首页navBar 图片 */

@property (nonatomic, assign) NSString * agentRegbutton;            /**<   0=关闭；1=开启；  手机端注册页面显示“代理注册” */

@property (nonatomic, assign) NSString * oftenLoginArea;            /**<   1=关闭；0=开启； 常用登录地 */

@property (nonatomic, strong) NSString * mobileTemplateBackground;  /**<   配色方案 */

@property (nonatomic, strong) NSString * mobileTemplateCategory;    /**<   模板号 */

@property (nonatomic, strong) NSString * webName;    /**<   首页底部文字 */

@property (nonatomic, assign) BOOL recharge;                        /**<   上级充值开关 */

@property (nonatomic , copy) NSArray<UGmobileMenu *>              * mobileMenu;

@property (nonatomic, assign) int rankingListSwitch;
//>>>>>>> dev_andrew

+ (instancetype)currentConfig;

+ (void)setCurrentConfig:(UGSystemConfigModel *)config;

@end

NS_ASSUME_NONNULL_END
