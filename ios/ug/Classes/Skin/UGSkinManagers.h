//
//  UGSkinManagers.h
//  abcc4
//
//  Created by fish on 2019/11/1.
//  Copyright © 2019 fish. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


#define Skin1 [UGSkinManagers currentSkin]

@interface UGSkinManagers : NSObject

+ (UGSkinManagers *)currentSkin;    /**<   获取当前正在使用的皮肤 */
+ (UGSkinManagers *)skinWithSysConf;/**<   根据SysConf获取对应皮肤 */
+ (UIColor *)randomThemeColor;

@property (nonatomic, strong) NSString *skitType;               /**<   皮肤类型 */
@property (nonatomic, strong) NSString *skitString;             /**<   皮肤类型 */

@property (nonatomic, strong) UIColor *bgColor;                 /**<    背景 渐变色 */
@property (nonatomic, strong) UIColor *navBarBgColor;           /**<    导航条背景色 */
@property (nonatomic, strong) UIColor *tabBarBgColor;           /**<    Tabbar背景色 */
@property (nonatomic, strong) UIColor *tabNoSelectColor;        /**<    Tabbar未选中颜色 */
@property (nonatomic, strong) UIColor *tabSelectedColor;        /**<    Tabbar已选中颜色 */
@property (nonatomic, strong) UIColor *cellBgColor;             /**<    Cell背景色 */
@property (nonatomic, strong) UIColor *progressBgColor;         /**<    进度条背景渐变色 */
@property (nonatomic, strong) UIColor *homeContentColor;        /**<    首页内容底色 */
@property (nonatomic, strong) UIColor *homeContentSubColor;     /**<    首页游戏列表二级菜单背景色 */
@property (nonatomic, strong) UIColor *CLBgColor;               /**<    长龙灰色背景底色 */
@property (nonatomic, strong) UIColor *menuHeadViewColor;       /**<    侧边栏顶部背景渐变色 */
@property (nonatomic, strong) UIColor *textColor1;              /**<    默认字颜色 黑色 */
@property (nonatomic, strong) UIColor *textColor2;              /**<    占位字颜色 深灰色 */
@property (nonatomic, strong) UIColor *textColor3;              /**<    占位字颜色 淡灰色 */
@property (nonatomic, strong) UIColor *textColor4;              /**<    反差字体 白色 */

- (void)useSkin;    /**<   应用此皮肤 */
- (BOOL)isBlack;    /**<   是否是黑色模板 */
- (BOOL)isLH;       /**<   是否是六合资料 */
- (BOOL)isJY;       /**<   是否是简约模板 */
- (BOOL)isSLH;       /**<   是否是石榴红模板 */



+ (UGSkinManagers *)next; /**<   测试换肤功能时使用 */
+ (UGSkinManagers *)last;
+ (UGSkinManagers *)lhSkin;

+ (UIColor *)jsftColor:(int)num;/**<   极速快艇的球颜色 */
@end

NS_ASSUME_NONNULL_END
