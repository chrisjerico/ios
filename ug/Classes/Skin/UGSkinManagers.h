//
//  UGSkinManagers.h
//  ug
//
//  Created by ug on 2019/10/1.
//  Copyright © 2019 ug. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UGNavigationController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGSkinManagers : NSObject

+(UGSkinManagers *)shareInstance;
/******************************************************************************
 函数名称 : -(UIColor *)navbarbgColor:(NSString *)skitType;
 函数描述 : 根据参数返回导航栏的背景颜色
 输入参数 : 1-19 石榴红，新年红
 输出参数 : N/A
 返回参数 : UIColor 
 备注信息 :
 ******************************************************************************/
//-(UIColor *)navbarbgColor:(NSString *)skitType;

/******************************************************************************
 函数名称 : -(UIColor *)tabbarbgColor:(NSString *)skitType;
 函数描述 : 根据参数返回tabbar栏的背景颜色
 输入参数 : 1-19 石榴红，新年红
 输出参数 : N/A
 返回参数 : UIColor
 备注信息 :111
 ******************************************************************************/
-(UIColor *)tabbarbgColor:(NSString *)skitType;

/******************************************************************************
 函数名称 : -(UIColor *)bgColor:(NSString *)skitType;
 函数描述 : 根据参数返回的背景颜色
 输入参数 : 1-19 石榴红，新年红
 输出参数 : N/A
 返回参数 : UIColor
 备注信息 :
 ******************************************************************************/
//-(UIColor *)bgColor:(NSString *)skitType;

/******************************************************************************
 函数名称 : resetNavbarAndTabBarBgColor;
 函数描述 : 根据参数设置导航栏和tabbar的背景颜色
 输入参数 : 1-19 石榴红，新年红
 输出参数 : N/A
 返回参数 : void
 备注信息 :
// ******************************************************************************/
//-(void)resetNavbarAndTabBarBgColor:(NSString *)skitType;

/******************************************************************************
 函数名称 : conversionSkitType;
 函数描述 : 根据系统设置返回皮肤类型
 输入参数 : void
 输出参数 : 1-19 石榴红，新年红
 返回参数 : String
 备注信息 :
 ******************************************************************************/
-(NSString *)conversionSkitType;

/******************************************************************************
 函数名称 : setSkin;
 函数描述 : 发动换皮肤方法
 输入参数 : void
 输出参数 : void
 返回参数 : void
 备注信息 :
 ******************************************************************************/
-(void)setSkin;

/******************************************************************************
 函数名称 : setTabbgColor;
 函数描述 : 返回Tabbarbg颜色方法
 输入参数 : void
 输出参数 : void
 返回参数 : UIColor
 备注信息 :
 ******************************************************************************/
-(UIColor *)setTabbgColor;

/******************************************************************************
 函数名称 : setNavbgColor;
 函数描述 : 返回Navbg颜色方法
 输入参数 : void
 输出参数 : void
 返回参数 : UIColor
 备注信息 :
 ******************************************************************************/
-(UIColor *)setNavbgColor;
/******************************************************************************
 函数名称 : setbgColor;
 函数描述 : 返回bg颜色方法
 输入参数 : void
 输出参数 : void
 返回参数 : UIColor
 备注信息 :
 ******************************************************************************/
-(UIColor *)setbgColor;
/******************************************************************************
 函数名称 : settabNOSelectColor;
 函数描述 : 返回tabbar默认颜色方法
 输入参数 : void
 输出参数 : void
 返回参数 : UIColor
 备注信息 :
 ******************************************************************************/
-(UIColor *)settabNOSelectColor;
/******************************************************************************
 函数名称 : settabSelectColor;
 函数描述 : 返回tabbar选中颜色方法
 输入参数 : void
 输出参数 : void
 返回参数 : UIColor
 备注信息 :
 ******************************************************************************/
-(UIColor *)settabSelectColor;

