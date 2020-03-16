//
//  MomentsCellImageItem.swift
//  ug
//
//  Created by xionghx on 2019/12/25.
//  Copyright © 2019 ug. All rights reserved.
//

import UIKit

class MomentsCellImageItem: UICollectionViewCell {

	@IBOutlet weak var itemImageView: UIImageView!
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

	func bind(item: String) {
		itemImageView.kf.setImage(with: URL(string: item), placeholder: UIImage(named: "placeholder"))
		
	}
	
}
