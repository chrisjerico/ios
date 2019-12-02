//
//  LHUserModel.h
//  ug
//
//  Created by fish on 2019/12/2.
//  Copyright © 2019 ug. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LHUserModel : NSObject
@property (nonatomic, copy) NSString *nickname;         /**<   昵称 */
@property (nonatomic, copy) NSString *face;             /**<   头像 */
@property (nonatomic, copy) NSString *levelName;        /**<   vip级别 */
@property (nonatomic, copy) NSString *missionLevel;     /**<   会员级别 */
@property (nonatomic, assign) BOOL isLhcdocVip;         /**<   是否是六合文档的VIP */
@property (nonatomic, assign) BOOL isFollow;            /**<   是否已关注 */
@property (nonatomic, assign) NSInteger likeNum;        /**<   点赞数量 */
@property (nonatomic, assign) NSInteger followNum;      /**<   关注数量 */
@property (nonatomic, assign) NSInteger contentNum;     /**<   发布帖子数量 */
@property (nonatomic, assign) NSInteger fansNum;        /**<   粉丝数量 */
@property (nonatomic, assign) NSInteger favContentNum;  /**<   收藏帖子数量 */
@end

NS_ASSUME_NONNULL_END
