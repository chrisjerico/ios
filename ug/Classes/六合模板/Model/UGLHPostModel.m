//
//  UGLHPostModel.m
//  ug
//
//  Created by ug on 2019/11/28.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGLHPostModel.h"

@implementation UGLHPostModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"id":@"cid"};
}

- (void)setContentPic:(NSString *)contentPic {
    _contentPic = contentPic;
    _photos = [contentPic componentsSeparatedByString:@","];
}

@end
