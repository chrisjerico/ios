//
//  MySettingVC.swift
//  ug
//
//  Created by xionghx on 2019/12/16.
//  Copyright © 2019 ug. All rights reserved.
//

import UIKit
import RxSwift

class MySettingVC: UITableViewController {
	
	@IBOutlet weak var logoutButton: UIButton!
	override func viewDidLoad() {
		super.viewDidLoad()
		logoutButton.layer.cornerRadius = 24
		logoutButton.layer.masksToBounds = true
		logoutButton.rx.tap.subscribe(onNext: { () in
			Configuration.logout()
		}).disposed(by: disposeBag)
		
		
		
	}

}
