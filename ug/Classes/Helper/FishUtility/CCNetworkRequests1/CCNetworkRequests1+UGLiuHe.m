//
//  CCNetworkRequests1+UGLiuHe.m
//  ug
//
//  Created by fish on 2019/10/25.
//  Copyright © 2019 ug. All rights reserved.
//

#import "CCNetworkRequests1+UGLiuHe.h"

@implementation CCNetworkRequests1 (UGLiuHe)

// 获取六合图库列表
- (CCSessionModel *)lh_getLhcdocPic:(BOOL)collected page:(NSInteger)page {
    return [self req:@"mobile/lhcdoc/getLhcdocPic"
                    :@{@"showFav":@((int)collected),    // 0全部；1我的收藏
                       @"size":@(APP.PageCount),
                       @"page":@(page),
                    }
                    :false];
}

// 获取期数列表（六合图库）
- (CCSessionModel *)lh_getSecondaryPicPeriods:(NSString *)typeId {
    return [self req:@"mobile/lhcdoc/getSecondaryPicPeriods"
                    :@{@"typeid":typeId}    // 图库id
                    :false];
}

// 收藏/取消收藏图库
- (CCSessionModel *)lh_odFavoritesPic:(BOOL)fav rid:(NSString *)rid {
    return [self req:@"mobile/lhcdoc/doFavorites"
                    :@{@"favFlag":@((int)fav),// 0取消收藏；1收藏
                       @"id":@"rid",    // 图库id
                       @"type":@"2",    // 1帖子；2图库
                    }
                    :false];
}

// 获取期数列表（幽默猜测、跑狗玄机、四不像）
- (CCSessionModel *)lh_getLhcNoPeriods:(NSInteger)type {
    NSDictionary *dict = @{@1:@"humorGuess",// 幽默猜测
                           @2:@"rundog",    // 跑狗玄机
                           @3:@"fourUnlike",// 四不像
    };
    return [self req:@"mobile/lhcdoc/getLhcNoPeriods"
                    :@{@"alias":dict[@(type)]}
                    :false];
}

// 获取投票结果（幽默猜测、跑狗玄机、四不像）
- (CCSessionModel *)lh_getVote:(NSString *)rid {
    return [self req:@"mobile/lhcdoc/getVote"
                    :@{@"cid":rid}
                    :true];
}

// 投票（幽默猜测、跑狗玄机、四不像）
- (CCSessionModel *)lh_doVote:(NSString *)rid animalFlag:(NSInteger)animalFlag {
    return [self req:@"mobile/lhcdoc/doVote"
                    :@{@"cid":rid, @"animalFlag":@(animalFlag)} // 生肖id
                    :true];
}

// 获取高手论坛列表（综合、精华、最新）
- (CCSessionModel *)lh_forum:(NSInteger)sort page:(NSInteger)page {
    NSDictionary *dict = @{@1:@"",      // 综合
                           @2:@"isHot", // 精华贴
                           @3:@"newest",// 最新
    };
    return [self req:@"mobile/lhcdoc/getcontentlist"
                    :@{@"key":@"forum",
                       @"sort":dict[@(sort)],
                       @"size":@(APP.PageCount),
                       @"page":@(page),
                    }
                    :false];
}

// 获取极品专贴列表（综合、精华、最新）
- (CCSessionModel *)lh_gourmet:(NSInteger)sort page:(NSInteger)page {
    NSDictionary *dict = @{@1:@"",      // 综合
                           @2:@"isHot", // 精华贴
                           @3:@"newest",// 最新
    };
    return [self req:@"mobile/lhcdoc/getcontentlist"
                    :@{@"key":@"gourmet",
                       @"sort":dict[@(sort)],
                       @"size":@(APP.PageCount),
                       @"page":@(page),
                    }
                    :false];
}

// 获取每期资料列表
- (CCSessionModel *)lh_mystery:(NSInteger)page {
    return [self req:@"mobile/lhcdoc/getcontentlist"
                    :@{@"key":@"mystery",
                       @"size":@(APP.PageCount),
                       @"page":@(page),
                    }
                    :false];
}

