//
//  AppDefine.h
//  Consult
//
//  Created by fish on `2017/10/25.
//  Copyright © 2017年 fish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SiteModel.h"
#import "ReactNativeVC.h"

// 测试环境宏
#define APP_TEST
#define DisableLanguage 1
#define RNCheckVersion1 @"1.2" // react-native升级了版本时更新，修改后会导致旧版本无法热更新


#define APP [AppDefine shared]

#define _LoadVC_from_storyboard_(sid)   [AppDefine viewControllerWithStoryboardID:sid]
#define _LoadView_from_nib_(nibName)    [AppDefine viewWithNibName:nibName]


@interface AppDefine : NSObject

@property (nonatomic, strong) NSString *Host;         /**<    服务器地址 */
@property (nonatomic, strong) NSString *ImageHost;      /**<    图片服务器地址 */
@property (nonatomic, readonly) NSString *SiteId;       /**<   当前站点ID */
@property (nonatomic, readonly) NSArray <SiteModel *> *allSites;  /**<   所有站点 */

@property (nonatomic) NSInteger PageCount;              /**<    TableView每页显示多少条数据 */
@property (nonatomic) NSUInteger PhotoMaxLength;        /**<    图片上传允许的最大大小 */
@property (nonatomic, readonly) NSString *beginTime;         /**<    推荐收益的默认开始时间*/

@property (nonatomic) BOOL isFish;

@property (nonatomic,assign)BOOL lotteryHallCustomImgS;                 /**<   彩票大厅自定义图标 */


@property (nonatomic,assign) BOOL isShow4;                              /**<  任务中心显示4个，不显示图片 */
@property (nonatomic,assign) BOOL isShowWZ;                             /**<  将选填 这两个字更换为  如果没有，可不填写 */
@property (nonatomic,assign) BOOL isHideText;                           /**<  在线三方支付设置快捷金额后，隐藏掉输入金额那一栏 */


@property (nonatomic,assign) BOOL isShowHornView;                       /**<  六合模板显示喇叭*/
@property (nonatomic,assign) BOOL isYHShowTitle;                          /**<  优惠详情现在titleLabel ,导航条显示：活动详情*/
@property (nonatomic,assign) BOOL isTabHot;                               /**< tab聊天室+红包动画*/
@property (nonatomic,assign) BOOL isTabMassageBadge;                      /**< 底部导航栏【站内信】收到新的站内信时，添加提示功能 */
@property (nonatomic,assign) BOOL isTextWhite;                            /**< 投注页面封盘时间字体颜色需要调整为白色 */

@property (nonatomic,assign) BOOL isGPKDeposit;                            /**< GPK版右上角最近浏览改为 存取款  */
@property (nonatomic,assign) BOOL isTitleWhite;                            /**< 游戏大厅绿色字体改为白色字体 */

