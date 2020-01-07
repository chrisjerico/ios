//
//  MomentsHomeHeaderView.swift
//  ug
//
//  Created by xionghx on 2019/12/22.
//  Copyright © 2019 ug. All rights reserved.
//

import UIKit

class ConcernedMomentsHeaderView: UIView {

	@IBOutlet weak var userNameLabel: UILabel!
	@IBOutlet weak var avatarImageView: UIImageView!
	/*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
	
	override func awakeFromNib() {
		super.awakeFromNib()
		avatarImageView.layer.cornerRadius = 30
		avatarImageView.layer.masksToBounds = true
	}

	func bind(name: String, avatar: String) {
		userNameLabel.text = name
//		avatarImageView.image = UIImage(named: "placeholder_avatar")
		avatarImageView.kf.setImage(with: URL(string: avatar), placeholder: UIImage(named: "placeholder_avatar"))
		
	}
}
