//
//  PathDefine.h
//  AutoPacking
//
//  Created by fish on 2019/12/12.
//  Copyright © 2019 fish. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN
//#import "SiteModel.h"

#define Path [PathDefine shared]

@interface PathDefine : NSObject

@property (nonatomic, readonly) NSString *username;

@property (nonatomic, readonly) NSString *projectDir;
@property (nonatomic, readonly) NSString *exportDir;
@property (nonatomic, readonly) NSString *shellDir;
@property (nonatomic, readonly) NSString *log;

@property (nonatomic, readonly) NSString *tempPlist;
@property (nonatomic, readonly) NSString *tempIpa;
@property (nonatomic, readonly) NSString *tempXcarchive;
@property (nonatomic, readonly) NSString *tempCiphertext;
@property (nonatomic, readonly) NSString *tempCommitId;

+ (instancetype)shared;
@end




@interface SiteModel (Helper)

@property (nonatomic, readonly) NSString *ipaPath;
@property (nonatomic, readonly) NSString *plistPath;
@property (nonatomic, readonly) NSString *xcarchivePath;
@end



NS_ASSUME_NONNULL_END