// 获取公式规律列表
- (CCSessionModel *)lh_rule:(NSInteger)page {
    return [self req:@"mobile/lhcdoc/getcontentlist"
                    :@{@"key":@"rule",
                       @"size":@(APP.PageCount),
                       @"page":@(page),
                    }
                    :false];
}

// 搜索帖子（高手论坛、极品专贴）
- (CCSessionModel *)lh_searchPost:(NSInteger)type content:(NSString *)content {
    NSDictionary *dict = @{@1:@"forum",
                           @2:@"gourmet",
    };
    return [self req:@"mobile/lhcdoc/searchPost"
                    :@{@"alias":dict[@(type)],
                       @"content":content,
                    }
                    :true];
}

// 获取我发布的帖子（高手论坛、极品专贴）
- (CCSessionModel *)lh_getHistoryPost:(NSInteger)type page:(NSInteger)page {
    NSDictionary *dict = @{@1:@"forum",
                           @2:@"gourmet",
    };
    return [self req:@"mobile/lhcdoc/getHistoryPost"
                    :@{@"alias":dict[@(type)],
                       @"size":@(APP.PageCount),
                       @"page":@(page),
                    }
                    :true];
}

// 发布帖子（高手论坛、极品专贴）
- (CCSessionModel *)lh_doPost:(NSInteger)type title:(NSString *)title content:(NSString *)content images:(NSArray<UIImage *> *)images {
    NSDictionary *dict = @{@1:@"forum",
                           @2:@"gourmet",
    };
    NSMutableDictionary *params = @{@"alias":dict[@(type)],
       @"title":title,
       @"content":content,
    }.mutableCopy;
    for (int i=0; i<images.count; i++) {
        params[_NSString(@"image[%d]", i)] = _NSString(@"data:image/jpeg;base64,/9j/%@", UIImageJPEGRepresentation(images[i], 1).base64EncodedString);
    }
    return [self req:@"mobile/lhcdoc/doPost"
                    :params
                    :true];
}

// 获取帖子详情（高手论坛、极品专贴、每期资料、公式规律）
- (CCSessionModel *)lh_getContentInfo:(NSString *)rid {
    return [self req:@"mobile/lhcdoc/getContentInfo"
                    :@{@"cid":rid}
                    :false];
}

// 获取回复列表（高手论坛、极品专贴、每期资料、公式规律、六合图库、幽默猜测、跑狗玄机、四不像）
- (CCSessionModel *)lh_getContentReply:(NSString *)rid {
    return [self req:@"mobile/lhcdoc/getContentReply"
                    :@{@"cid":rid}
                    :false];
}

// 回复帖子（高手论坛、极品专贴、每期资料、公式规律、六合图库、幽默猜测、跑狗玄机、四不像）
- (CCSessionModel *)lh_replypost:(NSString *)rid content:(NSString *)content {
    return [self req:@"mobile/lhcdoc/replypost"
                    :@{@"cid":rid, @"content":content,}
                    :true];
}

// 点赞/取消点赞帖子（高手论坛、极品专贴、每期资料、公式规律、六合图库、幽默猜测、跑狗玄机、四不像）
- (CCSessionModel *)lh_likePost:(BOOL)like rid:(NSString *)rid {
    return [self req:@"mobile/lhcdoc/"
                    :@{}
                    :false];
}

// 收藏/取消收藏帖子（高手论坛、极品专贴、每期资料、公式规律、六合图库、幽默猜测、跑狗玄机、四不像）
- (CCSessionModel *)lh_odFavoritesR:(BOOL)fav rid:(NSString *)rid {
    return [self req:@"mobile/lhcdoc/likePost"
                    :@{@"likeFlag":@(fav),
                       @"rid":rid,
                       @"type":@1,
                    }
                    :false];
}

// 关注/取消关注用户
- (CCSessionModel *)lh_followPoster:(BOOL)follow uid:(NSString *)uid {
    return [self req:@"mobile/lhcdoc/followPoster"
                    :@{@"followFlag":@(follow),
                       @"posterUid":uid,
                    }
                    :false];
}

@end
