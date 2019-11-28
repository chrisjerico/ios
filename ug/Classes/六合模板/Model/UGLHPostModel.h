//
//  UGLHPostModel.h
//  ug
//
//  Created by ug on 2019/11/28.
//  Copyright © 2019 ug. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UGLHPostInfoModel <NSObject>

@end
@interface UGLHPostInfoModel : UGModel<UGLHPostInfoModel>
@property (copy, nonatomic) NSString *cid;/**<   帖子ID" */
@property (copy, nonatomic) NSString *enable;/**<   是否可用" */
@property (copy, nonatomic) NSString *alias;/**<   栏目别名" */
@property (copy, nonatomic) NSString *uid;/**<   用户ID" */
@property (copy, nonatomic) NSString *nickname;/**<   昵称" */
@property (copy, nonatomic) NSString *headImg;/**<   头像" */
@property (copy, nonatomic) NSString *title;/**<   帖子标题" */
@property (copy, nonatomic) NSString *content;/**<   帖子详情" */

@property (copy, nonatomic) NSArray *contentPic;/**<   帖子图片" */
@property ( nonatomic) BOOL isHot;/**<   是否热门" */
@property (copy, nonatomic) NSString *likeNum;/**<  点赞数" */
@property (copy, nonatomic) NSString *viewNum;/**<   阅读数 " */
@property (copy, nonatomic) NSString *isLike;/**<   是否已点赞" */
@property (copy, nonatomic) NSString *createTime;/**<   创建时间" */

@property (copy, nonatomic) NSString *replyCount;/**<   回复数" */
@property (copy, nonatomic) NSString *isTop;/**<   是否置顶 '1'是 '0'否" */
@property (copy, nonatomic) NSString *price;/**<   帖子价格" */
@property (nonatomic) int isLhcdocVip;/**<   作者是否V认证 1是 0否" */
@property (copy, nonatomic) NSString *hasPay;/**<   是否已消费帖子 1是 0否" */
//@property (copy, nonatomic) NSString *periods;/**<   回复数" */
@end

@protocol UGLHPostModel <NSObject>

@end
@interface UGLHPostModel : UGModel<UGLHPostModel>
@property (strong, nonatomic) NSArray<UGLHPostInfoModel *>*list;/**<   " */
@end

NS_ASSUME_NONNULL_END
