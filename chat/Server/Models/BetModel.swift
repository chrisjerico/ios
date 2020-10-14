//
//  BetModel.swift
//  ug
//
//  Created by xionghx on 2019/12/12.
//  Copyright © 2019 ug. All rights reserved.
//

import Foundation
import ObjectMapper

public struct BetModel: Mappable {

	var gameId = ""
	var gameName = ""
	var trunNum = ""
	var totalMoney = ""
	var totalNums = ""
	var betBeans = [BetBeanModel]()
	var ftime = Date().timeIntervalSince1970
	public init?(map: Map) {
		
	}
	
	mutating public func mapping(map: Map) {
		gameId <- map["gameId"]
		gameName <- map["gameName"]
		trunNum <- map["turnNum"]
		totalMoney <- (map["totalMoney"], stringTransform)
		totalNums <- (map["totalNums"], stringTransform)
		betBeans <- map["betBean"]
		ftime <- map["ftime"]
		betBeans <- map["betParams"]
		
	}
	
}

extension BetModel {
	
	var betInfo: [String: Any] {
		var parameters = toJSON()
		for (index, item) in betBeans.enumerated() {
			for (key, value) in item.toJSON() {
				parameters["betBean[\(index)][\(key)]"] = value
			}
		}
		parameters["ftime"] = Date().timeIntervalSince1970
		return parameters
	}
	
	var betDisplayText: String {
		var betText = "游戏: \(gameName)\n" + "期号: \(trunNum)\n" + "内容: \n"
		betBeans.forEach { (betBean) in
			betText = betText + betBean.name + "金额:¥" + betBean.money + "\n"
		}
		betText = betText + "共计: \(totalNums)注\n"
		betText = betText + "金额: \(totalMoney)元\n"

		return betText
	}
}



struct BetBeanModel: Mappable {
	
	var name = ""
	var betNum = ""
	var playId = ""
	var money = ""
	var odds = ""
	var betInfo = ""
	var playIds = ""
	
	init?(map: Map) {
		
	}
	
	mutating func mapping(map: Map) {
		name <- map["name"]
		betNum <- map["betNum"]
		playId <- map["playId"]
		money <- map["money"]
		odds <- map["odds"]
		betInfo <- map["betInfo"]
		playIds <- map["playIds"]

	}
	
	
}
