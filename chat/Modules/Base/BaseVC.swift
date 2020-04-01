//
//  BaseVC.swift
//  chat
//
//  Created by xionghx on 2020/1/3.
//  Copyright © 2020 ug. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
//		let transparencyTypeSet = [ConcernedMomentsVC.self, RedpacketGrabListVC.self]
//		let blackTypeSet = [UGRealBetRecordViewController.self]
//		
//		if transparencyTypeSet.contains(where: { (type) -> Bool in return self.isKind(of: type) }) {
//			navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//			navigationController?.navigationBar.barStyle = .default
//		} else if blackTypeSet.contains(where: { (type) -> Bool in return self.isKind(of: type) }) {
//			navigationController?.navigationBar.setBackgroundImage(UIImage(color: .gray), for: .default)
//			navigationController?.navigationBar.barStyle = .default
//		} else {
//			navigationController?.navigationBar.setBackgroundImage(UIImage(color: .white), for: .default)
//			navigationController?.navigationBar.barStyle = .default
//		}
	}
	
	
}
