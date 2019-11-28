//
//  CCNetworkRequests1+UGLiuHe.m
//  ug
//
//  Created by fish on 2019/10/25.
//  Copyright © 2019 ug. All rights reserved.
//

#import "CCNetworkRequests1+UGLiuHe.h"

@implementation CCNetworkRequests1 (UGLiuHe)

// 栏目列表
- (CCSessionModel *)lhcdoc_categoryList {
    return [self req:@"wjapp/api.php?c=lhcdoc&a=categoryList" :@{} :false];
}

// 当前开奖信息
- (CCSessionModel *)lhdoc_lotteryNumber {
    return [self req:@"wjapp/api.php?c=lhcdoc&a=lotteryNumber" :@{} :false];
}

// 帖子列表
- (CCSessionModel *)lhdoc_contentList:(NSString *)alias uid:(NSString *)uid sort:(NSString *)sort page:(NSInteger)page {
    return [self req:@"wjapp/api.php?c=lhcdoc&a=contentList"
    :@{@"alias":alias,    // 栏目别名，必填
        @"uid":uid,    // 选填，作者ID
        @"sort":sort,    // 排序 非必填； new 最新，hot 热门
        @"page":@(page),    // 分页页码，非必填
        @"rows":@(APP.PageCount),   // 分页条数，非必填
    }
    :false];
}

// 获取老黄历详情
- (CCSessionModel *)lhdoc_lhlDetail:(NSDate *)date {
    return [self req:@"wjapp/api.php?c=lhcdoc&a=lhlDetail"
                    :@{@"date":[date stringWithFormat:@"yyyyMMdd"]}
                    :false];
}

// 获取帖子的期数列表
- (CCSessionModel *)lhdoc_lhcNoList:(NSString *)type type2:(NSString *)type2 {
    return [self req:@"wjapp/api.php?c=lhcdoc&a=lhcNoList"
                    :@{@"type":type,// 必填 栏目ID
                       @"type2":type2,// 非必填 资料ID，二级分类的期数列表时必须
                    }
                    :false];
}

// 六合图库列表接口
- (CCSessionModel *)lhdoc_tkList:(BOOL)showFav {
    return [self req:@"wjapp/api.php?c=lhcdoc&a=tkList"
                    :@{@"showFav":@(showFav),}  // 是否收藏 1是 0否
                    :false];
}

// 获取帖子详情
- (CCSessionModel *)lhdoc_contentDetail:(NSString *)cid {
    return [self req:@"wjapp/api.php?c=lhcdoc&a=contentDetail"
                    :@{@"id":cid}   // 必填，帖子ID
                    :false];
}

// 获取评论列表
- (CCSessionModel *)lhdoc_contentReplyList:(NSString *)cid replyPid:(NSString *)replyPId page:(NSInteger)page {
    return [self req:@"wjapp/api.php?c=lhcdoc&a=contentReplyList"
                    :@{@"contentId":cid,    // 必填，帖子ID，
                       @"replyPId":replyPId,// 非必填 ，一级评论ID，查询二级评论时必须
                       @"page":@(page),    // 分页页码，非必填
                       @"rows":@(APP.PageCount),   // 分页条数，非必填
                    }
                    :false];
}

// 发贴
- (CCSessionModel *)lhcdoc_postContent:(NSString *)alias title:(NSString *)title content:(NSString *)content images:(NSArray <UIImage *>*)images price:(double)price {
    return [self req:@"wjapp/api.php?c=lhcdoc&a=postContent"
    :@{@"alias":alias,    // 栏目别名，必填
        @"title":title,    // 必填，帖子标题
        @"content":content,    // 必填，帖子内容
        @"images":images,    // 非必填，图片，base64之后的图片信息
        @"price":_FloatString4(price),   // 非必填，帖子价格
    }
    :true];
}

// 发表评论
- (CCSessionModel *)lhdoc_postContentReply:(NSString *)cid rid:(NSString *_Nullable)rid content:(NSString *)content {
    return [self req:@"wjapp/api.php?c=lhcdoc&a=postContentReply"
                    :@{@"cid":cid,//必填，帖子ID
                       @"rid":rid,//非必填，评论ID，当回复评论时必填
                       @"content":content,//评论内容
                    }
                    :false];
}

// 给帖子投票
- (CCSessionModel *)lhdoc_vote:(NSString *)cid animalId:(NSString *)animalId {
    return [self req:@"wjapp/api.php?c=lhcdoc&a=vote"
                    :@{@"cid":cid,// 帖子ID
                       @"animalId":animalId,// 生肖ID
                    }
                    :false];
}

// 我的历史帖子
- (CCSessionModel *)lhdoc_historyContent:(NSString *)cateId page:(NSInteger)page {
    return [self req:@"wjapp/api.php?c=lhcdoc&a=historyContent"
                    :@{@"cateId":cateId,// 栏目ID
                       @"page":@(page),    // 分页页码，非必填
                       @"rows":@(APP.PageCount),   // 分页条数，非必填
                    }
                    :false];
}

// 关注用户列表
- (CCSessionModel *)lhdoc_followList:(NSString *_Nullable)uid {
    return [self req:@"wjapp/api.php?c=lhcdoc&a=followList"
                    :@{@"uid":uid,// 选填，为空时，查询当前登录用户的关注列表；否则查询指定用户的
                    }
                    :false];
}

// 关注帖子列表
- (CCSessionModel *)lhdoc_favContentList:(NSString *_Nullable)uid page:(NSInteger)page {
    return [self req:@"wjapp/api.php?c=lhcdoc&a=favContentList"
                    :@{@"uid":uid,// 选填，为空时，查询当前登录用户的；否则查询指定用户的
                       @"page":@(page),    // 分页页码，非必填
                       @"rows":@(APP.PageCount),   // 分页条数，非必填
                    }
                    :false];
}

@end
