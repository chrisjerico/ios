//
//  ReaPacketModel.swift
//  ug
//
//  Created by xionghx on 2019/11/19.
//  Copyright © 2019 ug. All rights reserved.
//

import Foundation
import ObjectMapper

struct RedPacketMessageModel: Mappable {
	
	/**
	"roomId":"6",
		  "uid":"63408",
		  "title":"红包测试",
		  "genre":"1",
		  "amount":"100",
		  "quantity":3,
		  "createTime":1574171683,
		  "expireTime":1574258083,
		  "updateTime":1574171683,
		  "status":1,
		  "id":"17"
	*/
	
	var roomId = ""
	var uid = ""
	var genre = ""
	var amount = ""
	var quantity = 0
	var createTime: Double = 0
	var expireTime: Double = 0
	var updateTime: Double = 0
	var status = 0
	var `id` = ""
	
	init?(map: Map) {
		
	}
	
	mutating func mapping(map: Map) {
		roomId 		<- map["roomId"]
		uid 		<- map[uid]
		genre 		<- map["genre"]
		amount 		<- map["amount"]
		quantity 	<- map["quantity"]
		createTime 	<- map["createTime"]
		expireTime 	<- map["expireTime"]
		updateTime 	<- map["updateTime"]
		status 		<- map["status"]
		`id` 		<- map["id"]


	}
	
	
}
