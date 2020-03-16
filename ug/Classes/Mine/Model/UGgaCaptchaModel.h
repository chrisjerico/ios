//
//  UGgaCaptchaModel.h
//  ug
//
//  Created by ug on 2019/9/25.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGgaCaptchaModel : UGModel
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *secret;
@property (nonatomic, strong) NSString *qrcode;//
@end

NS_ASSUME_NONNULL_END
