//
//  CCNetworkRequests1+UGLiuHe.h
//  ug
//
//  Created by fish on 2019/10/25.
//  Copyright © 2019 ug. All rights reserved.
//

#import "CCNetworkRequests1.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCNetworkRequests1 (UGLiuHe)

// 获取六合图库列表
- (CCSessionModel *)lh_getLhcdocPic:(BOOL)collected page:(NSInteger)page;

// 获取期数列表（六合图库）
- (CCSessionModel *)lh_getSecondaryPicPeriods:(NSString *)typeId;

// 收藏/取消收藏图库
- (CCSessionModel *)lh_odFavoritesPic:(BOOL)fav rid:(NSString *)rid;

// 获取期数列表（幽默猜测、跑狗玄机、四不像）
- (CCSessionModel *)lh_getLhcNoPeriods:(NSInteger)type;

// 获取投票结果（幽默猜测、跑狗玄机、四不像）
- (CCSessionModel *)lh_getVote:(NSString *)rid;

// 投票（幽默猜测、跑狗玄机、四不像）
- (CCSessionModel *)lh_doVote:(NSString *)rid animalFlag:(NSInteger)animalFlag;

// 获取高手论坛列表（综合、精华、最新）
- (CCSessionModel *)lh_forum:(NSInteger)sort page:(NSInteger)page;

// 获取极品专贴列表（综合、精华、最新）
- (CCSessionModel *)lh_gourmet:(NSInteger)sort page:(NSInteger)page;

// 获取每期资料列表
- (CCSessionModel *)lh_mystery:(NSInteger)page;

// 获取公式规律列表
- (CCSessionModel *)lh_rule:(NSInteger)page;

// 搜索帖子（高手论坛、极品专贴）
- (CCSessionModel *)lh_searchPost:(NSInteger)type content:(NSString *)content;

// 获取我发布的帖子（高手论坛、极品专贴）
- (CCSessionModel *)lh_getHistoryPost:(NSInteger)type page:(NSInteger)page;

// 发布帖子（高手论坛、极品专贴）
- (CCSessionModel *)lh_doPost:(NSInteger)type title:(NSString *)title content:(NSString *)content images:(NSArray<UIImage *> *)images;

// 获取帖子详情（高手论坛、极品专贴、每期资料、公式规律）
- (CCSessionModel *)lh_getContentInfo:(NSString *)rid;

// 获取回复列表（高手论坛、极品专贴、每期资料、公式规律、六合图库、幽默猜测、跑狗玄机、四不像）
- (CCSessionModel *)lh_getContentReply:(NSString *)rid;

// 回复帖子（高手论坛、极品专贴、每期资料、公式规律、六合图库、幽默猜测、跑狗玄机、四不像）
- (CCSessionModel *)lh_replypost:(NSString *)rid content:(NSString *)content;

// 点赞/取消点赞帖子（高手论坛、极品专贴、每期资料、公式规律、六合图库、幽默猜测、跑狗玄机、四不像）
- (CCSessionModel *)lh_likePost:(BOOL)like rid:(NSString *)rid;

// 收藏/取消收藏帖子（高手论坛、极品专贴、每期资料、公式规律、六合图库、幽默猜测、跑狗玄机、四不像）
- (CCSessionModel *)lh_odFavoritesR:(BOOL)fav rid:(NSString *)rid;

// 关注/取消关注用户
- (CCSessionModel *)lh_followPoster:(BOOL)follow uid:(NSString *)uid;

@end

NS_ASSUME_NONNULL_END
