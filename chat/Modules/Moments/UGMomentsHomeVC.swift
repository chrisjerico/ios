//
//  UGMomentsVC.swift
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
import RxDataSources

class UGMomentsHomeVC: BaseVC {
	
	
	let disposeBag = DisposeBag()
	
	lazy var tableView: UITableView = {
		let tableView = UITableView(frame: CGRect.zero, style: .grouped)
		tableView.register(UINib(nibName: "MomentsHomeCell", bundle: nil), forCellReuseIdentifier: "MomentsHomeCell")
		tableView.separatorInset = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 0)
		tableView.sectionHeaderHeight = 10
		return tableView
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.title = "发现"
		setupSubView()
		
		tableView.rx.itemSelected.subscribe(onNext: { [unowned self] (indexPath) in
			self.tableView.deselectRow(at: indexPath, animated: true)
			switch (indexPath.section, indexPath.row) {
			case (0, 0):
				self.navigationController?.pushViewController(ConcernedMomentsVC(), animated: true)
			case (0, 1):
				self.navigationController?.pushViewController(PublicMomentsVC(), animated: true)
			case (1, 0):
				self.navigationController?.pushViewController(UGYYLotteryHomeViewController(), animated: true)
			default:
				break
			}
		})
			.disposed(by: disposeBag)
		
		let items = BehaviorRelay(value: [[("朋友圈", "#13BA74","pengyouquan"),("看一看","#FF5C66","kanyikan")],[("UG游戏大厅","#2E87FF","UGyouxidating")]])
		
		let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, (String, String, String)>>(configureCell: { (ds, tv, p, e) -> UITableViewCell in
			let cell = tv.dequeueReusableCell(withIdentifier: "MomentsHomeCell", for: p) as! MomentsHomeCell
			cell.bind(item: e)
			return cell
		})
		items.map { $0.map {SectionModel(model: "", items: $0) }  }.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
	}
	func setupSubView() {
		
		view.addSubview(tableView)
		tableView.snp.makeConstraints { (make) in
			if #available(iOS 11.0, *) {
				make.edges.equalTo(view.safeAreaLayoutGuide)
			} else {
				make.edges.equalTo(view)
			}
		}
	}
	
}
//extension UGMomentsHomeVC: UITableViewDelegate {
//	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//		return 12
//	}
//	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//		return 12
//	}
//}
