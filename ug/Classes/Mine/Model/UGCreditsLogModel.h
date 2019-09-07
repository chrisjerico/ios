//
//  UGCreditsLogModel.h
//  ug
//
//  Created by ug on 2019/9/7.
//  Copyright © 2019 ug. All rights reserved.
//
//"id": "70",
//"mid": "0",
//"type": "兑换人民币",
//"integral": "-10.00",
//"oldInt": "174.0000",
//"newInt": "164.00",
//"addTime": "2019-09-07 15:17:18"
#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol UGCreditsLogModel <NSObject>

@end
@interface UGCreditsLogModel : UGModel
@property (nonatomic, strong) NSString *greditsLogId;//
@property (nonatomic, strong) NSString *type;//"兑换人民币",
@property (nonatomic, strong) NSString *integral;//"-10.00",
@property (nonatomic, strong) NSString *gnewInt;//"164.00",
@property (nonatomic, strong) NSString *addTime;//2019-09-04


@end

NS_ASSUME_NONNULL_END
