//
//  UGRedEnvelopeModel.h
//  ug
//
//  Created by ug on 2019/9/17.
//  Copyright © 2019 ug. All rights reserved.
//
//id: 红包活动ID
//intro：活动介绍
//isTest：是否带玩用户
//hasLogin：是否已登录
//username：用户名
//isHideAmount：是否隐藏红包金额
//isHideCount：是否隐藏剩余红包数量
//leftAmount：剩余红包金额
//leftCount：剩余红包数量
//attendedTimes：用户已领取次数
//attendTimeLimit：活动限制领取次数
#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol UGRedEnvelopeModel <NSObject>

@end
// 红包详情
// {{TEST_HOST}}?c=activity&a=redBagDetail&token={{TOKEN}}
@interface UGRedEnvelopeModel : UGModel<UGRedEnvelopeModel>
@property (nonatomic, strong) NSString *name;       /**<   活动标题 */
@property (nonatomic, strong) NSString *start;      /**<   活动开始时间 */
@property (nonatomic, strong) NSString *end;        /**<   活动结束时间 */
@property (nonatomic, strong) NSString *show_time;  /**<   活动显示时间，时间不到则不显示 */
@property (nonatomic, assign) BOOL isTest;          /**<   是否带玩用户 */
@property (nonatomic, assign) BOOL hasLogin;        /**<   是否已登录 */

@property (nonatomic, assign) BOOL canGet;          /**<   是否可以领红包 1可以 0不可以 */

@property (nonatomic, strong) NSString *username;   /**<   用户名 */
@property (nonatomic, strong) NSString *intro;      /**<   活动介绍 */
@property (nonatomic, strong) NSString *leftCount;  /**<   剩余红包数量 */
@property (nonatomic, strong) NSString *leftAmount; /**<   剩余红包金额 */
@property (nonatomic, strong) NSString *redBagLogo; /**<   红包Logo图片地址 */
@property (nonatomic, strong) NSString *rid;        /**<   红包活动ID */


@end

NS_ASSUME_NONNULL_END
