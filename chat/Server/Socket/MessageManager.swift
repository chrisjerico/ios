//
//  MessageManager.swift
//  ug
//
//  Created by xionghx on 2019/11/18.
//  Copyright © 2019 ug. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
class MessageManager: NSObject {
	
	static let shared = MessageManager()
	
	public let newError = PublishRelay<[String: Any]>()
	public let newMessage = PublishRelay<[String: Any]>()
	public let newLotteryWin = PublishRelay<[String: Any]>()

	public let newNotification = PublishRelay<[String: Any]>()
	
	
	func send(text: String, to receiver: Sender) {
		let dic: [String: Any] = [
			"betFollowFlag":false,
			"code":"R0002",
			"ip": App.user.clientIp,
			"channel":"2",
			"data_type":"text",
			"username": App.user.username,
			"msg":text,
			"level": App.user.curLevelInt,
			"chatName": receiver.displayName,
			"chatUid": receiver.senderId,
			"chat_type": 1
		]
		SocketManager.shared.send(dic)
	}
	
	func send(text: String, to room: Room) {
		let dic: [String: Any] = [
			"betFollowFlag":false,
			"code":"R0002",
			"ip": App.user.clientIp,
			"channel":"2",
			"data_type":"text",
			"username": App.user.username,
			"msg":text,
			"level": App.user.curLevelInt,
			"roomId": room.roomId,
			"chat_type": 0
		]
		SocketManager.shared.send(dic)
	}
	func send(imageUrl: String, imageUri: String, to room: Room) {
		let dic: [String: Any] = [
			"betFollowFlag":false,
			"code":"R0002",
			"ip": App.user.clientIp,
			"channel":"2",
			"data_type":"image",
			"username": App.user.username,
			"msg":imageUrl,
			"image_path": imageUri,
			"level": App.user.curLevelInt,
			"roomId": room.roomId,
			"chat_type": 0
		]
		SocketManager.shared.send(dic)
	}
	
	func send(bet: BetModel,to room: Room) {
		
		let dic: [String: Any] = [
			"betFollowFlag":true,
			"betUrl":bet.betInfo,
			"code":"R0002",
			"ip": App.user.clientIp,
			"channel":"2",
			"data_type":"text",
			"username": App.user.username,
			"msg":bet.betDisplayText,
			"msgJson": bet.toJSON(),
			"level": App.user.curLevelInt,
			"roomId": room.roomId,
			"chat_type": 0
		]
		SocketManager.shared.send(dic)

	}
	

	
	func send(join room: Room) {
		
		let dic = [
			"code":"R0000",
			"isLoadRecord":1,
			"channel":2,
			"token": App.user.sessid,
			"operate":1,
			"roomId": room.roomId
			] as [String : Any]
		
		SocketManager.shared.send(dic)
	}
	func send(exit room: Room) {
		
		let dic = [
			"code":"R0000",
			"isLoadRecord":1,
			"channel":2,
			"token": App.user.sessid,
			"operate":2,
			"roomId": room.roomId
			] as [String : Any]
		
		SocketManager.shared.send(dic)
	}
	
	func send(redPacket: RedPacketMessageModel,to room: Room) {
		
		let dic: [String: Any] =
			["code":"R0011",
			 "channel":"2",
			 "roomId": room.roomId,
			 "redBagId": redPacket.id,
			 "ip":"47.56.126.240",
			 "level": App.user.curLevelInt
		]
		
		SocketManager.shared.send(dic)

	}

}
