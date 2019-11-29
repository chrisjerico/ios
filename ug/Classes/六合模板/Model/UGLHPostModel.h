//
//  UGLHPostModel.h
//  ug
//
//  Created by ug on 2019/11/28.
//  Copyright © 2019 ug. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGLHPostModel : NSObject

// 《帖子列表》
// c=lhcdoc&a=contentList
@property (nonatomic, copy) NSString *cid;          /**<   帖子ID */
@property (nonatomic, copy) NSString *alias;        /**<    栏目别名 */
@property (nonatomic, copy) NSString *uid;          /**<   用户ID */
@property (nonatomic, copy) NSString *nickname;     /**<   昵称 */
@property (nonatomic, copy) NSString *headImg;      /**<   头像 */
@property (nonatomic, copy) NSString *title;        /**<   帖子标题 */
@property (nonatomic, copy) NSString *content;      /**<   帖子详情 */
@property (nonatomic, copy) NSArray <NSString *>*contentPic;   /**<   帖子图片 */
@property (nonatomic, copy) NSString *periods;    /**<   期数 */
@property (nonatomic, copy) NSString *createTime;   /**<   创建时间 */
@property (nonatomic, assign) BOOL enable;       /**<    是否可用 */
@property (nonatomic, assign) BOOL isHot;        /**<   是否热门 */
@property (nonatomic, assign) BOOL isLike;       /**<   是否已点赞 */
@property (nonatomic, assign) BOOL isTop;        /**<   是否置顶 '1'是 '0'否 */
@property (nonatomic, assign) BOOL isLhcdocVip;  /**<   作者是否V认证 1是 0否 */
@property (nonatomic, assign) BOOL hasPay;       /**<   是否已消费帖子 1是 0否 */
@property (nonatomic, assign) double price;        /**<   帖子价格 */
@property (nonatomic, assign) NSInteger likeNum;      /**<   点赞数 */
@property (nonatomic, assign) NSInteger viewNum;      /**<   阅读数 */
@property (nonatomic, assign) NSInteger replyCount;   /**<   回复数 */


// 《获取帖子详情》
// c=lhcdoc&a=contentDetail
//@property (nonatomic, copy) NSString *id;         /**<   帖子ID */
//@property (nonatomic, copy) NSString *uid;        /**<   作者ID */
//@property (nonatomic, copy) NSString *nickname;   /**<   作者昵称 */
//@property (nonatomic, copy) NSString *headImg;    /**<   作者头像 */
//@property (nonatomic, copy) NSString *title;      /**<   帖子标题 */
//@property (nonatomic, copy) NSString *content;    /**<   帖子内容 */
//@property (nonatomic, copy) NSString *contentPic; /**<   帖子图片内容 */
//@property (nonatomic, copy) NSString *periods;    /**<   期数 */
@property (nonatomic, copy) NSString *topAdPc;      /**<   pc端顶部广告 */
@property (nonatomic, copy) NSString *bottomAdPc;   /**<   pc端底部广告 */
@property (nonatomic, copy) NSString *topAdWap;     /**<   手机端顶部广告 */
@property (nonatomic, copy) NSString *bottomAdWap;  /**<   手机端底部广告 */
@property (nonatomic, copy) NSString *vote;         /**<   如果不是投票类型的帖子时，为null； 否则为数组 */
//@property (nonatomic, assign) double price;      /**<   帖子价格 */
//@property (nonatomic, assign) BOOL isLike;     /**<   是否已点赞 1是 0否 */
//@property (nonatomic, assign) BOOL hasPay;     /**<   是否已支付 1是 0否 */
//@property (nonatomic, assign) BOOL isHot;      /**<   是否热门 1是 0否 */
@property (nonatomic, assign) BOOL isFav;        /**<   是否收藏 1是 0否 */
@property (nonatomic, assign) BOOL isFollow;     /**<   是否关注 1是 0否 */
@property (nonatomic, assign) BOOL isLhcdoVip;   /**<   作者是否V认证 1是 0否 */
//@property (nonatomic, copy) NSString *createTime; /**<   文章创建时间 */
//@property (nonatomic, assign) NSInteger replyCount; /**<   评论数 */
//@property (nonatomic, assign) NSInteger likeNum;    /**<   点赞数 */
//@property (nonatomic, assign) NSInteger viewNum;    /**<   阅读数 */


