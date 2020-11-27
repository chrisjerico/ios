//
//  SVProgressHUD+noShowError.m
//  UGBWApp
//
//  Created by fish on 2020/11/27.
//  Copyright © 2020 ug. All rights reserved.
//

#import "SVProgressHUD+noShowError.h"

@implementation SVProgressHUD (noShowError)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [SVProgressHUD jr_swizzleMethod:@selector(showErrorWithStatus:) withMethod:@selector(cc_showErrorWithStatus:) error:nil];
    });
}

+ (void)cc_showErrorWithStatus:(NSString*)status {
    // 【授权TOKEN:  参数未传递!】此类报错不提示出来
    if ([[status lowercaseString] containsString:@"token"]) {
        [SVProgressHUD dismiss];
    } else {
        [self cc_showErrorWithStatus:status];
    }
}
@end
