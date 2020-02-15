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

static NSPointerArray *__viewPointers = nil;    // 保存需要换肤的对象
static UGSkinManagers *__currentSkin1 = nil;    // 当前皮肤
static UGSkinManagers *__lastSkin1 = nil;       // 上一个皮肤，用来做CGColor的色值匹配
static UGSkinManagers *__initSkin1 = nil;


#pragma mark - 换肤核心逻辑

+ (void)load {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		
		NSString *(^colorNameWithColor)(UGSkinManagers *, UIColor *) = ^NSString *(UGSkinManagers *sm, UIColor *c1) {
			NSString *colorName = c1.cc_userInfo[@"colorName"];
			if (colorName.length) {
				return colorName;
			}
			for (NSString *colorName in [UGSkinManagers propertyList]) {
				if ([colorName.lowercaseString containsString:@"color"]) {
					UIColor *c2 = [sm valueForKey:colorName];
					if ([c1 isEqualToColor:c2] || [c1.hexString isEqualToString:c2.hexString]) {
						return colorName;
					}
				}
			}
			return nil;
		};
		
		// 获取SkinColor
		UIColor *(^getSkinColor)(UGSkinManagers *, UIColor *) = ^UIColor *(UGSkinManagers *sm, UIColor *c) {
			if (c.alpha == SkinAlpha) {
				return [__currentSkin1 performSelector:colorNameWithColor(sm, c).UTF8String];
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
					// 设置换肤block
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
			[UIView cc_hookSelector:@selector(setBackgroundColor:) withOptions:AspectPositionInstead usingBlock:block1 error:nil];
			[UIView cc_hookSelector:@selector(setTintColor:) withOptions:AspectPositionInstead usingBlock:block1 error:nil];
			[UILabel cc_hookSelector:@selector(setTextColor:) withOptions:AspectPositionInstead usingBlock:block1 error:nil];
			[UITextField cc_hookSelector:@selector(setTextColor:) withOptions:AspectPositionInstead usingBlock:block1 error:nil];
			[UITextView cc_hookSelector:@selector(setTextColor:) withOptions:AspectPositionInstead usingBlock:block1 error:nil];
			[UIButton cc_hookSelector:@selector(setTitleColor:forState:) withOptions:AspectPositionInstead usingBlock:block1 error:nil];
			[UIButton cc_hookSelector:@selector(setTitleShadowColor:forState:) withOptions:AspectPositionInstead usingBlock:block1 error:nil];
			[UITabBar cc_hookSelector:@selector(setUnselectedItemTintColor:) withOptions:AspectPositionInstead usingBlock:block1 error:nil];
			[UITabBar cc_hookSelector:@selector(setSelectedImageTintColor:) withOptions:AspectPositionInstead usingBlock:block1 error:nil];
			[UITabBar cc_hookSelector:@selector(setBarTintColor:) withOptions:AspectPositionInstead usingBlock:block1 error:nil];
			[UINavigationBar cc_hookSelector:@selector(setBarTintColor:) withOptions:AspectPositionInstead usingBlock:block1 error:nil];
			[UISegmentedControl cc_hookSelector:@selector(setBackgroundColor:) withOptions:AspectPositionInstead usingBlock:block1 error:nil];
			
			// 处理CGColorRef类型（描边色）
			void (^block2)(id<AspectInfo>) = ^(id<AspectInfo> ai) {
				CGColorRef cr = [ai.arguments.firstObject CGColorValue];
				NSInvocation *invocation = ai.originalInvocation;
				if (CGColorGetAlpha(cr) == SkinAlpha) {
					NSString *colorName = colorNameWithColor(__lastSkin1, [UIColor colorWithCGColor:cr]);
					
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
			[CALayer cc_hookSelector:@selector(setBorderColor:) withOptions:AspectPositionInstead usingBlock:block2 error:nil];
			[CALayer cc_hookSelector:@selector(setShadowColor:) withOptions:AspectPositionInstead usingBlock:block2 error:nil];
			
			// 处理NSDictionary类型（UITabBarItem）
			NSArray *attrKeys = @[NSForegroundColorAttributeName, NSBackgroundColorAttributeName, NSStrokeColorAttributeName, NSUnderlineColorAttributeName, NSStrikethroughColorAttributeName];
			[UITabBarItem cc_hookSelector:@selector(setTitleTextAttributes:forState:) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> ai) {
				NSDictionary *dict = ai.arguments.firstObject;
				NSInvocation *invocation = ai.originalInvocation;
				
				// 判断是否存在SkinColor
				BOOL hasSkinColor = ({
					hasSkinColor = false;
					for (NSString *key in attrKeys) {
						if (((UIColor *)dict[key]).alpha == SkinAlpha) {
							hasSkinColor = true;
							break;
						}
					}
					hasSkinColor;
				});
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
							if ((c = getSkinColor(__lastSkin1, dict[key]))) {
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
								if ((c = getSkinColor(__lastSkin1, dict[key]))) {
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
			[UILabel cc_hookSelector:@selector(setAttributedText:) withOptions:AspectPositionInstead usingBlock:block3 error:nil];
			[UITextField cc_hookSelector:@selector(setAttributedText:) withOptions:AspectPositionInstead usingBlock:block3 error:nil];
			[UITextField cc_hookSelector:@selector(setAttributedPlaceholder:) withOptions:AspectPositionInstead usingBlock:block3 error:nil];;
			[UITextView cc_hookSelector:@selector(setAttributedText:) withOptions:AspectPositionInstead usingBlock:block3 error:nil];
			[UIButton cc_hookSelector:@selector(setAttributedTitle:forState:) withOptions:AspectPositionInstead usingBlock:block3 error:nil];
		}
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
				UIColor *c = [UIColor colorWithPatternImage:[UIImage gradientImageWithBounds:APP.Bounds andColors:colors andGradientType:GradientDirectionLeftToRight]];
				c.cc_userInfo[@"color"] = [hexString componentsSeparatedByString:@","].firstObject;
				c.cc_userInfo[@"endColor"] = [hexString componentsSeparatedByString:@","].lastObject;
				return c;
			} else {
				UIColor *c = colors.firstObject;
				c.cc_userInfo[@"color"] = hexString;
				return c;
			}
		};
		
		// 设置c.cc_userInfo[@"colorName"] = colorName; 和设置透明度
		for (NSString *colorName in [UGSkinManagers propertyList]) {
			if ([colorName.lowercaseString containsString:@"color"]) {
				NSString *setterName = _NSString(@"set%@%@:", colorName[0].uppercaseString, [colorName substringFromIndex:1]);
				[UGSkinManagers cc_hookSelector:NSSelectorFromString(setterName) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> ai) {
					UIColor *c = ai.arguments.firstObject;
					NSDictionary *cc_userInfo = c.cc_userInfo;
					c = [c colorWithAlphaComponent:SkinAlpha];
					c.cc_userInfo[@"colorName"] = colorName;
					[c.cc_userInfo addEntriesFromDictionary:cc_userInfo];
					[ai.originalInvocation setArgument:&c atIndex:2];
					[ai.originalInvocation invoke];
				} error:nil];
			}
		}
		
		// 渐变色有多个色值，用英文逗号隔开
		__dict = @{
			//经典 1蓝色  #ADC8D7
			@"1":({
				UGSkinManagers *sm = [UGSkinManagers new];
				sm.skitType                 = @"经典";
				sm.skitString               = @"经典 1蓝色";
				sm.bgColor                  = color(@"7F9493,5389B3");
				sm.navBarBgColor            = color(@"609AC5");
				sm.tabBarBgColor            = color(@"8DA3B1");
				sm.tabNoSelectColor         = color(@"525252");
				sm.tabSelectedColor         = color(@"010101");
				sm.progressBgColor          = color(@"d80000,fb5959");
				sm.homeContentColor         = color(@"b2cde0");
				sm.homeContentSubColor      = color(@"ADC8D7");
				sm.cellBgColor              = color(@"C1CBC9");
				sm.CLBgColor                = color(@"E6E6E6");
				sm.menuHeadViewColor        = color(@"5f9bc6,fb5959");
				sm.textColor1               = color(@"111111");
				sm.textColor2               = color(@"555555");
				sm.textColor3               = color(@"C1C1C1");
				sm.textColor4               = color(@"FFFFFF");
				sm;
			}),
			//经典 2红色
			@"2":({
				UGSkinManagers *sm = [UGSkinManagers new];
				sm.skitType                 = @"经典";
				sm.skitString               = @"经典 2红色";
				sm.bgColor                  = color(@"d19885,904a6e");
				sm.navBarBgColor            = color(@"73315C");
				sm.tabBarBgColor            = color(@"DFB9B5");
				sm.tabNoSelectColor         = color(@"000000");
				sm.tabSelectedColor         = color(@"FFFFFF");
				sm.progressBgColor          = color(@"d80000,fb5959");
				sm.homeContentColor         = color(@"d0aeb7");
				sm.homeContentSubColor      = color(@"D19885");
				sm.cellBgColor              = color(@"DFB9B5");
				sm.CLBgColor                = color(@"E6E6E6");
				sm.menuHeadViewColor        = color(@"bf338e,fb95db");
				sm.textColor1               = color(@"111111");
				sm.textColor2               = color(@"555555");
				sm.textColor3               = color(@"C1C1C1");
				sm.textColor4               = color(@"FFFFFF");
				sm;
			}),
			//经典 3褐色
			@"3":({
				UGSkinManagers *sm = [UGSkinManagers new];
				sm.skitType                 = @"经典";
				sm.skitString               = @"经典 3褐色";
				sm.bgColor                  = color(@"B48A46,8A5C3E");
				sm.navBarBgColor            = color(@"7E503C");
				sm.tabBarBgColor            = color(@"DFC8A1");
				sm.tabNoSelectColor         = color(@"000000");
				sm.tabSelectedColor         = color(@"FFFFFF");
				sm.progressBgColor          = color(@"d80000,fb5959");
				sm.homeContentColor         = color(@"d2bea6");
				sm.homeContentSubColor      = color(@"B48A46");
				sm.cellBgColor              = color(@"DFC8A1");
				sm.CLBgColor                = color(@"E6E6E6");
				sm.menuHeadViewColor        = color(@"bf7555,efb398");
				sm.textColor1               = color(@"111111");
				sm.textColor2               = color(@"555555");
				sm.textColor3               = color(@"C1C1C1");
				sm.textColor4               = color(@"FFFFFF");
				sm;
			}),
			//经典 4绿色
			@"4":({
				UGSkinManagers *sm = [UGSkinManagers new];
				sm.skitType                 = @"经典";
				sm.skitString               = @"经典 4绿色";
				sm.bgColor                  = color(@"78BC67,4DB48B");
				sm.navBarBgColor            = color(@"58BEA4");
				sm.tabBarBgColor            = color(@"B6DDB6");
				sm.tabNoSelectColor         = color(@"000000");
				sm.tabSelectedColor         = color(@"FFFFFF");
				sm.progressBgColor          = color(@"d80000,fb5959");
				sm.homeContentColor         = color(@"c4e5c7");
				sm.homeContentSubColor      = color(@"78BC67");
				sm.cellBgColor              = color(@"B6DDB6");
				sm.CLBgColor                = color(@"E6E6E6");
				sm.menuHeadViewColor        = color(@"49a791,7cead3");
				sm.textColor1               = color(@"111111");
				sm.textColor2               = color(@"555555");
				sm.textColor3               = color(@"C1C1C1");
				sm.textColor4               = color(@"FFFFFF");
				sm;
			}),
			//经典 5褐色
			@"5":({
				UGSkinManagers *sm = [UGSkinManagers new];
				sm.skitType                 = @"经典";
				sm.skitString               = @"经典 5褐色";
				sm.bgColor                  = color(@"913D3E,EAAD72");
				sm.navBarBgColor            = color(@"662E3E");
				sm.tabBarBgColor            = color(@"FBE0B8");
				sm.tabNoSelectColor         = color(@"000000");
				sm.tabSelectedColor         = color(@"FFFFFF");
				sm.progressBgColor          = color(@"d80000,fb5959");
				sm.homeContentColor         = color(@"c1a8aa");
				sm.homeContentSubColor      = color(@"EAAD72");
				sm.cellBgColor              = color(@"F7E2C0");
				sm.CLBgColor                = color(@"E6E6E6");
				sm.menuHeadViewColor        = color(@"a06577,f1adc4");
				sm.textColor1               = color(@"111111");
				sm.textColor2               = color(@"555555");
				sm.textColor3               = color(@"C1C1C1");
				sm.textColor4               = color(@"FFFFFF");
				sm;
			}),
			//经典 6淡蓝色
			@"6":({
				UGSkinManagers *sm = [UGSkinManagers new];
				sm.skitType                 = @"经典";
				sm.skitString               = @"经典 6淡蓝色";
				sm.bgColor                  = color(@"61A8B4,C7F3E5");
				sm.navBarBgColor            = color(@"2E647C");
				sm.tabBarBgColor            = color(@"C5EAE7");
				sm.tabNoSelectColor         = color(@"000000");
				sm.tabSelectedColor         = color(@"FFFFFF");
				sm.progressBgColor          = color(@"d80000,fb5959");
				sm.homeContentColor         = color(@"c1e1e6");
				sm.homeContentSubColor      = color(@"4361A3");
				sm.cellBgColor              = color(@"C5EAE7");
				sm.CLBgColor                = color(@"E6E6E6");
				sm.menuHeadViewColor        = color(@"4c91a9,85d2ec");
				sm.textColor1               = color(@"111111");
				sm.textColor2               = color(@"555555");
				sm.textColor3               = color(@"C1C1C1");
				sm.textColor4               = color(@"FFFFFF");
				sm;
			}),
			//经典 7深蓝
			@"7":({
				UGSkinManagers *sm = [UGSkinManagers new];
				sm.skitType                 = @"经典";
				sm.skitString               = @"经典 7深蓝";
				sm.bgColor                  = color(@"486869,436363");
				sm.navBarBgColor            = color(@"3F5658");
				sm.tabBarBgColor            = color(@"ABC2B4");
				sm.tabNoSelectColor         = color(@"000000");
				sm.tabSelectedColor         = color(@"FFFFFF");
				sm.progressBgColor          = color(@"d80000,fb5959");
				sm.homeContentColor         = color(@"acbdbe");
				sm.homeContentSubColor      = color(@"4DB48B");
				sm.cellBgColor              = color(@"ABC2B4");
				sm.CLBgColor                = color(@"E6E6E6");
				sm.menuHeadViewColor        = color(@"65898c,9fd3d8");
				sm.textColor1               = color(@"111111");
				sm.textColor2               = color(@"555555");
				sm.textColor3               = color(@"C1C1C1");
				sm.textColor4               = color(@"FFFFFF");
				sm;
			}),
			//经典 8紫色
			@"8":({
				UGSkinManagers *sm = [UGSkinManagers new];
				sm.skitType                 = @"经典";
				sm.skitString               = @"经典 8紫色";
				sm.bgColor                  = color(@"934FB4,9146A0");
				sm.navBarBgColor            = color(@"814689");
				sm.tabBarBgColor            = color(@"D1A4D7");
				sm.tabNoSelectColor         = color(@"000000");
				sm.tabSelectedColor         = color(@"FFFFFF");
				sm.progressBgColor          = color(@"d80000,fb5959");
				sm.homeContentColor         = color(@"d7b6e3");
				sm.homeContentSubColor      = color(@"934FB4");
				sm.cellBgColor              = color(@"D1A4D7");
				sm.CLBgColor                = color(@"E6E6E6");
				sm.menuHeadViewColor        = color(@"c161c3,f889fb");
				sm.textColor1               = color(@"111111");
				sm.textColor2               = color(@"555555");
				sm.textColor3               = color(@"C1C1C1");
				sm.textColor4               = color(@"FFFFFF");
				sm;
			}),
			//经典 9深红
			@"9":({
				UGSkinManagers *sm = [UGSkinManagers new];
				sm.skitType                 = @"经典";
				sm.skitString               = @"经典 9深红";
				sm.bgColor                  = color(@"871113,871B1F");
				sm.navBarBgColor            = color(@"880506");
				sm.tabBarBgColor            = color(@"DE9595");
				sm.tabNoSelectColor         = color(@"000000");
				sm.tabSelectedColor         = color(@"FFFFFF");
				sm.progressBgColor          = color(@"d80000,fb5959");
				sm.homeContentColor         = color(@"cd908d");
				sm.homeContentSubColor      = color(@"9B292F");
				sm.cellBgColor              = color(@"D1A4D7");
				sm.CLBgColor                = color(@"E6E6E6");
				sm.menuHeadViewColor        = color(@"c30808,f98080");
				sm.textColor1               = color(@"111111");
				sm.textColor2               = color(@"555555");
				sm.textColor3               = color(@"C1C1C1");
				sm.textColor4               = color(@"FFFFFF");
				sm;
			}),
			//经典 10淡灰
			@"10":({
				UGSkinManagers *sm = [UGSkinManagers new];
				sm.skitType                 = @"经典";
				sm.skitString               = @"经典 10淡灰";
				sm.bgColor                  = color(@"FC7008,FC7008");
				sm.navBarBgColor            = color(@"FF8705");
				sm.tabBarBgColor            = color(@"FFB666");
				sm.tabNoSelectColor         = color(@"000000");
				sm.tabSelectedColor         = color(@"FFFFFF");
				sm.progressBgColor          = color(@"d80000,fb5959");
				sm.homeContentColor         = color(@"ffc280");
				sm.homeContentSubColor      = color(@"E58645");
				sm.cellBgColor              = color(@"FFB666");
				sm.CLBgColor                = color(@"E6E6E6");
				sm.menuHeadViewColor        = color(@"ffa33f,fbd2a5");
				sm.textColor1               = color(@"111111");
				sm.textColor2               = color(@"555555");
				sm.textColor3               = color(@"C1C1C1");
				sm.textColor4               = color(@"FFFFFF");
				sm;
			}),
			//经典 11橘红
			@"11":({
				UGSkinManagers *sm = [UGSkinManagers new];
				sm.skitType                 = @"经典";
				sm.skitString               = @"经典 11橘红";
				sm.bgColor                  = color(@"B52A18,8F1115");
				sm.navBarBgColor            = color(@"8B2B2A");
				sm.tabBarBgColor            = color(@"DC7D6E");
				sm.tabNoSelectColor         = color(@"000000");
				sm.tabSelectedColor         = color(@"FFFFFF");
				sm.progressBgColor          = color(@"d80000,fb5959");
				sm.homeContentColor         = color(@"dba497");
				sm.homeContentSubColor      = color(@"B52A18");
				sm.cellBgColor              = color(@"DC7D6E");
				sm.CLBgColor                = color(@"E6E6E6");
				sm.menuHeadViewColor        = color(@"d24040,dc9191");
				sm.textColor1               = color(@"111111");
				sm.textColor2               = color(@"555555");
				sm.textColor3               = color(@"C1C1C1");
				sm.textColor4               = color(@"FFFFFF");
				sm;
			}),
			//经典 12星空蓝
			@"12":({
				UGSkinManagers *sm = [UGSkinManagers new];
				sm.skitType                 = @"经典";
				sm.skitString               = @"经典 12星空蓝";
				sm.bgColor                  = color(@"008CAC,00A9CA");
				sm.navBarBgColor            = color(@"68A7A0");
				sm.tabBarBgColor            = color(@"98BEBB");
				sm.tabNoSelectColor         = color(@"000000");
				sm.tabSelectedColor         = color(@"FFFFFF");
				sm.progressBgColor          = color(@"d80000,fb5959");
				sm.homeContentColor         = color(@"ade5ed");
				sm.homeContentSubColor      = color(@"22BDD1");
				sm.cellBgColor              = color(@"98BEBB");
				sm.CLBgColor                = color(@"E6E6E6");
				sm.menuHeadViewColor        = color(@"22667b,5fc5e2");
				sm.textColor1               = color(@"111111");
				sm.textColor2               = color(@"555555");
				sm.textColor3               = color(@"C1C1C1");
				sm.textColor4               = color(@"FFFFFF");
				sm;
			}),
			//经典 13紫色
			@"13":({
				UGSkinManagers *sm = [UGSkinManagers new];
				sm.skitType                 = @"经典";
				sm.skitString               = @"经典 13紫色";
				sm.bgColor                  = color(@"9800B7,46D8D6");
				sm.navBarBgColor            = color(@"9533DD");
				sm.tabBarBgColor            = color(@"C367D7");
				sm.tabNoSelectColor         = color(@"000000");
				sm.tabSelectedColor         = color(@"FFFFFF");
				sm.progressBgColor          = color(@"d80000,fb5959");
				sm.homeContentColor         = color(@"ccadee");
				sm.homeContentSubColor      = color(@"DCA4EA");
				sm.cellBgColor              = color(@"C367D7");
				sm.CLBgColor                = color(@"E6E6E6");
				sm.menuHeadViewColor        = color(@"aa83e8,dbc5ff");
				sm.textColor1               = color(@"111111");
				sm.textColor2               = color(@"555555");
				sm.textColor3               = color(@"C1C1C1");
				sm.textColor4               = color(@"FFFFFF");
				sm;
			}),
			//经典 14粉红
			@"14":({
				UGSkinManagers *sm = [UGSkinManagers new];
				sm.skitType                 = @"经典";
				sm.skitString               = @"经典 14粉红";
				sm.bgColor                  = color(@"FFBED4,FEC1D5");
				sm.navBarBgColor            = color(@"EFCFDD");
				sm.tabBarBgColor            = color(@"FEC1D5");
				sm.tabNoSelectColor         = color(@"000000");
				sm.tabSelectedColor         = color(@"FFFFFF");
				sm.progressBgColor          = color(@"d80000,fb5959");
				sm.homeContentColor         = color(@"ffe7ee");
				sm.homeContentSubColor      = color(@"F9CFDF");
				sm.cellBgColor              = color(@"FEC1D5");
				sm.CLBgColor                = color(@"E6E6E6");
				sm.menuHeadViewColor        = color(@"e499b0,fecfdd");
				sm.textColor1               = color(@"111111");
				sm.textColor2               = color(@"555555");
				sm.textColor3               = color(@"C1C1C1");
				sm.textColor4               = color(@"FFFFFF");
				sm;
			}),
			//经典 15淡蓝
			@"15":({
				UGSkinManagers *sm = [UGSkinManagers new];
				sm.skitType                 = @"经典";
				sm.skitString               = @"经典 15淡蓝";
				sm.bgColor                  = color(@"4CAEDC,5DC3EB");
				sm.navBarBgColor            = color(@"66C6EA");
				sm.tabBarBgColor            = color(@"5DC3EB");
				sm.tabNoSelectColor         = color(@"000000");
				sm.tabSelectedColor         = color(@"FFFFFF");
				sm.progressBgColor          = color(@"d80000,fb5959");
				sm.homeContentColor         = color(@"b1e2f3");
				sm.homeContentSubColor      = color(@"6EC4E5");
				sm.cellBgColor              = color(@"5DC3EB");
				sm.CLBgColor                = color(@"E6E6E6");
				sm.menuHeadViewColor        = color(@"5ebee5,addef3");
				sm.textColor1               = color(@"111111");
				sm.textColor2               = color(@"555555");
				sm.textColor3               = color(@"C1C1C1");
				sm.textColor4               = color(@"FFFFFF");
				sm;
			}),
			//经典 16淡灰
			@"16":({
				UGSkinManagers *sm = [UGSkinManagers new];
				sm.skitType                 = @"经典";
				sm.skitString               = @"经典 16淡灰";
				sm.bgColor                  = color(@"4300DA,5800EE");
				sm.navBarBgColor            = color(@"6505E6");
				sm.tabBarBgColor            = color(@"A766F7");
				sm.tabNoSelectColor         = color(@"000000");
				sm.tabSelectedColor         = color(@"FFFFFF");
				sm.progressBgColor          = color(@"d80000,fb5959");
				sm.homeContentColor         = color(@"b680f8");
				sm.homeContentSubColor      = color(@"6A3BEA");
				sm.cellBgColor              = color(@"A766F7");
				sm.CLBgColor                = color(@"E6E6E6");
				sm.menuHeadViewColor        = color(@"9041fd,c19bf5");
				sm.textColor1               = color(@"111111");
				sm.textColor2               = color(@"555555");
				sm.textColor3               = color(@"C1C1C1");
				sm.textColor4               = color(@"FFFFFF");
				sm;
			}),
			//经典 17淡灰
			@"17":({
				UGSkinManagers *sm = [UGSkinManagers new];
				sm.skitType                 = @"经典";
				sm.skitString               = @"经典 17淡灰";
				sm.bgColor                  = color(@"FECC0A,FE9C08");
				sm.navBarBgColor            = color(@"FFAF06");
				sm.tabBarBgColor            = color(@"FFE066");
				sm.tabNoSelectColor         = color(@"000000");
				sm.tabSelectedColor         = color(@"FFFFFF");
				sm.progressBgColor          = color(@"d80000,fb5959");
				sm.homeContentColor         = color(@"ffe280");
				sm.homeContentSubColor      = color(@"F4D36C");
				sm.cellBgColor              = color(@"FFE066");
				sm.CLBgColor                = color(@"E6E6E6");
				sm.menuHeadViewColor        = color(@"ffc344,ffe1a2");
				sm.textColor1               = color(@"111111");
				sm.textColor2               = color(@"555555");
				sm.textColor3               = color(@"C1C1C1");
				sm.textColor4               = color(@"FFFFFF");
				sm;
			}),
			//经典 18钻石蓝
			@"18":({
				UGSkinManagers *sm = [UGSkinManagers new];
				sm.skitType                 = @"经典";
				sm.skitString               = @"经典 18钻石蓝";
				sm.bgColor                  = color(@"B3B3B3");
				sm.navBarBgColor            = color(@"C1C1C1");
				sm.tabBarBgColor            = color(@"D9D9D9");
				sm.tabNoSelectColor         = color(@"000000");
				sm.tabSelectedColor         = color(@"FFFFFF");
				sm.progressBgColor          = color(@"d80000,fb5959");
				sm.homeContentColor         = color(@"e0e0e0");
				sm.homeContentSubColor      = color(@"c1c1c1");
				sm.cellBgColor              = color(@"D9D9D9");
				sm.CLBgColor                = color(@"E6E6E6");
				sm.menuHeadViewColor        = color(@"c1c1c1,ececec");
				sm.textColor1               = color(@"111111");
				sm.textColor2               = color(@"555555");
				sm.textColor3               = color(@"C1C1C1");
				sm.textColor4               = color(@"FFFFFF");
				sm;
			}),
			//经典 19忧郁蓝
			@"19":({
				UGSkinManagers *sm = [UGSkinManagers new];
				sm.skitType                 = @"经典";
				sm.skitString               = @"经典 19忧郁蓝";
				sm.bgColor                  = color(@"00B2FF,005ED6");
				sm.navBarBgColor            = color(@"4CABFA");
				sm.tabBarBgColor            = color(@"8CB9F4");
				sm.tabNoSelectColor         = color(@"000000");
				sm.tabSelectedColor         = color(@"FFFFFF");
				sm.progressBgColor          = color(@"d80000,fb5959");
				sm.homeContentColor         = color(@"a1ccff");
				sm.homeContentSubColor      = color(@"49CEFC");
				sm.cellBgColor              = color(@"8CB9F4");
				sm.CLBgColor                = color(@"E6E6E6");
				sm.menuHeadViewColor        = color(@"4ba2fa,64d0ef");
				sm.textColor1               = color(@"111111");
				sm.textColor2               = color(@"555555");
				sm.textColor3               = color(@"C1C1C1");
				sm.textColor4               = color(@"FFFFFF");
				sm;
			}),
			//六合资料
			@"六合资料0":({
				UGSkinManagers *sm = [UGSkinManagers new];
				sm.skitType                 = @"六合资料";
				sm.skitString               = @"六合资料 0默认风格";
				sm.bgColor                  = color(@"FFFFFF");
				sm.navBarBgColor            = color(@"ff566d");
				sm.tabBarBgColor            = color(@"FFFFFF");
				sm.tabNoSelectColor         = color(@"525252");
				sm.tabSelectedColor         = color(@"010101");
				sm.progressBgColor          = color(@"d80000,fb5959");
				sm.homeContentColor         = color(@"FFFFFF");
				sm.homeContentSubColor      = color(@"D3D3D3");
				sm.cellBgColor              = color(@"FFFFFF");
				sm.CLBgColor                = color(@"E6E6E6");
				sm.menuHeadViewColor        = color(@"ff566d,ffbac3");
				sm.textColor1               = color(@"111111");
				sm.textColor2               = color(@"555555");
				sm.textColor3               = color(@"C1C1C1");
				sm.textColor4               = color(@"FFFFFF");
				sm;
			}),
			@"六合资料1":({
				UGSkinManagers *sm = [UGSkinManagers new];
				sm.skitType                 = @"六合资料";
				sm.skitString               = @"六合资料 1蓝色";
				sm.bgColor                  = color(@"FFFFFF");
				sm.navBarBgColor            = color(@"58baf7");
				sm.tabBarBgColor            = color(@"FFFFFF");
				sm.tabNoSelectColor         = color(@"525252");
				sm.tabSelectedColor         = color(@"010101");
				sm.progressBgColor          = color(@"d80000,fb5959");
				sm.homeContentColor         = color(@"FFFFFF");
				sm.homeContentSubColor      = color(@"D3D3D3");
				sm.cellBgColor              = color(@"FFFFFF");
				sm.CLBgColor                = color(@"E6E6E6");
				sm.menuHeadViewColor        = color(@"58baf7,a8d6f3");
				sm.textColor1               = color(@"111111");
				sm.textColor2               = color(@"555555");
				sm.textColor3               = color(@"C1C1C1");
				sm.textColor4               = color(@"FFFFFF");
				sm;
			}),
			@"六合资料2":({
				UGSkinManagers *sm = [UGSkinManagers new];
				sm.skitType                 = @"六合资料";
				sm.skitString               = @"六合资料 2渐变";
				sm.bgColor                  = color(@"FFFFFF");
				sm.navBarBgColor            = color(@"b36cff,87d8d1");
				sm.tabBarBgColor            = color(@"FFFFFF");
				sm.tabNoSelectColor         = color(@"525252");
				sm.tabSelectedColor         = color(@"010101");
				sm.progressBgColor          = color(@"d80000,fb5959");
				sm.homeContentColor         = color(@"FFFFFF");
				sm.homeContentSubColor      = color(@"D3D3D3");
				sm.cellBgColor              = color(@"FFFFFF");
				sm.CLBgColor                = color(@"E6E6E6");
				sm.menuHeadViewColor        = color(@"b36cff,87d8d1");
				sm.textColor1               = color(@"111111");
				sm.textColor2               = color(@"555555");
				sm.textColor3               = color(@"C1C1C1");
				sm.textColor4               = color(@"FFFFFF");
				sm;
			}),
			@"六合资料3":({
				UGSkinManagers *sm = [UGSkinManagers new];
				sm.skitType                 = @"六合资料";
				sm.skitString               = @"六合资料 3大红";
				sm.bgColor                  = color(@"FFFFFF");
				sm.navBarBgColor            = color(@"fd0202");
				sm.tabBarBgColor            = color(@"FFFFFF");
				sm.tabNoSelectColor         = color(@"525252");
				sm.tabSelectedColor         = color(@"010101");
				sm.progressBgColor          = color(@"FEC434,FE8A23");
				sm.homeContentColor         = color(@"FFFFFF");
				sm.homeContentSubColor      = color(@"D3D3D3");
				sm.cellBgColor              = color(@"FFFFFF");
				sm.CLBgColor                = color(@"E6E6E6");
				sm.menuHeadViewColor        = color(@"fd0202,f34a4a");
				sm.textColor1               = color(@"111111");
				sm.textColor2               = color(@"555555");
				sm.textColor3               = color(@"C1C1C1");
				sm.textColor4               = color(@"FFFFFF");
				sm;
			}),
			@"六合资料4":({
				UGSkinManagers *sm = [UGSkinManagers new];
				sm.skitType                 = @"六合资料";
				sm.skitString               = @"六合资料 4粉红";
				sm.bgColor                  = color(@"FFFFFF");
				sm.navBarBgColor            = color(@"fa7dc5");
				sm.tabBarBgColor            = color(@"FFFFFF");
				sm.tabNoSelectColor         = color(@"525252");
				sm.tabSelectedColor         = color(@"010101");
				sm.progressBgColor          = color(@"FEC434,FE8A23");
				sm.homeContentColor         = color(@"FFFFFF");
				sm.homeContentSubColor      = color(@"D3D3D3");
				sm.cellBgColor              = color(@"FFFFFF");
				sm.CLBgColor                = color(@"E6E6E6");
				sm.menuHeadViewColor        = color(@"fa7dc5,f5c3e0");
				sm.textColor1               = color(@"111111");
				sm.textColor2               = color(@"555555");
				sm.textColor3               = color(@"C1C1C1");
				sm.textColor4               = color(@"FFFFFF");
				sm;
			}),
			@"六合资料5":({
				UGSkinManagers *sm = [UGSkinManagers new];
				sm.skitType                 = @"六合资料";
				sm.skitString               = @"六合资料 5橙色";
				sm.bgColor                  = color(@"FFFFFF");
				sm.navBarBgColor            = color(@"ffa811");
				sm.tabBarBgColor            = color(@"FFFFFF");
				sm.tabNoSelectColor         = color(@"525252");
				sm.tabSelectedColor         = color(@"010101");
				sm.progressBgColor          = color(@"d80000,fb5959");
				sm.homeContentColor         = color(@"FFFFFF");
				sm.homeContentSubColor      = color(@"D3D3D3");
				sm.cellBgColor              = color(@"FFFFFF");
				sm.CLBgColor                = color(@"E6E6E6");
				sm.menuHeadViewColor        = color(@"ffa811,f1cb8b");
				sm.textColor1               = color(@"111111");
				sm.textColor2               = color(@"555555");
				sm.textColor3               = color(@"C1C1C1");
				sm.textColor4               = color(@"FFFFFF");
				sm;
			}),
			@"六合资料6":({
				UGSkinManagers *sm = [UGSkinManagers new];
				sm.skitType                 = @"六合资料";
				sm.skitString               = @"六合资料 6深绿";
				sm.bgColor                  = color(@"FFFFFF");
				sm.navBarBgColor            = color(@"85b903");
				sm.tabBarBgColor            = color(@"FFFFFF");
				sm.tabNoSelectColor         = color(@"525252");
				sm.tabSelectedColor         = color(@"010101");
				sm.progressBgColor          = color(@"d80000,fb5959");
				sm.homeContentColor         = color(@"FFFFFF");
				sm.homeContentSubColor      = color(@"D3D3D3");
				sm.cellBgColor              = color(@"FFFFFF");
				sm.CLBgColor                = color(@"E6E6E6");
				sm.menuHeadViewColor        = color(@"85b903,9fb568");
				sm.textColor1               = color(@"111111");
				sm.textColor2               = color(@"555555");
				sm.textColor3               = color(@"C1C1C1");
				sm.textColor4               = color(@"FFFFFF");
				sm;
			}),
			@"六合资料7":({
				UGSkinManagers *sm = [UGSkinManagers new];
				sm.skitType                 = @"六合资料";
				sm.skitString               = @"六合资料 7水绿";
				sm.bgColor                  = color(@"FFFFFF");
				sm.navBarBgColor            = color(@"8BC34A");
				sm.tabBarBgColor            = color(@"FFFFFF");
				sm.tabNoSelectColor         = color(@"525252");
				sm.tabSelectedColor         = color(@"010101");
				sm.progressBgColor          = color(@"d80000,fb5959");
				sm.homeContentColor         = color(@"FFFFFF");
				sm.homeContentSubColor      = color(@"D3D3D3");
				sm.cellBgColor              = color(@"FFFFFF");
				sm.CLBgColor                = color(@"E6E6E6");
				sm.menuHeadViewColor        = color(@"8BC34A,a9c18e");
				sm.textColor1               = color(@"111111");
				sm.textColor2               = color(@"555555");
				sm.textColor3               = color(@"C1C1C1");
				sm.textColor4               = color(@"FFFFFF");
				sm;
			}),
			@"六合资料8":({
				UGSkinManagers *sm = [UGSkinManagers new];
				sm.skitType                 = @"六合资料";
				sm.skitString               = @"六合资料 8淡青";
				sm.bgColor                  = color(@"FFFFFF");
				sm.navBarBgColor            = color(@"48bdb1");
				sm.tabBarBgColor            = color(@"FFFFFF");
				sm.tabNoSelectColor         = color(@"525252");
				sm.tabSelectedColor         = color(@"010101");
				sm.progressBgColor          = color(@"d80000,fb5959");
				sm.homeContentColor         = color(@"FFFFFF");
				sm.homeContentSubColor      = color(@"D3D3D3");
				sm.cellBgColor              = color(@"FFFFFF");
				sm.CLBgColor                = color(@"E6E6E6");
				sm.menuHeadViewColor        = color(@"48bdb1,7ab9b3");
				sm.textColor1               = color(@"111111");
				sm.textColor2               = color(@"555555");
				sm.textColor3               = color(@"C1C1C1");
				sm.textColor4               = color(@"FFFFFF");
				sm;
			}),
			@"六合资料9":({
				UGSkinManagers *sm = [UGSkinManagers new];
				sm.skitType                 = @"六合资料";
				sm.skitString               = @"六合资料 9紫色";
				sm.bgColor                  = color(@"FFFFFF");
				sm.navBarBgColor            = color(@"ac77e6");
				sm.tabBarBgColor            = color(@"FFFFFF");
				sm.tabNoSelectColor         = color(@"525252");
				sm.tabSelectedColor         = color(@"010101");
				sm.progressBgColor          = color(@"d80000,fb5959");
				sm.homeContentColor         = color(@"FFFFFF");
				sm.homeContentSubColor      = color(@"D3D3D3");
				sm.cellBgColor              = color(@"FFFFFF");
				sm.CLBgColor                = color(@"E6E6E6");
				sm.menuHeadViewColor        = color(@"ac77e6,d7c0f1");
				sm.textColor1               = color(@"111111");
				sm.textColor2               = color(@"555555");
				sm.textColor3               = color(@"C1C1C1");
				sm.textColor4               = color(@"FFFFFF");
				sm;
			}),
			@"六合资料10":({
				UGSkinManagers *sm = [UGSkinManagers new];
				sm.skitType                 = @"六合资料";
				sm.skitString               = @"六合资料 10深蓝";
				sm.bgColor                  = color(@"FFFFFF");
				sm.navBarBgColor            = color(@"3862AA");
				sm.tabBarBgColor            = color(@"FFFFFF");
				sm.tabNoSelectColor         = color(@"525252");
				sm.tabSelectedColor         = color(@"010101");
				sm.progressBgColor          = color(@"d80000,fb5959");
				sm.homeContentColor         = color(@"FFFFFF");
				sm.homeContentSubColor      = color(@"D3D3D3");
				sm.cellBgColor              = color(@"FFFFFF");
				sm.CLBgColor                = color(@"E6E6E6");
				sm.menuHeadViewColor        = color(@"3862AA,7887a2");
				sm.textColor1               = color(@"111111");
				sm.textColor2               = color(@"555555");
				sm.textColor3               = color(@"C1C1C1");
				sm.textColor4               = color(@"FFFFFF");
				sm;
			}),
			//石榴红
			@"石榴红":({
				UGSkinManagers *sm = [UGSkinManagers new];
				sm.skitType                 = @"石榴红";
				sm.skitString               = @"石榴红 ";
				sm.bgColor                  = color(@"F5F5F5");
				sm.navBarBgColor            = color(@"CC022C");
				NSLog(@"APP.SiteId =%@ ",APP.SiteId);
				
				if ([APP.SiteId isEqualToString:@"c054"]) {
					sm.tabBarBgColor            = color(@"F6F6F6");
					sm.tabNoSelectColor         = color(@"000000");//717176
				} else {
					sm.tabBarBgColor            = color(@"CC022C");
					sm.tabNoSelectColor         = color(@"FFFFFF");
				}
				
				
				sm.tabSelectedColor         = color(@"F1B709");
				sm.progressBgColor          = color(@"FEC434,FE8A23");
				sm.homeContentColor         = color(@"FFFFFF");
				sm.homeContentSubColor      = color(@"E8A3B3");
				sm.cellBgColor              = color(@"FFFFFF");
				sm.CLBgColor                = color(@"E6E6E6");
				sm.menuHeadViewColor        = color(@"d7213a,f99695");
				sm.textColor1               = color(@"111111");
				sm.textColor2               = color(@"555555");
				sm.textColor3               = color(@"C1C1C1");
				sm.textColor4               = color(@"FFFFFF");
				sm;
			}),
			//新年红
			@"新年红0":({
				UGSkinManagers *sm = [UGSkinManagers new];
				sm.skitType                 = @"新年红";
				sm.skitString               = @"新年红 0默认风格";
				sm.bgColor                  = color(@"F5F5F5");
				sm.navBarBgColor            = color(@"DE1C27");
				sm.tabBarBgColor            = color(@"DE1C27");
				sm.tabNoSelectColor         = color(@"FFFFFF");
				sm.tabSelectedColor         = color(@"F1B709");
				sm.progressBgColor          = color(@"FEC434,FE8A23");
				sm.homeContentColor         = color(@"FFFFFF");
				sm.homeContentSubColor      = color(@"F4C9CD");
				sm.cellBgColor              = color(@"FFFFFF");
				sm.CLBgColor                = color(@"E6E6E6");
				sm.menuHeadViewColor        = color(@"e63534,f99695");
				sm.textColor1               = color(@"111111");
				sm.textColor2               = color(@"555555");
				sm.textColor3               = color(@"C1C1C1");
				sm.textColor4               = color(@"FFFFFF");
				sm;
			}),
			@"新年红1":({
				UGSkinManagers *sm = [UGSkinManagers new];
				sm.skitType                 = @"新年红";
				sm.skitString               = @"新年红 1蓝色风格";
				sm.bgColor                  = color(@"48A9D8,5CC2EC");
				sm.navBarBgColor            = color(@"58B8E4");
				sm.tabBarBgColor            = color(@"8ED0EB");
				sm.tabNoSelectColor         = color(@"525252");
				sm.tabSelectedColor         = color(@"010101");
				sm.progressBgColor          = color(@"d80000,fb5959");
				sm.homeContentColor         = color(@"a4ddf3");
				sm.homeContentSubColor      = color(@"7CB5D8");
				sm.cellBgColor              = color(@"BDDEEF");
				sm.CLBgColor                = color(@"E6E6E6");
				sm.menuHeadViewColor        = color(@"5f9bc6,fb5959");
				sm.textColor1               = color(@"111111");
				sm.textColor2               = color(@"555555");
				sm.textColor3               = color(@"C1C1C1");
				sm.textColor4               = color(@"FFFFFF");
				sm;
			}),
			
			
			//黑色模板
			@"黑色模板":({
				UGSkinManagers *sm = [UGSkinManagers new];
				sm.skitType                 = @"黑色模板";
				sm.skitString               = @"黑色模板";
				sm.bgColor                  = color(@"171717");
				sm.navBarBgColor            = color(@"333333");
				sm.tabBarBgColor            = color(@"313131");
				sm.tabNoSelectColor         = color(@"999999");
				sm.tabSelectedColor         = color(@"FFFFFF");
				sm.progressBgColor          = color(@"d80000,fb5959");
				sm.homeContentColor         = color(@"343434");
				sm.homeContentSubColor      = color(@"353535");
				sm.cellBgColor              = color(@"181818");
				sm.CLBgColor                = color(@"202122");
				sm.menuHeadViewColor        = color(@"323232");
				sm.textColor1               = color(@"FEFEFE");
				sm.textColor2               = color(@"C1C1C1");
				sm.textColor3               = color(@"555555");
				sm.textColor4               = color(@"000000");
				sm;
			}),
			//金沙模板
			@"金沙主题":({
				UGSkinManagers *sm = [UGSkinManagers new];
				sm.skitType                 = @"金沙主题";
				sm.skitString               = @"金沙主题";
				sm.bgColor                  = color(@"FFFFFF");
				sm.navBarBgColor            = color(@"323232");
				sm.tabBarBgColor            = color(@"323232");
				sm.tabNoSelectColor         = color(@"ffffff");
				sm.tabSelectedColor         = color(@"aab647");
				
				sm.progressBgColor          = color(@"d80000,fb5959");
				sm.homeContentColor         = color(@"FFFFFF");
				sm.homeContentSubColor      = color(@"D3D3D3");
				sm.cellBgColor              = color(@"FFFFFF");
				sm.CLBgColor                = color(@"E6E6E6");
				sm.menuHeadViewColor        = color(@"ff566d,ffbac3");
				sm.textColor1               = color(@"111111");
				sm.textColor2               = color(@"555555");
				sm.textColor3               = color(@"C1C1C1");
				sm.textColor4               = color(@"FFFFFF");
				sm;
			}),
			//火山橙
			@"火山橙":({
				UGSkinManagers *sm = [UGSkinManagers new];
				sm.skitType                 = @"火山橙";
				sm.skitString               = @"火山橙";
				sm.bgColor                  = color(@"FFFFFF");
				sm.navBarBgColor            = color(@"f08c34,eb3323");
				sm.tabBarBgColor            = color(@"262223");
				sm.tabNoSelectColor         = color(@"999999");
				sm.tabSelectedColor         = color(@"eb3323");
				
				sm.progressBgColor          = color(@"d80000,fb5959");
				sm.homeContentColor         = color(@"FFFFFF");
				sm.homeContentSubColor      = color(@"D3D3D3");
				sm.cellBgColor              = color(@"FFFFFF");
				sm.CLBgColor                = color(@"E6E6E6");
				sm.menuHeadViewColor        = color(@"ff566d,ffbac3");
				sm.textColor1               = color(@"111111");
				sm.textColor2               = color(@"555555");
				sm.textColor3               = color(@"C1C1C1");
				sm.textColor4               = color(@"FFFFFF");
				sm;
			}),
			
			//香槟金
            @"香槟金":({
                UGSkinManagers *sm = [UGSkinManagers new];
                sm.skitType                 = @"香槟金";
                sm.skitString               = @"香槟金";
                sm.bgColor                  = color(@"FFFFFF");
                sm.navBarBgColor            = color(@"f08c34,eb3323");
                sm.tabBarBgColor            = color(@"262223");
                sm.tabNoSelectColor         = color(@"999999");
                sm.tabSelectedColor         = color(@"eb3323");
                
                sm.progressBgColor          = color(@"d80000,fb5959");
                sm.homeContentColor         = color(@"FFFFFF");
                sm.homeContentSubColor      = color(@"D3D3D3");
                sm.cellBgColor              = color(@"FFFFFF");
                sm.CLBgColor                = color(@"E6E6E6");
                sm.menuHeadViewColor        = color(@"ff566d,ffbac3");
                sm.textColor1               = color(@"111111");
                sm.textColor2               = color(@"555555");
                sm.textColor3               = color(@"C1C1C1");
                sm.textColor4               = color(@"FFFFFF");
                sm;
            }),
            //简约
            @"简约模板0":({
                UGSkinManagers *sm = [UGSkinManagers new];
                sm.skitType                 = @"简约模板";
                sm.skitString               = @"简约模板 0蓝色";
                sm.bgColor                  = color(@"FFFFFF");
                sm.navBarBgColor            = color(@"4463A5");
                sm.tabBarBgColor            = color(@"F4F4F4");
                sm.tabNoSelectColor         = color(@"525252");
                sm.tabSelectedColor         = color(@"010101");
                sm.progressBgColor          = color(@"FEC434,FE8A23");
                sm.homeContentColor         = color(@"FFFFFF");
                sm.homeContentSubColor      = color(@"D3D3D3");
                sm.cellBgColor              = color(@"FFFFFF");
                sm.CLBgColor                = color(@"E6E6E6");
                sm.menuHeadViewColor        = color(@"fa7dc5,f5c3e0");
                sm.textColor1               = color(@"111111");
                sm.textColor2               = color(@"555555");
                sm.textColor3               = color(@"C1C1C1");
                sm.textColor4               = color(@"FFFFFF");
                sm;
            }),
            @"简约模板1":({
                UGSkinManagers *sm = [UGSkinManagers new];
                sm.skitType                 = @"简约模板";
                sm.skitString               = @"简约模板 1红色";
                sm.bgColor                  = color(@"FFFFFF");
                sm.navBarBgColor            = color(@"fb8787,e45353");
                sm.tabBarBgColor            = color(@"F4F4F4");
                sm.tabNoSelectColor         = color(@"525252");
                sm.tabSelectedColor         = color(@"010101");
                sm.progressBgColor          = color(@"FEC434,FE8A23");
                sm.homeContentColor         = color(@"FFFFFF");
                sm.homeContentSubColor      = color(@"D3D3D3");
                sm.cellBgColor              = color(@"FFFFFF");
                sm.CLBgColor                = color(@"E6E6E6");
                sm.menuHeadViewColor        = color(@"fa7dc5,f5c3e0");
                sm.textColor1               = color(@"111111");
                sm.textColor2               = color(@"555555");
                sm.textColor3               = color(@"C1C1C1");
                sm.textColor4               = color(@"FFFFFF");
                sm;
            }),


		};
		
		__currentSkin1 = __lastSkin1 = __initSkin1 = __dict[@"1"];
	});
	return __dict;
}


#pragma mark - 对外开放的函数

+ (UGSkinManagers *)skinWithSysConf {
	NSDictionary *dict = @{@"0":SysConf.mobileTemplateBackground,
						   @"2":[NSString stringWithFormat:@"新年红%@",SysConf.mobileTemplateStyle],
						   @"3":@"石榴红",
						   @"4":[NSString stringWithFormat:@"六合资料%@",SysConf.mobileTemplateLhcStyle],
						   @"5":@"黑色模板",
						   @"6":@"金沙主题",
						   @"7":@"火山橙",
                           @"8":@"香槟金",
                           @"9":[NSString stringWithFormat:@"简约模板%@",SysConf.mobileTemplateStyle],

	};
	
	NSLog(@"============================SysConf.mobileTemplateCategory=%@",SysConf.mobileTemplateStyle);
	
	NSString *skitType = dict[SysConf.mobileTemplateCategory];
#if DEBUG
	NSLog(@"============================skitType=%@",skitType);
//	skitType = @"石榴红";
//        skitType = @"新年红0";
//        skitType = @"简约模板0";
#endif
	return [UGSkinManagers allSkin][skitType];


}


+ (UGSkinManagers *)currentSkin {
	if (!__currentSkin1) {
		[UGSkinManagers allSkin];
	}
	return __currentSkin1;
}

- (void)useSkin {
	if (self == __currentSkin1) {
		[[NSNotificationCenter defaultCenter] postNotificationName:UGNotificationWithSkinSuccess object:nil];
		return;
	}
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

- (BOOL)isBlack {
	return [_skitType isEqualToString:@"黑色模板"];
}

- (BOOL)isLH {
	return [_skitType containsString:@"六合资料"];
}

- (BOOL)isJY{
    return [_skitType containsString:@"简约模板"];
}

- (BOOL)isSLH {
    return [_skitType isEqualToString:@"石榴红"];
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

+ (UGSkinManagers *)next {
    NSArray *keys = [[UGSkinManagers allSkin] keysSortedByValueUsingComparator:^NSComparisonResult(UGSkinManagers *obj1, UGSkinManagers *obj2) {
        return [obj1.skitString compare:obj2.skitString];
    }];
	NSInteger i = [keys indexOfObject:[[UGSkinManagers allSkin] allKeysForObject:Skin1].firstObject] + keys.count;
	return [UGSkinManagers allSkin][keys[++i%keys.count]];
}
+ (UGSkinManagers *)last {
    NSArray *keys = [[UGSkinManagers allSkin] keysSortedByValueUsingComparator:^NSComparisonResult(UGSkinManagers *obj1, UGSkinManagers *obj2) {
        return [obj1.skitString compare:obj2.skitString];
    }];
	NSInteger i = [keys indexOfObject:[[UGSkinManagers allSkin] allKeysForObject:Skin1].firstObject] + keys.count;
	return [UGSkinManagers allSkin][keys[--i%keys.count]];
}

+ (UGSkinManagers *)lhSkin{
    return [UGSkinManagers allSkin][@"六合资料0"];
}

+ (UIColor *)jsftColor:(int)num {
	UIColor *color;
	switch (num) {
		case 1:
			color = RGBA(230, 220, 73, 1);
			break;
		case 2:
			color = RGBA(66, 143, 220, 1);
			break;
		case 3:
			color = RGBA(75, 75, 75, 1);
			break;
		case 4:
			color = RGBA(236, 125, 50, 1);
			break;
		case 5:
			color = RGBA(114, 224, 223, 1);
			break;
		case 6:
			color = RGBA(77, 61, 273, 1);
			break;
		case 7:
			color = RGBA(191, 191, 191, 1);
			break;
		case 8:
			color = RGBA(232, 64, 37, 1);
			break;
		case 9:
			color = RGBA(103, 24, 11, 1);
			break;
		case 10:
			color = RGBA(91, 188, 54, 1);
			break;
			
		default:
			break;
	}
	return color;
}

@end
