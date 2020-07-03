//
//  NotificationSystemMessageVC.swift
//  chat
//
//  Created by xionghx on 2020/7/3.
//  Copyright © 2020 ug. All rights reserved.
//

import UIKit
import RxRelay
import RxSwift
import RxDataSources
import RxCocoa

class NotificationSystemMessageVC: BaseVC {
	let newsList = BehaviorRelay(value: [UGNoticeModel]())
	let selectedRows = BehaviorRelay(value: [Int]())
	let shouldRefresh = BehaviorRelay(value: ())
	
	@IBOutlet weak var tableView: UITableView!
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.title = "系统通知"
		tableView.register(UINib(nibName: "NotificationSystemMessageCell", bundle: nil), forCellReuseIdentifier: "NotificationSystemMessageCell")
		tableView.mj_header = RefreshHeader()
		
		Observable.merge(tableView.mj_header.rx.refreshing.asObservable(), shouldRefresh.asObservable()).subscribe(onNext: { () in
			CMNetwork.getNoticeList(withParams: [String: Any]()) { [weak self] (result, error) in
				self?.tableView.mj_header.endRefreshing()
				CMResult<UGNoticeTypeModel>.process(withResult: result) {
					let noticeTypeModel: UGNoticeTypeModel = result?.data as! UGNoticeTypeModel
					if let noticeModel = noticeTypeModel.popup as? [UGNoticeModel] {
						self?.newsList.accept(noticeModel)
					}
					
				}
			}
		}).disposed(by: disposeBag)
		
		let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, UGNoticeModel>>(configureCell: { [weak self] arg0, arg1, arg2, arg3 in
			
			let cell = arg1.dequeueReusableCell(withIdentifier: "NotificationSystemMessageCell", for: arg2) as! NotificationSystemMessageCell
			cell.bind(model: arg3)
			if let self = self {
				cell.bind(index: arg2.section, selectedIndex: self.selectedRows)
			}
			return cell
		})
		
		newsList.map { $0.map { SectionModel(model: "", items: [$0]) } }.bind(to: tableView.rx.items(dataSource:  dataSource)).disposed(by: disposeBag)
		tableView.rx.itemSelected.subscribe(onNext: { [unowned self] (path) in
			if self.selectedRows.value.contains(path.section) {
				self.selectedRows.accept(self.selectedRows.value.filter { $0 != path.section })
			} else {
				self.selectedRows.accept(self.selectedRows.value + [path.section])
			}
			self.tableView.reloadData()
		}).disposed(by: disposeBag)
	}
}