@property (nonatomic,assign) BOOL isShowSalary;                            /**<  任务系统周俸禄、月俸禄   */
@property (nonatomic,assign) BOOL isBgColorForMoneyVC;                     /**< 存款页面进去的底色为bg色   */
@property (nonatomic,assign) BOOL isC217RWDT;                                /**<  我的把任务中心4个字换成任务大厅*/
@property (nonatomic) BOOL isNoLeftButton;                               /**<  客服界面没有返回按钮，然后把×加亮 */
@property (nonatomic) BOOL isWebRightMenu;                               /**<  侧边栏为网络数据*/
@property (nonatomic) BOOL isHideSQSM;                               /**<  申请彩金页 申请说明的栏位去掉*/
@property (nonatomic) BOOL isShowSummary;                               /**<  我的推荐会员管理,添加一个盈亏汇总*/
@property (nonatomic,assign) BOOL isHideBank;                           /**<  在线支付隐藏银行按钮*/
//==============================================个人中心
@property (nonatomic) BOOL isSecondUrl;                               /**<  个人中心的在线客服跳转链接改为系统设置当中的在线客服2 */
@property (nonatomic) BOOL isC239B;                                   /**<  个人中心去掉真实名字，成长值，成长进度*/
@property (nonatomic) BOOL isNoAlert;                                   /**<  个人中心自动转换额度的提示去除*/
@property (nonatomic) BOOL isShowDML;                                   /**<  个人中心新增让会员查看提款所需打码量和实际打码量 */
//==============================================下注界面
@property (nonatomic,assign) BOOL isOneRow;                         /**<   开奖数据只显示一行*/
@property (nonatomic,assign) BOOL isRed;                                 /**<   tab选中点为红色，内容选择边框为红色，已选中注数的 数量颜色也更换成红色 */
@property (nonatomic,assign) BOOL isBA;                                 /**<   六合彩的特码A 和特码B 换一下位置 */
@property (nonatomic,assign) BOOL isC126CellStyle;                          /**<  下注测边栏，选中cell 背景为图*/
@property (nonatomic,assign) BOOL isAllCellStyle;                          /**<  下注测边栏，选中cell 为NavBgColor  选中无白边*/
@property (nonatomic) BOOL isHideTV;                                    /**<  去除澳门六合彩显示的小电视*/
@property (nonatomic,assign) BOOL isShowJinbei;                         /**<  显示金杯  六合彩种*/
@property (nonatomic,assign) BOOL isShowOtherJinbei;                    /**<  显示金杯   除六合彩种之外其他全部 */
@property (nonatomic,assign) BOOL addIcons;                                /**<   投注页面开奖旁边添加 开奖直播 长龙助手 开奖网  */
@property (nonatomic,assign) BOOL isReplaceIcon;                           /**< 投注页面开奖旁边添加 开奖直播 长龙助手 开奖网更换图标样式1   */
@property (nonatomic,assign)BOOL isSectionWhite;                          /**< IOS 彩票投注页面，所选的玩法名称显示修改成白色字体  */
@property (nonatomic,assign) BOOL isRedWhite;                             /**<  下注界面新年红模板样式 红白配色*/
@property (nonatomic,assign) BOOL isShowBorder;                         /**< 下注上面显示边框*/
@property (nonatomic,assign) BOOL isSelectStyle;                        /**< 下注六合彩 特码A|特码B 有选中效果*/
@property (nonatomic,assign) BOOL isGrey;                               /**<  下注界面tableCell 背景为灰色*/
@property (nonatomic,assign) BOOL isYellow;                             /**<  下注界面已选中数字为亮黄色*/
@property (nonatomic,assign)BOOL isBall6;                              /**<  下注界面上面显示为球图*/
@property (nonatomic,assign) BOOL isBallParty;                          /**<  下注界面上面显示为方形*/
@property (nonatomic,assign) BOOL isBall;                               /**<  下注界面号码显示为球图 */
@property (nonatomic,assign) BOOL isLight;                              /**<  下注界面背景色变淡*/
@property (nonatomic,assign) BOOL isChatWhite;                           /**<  下注界面 投注区，聊天室标题文字为白色*/
@property (nonatomic,assign) BOOL isHideChat;                            /**<  下注界面 投注区，聊天室图片隐藏  显示历史开奖几期*/
@property (nonatomic,assign)BOOL isBorderNavBarBgColor;                /**<  选中底色为navBarBgColor */
@property (nonatomic,assign) BOOL betOddsIsRed;                        /**<   下注页面赔率显示为红色 */
@property (nonatomic,assign) BOOL betBgIsWhite;                         /**<   下注页面背景白色 */
@property (nonatomic,assign) BOOL betSizeIsBig;                         /**<   下注页面Cell大字体 */
@property (nonatomic,assign) UIFont *cellBigFont;              /**<   下注页面Cell大字体  [UIFont boldSystemFontOfSize:17];*/
@property (nonatomic,assign) UIFont *cellNormalFont;           /**<   下注页面Cel正常l字体  [UIFont systemFontOfSize:14];*/
@property (nonatomic,assign)float cellNormalFontSize;                  /**<    下注页面Cel正常l字体  14] */
@property (nonatomic,assign)float borderWidthTimes;                    /**<    下注页面Cel边框宽的倍数 */
//==============================================虚拟币
@property (nonatomic,assign) BOOL isNoOnLineDoc;                          /**<  虚拟币在线支付没有文档*/
@property (nonatomic,assign) BOOL isHBDoc;                                /**<  虚拟币充值火币文档*/
//==============================================新的界面
@property (nonatomic,assign) BOOL isNewConversion;                          /**<  新的额度转换界面*/
@property (nonatomic,assign) BOOL isNewUserInfoView;                         /**<  新的我的资料界面*/
@property (nonatomic,assign) BOOL isNewLotteryView;                         /**<  新的彩票大厅界面*/
@property (nonatomic,assign) BOOL isNewChat;                                /**<  新的聊天室界面 tab 底部*/
//==============================================大转盘
@property (nonatomic,assign) BOOL isNoCry;                          /**<  没有哭脸*/
//==============================================首页
@property (nonatomic,assign) BOOL isShowLogo;                           /**<  首页中间游戏导航需增加logo图标，游戏导航栏可进行滑动  有左右箭头*/
@property (nonatomic,assign) BOOL isShowArrow;                          /**<  首页中间游戏导航需增加左右箭头 */
@property (nonatomic,assign)BOOL isWhite;                              /**<  首页游戏cell加白边 */
@property (nonatomic,assign) BOOL isCornerRadius;                       /**<  首页广告View加圆角*/
@property (nonatomic,assign) BOOL isFontSystemSize;                     /**<  首页导航文字不加粗*/
@property (nonatomic,assign) BOOL isNoBorder;                             /**<  首页优惠活动没有外面的View */
@property (nonatomic,assign) BOOL isWihiteBorder;                          /**<  首页优惠活动外面的View白色边框 */
@property (nonatomic,assign) BOOL isParagraphSpacing;                     /**<  首页公告详情段落有间距*/
@property (nonatomic,assign) BOOL isHideFoot;                             /**< 首页面手机端标记处去除  */
@property (nonatomic) BOOL isBottom;                                    /**<  首页二级分类图标显示的位置比照一样放右下角*/
@property (nonatomic) BOOL isChatButton;                                /**<  首页导航有聊天室按钮显示*/
@property (nonatomic) BOOL isNoSubtitle;                               /**<  首页游戏cell没有副标题的高度*/
@property (nonatomic,assign) BOOL isC190Cell;                                /**<  首页中优惠活动列表c190，c012 图片贴边 */
@property (nonatomic,assign) BOOL isNewLocation;                         /**<  首页刮刮乐，大转盘，砸金蛋移动到红包位置*/
@property (nonatomic) BOOL isTwoOnline;                                  /**< 首页点击在线客服会弹出框2个在线客服*/
@property (nonatomic,assign) BOOL isCanUploadAvatar;                /**<  提供给RN判断是否支持上传头像功能（2020-12-9添加）*/
//==============================================推荐收益
@property (nonatomic,assign) BOOL isShowAll;                           /**<  佣金比例全部展示样式*/
// 热更新相关字段
                                                   
