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
                    :@{@"showFav":@(showFav),// 是否收藏 1是 0否
                       @"page":@1,
                       @"rows":@1000,
                    }
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
    NSMutableArray *base64Images = images.count ? @[].mutableCopy : nil;
    for (UIImage *image in images) {
        [base64Images addObject:_NSString(@"data:image/png;base64,%@", [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength])];
    }
    return [self req:@"wjapp/api.php?c=lhcdoc&a=postContent"
                    :@{@"alias":alias,    // 栏目别名，必填
                       @"title":title,    // 必填，帖子标题
                       @"content":content,    // 必填，帖子内容
                       @"images":base64Images,    // 非必填，图片，base64之后的图片信息
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
                    :true];
}

// 给帖子投票
- (CCSessionModel *)lhdoc_vote:(NSString *)cid animalId:(NSString *)animalId {
    return [self req:@"wjapp/api.php?c=lhcdoc&a=vote"
                    :@{@"cid":cid,// 帖子ID
                       @"animalId":animalId,// 生肖ID
                    }
                    :true];
}

// 我的历史帖子
- (CCSessionModel *)lhdoc_historyContent:(NSString *_Nullable)cateId page:(NSInteger)page {
    return [self req:@"wjapp/api.php?c=lhcdoc&a=historyContent"
                    :@{@"cateId":cateId,// 非必填 ，栏目ID； 值为空时查询所有栏目的帖子
                       @"page":@(page),    // 分页页码，非必填
                       @"rows":@(APP.PageCount),   // 分页条数，非必填
                    }
                    :false];
}

// 关注用户列表
- (CCSessionModel *)lhdoc_followList:(NSString *_Nullable)uid page:(NSInteger)page {
    return [self req:@"wjapp/api.php?c=lhcdoc&a=followList"
                    :@{@"uid":uid,// 选填，为空时，查询当前登录用户的关注列表；否则查询指定用户的
                       @"page":@(page),    // 分页页码，非必填
                       @"rows":@(APP.PageCount),   // 分页条数，非必填
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

// 粉丝列表
- (CCSessionModel *)lhdoc_fansList:(NSString *_Nullable)uid page:(NSInteger)page {
    return [self req:@"wjapp/api.php?c=lhcdoc&a=fansList"
                    :@{@"uid":uid,// 选填，为空时，查询当前登录用户的；否则查询指定用户的
                       @"page":@(page),    // 分页页码，非必填
                       @"rows":@(APP.PageCount),   // 分页条数，非必填
                    }
                    :false];
}

// 帖子粉丝列表
- (CCSessionModel *)lhdoc_contentFansList:(NSString *_Nullable)uid alias:(NSString *_Nullable)alias{
    return [self req:@"wjapp/api.php?c=lhcdoc&a=contentFansList"
                    :@{@"uid":uid,// 选填，为空时，查询当前登录用户的；否则查询指定用户的
                       @"alias":alias,    // 栏目别名，值为空时查询所有栏目的
                    }
                    :false];
}

// 购买帖子
- (CCSessionModel *)lhcdoc_buyContent:(NSString *)cid  {
    return [self req:@"wjapp/api.php?c=lhcdoc&a=buyContent"
                    :@{@"cid":cid,    // 帖子ID，必填
                    }
                    :true];
}

// 打赏帖子
- (CCSessionModel *)lhcdoc_tipContent:(NSString *)cid amount:(double)amount  {
    return [self req:@"wjapp/api.php?c=lhcdoc&a=tipContent"
                    :@{@"cid":cid,    // 帖子ID，必填
                       @"amount":_FloatString4(amount),   // 必填，打赏金额
                    }
                    :true];
}

// 搜索帖子
- (CCSessionModel *)lhcdoc_searchContent:(NSString *)alias content:(NSString *)content page:(NSInteger)page {
    return [self req:@"wjapp/api.php?c=lhcdoc&a=searchContent"
                    :@{@"alias":alias,    // 栏目别名
                       @"content":content,   // 检索内容
                       @"page":@(page),    // 分页页码，非必填
                       @"rows":@(APP.PageCount),   // 分页条数，非必填
                    }
                    :false];
}

// 获取用户信息
- (CCSessionModel *)lhcdoc_getUserInfo:(NSString *)uid {
    return [self req:@"wjapp/api.php?c=lhcdoc&a=getUserInfo"
                    :@{@"uid":uid}  // 用户ID
                    :false];
}

// 申请VIP认证
- (CCSessionModel *)lhcdoc_applyVip:(NSString *)uid {
    return [self req:@"wjapp/api.php?c=lhcdoc&a=applyVip"
                    :@{@"uid":uid}  // 用户ID
                    :true];
}

// 点赞内容或帖子
- (CCSessionModel *)lhcdoc_likePost:(NSString *)rid type:(NSInteger)type likeFlag:(BOOL)likeFlag {
    return [self req:@"wjapp/api.php?c=lhcdoc&a=likePost"
                    :@{@"rid":rid,  // 帖子或内容ID
                       @"type":@(type), // 1 点赞帖子 2 点赞评论
                       @"likeFlag":@((int)likeFlag),// 点赞标记 1 点赞 0 取消点赞
                    }
                    :false];
}

// 收藏资料
- (CCSessionModel *)lhcdoc_doFavorites:(NSString *)rid type:(NSInteger)type favFlag:(BOOL)favFlag {
    return [self req:@"wjapp/api.php?c=lhcdoc&a=doFavorites"
                    :@{@"id":rid,   // 分类ID或帖子ID
                       @"type":@(type), //  1 收藏分类 2 收藏帖子
                       @"favFlag":@((int)favFlag),// 收藏标记 1 收藏 0 取消收藏
                    }
                    :false];
}

// 关注或取消关注楼主
- (CCSessionModel *)lhcdoc_followPoster:(NSString *)posterUid followFlag:(BOOL)followFlag {
    return [self req:@"wjapp/api.php?c=lhcdoc&a=followPoster"
                    :@{@"posterUid":posterUid,//posterUid：被关注会员ID
                       @"followFlag":@((int)followFlag),//followFlag：关注标记 1 关注 0 取消关注
                    }
                    :false];
}

// 设置昵称
- (CCSessionModel *)lhcdoc_setNickname:(NSString *)nickname {
    return [self req:@"wjapp/api.php?c=lhcdoc&a=setNickname"
                    :@{@"nickname":nickname,//昵称
                    }
                    :true];
}

@end
