//
//  UGLHGalleryModel.m
//  ug
//
//  Created by fish on 2019/11/28.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGLHGalleryModel.h"

@implementation UGLHGalleryModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"gid":@"id"};
}

@end

@implementation UGLHHotModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"gid":@"id"};
}

@end
