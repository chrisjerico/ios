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
		let typeSet = [ConcernedMomentsVC.self, RedpacketGrabListVC.self]
		if typeSet.contains(where: { (type) -> Bool in
			return self.isKind(of: type)
		}) {
			
			navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
			navigationController?.navigationBar.barStyle = .black
		} else {
			navigationController?.navigationBar.setBackgroundImage(UIImage(color: .white), for: .default)
			navigationController?.navigationBar.barStyle = .default

		}
	}


}
