//
//  MomentsImageUpdateApiModel.swift
//  ug
//
//  Created by xionghx on 2019/12/25.
//  Copyright © 2019 ug. All rights reserved.
//

import Foundation
import ObjectMapper
struct MomentsImageUpdateApiModel: Mappable {
	var result = [String]()
	init?(map: Map) {
		
	}
	
	mutating func mapping(map: Map) {
		result <- map["result"]
	}
	
	
}
