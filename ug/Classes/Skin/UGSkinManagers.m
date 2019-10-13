//
//  UGSkinManagers.m
//  ug
//
//  Created by ug on 2019/10/1.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGSkinManagers.h"
#import "UIImage+YYgradientImage.h"
#import "UGSystemConfigModel.h"


@implementation UGSkinManagers

+(UGSkinManagers *)shareInstance{
    static UGSkinManagers *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
    

}


-(NSString *)navbarbgColorString:(NSString *)skitType{
    
    NSString *navBgColor ;
    
    if ([skitType isEqualToString:@"1"]) {//经典  1蓝色
        navBgColor = @"0x609AC5";
    }
    else  if ([skitType isEqualToString:@"2"]) {//经典 2红色
        navBgColor = @"0x73315C";
    }
    else  if ([skitType isEqualToString:@"3"]) {//经典 3褐色
        navBgColor = @"0x7E503C";
    }
    else  if ([skitType isEqualToString:@"4"]) {//经典 4绿色
        navBgColor = @"0x58BEA4";
    }
    else  if ([skitType isEqualToString:@"5"]) {//经典  5褐色
        navBgColor = @"0x662E3E";
    }
    else  if ([skitType isEqualToString:@"6"]) {//经典 6淡蓝色
        navBgColor = @"0x2E647C";
    }
    else  if ([skitType isEqualToString:@"7"]) {//经典 7深蓝
        navBgColor = @"0x3F5658";
    }
    else  if ([skitType isEqualToString:@"8"]) {//经典 8紫色
        navBgColor = @"0x814689";
    }
    else  if ([skitType isEqualToString:@"9"]) {//经典 9深红
        navBgColor = @"0x880506";
    }
    else  if ([skitType isEqualToString:@"10"]) {//经典 10淡灰
        navBgColor = @"0xFF8705";
    }
    else  if ([skitType isEqualToString:@"11"]) {//经典 11橘红
        navBgColor = @"0x8B2B2A";
    }
    else  if ([skitType isEqualToString:@"12"]) {//经典 12星空蓝
        navBgColor = @"0x68A7A0";
    }
    else  if ([skitType isEqualToString:@"13"]) {//经典 13紫色
        navBgColor = @"0x9533DD";
    }
    else  if ([skitType isEqualToString:@"14"]) {//经典 14粉红
        navBgColor = @"0xEFCFDD";
    }
    else  if ([skitType isEqualToString:@"15"]) {//经典 15淡蓝
        navBgColor = @"0x66C6EA";
    }
    else  if ([skitType isEqualToString:@"16"]) {//经典 16淡灰
        navBgColor = @"0x6505E6";
    }
    else  if ([skitType isEqualToString:@"17"]) {//经典 17淡灰
        navBgColor = @"0xFFAF06";
    }
    else  if ([skitType isEqualToString:@"18"]) {//18钻石蓝
        navBgColor = @"0xC1C1C1";
    }
    else  if ([skitType isEqualToString:@"19"]) {//19经典 忧郁蓝
        navBgColor = @"0x4CABFA";
    }
    else  if ([skitType isEqualToString:@"石榴红"]) {//石榴红
        navBgColor = @"0xCC022C";
    }
    else  if ([skitType isEqualToString:@"新年红"]) {//新年红
        navBgColor = @"0xDE1C27";
    }
    else  if ([skitType isEqualToString:@"六合资料"]) {//六合资料
//        navBgColor = @"0x3D80E7";
                navBgColor = @"0x609AC5";
    }
    else {// 默认   经典  1蓝色
        navBgColor = @"0x609AC5";
    }
    return navBgColor;
    
}


