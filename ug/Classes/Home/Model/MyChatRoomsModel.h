//
//  MyChatRoomsModel.h
//  UGBWApp
//
//  Created by ug on 2020/9/15.
//  Copyright © 2020 ug. All rights reserved.
//

#import "UGModel.h"
#import "UGChatRoomModel.h"
NS_ASSUME_NONNULL_BEGIN
#define SysChatRoom [MyChatRoomsModel currentRoom]


@interface MyChatRoomsModel : UGModel
@property (nonatomic,strong) NSMutableArray<UGChatRoomModel *> *chatRoomAry;                    /**<    在线配置的聊天室i*/
@property (nonatomic,strong) UGChatRoomModel *defaultChatRoom;                                  /**<    默认的聊天室（取列表的第1条数据）i*/
@property (nonatomic) NSInteger chatRoomRedirect;           /**<   1=强制跳转至彩种对应聊天室, 0=跳转至上一次退出的聊天室 */

+ (instancetype)currentRoom;

+ (void)setCurrentRoom:(MyChatRoomsModel *)config;
@end


NS_ASSUME_NONNULL_END
