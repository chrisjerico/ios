//
//  UGSystemConfigModel.h
//  ug
//
//  Created by ug on 2019/7/23.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"
#import "UGChatRoomModel.h"
NS_ASSUME_NONNULL_BEGIN


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
    UCI_QQ客服    = 19,
};

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
};



#define SysConf [UGSystemConfigModel currentConfig]

// 我的页功能按钮Model
@interface UGUserCenterItem :UGModel
@property (nonatomic, assign) UserCenterItemType code; /**<   id */
@property (nonatomic, copy) NSString *logo; /**<   图标 */
@property (nonatomic, copy) NSString *name; /**<   标题 */
// 自定义参数
@property (nonatomic, readonly) NSString *lhImgName;    /**<   六合模版使用的本地图标 */
@property (nonatomic, readonly) NSString *bmImgName;    /**<   黑色模板使用的本地图标 */
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



@protocol UGMobileMenu <NSObject>

@end
@interface UGMobileMenu :UGModel<UGMobileMenu>
@property (nonatomic, copy) NSString *path; /**<   界面 */
@property (nonatomic, copy) NSString *icon; /**<   图标 */
@property (nonatomic, copy) NSString *name; /**<   标题 */
@property (nonatomic) NSInteger sort;       /**<   排序 */
@property (nonatomic) BOOL status;          /**<   1=显示建设中页面；0=正常显示 */
// 自定义参数
@property (nonatomic, readonly) MobileMenuType type;        /**<   页面类型 */
@property (nonatomic, readonly) NSString *defaultImgName;   /**<   本地图标 */
@property (nonatomic, readonly) Class cls;
+ (NSArray <UGMobileMenu *>*)allMenus;
- (void)createViewController:(void (^)(__kindof UIViewController *vc))completion;
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
@property (nonatomic, copy) NSString *mobileTemplateLhcStyle;     /**<   六合配色方案 */
@property (nonatomic, copy) NSString *mobileTemplateStyle;     /**<   新年红配色方案 */
@property (nonatomic, copy) NSString *webName;                    /**<   首页底部文字   网址名称*/
@property (nonatomic, copy) NSString *serviceQQ1;                    /**<   QQ客服q1*/
@property (nonatomic, copy) NSString *serviceQQ2;                    /**<   QQ客服q2*/
@property (nonatomic, copy) NSString *appPopupWechatNum;        /**<   微信客服号 */
@property (nonatomic, copy) NSString *appPopupWechatImg;        /**<   微信客服二维码 */
@property (nonatomic, copy) NSString *appPopupQqNum;        /**<   QQ客服号 */
@property (nonatomic, copy) NSString *appPopupQqImg;        /**<   微信客服二维码 */

@property (nonatomic, copy) NSArray<UGMobileMenu *> *mobileMenu;

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
@property (nonatomic) BOOL googleVerifier;          /**<   是否开启google 验证 */
@property (nonatomic) int rankingListSwitch;        /**<   是否显示中奖/投注排行榜 */
@property (nonatomic) BOOL recharge;                /**<   上级充值开关 */
@property (nonatomic) BOOL smsVerify;               /**<   手机短信验证 */
@property (nonatomic) BOOL allowreg;                /**<   是否开启注册功能。 */
@property (nonatomic) BOOL allowMemberCancelBet;    /**<   是否允许会员撤单，1允许 0不允许 */
@property (nonatomic) BOOL m_promote_pos;           /**<   优惠活动显示在首页还是内页，1首页，0内页 */
@property (nonatomic) BOOL yuebaoSwitch;            /**<   未登录时是否允许访问利息宝 */
@property (nonatomic, copy) NSString *chatRoomName;           /**<   聊天室名称*/
@property (nonatomic) BOOL chatFollowSwitch;                  /**<   是否允许聊天室跟注 */
@property (nonatomic, copy) NSString *chatMinFollowAmount;    /**<   聊天室跟注最小金额*/

@property (nonatomic, copy) NSString *easyRememberDomain;    /**<   黑色模板易记的网址*/

@property (nonatomic, copy) NSArray <LHPriceModel *>*lhcPriceList;    /**<   六合发帖价格范围 */

@property (nonatomic, copy) NSArray<UGUserCenterItem *> *userCenter;
@property (nonatomic) BOOL lhcdocMiCard;                /**<   六合彩开奖咪牌(默认状态)开关 */
@property (nonatomic, copy) NSString * lhcdocLotteryStr;/**<   六合彩预备开奖文字*/
+ (instancetype)currentConfig;

+ (void)setCurrentConfig:(UGSystemConfigModel *)config;


// 自定义参数
@property (nonatomic, readonly) NSArray <NSString *>*qqs;

@property (nonatomic,strong) NSMutableArray<UGChatRoomModel *> *chatRoomAry;                    /**<    在线配置的聊天室i*/
@property (nonatomic,strong) NSMutableArray *typeIdAry;                    /**<    在线配置的聊天室id对应的游戏id */
@end

NS_ASSUME_NONNULL_END