@property (nonatomic) BOOL Test;                        /**<   是否是测试环境 */
@property (nonatomic, strong) NSString *rnVersion;      /**<    jspatch热更新版本号 */
@property (nonatomic, copy) NSArray <RnPageModel *>*rnPageInfos;/**<   需要替换成rn的页面 */
//@property (nonatomic, copy) NSString *publicKey;        /**<   公钥 */
+ (void)addYsReplacePage:(Class)cls1 toPage:(Class (^)(void))block; /**<   提供给原生使用的替换页面函数 */

+ (instancetype)shared;

- (void)setupSiteAndSkinParams;
@end



#pragma mark - H5 url
// ——————————————————————————
@interface AppDefine ()

@property (nonatomic, readonly) NSString *chatShareUrl; /**<   分享注单到聊天室URL */
@property (nonatomic, readonly) NSString *chatHomeUrl;  /**<   聊天室大厅URL */
@property(nonatomic, strong) dispatch_source_t messageRequestTimer;
- (NSString *)chatGameUrl:(NSString *)roomId hide:(BOOL )hideHead ;          /**<   聊天室-游戏房间 */
- (NSString *)htmlStyleString:(NSString *)content;  /**<   添加html样式 */

@end





#pragma mark - System
// ——————————————————————————
@interface AppDefine ()

