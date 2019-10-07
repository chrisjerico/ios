//
//  UIView+Utils.m
//  FishUtility
//
//  Created by fish on 2016/12/1.
//  Copyright © 2016年 fish. All rights reserved.
//

#import "UIView+Utils.h"

typedef NS_ENUM(NSInteger, ZJConstraintType) {
    ZJConstraintTop,
    ZJConstraintLeft,
    ZJConstraintBottom,
    ZJConstraintRight,
    ZJConstraintWidth,
    ZJConstraintHeight,
    ZJConstraintCenterX,
    ZJConstraintCenterY,
};



@implementation ZJGetConstraint

+ (NSArray <NSNumber *>*)constraintAttributesWithType:(ZJConstraintType)type {
    NSArray *attr = nil;
    switch (type) {
        case ZJConstraintTop: {
            attr = @[@(NSLayoutAttributeTop),
                     @(NSLayoutAttributeTopMargin)];
            break;
        }
        case ZJConstraintLeft: {
            attr = @[@(NSLayoutAttributeLeft),
                     @(NSLayoutAttributeLeading),
                     @(NSLayoutAttributeLeftMargin)];
            break;
        }
        case ZJConstraintBottom: {
            attr = @[@(NSLayoutAttributeBottom),
                     @(NSLayoutAttributeBottomMargin),];
            break;
        }
        case ZJConstraintRight: {
            attr = @[@(NSLayoutAttributeRight),
                     @(NSLayoutAttributeTrailing),
                     @(NSLayoutAttributeTrailingMargin)];
            break;
        }
        case ZJConstraintWidth: {
            attr = @[@(NSLayoutAttributeWidth)];
            break;
        }
        case ZJConstraintHeight: {
            attr = @[@(NSLayoutAttributeHeight)];
            break;
        }
        case ZJConstraintCenterX: {
            attr = @[@(NSLayoutAttributeCenterX),
                     @(NSLayoutAttributeCenterXWithinMargins)];
            break;
        }
        case ZJConstraintCenterY: {
            attr = @[@(NSLayoutAttributeCenterY),
                     @(NSLayoutAttributeCenterYWithinMargins)];
            break;
        }
            
        default:;
    }
    return attr;
}

- (NSUInteger)count {
    return _constraints.count;
}

- (NSLayoutConstraint *)constraintWithType:(ZJConstraintType)type item:(id)item {
    NSLayoutConstraint *temp = nil;
    NSArray <NSNumber *>*attrs = [ZJGetConstraint constraintAttributesWithType:type];
    
    for (NSLayoutConstraint *lc in _constraints) {
        // 筛选作用在_owner上的约束
        if (!(lc.firstItem == _owner || lc.secondItem == _owner))
            continue;
        
        BOOL isFirstItem = lc.firstItem == _owner;
        id anotherItem = isFirstItem ? lc.secondItem : lc.firstItem;
        
        if (item) {
            // 若指定了item，则筛选item
            if (anotherItem != item)
                continue;
        } else {
            // 过滤掉 anotherItem 是子View的约束
            if ([anotherItem isKindOfClass:[UIView class]] && [((UIView *)anotherItem) existSuperview:_owner])
                continue;
            
            // 过滤掉 AspectRatio（长宽比）
            if ((type == ZJConstraintWidth || type == ZJConstraintHeight) && anotherItem)
                continue;
        }
        
        // 筛选 NSLayoutAttribute
        for (NSNumber *attr in attrs) {
            NSLayoutAttribute ownerAttr = isFirstItem ? lc.firstAttribute : lc.secondAttribute;
            if (ownerAttr == attr.integerValue) {
                temp = lc;
                break;
            }
        }
        
        if (lc == temp) {
            // 优先级筛选：若是“自定义约束”或“手动添加的约束”，则直接返回，否则继续寻找下一个更高优先级的约束；
            if (lc.classIsCustom || [lc isMemberOfClass:[NSLayoutConstraint class]])
                break;
        }
    }
    return temp;
}


- (NSLayoutConstraint *)top                 { return [self constraintWithType:ZJConstraintTop      item:nil];}
- (NSLayoutConstraint *)left                { return [self constraintWithType:ZJConstraintLeft     item:nil];}
- (NSLayoutConstraint *)bottom              { return [self constraintWithType:ZJConstraintBottom   item:nil];}
- (NSLayoutConstraint *)right               { return [self constraintWithType:ZJConstraintRight    item:nil];}
- (NSLayoutConstraint *)width               { return [self constraintWithType:ZJConstraintWidth    item:nil];}
- (NSLayoutConstraint *)height              { return [self constraintWithType:ZJConstraintHeight   item:nil];}
- (NSLayoutConstraint *)centerX             { return [self constraintWithType:ZJConstraintCenterX  item:nil];}
- (NSLayoutConstraint *)centerY             { return [self constraintWithType:ZJConstraintCenterY  item:nil];}


- (NSLayoutConstraint *)top:(id)item        { return [self constraintWithType:ZJConstraintTop      item:item];}
- (NSLayoutConstraint *)left:(id)item       { return [self constraintWithType:ZJConstraintLeft     item:item];}
- (NSLayoutConstraint *)bottom:(id)item     { return [self constraintWithType:ZJConstraintBottom   item:item];}
- (NSLayoutConstraint *)right:(id)item      { return [self constraintWithType:ZJConstraintRight    item:item];}
- (NSLayoutConstraint *)width:(id)item      { return [self constraintWithType:ZJConstraintWidth    item:item];}
- (NSLayoutConstraint *)height:(id)item     { return [self constraintWithType:ZJConstraintHeight   item:item];}
- (NSLayoutConstraint *)centerX:(id)item    { return [self constraintWithType:ZJConstraintCenterX  item:item];}
- (NSLayoutConstraint *)centerY:(id)item    { return [self constraintWithType:ZJConstraintCenterY  item:item];}

@end



@implementation UIView (Utils)

- (void)zj_updateConstraints:(void (^)(ZJGetConstraint *))block {
    block(self.zj_constraints);
}

- (BOOL)existSubview:(UIView *)view {
    return view != self && [view isDescendantOfView:self];
}

- (BOOL)existSuperview:(UIView *)view {
    return view != self && [self isDescendantOfView:view];
}

- (void)removeAllConstraints {
    [self removeConstraints:self.zj_constraints.constraints];
}

- (ZJGetConstraint *)zj_constraints {
    ZJGetConstraint *zj_constraints = objc_getAssociatedObject(self, @selector(zj_constraints));
    if (!zj_constraints) {
        zj_constraints = [ZJGetConstraint new];
        objc_setAssociatedObject(self, @selector(zj_constraints), zj_constraints, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    zj_constraints.constraints = ({
        [self.superview updateConstraintsIfNeeded];
        
        NSMutableArray <NSLayoutConstraint *>*constraints = [NSMutableArray array];
        [constraints addObjectsFromArray:self.constraints];
        [constraints addObjectsFromArray:[self constraintsAffectingLayoutForAxis:UILayoutConstraintAxisVertical]];
        [constraints addObjectsFromArray:[self constraintsAffectingLayoutForAxis:UILayoutConstraintAxisHorizontal]];
        
        [[NSSet setWithArray:constraints] allObjects];
    });
    zj_constraints.owner = self;
    return zj_constraints;
}

- (UIImage *)screenshot {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


@end
