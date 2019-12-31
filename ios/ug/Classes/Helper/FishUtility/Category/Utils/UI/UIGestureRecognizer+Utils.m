//
//  UIGestureRecognizer+Utils.m
//  dooboo
//
//  Created by fish on 16/5/16.
//  Copyright © 2016年 huangchucai. All rights reserved.
//

#import "UIGestureRecognizer+Utils.h"
#import "cc_runtime_property.h"

/*
 * UIGestureRecognizer+Block
 */
@implementation UIGestureRecognizer (Utils)

_CCRuntimeProperty_Readonly(NSMutableArray *, actionBlocks, [@[] mutableCopy])
_CCRuntimeProperty_Copy(NSString *, tagString, setTagString)

+ (instancetype)gestureRecognizer:(void (^)(__kindof UIGestureRecognizer *))actionBlock {
    UIGestureRecognizer *gr  = [[self class] new];
    [gr addTarget:gr action:@selector(onGestureRecognizer:)];
    [gr.actionBlocks addObject:[actionBlock copy]];
    return gr;
}

- (void)onGestureRecognizer:(UIGestureRecognizer *)gr {
    for (void (^action)(id) in self.actionBlocks)
        action(gr);
}

@end
