//
//  UGSkinManagers.m
//  abcc4
//
//  Created by fish on 2019/11/1.
//  Copyright © 2019 fish. All rights reserved.
//

#import "UGSkinManagers.h"

#define SkinAlpha 0.99


@implementation UGSkinManagers

static NSPointerArray *__viewPointers = nil;
static UGSkinManagers *__currentSkin1 = nil;
static UGSkinManagers *__lastSkin1 = nil;


#pragma mark - 换肤核心逻辑

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSString *(^colorNameWithColor)(UIColor *) = ^NSString *(UIColor *c1) {
            for (NSString *colorName in [UGSkinManagers propertyList]) {
                if ([colorName.lowercaseString containsString:@"color"]) {
                    UIColor *c2 = [__lastSkin1 valueForKey:colorName];
                    if ([c1 isEqualToColor:c2]) {
                        return colorName;
                    }
                }
            }
            return nil;
        };
        
        // 获取SkinColor
        UIColor *(^getSkinColor)(UIColor *) = ^UIColor *(UIColor *c) {
            if (c.alpha == SkinAlpha) {
                return [__currentSkin1 performSelector:colorNameWithColor(c).UTF8String];
            }
            return nil;
        };
        
        // 如果是SkinColor，就把【对象、函数、色彩类型】保存起来，换肤时遍历一遍修改颜色
        {
            // 处理UIColor类型
            void (^block1)(id<AspectInfo>) = ^(id<AspectInfo> ai) {
                UIColor *c = ai.arguments.firstObject;
                NSString *colorName = c.cc_userInfo[@"colorName"];
                NSInvocation *invocation = ai.originalInvocation;
                if (colorName.length) {
                    if (![__viewPointers.allObjects containsObject:ai.instance]) {
                        [__viewPointers addPointer:(__bridge void * _Nullable)(ai.instance)];
                    }
                    if (OBJOnceToken(ai.instance)) {
                        [ai.instance cc_userInfo][@"SkinBlocks"] = @{}.mutableCopy;
                    }
                    [ai.instance cc_userInfo][@"SkinBlocks"][NSStringFromSelector(invocation.selector)] = ^{
                        UIColor *c = [__currentSkin1 performSelector:colorName.UTF8String];
                        [invocation setArgument:&c atIndex:2];
                        [invocation invoke];
                    };
                } else {
                    [ai.instance cc_userInfo][@"SkinBlocks"][NSStringFromSelector(invocation.selector)] = nil;
                }
                [ai.originalInvocation invoke];
            };
            [UIView aspect_hookSelector:@selector(setBackgroundColor:) withOptions:AspectPositionInstead usingBlock:block1 error:nil];
            [UIView aspect_hookSelector:@selector(setTintColor:) withOptions:AspectPositionInstead usingBlock:block1 error:nil];
            [UILabel aspect_hookSelector:@selector(setTextColor:) withOptions:AspectPositionInstead usingBlock:block1 error:nil];
            [UITextField aspect_hookSelector:@selector(setTextColor:) withOptions:AspectPositionInstead usingBlock:block1 error:nil];
            [UITextView aspect_hookSelector:@selector(setTextColor:) withOptions:AspectPositionInstead usingBlock:block1 error:nil];
            [UIButton aspect_hookSelector:@selector(setTitleColor:forState:) withOptions:AspectPositionInstead usingBlock:block1 error:nil];
            [UIButton aspect_hookSelector:@selector(setTitleShadowColor:forState:) withOptions:AspectPositionInstead usingBlock:block1 error:nil];
            [UITabBar aspect_hookSelector:@selector(setUnselectedItemTintColor:) withOptions:AspectPositionInstead usingBlock:block1 error:nil];
            [UITabBar aspect_hookSelector:@selector(setSelectedImageTintColor:) withOptions:AspectPositionInstead usingBlock:block1 error:nil];
            [UITabBar aspect_hookSelector:@selector(setBarTintColor:) withOptions:AspectPositionInstead usingBlock:block1 error:nil];
            [UINavigationBar aspect_hookSelector:@selector(setBarTintColor:) withOptions:AspectPositionInstead usingBlock:block1 error:nil];

            
            // 处理CGColorRef类型（描边色）
            void (^block2)(id<AspectInfo>) = ^(id<AspectInfo> ai) {
                CGColorRef cr = [ai.arguments.firstObject CGColorValue];
                NSInvocation *invocation = ai.originalInvocation;
                if (CGColorGetAlpha(cr) == SkinAlpha) {
                    NSString *colorName = colorNameWithColor([UIColor colorWithCGColor:cr]);

                    if (![__viewPointers.allObjects containsObject:ai.instance]) {
                        [__viewPointers addPointer:(__bridge void * _Nullable)(ai.instance)];
                    }
                    if (OBJOnceToken(ai.instance)) {
                        [ai.instance cc_userInfo][@"SkinBlocks"] = @{}.mutableCopy;
                    }
                    [ai.instance cc_userInfo][@"SkinBlocks"][NSStringFromSelector(invocation.selector)] = ^{
                        UIColor *c = [__currentSkin1 performSelector:colorName.UTF8String];
                        CGColorRef cr = c.CGColor;
                        [invocation setArgument:&cr atIndex:2];
                        [invocation invoke];
                    };
                } else {
                    [ai.instance cc_userInfo][@"SkinBlocks"][NSStringFromSelector(invocation.selector)] = nil;
                }
                [ai.originalInvocation invoke];
            };
            [CALayer aspect_hookSelector:@selector(setBorderColor:) withOptions:AspectPositionInstead usingBlock:block2 error:nil];
            [CALayer aspect_hookSelector:@selector(setBackgroundColor:) withOptions:AspectPositionInstead usingBlock:block2 error:nil];
            [CALayer aspect_hookSelector:@selector(setShadowColor:) withOptions:AspectPositionInstead usingBlock:block2 error:nil];
            
            
            // 处理NSDictionary类型（UITabBarItem）
            NSArray *attrKeys = @[NSForegroundColorAttributeName, NSBackgroundColorAttributeName, NSStrokeColorAttributeName, NSUnderlineColorAttributeName, NSStrikethroughColorAttributeName];
            [UITabBarItem aspect_hookSelector:@selector(setTitleTextAttributes:forState:) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> ai) {
                NSDictionary *dict = ai.arguments.firstObject;
                NSInvocation *invocation = ai.originalInvocation;
                
                // 判断是否存在SkinColor
                BOOL hasSkinColor = false;
                for (NSString *key in attrKeys) {
                    if (((UIColor *)dict[key]).alpha == SkinAlpha) {
                        hasSkinColor = true;
                        break;
                    }
                }
                if (hasSkinColor) {
                    if (![__viewPointers.allObjects containsObject:ai.instance]) {
                        [__viewPointers addPointer:(__bridge void * _Nullable)(ai.instance)];
                    }
                    if (OBJOnceToken(ai.instance)) {
                        [ai.instance cc_userInfo][@"SkinBlocks"] = @{}.mutableCopy;
                    }
                    [ai.instance cc_userInfo][@"SkinBlocks"][NSStringFromSelector(invocation.selector)] = ^{
                        NSMutableDictionary *md = dict.mutableCopy;
                        UIColor *c = nil;
                        for (NSString *key in attrKeys) {
                            if ((c = getSkinColor(dict[key]))) {
                                md[key] = c;
                            }
                        }
                        [ai.originalInvocation setArgument:&md atIndex:2];
                        [invocation invoke];
                    };
                } else {
                    [ai.instance cc_userInfo][@"SkinBlocks"][NSStringFromSelector(invocation.selector)] = nil;
                }
                [ai.originalInvocation invoke];
            } error:nil];
            
            
            // 处理NSAttributedString类型（富文本）
            void (^block3)(id<AspectInfo>) = ^(id<AspectInfo> ai) {
                NSAttributedString *as = ai.arguments.firstObject;
                NSInvocation *invocation = ai.originalInvocation;
                
                // 判断是否存在SkinColor
                BOOL hasSkinColor = false;
                for (int i=0; i<as.length; i++) {
                    NSRange r = NSMakeRange(0, as.length);
                    NSMutableDictionary *dict = [as attributesAtIndex:i effectiveRange:&r].mutableCopy;
                    for (NSString *key in attrKeys) {
                        if (((UIColor *)dict[key]).alpha == SkinAlpha) {
                            hasSkinColor = true;
                            break;
                        }
                    }
                    if (hasSkinColor) {
                        break;
                    }
                }
                if (hasSkinColor) {
                    if (![__viewPointers.allObjects containsObject:ai.instance]) {
                        [__viewPointers addPointer:(__bridge void * _Nullable)(ai.instance)];
                    }
                    if (OBJOnceToken(ai.instance)) {
                        [ai.instance cc_userInfo][@"SkinBlocks"] = @{}.mutableCopy;
                    }
                    [ai.instance cc_userInfo][@"SkinBlocks"][NSStringFromSelector(invocation.selector)] = ^{
                        NSMutableAttributedString *mas = as.mutableCopy;
                        UIColor *c = nil;
                        for (int i=0; i<as.length; i++) {
                            NSRange r = NSMakeRange(0, as.length);
                            NSMutableDictionary *dict = [as attributesAtIndex:i effectiveRange:&r].mutableCopy;
                            BOOL isChange = false;
                            for (NSString *key in attrKeys) {
                                if ((c = getSkinColor(dict[key]))) {
                                    dict[key] = c;
                                    isChange = true;
                                }
                            }
                            if (isChange) {
                                [mas addAttributes:dict range:NSMakeRange(i, 1)];
                            }
                        }
                        [ai.originalInvocation setArgument:&mas atIndex:2];
                        [invocation invoke];
                    };
                } else {
                    [ai.instance cc_userInfo][@"SkinBlocks"][NSStringFromSelector(invocation.selector)] = nil;
                }
                [ai.originalInvocation invoke];
            };
            [UILabel aspect_hookSelector:@selector(setAttributedText:) withOptions:AspectPositionInstead usingBlock:block3 error:nil];
            [UITextField aspect_hookSelector:@selector(setAttributedText:) withOptions:AspectPositionInstead usingBlock:block3 error:nil];
            [UITextField aspect_hookSelector:@selector(setAttributedPlaceholder:) withOptions:AspectPositionInstead usingBlock:block3 error:nil];;
            [UITextView aspect_hookSelector:@selector(setAttributedText:) withOptions:AspectPositionInstead usingBlock:block3 error:nil];
            [UIButton aspect_hookSelector:@selector(setAttributedTitle:forState:) withOptions:AspectPositionInstead usingBlock:block3 error:nil];
        }
        
        // 把从xib、Storybard加载出来的颜色替换为SkinColor
        [UIView aspect_hookSelector:@selector(awakeFromNib) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> ai) {
            // 替换颜色
            UIColor *c = nil;
            if ([ai.instance isKindOfClass:[UIView class]]) {
                UIView *v = ai.instance;
                if ((c = getSkinColor(v.backgroundColor))) {
                    v.backgroundColor = c;
                }
                if ([v isKindOfClass:[UIButton class]]) {
                    UIButton *btn = (id)v;
                    for (NSNumber *state in @[@(UIControlStateNormal), @(UIControlStateHighlighted), @(UIControlStateDisabled), @(UIControlStateSelected)]) {
                        if ((c = getSkinColor([btn titleColorForState:state.intValue]))) {
                            [btn setTitleColor:c forState:state.intValue];
                        }
                        if ((c = getSkinColor([btn titleShadowColorForState:state.intValue]))) {
                            [btn setTitleShadowColor:c forState:state.intValue];
                        }
                    }
                }
                else if ([v isKindOfClass:UILabel.class] || [v isKindOfClass:UITextField.class] || [v isKindOfClass:UITextView.class]) {
                    UILabel *lb = (id)v;
                    if ((c = getSkinColor(lb.textColor))) {
                        lb.textColor = c;
                    }
                }
                else if ([v isKindOfClass:CALayer.class] && (c = getSkinColor([UIColor colorWithCGColor:[(CALayer *)v borderColor]]))) {
                    ((CALayer *)v).borderColor = c.CGColor;
                }
            }
        } error:nil];
    });
}


