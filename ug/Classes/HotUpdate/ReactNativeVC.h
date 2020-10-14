//
//  ReactNativeVC.h
//  ug
//
//  Created by fish on 2020/2/13.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+RnKeyValues.h"

// ReactNativeHelper
#import "ReactNativeHelper.h"


NS_ASSUME_NONNULL_BEGIN


@interface RnPageModel : NSObject

// 替换oc页面
@property (nonatomic, strong) NSString *vcName;     /**<   要被替换的oc页面类名 */
@property (nonatomic, strong) NSString *rnName;     /**<   rn页面类名 */
@property (nonatomic, strong) NSString *vcName2;    /**<   要替换的oc页面类名 */
@property (nonatomic, assign) BOOL fd_interactivePopDisabled;       /**<   是否禁用全屏滑动返回上一页 */
@property (nonatomic, assign) BOOL fd_prefersNavigationBarHidden;   /**<   是否隐藏导航条 */
@property (nonatomic, assign) BOOL 允许游客访问;
@property (nonatomic, assign) BOOL 允许未登录访问;

// 新增彩种
@property (nonatomic, strong) NSString *gameType;   /**<   彩种类型 */

// 新增我的页Item跳转
@property (nonatomic, assign) NSInteger userCenterItemCode; /**<   页面标识 */
@property (nonatomic, strong) NSString *userCenterItemIcon; /**<   默认图标URL */
@property (nonatomic, strong) NSString *userCenterItemTitle;/**<   默认标题 */

// 新增TabbarItem跳转
@property (nonatomic, strong) NSString *tabbarItemPath;     /**<   页面标识 */
@property (nonatomic, strong) NSString *tabbarItemIcon;     /**<   默认图标URL */
@property (nonatomic, strong) NSString *tabbarItemTitle;    /**<   默认标题 */

// 新增linkCategory跳转
@property (nonatomic, assign) NSInteger linkCategory;   /**<   linkCategory ： 1=彩票游戏；2=真人视讯；3=捕鱼游戏；4=电子游戏；5=棋牌游戏；6=体育赛事；7=导航链接；8=电竞游戏；9=聊天室；10=手机资料栏目 */
@property (nonatomic, assign) NSInteger linkPosition;

+ (instancetype)updateVersionPage;
@end



@interface ReactNativeVC : UIViewController

+ (instancetype)reactNativeWithRPM:(RnPageModel *)rpm params:(NSDictionary <NSString *, id>* _Nullable)params;  /**<   切换rn页面 */
- (BOOL)isEqualRPM:(RnPageModel *)rpm;
- (void)pushOrJump:(BOOL)pushOrJump rpm:(RnPageModel *)rpm params:(NSDictionary<NSString *,id> *)params;
+ (void)setTabbarHidden:(BOOL)hidden animated:(BOOL)animated;
+ (void)showLastRnPage;
@end

NS_ASSUME_NONNULL_END
