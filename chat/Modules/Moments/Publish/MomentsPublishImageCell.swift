//
//  MomentsPublishImageCell.swift
//  ug
//
//  Created by xionghx on 2019/12/23.
//  Copyright © 2019 ug. All rights reserved.
//

import UIKit

class MomentsPublishImageCell: UICollectionViewCell {

	@IBOutlet weak var itemImageView: UIImageView!
	override func awakeFromNib() {
        super.awakeFromNib()
		layer.cornerRadius = 3
		layer.masksToBounds = true
    }
	func bind(item: UIImage?) {
		if let image = item {
			itemImageView.image = image
		}
	}

}
