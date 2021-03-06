//
//  UGSystemConfigModel.h
//  ug
//
//  Created by ug on 2019/7/23.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"
#import "UGChatRoomModel.h"
#import "InviteCodeConfigModel.h"
NS_ASSUME_NONNULL_BEGIN

// （我的页包含的）功能页面
typedef NS_ENUM(NSInteger, UserCenterItemType) {
    UCI_存款       = 1,
    UCI_取款       = 2,
    UCI_银行卡管理   = 3,
    UCI_利息宝      = 4,
    UCI_推荐收益    = 5,
    UCI_彩票注单记录 = 6,
    UCI_其他注单记录 = 7,
    UCI_额度转换    = 8,
    UCI_站内信      = 9,
    UCI_安全中心    = 10,
    UCI_任务中心    = 11,
    UCI_个人信息    = 12,
    UCI_建议反馈    = 13,
    UCI_在线客服    = 14,
    UCI_活动彩金    = 15,
    UCI_长龙助手    = 16,
    UCI_全民竞猜    = 17,
    UCI_开奖走势    = 18,
    UCI_QQ客服     = 19,
    UCI_开奖网     = 20,
    UCI_未结注单     = 21,
    UCI_电子注单     = 22,
    UCI_真人注单     = 23,
    UCI_棋牌注单     = 24,
    UCI_捕鱼注单     = 25,
    UCI_电竞注单     = 26,
    UCI_体育注单     = 27,
    UCI_UG注单      = 28,
    UCI_已结注单     = 29,
    UCI_充值纪录     = 30,
    UCI_提现纪录     = 31,
    UCI_资金明细     = 32,
    UCI_活动大厅     = 33,
    UCI_我的关注     = 35,
    UCI_我的动态     = 36,
    UCI_我的粉丝     = 37,
    UCI_聊天室     = 9001,//本地的
};

// （TabbarController包含的）功能页面
typedef NS_ENUM(NSInteger, MobileMenuType) {
    MM_首页 = 1,
    MM_长龙助手,
    MM_购彩大厅_默认,
    MM_购彩大厅_亮黑,
    MM_开奖记录,
    MM_真人视讯,
    MM_棋牌电子,
    MM_彩票大厅,
    
    MM_我的_六合,
    MM_我的_默认,
    MM_我的_亮黑,
    MM_我的_金沙,
    MM_我的_火山橙,


    MM_任务中心,
    MM_签到,
    MM_站内信,
    MM_优惠活动_默认,
    MM_优惠活动_亮黑,
    MM_聊天室,
    MM_推广收益,
    MM_申请代理,
    
    MM_安全中心,
    MM_资金管理,
    MM_额度转换,
    MM_银行卡,
    MM_利息宝,
    MM_在线客服,
    MM_未结算,
    MM_优惠申请,
    
    MM_捕鱼,
    MM_电竞,
    MM_电子,
    MM_棋牌,
};



#define SysConf [UGSystemConfigModel currentConfig]


@interface platformModel : UGModel
@property (nonatomic) BOOL twitter;   /**<   twitter登录是否启用*/
@property (nonatomic) BOOL facebook;  /**<   facebook登录是否启用*/
@property (nonatomic) BOOL google;    /**<   google登录是否启用*/
@end

//第3方登录Model
@interface OauthModel : UGModel
@property (nonatomic) BOOL mSwith; /**<   第三方登录是否启用*/
@property (nonatomic, copy) platformModel *platform;
@end

// 我的页功能按钮Model
@interface UGUserCenterItem :UGModel
@property (nonatomic, assign) UserCenterItemType code; /**<   id */
@property (nonatomic, copy) NSString *logo; /**<   图标 */
@property (nonatomic, copy) NSString *name; /**<   标题 */
// 自定义参数
@property (nonatomic, copy) NSString *lhImgName;    /**<   六合模版使用的本地图标 */
@property (nonatomic, readonly) NSString *bmImgName;    /**<   GPK版使用的本地图标 */
@property (nonatomic, readonly) NSString *defaultImgName;   /**<   正常情况使用的本地图标 */
+ (NSArray <UGUserCenterItem *>*)allItems;
@end


// 六合帖子价格范围Model
@interface LHPriceModel : UGModel
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *alias;
@property (nonatomic) double priceMax;
@property (nonatomic) double priceMin;
@end

// 登录通知Model
@interface loginNoticeModel : UGModel
@property (nonatomic, copy) NSString * loginNotice_switch;/**<   //登录通知开关。0 是关 1 是开 */
@property (nonatomic, copy) NSString * loginNotice_text; /**<   //登录通知文字*/
@end


@protocol UGMobileMenu <NSObject>

