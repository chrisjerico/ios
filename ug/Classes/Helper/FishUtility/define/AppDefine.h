//
//  AppDefine.h
//  Consult
//
//  Created by fish on `2017/10/25.
//  Copyright © 2017年 fish. All rights reserved.
//

#import <Foundation/Foundation.h>

#define APP [AppDefine shared]

#define _LoadVC_from_storyboard_(sid)   [AppDefine viewControllerWithStoryboardID:sid]
#define _LoadView_from_nib_(nibName)    [AppDefine viewWithNibName:nibName]


@interface AppDefine : NSObject

@property (nonatomic, readonly) NSString *Host;         /**<    服务器地址 */
@property (nonatomic, readonly) NSString *SiteId;       /**<   站点ID */


@property (nonatomic) NSInteger PageCount;              /**<    TableView每页显示多少条数据 */
@property (nonatomic) NSUInteger PhotoMaxLength;        /**<    图片上传允许的最大大小 */



+ (instancetype)shared;
@end



#pragma mark - System
// ——————————————————————————
@interface AppDefine ()

@property (nonatomic) NSString *Name;               /**<    App名 */
@property (nonatomic) NSString *BundleId;           /**<    BundleID */
@property (nonatomic) NSString *Version;            /**<    版本号 */
@property (nonatomic) NSString *Build;              /**<    Build号 */

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

