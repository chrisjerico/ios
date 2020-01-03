//
//  MomentsCellCommentTextView.swift
//  ug
//
//  Created by xionghx on 2019/12/26.
//  Copyright © 2019 ug. All rights reserved.
//

import UIKit

class MomentsCellCommentTextView: UITextView {
	override init(frame: CGRect, textContainer: NSTextContainer?) {
		super.init(frame: frame, textContainer: textContainer)
		isScrollEnabled = false
		isEditable = false
		backgroundColor = UIColor(hex: "#F0F2F7")
		contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: -12)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	var comment: MomentsCommentModel?
	func bind(item: MomentsCommentModel) {
		comment = item
		attributedText = "\(item.usr): ".mutableAttributedString().x.fontSize(14).x.color(UIColor(hex: "#5067AB")) + item.comment.mutableAttributedString().x.fontSize(14).x.color(UIColor(hex: "#5E6066")).x.replaceEmoticons(size: 14)
	}
	
//	func bind(item: MomentsModel) {
//
//		var mutableAttributedString = "".mutableAttributedString()
//		item.comment_list.forEach { (item) in
//			mutableAttributedString = mutableAttributedString + "\n\(item.usr): ".mutableAttributedString().x.fontSize(14).x.color(UIColor(hex: "#5067AB")) + item.comment.mutableAttributedString().x.fontSize(14).x.color(UIColor(hex: "#5E6066")).x.replaceEmoticons(size: 14)
//		}
//		attributedText = mutableAttributedString
//
//	}
	
}
