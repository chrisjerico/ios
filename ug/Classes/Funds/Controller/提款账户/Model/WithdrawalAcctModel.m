//
//  WithdrawalAcctModel.m
//  UGBWApp
//
//  Created by fish on 2020/10/7.
//  Copyright © 2020 ug. All rights reserved.
//

#import "WithdrawalAcctModel.h"


@implementation WithdrawalAcctModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"wid":@"id"};
}

- (NSString *)minWithdrawMoney {
    return [_minWithdrawMoney removeFloatAllZero];
}

- (NSString *)maxWithdrawMoney {
    return _maxWithdrawMoney.doubleValue < 0.01 ? @"不限" : [_maxWithdrawMoney removeFloatAllZero];
}

@end


@implementation WithdrawalTypeModel

- (void)setData:(NSArray<WithdrawalAcctModel *> *)data {
    if ([data.firstObject isKindOfClass:[NSDictionary class]]) {
        NSMutableArray *temp = @[].mutableCopy;
        for (NSDictionary *dict in data) {
            [temp addObject:[WithdrawalAcctModel mj_objectWithKeyValues:dict]];
        }
        _data = [temp copy];
    } else {
        _data = data;
    }
}

- (BOOL)canAdd {
    if (_canAdd) return _canAdd;
    if (_ismore)
        return _data.count < 10;
    else
        return _data.count < 1;
}

@end

