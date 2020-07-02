//
//  UGConversationVC.swift
//  ug
//
//  Created by xionghx on 2019/10/21.
//  Copyright © 2019 ug. All rights reserved.
//

import UIKit
import Foundation
import SnapKit
import ObjectMapper
import RxCocoa
import RxSwift
import Moya
import RxDataSources

@objc
class UGConversationVC: BaseVC {
	let modelTop = PublishRelay<UGConversationModel>()
	let modelCancelTop = PublishRelay<UGConversationModel>()
	let modelRead = PublishRelay<UGConversationModel>()
	let modelDel = PublishRelay<UGConversationModel>()
	var notificationView: ConversationBottomView!
	
	lazy var footerView: UIView = {
		let containerView = UIView()
		containerView.frame = CGRect(x: 0, y: 0, width: App.width, height: 120)
		let view = UINib(nibName: "ConversationBottomView", bundle: nil).instantiate(withOwner: self, options: nil).first as! ConversationBottomView
		view.isHidden = true
		self.notificationView = view
		// TODO: 公告的点击事件
		view.announcementButton.rx.tap.subscribe(onNext: { () in
			
			
		}).disposed(by: self.disposeBag)
		
		// TODO: 站内信的点击事件
		view.notificationButton.rx.tap.subscribe(onNext: { () in
			
		}).disposed(by: self.disposeBag)
		
		ChatAPI.rx.request(ChatTarget.platformAlert(type: 0, page: 1, pageSize: 5)).subscribe(onSuccess: { (response) in
			logger.debug(try! response.mapString())
		}) { (error) in
			logger.debug(error.localizedDescription)
		}.disposed(by: self.disposeBag)
		
		
		//
		//				CMNetwork.getNoticeList(withParams: [String: Any]()) { (result, error) in
		//					CMResult<UGNoticeTypeModel>.process(withResult: result) {
		//						view.isHidden = false
		//						let noticeTypeModel: UGNoticeTypeModel = result?.data as! UGNoticeTypeModel
		//						if let noticeModel = noticeTypeModel.popup.first as? UGNoticeModel {
		//							view.announcementContentLabel.text = noticeModel.title
		//							view.announcementTimeLabel.text = noticeModel.addTime.components(separatedBy: " ").last
		//						}
		//						if let noticeModel = noticeTypeModel.scroll.first as? UGNoticeModel {
		//							view.notificationContentLabel.text = noticeModel.title
		//							view.notificationTimeLabel.text = noticeModel.addTime.components(separatedBy: " ").last
		//						}
		//					}
		//				}
		
		containerView.addSubview(view)
		view.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
			make.width.equalTo(App.width)
			make.height.equalTo(120)
		}
		return containerView
		
	}()
	
	lazy var tableView: UITableView = {
		let tableView = UITableView()
		tableView.separatorStyle = .none
		tableView.register(ConversationCell.self, forCellReuseIdentifier: "ConversationCell")
		tableView.mj_header = RefreshHeader()
		tableView.tableFooterView = footerView
		return tableView
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor.white
		navigationItem.title = "消息"
		setupSubView()
		
		let headerRefreshing = tableView.mj_header.rx.refreshing.asObservable().share()
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
		
		Observable.merge(headerRefreshing, shouldRefresh.map {_ in })
			.flatMap { _ in
				Observable.zip(ChatAPI.rx.request(ChatTarget.platformAlert(type: 1, page: 1, pageSize: 1)).mapArray(NotificationMessageModel.self, keyPath: "data.list").do(onError: { Alert.showTip($0.localizedDescription)}).asObservable(),
							   ChatAPI.rx.request(ChatTarget.platformAlert(type: 2, page: 1, pageSize: 1)).mapArray(NotificationMessageModel.self, keyPath: "data.list").do(onError: { Alert.showTip($0.localizedDescription)}).asObservable())
		}.retry()
			.subscribe(onNext: { [weak self] (arg) in
				guard let self = self else { return }
				if let model1 = arg.0.first, let model2 = arg.1.first {
					self.notificationView.announcementContentLabel.text = model1.title
					self.notificationView.announcementTimeLabel.text = DateFormatter(withFormat: "yyyy-MM-dd HH:mm:ss", locale: "zh-CN").date(from: model1.addTime)?.timeIntervalSince1970.x.timeTomCurrent
					self.notificationView.notificationContentLabel.text = model2.title
					self.notificationView.notificationTimeLabel.text = DateFormatter(withFormat: "yyyy-MM-dd HH:mm:ss", locale: "zh-CN").date(from: model2.addTime)?.timeIntervalSince1970.x.timeTomCurrent
					self.notificationView.isHidden = false
				} else {
					self.notificationView.isHidden = true
				}
				
			}).disposed(by: disposeBag)
		
		tableView.rx.modelSelected(UGConversationModel.self).subscribe(onNext: { [weak self] (conversation) in
			switch conversation.chatType {
			case let .privat(uid, userName):
				self?.navigationController?.pushViewController(UGPrivateChatVC(sender: Sender(senderId: uid, displayName: userName)), animated: true)
			case .room:
				self?.navigationController?.pushViewController(UGGroupChatVC(room: Room(conversation: conversation)), animated: true)
			}
		}).disposed(by: disposeBag)
		
		
		// 会话置顶
		modelTop.flatMap { $0.type == 1 ? ChatAPI.rx.request(ChatTarget.roomConversationTop(dataId: $0.roomId)): ChatAPI.rx.request(ChatTarget.privateConversationTop(dataId: $0.uid))}
			.mapBool()
			.do(onError: { (error) in
				Alert.showTip(error.localizedDescription)
				shouldRefresh.accept(())
				
			}).retry()
			.subscribe(onNext: { (success) in
				Alert.showTip("置顶成功")
				
				shouldRefresh.accept(())
				
			}).disposed(by: disposeBag)
		
		// 取消置顶
		modelCancelTop.flatMap { $0.type == 1 ? ChatAPI.rx.request(.roomConversationTopCancel(dataId: $0.roomId)): ChatAPI.rx.request(.privateConversationTopCancel(dataId: $0.uid))}
			.mapBool()
			.do(onError: { (error) in
				Alert.showTip(error.localizedDescription)
				shouldRefresh.accept(())
				
			}).retry()
			.subscribe(onNext: { (success) in
				Alert.showTip("置顶已取消")
				
				shouldRefresh.accept(())
				
			}).disposed(by: disposeBag)
		
		// 会话已读
		modelRead.flatMap { $0.type == 1 ? ChatAPI.rx.request(ChatTarget.roomConversationRead(roomId: $0.roomId)) : ChatAPI.rx.request(.privateConversationRead(targetUid: $0.uid)) }
			.mapBool()
			.do(onError: { (error) in
				Alert.showTip(error.localizedDescription)
				shouldRefresh.accept(())
				
			}).retry()
			.subscribe(onNext: { (success) in
				Alert.showTip("操作成功")
				shouldRefresh.accept(())
			}).disposed(by: disposeBag)
		
		// 会话删除
		modelDel.flatMap { conversation -> Single<Response> in
			//			MessageManager.shared.send(exit: Room(conversation: conversation))
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
		}
		.mapBool()
		.do(onError: { (error) in
			Alert.showTip(error.localizedDescription)
			shouldRefresh.accept(())
			
		}).retry()
			.subscribe(onNext: { (success) in
				Alert.showTip("会话已删除")
				shouldRefresh.accept(())
			}).disposed(by: disposeBag)
		tableView.rx.setDelegate(self).disposed(by: disposeBag)
		shouldRefresh.accept(())
		
	
	}
	
	func setupSubView() {
		view.addSubview(tableView)
		tableView.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
		
	}
	
}

extension UGConversationVC: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		guard let model: UGConversationModel = try? tableView.rx.model(at: indexPath) else {
			return UISwipeActionsConfiguration(actions: [])
		}
		var topAction: UIContextualAction
		if model.sort == 1 {
			topAction = UIContextualAction(style: UIContextualAction.Style.destructive, title: "取消置顶") { [weak self] (_, _, _) in self?.modelCancelTop.accept(model) }
		} else {
			topAction = UIContextualAction(style: UIContextualAction.Style.destructive, title: "置顶") { [weak self] (_, _, _) in self?.modelTop.accept(model) }
		}
		topAction.backgroundColor = UIColor(hex: "#6287F5")
		let readAction = UIContextualAction(style: UIContextualAction.Style.destructive, title: "已读") { [weak self] (_, _, _) in self?.modelRead.accept(model) }
		readAction.backgroundColor = UIColor(hex: "#BCC0CC")
		let delAction = UIContextualAction(style: UIContextualAction.Style.destructive, title: "删除") { [weak self] (_, _, _) in self?.modelDel.accept(model) }
		delAction.backgroundColor = UIColor(hex: "#E66262")
		return UISwipeActionsConfiguration(actions: [delAction, readAction, topAction])
	}
}
