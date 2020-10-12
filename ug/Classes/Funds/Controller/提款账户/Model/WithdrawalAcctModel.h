//
//  WithdrawalAcctModel.h
//  UGBWApp
//
//  Created by fish on 2020/10/7.
//  Copyright © 2020 ug. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface WithdrawalAcctModel : NSObject

@property (nonatomic, copy) NSString *wid;        /**<   账户id */
@property (nonatomic, copy) NSString *uid;        /**<   用户ID */
@property (nonatomic, assign) UGWithdrawalType type;        /**<   账户类型 */
@property (nonatomic, copy) NSString *bankId;               /**<   银行卡ID */
@property (nonatomic, copy) NSString *bankName;             /**<   银行 */
@property (nonatomic, copy) NSString *bankCode;             /**<   银行代码 */
@property (nonatomic, copy) NSString *bankBackgroundImage;  /**<   银行背景图 */
@property (nonatomic, copy) NSString *ownerName;            /**<   真实姓名 */
@property (nonatomic, copy) NSString *bankCard;             /**<   银行卡号 */
@property (nonatomic, copy) NSString *bankAddr;             /**<   开户地址 */

// 自定义参数
@property (nonatomic, copy) NSString *name;
@end



@interface WithdrawalTypeModel : NSObject

@property (nonatomic, assign) UGWithdrawalType type;        /**<   账户类型 */
@property (nonatomic, assign) BOOL ismore;      /**<   是否允许多账号 */
@property (nonatomic, assign) BOOL isshow;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray <WithdrawalAcctModel *>*data;

@property (nonatomic, assign) BOOL canAdd;
@end

NS_ASSUME_NONNULL_END
