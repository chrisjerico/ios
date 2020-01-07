//
//  UGChatRoomModel.h
//  ug
//
//  Created by ug on 2020/1/7.
//  Copyright © 2020 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGChatRoomModel : UGModel
@property (nonatomic, strong) NSString *roomId;   /**<   房间id */
@property (nonatomic, strong) NSString *roomName;       /**<   房间名 */
@property (nonatomic, strong) NSString *password;       /**<  密码 */
@property (nonatomic, strong) NSString *typeId; /**<   游戏id */
@end

NS_ASSUME_NONNULL_END
