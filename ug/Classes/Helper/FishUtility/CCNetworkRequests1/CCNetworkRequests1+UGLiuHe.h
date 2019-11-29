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

// 栏目列表
- (CCSessionModel *)lhcdoc_categoryList;

// 当前开奖信息
- (CCSessionModel *)lhdoc_lotteryNumber;

// 帖子列表
- (CCSessionModel *)lhdoc_contentList:(NSString *)alias uid:(NSString *_Nullable)uid sort:(NSString *_Nullable)sort  page:(NSInteger)page;

// 获取老黄历详情
- (CCSessionModel *)lhdoc_lhlDetail:(NSDate *)date;

// 获取帖子的期数列表
- (CCSessionModel *)lhdoc_lhcNoList:(NSString *)type type2:(NSString *_Nullable)type2;

// 六合图库列表接口
- (CCSessionModel *)lhdoc_tkList:(BOOL)showFav;

// 获取帖子详情
- (CCSessionModel *)lhdoc_contentDetail:(NSString *)cid;

// 获取评论列表
- (CCSessionModel *)lhdoc_contentReplyList:(NSString *)cid replyPid:(NSString *_Nullable)replyPId page:(NSInteger)page;

// 发帖
- (CCSessionModel *)lhcdoc_postContent:(NSString *)alias title:(NSString *)title content:(NSString *)content images:(NSArray <UIImage *>*_Nullable)images price:(double)price;

// 发表评论
- (CCSessionModel *)lhdoc_postContentReply:(NSString *)cid rid:(NSString *_Nullable)rid content:(NSString *)content;

// 给帖子投票
- (CCSessionModel *)lhdoc_vote:(NSString *)cid animalId:(NSString *)animalId;

// 我的历史帖子
- (CCSessionModel *)lhdoc_historyContent:(NSString *)cateId page:(NSInteger)page;

// 关注用户列表
- (CCSessionModel *)lhdoc_followList:(NSString *_Nullable)uid;

// 关注帖子列表
- (CCSessionModel *)lhdoc_favContentList:(NSString *_Nullable)uid page:(NSInteger)page;

// 粉丝列表
- (CCSessionModel *)lhdoc_fansList:(NSString *_Nullable)uid;

// 帖子粉丝列表
- (CCSessionModel *)lhdoc_contentFansList:(NSString *_Nullable)uid alias:(NSString *_Nullable)alias;

// 购买帖子
- (CCSessionModel *)lhcdoc_buyContent:(NSString *)cid ;

// 打赏帖子
- (CCSessionModel *)lhcdoc_tipContent:(NSString *)cid amount:(double)amount;

@end

NS_ASSUME_NONNULL_END
