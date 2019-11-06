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

@property (nonatomic, strong) UIColor *bgColor;                 /**<    背景 渐变色 */
@property (nonatomic, strong) UIColor *navBarBgColor;           /**<    导航条背景色 */
@property (nonatomic, strong) UIColor *tabBarBgColor;           /**<    Tabbar背景色 */
@property (nonatomic, strong) UIColor *tabNoSelectColor;        /**<    Tabbar未选中颜色 */
@property (nonatomic, strong) UIColor *tabSelectedColor;        /**<    Tabbar已选中颜色 */
@property (nonatomic, strong) UIColor *cellBgColor;             /**<    Cell背景色 */
@property (nonatomic, strong) UIColor *progressBgColor;         /**<    进度条背景渐变色 */
@property (nonatomic, strong) UIColor *homeContentColor;        /**<   首页内容底色 */
@property (nonatomic, strong) UIColor *CLBgColor;               /**<    长龙灰色背景底色 */
@property (nonatomic, strong) UIColor *menuHeadViewColor;       /**<    侧边栏顶部背景渐变色 */
@property (nonatomic, strong) UIColor *textColor1;              /**<    默认字颜色 黑色 */
@property (nonatomic, strong) UIColor *textColor2;              /**<    占位字颜色 深灰色 */
@property (nonatomic, strong) UIColor *textColor3;              /**<    占位字颜色 淡灰色 */


- (void)useSkin;    /**<   应用此皮肤 */



+ (UGSkinManagers *)randomSkin; /**<   测试换肤功能时使用 */
@end

NS_ASSUME_NONNULL_END
