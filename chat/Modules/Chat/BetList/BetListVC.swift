//
//  ShareBetSelectVC.swift
//  ug
//
//  Created by xionghx on 2019/12/10.
//  Copyright © 2019 ug. All rights reserved.
//

import Foundation
import ObjectMapper
import RxCocoa
import RxSwift
import MJRefresh

protocol BetListDelegate: NSObject {
	func betListHandleButtonTaped(with item: BetModel)
}

class BetListVC: BaseVC {
	weak var delegate: BetListDelegate?
	lazy var tableView: UITableView = {
		let tableView = UITableView()
		tableView.separatorStyle = .none
//		tableView.mj_footer = RefreshFooter()
		tableView.register(UINib(nibName: "BetListCell", bundle: nil), forCellReuseIdentifier: "BetListCell")
		return tableView
	}()
	var page = 1
	let pageSize = 20
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.title = "注单列表"
		let cancelButton = UIButton(type: .custom)
		cancelButton.setAttributedTitle("取消".mutableAttributedString().x.color(.gray).x.fontSize(16), for: .normal)
		cancelButton.rx.tap.subscribe(onNext: { [weak self] () in
			self?.navigationController?.dismiss(animated: true, completion: nil)
		}).disposed(by: disposeBag)
		let rightItem = UIBarButtonItem(customView: cancelButton)
		navigationItem.rightBarButtonItem = rightItem
		
		
		setupSubView()
	
		let dataSource = BehaviorRelay<[BetModel]>(value: [BetModel]())
		dataSource.subscribe(onNext: { [weak self] (betList) in
			guard let weakSelf = self else { return }
			if betList.count > 0 {
				weakSelf.emptyStatus.isHidden = true
			} else {
				weakSelf.emptyStatus.isHidden = false
			}
		}).disposed(by: disposeBag)
		
		ChatAPI.rx.request(ChatTarget.betList(page: page, pageSize: pageSize))
			.mapArray(BetModel.self,keyPath: "data.list")
			.subscribe(onSuccess: { [weak self] (betList) in
				guard let weakSelf = self else { return }
				if betList.count > 0 {
					dataSource.accept(betList)
					weakSelf.page += 1
				}
			}) { (error) in

				Alert.showTip(error.localizedDescription)
		}.disposed(by: disposeBag)


//		tableView.mj_footer.rx.refreshing.flatMap { [weak self] (_) -> Single<[BetModel]> in
//			guard let weakSelf = self else { return Single.create { _ in Disposables.create() }}
//			return ChatAPI.rx.request(ChatTarget.betList(page: weakSelf.page, pageSize: weakSelf.pageSize)).mapArray(BetModel.self)
//		}.subscribe(onNext: { [weak self] betlist in
//			guard let weakSelf = self else { return }
//			weakSelf.tableView.mj_footer.endRefreshing()
//
//			if betlist.count > 0 {
//				dataSource.accept(dataSource.value + betlist)
//				weakSelf.page += 1
//			} else {
//				weakSelf.tableView.mj_footer.endRefreshingWithNoMoreData()
//			}
//
//		}, onError: { [weak self] (error) in
//			guard let weakSelf = self else { return }
//			weakSelf.tableView.mj_footer.endRefreshing()
//			Alert.showTip(error.localizedDescription)
//
//		}).disposed(by: disposeBag)
//
		
		
		dataSource.bind(to: tableView.rx.items) {(tableView, row, element) in
			let cell = tableView.dequeueReusableCell(withIdentifier: "BetListCell") as! BetListCell
			cell.bind(item: element)
			cell.delegate = self
			return cell
		}.disposed(by: disposeBag)
		
		
	}
	func setupSubView() {
		view.addSubview(tableView)
		tableView.snp.makeConstraints { (make) in
			make.edges.equalTo(view)
		}
		view.addSubview(emptyStatus)
		emptyStatus.snp.makeConstraints { (make) in
			make.center.equalToSuperview()
			make.width.height.equalTo(App.width*0.6)
		}
		emptyStatus.isHidden = true

	}
	
	lazy var emptyStatus: UIImageView = {
		let imageview = UIImageView(image: UIImage(named: "kong"))
		return imageview
	}()
	
}

extension BetListVC: BetListCellDelegate {
	func betListCellHandleButtonTaped(item: BetModel) {
		guard let delegate = self.delegate else { return }
		delegate.betListHandleButtonTaped(with: item)
		navigationController?.dismiss(animated: true, completion: nil)
	}
	
}
