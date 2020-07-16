//
//  NotificationMessageModel.swift
//  chat
//
//  Created by xionghx on 2020/7/1.
//  Copyright © 2020 ug. All rights reserved.
//

import Foundation
import ObjectMapper


class NotificationMessageModel: Mappable {
	
	var `id` = ""
	var category = ""
	var title = ""
	var content = ""
	var pic = ""
	var linkCategory = 0
	var linkPosition = 0
	var linkUrl = ""
	var alert_type = 0
	var time: TimeInterval = 0.0
	var addTime = ""
	required init?(map: Map) {
		
	}
	
	func mapping(map: Map) {
		id <- map["id"]
		category <- map["category"]
		title <- map["title"]
		content <- map["content"]
		pic <- map["pic"]
		linkCategory <- map["linkCategory"]
		linkPosition <- map["linkPosition"]
		linkUrl <- map["linkUrl"]
		alert_type <- map["alert_type"]
		time <- map["time"]
		addTime <- map["addTime"]

	}
	
}
