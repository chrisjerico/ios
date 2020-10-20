//
//  CMNetwork+Upload.h
//  UGBWApp
//
//  Created by xionghx on 2020/10/18.
//  Copyright © 2020 ug. All rights reserved.
//

#import "CMNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMNetwork (Upload)

//上传身份证
+ (void)uploadIdentityWithParams:(NSDictionary *)params image: (UIImage *)image completion:(CMNetworkBlock)completionBlock;
//申请找回资金密码
+ (void)applyFundPwWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock;

@end

NS_ASSUME_NONNULL_END
