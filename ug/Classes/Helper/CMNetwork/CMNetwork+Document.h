//
//  CMNetwork+Document.h
//  ug
//
//  Created by xionghx on 2019/9/27.
//  Copyright © 2019 ug. All rights reserved.
//


#import "CMNetwork.h"
#import "UGDocumentVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMNetwork (Document)
+ (void)getDocumnetListWithParams:(NSDictionary *)params
					   completion:(CMNetworkBlock)completionBlock;


+ (void)getDocumnetDetailWithParams:(NSDictionary *)params
						 completion:(CMNetworkBlock)completionBlock;

+ (void)getDocumnetPayWithParams:(NSDictionary *)params
					  completion:(CMNetworkBlock)completionBlock;

@end

NS_ASSUME_NONNULL_END