-(UIColor *)navbarbgColor:(NSString *)skitType{
    
    UIColor *navBgColor ;
    
    if ([skitType isEqualToString:@"1"]) {//经典  1蓝色
        navBgColor = kUIColorFromRGB(0x609AC5);
    }
    else  if ([skitType isEqualToString:@"2"]) {//经典 2红色
        navBgColor = kUIColorFromRGB(0x73315C);
    }
    else  if ([skitType isEqualToString:@"3"]) {//经典 3褐色
        navBgColor = kUIColorFromRGB(0x7E503C);
    }
    else  if ([skitType isEqualToString:@"4"]) {//经典 4绿色
        navBgColor = kUIColorFromRGB(0x58BEA4);
    }
    else  if ([skitType isEqualToString:@"5"]) {//经典  5褐色
        navBgColor = kUIColorFromRGB(0x662E3E);
    }
    else  if ([skitType isEqualToString:@"6"]) {//经典 6淡蓝色
        navBgColor = kUIColorFromRGB(0x2E647C);
    }
    else  if ([skitType isEqualToString:@"7"]) {//经典 7深蓝
        navBgColor = kUIColorFromRGB(0x3F5658);
    }
    else  if ([skitType isEqualToString:@"8"]) {//经典 8紫色
        navBgColor = kUIColorFromRGB(0x814689);
    }
    else  if ([skitType isEqualToString:@"9"]) {//经典 9深红
        navBgColor = kUIColorFromRGB(0x880506);
    }
    else  if ([skitType isEqualToString:@"10"]) {//经典 10淡灰
        navBgColor = kUIColorFromRGB(0xFF8705);
    }
    else  if ([skitType isEqualToString:@"11"]) {//经典 11橘红
        navBgColor = kUIColorFromRGB(0x8B2B2A);
    }
    else  if ([skitType isEqualToString:@"12"]) {//经典 12星空蓝
        navBgColor = kUIColorFromRGB(0x68A7A0);
    }
    else  if ([skitType isEqualToString:@"13"]) {//经典 13紫色
        navBgColor = kUIColorFromRGB(0x9533DD);
    }
    else  if ([skitType isEqualToString:@"14"]) {//经典 14粉红
        navBgColor = kUIColorFromRGB(0xEFCFDD);
    }
    else  if ([skitType isEqualToString:@"15"]) {//经典 15淡蓝
        navBgColor = kUIColorFromRGB(0x66C6EA);
    }
    else  if ([skitType isEqualToString:@"16"]) {//经典 16淡灰
        navBgColor = kUIColorFromRGB(0x6505E6);
    }
    else  if ([skitType isEqualToString:@"17"]) {//经典 17淡灰
        navBgColor = kUIColorFromRGB(0xFFAF06);
    }
    else  if ([skitType isEqualToString:@"18"]) {//18钻石蓝
        navBgColor = kUIColorFromRGB(0xC1C1C1);
    }
    else  if ([skitType isEqualToString:@"19"]) {//19经典 忧郁蓝
        navBgColor = kUIColorFromRGB(0x4CABFA);
    }
    else  if ([skitType isEqualToString:@"石榴红"]) {//石榴红
        navBgColor = kUIColorFromRGB(0xCC022C);
    }
    else  if ([skitType isEqualToString:@"新年红"]) {//新年红
        navBgColor = kUIColorFromRGB(0xDE1C27);
    }
    else  if ([skitType isEqualToString:@"六合资料"]) {//六合资料
//        navBgColor = kUIColorFromRGB(0x3D80E7);
         navBgColor = kUIColorFromRGB(0x609AC5);
    }
    else {// 默认   经典  1蓝色
        navBgColor = kUIColorFromRGB(0x609AC5);
    }
    return navBgColor;
    
}


-(UIColor *)tabbarbgColor:(NSString *)skitType{
    
    UIColor *tabBgColor ;
    
    if ([skitType isEqualToString:@"1"]) {//经典  1蓝色
        tabBgColor = kUIColorFromRGB(0xC1CBC9);
    }
    else  if ([skitType isEqualToString:@"2"]) {//经典 2红色
        tabBgColor = kUIColorFromRGB(0xDFB9B5);
    }
    else  if ([skitType isEqualToString:@"3"]) {//经典 3褐色
        tabBgColor = kUIColorFromRGB(0xDFC8A1);
    }
    else  if ([skitType isEqualToString:@"4"]) {//经典 4绿色
        tabBgColor = kUIColorFromRGB(0xB6DDB6);
    }
    else  if ([skitType isEqualToString:@"5"]) {//经典  5褐色
        tabBgColor = kUIColorFromRGB(0xFBE0B8);
    }
    else  if ([skitType isEqualToString:@"6"]) {//经典 6淡蓝色
        tabBgColor = kUIColorFromRGB(0xC5EAE7);
    }
    else  if ([skitType isEqualToString:@"7"]) {//经典 7深蓝
        tabBgColor = kUIColorFromRGB(0xABC2B4);
    }
    else  if ([skitType isEqualToString:@"8"]) {//经典 8紫色
        tabBgColor = kUIColorFromRGB(0xD1A4D7);
    }
    else  if ([skitType isEqualToString:@"9"]) {//经典 9深红
        tabBgColor = kUIColorFromRGB(0xDE9595);
    }
    else  if ([skitType isEqualToString:@"10"]) {//经典 10淡灰
        tabBgColor = kUIColorFromRGB(0xFFB666);
    }
    else  if ([skitType isEqualToString:@"11"]) {//经典 11橘红
        tabBgColor = kUIColorFromRGB(0xDC7D6E);
    }
    else  if ([skitType isEqualToString:@"12"]) {//经典 12星空蓝
        tabBgColor = kUIColorFromRGB(0x98BEBB);
    }
    else  if ([skitType isEqualToString:@"13"]) {//经典 13紫色
        tabBgColor = kUIColorFromRGB(0xC367D7);
    }
    else  if ([skitType isEqualToString:@"14"]) {//经典 14粉红
        tabBgColor = kUIColorFromRGB(0xFEC1D5);
    }
    else  if ([skitType isEqualToString:@"15"]) {//经典 15淡蓝
        tabBgColor = kUIColorFromRGB(0x5DC3EB);
    }
    else  if ([skitType isEqualToString:@"16"]) {//经典 16淡灰
        tabBgColor = kUIColorFromRGB(0xA766F7);
    }
    else  if ([skitType isEqualToString:@"17"]) {//经典 17淡灰
        tabBgColor = kUIColorFromRGB(0xFFE066);
    }
    else  if ([skitType isEqualToString:@"18"]) {//18钻石蓝
        tabBgColor = kUIColorFromRGB(0xD9D9D9);
    }
    else  if ([skitType isEqualToString:@"19"]) {//19经典 忧郁蓝
        tabBgColor = kUIColorFromRGB(0x8CB9F4);
    }
    else  if ([skitType isEqualToString:@"石榴红"]) {//石榴红
//        tabBgColor = kUIColorFromRGB(0xF8F8F8);0xCC022C
        tabBgColor = kUIColorFromRGB(0xCC022C);
    }
    else  if ([skitType isEqualToString:@"新年红"]) {//新年红
        tabBgColor = kUIColorFromRGB(0xDE1C27);
    }
    else  if ([skitType isEqualToString:@"六合资料"]) {//六合资料
//        tabBgColor = kUIColorFromRGB(0xFFFFFF);
         tabBgColor = kUIColorFromRGB(0xC1CBC9);
    }
    else {//默认 经典  1蓝色
        tabBgColor = kUIColorFromRGB(0xC1CBC9);
    }
    return tabBgColor;
    
}



