//
//  UGbankModel.h
//  ug
//
//  Created by ug on 2019/6/21.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UGbankModel <NSObject>

@end
@interface UGbankModel : UGModel<UGbankModel>
@property (nonatomic, strong) NSString *bankId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *logo;
@property (nonatomic, strong) NSString *home;
@property (nonatomic, strong) NSString *sort;
@property (nonatomic, assign) BOOL isDelete;

@end

NS_ASSUME_NONNULL_END
