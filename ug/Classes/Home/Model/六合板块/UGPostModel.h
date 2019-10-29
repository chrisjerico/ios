//
//  UGPostModel.h
//  ug
//
//  Created by fish on 2019/10/27.
//  Copyright © 2019 ug. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGPostModel : NSObject
// 《获取高手论坛列表（综合、精华、最新）》
// 《获取极品专贴列表（综合、精华、最新）》
// 《获取每期资料列表》
// 《获取公式规律列表》
// mobile/lhcdoc/getcontentlist
@property (nonatomic) NSString *cid;        /**<   栏目ID */
@property (nonatomic) NSString *enable;     /**<   是否可用 */
@property (nonatomic) NSString *alias;      /**<   栏目别名 */
@property (nonatomic) NSString *uid;        /**<   用户ID */
@property (nonatomic) NSString *nickname;   /**<   昵称 */
@property (nonatomic) NSString *headImg;    /**<   头像 */
@property (nonatomic) NSString *title;      /**<   帖子标题 */
@property (nonatomic) NSString *content;    /**<   帖子详情 */
@property (nonatomic) NSString *contentPic; /**<   帖子图片 */
@property (nonatomic) NSString *periods;
@property (nonatomic) NSString *isHot;      /**<   是否热门 */
@property (nonatomic) NSString *likeNum;    /**<   点赞数 */
@property (nonatomic) NSString *viewNum;    /**<   阅读数 */
@property (nonatomic) NSString *isLike;     /**<   是否已点赞 */
@property (nonatomic) NSString *createTime; /**<   创建时间 */
@property (nonatomic) NSString *replyCount; /**<   回复数 */
@property (nonatomic) NSString *isTop;      /**<   是否置顶 '1'是 '0'否 */






@end

NS_ASSUME_NONNULL_END