-(UIColor *)bgColor:(NSString *)skitType{
    
    UIColor *bgColor ;
    
    if ([skitType isEqualToString:@"1"]) {//经典  1蓝色
         UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0x7F9493),kUIColorFromRGB(0x5389B3)] andGradientType:GradientDirectionLeftToRight];
         bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"2"]) {//经典 2红色
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0xd19885),kUIColorFromRGB(0x904a6e)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"3"]) {//经典 3褐色
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0xB48A46),kUIColorFromRGB(0x8A5C3E)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"4"]) {//经典 4绿色
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0x78BC67),kUIColorFromRGB(0x4DB48B)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"5"]) {//经典  5褐色
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0x913D3E),kUIColorFromRGB(0xEAAD72)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"6"]) {//经典 6淡蓝色
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0x61A8B4),kUIColorFromRGB(0xC7F3E5)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"7"]) {//经典 7深蓝
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0x486869),kUIColorFromRGB(0x436363)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
        
    }
    else  if ([skitType isEqualToString:@"8"]) {//经典 8紫色
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0x934FB4),kUIColorFromRGB(0x9146A0)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"9"]) {//经典 9深红
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0x871113),kUIColorFromRGB(0x871B1F)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
        
    }
    else  if ([skitType isEqualToString:@"10"]) {//经典 10淡灰
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0xFC7008),kUIColorFromRGB(0xFC7008)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"11"]) {//经典 11橘红
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0xB52A18),kUIColorFromRGB(0x8F1115)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"12"]) {//经典 12星空蓝
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0x008CAC),kUIColorFromRGB(0x00A9CA)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
        
    }
    else  if ([skitType isEqualToString:@"13"]) {//经典 13紫色
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0x9800B7),kUIColorFromRGB(0x46D8D6)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
        
    }
    else  if ([skitType isEqualToString:@"14"]) {//经典 14粉红
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0xFFBED4),kUIColorFromRGB(0xFEC1D5)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"15"]) {//经典 15淡蓝
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0x4CAEDC),kUIColorFromRGB(0x5DC3EB)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"16"]) {//经典 16淡灰
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0x4300DA),kUIColorFromRGB(0x5800EE)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"17"]) {//经典 17淡灰
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0xFECC0A),kUIColorFromRGB(0xFE9C08)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
        
    }
    else  if ([skitType isEqualToString:@"18"]) {//18钻石蓝
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0xB3B3B3),kUIColorFromRGB(0xB3B3B3)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"19"]) {//19经典 忧郁蓝
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0x00B2FF),kUIColorFromRGB(0x005ED6)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"石榴红"]) {//石榴红
        bgColor = kUIColorFromRGB(0xFFFFFF);
    }
    else  if ([skitType isEqualToString:@"新年红"]) {//新年红
        bgColor = kUIColorFromRGB(0xFFFFFF);
    }
    else  if ([skitType isEqualToString:@"六合资料"]) {//六合资料
//        bgColor = kUIColorFromRGB(0xFFFFFF);
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0x7F9493),kUIColorFromRGB(0x5389B3)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  {//默认 经典  1蓝色
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0x7F9493),kUIColorFromRGB(0x5389B3)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    return bgColor;
    
}

-(UIColor *)signbgColor:(NSString *)skitType{
    
    UIColor *bgColor ;
    
    if ([skitType isEqualToString:@"1"]) {//经典  1蓝色
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0x7F9493),kUIColorFromRGB(0x5389B3)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"2"]) {//经典 2红色
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0xd19885),kUIColorFromRGB(0x904a6e)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"3"]) {//经典 3褐色
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0xB48A46),kUIColorFromRGB(0x8A5C3E)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"4"]) {//经典 4绿色
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0x78BC67),kUIColorFromRGB(0x4DB48B)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"5"]) {//经典  5褐色
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0x913D3E),kUIColorFromRGB(0xEAAD72)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"6"]) {//经典 6淡蓝色
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0x61A8B4),kUIColorFromRGB(0xC7F3E5)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"7"]) {//经典 7深蓝
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0x486869),kUIColorFromRGB(0x436363)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
        
    }
    else  if ([skitType isEqualToString:@"8"]) {//经典 8紫色
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0x934FB4),kUIColorFromRGB(0x9146A0)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"9"]) {//经典 9深红
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0x871113),kUIColorFromRGB(0x871B1F)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
        
    }
    else  if ([skitType isEqualToString:@"10"]) {//经典 10淡灰
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0xFC7008),kUIColorFromRGB(0xFC7008)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"11"]) {//经典 11橘红
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0xB52A18),kUIColorFromRGB(0x8F1115)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"12"]) {//经典 12星空蓝
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0x008CAC),kUIColorFromRGB(0x00A9CA)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
        
    }
    else  if ([skitType isEqualToString:@"13"]) {//经典 13紫色
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0x9800B7),kUIColorFromRGB(0x46D8D6)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
        
    }
    else  if ([skitType isEqualToString:@"14"]) {//经典 14粉红
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0xFFBED4),kUIColorFromRGB(0xFEC1D5)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"15"]) {//经典 15淡蓝
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0x4CAEDC),kUIColorFromRGB(0x5DC3EB)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"16"]) {//经典 16淡灰
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0x4300DA),kUIColorFromRGB(0x5800EE)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"17"]) {//经典 17淡灰
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0xFECC0A),kUIColorFromRGB(0xFE9C08)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
        
    }
    else  if ([skitType isEqualToString:@"18"]) {//18钻石蓝
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0xB3B3B3),kUIColorFromRGB(0xB3B3B3)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"19"]) {//19经典 忧郁蓝
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0x00B2FF),kUIColorFromRGB(0x005ED6)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"石榴红"]) {//石榴红
        bgColor = kUIColorFromRGB(0xFFFFFF);
    }
    else  if ([skitType isEqualToString:@"新年红"]) {//新年红
        bgColor = kUIColorFromRGB(0xFFFFFF);
    }
    else  if ([skitType isEqualToString:@"六合资料"]) {//六合资料
//        bgColor = kUIColorFromRGB(0x3D80E7);
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0x7F9493),kUIColorFromRGB(0x5389B3)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else {//默认 经典  1蓝色
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0x7F9493),kUIColorFromRGB(0x5389B3)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    return bgColor;
    
}




