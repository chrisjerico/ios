
//
//  UGSystemConfigModel.m
//  ug
//
//  Created by ug on 2019/7/23.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGSystemConfigModel.h"

#define filePath  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"UGSystemConfigModel"]

UGSystemConfigModel *currentConfig = nil;

@implementation UGmobileMenu
+ (instancetype)menu:(NSString *)path :(NSString *)name :(NSString *)icon :(NSString *)selectedIcon :(Class)cls {
    UGmobileMenu *gm = [UGmobileMenu new];
    gm.path = path;
    gm.name = name;
    gm.icon = icon;
    gm.selectedIcon = selectedIcon;
    gm.cls = cls;
    return gm;
}
@end

@implementation UGSystemConfigModel

MJExtensionCodingImplementation

+ (instancetype)currentConfig {
    if (!currentConfig)
        currentConfig = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    return currentConfig;
}

+ (void)setCurrentConfig:(UGSystemConfigModel *)user {
    currentConfig = user;
    [NSKeyedArchiver archiveRootObject:user toFile:filePath];
}

@end

