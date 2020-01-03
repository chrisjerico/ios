//
//  CommentInputBar.swift
//  ug
//
//  Created by xionghx on 2019/12/29.
//  Copyright © 2019 ug. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol CommentInputBarDelegate: NSObject {
	func commentInputBarSendButtonTaped(content: String)
}
//@IBDesignable
class CommentInputBar: UIView {
	weak var delegate: CommentInputBarDelegate?
	@IBOutlet weak var inputTextView: UITextView!
	@IBOutlet weak var placeHolderLabel: UILabel!
	@IBOutlet weak var emoticonButton: UIButton!
	@IBOutlet weak var rightStackView: UIStackView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		inputTextView.contentInset = UIEdgeInsets(top: 3, left: 12, bottom: 0, right: 0)
		inputTextView.rx.text.orEmpty.map { $0.count > 0 }.bind(to: placeHolderLabel.rx.isHidden).disposed(by: disposeBag)
		inputTextView.delegate = self
//		inputTextView.rx.setDelegate(self).disposed(by: disposeBag)
		App.emojiKeyBoard.keyTaped.subscribe(onNext: { [weak self] (keyType) in
			guard let weakSelf = self else { return }
			switch keyType {
			case .send:
				if weakSelf.inputTextView.text.count > 0 {
					let plainText = weakSelf.inputTextView.x.plainText()
					if let delegate = weakSelf.delegate {
						delegate.commentInputBarSendButtonTaped(content: plainText)
					}
				}
			case .del:
				weakSelf.inputTextView.deleteBackward()
			case let .emotion(emotion):
				weakSelf.inputTextView.x.append(emoticon: emotion)
			}
			
		}).disposed(by: disposeBag)
//		inputTextView.rx.didEndEditing.subscribe(onNext: { [weak self] () in
//			self?.dismiss()
//		}).disposed(by: disposeBag)
	}
	
	@IBAction func emticonButtonTaped(_ sender: UIButton) {
		inputTextView.inputView = sender.isSelected ? nil: App.emojiKeyBoard
		sender.isSelected = !sender.isSelected
		inputTextView.reloadInputViews()
		inputTextView.becomeFirstResponder()
	}
	
	func show() {
		inputTextView.inputView = nil
		inputTextView.reloadInputViews()
		inputTextView.becomeFirstResponder()
		isHidden = false
	}
	func dismiss() {
		isHidden = true
		inputTextView.text = nil
		inputTextView.resignFirstResponder()
	}
	
	
}
extension CommentInputBar: UITextViewDelegate {

	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		guard text == "\n", textView.text.count > 0 else {
			return true
		}
		let plainText = textView.x.plainText()
		if let delegate = delegate {
			delegate.commentInputBarSendButtonTaped(content: plainText)
		}

		return false
	}
	func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
		dismiss()
		return true
	}
}
