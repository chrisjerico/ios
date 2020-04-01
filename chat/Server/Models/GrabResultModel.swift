//
//  GrapResultModel.swift
//  ug
//
//  Created by xionghx on 2019/12/8.
//  Copyright © 2019 ug. All rights reserved.
//

import Foundation
import ObjectMapper

struct GrabResultModel: Mappable {
	
	/**
	"redBagId":403,
	"miniRedBagAmount":10.41,
	"miniRedBagId":1,
	"isMine":false,
	"isMax":false,
	"time":1575819728,
	"uid":"63408"
	*/
	var redBagId = 403
	var miniRedBagAmount = 10.41
	var miniRedBagId = 1
	var isMine = false
	var isMax = false
	var time = 1575819728
	var uid = "63408"
	
	
	init?(map: Map) {
		
	}
	
	mutating func mapping(map: Map) {
		redBagId 			<- map["redBagId"]
		miniRedBagAmount 	<- map["miniRedBagAmount"]
		miniRedBagId 		<- map["miniRedBagId"]
		isMine 				<- map["isMine"]
		isMax 				<- map["isMax"]
		time 				<- map["time"]
		uid 				<- map["uid"]
	}
	
	
}
