//
//  UGImgVcodeModel.h
//  ug
//
//  Created by ug on 2019/8/2.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGImgVcodeModel : UGModel
@property (nonatomic, strong) NSString *nc_value;
@property (nonatomic, strong) NSString *nc_token;
@property (nonatomic, strong) NSString *nc_csessionid;
@property (nonatomic, strong) NSString *nc_sig;
@end

NS_ASSUME_NONNULL_END
