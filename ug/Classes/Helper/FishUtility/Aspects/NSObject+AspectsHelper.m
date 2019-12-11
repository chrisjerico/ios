//
//  NSObject+AspectsHelper.m
//  ug
//
//  Created by fish on 2019/11/19.
//  Copyright © 2019 ug. All rights reserved.
//

#import "NSObject+AspectsHelper.h"

#define HookSEL(cls, selector) NSSelectorFromString([NSString stringWithFormat:@"cc_%@_%@", cls, selector])


@interface HookModel : NSObject
@property (nonatomic) Class cls;            /**<   类 */
@property (nonatomic) NSString *selector;   /**<   函数名 */
@property (nonatomic) AspectOptions opt;    /**<   AOP类型 */
@property (nonatomic) void (^block)(id<AspectInfo> ai); /**<   block */
@end
@implementation HookModel
@end



@implementation NSObject (AspectsHelper)

static NSMutableArray *__hms = nil;


+ (void)cc_hookSelector:(SEL)_sel withOptions:(AspectOptions)options usingBlock:(void(^)(id<AspectInfo> ai))block error:(NSError **)error {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __hms = @[].mutableCopy;
    });
    
    NSString *selector = NSStringFromSelector(_sel);
    [__hms addObject:({
        HookModel *hm = [HookModel new];
        hm.cls = self;
        hm.selector = selector;
        hm.opt = options;
        hm.block = block;
        hm;
    })];
    
    [self hookMethod:_sel opt:options err:error];
}

- (void)cc_hookSelector:(SEL)_sel withOptions:(AspectOptions)options usingBlock:(void(^)(id<AspectInfo> ai))block error:(NSError **)error {
    NSString *selector = NSStringFromSelector(_sel);
    if (OBJOnceToken(self)) {
        self.cc_userInfo[@"cc_hook_hms"] = @[].mutableCopy;
    }
    [self.cc_userInfo[@"cc_hook_hms"] addObject:({
        HookModel *hm = [HookModel new];
        hm.cls = self.class;
        hm.selector = selector;
        hm.opt = options;
        hm.block = block;
        hm;
    })];
    
    [self.class hookMethod:_sel opt:options err:error];
}

+ (void)hookMethod:(SEL)_sel opt:(AspectOptions)opt err:(NSError **)err {
    NSString *selector = NSStringFromSelector(_sel);
    static NSMutableDictionary *__dict = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 若父类与子类共同hook同一个函数，在这里对父类的函数做JRSwizzle交换处理
        {
            Class cls = [UIView class];
            SEL sel = @selector(setBackgroundColor:);
            [cls jr_swizzleMethod:sel withBlock:^(id obj, UIColor *color) {
                [obj performSelectorWithArgs:HookSEL(cls, NSStringFromSelector(sel)), color];
            } error:nil];
        }
        
        __dict = @{}.mutableCopy;
    });
    
    for (NSString *key in __dict.allKeys) {
        NSArray *temp = [key componentsSeparatedByString:@"-"];
        Class cls = NSClassFromString(temp[0]);
        NSString *sel = temp[1];
        if (cls != self && [selector isEqualToString:sel] && ([self isSubclassOfClass:cls] || [cls isSubclassOfClass:self])) {
            Class supCls = [self isSubclassOfClass:cls] ? cls : self;
            Class subCls = [self isSubclassOfClass:cls] ? self : cls;
            
            if (![supCls instancesRespondToSelector:HookSEL(supCls, selector)]) {
                NSString *err = _NSString(@"由于父类（%@）与子类（%@）共同hook同一个函数(%@)，需要对父类的函数做JRSwizzle交换处理。", supCls, subCls, selector);
                NSLog(@"————————————————————————");
                NSLog(@"%@", err);
                NSLog(@"需交换的类：%@，函数名：%@", supCls, selector);
                NSLog(@"————————————————————————");
#ifndef DEBUG
                @throw [NSException exceptionWithName:err reason:err userInfo:nil];
#endif
            }
        }
    }
    
    NSString *key = _NSString(@"%@-%@-%ld", self, selector, opt);
    if (!__dict[key]) {
        SEL hs = HookSEL(self, selector);
        SEL hookSelector = [self instancesRespondToSelector:hs] ? hs : _sel;
        
        NSError *error = nil;
        [self aspect_hookSelector:hookSelector withOptions:opt usingBlock:^(id<AspectInfo> ai) {
            NSArray *hms = [__hms arrayByAddingObjectsFromArray:[ai.instance cc_userInfo][@"cc_hook_hms"]];
            hms = [hms objectsWithValue:selector keyPath:@"selector"];
            hms = [hms objectsWithValue:@(opt) keyPath:@"opt"];
            for (HookModel *hm in hms) {
                if ([ai.instance isKindOfClass:hm.cls]) {
                    if (hm.block) {
                        hm.block(ai);
                    }
                    if (hm.opt == AspectOptionAutomaticRemoval) {
                        [__hms removeObject:hm];
                        [[ai.instance cc_userInfo][@"cc_hook_hms"] removeObject:hm];
                    }
                }
            }
            if (opt == AspectPositionInstead && !hms.count) {
                [ai.originalInvocation invoke];
            }
        } error:&error];
        if (error) {
            if (err) {
                *err = error;
            }
#ifndef DEBUG
            @throw [NSException exceptionWithName:@"方法交换失败" reason:_NSString(@"-[%@ %@]   err = %@", self, selector, *err) userInfo:nil];
#endif
        } else {
            __dict[key] = @true;
        }
    }
}

@end
