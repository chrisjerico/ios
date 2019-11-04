//
//  UIView+TagString.m
//  C
//
//  Created by fish on 2018/9/13.
//  Copyright © 2018年 fish. All rights reserved.
//

#import "UIView+TagString.h"
#import "cc_runtime_property.h"

@implementation UIView (TagString)

_CCRuntimeProperty_Copy(NSString *, tagString, setTagString)

- (NSArray<UIView *> *)viewsWithMemberOfClass:(Class)cls {
    NSMutableArray *vs = @[].mutableCopy;
    void (^findSubview)(UIView *) = nil;
    void (^__block __findSubview)(UIView *) = findSubview = ^(UIView *v) {
        for (UIView *subview in v.subviews) {
            if ([subview isMemberOfClass:cls]) {
                [vs addObject:subview];
            }
            
            __findSubview(subview);
        }
    };
    findSubview(self);
    return vs.copy;
}

- (nullable __kindof UIView *)viewWithTagString:(NSString *)tagString {
    if (!tagString.length)
        return nil;
    
    for (UIView *subview in self.subviews) {
        if ([subview.tagString isEqualToString:tagString])
            return subview;
        
        UIView *v = [subview viewWithTagString:tagString];
        if (v)
            return v;
    }
    return nil;
}

- (UIView *)superviewWithTagString:(NSString *)tagString {
    UIView *superview = self.superview;
    while (superview) {
        if ([superview.tagString isEqualToString:tagString])
            return superview;
        superview = superview.superview;
    }
    return nil;
}

- (UIGestureRecognizer *)gestureRecognizerWithTagString:(NSString *)tagString {
    for (UIGestureRecognizer *gr in self.gestureRecognizers) {
        if ([gr.tagString isEqualToString:tagString])
            return gr;
    }
    return nil;
}

- (NSLayoutConstraint *)constraintWithIdentifier:(NSString *)identifier {
    for (NSLayoutConstraint *lc in self.cc_constraints.constraints) {
        if ([lc isKindOfClass:[NSLayoutConstraint class]] && [lc.identifier isEqualToString:identifier])
            return lc;
    }
    return nil;
}

@end
