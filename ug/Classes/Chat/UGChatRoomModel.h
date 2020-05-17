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
@property (nonatomic, strong) NSString *maxAmount;         /**<    */
@property (nonatomic, strong) NSString *minAmount;       /**<    */
@property (nonatomic, strong) NSString *maxQuantity;       /**<   */
@property (nonatomic)  int  isRedBag;                      /**<   */
@end



@interface UGChatRoomModel : UGModel
@property (nonatomic, strong) NSString *roomId;         /**<   房间id */
@property (nonatomic, strong) NSString *roomName;       /**<   房间名 */
@property (nonatomic, strong) NSString *password;       /**<  密码 */
@property (nonatomic, strong) NSString *typeId;         /**<   游戏id   已废弃*/
@property (nonatomic)  BOOL isChatBan;                   /**<   */
@property (nonatomic)  BOOL isShareBet;                   /**< //聊天室是否支持分享  */
@property (nonatomic)  int  sortId;                      /**<   */
@property (nonatomic, strong) NSString *isMine;         /**<  */
@property (nonatomic, strong) NSString *maxAmount;         /**<    */
@property (nonatomic, strong) NSString *minAmount;       /**<    */
@property (nonatomic, strong) ChatRedBagSettingModel *chatRedBagSetting;       /**<  */
@property (nonatomic)  BOOL isPassWord;                   /**<   已填写密码*/

@property (nonatomic, strong) NSArray < NSString *>* typeIds;         /**<   游戏id 数组*/
@end

NS_ASSUME_NONNULL_END
