//
//  UGAddressListModel.h
//  ug
//
//  Created by ug on 2019/7/13.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UGAddressModel <NSObject>

@end
@interface UGAddressModel : UGModel<UGAddressModel>

@property (nonatomic, strong) NSString *name;

@end


@protocol UGAddressListModel <NSObject>

@end
@interface UGAddressListModel : UGModel<UGAddressListModel>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray<UGAddressModel> *city;

@end

NS_ASSUME_NONNULL_END