-(UIColor *)mineProgressViewColor:(NSString *)skitType{
    
    UIColor *bgColor ;
    
    if ([skitType isEqualToString:@"1"]) {//经典  1蓝色
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0xd80000),kUIColorFromRGB(0xfb5959)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"2"]) {//经典 2红色
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0xd80000),kUIColorFromRGB(0xfb5959)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"3"]) {//经典 3褐色
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0xd80000),kUIColorFromRGB(0xfb5959)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"4"]) {//经典 4绿色
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0xd80000),kUIColorFromRGB(0xfb5959)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"5"]) {//经典  5褐色
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0xd80000),kUIColorFromRGB(0xfb5959)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"6"]) {//经典 6淡蓝色
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0xd80000),kUIColorFromRGB(0xfb5959)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"7"]) {//经典 7深蓝
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0xd80000),kUIColorFromRGB(0xfb5959)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
        
    }
    else  if ([skitType isEqualToString:@"8"]) {//经典 8紫色
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0xd80000),kUIColorFromRGB(0xfb5959)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"9"]) {//经典 9深红
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0xd80000),kUIColorFromRGB(0xfb5959)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
        
    }
    else  if ([skitType isEqualToString:@"10"]) {//经典 10淡灰
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0xd80000),kUIColorFromRGB(0xfb5959)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"11"]) {//经典 11橘红
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0xd80000),kUIColorFromRGB(0xfb5959)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"12"]) {//经典 12星空蓝
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0xd80000),kUIColorFromRGB(0xfb5959)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
        
    }
    else  if ([skitType isEqualToString:@"13"]) {//经典 13紫色
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0xd80000),kUIColorFromRGB(0xfb5959)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"14"]) {//经典 14粉红
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0xd80000),kUIColorFromRGB(0xfb5959)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"15"]) {//经典 15淡蓝
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0xd80000),kUIColorFromRGB(0xfb5959)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"16"]) {//经典 16淡灰
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0xd80000),kUIColorFromRGB(0xfb5959)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"17"]) {//经典 17淡灰
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0xd80000),kUIColorFromRGB(0xfb5959)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
        
    }
    else  if ([skitType isEqualToString:@"18"]) {//18钻石蓝
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0xd80000),kUIColorFromRGB(0xfb5959)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"19"]) {//19经典 忧郁蓝
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0xd80000),kUIColorFromRGB(0xfb5959)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"石榴红"]) {//石榴红
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0xFEC434),kUIColorFromRGB(0xFE8A23)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"新年红"]) {//新年红
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0xFEC434),kUIColorFromRGB(0xFE8A23)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"六合资料"]) {//六合资料
//        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0xFEC434),kUIColorFromRGB(0xFE8A23)] andGradientType:GradientDirectionLeftToRight];
//        bgColor = [UIColor colorWithPatternImage:backImage];
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0xd80000),kUIColorFromRGB(0xfb5959)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else {//默认 经典  1蓝色
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0xd80000),kUIColorFromRGB(0xfb5959)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    return bgColor;
    
}


