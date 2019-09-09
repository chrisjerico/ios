//
//  UGdepositListModel.h
//  ug
//
//  Created by ug on 2019/9/9.
//  Copyright © 2019 ug. All rights reserved.
//
//"username": "ceshi4",
//"level": 3,
//"date": "2019-09-02",
//"amount": "2000.00"
//#import "UGModel.h"
//http://test10.6yc.com/wjapp/api.php?c=team&a=depositList&token=fJJWVq81cwzjWrVDcjZdSSR1&page=1&rows=20
NS_ASSUME_NONNULL_BEGIN

@interface UGdepositListModel : UGModel
@property (nonatomic, strong) NSNumber *level;//等级
@property (nonatomic, strong) NSString *date;//日期
@property (nonatomic, strong) NSString *amount;//存款金额
@property (nonatomic, strong) NSString *username;//用户名
@end

NS_ASSUME_NONNULL_END
