//
//  ContactsVC.swift
//  chat
//
//  Created by xionghx on 2020/1/5.
//  Copyright © 2020 ug. All rights reserved.
//

import UIKit
import ObjectMapper
import RxCocoa
import RxSwift
import RxRelay
import RxDataSources

class ContactsVC: BaseVC {
	
	@IBOutlet weak var segmentAnimationViewCenterX: NSLayoutConstraint!
	@IBOutlet weak var segmentBackDropView: UIView!
	@IBOutlet weak var segmentAnimationView: UIView!
	@IBOutlet var segmentButtons: [UIButton]!
	@IBOutlet weak var tableView: UITableView!
	let selectedIndex = BehaviorRelay(value: 0)
	override func viewDidLoad() {
		super.viewDidLoad()
		setupSubView()
		let shouldRefresh = PublishRelay<()>()
		
		let items = Observable.merge(tableView.mj_header.rx.refreshing.asObservable(), shouldRefresh.asObservable()).flatMapLatest { _ in
			ChatAPI.rx.request(ChatTarget.roomList).mapObject(UGConversationApiDataModel.self).do(onSuccess: { [weak self] _ in
				self?.tableView.mj_header.endRefreshing()
				}, onError: {[weak self] (error) in
					self?.tableView.mj_header.endRefreshing()
					Alert.showTip(error.localizedDescription)
			}).map { $0.conversationList}
		}.retry()
		
		let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, UGConversationModel>>.init(configureCell: { (ds,tv, p, item) in
			let cell = tv.dequeueReusableCell(withIdentifier: "RoomCell") as! RoomCell
			cell.bind(item: item)
			return cell
		})
		
		let sortedItems = items.map { array in
			return array.sorted { (arg0, arg1) -> Bool in
				let thisHead = ((arg0.type == 1 ? arg0.roomName : arg0.username) as NSString).x.firstPinyinHead() as String
				let thatHead = ((arg1.type == 1 ? arg1.roomName : arg1.username) as NSString).x.firstPinyinHead() as String
				return thisHead.unicodeScalars.first!.value < thatHead.unicodeScalars.first!.value
			}
		}
		
		let splitedItems = Observable.combineLatest(sortedItems, selectedIndex).map { arg in
			
			return arg.0.filter { item -> Bool in
				if arg.1 == 0 {
					return true
				} else if arg.1 == 1 {
					return item.type == 1
				} else if arg.1 == 2 {
					return item.type == 2
				} else if arg.1 == 3 {
					return item.type == 3
				}
				return true
			}.reduce([SectionModel<String, UGConversationModel>]()) { (result, model) -> [SectionModel<String, UGConversationModel>] in
				let thisHead = ((model.type == 1 ? model.roomName : model.username) as NSString).x.firstPinyinHead() as String
				guard var previous = result.last, let previousModel = previous.items.last else { return [SectionModel(model: thisHead, items: [model])] }
				let thatHead = ((previousModel.type == 1 ? previousModel.roomName : previousModel.username) as NSString).x.firstPinyinHead() as String
				var newResult = result
				
				if thisHead == thatHead {
					newResult.removeLast()
					previous.items.append(model)
					newResult.append(previous)
					return newResult
				} else {
					newResult.append(SectionModel(model: thisHead, items: [model]))
					return newResult
				}
				
			}
			
		}
		
		splitedItems.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
		
		dataSource.titleForHeaderInSection = { dataSource, index in
			return dataSource.sectionModels[index].model
		}
		
		dataSource.sectionIndexTitles = { dataSource in
			return dataSource.sectionModels.map { $0.identity }
		}
		
		tableView.rx.modelSelected(UGConversationModel.self).subscribe(onNext: { [weak self] (conversation) in
			switch conversation.chatType {
			case let .privat(uid, userName):
				self?.navigationController?.pushViewController(UGPrivateChatVC(sender: Sender(senderId: uid, displayName: userName)), animated: true)
			case .room:
				self?.navigationController?.pushViewController(UGGroupChatVC(room: Room(conversation: conversation)), animated: true)
			}
		}).disposed(by: disposeBag)
		
		
		segmentButtons.forEach { [unowned self] (button) in
			button.addTarget(self, action: #selector(segmentButtonTaped(sender:)), for: .touchUpInside)
		}
		
		segmentButtonTaped(sender: segmentButtons[0])
		
		shouldRefresh.accept(())

	}
	func setupSubView() {
		navigationItem.title = "通讯录"
		tableView.separatorStyle = .none
		tableView.register(RoomCell.self, forCellReuseIdentifier: "RoomCell")
		tableView.mj_header = RefreshHeader()
		tableView.sectionIndexColor = UIColor.x.main
		
		segmentBackDropView.layer.cornerRadius = 15
		segmentBackDropView.layer.masksToBounds = true
		segmentAnimationView.layer.cornerRadius = 15
		segmentAnimationView.layer.masksToBounds = true
		
	}
	
	@objc func segmentButtonTaped(sender: UIButton) {
		guard let index: Int = segmentButtons.firstIndex(of: sender) else { return }
		let constant = CGFloat(index) * 260.0/4.0
		segmentAnimationViewCenterX.constant = constant
		UIView.animate(withDuration: 0.1, animations: { [unowned self]  in
			self.segmentAnimationView.updateConstraintsIfNeeded()
		}) { [weak self] (completed) in
			guard completed, let weakSelf = self else { return }
			weakSelf.segmentButtons.forEach { $0.isEnabled = true }
			sender.isEnabled = false
			weakSelf.selectedIndex.accept(index)
		}
	}
}
