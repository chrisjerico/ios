//
//  UGChatVC.swift
//  ug
//
//  Created by xionghx on 2019/10/22.
//  Copyright © 2019 ug. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import RxSwift
import Moya
import SKPhotoBrowser
import ObjectMapper
import RxCocoa
import NSObject_Rx
import SwiftyJSON
import RxAlertController




class UGPrivateChatVC: MessagesViewController {
	let outgoingAvatarOverlap: CGFloat = 17.5
	
	
	
	var messages = [MessageModel]()
	var sender: Sender
	
	private lazy var attachFunctionMenusView: AttachFunctionMenusView = {
		let allItem = [
			["image": "paizhao", "name": "拍照"],
			["image": "xiangce", "name": "相册"],
			//			["image": "hongbao", "name": "红包"],
			//			["image": "hongbaosaolei", "name": "红包扫雷"],
			["image": "zhudanfenxiang", "name": "注单分享"]
		]
		return AttachFunctionMenusView(dataSource: allItem) {[weak self] (index) in
			self?.attachItemSelected(index: index)
		}
		
	}()
	private lazy var emojiKeyBoard = App.emojiKeyBoard
	private lazy var emojiButton = InputBarButtonItem()
	private lazy var attachFunctionMenusButton = InputBarButtonItem()
	private lazy var gifMessageSizeCalculator = GifMessageSizeCalculator(layout: messagesCollectionView.messagesCollectionViewFlowLayout)
	private lazy var redpacketMessageSizeCalculator = RedpacketMessageSizeCalculator(layout: messagesCollectionView.messagesCollectionViewFlowLayout)
	
	init(sender: Sender) {
		self.sender = sender
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		emojiKeyBoard.delegate = self
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationItem.title = sender.displayName
		
		configureMessageCollectionView()
		configMessageInputBar()
		
		
		var isFirstReload = true
		messagesCollectionView.mj_header.rx.refreshing.startWith(())
			.flatMap { [weak self] _ in
				ChatAPI.rx.request(ChatTarget.messageRecord(from: self!.sender.senderId, lastMessage: self?.messages.first?.messageId ?? ""))
				
		}
		.subscribe(onNext: { [weak self] (response) in
			self?.messagesCollectionView.mj_header.endRefreshing()
			guard
				let json = try? response.mapJSON() as? [String: Any],
				let messageJson = json["data"] as? [[String: Any]]
				else {
					//					Alert.showTip("JSON解析出错")
					return
			}
			
			let messages = messageJson.map{ MessageModel(JSON: $0)!}.reversed()
			self?.messages.insert(contentsOf: messages, at: 0)
			if isFirstReload {
				self?.messagesCollectionView.reloadData()
				self?.messagesCollectionView.scrollToBottom()
			} else {
				self?.messagesCollectionView.reloadDataAndKeepOffset()
			}
			isFirstReload = false
			}, onError: { [weak self] (error) in
				self?.messagesCollectionView.mj_header.endRefreshing()
				Alert.showTip(error.localizedDescription)
				
		}).disposed(by: disposeBag)
		
		MessageManager.shared.newMessage.filter { [weak self] message in
			guard
				let weakSelf = self,
				let uid = message["chatUid"] as? String
				else {
					return true
			}
			return uid == weakSelf.sender.senderId
		}.map { MessageModel(JSON: $0)!}
			.subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
			.observeOn(MainScheduler.instance)
			.subscribe(onNext: { [weak self] (message) in
				guard let self = self else { return }
				self.messages.append(message)
				self.messagesCollectionView.reloadData()
				self.messagesCollectionView.scrollToBottom()
			})
			.disposed(by: disposeBag)
		

	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		messagesCollectionView.scrollToBottom()
		
	}
	private func configureMessageCollectionView() {
		messagesCollectionView.register(MessageCollectionViewGifCell.self)
		messagesCollectionView.register(MessageCollectionViewRedpacketCell.self)
		messagesCollectionView.register(MessageCollectionViewBetCell.self)
		
		messagesCollectionView.keyboardDismissMode = .onDrag
		
		messagesCollectionView.messagesDataSource = self
		messagesCollectionView.messageCellDelegate = self
		messagesCollectionView.messagesLayoutDelegate = self
		messagesCollectionView.messagesDisplayDelegate = self
		maintainPositionOnKeyboardFrameChanged = true
		scrollsToBottomOnKeyboardBeginsEditing = true
		messagesCollectionView.mj_header = RefreshHeader()
		
		
	}
	private func configMessageInputBar() {
		messageInputBar.backgroundView.backgroundColor = UIColor(hex: "#edeff7")
		messageInputBar.maxTextViewHeight = 80
		messageInputBar.shouldAutoUpdateMaxTextViewHeight = false
		messageInputBar.inputTextView.returnKeyType = .send
		messageInputBar.inputTextView.layer.cornerRadius = 5
		messageInputBar.inputTextView.layer.masksToBounds = true
		messageInputBar.inputTextView.backgroundColor = UIColor.white
		messageInputBar.inputTextView.delegate = self
		messageInputBar.setRightStackViewWidthConstant(to: 80, animated: false)
		messageInputBar.inputTextView.textColor = UIColor.darkText
		messageInputBar.inputTextView.placeholder = "在此回复"
		
		let leftView = UIImageView(image: UIImage(named: "shuru"))
		messageInputBar.inputTextView.addSubview(leftView)
		leftView.snp.makeConstraints { (make) in
			make.leading.equalToSuperview().offset(6)
			make.centerY.equalToSuperview()
		}
		messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 0)
		messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 24, bottom: 8, right: 0)
		
