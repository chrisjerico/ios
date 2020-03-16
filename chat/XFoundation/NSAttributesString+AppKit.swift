//
//  NSAttributesStringExtension.swift
//  XiaoJir
//
//  Created by xionghx on 2018/11/1.
//  Copyright © 2018 xionghx. All rights reserved.
//

import Foundation
import UIKit

public func + (attr1: NSMutableAttributedString, attr2: NSMutableAttributedString) -> NSMutableAttributedString {
	attr1.append(attr2)
	return attr1
}

public extension AppKit where Base: NSMutableAttributedString {
	
	func allRange() -> NSRange {
		return NSRange(location: 0, length: base.length)
	}
	
	/// 添加图片
	///
	/// - Parameters:
	///   - image: 图片对象
	///   - bounds: 图片大小位置
	///   - index: 插入下标
	/// - Returns: NSMutableAttributedString
	func insertImage(_ image: UIImage?, bounds: CGRect, index: Int) -> Base {
		guard let image = image else {
			return base
		}
		let attchImage = NSTextAttachment()
		attchImage.image = image
		// 设置图片大小
		attchImage.bounds = bounds
		let imageAttr = NSAttributedString(attachment: attchImage)
		base.insert(imageAttr, at: index)
		return base
	}
	
	// 图片
	func image(_ image: UIImage, bounds: CGRect) -> Base {
		let attchImage = NSTextAttachment()
		attchImage.image = image
		// 设置图片大小
		attchImage.bounds = bounds
		let imageAttr = NSAttributedString(attachment: attchImage)
		base.append(imageAttr)
		return base
	}
	
	// 中划线
	func strike(_ value: Int) -> NSMutableAttributedString {
		base.addAttributes([.strikethroughStyle: value], range: self.allRange())
		return base
	}
	
	// 中划线颜色
	func strikeColor(_ color: UIColor) -> NSMutableAttributedString {
		base.addAttributes([.strikethroughColor: color], range: self.allRange())
		return base
	}
	
	// 描边宽度
	func strokeWidth(_ width: CGFloat) -> NSMutableAttributedString {
		base.addAttributes([.strokeWidth: width], range: self.allRange())
		return base
	}
	
	// 描边颜色
	func strokeColor(_ color: UIColor) -> NSMutableAttributedString {
		base.addAttributes([.strokeColor: color], range: self.allRange())
		return base
	}
	
	// 字间距
	func fontSpace(_ space: CGFloat) -> NSMutableAttributedString {
		base.addAttributes([.kern: space], range: self.allRange())
		return base
	}
	
	// 背景色
	func backgroundColor(_ color: UIColor) -> NSMutableAttributedString {
		base.addAttributes([.backgroundColor: color], range: self.allRange())
		return base
	}
	
	// 前景色
	func color(_ color: UIColor) -> NSMutableAttributedString {
		base.addAttributes([.foregroundColor: color], range: self.allRange())
		return base
	}
	
	// 下划线
	func underLine(_ style: NSUnderlineStyle) -> NSMutableAttributedString {
		base.addAttributes([.underlineStyle: style.rawValue], range: self.allRange())
		return base
	}
	
	//倾斜
	func obliqueness(_ obliqueness: CGFloat) -> NSMutableAttributedString {
		base.addAttributes([.obliqueness: obliqueness], range: self.allRange())
		return base
	}
	
	// 下划线颜色
	func underLineColor(_ color: UIColor) -> NSMutableAttributedString {
		base.addAttributes([.underlineColor: color], range: self.allRange())
		return base
	}
	
	// 字体
	func font(_ font: UIFont) -> NSMutableAttributedString {
		base.addAttributes([.font: font], range: self.allRange())
		return base
	}
	
	// 系统字体大小
	func fontSize(_ size: CGFloat) -> NSMutableAttributedString {
		base.addAttributes([.font: UIFont.systemFont(ofSize: size)], range: self.allRange())
		return base
	}
	
	// 链接 NSUrl
	func linkUrl(_ url: URL) -> NSMutableAttributedString {
		base.addAttributes([.link: url], range: self.allRange())
		return base
	}
	
	// 链接 NSString
	func linkString(_ string: NSString) -> NSMutableAttributedString {
		base.addAttributes([.link: string], range: self.allRange())
		return base
	}
	
	// 行间距
	func lineSpace( _ space: CGFloat) -> NSMutableAttributedString {
		let style = NSMutableParagraphStyle()
		style.lineSpacing = space
		style.lineBreakMode = .byCharWrapping
		base.addAttribute(.paragraphStyle, value: style, range: self.allRange())
		return base
	}
	
	// 段落样式
	func paragraphStyle(_ style: NSMutableParagraphStyle) -> NSMutableAttributedString {
		base.addAttribute(.paragraphStyle, value: style, range: self.allRange())
		return base
	}
	
	
	// 添加user链接
	func linkUser(name: String, profileId: String) -> NSMutableAttributedString {
		
		if let url = URL(string: "XiaoJir://user/\(profileId)") {
			return base + "@\(name)".mutableAttributedString().x.linkUrl(url)
		} else {
			return base
		}
		
	}
	// 添加小记回复的链接
	func linkReplyComment(name: String, feedId: String, commentId: String) -> NSMutableAttributedString {
		
		if let url = URL(string: "XiaoJir://reply-comment?feedId=\(feedId)&commentId=\(commentId)") {
			return "回复".mutableAttributedString().x.color(UIColor(hex: "#767E8C")).x.fontSize(14)
				+ "\(name)".mutableAttributedString().x.linkUrl(url)
				+ base
		} else {
			return base
			
		}
		
	}
	
	
	func replaceEmoticons(size: CGFloat) -> NSMutableAttributedString {
		let pattern = RegexParser.emoticon.pattern
		let range = NSRange(location: 0, length: base.string.count)
		let matches = RegexParser.getElements(from: base.string, with: pattern, range: range)
		
		
		for match in matches.reversed() {
			let emojiBundlePath = Bundle.main.path(forResource: "Emoji", ofType: "bundle")!
			let word = (((base.string as NSString).substring(with: match.range) as NSString).replacingOccurrences(of: "[em_", with: "") as NSString).replacingOccurrences(of: "]", with: "")
			let emojiFilePath = Bundle(path: emojiBundlePath)!.path(forResource: word, ofType: "gif", inDirectory: "Resource")!

			let emoticon = EmoticonAttachment(emoticon: .gif(filePath: emojiFilePath))
			emoticon.bounds = CGRect(x: 0, y: 0, width: size, height: size)
			base.replaceCharacters(in: match.range, with: NSMutableAttributedString(attachment: emoticon))
		}
		return base
	}
	
}
