//
//  MomentsModel.swift
//  ug
//
//  Created by xionghx on 2019/12/20.
//  Copyright © 2019 ug. All rights reserved.
//

import Foundation
import ObjectMapper

struct MomentsModel: Mappable {
	/*
	"mid":"61",
	"uid":"63444",
	"usr":"ioser001",
	"msg_type":"1",
	"reply_num":"0",
	"view_num":362,
	"like_num":"0",
	"relation_id":"0",
	"content":"注单分享吧",
	"images":"",
	"create_ts":"12月19日 19:13",
	"update_ts":"12月20日 14:43",
	"avatar":"",
	"bet_info":{
	"betBean":[
	{
	"money":"1.00",
	"odds":"43.0000",
	"playId":"708506",
	"playIds":"70"
	}
	],
	"betIssue":"2019140",
	"endTime":"1576762200",
	"gameId":"70",
	"totalMoney":"1.00",
	"totalNum":"1",
	"pwd":"",
	"share_data":{
	"betParams":[
	{
	"money":"1.00",
	"name":"06",
	"odds":"43.0000",
	"playId":"708506"
	}
	],
	"code":"TM",
	"ftime":"1576762200",
	"gameId":"70",
	"gameName":"香港六合彩",
	"playNameArray":[
	{
	"playName1":"特码A-06",
	"playName2":"06"
	}
	],
	"specialPlay":false,
	"totalMoney":"1.00",
	"totalNums":"1",
	"turnNum":"2019140",
	"is_instant":"0"
	}
	},
	"like_list":[
	
	],
	"comment_list":[
	
	]
	
	
	*/
	
	var mid = 0
	var uid = ""
	var usr = ""
	var msg_type = "1"
	var reply_num = ""
	var view_num = 0
	var like_num = ""
	var relation_id = ""
	var content = ""
	var images = [String]()
	var create_ts = ""
	var update_ts = ""
	var avatar = ""
	var bet_info: BetModel?
	var comment_list = [MomentsCommentModel]()
	var like_list = [MomentsLikesModel]()
	var is_follow = false
	
	init?(map: Map) {
		
	}
	
	mutating func mapping(map: Map) {
		mid <- (map["mid"], intTransform)
		uid <- map["uid"]
		usr <- map["usr"]
		msg_type <- map["msg_type"]
		reply_num <- map["reply_num"]
		like_num <- map["like_num"]
		relation_id <- map["relation_id"]
		content <- map["content"]
		images <- map["images"]
		create_ts <- map["create_ts"]
		update_ts <- map["update_ts"]
		avatar <- map["avatar"]
		bet_info <- map["bet_info.share_data"]
		view_num <- map["view_num"]
		comment_list <- map["comment_list"]
		like_list <- map["like_list"]
		is_follow <- map["is_follow"]
	}
	func isLiked() -> Bool { like_list.map { $0.uid }.contains(Int(App.user.userId)) }
	func isSelf() -> Bool { uid == App.user.userId }

	
}
struct MomentsApiDataModel: Mappable {
	var list = [MomentsModel]()
	init?(map: Map) {
		
	}
	
	mutating func mapping(map: Map) {
		list <- map["list"]
	}
	
	
}
struct MomentsCommentModel: Mappable {
	
	var mc_id = 0
	var mid = 0
	var pid = 0
	var uid = 0
	var usr = ""
	var comment = ""

	
	init?(map: Map) {
		
	}
	
	mutating func mapping(map: Map) {
		mc_id <- (map["mc_id"], intTransform)
		mid <- (map["mid"], intTransform)
		pid <- (map["pic"], intTransform)
		uid <- (map["uid"], intTransform)
		usr <- map["usr"]
		comment <- map["comment"]
	}

}

struct MomentsLikesModel: Mappable {
	
	var uid = 0
	var usr = ""

	
	init?(map: Map) {
		
	}
	
	mutating func mapping(map: Map) {
		uid <- (map["uid"], intTransform)
		usr <- map["usr"]
	}

}
