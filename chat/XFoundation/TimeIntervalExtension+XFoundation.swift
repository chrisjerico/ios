//
//  TimeIntervalExtension.swift
//  XiaoJir
//
//  Created by xionghx on 2018/11/16.
//  Copyright © 2018 xionghx. All rights reserved.
//

import Foundation

extension TimeInterval {
	
	private var timeFormatter: DateFormatter {
		
		get {
			let formater = DateFormatter.init()
			formater.dateFormat = "aaa hh:mm"
			return formater
		}
		set {}
	}
	
	private var weekFormatter: DateFormatter {
		
		get {
			let formater = DateFormatter.init()
			formater.dateFormat = "EEEE"
			return formater
		}
		set {}
	}
	
	private var dateFormatter: DateFormatter {
		
		get {
			let formater = DateFormatter.init()
			formater.dateFormat = "yyyy年MM月dd日"
			return formater
		}
		set {}
	}
	
	private var timeString: String { get { return timeFormatter.string(from: Date(timeIntervalSince1970: self))} set {}}
	private var weekString: String { get { return weekFormatter.string(from: Date(timeIntervalSince1970: self))} set {}}
	private var dateString: String { get { return dateFormatter.string(from: Date(timeIntervalSince1970: self))} set {}}
	
	public func timeStringCompareCurrent() -> String? {
		
		let calendar = Calendar(identifier: .gregorian)
		
//		let componentsSet: Set<Calendar.Component> = ([.year, .month, .day, .hour, .minute, .second])
//		let componentsSelf = calendar.dateComponents(componentsSet, from: Date(timeIntervalSince1970: self))
//		let componentsNow = calendar.dateComponents(componentsSet, from: Date())
		
		let dateSelf = Date(timeIntervalSince1970: self)
		
		// 当天
		if calendar.isDateInToday(dateSelf) {
			return timeString
		}
		
		//昨天
		if calendar.isDateInYesterday(dateSelf) {
			return "昨天" + timeString
		}
		
		return dateString + timeString
		
	}
	public func caculatorDayString(otherTimeInterval: TimeInterval?) -> String? {
			
		guard let otherTimeInterval = otherTimeInterval else {
			return timeStringCompareCurrent()
		}
		
		guard self - otherTimeInterval > 60*5 else {
			return nil
		}
		
		return timeStringCompareCurrent()
		
	}
	
	public func detailDisplayString() -> String {
		let formatter = DateFormatter()
		
		let date = Date(timeIntervalSince1970: self)
		
		let displayString: String
		
		if Calendar.current.isDateInToday(date) { // 今天
			formatter.dateFormat = "aaa hh:mm"
			displayString = formatter.string(from: date)
			
		} else if Calendar.current.isDateInYesterday(date) { // 昨天
			formatter.dateFormat = "aaa hh:mm"
			displayString = "昨天 \(formatter.string(from: date))"
			
		} else { // 其他
			formatter.dateFormat = "yyyy-MM-dd aaa hh:mm"
			displayString = formatter.string(from: date)
		}
		
		return displayString
	}
}