/******************************************************************************
 函数名称 : setCellbgColor;
 函数描述 : 返回cell颜色方法
 输入参数 : void
 输出参数 : void
 返回参数 : UIColor
 备注信息 :
 ******************************************************************************/
-(UIColor *)setCellbgColor;

/******************************************************************************
 函数名称 : setNavbgStringColor;
 函数描述 : 返回nav颜色字符串方法
 输入参数 : void
 输出参数 : void
 返回参数 : NSString
 备注信息 :
 ******************************************************************************/
-(NSString *)setNavbgStringColor;

/******************************************************************************
 函数名称 : skitType;
 函数描述 : 返回 经典，新年红 石榴红方法
 输入参数 : void
 输出参数 : void
 返回参数 : NSString
 备注信息 :
 ******************************************************************************/
-(NSString *)skitType;

/******************************************************************************
 函数名称 : setMineProgressViewColor;
 函数描述 : 返回我的进度条颜色方法
 输入参数 : void
 输出参数 : void
 返回参数 : UIColor
 备注信息 :
 ******************************************************************************/
-(UIColor *)setMineProgressViewColor;


/******************************************************************************
 函数名称 : setChatNavbgStringColor;
 函数描述 : 返回聊天颜色方法
 输入参数 : void
 输出参数 : void
 返回参数 : NSString
 备注信息 :
 ******************************************************************************/
-(NSString *)setChatNavbgStringColor;

/******************************************************************************
 函数名称 : sethomeContentColor;
 函数描述 : 返回首页的内容：cell，广告条，长龙，彩票颜色方法
 输入参数 : void
 输出参数 : void
 返回参数 : UIColor
 备注信息 :
 ******************************************************************************/
-(UIColor *)sethomeContentColor;


/******************************************************************************
 函数名称 : sethomeContentBorderColor;
 函数描述 : 返回首页的内容：cell，广告条，长龙，彩票 边框颜色方法
 输入参数 : void
 输出参数 : void
 返回参数 : UIColor
 备注信息 :
 ******************************************************************************/
-(UIColor *)sethomeContentBorderColor;

/******************************************************************************
 函数名称 : setMenuHeadViewColor;
 函数描述 : 返回menuhead颜色方法
 输入参数 : void
 输出参数 : void
 返回参数 : UIColor
 备注信息 :
 ******************************************************************************/
-(UIColor *)setMenuHeadViewColor;

/******************************************************************************
 函数名称 : setSignbgColor;
 函数描述 : 返回签到页面bg颜色方法
 输入参数 : void
 输出参数 : void
 返回参数 : UIColor
 备注信息 :
 ******************************************************************************/
-(UIColor *)setSignbgColor;

/******************************************************************************
 函数名称 : navigationBar;
 函数描述 : 改变navbar 的颜色
 输入参数 : UGNavigationController，UIColor
 输出参数 : void
 返回参数 : void
 备注信息 :
 ******************************************************************************/
-(void)navigationBar:(UGNavigationController *)nav bgColor:(UIColor *)bgColor;
@end


#define UIColorTheme1 UGRGBColor(239, 83, 98) // Grapefruit
#define UIColorTheme2 UGRGBColor(254, 109, 75) // Bittersweet
#define UIColorTheme3 UGRGBColor(255, 207, 71) // Sunflower
#define UIColorTheme4 UGRGBColor(159, 214, 97) // Grass
#define UIColorTheme5 UGRGBColor(63, 208, 173) // Mint
#define UIColorTheme6 UGRGBColor(49, 189, 243) // Aqua
#define UIColorTheme7 UGRGBColor(90, 154, 239) // Blue Jeans
#define UIColorTheme8 UGRGBColor(172, 143, 239) // Lavender
#define UIColorTheme9 UGRGBColor(238, 133, 193) // Pink Rose
#define UIColorTheme10 UGRGBColor(39, 192, 243) // Dark
@interface UGSkinManagers (ThemeColor)

+ (UIColor *)randomThemeColor;
@end

NS_ASSUME_NONNULL_END
