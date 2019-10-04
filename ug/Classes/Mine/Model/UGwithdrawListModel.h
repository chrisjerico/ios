//
//  UGwithdrawListModel.h
//  ug
//
//  Created by ug on 2019/9/9.
//  Copyright © 2019 ug. All rights reserved.
//
//"username": "ceshi2",
//"level": 1,
//"date": "2019-08-29",
//"amount": "10.00"
#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGwithdrawListModel : UGModel
@property (nonatomic, strong) NSNumber *level;      /**<   等级 */
@property (nonatomic, strong) NSString *date;       /**<   日期 */
@property (nonatomic, strong) NSString *amount;     /**<   提款金额 */
@property (nonatomic, strong) NSString *username;   /**<   用户名 */
@end

NS_ASSUME_NONNULL_END