@end
@interface UGMobileMenu :UGModel<UGMobileMenu>
@property (nonatomic, copy) NSString *path;         /**<   界面 */
@property (nonatomic, copy) NSString *icon;         /**<   图标 */
@property (nonatomic, copy) NSString *icon_logo;         /**<   tab图标 */
@property (nonatomic, copy) NSString *name;         /**<   标题 */
@property (nonatomic) NSInteger sort;               /**<   排序 */
@property (nonatomic) BOOL status;                  /**<   1=显示建设中页面；0=正常显示 */
@property (nonatomic) NSInteger isHot;              /**<   1 代表是热门  */
@property (nonatomic, copy) NSString *icon_hot;    /**<   热门图片路径 */
@property (nonatomic, copy) NSString *roles;        /**<   用户观看层级 */
// 自定义参数
@property (nonatomic, readonly) MobileMenuType type;        /**<   页面类型 */
@property (nonatomic, copy) NSString *defaultImgName;   /**<   本地图标 */
@property (nonatomic, readonly) NSString *clsName;
+ (NSArray <UGMobileMenu *>*)allMenus;
- (void)createViewController:(void (^)(__kindof UIViewController *vc))completion;

@end
@protocol UGSystemConfigModel <NSObject>

@end



@interface UGSystemConfigModel : UGModel<UGSystemConfigModel>

//===============================================
@property (nonatomic, copy) NSString *zxkfUrl2;                    /**<   在线客服2 */
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
@property (nonatomic, copy) NSString *mobileTemplateBackground;   /**<   配色方案  */
@property (nonatomic, copy) NSString *mobileTemplateCategory;     /**<   经典 配色方案     */
@property (nonatomic, copy) NSString *mobileTemplateLhcStyle;     /**<   六合配色方案 */
@property (nonatomic, copy) NSString *mobileTemplateGpkStyle;     /**<   Gpk配色方案 */
@property (nonatomic, copy) NSString *mobileTemplateStyle;     /**<   新年红 简约 配色方案      */
@property (nonatomic, copy) NSString *mobileTemplateHBStyle;     /**<   红包模板 配色方案      */
@property (nonatomic, copy) NSString *webName;                    /**<   首页底部文字   网址名称*/
@property (nonatomic, copy) NSString *serviceQQ1;                    /**<   QQ客服q1*/
@property (nonatomic, copy) NSString *serviceQQ2;                    /**<   QQ客服q2*/
@property (nonatomic, copy) NSString *appPopupWechatNum;        /**<   微信客服号 */
@property (nonatomic, copy) NSString *appPopupWechatImg;        /**<   微信客服二维码 */
@property (nonatomic, copy) NSString *appPopupQqNum;        /**<   QQ客服号 */
@property (nonatomic, copy) NSString *appPopupQqImg;        /**<   微信客服二维码 */
@property (nonatomic, copy) NSString *domainBindAgentId;    /**<   如果这个属性大于0，则在注册邀请人输入框填入改ID，且无法更改 */
@property (nonatomic, copy) NSString *homeTypeSelect;        /**<  是否开启前台分类*/
@property (nonatomic, copy) NSString *missionPopUpSwitch;    /**<   开启后，首页会显示浮窗，点击弹出任务框  0未开启，1开启UGSystemConfigModel */
@property (nonatomic, copy) NSString *mission_logo;        /**<  手机端首页显示浮窗 任务图片*/

@property (nonatomic, copy) NSArray<UGMobileMenu *> *mobileMenu;

@property (nonatomic) NSInteger inviteCodeSwitch;          /**<   邀请码 0不填，1选填，2必填 */
@property (nonatomic, strong) NSString *inviteWord;			/**<   邀请码文字 */
@property (nonatomic, strong) InviteCodeConfigModel * inviteCode;
@property (nonatomic) NSInteger hide_reco;          /**<   代理人 0不填，1选填，2必填 */

@property (nonatomic, copy) NSString *popup_type;         /**<   公告  0直接弹窗，1登录后弹出 */
@property (nonatomic) NSInteger reg_name;           /**<   真实姓名  0不填，1选填，2必填 */
@property (nonatomic) NSInteger reg_fundpwd;        /**<   取款密码  0不填，1选填，2必填 */
@property (nonatomic) NSInteger reg_qq;             /**<   QQ  0不填，1选填，2必填 */
@property (nonatomic) NSInteger reg_fb;             /**<   FACEBOOK  0不填，1选填，2必填 */
@property (nonatomic) NSInteger reg_wx;             /**<   微信  0不填，1选填，2必填 */
@property (nonatomic) NSInteger reg_phone;          /**<   手机  0不填，1选填，2必填 */
@property (nonatomic) NSInteger reg_email;          /**<   邮箱  0不填，1选填，2必填 */
@property (nonatomic) NSInteger reg_vcode;          /**<   0无验证码，1图形验证码 3点击显示图形验证码 2滑块验证码 */
@property (nonatomic) NSInteger pass_limit;         /**<   注册密码强度，0、不限制；1、数字字母；2、数字字母符合 */
@property (nonatomic) NSInteger pass_length_min;    /**<   注册密码最小长度 */
@property (nonatomic) NSInteger pass_length_max;    /**<   注册密码最大长度 */
@property (nonatomic) BOOL googleVerifier;          /**<   是否开启google 验证 */
@property (nonatomic) int rankingListSwitch;        /**<   是否显示中奖/投注排行榜 */
@property (nonatomic) BOOL recharge;                /**<   上级充值开关 */
@property (nonatomic) BOOL smsVerify;               /**<   手机短信验证 */
@property (nonatomic) BOOL allowreg;                /**<   是否开启注册功能。 */
@property (nonatomic) BOOL allowMemberCancelBet;    /**<   是否允许会员撤单，1允许 0不允许 */
@property (nonatomic) BOOL m_promote_pos;           /**<   优惠活动显示在首页还是内页，1首页，0内页 */
@property (nonatomic) BOOL yuebaoSwitch;            /**<   未登录时是否允许访问利息宝 */
@property (nonatomic) BOOL mBonsSwitch;            /**<   俸禄开关开启。0 为开启， 1 为 关闭*/
@property (nonatomic) BOOL lhcdocIsShowNav;          /**<   是否开启分栏（六合模板   true 开启） */
@property (nonatomic, copy) NSString *chatRoomName;           /**<   聊天室名称*/
@property (nonatomic, assign) NSInteger chatFollowSwitch;                  /**<   0-不能分享 1- 允许分享 */
@property (nonatomic) BOOL chatShareBet;                  /**<   是否允许注单分享 */

