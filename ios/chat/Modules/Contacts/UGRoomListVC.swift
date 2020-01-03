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
import RxRelay

@objc
class UGRoomListVC: BaseVC {
	
	lazy var tableView: UITableView = {
		let tableView = UITableView()
		tableView.separatorStyle = .none
		tableView.register(RoomCell.self, forCellReuseIdentifier: "RoomCell")
		tableView.mj_header = RefreshHeader()
		return tableView
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.title = "通讯录"
		setupSubView()
		let shouldRefresh = PublishRelay<()>()
		
		Observable.merge(tableView.mj_header.rx.refreshing.asObservable(), shouldRefresh.asObservable()).flatMapLatest { _ in
			ChatAPI.rx.request(ChatTarget.roomList).mapObject(UGConversationApiDataModel.self).do(onSuccess: { [weak self] _ in
				self?.tableView.mj_header.endRefreshing()
				}, onError: {[weak self] (error) in
					self?.tableView.mj_header.endRefreshing()
					Alert.showTip(error.localizedDescription)
			}).map { $0.conversationList}
		}.retry().bind(to: tableView.rx.items) {(tableView, row, element) in
			let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell") as! RoomCell
			cell.bind(item: element)
			return cell
		}.disposed(by: disposeBag)
		
		
		
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
			make.edges.equalTo(view)
		}
	}
	
}

