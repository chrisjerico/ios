//
//  UGChatRoomModel.h
//  ug
//
//  Created by ug on 2020/1/7.
//  Copyright © 2020 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ChatRedBagSettingModel <NSObject>

@end

@interface ChatRedBagSettingModel : UGModel <ChatRedBagSettingModel>
@property (nonatomic, strong) NSString *maxAmount;         /**<   房间id */
@property (nonatomic, strong) NSString *minAmount;       /**<   房间名 */
@property (nonatomic, strong) NSString *maxQuantity;       /**<  密码 */
@property (nonatomic)  int  isRedBag;                      /**<   */
@end



@interface UGChatRoomModel : UGModel
@property (nonatomic, strong) NSString *roomId;         /**<   房间id */
@property (nonatomic, strong) NSString *roomName;       /**<   房间名 */
@property (nonatomic, strong) NSString *password;       /**<  密码 */
@property (nonatomic, strong) NSString *typeId;         /**<   游戏id */
@property (nonatomic)  BOOL isChatBan;                   /**<   */
@property (nonatomic)  int  sortId;                      /**<   */
@property (nonatomic, strong) ChatRedBagSettingModel *chatRedBagSetting;       /**<  */
@end

NS_ASSUME_NONNULL_END
