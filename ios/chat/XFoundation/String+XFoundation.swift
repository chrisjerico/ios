//
//  String+AppKit.swift
//  XiaoJir
//
//  Created by xionghuanxin on 2018/10/8.
//  Copyright © 2018年 xionghx. All rights reserved.
//

import UIKit

/// 正则表达式
///
/// - email: 邮箱
/// - digital: 数字
/// - phone: 电话号码
/// - password: 密码
/// - chinese: 中文
public enum Regex: String {
    case email = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
    case digital = "^[0-9]+$"
    case phone = "^1[3456789]\\d{9}$"
    case password = "^(?=.*\\d)((?=.*[a-z])(?=.*[A-Z])(\\W?).\\S{6,18})$"
    case chinese = "[\u{4e00}-\u{9fa5}]+"

    public var pattern: String {
        return rawValue
    }
}

public extension AppKit where Base == String {
	
	
	
}


public extension String {

    /// 是否为邮箱地址
	var isEmail: Bool {
        return match(Regex.email.pattern)
    }

    /// 是否为全数字
	var isDigital: Bool {
        return match(Regex.digital.pattern)
    }

    /// 是否为手机号码
	var isPhone: Bool {
        return match(Regex.phone.pattern)
    }

    /// 是否为登录密码
	var isPassword: Bool {
        return match(Regex.password.pattern)
    }

    /// 是否为中文字符
	var isChinese: Bool {
        return match(Regex.chinese.pattern)
    }

    /// 是否满足对应正则条件
    ///
    /// - Parameter pattern: 正则表达式
    /// - Returns: 是否满足正则条件
	func match(_ pattern: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: count)) != nil
        } catch {
            return false
        }
    }
	
	/// 转换为可变的富文本
	///
	/// - Returns: 对应的富文本
	func mutableAttributedString() -> NSMutableAttributedString {
		return NSMutableAttributedString(string: self)
	}
	
	/// 转换为富文本
	///
	/// - Returns: 对应的富文本
	func AttributedString() -> NSAttributedString {
		return NSAttributedString(string: self)
	}

}

public extension String {
    /// 计算文本大小
    ///
    /// - Parameters:
    ///   - width: 文本最大宽度
    ///   - attributes: 富文本属性
    /// - Returns: 文本大小的结果值
	func size(maxWidth width: CGFloat, attributes: [NSAttributedString.Key: Any]? = nil) -> CGSize {
        let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
        return (self as NSString).boundingRect(with: maxSize, options: options, attributes: attributes, context: nil).size
    }
}
