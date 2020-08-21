//
//  WKUserContentController+MemoryLeak.m
//  UGBWApp
//
//  Created by fish on 2020/8/6.
//  Copyright © 2020 ug. All rights reserved.
//

#import "WKUserContentController+MemoryLeak.h"

@interface WKWebVConfModel : NSObject<WKScriptMessageHandler>
@property (nonatomic, weak) id obj;
@end
@implementation WKWebVConfModel
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([_obj respondsToSelector:@selector(userContentController:didReceiveScriptMessage:)]) {
        [_obj userContentController:userContentController didReceiveScriptMessage:message];
    }
}
@end


@implementation WKUserContentController (MemoryLeak)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [WKUserContentController jr_swizzleMethod:@selector(addScriptMessageHandler:name:) withMethod:@selector(cc_addScriptMessageHandler:name:) error:nil];
    });
}

- (void)cc_addScriptMessageHandler:(id <WKScriptMessageHandler>)scriptMessageHandler name:(NSString *)name {
    if ([scriptMessageHandler isKindOfClass:[UIViewController class]]) {
        WKWebVConfModel *obj = [WKWebVConfModel new];
        obj.obj = scriptMessageHandler;
        if ([scriptMessageHandler respondsToSelector:@selector(cc_userInfo)]) {
            [(NSObject *)scriptMessageHandler cc_userInfo][@"scriptMessageHandler"] = obj;
        }
        [self cc_addScriptMessageHandler:obj name:name];
    } else {
        [self cc_addScriptMessageHandler:scriptMessageHandler name:name];
    }
}
@end
