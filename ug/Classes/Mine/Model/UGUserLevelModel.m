//
//  UGUserLevelModel.m
//  ug
//
//  Created by ug on 2019/6/4.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGUserLevelModel.h"
#define filePath  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"ugGameUserLevelModel"]

UGUserLevelModel * g_currentLevel = nil;
@implementation UGUserLevelModel

//添加了下面的宏定义
MJExtensionCodingImplementation

+ (instancetype)currentLevel {
    
    if (g_currentLevel == nil) {
        //解档
        UGUserLevelModel *decodedUser = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        
        g_currentLevel = decodedUser;
    }
    
    return g_currentLevel;
}

+ (void)setCurrentLevel:(UGUserLevelModel *)user {
    g_currentLevel = user;
    //归档
    [NSKeyedArchiver archiveRootObject:user toFile:filePath];
    
}
@end
