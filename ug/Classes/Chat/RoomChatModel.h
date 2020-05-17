//
//  RoomChatModel.h
//  UGBWApp
//
//  Created by ug on 2020/3/12.
//  Copyright © 2020 ug. All rights reserved.
//
//quantity = "10",
//isShareBet = 1,
//minAmount = "10",
//isShareBill = 1,
//isChatBan = 1,
//typeId = "0",
//typeIds =     (
//),
//oddsRate = "1",
//roomName = "2044大包间",
//roomId = "0",
//sortId = -1,
//password = %@NSCONTEXT,
//chatRedBagSetting =     {
//    isRedBag = 1,
//    maxAmount = "200",
//    minAmount = "1",
//    maxQuantity = "20",
//},
//maxAmount = "1000",
//isMine = 0,

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RoomChatModel : UGModel
@property (nonatomic) int sortId;         /**<   排序 */
@property (nonatomic, strong) NSString *roomName;       /**<   房间名 */
@property (nonatomic, strong) NSString *password;       /**<  密码 */
@property (nonatomic, strong) NSString *roomId;       /**<  密码 */
@property (nonatomic, strong) NSString *typeId;       /**<   已废弃 */
@property (nonatomic)  BOOL isShareBet;                   /**< //聊天室是否支持分享  */
@property (nonatomic, strong) NSArray < NSString *>* typeIds;         /**<   游戏id 数组*/
@end

NS_ASSUME_NONNULL_END
