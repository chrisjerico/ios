//
//  NSObject+AspectsHelper.m
//  ug
//
//  Created by fish on 2019/11/19.
//  Copyright © 2019 ug. All rights reserved.
//

#import "NSObject+AspectsHelper.h"

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


+ (void)cc_hookSelector:(SEL)_selector withOptions:(AspectOptions)options usingBlock:(void(^)(id<AspectInfo> ai))block error:(NSError **)error {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __hms = @[].mutableCopy;
    });
    
    NSString *selector = NSStringFromSelector(_selector);
    [__hms addObject:({
        HookModel *hm = [HookModel new];
        hm.cls = self;
        hm.selector = selector;
        hm.opt = options;
        hm.block = block;
        hm;
    })];
    
    [self hookMethod:selector opt:options err:error];
}

- (void)cc_hookSelector:(SEL)_selector withOptions:(AspectOptions)options usingBlock:(void(^)(id<AspectInfo> ai))block error:(NSError **)error {
    NSString *selector = NSStringFromSelector(_selector);
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
    
    [self.class hookMethod:selector opt:options err:error];
}

+ (void)hookMethod:(NSString *)selector opt:(AspectOptions)opt err:(NSError **)err {
    static NSMutableDictionary *__dict = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __dict = @{}.mutableCopy;
    });
    
    Class cls = nil;
    Class temp = self;
    while ((temp = [temp superclass])) {
        for (NSString *name in [temp methodList]) {
            if ([name isEqualToString:selector]) {
                cls = temp;
                break;
            }
        }
        if (cls) {
            break;
        }
    }
    if (cls) {
        [cls hookMethod:selector opt:opt err:err];
    }
    cls = self;
    NSString *key = _NSString(@"%@_%@_%ld", cls, selector, opt);
    if (cls && !__dict[key]) {
        NSError *error = nil;
        [cls aspect_hookSelector:NSSelectorFromString(selector) withOptions:opt usingBlock:^(id<AspectInfo> ai) {
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
