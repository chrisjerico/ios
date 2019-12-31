//
//  CMNetwork+Document.m
//  ug
//
//  Created by xionghx on 2019/9/27.
//  Copyright © 2019 ug. All rights reserved.
//

#import "CMNetwork+Document.h"
#import "UGDocumentDetailVC.h"


@implementation CMNetwork (Document)


//获取文档列表数据
+ (void)getDocumnetListWithParams:(NSDictionary *)params completion:(CMNetworkBlock)completionBlock {
	
	CMMETHOD_BEGIN;
	
	[self.manager requestInMainThreadWithMethod:[getDocumentListUrl stringToRestfulUrlWithFlag:RESTFUL]
										 params:params
										  model:CMResultClassMake(DocumentListModel.class)
										   post:NO
									 completion:completionBlock];
	
	CMMETHOD_END;
}

//获取文档
+ (void)getDocumnetDetailWithParams:(NSDictionary *)params
						 completion:(CMNetworkBlock)completionBlock {
	
	
	CMMETHOD_BEGIN;
	
	[self.manager requestInMainThreadWithMethod:[getDocumentDetailUrl stringToRestfulUrlWithFlag:RESTFUL]
										 params:params
										  model:CMResultClassMake(UGDocumentDetailData.class)
										   post:NO
									 completion:completionBlock];
	
	CMMETHOD_END;
	
	
}
//打赏文档
+ (void)getDocumnetPayWithParams:(NSDictionary *)params
					  completion:(CMNetworkBlock)completionBlock {
	
	
	CMMETHOD_BEGIN;
	
	[self.manager requestInMainThreadWithMethod:[getDocumentPayUrl stringToRestfulUrlWithFlag:RESTFUL]
										 params:params
										  model:CMResultClassMake(nil)
										   post:YES
									 completion:completionBlock];
	
	CMMETHOD_END;
	
	
}


@end
