//
//  UGLHCategoryListModel.m
//  ug
//
//  Created by ug on 2019/11/26.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGLHCategoryListModel.h"

@implementation UGLHCategoryListModel
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"cid"}];
}

- (NSString *)categoryType {
    NSString *alias = [[_link componentsSeparatedByString:@"?"].firstObject componentsSeparatedByString:@"/"].lastObject;
    alias = alias.length ? alias : _alias;
    return alias;
}

- (void)setContentId:(NSString *)contentId {
    if (![contentId isEqualToString:@"0"]) {
        _contentId = contentId;
    }
}
@end