@property (nonatomic, copy) NSString *chatMinFollowAmount;    /**<   聊天室跟注最小金额*/

@property (nonatomic, copy) NSString *easyRememberDomain;    /**<   GPK版易记的网址  动态域名  */

@property (nonatomic, copy) NSArray <LHPriceModel *>*lhcPriceList;    /**<   六合发帖价格范围 */

@property (nonatomic, copy) NSArray<UGUserCenterItem *> *userCenter;
@property (nonatomic) BOOL lhcdocMiCard;                /**<   六合彩开奖咪牌(默认状态)开关 */
@property (nonatomic, copy) NSString * lhcdocLotteryStr;/**<   六合彩预备开奖文字*/
@property (nonatomic, copy) NSString * appSelectType;/**<   六合资料模版 首页解码器显示的彩种 0为默认 其他为彩种id*/

@property (nonatomic, copy) NSString * chatLink;/**<   聊天的链接*/
@property (nonatomic) BOOL switchAgentRecharge;                /**<   给下级会员充值开关 */
@property (nonatomic) BOOL betAmountIsDecimal;          /**<   1=允许小数点，0=不允许，以前默认是允许投注金额带小数点的，默认为1 */

@property (nonatomic) BOOL activeReturnCoinStatus ;                /**<   是否開啟拉條模式 */
@property (nonatomic) int activeReturnCoinRatio  ;                /**<  拉條最大值    拉條最小值固定為 0   */
@property (nonatomic) int adSliderTimer  ;                /**<  首页腰部广告轮播时间间隔  */
@property (nonatomic) BOOL chaseNumber;                /**<   追号开关  默认关 */
@property (nonatomic) BOOL selectNumber;                /**<   机选开关  默认关 */

@property (nonatomic) BOOL loginVCode;                /**<   登录增加了滑动验证码配置  默认开 */
@property (nonatomic) BOOL announce_first;                /**<   手机公告是否展开第1条   */
@property (nonatomic, copy) NSString *switchBindVerify;                /**<   帐户绑定验证提款密码  默认关闭 "0" */

@property (nonatomic, copy) NSString * switchShowFriendReferral;/**<   //是否显示 首页推荐好友显示 1 显示
*/
@property (nonatomic, copy) NSString * showNavigationBar;/**<   //显示在前还是后 1 前 0 后
*/

@property (nonatomic, copy) OauthModel * oauth;/**<   第三方登录*/
@property (nonatomic, copy) NSString * currency;/**<   /货币单位，默认人民币  CNY    currency*/

@property (nonatomic, copy) NSString * chatShareBetMinAmount;/**<   聊天室 注单分享最小金额限制*/

@property (nonatomic, copy) loginNoticeModel * loginNotice;/**<   登录通知*/

@property (nonatomic) BOOL mobileHomeGameTypeSwitch;                /**<   系统设置-内容管理-手机游戏图标，关闭开关时，只需隐藏前台分类tab，后台游戏图标内容不变 */

@property (nonatomic) BOOL lhcdocSwitchMobileHome;                /**<  六合个人中心我的面板是否隐藏 */

//
+ (instancetype)currentConfig;

+ (void)setCurrentConfig:(UGSystemConfigModel *)config;


// 自定义参数
@property (nonatomic, readonly) NSArray <NSString *>*qqs;


@property (nonatomic) BOOL hasShare;                /**<   是否可以下注分享*/
//优惠图片分类信息
@property (nonatomic, strong) NSDictionary *typyArr;/**<   优惠图片分类信息*/
@property (nonatomic) NSInteger typeIsShow;           /**<    1 有分类 0没有分类 */
@property (nonatomic) BOOL switchShowActivityCategory;            /**<   前台申请彩金按分类显示 */
@property (nonatomic) NSInteger switchCoinPwd;
@property (nonatomic, strong) NSArray<NSString *> * coinPwdAuditOptionAry;
@end

NS_ASSUME_NONNULL_END
