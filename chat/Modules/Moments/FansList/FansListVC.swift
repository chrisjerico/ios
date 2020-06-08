//
//  FansListVC.swift
//  chat
//
//  Created by xionghx on 2020/5/31.
//  Copyright © 2020 ug. All rights reserved.
//

import UIKit
import RxDataSources

class FansListVC: BaseVC {
	
	@IBOutlet weak var tableView: UITableView!
	var items = [Any]()
	var page: Int = 1
	let rows: Int = 20
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.register(UINib(nibName: "FansListCell", bundle: nil), forCellReuseIdentifier: "FansListCell")
		//		tableView.mj_header = RefreshHeader()
		tableView.mj_footer = RefreshFooter()
		
		let items = tableView.mj_footer.rx.refreshing.flatMap { [unowned self] _ in momentsAPI.rx.request(MomentsTarget.followList(page: self.page, rows: self.rows)) }
		
		
		items.subscribe(onNext: { (response) in
			logger.debug(try! response.mapJSON())
		}, onError: { (error) in
			logger.debug(error.localizedDescription)
		}).disposed(by: disposeBag)
	}
}




