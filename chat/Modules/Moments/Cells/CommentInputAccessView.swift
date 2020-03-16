//
//  CommentInputAccessView.swift
//  ug
//
//  Created by xionghx on 2019/12/25.
//  Copyright © 2019 ug. All rights reserved.
//

import Foundation
import InputBarAccessoryView

class CommentInputAccessView: InputBarAccessoryView {
	private lazy var emojiButton = InputBarButtonItem()
	let emojiKeyBoard = App.emojiKeyBoard
	override init(frame: CGRect) {
		super.init(frame: frame)
		inputTextView.returnKeyType = .send
		maxTextViewHeight = 80
		shouldAutoUpdateMaxTextViewHeight = false
		inputTextView.returnKeyType = .send
		inputTextView.layer.cornerRadius = 5
		inputTextView.layer.masksToBounds = true
		inputTextView.backgroundColor = UIColor(hex: "#eeeeee")
		setRightStackViewWidthConstant(to: 58, animated: false)
		inputTextView.textColor = UIColor.darkText
		//			inputTextView.placeholder = "在此回复"
		//发送表情的按钮
		emojiButton.configure { (item) in
			item.image = UIImage(named: "biaoqing")
			item.setSize(CGSize(width: 30, height: 30), animated: false)
			item.imageView?.contentMode = .scaleAspectFit
		}
		.onTouchUpInside {[weak self] item in
			
			guard let weakSelf = self else { return }
			let textView = weakSelf.inputTextView
			if textView.inputView == weakSelf.emojiKeyBoard {
				weakSelf.setKeyBoard(type: .system)
			} else {
				weakSelf.setKeyBoard(type: .emoji)
			}
			weakSelf.inputTextView.becomeFirstResponder()
		}
		
		setStackViewItems([emojiButton], forStack: .right, animated: false)

	}
	
	func setKeyBoard(type: KeyBoardType) {
		switch type {
		case .system:
			inputTextView.inputView = nil
			emojiButton.image = UIImage(named: "biaoqing")
		case .emoji:
			inputTextView.inputView = self.emojiKeyBoard
			emojiButton.image = UIImage(named: "jianpan")
		}
		inputTextView.reloadInputViews()
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
