//
//  UGNavigationController.swift
//  ug
//
//  Created by xionghx on 2019/10/26.
//  Copyright © 2019 ug. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import NSObject_Rx

public class BaseNav: UGNavigationController {
	let transparentControllers = [ConcernedMomentsVC.self]
	
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		navigationBar.shadowImage = UIImage()
	}
	public override func pushViewController(_ viewController: UIViewController, animated: Bool) {
		if viewControllers.count > 0 {
			viewController.hidesBottomBarWhenPushed = true
			let backButton = UIButton(type: .custom)
			let typeSet = [ConcernedMomentsVC.self, RedpacketGrabListVC.self]
			if typeSet.contains(where: { viewController.isKind(of: $0) }) {
				backButton.setImage(UIImage(named: "nav_back_white"), for: .normal)
			} else {
				backButton.setImage(UIImage(named: "nav_back_black"), for: .normal)
			}
			
			viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
			backButton.rx.tap.subscribe(onNext: { [unowned self] () in
				self.popViewController(animated: true)
			}).disposed(by: disposeBag)
		}
		
		super.pushViewController(viewController, animated: animated)
	}

	
	
}