-(UIColor *)menuHeadViewColor:(NSString *)skitType{
    
    UIColor *bgColor ;
    
    if ([skitType isEqualToString:@"1"]) {//经典  1蓝色
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0x5f9bc6),kUIColorFromRGB(0xfb5959)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"2"]) {//经典 2红色
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0xbf338e),kUIColorFromRGB(0xfb95db)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"3"]) {//经典 3褐色
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0xbf7555),kUIColorFromRGB(0xfefb398)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"4"]) {//经典 4绿色
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0x49a791),kUIColorFromRGB(0x7cead3)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"5"]) {//经典  5褐色
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0xa06577),kUIColorFromRGB(0xf1adc4)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"6"]) {//经典 6淡蓝色
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0x4c91a9),kUIColorFromRGB(0x85d2ec)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"7"]) {//经典 7深蓝
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0x65898c),kUIColorFromRGB(0x9fd3d8)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
        
    }
    else  if ([skitType isEqualToString:@"8"]) {//经典 8紫色
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0xc161c3),kUIColorFromRGB(0xf889fb)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"9"]) {//经典 9深红
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0xc30808),kUIColorFromRGB(0xf98080)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
        
    }
    else  if ([skitType isEqualToString:@"10"]) {//经典 10淡灰
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0xffa33f),kUIColorFromRGB(0xfbd2a5)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"11"]) {//经典 11橘红
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0xd24040),kUIColorFromRGB(0xdc9191)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"12"]) {//经典 12星空蓝
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0x22667b),kUIColorFromRGB(0x5fc5e2)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
        
    }
    else  if ([skitType isEqualToString:@"13"]) {//经典 13紫色
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0xaa83e8),kUIColorFromRGB(0xdbc5ff)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"14"]) {//经典 14粉红
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0xe499b0),kUIColorFromRGB(0xfecfdd)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"15"]) {//经典 15淡蓝
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0x5ebee5),kUIColorFromRGB(0xaddef3)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"16"]) {//经典 16淡灰
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0x9041fd),kUIColorFromRGB(0xc19bf5)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"17"]) {//经典 17淡灰
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0xffc344),kUIColorFromRGB(0xffe1a2)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
        
    }
    else  if ([skitType isEqualToString:@"18"]) {//18钻石蓝
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0xc1c1c1),kUIColorFromRGB(0xececec)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"19"]) {//19经典 忧郁蓝
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0x4ba2fa),kUIColorFromRGB(0x64d0ef)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"石榴红"]) {//石榴红
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0xd7213a),kUIColorFromRGB(0xf99695)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"新年红"]) {//新年红
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0xe63534),kUIColorFromRGB(0xf99695)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else  if ([skitType isEqualToString:@"六合资料"]) {//六合资料
//        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0x3D80E7),kUIColorFromRGB(0x3D80E7)] andGradientType:GradientDirectionLeftToRight];
//        bgColor = [UIColor colorWithPatternImage:backImage];
        
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0x5f9bc6),kUIColorFromRGB(0xfb5959)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    else {//默认 经典  1蓝色
        UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0x5f9bc6),kUIColorFromRGB(0xfb5959)] andGradientType:GradientDirectionLeftToRight];
        bgColor = [UIColor colorWithPatternImage:backImage];
    }
    return bgColor;
    
}

-(UIColor *)cellbgColor:(NSString *)skitType{
    
    UIColor *tabBgColor ;
    
    if ([skitType isEqualToString:@"1"]) {//经典  1蓝色
        tabBgColor = kUIColorFromRGB(0xC1CBC9);
    }
    else  if ([skitType isEqualToString:@"2"]) {//经典 2红色
        tabBgColor = kUIColorFromRGB(0xDFB9B5);
    }
    else  if ([skitType isEqualToString:@"3"]) {//经典 3褐色
        tabBgColor = kUIColorFromRGB(0xDFC8A1);
    }
    else  if ([skitType isEqualToString:@"4"]) {//经典 4绿色
        tabBgColor = kUIColorFromRGB(0xB6DDB6);
    }
    else  if ([skitType isEqualToString:@"5"]) {//经典  5褐色
        tabBgColor = kUIColorFromRGB(0xF7E2C0);
    }
    else  if ([skitType isEqualToString:@"6"]) {//经典 6淡蓝色
        tabBgColor = kUIColorFromRGB(0xC5EAE7);
    }
    else  if ([skitType isEqualToString:@"7"]) {//经典 7深蓝
        tabBgColor = kUIColorFromRGB(0xABC2B4);
    }
    else  if ([skitType isEqualToString:@"8"]) {//经典 8紫色
        tabBgColor = kUIColorFromRGB(0xD1A4D7);
    }
    else  if ([skitType isEqualToString:@"9"]) {//经典 9深红
        tabBgColor = kUIColorFromRGB(0xD1A4D7);
    }
    else  if ([skitType isEqualToString:@"10"]) {//经典 10淡灰
        tabBgColor = kUIColorFromRGB(0xFFB666);
    }
    else  if ([skitType isEqualToString:@"11"]) {//经典 11橘红
        tabBgColor = kUIColorFromRGB(0xDC7D6E);
    }
    else  if ([skitType isEqualToString:@"12"]) {//经典 12星空蓝
        tabBgColor = kUIColorFromRGB(0x98BEBB);
    }
    else  if ([skitType isEqualToString:@"13"]) {//经典 13紫色
        tabBgColor = kUIColorFromRGB(0xC367D7);
    }
    else  if ([skitType isEqualToString:@"14"]) {//经典 14粉红
        tabBgColor = kUIColorFromRGB(0xFEC1D5);
    }
    else  if ([skitType isEqualToString:@"15"]) {//经典 15淡蓝
        tabBgColor = kUIColorFromRGB(0x5DC3EB);
    }
    else  if ([skitType isEqualToString:@"16"]) {//经典 16淡灰
        tabBgColor = kUIColorFromRGB(0xA766F7);
    }
    else  if ([skitType isEqualToString:@"17"]) {//经典 17淡灰
        tabBgColor = kUIColorFromRGB(0xFFE066);
    }
    else  if ([skitType isEqualToString:@"18"]) {//18钻石蓝
        tabBgColor = kUIColorFromRGB(0xD9D9D9);
    }
    else  if ([skitType isEqualToString:@"19"]) {//19经典 忧郁蓝
        tabBgColor = kUIColorFromRGB(0x8CB9F4);
    }
    else  if ([skitType isEqualToString:@"石榴红"]) {//石榴红
        //        tabBgColor = kUIColorFromRGB(0xF8F8F8);0xCC022C
        tabBgColor = [UIColor whiteColor];
    }
    else  if ([skitType isEqualToString:@"新年红"]) {//新年红
        tabBgColor = [UIColor whiteColor];
    }
    else  if ([skitType isEqualToString:@"六合资料"]) {//六合资料
//        tabBgColor = [UIColor whiteColor];
         tabBgColor = kUIColorFromRGB(0xC1CBC9);
    }
    else {//默认 经典  1蓝色
        tabBgColor = kUIColorFromRGB(0xC1CBC9);
    }
    return tabBgColor;
    
}

