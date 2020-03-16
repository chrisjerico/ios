//
//  MomentsCellCommentLabel.swift
//  ug
//
//  Created by xionghx on 2019/12/25.
//  Copyright © 2019 ug. All rights reserved.
//

import UIKit
import InputBarAccessoryView

protocol MomentsCellCommentLabelDelegate: NSObject {
	func momentsCellCommentLabeCommented(item: MomentsCommentModel)
}

class MomentsCellCommentLabel: UIView {
	weak var delegate: MomentsCellCommentLabelDelegate?
	var comment: MomentsCommentModel?
//	lazy var commentAccessoryView: CommentInputAccessView = {
//		let accessoryView = CommentInputAccessView()
//		accessoryView.inputTextView.delegate = self
////		#EDEFF7
//
//		return accessoryView
//	}()
//
//	lazy var tempTextFiled: UITextField = {
//		let field = UITextField()
//		field.inputAccessoryView = commentAccessoryView
//		//		field.delegate = self
//		return field
//	}()
	
	@IBOutlet weak var contentLabel: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
//		addSubview(tempTextFiled)
//		App.emojiKeyBoard.keyTaped.subscribe(onNext: { [weak self] (keyType) in
//			guard let weakSelf = self else { return }
//			switch keyType {
//			case .send:
//				break
//			case .del:
//				weakSelf.commentAccessoryView.inputTextView.deleteBackward()
//			case let .emotion(emotion):
//				weakSelf.commentAccessoryView.inputTextView.x.append(emoticon: emotion)
//			}
//
//		}).disposed(by: disposeBag)

		
	}
	
	func bind(item: MomentsCommentModel) {
		comment = item
		contentLabel.attributedText = "\(item.usr):".mutableAttributedString().x.fontSize(12).x.color(UIColor(hex: "#5067AB")) + item.comment.mutableAttributedString().x.replaceEmoticons(size: 12).x.fontSize(12).x.color(UIColor(hex: "#5E6066"))
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		logger.debug("taped")
//		tempTextFiled.becomeFirstResponder()

	}
	
//
//	func makeNewComment() {
//		let plainText = commentAccessoryView.inputTextView.x.plainText()
//		if plainText.count > 0, let delegate = delegate, var model = comment {
//
//			Alert.showLoading()
//			momentsAPI.rx.request(MomentsTarget.comment(content: plainText, mid: model.mid, pid: model.pid)).mapBool().subscribe(onSuccess: { (success) in
//				Alert.hide()
//				model.comment = plainText
//				model.pid = 0
//				model.uid = Int(App.user.userId)!
//				model.usr = App.user.username
//				delegate.momentsCellCommentLabeCommented(item: model)
//
//			}, onError: { (error) in
//				Alert.showTip(error.localizedDescription)
//			}).disposed(by: disposeBag)
//
//			commentAccessoryView.inputTextView.text = ""
//		}
//
//
//	}
	
}
//extension MomentsCellCommentLabel: UITextViewDelegate {
//
////	func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
////
////		return false
////	}
//	func textViewDidBeginEditing(_ textView: UITextView) {
////		textView.endEditing(true)
//		commentAccessoryView.inputTextView.becomeFirstResponder()
//
//	}
//}

//extension MomentsCellCommentLabel: UITextFieldDelegate {
//	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//
//		return true
//
//	}
//	func textViewDidBeginEditing(_ textView: UITextView) {
//		commentAccessoryView.inputTextView.becomeFirstResponder()
//
//	}
//}
//
//extension MomentsCellCommentLabel: EmojiKeyBoardInputDelegate {
//	public func delButtonTaped() {
//		commentAccessoryView.inputTextView.deleteBackward()
//	}
//
//	public func sendButtonTaped() {
//		let plainText = commentAccessoryView.inputTextView.x.plainText()
//		if plainText.count > 0 {
//			//			MessageManager.shared.send(text: plainText, to: room)
//			commentAccessoryView.inputTextView.text = ""
//		}
//	}
//
//	public func didSelected(emoticon: EmoticonType) {
//		commentAccessoryView.inputTextView.x.append(emoticon: emoticon)
//	}
//}

//extension MomentsCellCommentLabel: UITextViewDelegate {
//	public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//		if text == "\n" {
//			if let text = commentAccessoryView.inputTextView.text, text.count > 0, let delegate = delegate, var model = comment {
//
//				Alert.showLoading()
//				momentsAPI.rx.request(MomentsTarget.comment(content: text, mid: model.mid, pid: model.pid)).mapBool().subscribe(onSuccess: { (success) in
//					Alert.hide()
//					model.comment = text
//					model.pid = 0
//					model.uid = Int(App.user.userId)!
//					model.usr = App.user.username
//					delegate.momentsCellCommentLabeCommented(item: model)
//
//				}, onError: { (error) in
//					Alert.showTip(error.localizedDescription)
//				}).disposed(by: disposeBag)
//
//				textView.text = ""
//			}
//			return false
//		} else {
//			return true
//		}
//	}
//
//	//	func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
//	//		setKeyBoard(type: .system)
//	//		return true
//	//	}
//	//
//	//	func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
//	//		clearBottomInputItems()
//	//		return true
//	//	}
//
//}
