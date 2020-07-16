//
//  UGConversationModel.swift
//  ug
//
//  Created by xionghx on 2019/11/16.
//  Copyright © 2019 ug. All rights reserved.
//

import ObjectMapper
public struct UGConversationApiDataModel: Mappable {
	var conversationList = [UGConversationModel]()
	public init?(map: Map) {
		
	}
	
	public mutating func mapping(map: Map) {
		conversationList <- map["conversationList"]
	}
	
	
	
}

public struct UGConversationModel: Mappable {

	var roomName = " "
	var	roomId = 0
	var	unreadCount = 0
	var	memberCount = 0
	var	type = 0
	var	sort = 0
	
	
	var uid = 0
	var username = ""
	var nickname = ""
	var lastMessageInfo: MessageModel?
	
	var isMine = 0
	var minAmount = "0.0"
	var maxAmount = "0.0"
	
	var chatRedBagSetting = RedpacketSettingModel()
	
	var minepacketSetting: MinepacketSettingModel {
		return MinepacketSettingModel(isMine: isMine, minAmount: minAmount, maxAmount: maxAmount)
	}
	
	
	
	var chatType: ChatType {
		switch type {
		case 1:
			return .room(roomid: "\(roomId)", roomName: roomName)
		case 2, 3:
			return .privat(uid: "\(uid)", userName: "\(username)")
		default:
			fatalError("undefined type")
		}
	}
	public init?(map: Map) {
		
	}
	
	public mutating func mapping(map: Map) {
		
		roomName 	<- map["roomName"]
		roomId 		<- map["roomId"]
		unreadCount <- (map["unreadCount"],intTransform)
		memberCount <- map["memberCount"]
		type 		<- map["type"]
		sort 		<- map["sort"]
		uid 		<- map["uid"]
		username 	<- map["username"]
		nickname 	<- map["nickname"]
		lastMessageInfo <- map["lastMessageInfo"]
		chatRedBagSetting <- map["chatRedBagSetting"]

		isMine <- (map["isMine"], intTransform)
		minAmount <- map["minAmount"]
		maxAmount <- map["maxAmount"]

		
	}
	
}

struct RedpacketSettingModel: Mappable {
	
	var isRedBag = false
	var maxAmount = "0"
	var minAmount = "0"
	var maxQuantity = "0"
	
	
	init?(map: Map) {
		
	}
	
	mutating func mapping(map: Map) {
		isRedBag <- map["isRedBag"]
		maxAmount <- map["maxAmount"]
		minAmount <- map["minAmount"]
		maxQuantity <- map["maxQuantity"]
	}
	
	init() {
		
	}
}

struct MinepacketSettingModel {
	var isMine = 0
	var minAmount = "0"
	var maxAmount = "0"
}
