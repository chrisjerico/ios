//
//  FollowListVC.swift
//  chat
//
//  Created by xionghx on 2020/6/29.
//  Copyright © 2020 ug. All rights reserved.
//

import UIKit
import RxDataSources
import RxRelay
import RxSwift

class FollowListVC: BaseVC {
	
	@IBOutlet weak var tableView: UITableView!
	let dataList = BehaviorRelay(value: [MomentUserModel]())
	var page: Int = 1
	let rows: Int = 20
	let shouldRefresh = PublishRelay<()>()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.register(UINib(nibName: "FansListCell", bundle: nil), forCellReuseIdentifier: "FansListCell")
		tableView.mj_header = RefreshHeader()
		tableView.mj_footer = RefreshFooter()
		tableView.rx.setDelegate(self).disposed(by: disposeBag)
		tableView.tableFooterView = UIView()
		
		
		let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, MomentUserModel>>(configureCell: {(arg0, arg1, arg3, arg4) in
			let cell = arg1.dequeueReusableCell(withIdentifier: "FansListCell", for: arg3) as! FansListCell
			cell.bind(model: arg4)
			return cell
		})
		
		
		
		Observable.merge(tableView.mj_header.rx.refreshing.asObservable(), shouldRefresh.asObservable()).flatMap { [weak self] _ in
			return momentsAPI.rx.request(MomentsTarget.followList(page: 1, rows: 20)).mapObject(MomentUserDataModel.self).do( onError: { (error) in
				guard let weakSelf = self else { return }
				Alert.showTip("\(error)")
				weakSelf.tableView.mj_header.endRefreshing()
			})
		}.retry().subscribe(onNext: { [weak self] (data) in
			guard let weakSelf = self else { return }
			weakSelf.tableView.mj_header.endRefreshing()
			weakSelf.dataList.accept(data.list)
			weakSelf.page = 2
			Alert.hide()
		}).disposed(by: disposeBag)
		
		tableView.mj_footer.rx.refreshing.flatMap { [weak self] _ ->  Observable<MomentUserDataModel>  in
			guard let weakSelf = self else { return Observable.empty() }
			return momentsAPI.rx.request(MomentsTarget.followList(page: weakSelf.page, rows: weakSelf.rows)).asObservable().mapObject(MomentUserDataModel.self).do( onError: {  (error) in
				Alert.showTip(error.localizedDescription)
				weakSelf.tableView.mj_footer.endRefreshing()
			})
		}.retry().subscribe(onNext: { [weak self] (data) in
			guard let weakSelf = self else { return }
			if data.list.count > 0 {
				weakSelf.dataList.accept(weakSelf.dataList.value + data.list)
				weakSelf.page += 1
				weakSelf.tableView.mj_footer.endRefreshing()
				
			} else {
				weakSelf.tableView.mj_footer.endRefreshingWithNoMoreData()
			}
			
		}).disposed(by: disposeBag)
		dataList.map { [SectionModel(model: "", items: $0)]}.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
		
		shouldRefresh.accept(())
		
		
	}
}


extension FollowListVC: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 56
	}
}

