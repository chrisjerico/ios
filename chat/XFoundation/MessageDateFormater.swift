//
//  MessageDateFormater.swift
//  chat
//
//  Created by xionghx on 2020/10/14.
//  Copyright © 2020 ug. All rights reserved.
//

import Foundation


open class MessageDateFormater {

	// MARK: - Properties

	public static let shared = MessageDateFormater()

	private let formatter = DateFormatter()

	// MARK: - Initializer

	private init() {}

	// MARK: - Methods

	public func string(from date: Date) -> String {
		configureDateFormatter(for: date)
		return formatter.string(from: date)
	}

	public func attributedString(from date: Date, with attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
		let dateString = string(from: date)
		return NSAttributedString(string: dateString, attributes: attributes)
	}

	open func configureDateFormatter(for date: Date) {
		switch true {
		case Calendar.current.isDateInToday(date) || Calendar.current.isDateInYesterday(date):
			formatter.doesRelativeDateFormatting = true
			formatter.dateStyle = .short
			formatter.timeStyle = .short
		case Calendar.current.isDate(date, equalTo: Date(), toGranularity: .day):
			formatter.dateFormat = "hh:mm"
		case Calendar.current.isDate(date, equalTo: Date(), toGranularity: .month):
			formatter.dateFormat = "MM-dd hh:mm"
		default:
			formatter.dateFormat = "yyyy-MM-dd hh:mm"
		}
	}
	
}
