//
//  UGLHPostModel.m
//  ug
//
//  Created by ug on 2019/11/28.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGLHPostModel.h"

@implementation LHPostAdModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"aid":@"id"};
}
@end



@interface UGLHPostModel ()
@property (nonatomic, copy) NSString *tempId;
@end

@implementation UGLHPostModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"tempId":@"id"};
}

- (void)setTempId:(NSString *)tempId {
    _cid = tempId;
}

@end
