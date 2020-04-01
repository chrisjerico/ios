
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
    
    if (user.token.length && [user.token isEqualToString:g_currentUser.token]) {
        Class cls = [UGUserModel class];
        while (cls != [NSObject class]) {
            for (NSString *key in [cls ivarList]) {
                id value = [user valueForKey:key];
                if (value)
                    [g_currentUser setValue:value forKey:key];
            }
            cls = [cls superclass];
        }
    } else {
        g_currentUser = user;
    }
    
    if (TabBarController1) {
        [TabBarController1 setUGMailBoxTableViewControllerBadge];
    }
    //归档
    [NSKeyedArchiver archiveRootObject:user toFile:filePath];
}

- (BOOL)isAgent {
    return _isTest ? true : _isAgent;
}

@end