#pragma mark - 色值

+ (NSDictionary<NSString *,UGSkinManagers *> *)allSkin {
    static NSDictionary <NSString *, UGSkinManagers *>*__dict = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __viewPointers = [NSPointerArray pointerArrayWithOptions:NSPointerFunctionsWeakMemory];
        
        UIColor *(^color)(NSString *) = ^UIColor *(NSString *hexString) {
            NSMutableArray <UIColor *> *colors = @[].mutableCopy;
            for (NSString *hs in [hexString componentsSeparatedByString:@","]) {
                [colors addObject:[UIColor colorWithHexString:hs]];
            }
            if (colors.count > 1) {
                return [UIColor colorWithPatternImage:[UIImage gradientImageWithBounds:APP.Bounds andColors:colors andGradientType:GradientDirectionLeftToRight]];
            } else {
                return colors.firstObject;
            }
        };
        
        // 设置c.cc_userInfo[@"colorName"] = colorName; 和设置透明度
        for (NSString *colorName in [UGSkinManagers propertyList]) {
            if ([colorName.lowercaseString containsString:@"color"]) {
                NSString *setterName = _NSString(@"set%@%@:", colorName[0].uppercaseString, [colorName substringFromIndex:1]);
                [UGSkinManagers aspect_hookSelector:NSSelectorFromString(setterName) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> ai) {
                    UIColor *c = ai.arguments.firstObject;
                    c = [c colorWithAlphaComponent:SkinAlpha];
                    c.cc_userInfo[@"colorName"] = colorName;
                    [ai.originalInvocation setArgument:&c atIndex:2];
                    [ai.originalInvocation invoke];
                } error:nil];
            }
        }
        
        // 渐变色有多个色值，用英文逗号隔开
        __dict = @{
        //经典 1蓝色
        @"1":({
            UGSkinManagers *sm = [UGSkinManagers new];
            sm.skitType = @"经典";
            sm.bgColor = color(@"7F9493,5389B3");
            sm.navBarBgColor = color(@"609AC5");
            sm.tabBarBgColor = color(@"C1CBC9");
            sm.tabNoSelectColor = color(@"717176");
            sm.tabSelectedColor = color(@"FFFFFF");
            sm.cellBgColor = color(@"C1CBC9");
            sm.progressBgColor = color(@"d80000,fb5959");
            sm.homeContentColor = color(@"b2cde0");
            sm.homeContentBorderColor = color(@"b2cde0");
            sm.menuHeadViewColor = color(@"5f9bc6,fb5959");
            sm.signBgColor = color(@"7F9493,5389B3");
            sm;
        }),
        //经典 2红色
        @"2":({
            UGSkinManagers *sm = [UGSkinManagers new];
            sm.skitType = @"经典";
            sm.bgColor = color(@"d19885,904a6e");
            sm.navBarBgColor = color(@"73315C");
            sm.tabBarBgColor = color(@"DFB9B5");
            sm.tabNoSelectColor = color(@"717176");
            sm.tabSelectedColor = color(@"FFFFFF");
            sm.cellBgColor = color(@"DFB9B5");
            sm.progressBgColor = color(@"d80000,fb5959");
            sm.homeContentColor = color(@"d0aeb7");
            sm.homeContentBorderColor = color(@"d0aeb7");
            sm.menuHeadViewColor = color(@"bf338e,fb95db");
            sm.signBgColor = color(@"d19885,904a6e");
            sm;
        }),
        //经典 3褐色
        @"3":({
            UGSkinManagers *sm = [UGSkinManagers new];
            sm.skitType = @"经典";
            sm.bgColor = color(@"B48A46,8A5C3E");
            sm.navBarBgColor = color(@"7E503C");
            sm.tabBarBgColor = color(@"DFC8A1");
            sm.tabNoSelectColor = color(@"717176");
            sm.tabSelectedColor = color(@"FFFFFF");
            sm.cellBgColor = color(@"DFC8A1");
            sm.progressBgColor = color(@"d80000,fb5959");
            sm.homeContentColor = color(@"d2bea6");
            sm.homeContentBorderColor = color(@"d2bea6");
            sm.menuHeadViewColor = color(@"bf7555,efb398");
            sm.signBgColor = color(@"B48A46,8A5C3E");
            sm;
        }),
        //经典 4绿色
        @"4":({
            UGSkinManagers *sm = [UGSkinManagers new];
            sm.skitType = @"经典";
            sm.bgColor = color(@"78BC67,4DB48B");
            sm.navBarBgColor = color(@"58BEA4");
            sm.tabBarBgColor = color(@"B6DDB6");
            sm.tabNoSelectColor = color(@"717176");
            sm.tabSelectedColor = color(@"FFFFFF");
            sm.cellBgColor = color(@"B6DDB6");
            sm.progressBgColor = color(@"d80000,fb5959");
            sm.homeContentColor = color(@"c4e5c7");
            sm.homeContentBorderColor = color(@"c4e5c7");
            sm.menuHeadViewColor = color(@"49a791,7cead3");
            sm.signBgColor = color(@"78BC67,4DB48B");
            sm;
        }),
        //经典 5褐色
        @"5":({
            UGSkinManagers *sm = [UGSkinManagers new];
            sm.skitType = @"经典";
            sm.bgColor = color(@"913D3E,EAAD72");
            sm.navBarBgColor = color(@"662E3E");
            sm.tabBarBgColor = color(@"FBE0B8");
            sm.tabNoSelectColor = color(@"717176");
            sm.tabSelectedColor = color(@"FFFFFF");
            sm.cellBgColor = color(@"F7E2C0");
            sm.progressBgColor = color(@"d80000,fb5959");
            sm.homeContentColor = color(@"c1a8aa");
            sm.homeContentBorderColor = color(@"c1a8aa");
            sm.menuHeadViewColor = color(@"a06577,f1adc4");
            sm.signBgColor = color(@"913D3E,EAAD72");
            sm;
        }),
        //经典 6淡蓝色
        @"6":({
            UGSkinManagers *sm = [UGSkinManagers new];
            sm.skitType = @"经典";
            sm.bgColor = color(@"61A8B4,C7F3E5");
            sm.navBarBgColor = color(@"2E647C");
            sm.tabBarBgColor = color(@"C5EAE7");
            sm.tabNoSelectColor = color(@"717176");
            sm.tabSelectedColor = color(@"FFFFFF");
            sm.cellBgColor = color(@"C5EAE7");
            sm.progressBgColor = color(@"d80000,fb5959");
            sm.homeContentColor = color(@"c1e1e6");
            sm.homeContentBorderColor = color(@"c1e1e6");
            sm.menuHeadViewColor = color(@"4c91a9,85d2ec");
            sm.signBgColor = color(@"61A8B4,C7F3E5");
            sm;
        }),
        //经典 7深蓝
        @"7":({
            UGSkinManagers *sm = [UGSkinManagers new];
            sm.skitType = @"经典";
            sm.bgColor = color(@"486869,436363");
            sm.navBarBgColor = color(@"3F5658");
            sm.tabBarBgColor = color(@"ABC2B4");
            sm.tabNoSelectColor = color(@"717176");
            sm.tabSelectedColor = color(@"FFFFFF");
            sm.cellBgColor = color(@"ABC2B4");
            sm.progressBgColor = color(@"d80000,fb5959");
            sm.homeContentColor = color(@"acbdbe");
            sm.homeContentBorderColor = color(@"acbdbe");
            sm.menuHeadViewColor = color(@"65898c,9fd3d8");
            sm.signBgColor = color(@"486869,436363");
            sm;
        }),
        //经典 8紫色
        @"8":({
            UGSkinManagers *sm = [UGSkinManagers new];
            sm.skitType = @"经典";
            sm.bgColor = color(@"934FB4,9146A0");
            sm.navBarBgColor = color(@"814689");
            sm.tabBarBgColor = color(@"D1A4D7");
            sm.tabNoSelectColor = color(@"717176");
            sm.tabSelectedColor = color(@"FFFFFF");
            sm.cellBgColor = color(@"D1A4D7");
            sm.progressBgColor = color(@"d80000,fb5959");
            sm.homeContentColor = color(@"d7b6e3");
            sm.homeContentBorderColor = color(@"d7b6e3");
            sm.menuHeadViewColor = color(@"c161c3,f889fb");
            sm.signBgColor = color(@"934FB4,9146A0");
            sm;
        }),
        //经典 9深红
        @"9":({
            UGSkinManagers *sm = [UGSkinManagers new];
            sm.skitType = @"经典";
            sm.bgColor = color(@"871113,871B1F");
            sm.navBarBgColor = color(@"880506");
            sm.tabBarBgColor = color(@"DE9595");
            sm.tabNoSelectColor = color(@"717176");
            sm.tabSelectedColor = color(@"FFFFFF");
            sm.cellBgColor = color(@"D1A4D7");
            sm.progressBgColor = color(@"d80000,fb5959");
            sm.homeContentColor = color(@"cd908d");
            sm.homeContentBorderColor = color(@"cd908d");
            sm.menuHeadViewColor = color(@"c30808,f98080");
            sm.signBgColor = color(@"871113,871B1F");
            sm;
        }),
        //经典 10淡灰
        @"10":({
            UGSkinManagers *sm = [UGSkinManagers new];
            sm.skitType = @"经典";
            sm.bgColor = color(@"FC7008,FC7008");
            sm.navBarBgColor = color(@"FF8705");
            sm.tabBarBgColor = color(@"FFB666");
            sm.tabNoSelectColor = color(@"717176");
            sm.tabSelectedColor = color(@"FFFFFF");
            sm.cellBgColor = color(@"FFB666");
            sm.progressBgColor = color(@"d80000,fb5959");
            sm.homeContentColor = color(@"ffc280");
            sm.homeContentBorderColor = color(@"ffc280");
            sm.menuHeadViewColor = color(@"ffa33f,fbd2a5");
            sm.signBgColor = color(@"FC7008,FC7008");
            sm;
        }),
        //经典 11橘红
        @"11":({
            UGSkinManagers *sm = [UGSkinManagers new];
            sm.skitType = @"经典";
            sm.bgColor = color(@"B52A18,8F1115");
            sm.navBarBgColor = color(@"8B2B2A");
            sm.tabBarBgColor = color(@"DC7D6E");
            sm.tabNoSelectColor = color(@"717176");
            sm.tabSelectedColor = color(@"FFFFFF");
            sm.cellBgColor = color(@"DC7D6E");
            sm.progressBgColor = color(@"d80000,fb5959");
            sm.homeContentColor = color(@"dba497");
            sm.homeContentBorderColor = color(@"dba497");
            sm.menuHeadViewColor = color(@"d24040,dc9191");
            sm.signBgColor = color(@"B52A18,8F1115");
            sm;
        }),
        //经典 12星空蓝
        @"12":({
            UGSkinManagers *sm = [UGSkinManagers new];
            sm.skitType = @"经典";
            sm.bgColor = color(@"008CAC,00A9CA");
            sm.navBarBgColor = color(@"68A7A0");
            sm.tabBarBgColor = color(@"98BEBB");
            sm.tabNoSelectColor = color(@"717176");
            sm.tabSelectedColor = color(@"FFFFFF");
            sm.cellBgColor = color(@"98BEBB");
            sm.progressBgColor = color(@"d80000,fb5959");
            sm.homeContentColor = color(@"ade5ed");
            sm.homeContentBorderColor = color(@"ade5ed");
            sm.menuHeadViewColor = color(@"22667b,5fc5e2");
            sm.signBgColor = color(@"008CAC,00A9CA");
            sm;
        }),
        //经典 13紫色
        @"13":({
            UGSkinManagers *sm = [UGSkinManagers new];
            sm.skitType = @"经典";
            sm.bgColor = color(@"9800B7,46D8D6");
            sm.navBarBgColor = color(@"9533DD");
            sm.tabBarBgColor = color(@"C367D7");
            sm.tabNoSelectColor = color(@"717176");
            sm.tabSelectedColor = color(@"FFFFFF");
            sm.cellBgColor = color(@"C367D7");
            sm.progressBgColor = color(@"d80000,fb5959");
            sm.homeContentColor = color(@"ccadee");
            sm.homeContentBorderColor = color(@"ccadee");
            sm.menuHeadViewColor = color(@"aa83e8,dbc5ff");
            sm.signBgColor = color(@"9800B7,46D8D6");
            sm;
        }),
        //经典 14粉红
        @"14":({
            UGSkinManagers *sm = [UGSkinManagers new];
            sm.skitType = @"经典";
            sm.bgColor = color(@"FFBED4,FEC1D5");
            sm.navBarBgColor = color(@"EFCFDD");
            sm.tabBarBgColor = color(@"FEC1D5");
            sm.tabNoSelectColor = color(@"717176");
            sm.tabSelectedColor = color(@"FFFFFF");
            sm.cellBgColor = color(@"FEC1D5");
            sm.progressBgColor = color(@"d80000,fb5959");
            sm.homeContentColor = color(@"ffe7ee");
            sm.homeContentBorderColor = color(@"ffe7ee");
            sm.menuHeadViewColor = color(@"e499b0,fecfdd");
            sm.signBgColor = color(@"FFBED4,FEC1D5");
            sm;
        }),
        //经典 15淡蓝
        @"15":({
            UGSkinManagers *sm = [UGSkinManagers new];
            sm.skitType = @"经典";
            sm.bgColor = color(@"4CAEDC,5DC3EB");
            sm.navBarBgColor = color(@"66C6EA");
            sm.tabBarBgColor = color(@"5DC3EB");
            sm.tabNoSelectColor = color(@"717176");
            sm.tabSelectedColor = color(@"FFFFFF");
            sm.cellBgColor = color(@"5DC3EB");
            sm.progressBgColor = color(@"d80000,fb5959");
            sm.homeContentColor = color(@"b1e2f3");
            sm.homeContentBorderColor = color(@"b1e2f3");
            sm.menuHeadViewColor = color(@"5ebee5,addef3");
            sm.signBgColor = color(@"4CAEDC,5DC3EB");
            sm;
        }),
        //经典 16淡灰
        @"16":({
            UGSkinManagers *sm = [UGSkinManagers new];
            sm.skitType = @"经典";
            sm.bgColor = color(@"4300DA,5800EE");
            sm.navBarBgColor = color(@"6505E6");
            sm.tabBarBgColor = color(@"A766F7");
            sm.tabNoSelectColor = color(@"717176");
            sm.tabSelectedColor = color(@"FFFFFF");
            sm.cellBgColor = color(@"A766F7");
            sm.progressBgColor = color(@"d80000,fb5959");
            sm.homeContentColor = color(@"b680f8");
            sm.homeContentBorderColor = color(@"b680f8");
            sm.menuHeadViewColor = color(@"9041fd,c19bf5");
            sm.signBgColor = color(@"4300DA,5800EE");
            sm;
        }),
        //经典 17淡灰
        @"17":({
            UGSkinManagers *sm = [UGSkinManagers new];
            sm.skitType = @"经典";
            sm.bgColor = color(@"FECC0A,FE9C08");
            sm.navBarBgColor = color(@"FFAF06");
            sm.tabBarBgColor = color(@"FFE066");
            sm.tabNoSelectColor = color(@"717176");
            sm.tabSelectedColor = color(@"FFFFFF");
            sm.cellBgColor = color(@"FFE066");
            sm.progressBgColor = color(@"d80000,fb5959");
            sm.homeContentColor = color(@"ffe280");
            sm.homeContentBorderColor = color(@"ffe280");
            sm.menuHeadViewColor = color(@"ffc344,ffe1a2");
            sm.signBgColor = color(@"FECC0A,FE9C08");
            sm;
        }),
        //18钻石蓝
        @"18":({
            UGSkinManagers *sm = [UGSkinManagers new];
            sm.skitType = @"经典";
            sm.bgColor = color(@"B3B3B3,B3B3B3");
            sm.navBarBgColor = color(@"C1C1C1");
            sm.tabBarBgColor = color(@"D9D9D9");
            sm.tabNoSelectColor = color(@"717176");
            sm.tabSelectedColor = color(@"FFFFFF");
            sm.cellBgColor = color(@"D9D9D9");
            sm.progressBgColor = color(@"d80000,fb5959");
            sm.homeContentColor = color(@"e0e0e0");
            sm.homeContentBorderColor = color(@"e0e0e0");
            sm.menuHeadViewColor = color(@"c1c1c1,ececec");
            sm.signBgColor = color(@"B3B3B3,B3B3B3");
            sm;
        }),
        //19经典 忧郁蓝
        @"19":({
            UGSkinManagers *sm = [UGSkinManagers new];
            sm.skitType = @"经典";
            sm.bgColor = color(@"00B2FF,005ED6");
            sm.navBarBgColor = color(@"4CABFA");
            sm.tabBarBgColor = color(@"8CB9F4");
            sm.tabNoSelectColor = color(@"717176");
            sm.tabSelectedColor = color(@"FFFFFF");
            sm.cellBgColor = color(@"8CB9F4");
            sm.progressBgColor = color(@"d80000,fb5959");
            sm.homeContentColor = color(@"a1ccff");
            sm.homeContentBorderColor = color(@"a1ccff");
            sm.menuHeadViewColor = color(@"4ba2fa,64d0ef");
            sm.signBgColor = color(@"00B2FF,005ED6");
            sm;
        }),
        //石榴红
        @"石榴红":({
            UGSkinManagers *sm = [UGSkinManagers new];
            sm.skitType = @"石榴红";
            sm.bgColor = color(@"FFFFFF");
            sm.navBarBgColor = color(@"CC022C");
            sm.tabBarBgColor = color(@"CC022C");
            sm.tabNoSelectColor = color(@"FFFFFF");
            sm.tabSelectedColor = color(@"F1B709");
            sm.cellBgColor = color(@"FFFFFF");
            sm.progressBgColor = color(@"FEC434,FE8A23");
            sm.homeContentColor = color(@"FFFFFF");
            sm.homeContentBorderColor = color(@"E7E6E6");
            sm.menuHeadViewColor = color(@"d7213a,f99695");
            sm.signBgColor = color(@"FFFFFF");
            sm;
        }),
        //新年红
        @"新年红":({
            UGSkinManagers *sm = [UGSkinManagers new];
            sm.skitType = @"新年红";
            sm.bgColor = color(@"FFFFFF");
            sm.navBarBgColor = color(@"DE1C27");
            sm.tabBarBgColor = color(@"DE1C27");
            sm.tabNoSelectColor = color(@"FFFFFF");
            sm.tabSelectedColor = color(@"F1B709");
            sm.cellBgColor = color(@"FFFFFF");
            sm.progressBgColor = color(@"FEC434,FE8A23");
            sm.homeContentColor = color(@"FFFFFF");
            sm.homeContentBorderColor = color(@"E7E6E6");
            sm.menuHeadViewColor = color(@"e63534,f99695");
            sm.signBgColor = color(@"FFFFFF");
            sm;
        }),
        //六合资料
        @"六合资料":({
            UGSkinManagers *sm = [UGSkinManagers new];
            sm.skitType = @"六合资料";
            sm.bgColor = color(@"7F9493,5389B3");
            sm.navBarBgColor = color(@"609AC5");
            sm.tabBarBgColor = color(@"C1CBC9");
            sm.tabNoSelectColor = color(@"717176");
            sm.tabSelectedColor = color(@"3D80E7");
            sm.cellBgColor = color(@"C1CBC9");
            sm.progressBgColor = color(@"d80000,fb5959");
            sm.homeContentColor = color(@"b2cde0");
            sm.homeContentBorderColor = color(@"b2cde0");
            sm.menuHeadViewColor = color(@"5f9bc6,fb5959");
            sm.signBgColor = color(@"7F9493,5389B3");
            sm;
        }),
        };
        
        __currentSkin1 = __lastSkin1 = __dict[@"1"];
    });
    return __dict;
}


