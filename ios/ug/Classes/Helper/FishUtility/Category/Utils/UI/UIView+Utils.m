//
//  UIView+Utils.m
//  FishUtility
//
//  Created by fish on 2016/12/1.
//  Copyright © 2016年 fish. All rights reserved.
//

#import "UIView+Utils.h"

typedef NS_ENUM(NSInteger, CCConstraintType) {
    CCConstraintTop,
    CCConstraintLeft,
    CCConstraintBottom,
    CCConstraintRight,
    CCConstraintWidth,
    CCConstraintHeight,
    CCConstraintCenterX,
    CCConstraintCenterY,
};



@implementation CCGetConstraint

+ (NSArray <NSNumber *>*)constraintAttributesWithType:(CCConstraintType)type {
    NSArray *attr = nil;
    switch (type) {
        case CCConstraintTop: {
            attr = @[@(NSLayoutAttributeTop),
                     @(NSLayoutAttributeTopMargin)];
            break;
        }
        case CCConstraintLeft: {
            attr = @[@(NSLayoutAttributeLeft),
                     @(NSLayoutAttributeLeading),
                     @(NSLayoutAttributeLeftMargin)];
            break;
        }
        case CCConstraintBottom: {
            attr = @[@(NSLayoutAttributeBottom),
                     @(NSLayoutAttributeBottomMargin),];
            break;
        }
        case CCConstraintRight: {
            attr = @[@(NSLayoutAttributeRight),
                     @(NSLayoutAttributeTrailing),
                     @(NSLayoutAttributeTrailingMargin)];
            break;
        }
        case CCConstraintWidth: {
            attr = @[@(NSLayoutAttributeWidth)];
            break;
        }
        case CCConstraintHeight: {
            attr = @[@(NSLayoutAttributeHeight)];
            break;
        }
        case CCConstraintCenterX: {
            attr = @[@(NSLayoutAttributeCenterX),
                     @(NSLayoutAttributeCenterXWithinMargins)];
            break;
        }
        case CCConstraintCenterY: {
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

- (NSLayoutConstraint *)constraintWithType:(CCConstraintType)type item:(id)item {
    NSLayoutConstraint *temp = nil;
    NSArray <NSNumber *>*attrs = [CCGetConstraint constraintAttributesWithType:type];
    
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
            if ((type == CCConstraintWidth || type == CCConstraintHeight) && anotherItem)
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


- (NSLayoutConstraint *)top                 { return [self constraintWithType:CCConstraintTop      item:nil];}
- (NSLayoutConstraint *)left                { return [self constraintWithType:CCConstraintLeft     item:nil];}
- (NSLayoutConstraint *)bottom              { return [self constraintWithType:CCConstraintBottom   item:nil];}
- (NSLayoutConstraint *)right               { return [self constraintWithType:CCConstraintRight    item:nil];}
- (NSLayoutConstraint *)width               { return [self constraintWithType:CCConstraintWidth    item:nil];}
- (NSLayoutConstraint *)height              { return [self constraintWithType:CCConstraintHeight   item:nil];}
- (NSLayoutConstraint *)centerX             { return [self constraintWithType:CCConstraintCenterX  item:nil];}
- (NSLayoutConstraint *)centerY             { return [self constraintWithType:CCConstraintCenterY  item:nil];}


- (NSLayoutConstraint *)top:(id)item        { return [self constraintWithType:CCConstraintTop      item:item];}
- (NSLayoutConstraint *)left:(id)item       { return [self constraintWithType:CCConstraintLeft     item:item];}
- (NSLayoutConstraint *)bottom:(id)item     { return [self constraintWithType:CCConstraintBottom   item:item];}
- (NSLayoutConstraint *)right:(id)item      { return [self constraintWithType:CCConstraintRight    item:item];}
- (NSLayoutConstraint *)width:(id)item      { return [self constraintWithType:CCConstraintWidth    item:item];}
- (NSLayoutConstraint *)height:(id)item     { return [self constraintWithType:CCConstraintHeight   item:item];}
- (NSLayoutConstraint *)centerX:(id)item    { return [self constraintWithType:CCConstraintCenterX  item:item];}
- (NSLayoutConstraint *)centerY:(id)item    { return [self constraintWithType:CCConstraintCenterY  item:item];}

@end



@implementation UIView (Utils)

- (void)cc_updateConstraints:(void (^)(CCGetConstraint *))block {
    block(self.cc_constraints);
}

- (BOOL)existSubview:(UIView *)view {
    return view != self && [view isDescendantOfView:self];
}

- (BOOL)existSuperview:(UIView *)view {
    return view != self && [self isDescendantOfView:view];
}

- (void)removeAllConstraints {
    [self removeConstraints:self.cc_constraints.constraints];
}

- (CCGetConstraint *)cc_constraints {
    CCGetConstraint *cc_constraints = objc_getAssociatedObject(self, @selector(cc_constraints));
    if (!cc_constraints) {
        cc_constraints = [CCGetConstraint new];
        objc_setAssociatedObject(self, @selector(cc_constraints), cc_constraints, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    cc_constraints.constraints = ({
        [self.superview updateConstraintsIfNeeded];
        
        NSMutableArray <NSLayoutConstraint *>*constraints = [NSMutableArray array];
        [constraints addObjectsFromArray:self.constraints];
        [constraints addObjectsFromArray:[self constraintsAffectingLayoutForAxis:UILayoutConstraintAxisVertical]];
        [constraints addObjectsFromArray:[self constraintsAffectingLayoutForAxis:UILayoutConstraintAxisHorizontal]];
        
        [[NSSet setWithArray:constraints] allObjects];
    });
    cc_constraints.owner = self;
    return cc_constraints;
}

- (UIImage *)screenshot {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


@end




@implementation UIStackView (CCUtils)

- (void)addArrangedSubviews:(NSArray <UIView *> *)views {
    for (UIView *v in views) {
        [self addArrangedSubview:v];
    }
}

@end
