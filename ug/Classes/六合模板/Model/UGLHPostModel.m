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


@implementation LHVoteModel
@end



@interface UGLHPostModel ()
@property (nonatomic, copy) NSString *tempId;
@end

@implementation UGLHPostModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"tempId":@"id"};
}
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"vote":@"LHVoteModel"};
}

- (void)setTempId:(NSString *)tempId {
    _cid = tempId;
}

// 这4个方法不写MJExtension无法正常赋值
- (void)setTopAdPc:(LHPostAdModel *)topAdPc { _topAdPc = topAdPc;}
- (void)setBottomAdPc:(LHPostAdModel *)bottomAdPc { _bottomAdPc = bottomAdPc; }
- (void)setTopAdWap:(LHPostAdModel *)topAdWap { _topAdWap = topAdWap;}
- (void)setBottomAdWap:(LHPostAdModel *)bottomAdWap { _bottomAdWap = bottomAdWap; }

@end
