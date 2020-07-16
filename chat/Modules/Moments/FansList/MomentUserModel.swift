//
//  MomentUserModel.swift
//  chat
//
//  Created by xionghx on 2020/6/29.
//  Copyright © 2020 ug. All rights reserved.
//

import Foundation
import ObjectMapper


/**
avatar = "http://test10.6yc.com/images/face/memberFace4.jpg?v=1752442393",
			follow_usr = "benjamin",
			mf_id = "3",
			from_usr = "bob001",
			follow_uid = "4816",
			from_uid = "6445",
			create_ts = "1589954879",
*/

class MomentUserDataModel: Mappable {
	var list = [MomentUserModel]()
	required init?(map: Map) {
		
	}
	
	func mapping(map: Map) {
		list <- map["list"]
	}
	
}

class MomentUserModel: Mappable {
	var avatar = ""
	var follow_usr = ""
	var mf_id = ""
	var from_usr = ""
	var follow_uid = ""
	var from_uid = ""
	var create_ts = ""
	required init?(map: Map) {
		
	}
	
	func mapping(map: Map) {
		avatar <- map["avatar"]
		follow_usr <- map["follow_usr"]
		mf_id <- map["mf_id"]
		from_usr <- map["from_usr"]
		follow_uid <- map["follow_uid"]
		from_uid <- map["from_uid"]
		create_ts <- map["create_ts"]

	}
	
	
	
}
