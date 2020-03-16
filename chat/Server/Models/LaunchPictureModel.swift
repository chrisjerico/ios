//
//  LaunchPictureModel.swift
//  ug
//
//  Created by xionghx on 2019/12/30.
//  Copyright © 2019 ug. All rights reserved.
//

import Foundation
import ObjectMapper

struct LaunchPictureModel: Mappable {
	var pic = ""
	init?(map: Map) {
		
	}
	
	mutating func mapping(map: Map) {
		pic <- map["pic"]
	}
	
	
}
