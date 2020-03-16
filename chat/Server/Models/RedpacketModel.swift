//
//  MessageRedpacketModel.swift
//  ug
//
//  Created by xionghx on 2019/12/7.
//  Copyright © 2019 ug. All rights reserved.
//

import Foundation
import ObjectMapper


struct RedpacketModel: Mappable {
	
	var quantity = 1
	var expireTime = 1575690847
	var grabDmlMultiple = "1"
	var uid = 63461
	var status = 3
	var amount = "10"
	var grabLevels = ""
	var `id` = "311"
	var grab_amount = "1.0"
	var roomId = "0"
	var title = "恭喜发财,大吉大利"
	var createTime = 1575690547
	var is_grab = 0
	var createDmlMultiple = "1"
	var grabList = [PacketGrabMemberModel]()
	var genre = "1"
	var updateTime = 1575690853
	
	init?(map: Map) {
		
	}
	
	mutating func mapping(map: Map) {
		
		
		quantity <- map["quantity"]
		expireTime <- map["expireTime"]
		grabDmlMultiple <- map["grabDmlMultiple"]
		uid <- map["uid"]
		status <- map["status"]
		amount <- map["amount"]
		grabLevels <- map["grabLevels"]
		grabLevels <- map["grabLevels"]
		`id` <- map["id"]
		grab_amount <- (map["grab_amount"], stringTransform)
		title <- map["title"]
		createTime <- map["createTime"]
		is_grab <- map["is_grab"]
		createDmlMultiple <- map["createDmlMultiple"]
		grabList <- map["grabList"]
		genre <- map["genre"]
		updateTime <- map["updateTime"]
	}
	
}

struct PacketGrabMemberModel: Mappable {
	var isMine = 0
	var uid = "63459"
	var time = 1575720743
	var isMax = 0
	var nickname = "t1****6"
	var avatar = ""
	var date = "20:12:23"
	var miniRedBagAmount = "7.37"
	var miniRedBagId = 2
	var redBagId = 378
	
	init?(map: Map) {
		
	}
	
	mutating func mapping(map: Map) {
		isMine <- map["isMine"]
		uid <- map["uid"]
		time <- map["time"]
		isMax <- map["isMax"]
		nickname <- map["nickname"]
		avatar <- map["avatar"]
		date <- map["date"]
		miniRedBagAmount <- map["miniRedBagAmount"]
		miniRedBagId <- map["miniRedBagId"]
		redBagId <- map["redBagId"]
	}
	
}