#pragma mark - 对外开放的函数

+ (UGSkinManagers *)skinWithSysConf {
    NSDictionary *dict = @{@"0":SysConf.mobileTemplateBackground,
                           @"2":@"新年红",
                           @"3":@"石榴红",
                           @"4":@"六合资料",
    };
    NSString *skitType = dict[SysConf.mobileTemplateCategory];
    return [UGSkinManagers allSkin][skitType];
}


+ (UGSkinManagers *)currentSkin {
    if (!__currentSkin1) {
        [UGSkinManagers allSkin];
    }
    return __currentSkin1;
}

- (void)useSkin {
    __currentSkin1 = self;
    // 遍历对象执行换肤block
    for (NSObject *obj in __viewPointers.allObjects) {
        for (void (^block)(void) in ((NSDictionary *)obj.cc_userInfo[@"SkinBlocks"]).allValues) {
            block();
        }
    }
    __lastSkin1 = self;
    [[NSNotificationCenter defaultCenter] postNotificationName:UGNotificationWithSkinSuccess object:nil];
}

+ (UIColor *)randomThemeColor {
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
    
    static NSArray<UIColor *> *themeColors = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
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
    });
    return themeColors[arc4random() % themeColors.count];
}

+ (UGSkinManagers *)randomSkin {
    static NSInteger __i = 0;
    NSInteger cnt = [UGSkinManagers allSkin].count;
    return [UGSkinManagers allSkin].allValues[++__i%cnt];
}

@end
