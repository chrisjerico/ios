//
//  NotificationMessageVC.swift
//  chat
//
//  Created by xionghx on 2020/7/1.
//  Copyright © 2020 ug. All rights reserved.
//

import UIKit
import RxRelay
import RxSwift
import RxDataSources
import RxCocoa

class NotificationMessageVC: BaseVC {
	var page = 1
	let pageSize = 20
	let newsList = BehaviorRelay(value: [NotificationMessageModel]())
	
	@IBOutlet weak var segmentAnimationView: UIView!
	@IBOutlet weak var segmentAnimationViewCenterX: NSLayoutConstraint!
	@IBOutlet var segmentButtons: [UIButton]!
	@IBOutlet weak var tableView: UITableView!
	let selectedIndex = BehaviorRelay(value: 0)
	let selectedRows = BehaviorRelay(value: [Int]())
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.title = "平台消息"
		tableView.register(UINib(nibName: "NotificationMessageCell", bundle: nil), forCellReuseIdentifier: "NotificationMessageCell")
		tableView.mj_header = RefreshHeader()
		tableView.mj_footer = RefreshFooter()
		Observable.merge(tableView.mj_header.rx.refreshing.asObservable().map{0}, selectedIndex.asObservable()).flatMap { [weak self] (arg) in
			return ChatAPI.rx.request(ChatTarget.platformAlert(type: self?.selectedIndex.value ?? 0, page: self?.page ?? 1, pageSize: self?.pageSize ?? 20)).mapArray(NotificationMessageModel.self, keyPath: self?.selectedIndex.value == 0 ? "data": "data.list").do( onError: { (error) in
				guard let weakSelf = self else { return }
				Alert.showTip("\(error)")
				weakSelf.tableView.mj_header.endRefreshing()
			})
		}.retry().subscribe(onNext: { [weak self] (data) in
			guard let weakSelf = self else { return }
			weakSelf.tableView.mj_header.endRefreshing()
			weakSelf.newsList.accept(data)
			weakSelf.page = 2
			Alert.hide()
		}).disposed(by: disposeBag)
		
		tableView.mj_footer.rx.refreshing.flatMap { [weak self] _ -> Observable<[NotificationMessageModel]>  in
			guard let weakSelf = self else { return Observable.empty() }
			return ChatAPI.rx.request(ChatTarget.platformAlert(type: self?.selectedIndex.value ?? 0, page: self?.page ?? 1, pageSize: self?.pageSize ?? 20)).mapArray(NotificationMessageModel.self, keyPath: self?.selectedIndex.value == 0 ? "data": "data.list").asObservable().do( onError: { (error) in
				Alert.showTip(error.localizedDescription)
				weakSelf.tableView.mj_footer.endRefreshing()
			})
		}.retry().subscribe(onNext: { [weak self] (data) in
			guard let weakSelf = self else { return }
			if data.count > 0 {
				weakSelf.newsList.accept(weakSelf.newsList.value + data)
				weakSelf.page += 1
				weakSelf.tableView.mj_footer.endRefreshing()
			} else {
				weakSelf.tableView.mj_footer.endRefreshingWithNoMoreData()
			}
		}).disposed(by: disposeBag)
		
		
		let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, NotificationMessageModel>>(configureCell: { [weak self] arg0, arg1, arg2, arg3 in
			
			let cell = arg1.dequeueReusableCell(withIdentifier: "NotificationMessageCell", for: arg2) as! NotificationMessageCell
			cell.bind(model: arg3)
			if let self = self {
				cell.bind(index: arg2.section, selectedIndex: self.selectedRows)
			}
			return cell
		})
		
		newsList.map { $0.map { SectionModel(model: "", items: [$0]) } }.bind(to: tableView.rx.items(dataSource:  dataSource)).disposed(by: disposeBag)
		tableView.rx.itemSelected.subscribe(onNext: { [unowned self] (path) in
			self.selectedRows.accept(self.selectedRows.value + [path.section])
			self.tableView.reloadData()
		}).disposed(by: disposeBag)
		tableView.rx.itemDeleted.subscribe(onNext: { [unowned self] (path) in
			self.selectedRows.accept(self.selectedRows.value.filter { $0 != path.section })
			self.tableView.reloadData()

		}).disposed(by: disposeBag)
		selectedIndex.accept(0)
	}

	@IBAction func segmentButtonTaped(_ sender: UIButton) {
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
			weakSelf.page = 1
			weakSelf.selectedRows.accept([Int]())
		}
	}
	
}
