//
//  UGLHPostCommentModel.h
//  ug
//
//  Created by fish on 2019/11/29.
//  Copyright © 2019 ug. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UGLHPostModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UGLHPostCommentModel : NSObject

// 《获取评论列表》
// c=lhcdoc&a=contentReplyList
@property (nonatomic, copy) NSString *pid;/**<   评论ID */
@property (nonatomic, copy) NSString *uid;/**<   发起评论的用户ID */
@property (nonatomic, copy) NSString *nickname; /**<   用户昵称 */
@property (nonatomic, copy) NSString *headImg;/**<   评论用户头像 */
@property (nonatomic, copy) NSString *content;/**<   内容 */
@property (nonatomic, copy) NSString *actionTime;/**<   评论时间 */
@property (nonatomic, assign) NSInteger replyCount;/**<   回复数 */
@property (nonatomic, assign) NSInteger likeNum;/**<   点赞数 */
@property (nonatomic, assign) BOOL isLike;/**<   是否已点赞 1是 0否 */


// 自定义参数
@property (nonatomic, copy) NSString *cid;  /**<   帖子ID */

@property (nonatomic, copy) NSArray<UGLHPostModel *> *secReplyList;    /**<   回复数组 */



@end

NS_ASSUME_NONNULL_END
