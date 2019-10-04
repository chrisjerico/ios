//
//  UICollectionViewCell+Utils.h
//  C
//
//  Created by fish on 2017/12/7.
//  Copyright © 2017年 fish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionViewCell (Utils)

@property (nonatomic) void (^didSelectedChange)(__kindof UICollectionViewCell *cell, BOOL selected);

@end
