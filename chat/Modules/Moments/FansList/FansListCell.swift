//
//  FansListCell.swift
//  chat
//
//  Created by xionghx on 2020/6/22.
//  Copyright © 2020 ug. All rights reserved.
//

import UIKit

class FansListCell: UITableViewCell {

	@IBOutlet weak var followButton: UIButton!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var avatarImageView: UIImageView!
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func bind(model: MomentUserModel) {
		avatarImageView.kf.setImage(with: URL(string: model.avatar), placeholder: UIImage(named: "wode1"))
		nameLabel.text = model.follow_usr
		
		
	}
    
}
