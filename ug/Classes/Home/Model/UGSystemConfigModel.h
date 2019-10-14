//
//  UGSystemConfigModel.h
//  ug
//
//  Created by ug on 2019/7/23.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

#define SysConf [UGSystemConfigModel currentConfig]

@protocol UGmobileMenu <NSObject>

@end
@interface UGmobileMenu :UGModel<UGmobileMenu>
@property (nonatomic, copy) NSString *path; /**<   界面 */
@property (nonatomic, copy) NSString *icon; /**<   图标 */
@property (nonatomic, copy) NSString *name; /**<   标题 */
@property (nonatomic) NSInteger sort;       /**<   排序 */

// 自定义参数
@property (nonatomic) Class cls;
@property (nonatomic, copy) NSString *selectedIcon;
+ (instancetype)menu:(NSString *)path :(NSString *)name :(NSString *)icon :(NSString *)selectedIcon :(Class)cls;
@end
@protocol UGSystemConfigModel <NSObject>

@end



@interface UGSystemConfigModel : UGModel<UGSystemConfigModel>

@property (nonatomic, copy) NSString *zxkfUrl;                    /**<   在线客服 */
@property (nonatomic, copy) NSString *minWithdrawMoney;           /**<   最低提款金额 */
@property (nonatomic, copy) NSString *maxWithdrawMoney;           /**<   最高提款金额 */
@property (nonatomic, copy) NSString *closeregreason;             /**<   关闭注册功能提示内容 */
@property (nonatomic, copy) NSString *missionName;                /**<   哇咔豆 */
@property (nonatomic, copy) NSString *missionBili;
@property (nonatomic, copy) NSString *isIntToMoney;               /**<   积分开关0=关闭；1=开启； */
@property (nonatomic, copy) NSString *missionSwitch;              /**<   1=关闭；0=开启；任务中心 */
@property (nonatomic, copy) NSString *myreco_img;                 /**<   1=关闭；0=开启； */
@property (nonatomic, copy) NSString *checkinSwitch;              /**<   0=关闭；1=开启签到开关 */
@property (nonatomic, copy) NSString *mkCheckinSwitch;            /**< 0=开启；1=关闭 补签开关： */
@property (nonatomic, copy) NSString *agent_m_apply;              /**<   允许会员中心申请代理 */
@property (nonatomic, copy) NSString *mobile_logo;                /**<   首页navBar 图片 */
@property (nonatomic, copy) NSString *agentRegbutton;             /**<   0=关闭；1=开启；  手机端注册页面显示“代理注册” */
@property (nonatomic, copy) NSString *oftenLoginArea;             /**<   1=关闭；0=开启； 常用登录地 */
@property (nonatomic, copy) NSString *mobileTemplateBackground;   /**<   配色方案 */
@property (nonatomic, copy) NSString *mobileTemplateCategory;     /**<   模板号 */
@property (nonatomic, copy) NSString *webName;                    /**<   首页底部文字 */

@property (nonatomic, copy) NSArray<UGmobileMenu *> *mobileMenu;

@property (nonatomic) NSInteger hide_reco;          /**<   代理人 */
@property (nonatomic) NSInteger reg_name;           /**<   真实姓名 */
@property (nonatomic) NSInteger reg_fundpwd;        /**<   取款密码 */
@property (nonatomic) NSInteger reg_qq;             /**<   QQ */
@property (nonatomic) NSInteger reg_wx;             /**<   微信 */
@property (nonatomic) NSInteger reg_phone;          /**<   手机 */
@property (nonatomic) NSInteger reg_email;          /**<   邮箱 */
@property (nonatomic) NSInteger reg_vcode;          /**<   0无验证码，1图形验证码 3点击显示图形验证码 2滑块验证码 */
@property (nonatomic) NSInteger pass_limit;         /**<   注册密码强度，0、不限制；1、数字字母；2、数字字母符合 */
@property (nonatomic) NSInteger pass_length_min;    /**<   注册密码最小长度 */
@property (nonatomic) NSInteger pass_length_max;    /**<   注册密码最大长度 */
@property (nonatomic) NSInteger googleVerifier;     /**<   是否开启google 验证 1为开启 */
@property (nonatomic) int rankingListSwitch;
@property (nonatomic) BOOL recharge;                /**<   上级充值开关 */
@property (nonatomic) BOOL smsVerify;               /**<   手机短信验证 */
@property (nonatomic) BOOL allowreg;                /**<   是否开启注册功能。 */
@property (nonatomic) BOOL allowMemberCancelBet;    /**<   是否允许会员撤单，1允许 0不允许 */
@property (nonatomic) BOOL m_promote_pos;           /**<   优惠活动显示在首页还是内页，1首页，0内页 */

+ (instancetype)currentConfig;

+ (void)setCurrentConfig:(UGSystemConfigModel *)config;

@end

NS_ASSUME_NONNULL_END
