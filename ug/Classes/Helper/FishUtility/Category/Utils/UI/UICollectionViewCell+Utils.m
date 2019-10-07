//
//  UICollectionViewCell+Utils.m
//  C
//
//  Created by fish on 2017/12/7.
//  Copyright © 2017年 fish. All rights reserved.
//

#import "UICollectionViewCell+Utils.h"
#import "zj_runtime_property.h"

@implementation UICollectionViewCell (Utils)

_ZJRuntimeProperty_Copy(void (^)(__kindof UICollectionViewCell *, BOOL), didSelectedChange, setDidSelectedChange)


+ (void)load {
    [super load];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [UICollectionViewCell aspect_hookSelector:@selector(setSelected:) withOptions:AspectPositionAfter usingBlock:^(id <AspectInfo>aInfo) {
            UICollectionViewCell *cell = aInfo.instance;
            if (cell.didSelectedChange)
                cell.didSelectedChange(aInfo.instance, [aInfo.arguments.firstObject boolValue]);
        } error:nil];
    });
}

@end
