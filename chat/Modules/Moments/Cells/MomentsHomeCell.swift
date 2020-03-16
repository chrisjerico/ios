//
//  MomentsHomeCell.swift
//  ug
//
//  Created by xionghx on 2019/12/21.
//  Copyright © 2019 ug. All rights reserved.
//

import UIKit
import SVGKit

class MomentsHomeCell: UITableViewCell {
	@IBOutlet weak var itemImage: UIImageView!
	@IBOutlet weak var itemLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
		accessoryType = .disclosureIndicator
		
		
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func bind(item: (String, String, String)) {
		itemImage.image = SVGKImage(named: item.2).uiImage.withRenderingMode(.alwaysTemplate)
		itemImage.tintColor = UIColor(hex: item.1)
		itemLabel.text = item.0
	}
    
}
