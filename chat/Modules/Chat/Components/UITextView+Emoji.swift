//
//  UITextView+Emoji.swift
//  ug
//
//  Created by xionghx on 2019/11/27.
//  Copyright © 2019 ug. All rights reserved.
//

import UIKit

public extension AppKit where Base: UITextView {
	
	func append(emoticon: EmoticonType) {
		
		switch emoticon {
		case .gif:
			let font = base.font!
			let bounds = CGRect(x: 0, y: 0, width: font.lineHeight, height: font.lineHeight)
			let emoticonAttachment = EmoticonAttachment(emoticon: emoticon)
			emoticonAttachment.bounds = bounds
			let mutableAttributedText = NSMutableAttributedString(attributedString: base.attributedText)
			mutableAttributedText.append(NSAttributedString(attachment: emoticonAttachment))
			
			base.attributedText = mutableAttributedText.x.font(font)
			
		default:
			break
		}
	}
	
	func plainText() -> String {
		let mAttrString = NSMutableAttributedString(attributedString: base.attributedText)
		
			//emoji的解析
			var allMached = [(attachment: EmoticonAttachment, range: NSRange)]()
			mAttrString.enumerateAttribute(.attachment, in: mAttrString.x.allRange(), options: []) { (value, range, _) in
				if let emoticon = value as? EmoticonAttachment {
					allMached.append((emoticon, range))
				}
			}
			
			for mached in allMached.reversed() {
				mAttrString.replaceCharacters(in: mached.range, with: mached.attachment.emoticon.description())
			}
		
		return mAttrString.string
	}
}


