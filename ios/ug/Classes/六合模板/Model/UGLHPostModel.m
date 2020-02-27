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

+ (NSString *)keyWithImage:(__kindof UIImage *)image {
    return _NSString(@"[em_%d]", (int)[self.allEmoji indexOfObject:image] + 1);
}

+ (YYImage *)imageWithKey:(NSString *)key {
    NSInteger idx = [[key stringByReplacingOccurrencesOfString:@"[em_" withString:@""] stringByReplacingOccurrencesOfString:@"]" withString:@""].integerValue;
    return self.allEmoji[idx];
}

+ (NSArray <YYImage *>*)allEmoji {
    static NSMutableArray *_allEmoji = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _allEmoji = @[].mutableCopy;
        NSInteger gifCnt = 172;
        for (int i=1; i<=gifCnt; i++) {
            YYImage *image = [YYImage imageWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForScaledResource:@(i).stringValue ofType:@"gif"]] scale:1.1];
            image.preloadAllAnimatedImageFrames = YES;
            [_allEmoji addObject:image];
        }
    });
    return _allEmoji;
}

// 这4个方法不写MJExtension无法正常赋值
- (void)setTopAdPc:(LHPostAdModel *)topAdPc { _topAdPc = topAdPc;}
- (void)setBottomAdPc:(LHPostAdModel *)bottomAdPc { _bottomAdPc = bottomAdPc; }
- (void)setTopAdWap:(LHPostAdModel *)topAdWap { _topAdWap = topAdWap;}
- (void)setBottomAdWap:(LHPostAdModel *)bottomAdWap { _bottomAdWap = bottomAdWap; }



@end
