//
//  UGdepositModel.m
//  ug
//
//  Created by ug on 2019/9/10.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGdepositModel.h"


@implementation UGdepositModel



@end

@implementation UGrechargeBankModel

@end

@implementation UGparaModel

@end

@implementation UGchannelModel
+ (JSONKeyMapper *)keyMapper {
    
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"pid"
                                                       }];
}

- (NSString *)currencyRate {
    return [_currencyRate isEqualToString:@"0"] && [_domain.lowercaseString.stringByTrim isEqualToString:@"cgp"] ? @"1" : _currencyRate;
}
@end

@implementation UGpaymentModel

+ (JSONKeyMapper *)keyMapper {
    
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"pid"
                                                       }];
}

@end

