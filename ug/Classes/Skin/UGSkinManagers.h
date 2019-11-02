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

@property (nonatomic, strong) UIColor *bgColor;                 /**<    背景色 */
@property (nonatomic, strong) UIColor *navBarBgColor;           /**<    导航条背景色 */
@property (nonatomic, strong) UIColor *tabBarBgColor;           /**<    Tabbar背景色 */
@property (nonatomic, strong) UIColor *tabNoSelectColor;        /**<    Tabbar非选中颜色 */
@property (nonatomic, strong) UIColor *tabSelectedColor;        /**<    Tabbar已选中颜色 */
@property (nonatomic, strong) UIColor *cellBgColor;             /**<    Cell背景色 */
@property (nonatomic, strong) UIColor *progressBgColor;         /**<    进度条背景色 */
@property (nonatomic, strong) UIColor *homeContentColor;
@property (nonatomic, strong) UIColor *homeContentBorderColor;  /**<    描边色 */
@property (nonatomic, strong) UIColor *menuHeadViewColor;
@property (nonatomic, strong) UIColor *signBgColor;             /**<    签到页背景色 */

- (void)useSkin;    /**<   应用此皮肤 */



+ (UGSkinManagers *)randomSkin; /**<   测试换肤功能时使用 */
@end

NS_ASSUME_NONNULL_END
