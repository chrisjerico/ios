//
//  ConversationBottomView.swift
//  chat
//
//  Created by xionghx on 2020/5/29.
//  Copyright © 2020 ug. All rights reserved.
//

import UIKit

class ConversationBottomView: UIView {

	@IBOutlet weak var announcementButton: UIButton!
	@IBOutlet weak var announcementContentLabel: UILabel!
	@IBOutlet weak var announcementTimeLabel: UILabel!
	@IBOutlet weak var notificationButton: UIButton!
	@IBOutlet weak var notificationContentLabel: UILabel!
	@IBOutlet weak var notificationTimeLabel: UILabel!
	/*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
	@IBAction func announcementButtonTaped(_ sender: Any) {
		let vc = NotificationMessageVC()
		UINavigationController.current().pushViewController(vc, animated: true)
	}
	@IBAction func notificationButtonTaped(_ sender: Any) {
		
	}
	
}
