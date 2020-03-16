//
//  MomentsCellLikesLabel.swift
//  ug
//
//  Created by xionghx on 2019/12/25.
//  Copyright © 2019 ug. All rights reserved.
//

import UIKit
import SVGKit


class MomentsCellLikesLabel: UIView {

	@IBOutlet weak var iconImageView: UIImageView!
	@IBOutlet weak var itemsLabel: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		iconImageView.image = SVGKImage(named: "xihuan").uiImage.withRenderingMode(.alwaysTemplate)
	}

	func bind(item: MomentsModel) {
		itemsLabel.text = item.like_list.map { $0.usr }.joined(separator: "、")
	}

}