// 《我的历史帖子》
// c=lhcdoc&a=historyContent
//@property (nonatomic, copy) NSString *cid;        /**<   帖子ID */
//@property (nonatomic, copy) NSString *alias;      /**<    栏目别名 */
//@property (nonatomic, copy) NSString *uid;        /**<   用户ID */
//@property (nonatomic, copy) NSString *nickname;   /**<   昵称 */
//@property (nonatomic, copy) NSString *headImg;    /**<   头像 */
//@property (nonatomic, copy) NSString *title;      /**<   帖子标题 */
//@property (nonatomic, copy) NSString *content;    /**<   帖子详情 */
//@property (nonatomic, copy) NSString *contentPic; /**<   帖子图片 */
//@property (nonatomic, copy) NSString *periods;  /**<   期数 */
//@property (nonatomic, copy) NSString *createTime; /**<   创建时间 */
//@property (nonatomic, assign) BOOL enable;       /**<    是否可用 */
//@property (nonatomic, assign) BOOL isHot;      /**<   是否热门 */
//@property (nonatomic, assign) BOOL isLike;     /**<   是否已点赞 */
//@property (nonatomic, assign) BOOL isTop;      /**<   是否置顶 '1'是 '0'否 */
//@property (nonatomic, assign) BOOL isLhcdocVip;/**<   作者是否V认证 1是 0否 */
//@property (nonatomic, assign) BOOL hasPay;     /**<   是否已消费帖子 1是 0否 */
//@property (nonatomic, assign) double price;      /**<   帖子价格 */
//@property (nonatomic, assign) NSInteger likeNum;    /**<   点赞数 */
//@property (nonatomic, assign) NSInteger viewNum;    /**<   阅读数 */
//@property (nonatomic, assign) NSInteger replyCount; /**<   回复数 */


// 《关注帖子列表》
// c=lhcdoc&a=favContentList
//@property (nonatomic, copy) NSString *cid;        /**<   帖子ID */
//@property (nonatomic, copy) NSString *alias;      /**<    栏目别名 */
//@property (nonatomic, copy) NSString *uid;        /**<   用户ID */
//@property (nonatomic, copy) NSString *nickname;   /**<   昵称 */
//@property (nonatomic, copy) NSString *headImg;    /**<   头像 */
//@property (nonatomic, copy) NSString *title;      /**<   帖子标题 */
//@property (nonatomic, copy) NSString *content;    /**<   帖子详情 */
//@property (nonatomic, copy) NSString *contentPic; /**<   帖子图片 */
//@property (nonatomic, copy) NSString *periods;  /**<   期数 */
//@property (nonatomic, copy) NSString *createTime; /**<   创建时间 */
//@property (nonatomic, assign) BOOL enable;       /**<    是否可用 */
//@property (nonatomic, assign) BOOL isHot;      /**<   是否热门 */
//@property (nonatomic, assign) BOOL isLike;     /**<   是否已点赞 */
//@property (nonatomic, assign) BOOL isTop;      /**<   是否置顶 '1'是 '0'否 */
//@property (nonatomic, assign) BOOL isLhcdocVip;/**<   作者是否V认证 1是 0否 */
//@property (nonatomic, assign) BOOL hasPay;     /**<   是否已消费帖子 1是 0否 */
//@property (nonatomic, assign) double price;      /**<   帖子价格 */
//@property (nonatomic, assign) NSInteger likeNum;    /**<   点赞数 */
//@property (nonatomic, assign) NSInteger viewNum;    /**<   阅读数 */
//@property (nonatomic, assign) NSInteger replyCount; /**<   回复数 */


// ————————————————————————————
// 自定义参数
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) BOOL isShowAll;           /**<    是否显示全文 */
@property (nonatomic, assign) BOOL showAllButtonHidden; /**<    是否显示‘全文按钮’ */
@end

NS_ASSUME_NONNULL_END
