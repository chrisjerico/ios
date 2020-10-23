//
//  MySettingVC.swift
//  ug
//
//  Created by xionghx on 2019/12/16.
//  Copyright © 2019 ug. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class MySettingVC: UITableViewController {
	
	@IBOutlet weak var logoutButton: UIButton!
	override func viewDidLoad() {
		super.viewDidLoad()
		logoutButton.layer.cornerRadius = 24
		logoutButton.layer.masksToBounds = true
		logoutButton.rx.tap.subscribe(onNext: { () in
			Configuration.logout()
		}).disposed(by: disposeBag)
				
		tableView.rx.itemSelected.filter { $0.row == 1 }.subscribe { (_) in
			if App.user.hasFundPwd {
				let vc = UIStoryboard(name: "UGSafety", bundle: nil).instantiateViewController(withIdentifier: "UGModifyPayPwdController")
				self.navigationController?.pushViewController(vc, animated: true)
			} else {
				let vc = UGgoBindViewController()
				vc.title = "绑定银行卡"
				self.navigationController?.pushViewController(vc, animated: true)
			}
		}.disposed(by: disposeBag)

		
	}

}
