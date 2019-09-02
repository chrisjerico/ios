
//
//  UGSystemConfigModel.m
//  ug
//
//  Created by ug on 2019/7/23.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGSystemConfigModel.h"

#define filePath  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"UGSystemConfigModel"]

UGSystemConfigModel * currentConfig = nil;

@implementation UGSystemConfigModel
//添加了下面的宏定义
MJExtensionCodingImplementation

+ (instancetype)currentConfig {
    
    if (currentConfig == nil) {
        //解档
        UGSystemConfigModel *decodedUser = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        
        currentConfig = decodedUser;
    }
    
    return currentConfig;
}

+ (void)setCurrentConfig:(UGSystemConfigModel *)user {
    currentConfig = user;
    //归档
    [NSKeyedArchiver archiveRootObject:user toFile:filePath];
    
}

@end