//首页的内容：cell，广告条，长龙，彩票
-(UIColor *)homeContentColor:(NSString *)skitType{
    
    UIColor *contentColor ;
    
    if ([skitType isEqualToString:@"1"]) {//经典  1蓝色
        contentColor = kUIColorFromRGB(0xb2cde0);
    }
    else  if ([skitType isEqualToString:@"2"]) {//经典 2红色
        contentColor = kUIColorFromRGB(0xd0aeb7);
    }
    else  if ([skitType isEqualToString:@"3"]) {//经典 3褐色
        contentColor = kUIColorFromRGB(0xd2bea6);
    }
    else  if ([skitType isEqualToString:@"4"]) {//经典 4绿色
        contentColor = kUIColorFromRGB(0xc4e5c7);
    }
    else  if ([skitType isEqualToString:@"5"]) {//经典  5褐色
        contentColor = kUIColorFromRGB(0xc1a8aa);
    }
    else  if ([skitType isEqualToString:@"6"]) {//经典 6淡蓝色
        contentColor = kUIColorFromRGB(0xc1e1e6);
    }
    else  if ([skitType isEqualToString:@"7"]) {//经典 7深蓝
        contentColor = kUIColorFromRGB(0xacbdbe);
    }
    else  if ([skitType isEqualToString:@"8"]) {//经典 8紫色
        contentColor = kUIColorFromRGB(0xd7b6e3);
    }
    else  if ([skitType isEqualToString:@"9"]) {//经典 9深红
        contentColor = kUIColorFromRGB(0xcd908d);
    }
    else  if ([skitType isEqualToString:@"10"]) {//经典 10淡灰
        contentColor = kUIColorFromRGB(0xffc280);
    }
    else  if ([skitType isEqualToString:@"11"]) {//经典 11橘红
        contentColor = kUIColorFromRGB(0xdba497);
    }
    else  if ([skitType isEqualToString:@"12"]) {//经典 12星空蓝
        contentColor = kUIColorFromRGB(0xade5ed);
    }
    else  if ([skitType isEqualToString:@"13"]) {//经典 13紫色
        contentColor = kUIColorFromRGB(0xccadee);
    }
    else  if ([skitType isEqualToString:@"14"]) {//经典 14粉红
        contentColor = kUIColorFromRGB(0xffe7ee);
    }
    else  if ([skitType isEqualToString:@"15"]) {//经典 15淡蓝
        contentColor = kUIColorFromRGB(0xb1e2f3);
    }
    else  if ([skitType isEqualToString:@"16"]) {//经典 16淡灰
        contentColor = kUIColorFromRGB(0xb680f8);
    }
    else  if ([skitType isEqualToString:@"17"]) {//经典 17淡灰
        contentColor = kUIColorFromRGB(0xffe280);
    }
    else  if ([skitType isEqualToString:@"18"]) {//18钻石蓝
        contentColor = kUIColorFromRGB(0xe0e0e0);
    }
    else  if ([skitType isEqualToString:@"19"]) {//19经典 忧郁蓝
        contentColor = kUIColorFromRGB(0xa1ccff);
    }
    else  if ([skitType isEqualToString:@"石榴红"]) {//石榴红
        //        tabBgColor = kUIColorFromRGB(0xF8F8F8);0xCC022C
        contentColor = [UIColor whiteColor];
    }
    else  if ([skitType isEqualToString:@"新年红"]) {//新年红
        contentColor = [UIColor whiteColor];
    }
    else  if ([skitType isEqualToString:@"六合资料"]) {//六合资料
//        contentColor = [UIColor whiteColor];
          contentColor = kUIColorFromRGB(0xb2cde0);
    }
    else {//默认 经典  1蓝色
        contentColor = kUIColorFromRGB(0xb2cde0);
    }
    return contentColor;
    
}


