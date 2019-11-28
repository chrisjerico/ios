//
//  UGLHPostCommentModel.h
//  ug
//
//  Created by fish on 2019/11/29.
//  Copyright © 2019 ug. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGLHPostCommentModel : NSObject

// 《获取评论列表》
// c=lhcdoc&a=contentReplyList
@property (nonatomic, copy) NSString *id;/**<   评论ID */
@property (nonatomic, copy) NSString *uid;/**<   发起评论的用户ID */
@property (nonatomic, copy) NSString *headImg;/**<   评论用户头像 */
@property (nonatomic, copy) NSString *content;/**<   内容 */
@property (nonatomic, copy) NSString *actionTime;/**<   评论时间 */
@property (nonatomic, copy) NSString *replyCount;/**<   回复数 */
@property (nonatomic, copy) NSString *likeNum;/**<   点赞数 */
@property (nonatomic, copy) NSString *isLike;/**<   是否已点赞 1是 0否 */

@end

NS_ASSUME_NONNULL_END
