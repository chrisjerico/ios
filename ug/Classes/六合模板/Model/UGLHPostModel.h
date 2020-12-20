//
//  UGLHPostModel.h
//  ug
//
//  Created by ug on 2019/11/28.
//  Copyright © 2019 ug. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYWebImage.h"

NS_ASSUME_NONNULL_BEGIN

// 帖子广告Model
@interface LHPostAdModel : NSObject
@property (nonatomic, copy) NSString *aid;           /**<   广告ID */
@property (nonatomic, copy) NSString *addTime;      /**<   添加时间 */
@property (nonatomic, copy) NSString *cid;          /**<   帖子ID */
@property (nonatomic, copy) NSString *pic;          /**<   图片 */
@property (nonatomic, copy) NSString *position;     /**<   位置 */
@property (nonatomic, copy) NSString *link;         /**<   跳转链接 */
@property (nonatomic, assign) BOOL isShow;       /**<   是否显示 */
@property (nonatomic, assign) NSInteger targetType;   /**<   跳转方式：1本窗口 2 新窗口 */
@end


// 帖子投票Model（生肖）
@interface LHVoteModel : NSObject
@property (nonatomic, copy) NSString *animalFlag;   /**<   生肖ID */
@property (nonatomic, copy) NSString *animal;       /**<   标题 */
@property (nonatomic, assign) NSInteger num;        /**<   票数 */
@property (nonatomic, assign) NSInteger percent;    /**<   百分比 */

// 自定义参数
@property (nonatomic, assign) BOOL selected;
@end







// 帖子Model
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
@property (nonatomic, copy) NSString *baoma_type;   /**<   解码器类型（香港六合彩，澳门六合彩） */
@property (copy, nonatomic) NSString *read_pri; /**<   可浏览会员类型：0是全部  1是正式会员 */
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
//@property (nonatomic, copy) NSString *alias;      /**<   帖子所属栏目的别名 */
@property (nonatomic, copy) LHPostAdModel *topAdPc;      /**<   pc端顶部广告 */
@property (nonatomic, copy) LHPostAdModel *bottomAdPc;   /**<   pc端底部广告 */
@property (nonatomic, copy) LHPostAdModel *topAdWap;     /**<   手机端顶部广告 */
@property (nonatomic, copy) LHPostAdModel *bottomAdWap;  /**<   手机端底部广告 */
@property (nonatomic, copy) NSArray <LHVoteModel *>*vote;         /**<   如果不是投票类型的帖子时，为null； 否则为数组 */
//@property (nonatomic, assign) double price;      /**<   帖子价格 */
//@property (nonatomic, assign) BOOL isLike;     /**<   是否已点赞 1是 0否 */
//@property (nonatomic, assign) BOOL hasPay;     /**<   是否已支付 1是 0否 */
//@property (nonatomic, assign) BOOL isHot;      /**<   是否热门 1是 0否 */
@property (nonatomic, assign) BOOL isFav;        /**<   是否收藏 1是 0否 */
@property (nonatomic, assign) BOOL isBigFav;     /**<   图库是否收藏 1是 0否 */
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
@property (nonatomic, copy) NSString *type;     /**<   栏目ID */
@property (nonatomic, copy) NSString *type2;    /**<   资料ID */
@property (nonatomic, copy) NSArray<UGLHPostModel *> *secReplyList;    /**<   回复数组 */
@property (nonatomic, copy) NSString *link;    /**<   分栏链接，用来判断是否加载解码器  根据 mystery/   */

// ————————————————————————————
// 自定义参数
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, readonly) NSString *categoryType; /**<   类型 */

+ (NSString *)keyWithImage:(__kindof UIImage *)image;
+ (YYImage *)imageWithKey:(NSString *)key;
+ (NSArray <YYImage *>*)allEmoji;
@end

NS_ASSUME_NONNULL_END