//首页的内容：cell，广告条，长龙，彩票
-(UIColor *)homeContentBorderColor:(NSString *)skitType{
    
    UIColor *contentColor ;
    
    if ([skitType isEqualToString:@"1"]) {//经典  1蓝色
        contentColor = kUIColorFromRGB(0xb2cde0);
    }
    else  if ([skitType isEqualToString:@"2"]) {//经典 2红色
        contentColor = kUIColorFromRGB(0xd0aeb7);
    }
    else  if ([skitType isEqualToString:@"3"]) {//经典 3褐色
        contentColor = kUIColorFromRGB(0xd2bea6);
    }
    else  if ([skitType isEqualToString:@"4"]) {//经典 4绿色
        contentColor = kUIColorFromRGB(0xc4e5c7);
    }
    else  if ([skitType isEqualToString:@"5"]) {//经典  5褐色
        contentColor = kUIColorFromRGB(0xc1a8aa);
    }
    else  if ([skitType isEqualToString:@"6"]) {//经典 6淡蓝色
        contentColor = kUIColorFromRGB(0xc1e1e6);
    }
    else  if ([skitType isEqualToString:@"7"]) {//经典 7深蓝
        contentColor = kUIColorFromRGB(0xacbdbe);
    }
    else  if ([skitType isEqualToString:@"8"]) {//经典 8紫色
        contentColor = kUIColorFromRGB(0xd7b6e3);
    }
    else  if ([skitType isEqualToString:@"9"]) {//经典 9深红
        contentColor = kUIColorFromRGB(0xcd908d);
    }
    else  if ([skitType isEqualToString:@"10"]) {//经典 10淡灰
        contentColor = kUIColorFromRGB(0xffc280);
    }
    else  if ([skitType isEqualToString:@"11"]) {//经典 11橘红
        contentColor = kUIColorFromRGB(0xdba497);
    }
    else  if ([skitType isEqualToString:@"12"]) {//经典 12星空蓝
        contentColor = kUIColorFromRGB(0xade5ed);
    }
    else  if ([skitType isEqualToString:@"13"]) {//经典 13紫色
        contentColor = kUIColorFromRGB(0xccadee);
    }
    else  if ([skitType isEqualToString:@"14"]) {//经典 14粉红
        contentColor = kUIColorFromRGB(0xffe7ee);
    }
    else  if ([skitType isEqualToString:@"15"]) {//经典 15淡蓝
        contentColor = kUIColorFromRGB(0xb1e2f3);
    }
    else  if ([skitType isEqualToString:@"16"]) {//经典 16淡灰
        contentColor = kUIColorFromRGB(0xb680f8);
    }
    else  if ([skitType isEqualToString:@"17"]) {//经典 17淡灰
        contentColor = kUIColorFromRGB(0xffe280);
    }
    else  if ([skitType isEqualToString:@"18"]) {//18钻石蓝
        contentColor = kUIColorFromRGB(0xe0e0e0);
    }
    else  if ([skitType isEqualToString:@"19"]) {//19经典 忧郁蓝
        contentColor = kUIColorFromRGB(0xa1ccff);
    }
    else  if ([skitType isEqualToString:@"石榴红"]) {//石榴红
        //        tabBgColor = kUIColorFromRGB(0xF8F8F8);0xCC022C
        contentColor = RGBA(231, 230, 230, 1);
    }
    else  if ([skitType isEqualToString:@"新年红"]) {//新年红
        contentColor = RGBA(231, 230, 230, 1);
    }
    else  if ([skitType isEqualToString:@"六合资料"]) {//六合资料
//        contentColor = kUIColorFromRGB(0x3D80E7);
        contentColor = kUIColorFromRGB(0xb2cde0);
    }
    else  {//默认 经典  1蓝色
        contentColor = kUIColorFromRGB(0xb2cde0);
    }
    return contentColor;
    
}


-(void)resetNavbarAndTabBarBgColor:(NSString *)skitType{
    
    [[UITabBar appearance] setBackgroundImage:[UIImage imageWithColor:[self tabbarbgColor :skitType]]];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[[UGSkinManagers shareInstance] settabNOSelectColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:                                                         [NSDictionary dictionaryWithObjectsAndKeys: [[UGSkinManagers shareInstance] settabSelectColor],NSForegroundColorAttributeName, nil]forState:UIControlStateSelected];

    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[[UGSkinManagers shareInstance] settabNOSelectColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:                                                         [NSDictionary dictionaryWithObjectsAndKeys: [[UGSkinManagers shareInstance] settabSelectColor],NSForegroundColorAttributeName, nil]forState:UIControlStateSelected];
    
    UGTabbarController *tabbar = TabBarController1;
    [tabbar.tabBar setBackgroundImage:[UIImage imageWithColor:[self tabbarbgColor :skitType]]];
     
     [tabbar.tabBar setSelectedImageTintColor: [[UGSkinManagers shareInstance] settabSelectColor]];
     
     [tabbar.tabBar setUnselectedItemTintColor: [[UGSkinManagers shareInstance] settabNOSelectColor]];
    
    for (UIBarItem *item in tabbar.tabBar.items) {
        [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                      [[UGSkinManagers shareInstance] settabNOSelectColor], NSForegroundColorAttributeName, nil]
                            forState:UIControlStateNormal];
        [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                      [[UGSkinManagers shareInstance] settabSelectColor],NSForegroundColorAttributeName, nil]
                            forState:UIControlStateSelected];
    }
    



    if (@available(iOS 13.0, *)) {
        for (UGNavigationController *nav in TabBarController1.viewControllers) {
            
            [self navigationBar:nav bgColor:[self navbarbgColor:skitType]];
            
            
            UIView *stateView = [nav.navigationBar viewWithTagString:@"状态栏背景View"];
            if (!stateView) {
                stateView = [[UIView alloc] initWithFrame:CGRectMake(0, -k_Height_StatusBar, UGScreenW, k_Height_StatusBar)];
                stateView.tagString = @"状态栏背景View";
                [nav.navigationBar addSubview:stateView];
            }
            stateView.backgroundColor = [self navbarbgColor:skitType];
        }
    }
    else {
        //   bug: iOS13 崩溃
        UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
        if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
            statusBar.backgroundColor = [self navbarbgColor:skitType];
        }
    }
}

-(void)navigationBarBgColor:(UGNavigationController *)nav  BgColor:(NSString *)skitType{
    
}


