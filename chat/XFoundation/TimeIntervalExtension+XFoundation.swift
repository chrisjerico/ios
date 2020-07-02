//
//  TimeIntervalExtension.swift
//  XiaoJir
//
//  Created by xionghx on 2018/11/16.
//  Copyright © 2018 xionghx. All rights reserved.
//

import Foundation

extension TimeInterval: AppKitCompatible { }

extension AppKit where Base == TimeInterval {
	
	var timeTomCurrent: String {
		let currentTime = Date().timeIntervalSince1970
		let reduceTime : TimeInterval = currentTime - base
		if reduceTime < 60 {
			return "刚刚"
		}
		let mins = Int(reduceTime / 60)
		if mins < 60 {
			return "\(mins)分钟前"
		}
		let hours = Int(reduceTime / 3600)
		if hours < 24 {
			return "\(hours)小时前"
		}
		let days = Int(reduceTime / 3600 / 24)
		if days < 30 {
			return "\(days)天前"
		}
		let months = Int(reduceTime / 3600 / 24 / 30)
		if months < 12 {
			return "\(months)月前"
		}
		let years = Int(reduceTime / 3600 / 24 / 30 / 23)
		return "\(years)年前"
	}
	
}
