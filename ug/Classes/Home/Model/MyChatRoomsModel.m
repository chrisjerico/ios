//
//  MyChatRoomsModel.m
//  UGBWApp
//
//  Created by ug on 2020/9/15.
//  Copyright © 2020 ug. All rights reserved.
//

#import "MyChatRoomsModel.h"

#define chatRoomfilePath  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"MyChatRoomsModel"]
MyChatRoomsModel *currentRoom= nil;

@implementation MyChatRoomsModel

MJExtensionCodingImplementation

+ (instancetype)currentRoom {
    if (!currentRoom)
        currentRoom = [NSKeyedUnarchiver unarchiveObjectWithFile:chatRoomfilePath];
    return currentRoom;
}

+ (void)setCurrentRoom:(MyChatRoomsModel *)config{
    currentRoom = config;
    [NSKeyedArchiver archiveRootObject:config toFile:chatRoomfilePath];
}

@end
