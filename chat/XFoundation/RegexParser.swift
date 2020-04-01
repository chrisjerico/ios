//
//  RegexParser.swift
//  XiaoJir
//
//  Created by diao on 2018/11/18.
//  Copyright © 2018 xionghx. All rights reserved.
//

import Foundation

public enum RegexParser: String {
	case url = #"(((https|http)?://|www\.|pic\.)[-\w;/?:@&=+$\|\_.!~*\|'()\[\]%#,☺]+[\w/#](\(\))?)"#
	case user = #"@[\u4e00-\u9fa5a-zA-Z0-9_-]+[\(\d.*?\)]{2,30}"#
	case topic = "#.*?#"
	case emoticon = #"\[em_{1}([0-9])*\]"#
	
}
extension RegexParser {
	
	public var pattern: String {
		return rawValue
	}
	
	private static var cachedRegularExpressions: [String: NSRegularExpression] = [:]
	
	public static func getElements(from text: String, with pattern: String, range: NSRange) -> [NSTextCheckingResult] {
		guard let elementRegex = regularExpression(for: pattern) else { return [] }
		return elementRegex.matches(in: text, options: [], range: range)
	}
	
	private static func regularExpression(for pattern: String) -> NSRegularExpression? {
		if let regex = cachedRegularExpressions[pattern] {
			return regex
		} else if let createdRegex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]) {
			cachedRegularExpressions[pattern] = createdRegex
			return createdRegex
		} else {
			return nil
		}
	}
	
}
