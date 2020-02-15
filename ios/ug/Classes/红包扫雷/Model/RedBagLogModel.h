//
//  RedBagLogModel.h
//  ug
//
//  Created by ug on 2020/2/15.
//  Copyright © 2020 ug. All rights reserved.
//  operate   | false | int       | 操作类型1-发送红包，2-抢红包，3-过期退回，4-踩雷赔付，5-获得赔付，6-幸运奖励，7-多雷奖励 |
//"id": "6856",
//     "uid": "63408",
//     "createTime": "1580885856",
//     "redBagId": "1850",
//     "genre": "2",
//     "operate": "3",
//     "amount": "8.00",
//     "genreText": "扫雷红包",
//     "operateText": "过期"

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RedBagLogModel : UGModel
@property (nonatomic, strong) NSString *rid;//==》id
@property (nonatomic, strong) NSString *uid;//
@property (nonatomic, strong) NSString *createTime;// 创建时间
@property (nonatomic, strong) NSString *redBagId;//
@property (nonatomic, strong) NSString *genre;//
@property (nonatomic, strong) NSString *operate;//操作类型1-发送红包，2-抢红包，3-过期退回，4-踩雷赔付，5-获得赔付，6-幸运奖励，7-多雷奖励 |
@property (nonatomic, strong) NSString *amount;//
@property (nonatomic, strong) NSString *genreText;//
@property (nonatomic, strong) NSString *operateText;//类型
@end

NS_ASSUME_NONNULL_END
