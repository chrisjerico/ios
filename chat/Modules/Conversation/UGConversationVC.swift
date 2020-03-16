//
//  UGConversationVC.swift
//  ug
//
//  Created by xionghx on 2019/10/21.
//  Copyright © 2019 ug. All rights reserved.
//

import UIKit
import SnapKit
import ObjectMapper
import RxCocoa
import RxSwift
import Moya

@objc
class UGConversationVC: BaseVC {
	
	lazy var tableView: UITableView = {
		let tableView = UITableView()
		tableView.separatorStyle = .none
		tableView.register(ConversationCell.self, forCellReuseIdentifier: "ConversationCell")
		tableView.mj_header = RefreshHeader()
		return tableView
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor.white
		navigationItem.title = "消息"
		setupSubView()
		
		let headerRefreshing = tableView.mj_header.rx.refreshing.map { _ in }
		let newMessage = MessageManager.shared.newMessage.throttle(DispatchTimeInterval.seconds(3), scheduler: MainScheduler.instance).map { _ in }
		let newNotification = MessageManager.shared.newNotification.throttle(DispatchTimeInterval.seconds(1), scheduler: MainScheduler.instance).map { _ in }
		let shouldRefresh = PublishRelay<()>()
		Observable.merge(headerRefreshing, newMessage, newNotification, shouldRefresh.map {_ in }).flatMapLatest { _ in
			ChatAPI.rx.request(ChatTarget.conversations).mapObject(UGConversationApiDataModel.self).do(onSuccess: { [weak self] _ in
				self?.tableView.mj_header.endRefreshing()
				}, onError: {[weak self] (error) in
					self?.tableView.mj_header.endRefreshing()
					Alert.showTip(error.localizedDescription)
			}).map { $0.conversationList}
		}.retry().bind(to: tableView.rx.items) {(tableView, row, element) in
			let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell") as! ConversationCell
			cell.bind(item: element)
			return cell
		}.disposed(by: disposeBag)
		
		
		tableView.rx.modelDeleted(UGConversationModel.self).subscribe(onNext: { (room) in
			MessageManager.shared.send(exit: Room(conversation: room))
		}).disposed(by: disposeBag)
		
		tableView.rx.modelDeleted(UGConversationModel.self).flatMap { (conversation) -> Single<Response>  in
			var parmaters = [String: Any]()
			switch conversation.chatType {
			case let .privat(uid, _):
				parmaters["targetUid"] = uid
				parmaters["type"] = 2
				
			case let .room(roomId, _):
				parmaters["roomId"] = roomId
				parmaters["type"] = 1
			}
			return ChatAPI.rx.request(ChatTarget.delConversation(parameters: parmaters))
		}.mapBool().subscribe(onNext: { (success) in
			Alert.showTip("置顶成功")
		}, onError: { (error) in
			Alert.showTip(error.localizedDescription)
		}).disposed(by: disposeBag)

		tableView.rx.modelSelected(UGConversationModel.self).subscribe(onNext: { [weak self] (conversation) in
			switch conversation.chatType {
			case let .privat(uid, userName):
				self?.navigationController?.pushViewController(UGPrivateChatVC(sender: Sender(senderId: uid, displayName: userName)), animated: true)
			case .room:
				self?.navigationController?.pushViewController(UGGroupChatVC(room: Room(conversation: conversation)), animated: true)
			}
		}).disposed(by: disposeBag)
			
		shouldRefresh.accept(())
	}
	
	func setupSubView() {
		view.addSubview(tableView)
		tableView.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
	}
	
}