@property (nonatomic) NSString *Name;               /**<    App名 */
@property (nonatomic) NSString *BundleId;           /**<    BundleID */
@property (nonatomic) NSString *Version;            /**<    版本号 */
@property (nonatomic) NSString *Build;              /**<    Build号 */
@property (nonatomic) NSString *DevUser;            /**<    开发者在当前电脑登录的用户名 */

@property (nonatomic) UIWindow *Window;             /**<    UIApplication.windows.first */
@property (nonatomic) CGRect Bounds;                /**<    bounds */
@property (nonatomic) CGSize Size;                  /**<    size */
@property (nonatomic) CGFloat Height;               /**<    屏幕高度 */
@property (nonatomic) CGFloat Width;                /**<    屏幕宽度 */

@property (nonatomic) NSString *DocumentDirectory;  /**<    沙盒 Document目录 */
@property (nonatomic) NSString *LibraryDirectory;   /**<    沙盒 Library目录 */
@property (nonatomic) NSString *CachesDirectory;    /**<    沙盒缓存目录 */

@property (nonatomic) CGFloat StatusBarHeight;      /**<    状态栏高度 */
@property (nonatomic) CGFloat BottomSafeHeight;     /**<    底部安全高度 */

+ (__kindof UIViewController *)viewControllerWithStoryboardID:(NSString *)sid;  /**<    从Storyboard加载vc */
+ (__kindof UIViewController *)viewControllerWithNibName:(NSString *)nibName;   /**<    从xib加载vc */
+ (__kindof UIView *)viewWithNibName:(NSString *)nibName;                       /**<    从xib加载view */
+ (NSString *)stringWithFloat:(double)f decimal:(unsigned short)d;              /**<   double转字符串，去除末尾的0 */
+ (NSString *)stringWithFileSize:(double)size;
+ (BOOL)hasUpdateWithCurrentVersion:(NSString *)v1 newVersion:(NSString *)v2;
@end



#pragma mark - Color
// ——————————————————————————
@interface AppDefine ()

// 主题色、辅色
@property (nonatomic) UIColor *ThemeColor1;          /**<    主题颜色 天蓝色 29, 161, 242 */
@property (nonatomic) UIColor *ThemeColor2;          /**<    主题副色 天青色 82, 204, 204 */
@property (nonatomic) UIColor *ThemeColor3;          /**<    主题副色 屎黄色 245, 210, 37 */
@property (nonatomic) UIColor *AuxiliaryColor1;      /**<    辅色 绿色 77, 191, 76 */
@property (nonatomic) UIColor *AuxiliaryColor2;      /**<    辅色 红色 250, 75, 75 */
@property (nonatomic) UIColor *AuxiliaryColor3;      /**<    辅色 橙色 245, 113, 69 */

// 黑色、灰色
@property (nonatomic) UIColor *TextColor1;           /**<    文字 黑色 51 */
@property (nonatomic) UIColor *TextColor2;           /**<    文字 深灰色 102 */
@property (nonatomic) UIColor *TextColor3;           /**<    文字 灰色1 描边 153 */
@property (nonatomic) UIColor *TextColor4;           /**<    文字 灰色2 170 */
@property (nonatomic) UIColor *LineColor;            /**<    分割线 浅灰色 204 */

// 淡灰色
@property (nonatomic) UIColor *LoadingColor;         /**<    加载/缺省 淡灰色 238 */
@property (nonatomic) UIColor *NavigationBarColor;   /**<    导航条 淡灰色 243 */
@property (nonatomic) UIColor *BackgroundColor;      /**<    背景色 淡灰色 247 */
@end




// double转字符串，去除末尾的0
#define _FloatString1(f) [AppDefine stringWithFloat:f decimal:1]
#define _FloatString2(f) [AppDefine stringWithFloat:f decimal:2]
#define _FloatString4(f) [AppDefine stringWithFloat:f decimal:4]

// 拼接图片URL
#define UGImageURL(path) [APP.ImageHost stringByAppendingFormat:@"/%@", path]
