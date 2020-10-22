//
//  CMNetwork+Upload.m
//  UGBWApp
//
//  Created by xionghx on 2020/10/18.
//  Copyright © 2020 ug. All rights reserved.
//

#import "CMNetwork+Upload.h"
#import "URLModel.h"

@implementation CMNetwork (Upload)
//上传身份证
+ (void)uploadIdentityWithParams:(NSDictionary *)params image: (UIImage *)image completion:(CMNetworkBlock)completionBlock {
	CMMETHOD_BEGIN;
	
	[self.manager uploadFileWithRequestUrl:	[uploadIdentityUrl stringToRestfulUrlWithFlag:RESTFUL]
									  data: UIImageJPEGRepresentation(image, 0.1)
								  fileName:	@"files"
									params:	params
									 model:	CMResultClassMake(URLModel.class)
								completion:	completionBlock ];
	CMMETHOD_END;
	
}

//申请找回资金密码
+ (void)applyFundPwWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
	
	CMMETHOD_BEGIN;
	
	[self.manager requestInMainThreadWithMethod:[applyFundPwdUrl stringToRestfulUrlWithFlag:RESTFUL]
										 params:params
										  model:CMResultClassMake(nil)
										   post:YES
									 completion:completionBlock];
	
	CMMETHOD_END;
}
@end
