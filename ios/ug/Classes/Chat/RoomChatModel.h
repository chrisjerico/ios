//
//  RoomChatModel.h
//  UGBWApp
//
//  Created by ug on 2020/3/12.
//  Copyright © 2020 ug. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RoomChatModel : UGModel
@property (nonatomic) int sortId;         /**<   排序 */
@property (nonatomic, strong) NSString *roomName;       /**<   房间名 */
@property (nonatomic, strong) NSString *password;       /**<  密码 */
@property (nonatomic, strong) NSString *roomId;       /**<  密码 */
@property (nonatomic, strong) NSString *typeId;       /**<   */
@end

NS_ASSUME_NONNULL_END
