//
//  UGdepositStatModel.h
//  ug
//
//  Created by ug on 2019/9/9.
//  Copyright © 2019 ug. All rights reserved.
//  "date": "2019-09-09",
//"level": 0,
//"amount": "0.00",
//"member": 0
//http://test10.6yc.com/wjapp/api.php?c=team&a=depositStat&token=fJJWVq81cwzjWrVDcjZdSSR1&page=1&rows=20
#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGdepositStatModel : UGModel
@property (nonatomic, strong) NSNumber *level;  /**<   等级 */
@property (nonatomic, strong) NSString *date;   /**<   日期 */
@property (nonatomic, strong) NSString *amount; /**<   存款金额 */
@property (nonatomic, strong) NSNumber *member; /**<   存款人数 */
@end

NS_ASSUME_NONNULL_END
