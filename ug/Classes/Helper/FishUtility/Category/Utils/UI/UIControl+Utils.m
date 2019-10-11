//
//  UIControl+Utils.m
//  C
//
//  Created by fish on 2017/10/30.
//  Copyright © 2017年 fish. All rights reserved.
//

#import "UIControl+Utils.h"
#import "cc_runtime_property.h"

@interface CCControlModel : NSObject

@property (copy, nonatomic) void (^block)(id arg);  /**<   Action Block */
@property (strong, nonatomic) id userInfo;

- (void)invokeBlock:(id)arg;
@end

@implementation CCControlModel

- (void)invokeBlock:(id)arg {
    if (self.block)
        self.block(arg);
}
@end





@interface UIControl ()
@property (nonatomic, readonly) NSMutableArray <CCControlModel *>*actions;
@end

@implementation UIControl (Utils)


_CCRuntimeProperty_Copy(void (^)(__kindof UIControl *, BOOL), didSelectedChange, setDidSelectedChange)

+ (void)load {
    [super load];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [UIControl jr_swizzleMethod:@selector(setSelected:) withMethod:@selector(cc_setSelected:) error:nil];
    });
}

- (void)cc_setSelected:(BOOL)selected {
    [self cc_setSelected:selected];
    if (self.didSelectedChange)
        self.didSelectedChange(self, selected);
}

#pragma mark - Add Action

- (NSMutableArray *)actions {
    NSMutableArray *actions = objc_getAssociatedObject(self, @selector(actions));
    if (!actions) {
        actions = [NSMutableArray array];
        objc_setAssociatedObject(self, @selector(actions), actions, OBJC_ASSOCIATION_RETAIN);
    }
    return actions;
}

- (void)handleControlEvents:(UIControlEvents)controlEvents actionBlock:(void (^)(__kindof UIControl *))actionBlock {
    CCControlModel *b = [CCControlModel new];
    b.block = actionBlock;
    b.userInfo = @(controlEvents);
    [self.actions addObject:b];
    
    [self addTarget:b action:@selector(invokeBlock:) forControlEvents:controlEvents];
}


- (void)removeActionBlocksForControlEvents:(UIControlEvents)controlEvents {
    NSMutableArray *tmpArr = [NSMutableArray array];
    
    [self.actions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CCControlModel *b = obj;
        if ([b.userInfo integerValue] == controlEvents) {
            [tmpArr addObject:b];
            [self removeTarget:b action:@selector(invokeBlock:) forControlEvents:controlEvents];
        }
    }];
    
    [self.actions removeObjectsInArray:tmpArr];
}

@end