//		messageInputBar.bottomStackView.backgroundColor = UIColor.red
//		messageInputBar.backgroundColor = UIColor.yellow
		
		//群附加功能的按钮
		attachFunctionMenusButton.configure { item in
			item.image = UIImage(named: "keyboard_attach")
			item.imageView?.contentMode = .scaleAspectFit
			item.setSize(CGSize(width: 30, height: 30), animated: false)
			item.imageView?.contentMode = .scaleAspectFit
			
		}
		.onTouchUpInside { [weak self] item in
			guard let weakSelf = self else { return }
			weakSelf.messageInputBar.inputTextView.resignFirstResponder()
			if weakSelf.messageInputBar.bottomStackView.arrangedSubviews.count > 0 {
				weakSelf.messageInputBar.setStackViewItems([InputItem](), forStack: .bottom, animated: false)
			} else {
				weakSelf.messageInputBar.setStackViewItems([weakSelf.attachFunctionMenusView], forStack: .bottom, animated: false)
			}
		}
		
		//发送表情的按钮
		emojiButton.configure { (item) in
			item.image = UIImage(named: "keyboard_emoji")
			item.setSize(CGSize(width: 30, height: 30), animated: false)
			item.imageView?.contentMode = .scaleAspectFit
		}
		.onTouchUpInside {[weak self] item in
			
			guard let weakSelf = self else { return }
			let textView = weakSelf.messageInputBar.inputTextView
			if textView.inputView == weakSelf.emojiKeyBoard {
				weakSelf.setKeyBoard(type: .system)
			} else {
				weakSelf.setKeyBoard(type: .emoji)
			}
			weakSelf.messageInputBar.inputTextView.becomeFirstResponder()
		}
		
		messageInputBar.setStackViewItems([emojiButton, attachFunctionMenusButton], forStack: .right, animated: false)
	}
	
	func isTimeLabelVisible(at indexPath: IndexPath) -> Bool {
		guard indexPath.section - 1 >= 0 else { return true }
		let message = messages[indexPath.section]
		let previousMessage = messages[indexPath.section - 1]
		return message.t - previousMessage.t > 180
	}
	
	func isPreviousMessageSameSender(at indexPath: IndexPath) -> Bool {
		guard indexPath.section - 1 >= 0 else { return false }
		return messages[indexPath.section].uid == messages[indexPath.section - 1].uid
	}
	
	func isNextMessageSameSender(at indexPath: IndexPath) -> Bool {
		guard indexPath.section + 1 < messages.count else { return false }
		return messages[indexPath.section].uid == messages[indexPath.section + 1].uid
	}
	public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		guard let messagesDataSource = messagesCollectionView.messagesDataSource else {
			fatalError("Ouch. nil data source for messages")
		}
		
		// Very important to check this when overriding `cellForItemAt`
		// Super method will handle returning the typing indicator cell
		guard !isSectionReservedForTypingIndicator(indexPath.section) else {
			return super.collectionView(collectionView, cellForItemAt: indexPath)
		}
		
		let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
		
		guard case let .custom(any) = message.kind else {
			return super.collectionView(collectionView, cellForItemAt: indexPath)
		}
		
		if let _ = any as? GifText {
			let cell = messagesCollectionView.dequeueReusableCell(MessageCollectionViewGifCell.self, for: indexPath)
			cell.configure(with: message, at: indexPath, and: messagesCollectionView)
			return cell
			
		} else if let _ = any as? RedpacketModel {
			let cell = messagesCollectionView.dequeueReusableCell(MessageCollectionViewRedpacketCell.self, for: indexPath)
			cell.configure(with: message, at: indexPath, and: messagesCollectionView)
			return cell
			
		} else if let _ = any as? BetModel {
			let cell = messagesCollectionView.dequeueReusableCell(MessageCollectionViewBetCell.self, for: indexPath)
			cell.configure(with: message, at: indexPath, and: messagesCollectionView)
			cell.betDelegate = self
			return cell
			
		} else {
			let cell = messagesCollectionView.dequeueReusableCell(MessageContentCell.self, for: indexPath)
			cell.configure(with: message, at: indexPath, and: messagesCollectionView)
			return cell
		}
		
	}
	
	
	// Mark: function
	func setKeyBoard(type: KeyBoardType) {
		switch type {
		case .system:
			self.messageInputBar.inputTextView.inputView = nil
		case .emoji:
			self.messageInputBar.inputTextView.inputView = self.emojiKeyBoard
		}
		self.messageInputBar.inputTextView.reloadInputViews()
	}
	func clearBottomInputItems () {
		attachFunctionMenusButton.image = UIImage(named: "keyboard_attach")
		messageInputBar.setStackViewItems([InputItem](), forStack: .bottom, animated: false)
	}
	
	func attachItemSelected(index: Int) {
		
		switch index {
		case 0:
			UIImagePickerController.rx.createWithParent(self) { picker in
				picker.sourceType = .camera
				picker.allowsEditing = false
			}
			.flatMap {
				$0.rx.didFinishPickingMediaWithInfo
			}
			.take(1)
			.map { info in
				return info[.originalImage] as? UIImage
			}
			.filterNil()
			.flatMap { image in
				FileUploadApi.rx.requestWithProgress(FileUploadTarget.image(data: image))
			}.subscribe(onNext: { [weak self] (response) in
				Alert.showProgress(progress: response.progress)
				if let weakSelf = self, response.completed, let response = response.response, let fileModel = try? response.mapObject(NetWorkFileModel.self, keyPath: nil, decrypt: false) {
					MessageManager.shared.send(imageUrl: fileModel.url, imageUri: fileModel.uri, to: weakSelf.sender)
				}
				}, onError: { (error) in
					Alert.showTip(error.localizedDescription)
			}, onCompleted: {
				Alert.hide()
			}).disposed(by: disposeBag)
			
			
		case 1:
			
			UIImagePickerController.rx.createWithParent(self) { picker in
				picker.sourceType = .photoLibrary
				picker.allowsEditing = false
			}
			.flatMap {
				$0.rx.didFinishPickingMediaWithInfo
			}
			.take(1)
			.map { info in
				return info[.originalImage] as? UIImage
			}
			.filterNil()
			.flatMap { image in
				FileUploadApi.rx.requestWithProgress(FileUploadTarget.image(data: image))
			}.subscribe(onNext: { [weak self] (response) in
				Alert.showProgress(progress: response.progress)
				if let weakSelf = self, response.completed, let response = response.response, let fileModel = try? response.mapObject(NetWorkFileModel.self, keyPath: nil, decrypt: false) {
					MessageManager.shared.send(imageUrl: fileModel.url, imageUri: fileModel.uri, to: weakSelf.sender)
				}
				}, onError: { (error) in
					Alert.showTip(error.localizedDescription)
			}, onCompleted: {
				Alert.hide()
			}).disposed(by: disposeBag)
			
			
		case 2:
			let vc = BetListVC()
			vc.delegate = self
			present(BaseNav(rootViewController: vc), animated: true, completion: nil)
			
		default:
			break
		}
		
	}
	let fieldMaker: (String, String, String, NSTextAlignment) -> (UITextField) -> Void = { (title, placeHolder, suffix, textAlignment) in
		return { (field: UITextField) in
			let leftLabel = UILabel()
			leftLabel.attributedText = title.mutableAttributedString().x.fontSize(12).x.color(UIColor.darkText)
			field.leftView = leftLabel
			field.leftViewMode = .always
			field.placeholder = placeHolder
			field.textAlignment = textAlignment
			
			let rightLabel = UILabel()
			rightLabel.attributedText = suffix.mutableAttributedString().x.fontSize(12).x.color(UIColor.darkText)
			field.rightView = rightLabel
			field.rightViewMode = .always
			field.keyboardType = .numberPad
		}
	}
}
extension UGPrivateChatVC: MessagesLayoutDelegate {
	
