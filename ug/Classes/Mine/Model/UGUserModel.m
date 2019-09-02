
//
//  UGUserModel.m
//  ug
//
//  Created by ug on 2019/5/4.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGUserModel.h"


#define filePath  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"ugGameUserModel"]

UGUserModel * g_currentUser = nil;

@implementation UGUserModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"uid":@"userId",
                                                       @"API-SID":@"sessid",
                                                       @"API-TOKEN":@"token",
                                                       @"usr":@"username"
                                                       }];
}
//添加了下面的宏定义
MJExtensionCodingImplementation

+ (instancetype)currentUser {
    
    if (g_currentUser == nil) {
        //解档
        UGUserModel *decodedUser = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        g_currentUser = decodedUser;
    }
    
    return g_currentUser;
}

+ (void)setCurrentUser:(UGUserModel *)user {
    g_currentUser = user;
    //归档
    [NSKeyedArchiver archiveRootObject:user toFile:filePath];
    
}

@end
