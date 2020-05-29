//
//  RoomCell.swift
//  ug
//
//  Created by xionghx on 2019/11/18.
//  Copyright © 2019 ug. All rights reserved.
//

import UIKit

class RoomCell: UITableViewCell {
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupSubView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	lazy var iconImage: UIImageView = {
		let imageView = UIImageView()
		
		return imageView
	}()
	
	lazy var titleLable: UILabel = {
		let label = UILabel()
		label.textColor = UIColor(white: 0.5, alpha: 1.0)
		label.font = UIFont.boldSystemFont(ofSize: 14)
		
		return label
	}()
	
	
	func setupSubView() {
		
		let lineMaker = { () -> UIView in
			let view = UIView()
			view.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
			return view
		}
		
		addSubview(iconImage)
		iconImage.snp.makeConstraints { (make) in
			make.top.equalTo(self).offset(5)
			make.width.height.equalTo(32)
			make.left.equalToSuperview().offset(15)
		}
		addSubview(titleLable)
		titleLable.snp.makeConstraints { (make) in
			make.left.equalTo(iconImage.snp.right).offset(8)
			make.centerY.equalTo(iconImage)
		}
		
		let line = lineMaker()
		addSubview(line)
		line.snp.makeConstraints { (make) in
			make.left.right.equalToSuperview()
			make.top.equalTo(iconImage.snp.bottom).offset(15)
			make.height.equalTo(0.5)
			make.bottom.equalTo(self)
		}
		
	}
	
	func bind(item: UGConversationModel) {
		switch item.chatType {
		case .room:
			titleLable.text = item.roomName
			iconImage.image = UIImage(named: "qm")
		case let .privat(_, userName):
			titleLable.text = userName
			iconImage.image = item.type == 2 ? UIImage(named: "gly") : UIImage(named: "kefu")
		}
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(false, animated: true)
	}
}