	func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
		if isTimeLabelVisible(at: indexPath) {
			return 18
		}
		return 0
	}
	
	func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
		return 20
	}
	
	func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
		return 0
	}
}
extension UGPrivateChatVC: MessagesDisplayDelegate {
	public func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
		
		guard let message = message as? MessageModel else {
			return
		}
		if message.sender.senderId == App.user.userId {
			avatarView.kf.setImage(with: URL(string: App.user.avatar))
		} else {
			avatarView.kf.setImage(with: URL(string: message.avator))
		}
	}
	
	// MARK: - Picture Message
	
	public func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
		
		guard case let .photo(media) = message.kind  else {
			return
		}
		if let image = media.image {
			imageView.image = image
		} else if let url = media.url {
			imageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
		}
	}
}

extension UGPrivateChatVC: MessagesDataSource {
	public func currentSender() -> SenderType {
		return UGUserModel.currentUser()
	}
	
	public func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
		return messages.count
	}
	
	public func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
		return messages[indexPath.section]
	}
	
	func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
		if isTimeLabelVisible(at: indexPath) {
//			return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
			return MessageDateFormater.shared.attributedString(from: message.sentDate, with: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])

		}
		return nil
	}
	
	func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
		let name = message.sender.displayName
		return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
	}
}

extension UGPrivateChatVC: MessageCellDelegate {
	//	func didTapPlayButton(in cell: AudioMessageCell) {
	//		messageInputBar.inputTextView.resignFirstResponder()
	//		clearBottomInputItems()
	//
	//	}
	//
	//	func didTapBackground(in cell: MessageCollectionViewCell) {
	//		messageInputBar.inputTextView.resignFirstResponder()
	//		clearBottomInputItems()
	//	}
	
