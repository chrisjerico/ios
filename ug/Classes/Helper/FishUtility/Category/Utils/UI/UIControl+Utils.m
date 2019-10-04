//
//  UIControl+Utils.m
//  C
//
//  Created by fish on 2017/10/30.
//  Copyright © 2017年 fish. All rights reserved.
//

#import "UIControl+Utils.h"
#import "zj_runtime_property.h"

@interface ZJControlModel : NSObject

@property (copy, nonatomic) void (^block)(id arg);  /**<   Action Block */
@property (strong, nonatomic) id userInfo;

- (void)invokeBlock:(id)arg;
@end

@implementation ZJControlModel

- (void)invokeBlock:(id)arg {
    if (self.block)
        self.block(arg);
}
@end





@interface UIControl ()
@property (nonatomic, readonly) NSMutableArray <ZJControlModel *>*actions;
@end

@implementation UIControl (Utils)


_ZJRuntimeProperty_Copy(void (^)(__kindof UIControl *, BOOL), didSelectedChange, setDidSelectedChange)

+ (void)load {
    [super load];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [UIControl jr_swizzleMethod:@selector(setSelected:) withMethod:@selector(zj_setSelected:) error:nil];
    });
}

- (void)zj_setSelected:(BOOL)selected {
    [self zj_setSelected:selected];
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
    ZJControlModel *b = [ZJControlModel new];
    b.block = actionBlock;
    b.userInfo = @(controlEvents);
    [self.actions addObject:b];
    
    [self addTarget:b action:@selector(invokeBlock:) forControlEvents:controlEvents];
}


- (void)removeActionBlocksForControlEvents:(UIControlEvents)controlEvents {
    NSMutableArray *tmpArr = [NSMutableArray array];
    
    [self.actions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ZJControlModel *b = obj;
        if ([b.userInfo integerValue] == controlEvents) {
            [tmpArr addObject:b];
            [self removeTarget:b action:@selector(invokeBlock:) forControlEvents:controlEvents];
        }
    }];
    
    [self.actions removeObjectsInArray:tmpArr];
}

@end
