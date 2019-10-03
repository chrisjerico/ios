//
//  UGinviteInfoModel.h
//  ug
//
//  Created by ug on 2019/9/8.
//  Copyright © 2019 ug. All rights reserved.
//
//"username": "ugtmac",
//"rid": "2680",
//"uid": "2680",
//"link_i": "http://fh-api.service/?2680",
//"link_r": "http://fh-api.service/?2680&r",
//"fandian_intro": "一级下线:0.00%, 二级下线:0.00%",
//"fanDian": "0.00",
//"month_earn": "0.00",
//"month_member": "一级下线:0, 二级下线:0",
//"total_member": "一级下线:0, 二级下线:0"

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol UGinviteInfoModel <NSObject>

@end
@interface UGinviteInfoModel : UGModel
@property (nonatomic, strong) NSString *username;//
@property (nonatomic, strong) NSString *rid;//
@property (nonatomic, strong) NSString *link_i;         /**<   首页推广地址 */
@property (nonatomic, strong) NSString *link_r;         /**<   注册推广地址 */

@property (nonatomic, strong) NSString *month_earn;     /**<   本月推荐收益 */
@property (nonatomic, strong) NSString *month_member;   /**<   本月推荐会员 */
@property (nonatomic, strong) NSString *total_member;   /**<   推荐会员总计 */


@property (nonatomic, strong) NSString *fandian_intro;  /**<   佣金比例 */

@end

NS_ASSUME_NONNULL_END
