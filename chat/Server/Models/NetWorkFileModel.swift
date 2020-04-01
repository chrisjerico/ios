//
//  NetWorkFileModel.swift
//  ug
//
//  Created by xionghx on 2019/12/10.
//  Copyright © 2019 ug. All rights reserved.
//

import Foundation
import ObjectMapper

struct NetWorkFileModel: Mappable {
	
		
	//	"name": "redpacket-zjlz.png",
	//	"ext": "png",
	//	"mime": "image/png",
	//	"size": 5333,
	//	"savename": "OuGOtSB1Ql_1575966218.png",
	//	"savepath": "/alidata/www/web/customise/picture/chat/chatlog/OuGOtSB1Ql_1575966218.png",
	//	"url": "https://cdn01.junbaozhaishanghang.com/upload/t003/customise/picture/chat/chatlog/OuGOtSB1Ql_1575966218.png",
	//	"uri": "/customise/picture/chat/chatlog/OuGOtSB1Ql_1575966218.png",
	//	"md5": "2f30e9ab8eca1caba978ea598674a2d2"
	var name = ""
	var ext = ""
	var mime = ""
	var size = 0
	var savename = ""
	var savepath = ""
	var url = ""
	var uri = ""
	var md5 = ""


	init?(map: Map) {
		
	}
	
	mutating func mapping(map: Map) {
		
		name <- map["name"]
		ext <- map["ext"]
		mime <- map["mime"]
		size <- map["size"]
		savename <- map["savename"]
		savepath <- map["savepath"]
		url <- map["url"]
		uri <- map["uri"]
		md5 <- map["md5"]

		
	}

}
