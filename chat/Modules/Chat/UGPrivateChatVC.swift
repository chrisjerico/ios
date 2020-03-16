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



class UGPrivateChatVC: MessagesViewController {
	
	var messages = [MessageModel]()
	var sender: Sender
	
	init(sender: Sender) {
		self.sender = sender
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationItem.title = sender.displayName
	
		configureMessageCollectionView()
		MessageManager.shared.newMessage.subscribe(onNext: { [weak self] (message) in
			guard let self = self else { return }
			self.messages.append(MessageModel(JSON: message)!)
			self.messagesCollectionView.reloadData()
			self.messagesCollectionView.scrollToBottom()
		})
			.disposed(by: disposeBag)
		
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
					Alert.showTip("JSON解析出错")
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
		
		messageInputBar.delegate = self
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		messagesCollectionView.scrollToBottom()
		
	}
	private func configureMessageCollectionView() {
		
		//		messagesCollectionView.register(ChatMessageCellHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
		//		messagesCollectionView.backgroundColor = UIColor(hex: "#263147")
		messagesCollectionView.messagesDataSource = self
		//		messagesCollectionView.messageCellDelegate = self
		messagesCollectionView.messagesLayoutDelegate = self
		messagesCollectionView.messagesDisplayDelegate = self
		maintainPositionOnKeyboardFrameChanged = true
		scrollsToBottomOnKeyboardBeginsEditing = true
		messagesCollectionView.mj_header = RefreshHeader()
		
		let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout
		
		layout?.setMessageIncomingAvatarSize(CGSize(width: 40, height: 40))
		layout?.setMessageOutgoingAvatarSize(CGSize(width: 40, height: 40))
		
		layout?.setMessageIncomingAvatarPosition(AvatarPosition(horizontal: AvatarPosition.Horizontal.cellLeading, vertical: .cellTop))
		layout?.setMessageOutgoingAvatarPosition(AvatarPosition(horizontal: AvatarPosition.Horizontal.cellTrailing, vertical: .cellTop))
		
	}
	
	
}

extension UGPrivateChatVC: InputBarAccessoryViewDelegate {
	func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {

		MessageManager.shared.send(text: text, to: sender)
		inputBar.inputTextView.text = nil

		
	}
}

extension UGPrivateChatVC: MessagesLayoutDelegate {
	
}
extension UGPrivateChatVC: MessagesDisplayDelegate {
	
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
	
}