-(void)navigationBar:(UGNavigationController *)nav bgColor:(UIColor *)bgColor{
    nav.navigationBar.backgroundColor = bgColor;
    [nav.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    nav.navigationBar.shadowImage = [UIImage new];
}


-(UIColor *)tabSelectColor:(NSString *)skitType{
    
    UIColor *bgColor ;
    
 
   if ([skitType isEqualToString:@"石榴红"]) {//石榴红
         bgColor = [UIColor yellowColor];
    }
    else  if ([skitType isEqualToString:@"新年红"]) {//新年红
        bgColor = [UIColor yellowColor];
    }
    else  if ([skitType isEqualToString:@"六合资料"]) {//六合资料
        bgColor = kUIColorFromRGB(0x3D80E7);
    }
    else  {//
        bgColor = [UIColor whiteColor];
    }
    return bgColor;
    
}

-(UIColor *)tabNOSelectColor:(NSString *)skitType{
    
    UIColor *bgColor ;
    
    
    if ([skitType isEqualToString:@"石榴红"]) {//石榴红
       bgColor = [UIColor whiteColor];
    }
    else  if ([skitType isEqualToString:@"新年红"]) {//新年红
        bgColor = [UIColor whiteColor];
    }
    else  if ([skitType isEqualToString:@"六合资料"]) {//六合资料
        bgColor = [UIColor grayColor];
    }
    else  {//
        bgColor = [UIColor grayColor];
    }
    return bgColor;
    
}


-(NSString *)conversionSkitType{
    
//    mobileTemplateCategory = “2”,==>新年红
//    mobileTemplateCategory = “3”,==>石榴红
//    mobileTemplateCategory = “0”,==>经典
    
//    mobileTemplateBackground == “19”
    NSString *skitType = @"";
    
     UGSystemConfigModel *config = [UGSystemConfigModel currentConfig];
    if ([config.mobileTemplateCategory isEqualToString:@"0"]) {
        skitType = config.mobileTemplateBackground;
    }
    else if([config.mobileTemplateCategory isEqualToString:@"2"]) {
        skitType = @"新年红";
    }
    else if([config.mobileTemplateCategory isEqualToString:@"3"]) {
        skitType = @"石榴红";
    }
    else if([config.mobileTemplateCategory isEqualToString:@"4"]) {
//        skitType = @"六合资料";
        skitType = config.mobileTemplateBackground;
    }
    else{
        skitType = @"新年红";
    }
    return skitType;
}

-(NSString *)skitType{

    NSString *skitType = @"";
    
    UGSystemConfigModel *config = [UGSystemConfigModel currentConfig];
    if ([config.mobileTemplateCategory isEqualToString:@"0"]) {
        skitType = @"经典";
    }
    else if([config.mobileTemplateCategory isEqualToString:@"2"]) {
        skitType = @"新年红";
    }
    else if([config.mobileTemplateCategory isEqualToString:@"3"]) {
        skitType = @"石榴红";
    }
    else if([config.mobileTemplateCategory isEqualToString:@"4"]) {
        skitType = @"六合资料";
    }
    else{
        skitType = @"新年红";
    }
    
    return skitType;
}

-(void)setNavbarAndTabarSkin{
     [self resetNavbarAndTabBarBgColor:[self conversionSkitType]];
}

-(void)setSkin {
    [self setNavbarAndTabarSkin];
    SANotificationEventPost(UGNotificationWithSkinSuccess, nil);
}

-(UIColor *)setTabbgColor{
    return [self tabbarbgColor:[self conversionSkitType]];
}

-(UIColor *)setNavbgColor{
    return [self navbarbgColor:[self conversionSkitType]];
}

-(UIColor *)setbgColor{
    return [self bgColor:[self conversionSkitType]];
}

-(UIColor *)setSignbgColor{
    return [self signbgColor:[self conversionSkitType]];
}

-(UIColor *)settabNOSelectColor{
    return [self tabNOSelectColor:[self conversionSkitType]];
}

-(UIColor *)settabSelectColor{
    return [self tabSelectColor:[self conversionSkitType]];
}

-(UIColor *)setCellbgColor{
    return [self cellbgColor:[self conversionSkitType]];
}

-(UIColor *)sethomeContentColor{
    return [self homeContentColor:[self conversionSkitType]];
}

-(UIColor *)sethomeContentBorderColor{
    return [self homeContentBorderColor:[self conversionSkitType]];
}

-(NSString *)setNavbgStringColor{
    return [self navbarbgColorString:[self conversionSkitType]];
}

-(UIColor *)setMineProgressViewColor{
    
     return [self mineProgressViewColor:[self conversionSkitType]];
}

-(UIColor *)setMenuHeadViewColor{
    
    return [self menuHeadViewColor:[self conversionSkitType]];
}

-(NSString *)setChatNavbgStringColor{
    
    NSString *str = [self navbarbgColorString:[self conversionSkitType]];
    //先以16为参数告诉strtoul字符串参数表示16进制数字，然后使用0x%X转为数字类型 16进制转10进制
//    unsigned long red = strtoul([str UTF8String],0,16);
    
    NSString * subString2 = [str substringFromIndex:2];
    NSLog(@"%@", subString2);
    return subString2;
}
@end

@implementation UGSkinManagers (ThemeColor)

static NSArray<UIColor *> *themeColors = nil;

+ (UIColor *)randomThemeColor {
    if (!themeColors) {
        themeColors = @[
                        UIColorTheme1,
                        UIColorTheme2,
                        UIColorTheme3,
                        UIColorTheme4,
                        UIColorTheme5,
                        UIColorTheme6,
                        UIColorTheme7,
                        UIColorTheme8,
                        UIColorTheme9,
                        UIColorTheme10];
    }
    return themeColors[arc4random() % themeColors.count];
}

@end
