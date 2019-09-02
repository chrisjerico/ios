//
//  UGLoginAddressModel.h
//  ug
//
//  Created by ug on 2019/7/12.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UGLoginAddressModel <NSObject>

@end
@interface UGLoginAddressModel : UGModel<UGLoginAddressModel>

@property (nonatomic, strong) NSString *addressId;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *city;

@end

NS_ASSUME_NONNULL_END