	func didTapAvatar(in cell: MessageCollectionViewCell) {
		logger.debug("didTapAvatar")
	}
	public func didTapMessage(in cell: MessageCollectionViewCell) {
		if
			let cell = cell as? MediaMessageCell,
			let image = cell.imageView.image
		{
			let browser = SKPhotoBrowser(photos: [SKPhoto.photoWithImage(image)])
			navigationController?.present(browser, animated: true, completion: nil)
		}
		
	}
	
	
	
}

extension UGPrivateChatVC: EmojiKeyBoardInputDelegate {
	public func delButtonTaped() {
		messageInputBar.inputTextView.deleteBackward()
	}
	
	public func sendButtonTaped() {
		let plainText = messageInputBar.inputTextView.x.plainText()
		if plainText.count > 0 {
			MessageManager.shared.send(text: plainText, to: sender)
			messageInputBar.inputTextView.text = ""
		}
	}
	
	public func didSelected(emoticon: EmoticonType) {
		messageInputBar.inputTextView.x.append(emoticon: emoticon)
	}
}

extension UGPrivateChatVC: UITextViewDelegate {
	public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		if text == "\n" {
			if let text = messageInputBar.inputTextView.text, text.count > 0  {
				MessageManager.shared.send(text: text, to: sender)
				textView.text = ""
			}
			return false
		} else {
			return true
		}
	}
	
	func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
		setKeyBoard(type: .system)
		return true
	}
	
	func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
		clearBottomInputItems()
		return true
	}
	
}

extension UGPrivateChatVC: BetFollowViewDelegate {
	
	func viewDidDisapear() {
		becomeFirstResponder()
	}
	

}

extension UGPrivateChatVC: BetListDelegate {
	func betListHandleButtonTaped(with item: BetModel) {
		MessageManager.shared.send(bet: item, to: sender)
	}
}
extension UGPrivateChatVC: MessageCollectionViewBetCellDelegate {
	func didTapBetFollowButton(with item: BetModel) {
		logger.debug(item)
		
		let betFollowView = Bundle.main.loadNibNamed("BetFollowView", owner: self, options: nil)?.first as! BetFollowView
		betFollowView.delegate = self
		betFollowView.bind(item: item)
		App.widow.addSubview(betFollowView)
		betFollowView.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
		resignFirstResponder()
		
	}
	
	
}
